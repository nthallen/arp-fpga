/* simeth main.c

   Basic organization:
   main() invokes xilkernel_main()
   main_main() invoked as default thread from xilkernel
   udpThread() started by main_main()
   serverAppThread() accept()s TCP connections from clients
   tcpThread() manages TCP connections after accept()
*/
#include "simeth.h"
#include "simeth_intr.h"

static int err_rv = 1;
sem_t udp_sem;
static struct sockaddr_in udpCliAddr;
static struct sockaddr_in udpSrvrAddr;
static int udp_port = 0;
unsigned int scan[MAX_SCAN_LENGTH + SCAN_GUARD];
int xfrEnabled = 0, app_done = 0;
int scan_xmit_length = 0;
static unsigned int parse_cmds( char *cmd );

int main() {
  xilkernel_main();
  // xilkernel_main() will start whatever threads are specified
  // in XPS Software Platform Settings, e.g. main_main
}

void* main_main(void* arg) {
  lwip_init(); // starts two more threads
  sleep(100); // msecs to finish message
  xil_printf("lwIP initialized\n");
  // Cannot initialize the ethernet here because
  // Xemacif_init call lwIP's mem_malloc, which requires
  // that the thread have been registered via sys_thread_new()
  // if ( ethernet_init() ) return &err_rv;
  // xil_printf("ethernet initialized\n");
  if ( sem_init(&udp_sem, 0, 0) ) {
    xil_printf( "Unable to initialize udp_sem\n" );
    return &err_rv;
  }

  sys_thread_new((void *)&udpThread, 0, 8);
    // run the UDP thread at the lowest priority for now
    // since it will run ready until we configure interrupts
  sem_wait(&udp_sem); // wait for ethernet initialization
  setup_interrupt();
  sleep(100);
  
  sys_thread_new((void *)&serverAppThread, 0, 1);
  // serverAppThread(0);
  // Since this is the end of the main_main() thread, we should
  // be able to simply call the serverAppThread and save the
  // thread create/destroy overhead. Unfortunately, lwip needs
  // to keep separate track of the threads.
}
  
// udpThread() is responsible for fetching data from the FSL
// and forwarding it to the UDP destination. Currently this is
// a ready loop, but eventually it might await a message from
// an ISR. It would be nice to know when we no longer need to
// watch for incoming data. For the first pass, we can probably
// stop when we get the disable message, but in the future we
// might want to get another signal from the hardware.
void *udpThread(void *arg) {
  // set up the udp socket
  int udp_socket, rc;
  // int cur_N_skipped;
  int transfers = 0;

  if ( ethernet_init() ) return &err_rv;
  xil_printf("ethernet initialized\n");
  sem_post(&udp_sem);

  udp_socket = socket(AF_INET,SOCK_DGRAM,0);
  if ( udp_socket < 0 ) {
    xil_printf("cannot open udp socket\n");
    return &err_rv;
  }

  /* bind any port */
  udpCliAddr.sin_family = AF_INET;
  udpCliAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  udpCliAddr.sin_port = htons(0);

  /* We'll leave configuration of the udpSrvrAddr to the tcpThread */
  rc = bind(udp_socket, (struct sockaddr *) &udpCliAddr, sizeof(udpCliAddr));
  if ( rc<0 ) {
    xil_printf("cannot bind UDP port\n");
    return &err_rv;
  }
  xil_printf("udp_thread: UDP bound, awaiting semaphore\n");
  for (;;) {
    int i; // for overrun check at the bottom
    int status;
    int words_read, scan_size;

    if ( sem_wait( &udp_sem ) ) {
      xil_printf("Error %d from sem_wait() in udpThread\n", errno );
      return &err_rv;
    }
      
//    words_read = scan_gen_sm_0_ArrayRead(SCAN_GEN_SM_0_SRCSIGNAL,
//         SCAN_GEN_SM_0_SRCSIGNAL_DOUT,
//         scan_xmit_length+1, scan);
    words_read = scan_gen_read_fifo( scan, scan_xmit_length+1 );
    if ( words_read < scan_xmit_length+1 ) {
      xil_printf("Short packet received: %d/%d\n", words_read, scan_xmit_length+1 );
    } else {
      scan_size = (scan_xmit_length+1) * sizeof(unsigned int);
      rc = sendto(udp_socket, scan, scan_size, 0, 
        (struct sockaddr *) &udpSrvrAddr, 
        sizeof(udpSrvrAddr));
      if ( rc<0 ) {
        xil_printf( "udpThread: cannot send data: %d\n", errno);
        return &err_rv;
      }
    }
    for ( i = MAX_SCAN_LENGTH; i < MAX_SCAN_LENGTH+SCAN_GUARD; i++ ) {
      if ( scan[i] ) {
        xil_printf("Overrun: scan[%d] = %d\n", i, scan[i]);
        break;
      }
    }
  }
}
  
void *serverAppThread(void *arg) {
   struct sockaddr_in servAddr, cliAddr;
   int tcp_socket, new_sock;

   /* create socket */
   tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
   if(tcp_socket<0) {
     xil_printf("serverAppThread: cannot open tcp_socket\n");
     return &err_rv;
  }

  /* bind server port */
  servAddr.sin_family = AF_INET;
  servAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  servAddr.sin_port = htons(SSP_SERVER_PORT);
  
  if ( bind(tcp_socket, (struct sockaddr *) &servAddr, sizeof(servAddr))<0) {
    xil_printf("serverAppThread: cannot bind port\n");
    return &err_rv;
  }

  if ( listen(tcp_socket,5) < 0 ) {
    xil_printf("serverAppThread: listen failed\n");
    return &err_rv;
  }

  xil_printf("serverAppThread: entering main loop\n");
  while(1) {
    int cliLen = sizeof(cliAddr);
    new_sock = accept(tcp_socket, (struct sockaddr *)&cliAddr, &cliLen);
    if ( new_sock<0 ) {
      xil_printf("serverAppThread: cannot accept connection\n");
      return &err_rv;
    }
    xil_printf("serverAppThread: accepted connection\n");
    // This must be handled more robustly. Only one UDP client
    // can be supported at a time, but we probably need to allow
    // us to hijack the connection if we lose one for some reason
    memcpy((char *)&udpSrvrAddr, (char *)&cliAddr, cliLen );
    // Spawn a new thread to handle the data for the new connection
    // The example gave lower priorities as more connections
    // are made.
    sys_thread_new((void *)&tcpThread, &new_sock, 4);
  }    
}
  
static char rcv_msg[SSP_MAX_MSG+1];

void *tcpThread( void *socketptr ) {
  int my_sock = *(int *)socketptr;
  int n;
  int done = 0;
  
  while (!done) {
    n = recv(my_sock, rcv_msg, SSP_MAX_MSG, 0);
    // xil_printf("tcpThread: received %d bytes\n", n);
    if ( n <= 0 ) break;
    if ( n > SSP_MAX_MSG ) {
      xil_printf("tcpThread: recv overflow!\n");
      break;
    }
    if ( n > 0 ) {
      unsigned int rv;
      rcv_msg[n] = '\0';
      rv = parse_cmds(rcv_msg);
      if ( rv == 410 ) done = 1;
      rcv_msg[7] = '\0';
      rcv_msg[6] = '\n';
      rcv_msg[5] = '\r';
      rcv_msg[4] = rv%10 + '0';
      rv /= 10;
      n = 4;
      while ( rv ) {
        ++n;
        rcv_msg[8-n] = rv%10+'0';
        rv /= 10;
      }
      rv = send( my_sock, rcv_msg+8-n, n, 0 );
    }
  }
  xil_printf("tcpThread: exiting thread\n");
  close(my_sock);
  xfr_disable();
  return &err_rv;
}

int ethernet_init(void) {
    struct ip_addr ipaddr, netmask, gateway;
    struct netif *server_netif;
    sleep(100);
    XEmacIf_Config *xemacif_ptr = &XEmacIf_ConfigTable[0];
    IP4_ADDR(&ipaddr, 10, 0, 0, 200 );
    IP4_ADDR(&netmask, 255, 255, 255, 0 );
    IP4_ADDR(&gateway, 10, 0, 0, 1 );
    
    // Set up the lwIP network interface
    // Allocate and configure the server's netif
    server_netif = mem_malloc(sizeof(struct netif)); 
    if (server_netif == NULL) {
        xil_printf("ERROR: netif_add(): Out of memory for default netif\n\r");
        return 1;
    }
    server_netif = netif_add(server_netif,
                             &ipaddr,
                             &netmask,
                             &gateway,
                             &XEmacIf_ConfigTable[0],
                             xemacif_init,
                             tcpip_input);
    sleep(100);
    xil_printf("netif_added\n");
    netif_set_default(server_netif);
    sleep(100);
    xil_printf("default added\n");
    
    // Register the XEMAC interrupt handler with the controller and enable
    // interrupts within XMK
    register_int_handler(EMAC_INTERRUPT_ID,
                         (XInterruptHandler)XEmac_IntrHandlerFifo,
                         xemacif_ptr->instance_ptr);
    enable_interrupt(EMAC_INTERRUPT_ID);
    sleep(100);
    xil_printf("interrupt enabled\n");
    return 0;
}

void check_fifo_status( int status, char *where ) {
  if ( status ) {
    xil_printf("ERROR: status = %d while %s\n", status, where );
  }
}

/*
  get_data
    Opens a UDP socket for receiving data
    Opens TCP command connection to SSP board
    Issues the configuration command, informing the SSP board
      what UDP port to send data to
    Reads some quantity of data from the UDP port
    Issues the stop command

  Commands:
    EN Enable
    DA Disable
    EX Quit
    NS:xxxx N_Samples
    NC:xxxx N_Coadd
    UP:xxxxx UDP Port Number
    RS Return Status
  Return Values:
    200 OK
    410 Gone (successful response to EX)
    500 Bad
*/
static unsigned int parse_cmds( char *cmd ) {
  if ( cmd[0] == 'E' ) {
    if ( cmd[1] == 'N' ) {
      if (!udp_port) {
        xil_printf("xfr_enable: udp_port not initialized\n");
        return 400;
      }
      udpSrvrAddr.sin_port = htons(udp_port);
      xfr_init();
      xfr_enable();
      return 200;
    } else if ( cmd[1] == 'X' ) {
      app_done = 1;
      xil_printf("Received Exit\n");
      return 410;
    }
  } else if ( cmd[0] == 'D' ) {
    if ( cmd[1] == 'A' ) {
      xfr_disable();
      // sleep(200);
      return 200;
    }
  } else if ( cmd[0] == 'U' && cmd[1] == 'P' && cmd[2] == ':' ) {
    udp_port = atoi(cmd+3);
    xil_printf("tcpThread: Setting UDP port to %d\n", udp_port );
    return 200;
  } else if ( cmd[0] == 'N' && cmd[1] == 'S' && cmd[2] == ':' ) {
    scan_xmit_length = atoi(cmd+3);
    if ( scan_xmit_length > 4000 ) {
      xil_printf("tcpThread: scan length request too large: %d\n",
        scan_xmit_length );
      scan_xmit_length = 0;
      return 400;
    } else {
      xil_printf("tcpThread: Setting scan_xmit_length to %d\n",
        scan_xmit_length );
      return 200;
    }
  }
  return 500;
}
