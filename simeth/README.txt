Simeth: Test project using Sysgen generated scan
to test ethernet throughput.

Notes on use LwIP with Xilkernel
  Software Platform Settings
    xilkernel
	    sysintc_spec => opb_intc_0
	    config_sema => true
	    max_sem => 40 [40 is enough for the current config. 20 is not enough]
	    config_time => true
	    config_sched => true
	      sched_type => SCHED_PRIO
	    config_pthread_support => true
	      static_pthread_table => ((main_main, 0))
	      pthread_stack_size => 8000
	    systmr_spec->systmr_dev => opb_timer_1
	  LwIP
	    emac_instances  ((Ethernet_MAC, 0, 0xA, 0x35, 0x55, 0x55, 0x55))
	      (or whatever, using the Xilinx numbers without authorization)
	    api_mode SOCKETS_API
	    All other options current defaulted

Lessons Learned:
  Threads that are going to interact with LwIP need to be created via
  sys_thread_new(), which sets up additional data structures, rather
  than going directly to pthread_create(). Specifically, this means that
  main_main() cannot do anything directly with LwIP, and must be limited
  to starting up other threads that will do the real work. I was tempted
  to initialize the ethernet interface in main_main() before starting up
  the tcp and upd threads, but netif_add() attempts to allocate memory
  using mem_malloc(), which needs to run in a thread known to LwIP (hence
  created by sys_thread_new()) so ethernet_init() was moved into the
  tcpThread().
  
LwIP Thread Usage

  lwip_init {
    spawns a thread to run lwip_init_proper
      invokes tcpip_init
	spawns a thread to handle tcpip
      spawns thread to handle packets
    waits for lwip_init_proper to complete

  Net result is 2 additional threads. It looks like lwip_init could
  simply call lwip_init_proper and avoid one thread create/destroy.
  [Probably not, since lwip_init is called from main_main()'s thread.]

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
