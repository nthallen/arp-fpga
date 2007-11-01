/* simeth main.c

   Basic organization:
   main() invokes xilkernel_main()
   main_main() invoked as default thread from xilkernel
   udpThread() started by main_main()
   serverAppThread() accept()s TCP connections from clients
   tcpThread() manages TCP connections after accept()
*/
#include "ssp_ad.h"
#include "ssp_intr.h"

typedef struct {
  int socket;
  struct sockaddr_in cliAddr;
} tcpThreadContext_t;

static int err_rv = 1;
sem_t udp_sem;
static struct sockaddr_in udpCliAddr;
static struct sockaddr_in udpSrvrAddr;
static int udp_port = 0;
unsigned int scan[MAX_SCAN_LENGTH + SCAN_GUARD];
int xfrEnabled = 0, app_done = 0;
int scan_xmit_length = 0, new_scan_xmit_length = 0;
static unsigned int parse_cmds( char *cmd, tcpThreadContext_t *context );
static int udpThreadCmd = 0;
#define UDPCMD_ENABLE 1
#define UDPCMD_DISABLE 2
#define UDPCMD_TRIGEXT 3
#define UDPCMD_TRIGUP 4
#define UDPCMD_TRIGDN 5
#define UDPCMD_AUTOEN 6
#define UDPCMD_AUTODA 7

int main() {
  xilkernel_main();
  // xilkernel_main() will start whatever threads are specified
  // in XPS Software Platform Settings, e.g. main_main
}

void* main_main(void* arg) {
  safe_print("In main_main\n");
  sleep(100);
  lwip_init(); // starts two more threads
  sleep(100); // msecs to finish message
  safe_print("lwIP initialized\n");
  // Cannot initialize the ethernet here because
  // Xemacif_init call lwIP's mem_malloc, which requires
  // that the thread have been registered via sys_thread_new()
  // if ( ethernet_init() ) return &err_rv;
  // xil_printf("ethernet initialized\n");
  if ( sem_init(&udp_sem, 0, 0) ) {
    safe_print( "Unable to initialize udp_sem\n" );
    return &err_rv;
  }

  sys_thread_new((void *)&udpThread, 0, 5);
    // run the UDP thread at the lowest priority for now
    // since it will run ready until we configure interrupts
  sem_wait(&udp_sem); // wait for ethernet initialization
  setup_dsp_interrupt();
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
  safe_print("ethernet initialized\n");
  
  SPI_system_init();
  AD9510_Init();
  
  sem_post(&udp_sem);

  udp_socket = socket(AF_INET,SOCK_DGRAM,0);
  if ( udp_socket < 0 ) {
    safe_print("cannot open udp socket\n");
    return &err_rv;
  }

  /* bind any port */
  udpCliAddr.sin_family = AF_INET;
  udpCliAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  udpCliAddr.sin_port = htons(0);

  /* We'll leave configuration of the udpSrvrAddr to the tcpThread */
  rc = bind(udp_socket, (struct sockaddr *) &udpCliAddr, sizeof(udpCliAddr));
  if ( rc<0 ) {
    safe_print("cannot bind UDP port\n");
    return &err_rv;
  }
  safe_print("udp_thread: UDP bound, awaiting semaphore\n");
  for (;;) {
    int i; // for overrun check at the bottom
    int status;
    unsigned int words_read, scan_size;

    // safe_print("udp_thread: waiting\n");
    if ( sem_wait( &udp_sem ) ) {
      print_mutex_lock();
      xil_printf("Error %d from sem_wait() in udpThread\n", errno );
      print_mutex_unlock();
      return &err_rv;
    }
    // safe_print("udp_thread: awake\n");
    for (;;) {
      if ( udpThreadCmd ) {
        switch (udpThreadCmd) {
          case UDPCMD_ENABLE:
            xfr_init();
            xfr_enable();
            safe_print("Enabled\n");
            break;
          case UDPCMD_DISABLE:
            xfr_disable();
            safe_print("Disabled\n");
            break;
          case UDPCMD_TRIGEXT:
            set_trigger_src( SSP_TRIG_EXTERNAL );
            safe_print("External\n");
            break;
          case UDPCMD_TRIGUP:
            set_trigger_src( SSP_TRIG_LEVEL_UP );
            safe_print("Rising\n");
            break;
                case UDPCMD_TRIGDN:
            set_trigger_src( SSP_TRIG_LEVEL_DN );
            safe_print("Falling\n");
            break;
          case UDPCMD_AUTOEN:
            set_trigger_mode( 1 );
            safe_print("Auto Enabled\n");
            break;
          case UDPCMD_AUTODA:
            set_trigger_mode( 0 );
            safe_print("Auto Disabled\n");
            break;
          default:
            safe_print("Invalid UDPCMD\n");
            break;
        }
        udpThreadCmd = 0;
      }

      words_read = ssp_read_fifo( scan, scan_xmit_length+1 );
      if ( words_read == 0 ) break;
      if ( words_read < scan_xmit_length+1 ) {
        print_mutex_lock();
        xil_printf("Short packet received: %d/%d\n", words_read, scan_xmit_length+1 );
        print_mutex_unlock();
      } else {
        scan_size = (scan_xmit_length+1) * sizeof(unsigned int);
        // safe_print("udp_Thread: Pre-sendto\n");
        rc = sendto(udp_socket, scan, scan_size, 0, 
          (struct sockaddr *) &udpSrvrAddr, 
          sizeof(udpSrvrAddr));
        // safe_print("udp_Thread: Post-sendto\n");
        if ( rc<0 ) {
          print_mutex_lock();
          xil_printf( "udpThread: cannot send data: %d\n", errno);
          print_mutex_unlock();
          return &err_rv;
        }
        sleep(100);
      }
    }
    for ( i = MAX_SCAN_LENGTH; i < MAX_SCAN_LENGTH+SCAN_GUARD; i++ ) {
      if ( scan[i] ) {
        print_mutex_lock();
        xil_printf("Overrun: scan[%d] = %d\n", i, scan[i]);
        print_mutex_unlock();
        break;
      }
    }
  }
}
  
void *serverAppThread(void *arg) {
   struct sockaddr_in servAddr, cliAddr;
   int tcp_socket, new_sock;
   tcpThreadContext_t *tcpThreadContext;

   /* create socket */
   tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
   if(tcp_socket<0) {
     safe_print("serverAppThread: cannot open tcp_socket\n");
     return &err_rv;
  }

  /* bind server port */
  servAddr.sin_family = AF_INET;
  servAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  servAddr.sin_port = htons(SSP_SERVER_PORT);
  
  if ( bind(tcp_socket, (struct sockaddr *) &servAddr, sizeof(servAddr))<0) {
    safe_print("serverAppThread: cannot bind port\n");
    return &err_rv;
  }

  if ( listen(tcp_socket,5) < 0 ) {
    safe_print("serverAppThread: listen failed\n");
    return &err_rv;
  }

  safe_print("serverAppThread: entering main loop\n");
  while(1) {
    int cliLen = sizeof(cliAddr);
    new_sock = accept(tcp_socket, (struct sockaddr *)&cliAddr, &cliLen);
    if ( new_sock<0 ) {
      safe_print("serverAppThread: cannot accept connection\n");
      return &err_rv;
    }
    safe_print("serverAppThread: accepted connection\n");
    // This must be handled more robustly. Only one UDP client
    // can be supported at a time, but we probably need to allow
    // us to hijack the connection if we lose one for some reason
    tcpThreadContext = mem_malloc(sizeof(tcpThreadContext_t));
    if ( tcpThreadContext == 0 ) {
      safe_print("memory allocation failure\n");
    } else {
      // Spawn a new thread to handle the data for the new connection
      // The example gave lower priorities as more connections
      // are made.
      memcpy((char *)&tcpThreadContext->cliAddr, (char *)&cliAddr, cliLen );
      tcpThreadContext->socket = new_sock;
      sys_thread_new((void *)&tcpThread, (void *)tcpThreadContext, 4);
    }
  }    
}
  
static char rcv_msg[SSP_MAX_MSG+1];

void *tcpThread( void *context ) {
  tcpThreadContext_t *tcpThreadContext =
    (tcpThreadContext_t *)context;
  int my_sock = tcpThreadContext->socket;
  int n;
  int done = 0;
  
  while (!done) {
    n = recv(my_sock, rcv_msg, SSP_MAX_MSG, 0);
    print_mutex_lock();
    xil_printf("tcpThread: received %d bytes\n", n);
    print_mutex_unlock();
    if ( n <= 0 ) break;
    if ( n > SSP_MAX_MSG ) {
      safe_print("tcpThread: recv overflow!\n");
      break;
    }
    if ( n > 0 ) {
      unsigned int rv;
      rcv_msg[n] = '\0';
      rv = parse_cmds(rcv_msg, tcpThreadContext);
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
  close(my_sock);
  safe_print("tcpThread: socket closed, exiting thread\n");
  // xfr_disable();
  mem_free(tcpThreadContext);
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
        safe_print("ERROR: netif_add(): Out of memory for default netif\n\r");
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
    safe_print("netif_added\n");
    netif_set_default(server_netif);
    sleep(100);
    safe_print("default added\n");
    
    // Register the XEMAC interrupt handler with the controller and enable
    // interrupts within XMK
    register_int_handler(EMAC_INTERRUPT_ID,
                         (XInterruptHandler)XEmac_IntrHandlerFifo,
                         xemacif_ptr->instance_ptr);
    enable_interrupt(EMAC_INTERRUPT_ID);
    sleep(100);
    safe_print("interrupt enabled\n");
    return 0;
}

/* check_fifo_status( int status, char *where );
 * if status is non-zero, reports and error
 * returns status
 */
int check_fifo_status( int status, char *where ) {
  if ( status ) {
        print_mutex_lock();
    xil_printf("ERROR: status = %d while %s\n", status, where );
    print_mutex_unlock();
  }
  return status;
}

static int enq_udpcmd( int cmdcode ) {
  if (udpThreadCmd) return 503;
  udpThreadCmd = cmdcode;
  sem_post(&udp_sem);
  return 200;
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
    TE Trigger External
    TU:[-]xxxxx Level Trigger Rising
    TD:[-]xxxxx Level Trigger Falling
    AE Autotrig Enable
    AD Autotrig Disable
    RS Return Status
  Return Values:
    200 OK
    410 Gone (successful response to EX)
    500 Bad
    503 Busy (Service Unavailable)
*/
static unsigned int parse_cmds( char *cmd, tcpThreadContext_t *tcpThreadContext ) {
  if ( cmd[0] == 'E' ) {
    if ( cmd[1] == 'N' ) {
      if (!udp_port) {
        safe_print("xfr_enable: udp_port not initialized\n");
        return 400;
      }
      memcpy((char *)&udpSrvrAddr, (char *)&tcpThreadContext->cliAddr,
        sizeof(struct sockaddr_in) );
      udpSrvrAddr.sin_port = htons(udp_port);
      return enq_udpcmd( UDPCMD_ENABLE );
      // xfr_init();
      // xfr_enable();
      // return 200;
    } else if ( cmd[1] == 'X' ) {
      app_done = 1;
      safe_print("Received Exit\n");
      return 410;
    }
  } else if ( cmd[0] == 'D' ) {
    if ( cmd[1] == 'A' ) {
      return enq_udpcmd( UDPCMD_DISABLE );
      // safe_print("xfr_disable\n");
      // xfr_disable();
      // return 200;
    }
  } else if ( cmd[0] == 'U' && cmd[1] == 'P' && cmd[2] == ':' ) {
    udp_port = atoi(cmd+3);
    print_mutex_lock();
    xil_printf("tcpThread: Setting UDP port to %d\n", udp_port );
    print_mutex_unlock();
    return 200;
  } else if ( cmd[0] == 'N' && cmd[1] == 'S' && cmd[2] == ':' ) {
    new_scan_xmit_length = atoi(cmd+3);
    if ( new_scan_xmit_length > 4000 ) {
      print_mutex_lock();
      xil_printf("tcpThread: scan length request too large: %d\n",
        new_scan_xmit_length );
      print_mutex_unlock();
      new_scan_xmit_length = 0;
      return 400;
    } else {
      print_mutex_lock();
      xil_printf("tcpThread: Setting scan_xmit_length to %d\n",
        new_scan_xmit_length );
      print_mutex_unlock();
      return 200;
    }
  } else if ( cmd[0] == 'T' ) {
    if ( cmd[1] == 'E' ) return enq_udpcmd( UDPCMD_TRIGEXT );
    else if ( ( cmd[1] == 'U' || cmd[1] == 'D' ) && cmd[2] == ':' ) {
      TriggerLevel = atoi(cmd+3);
      return enq_udpcmd( cmd[1] == 'U' ? UDPCMD_TRIGUP : UDPCMD_TRIGDN );
    }
  } else if ( cmd[0] == 'A' ) {
    if ( cmd[1] == 'E' ) return enq_udpcmd( UDPCMD_AUTOEN );
    if ( cmd[1] == 'D' ) return enq_udpcmd( UDPCMD_AUTODA );
  }
  return 500;
}
