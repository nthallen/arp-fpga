Simeth: Test project using Sysgen generated scan
to test ethernet throughput.

Notes on use LwIP with Xilkernel

LwIP Thread Usage

  lwip_init {
    spawns a thread to run lwip_init_proper
      invokes tcpip_init
	spawns a thread to handle tcpip
      spawns thread to handle packets
    waits for lwip_init_proper to complete

  Net result is 2 additional threads. It looks like lwip_init could
  simply call lwip_init_proper and avoid one thread create/destroy.

  In any event, after calling lwip_init, there are two new threads,
  one for tcpip, one for packets.

Synchronicity

  Reads can be made non-blocking via two mechanisms:
  
    u32_t val = 1;
    lwip_ioctl( s, FIONBIO, &val );
    
  or
  
    n = recv( s, buf, len, MSG_DONTWAIT);
  
  or
  
    n = recvfrom( s, buf, len, MSG_DONTWAIT, from, fromlen );
  
  accept() is always blocking, but it's easy enough to use your
  own threads to work around that.

  send() appears to be always blocking.

Basic Application Layout

  main() {
    xilkernel_main();
    // xilkernel_main() will start whatever threads are specified
    // in XPS Software Platform Settings, e.g. main_main
  }
  
  main_main() {
    lwip_init(); // starts two more threads
      // can wait for initialization messages to pass before
      // printing our own messages
    sys_thread_new((void *)&udpThread, 0, 8);
      // run the UDP thread at the lowest priority for now
      // since it will run ready until we configure interrupts
    sys_thread_new((void *)&serverAppThread, 0, 1);
    // Since this is the end of the main_main() thread, we should
    // be able to simply call the serverAppThread and save the
    // thread create/destroy overhead.
  }
  
  // udpThread() is responsible for fetching data from the FSL
  // and forwarding it to the UDP destination. Currently this is
  // a ready loop, but eventually it might await a message from
  // an ISR. It would be nice to know when we no longer need to
  // watch for incoming data. For the first pass, we can probably
  // stop when we get the disable message, but in the future we
  // might want to get another signal from the hardware.
  udpThread() {
    // set up the udp socket
    for (;;) {
      // wait for an enable message from the serverAppThread
      // set up udp destination port
      for (;;) {
	// check for incoming message
	// check for data on FSL
	if ( whole packet received ) {
	  send();
	  if ( !enabled ) break;
	}
      }
    }
  }
  
  serverAppThread() {
    // Configure the ethernet interface
    // Register the interrupt handler
    sock = socket();
    listen(sock, 4);
    while(1) {
      size = sizeof(remote);
      new_sock = accept(sock, (struct sockaddr *)&remote, &size);
      // Spawn a new thread to handle the data for the new connection
      // The example gave lower priorities as more connections
      // are made.
      sys_thread_new((void *)&tcpThread, &new_sock, 4);
    }    
  }
  
  tcpThread( socket ) {
    // Receive and interpret requests from client
    // Enable/Disable Acquisition
    // Set Options
  }
