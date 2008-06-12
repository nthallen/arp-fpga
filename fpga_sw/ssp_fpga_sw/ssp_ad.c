/* simeth main.c

   Basic organization:
   main() invokes xilkernel_main()
   main_main() invoked as default thread from xilkernel
   udpThread() started by main_main()
   serverAppThread() accept()s TCP connections from clients
   tcpThread() manages TCP connections after accept()
*/
#include "ssp_intr.h"
#include "errno.h"
#include "mb_interface.h"
#include "ad9510_if.h"
#include "sys/process.h"

typedef struct {
  int socket;
  struct sockaddr_in cliAddr;
} tcpThreadContext_t;

static int err_rv = 1;
sem_t udp_sem, tcp_sem, cfg_sem;
static struct sockaddr_in udpCliAddr;
static struct sockaddr_in udpSrvrAddr;
unsigned int scan[SSP_MAX_SCAN_LENGTH + SCAN_GUARD + 1];
int xfrEnabled = 0, app_done = 0;
unsigned int scan_xmit_length, words_read;
static unsigned int parse_cmds( char *cmd, tcpThreadContext_t *context );

#define UDPCMD_ENABLE 1
#define UDPCMD_DISABLE 2
#define UDPCMD_TRIGGER 3

ssp_config_t ssp_config;

int main(void) {
  microblaze_init_icache_range(0, XPAR_MICROBLAZE_0_CACHE_BYTE_SIZE);
  microblaze_enable_icache();
  microblaze_init_dcache_range(0, XPAR_MICROBLAZE_0_DCACHE_BYTE_SIZE);
  microblaze_enable_dcache();
  xilkernel_main();
  // xilkernel_main() will start whatever threads are specified
  // in XPS Software Platform Settings, e.g. main_main
  return 0;
}

void* main_main(void* arg) {
  extern void lwip_init();
  safe_print("\r\n\r\nSSP System Software V1.0\n");
  sleep(100);
  lwip_init(); // starts two more threads
  sleep(100); // msecs to finish message
  //safe_print("lwIP initialized\n");
  // Cannot initialize the ethernet here because
  // Xemacif_init call lwIP's mem_malloc, which requires
  // that the thread have been registered via sys_thread_new()
  // if ( ethernet_init() ) return &err_rv;
  // xil_printf("ethernet initialized\n");
  if ( sem_init(&udp_sem, 0, 0) ) {
    safe_print( "Unable to initialize udp_sem\n" );
    return &err_rv;
  }
  if ( sem_init(&tcp_sem, 0, 0) ) {
    safe_print( "Unable to initialize tcp_sem\n" );
    return &err_rv;
  }
  /* cfg_sem could be a mutex. */
  if ( sem_init(&cfg_sem, 0, 0) ) {
    safe_print( "Unable to initialize cfg_sem\n" );
    return &err_rv;
  }
  sem_post( &cfg_sem ); // unlock the semaphore
  
  // Initialize the ssp_config as necessary
  ssp_config.NF = 1;

  sys_thread_new((void *)&udpThread, 0, 5);
    // run the UDP thread at the lowest priority for now
    // since it will run ready until we configure interrupts
  sem_wait(&udp_sem); // wait for ethernet initialization
  sleep(100);
  
  sys_thread_new((void *)&serverAppThread, 0, 1);
  // serverAppThread(0);
  // Since this is the end of the main_main() thread, we should
  // be able to simply call the serverAppThread and save the
  // thread create/destroy overhead. Unfortunately, lwip needs
  // to keep separate track of the threads.
  return &err_rv;
}

int sendfrags( int udp_socket, int *bfr, int total_size, int flags,
        struct sockaddr *to, socklen_t tolen ) {
  int rc, bytes_remaining, word_offset = 0;
  int frag_size, frag_words;
  static unsigned long serial_number = 0;
  
  serial_number = (serial_number + 0x10000L) & 0x3FFF0000;
  bytes_remaining = total_size;
  while ( bytes_remaining ) {
  	int tmp_hdr;
    frag_size = (bytes_remaining > MAX_FRAG_PAYLOAD) ?
      MAX_FRAG_PAYLOAD : bytes_remaining;
    bytes_remaining -= frag_size;
    tmp_hdr = SSP_FRAG_FLAG | serial_number | word_offset |
      (bytes_remaining ? 0 : SSP_LAST_FRAG_FLAG);
    { unsigned char *fr = (unsigned char *)&tmp_hdr;
    	unsigned char *to = (unsigned char *)bfr;
    	to[3] = fr[0];
    	to[2] = fr[1];
    	to[1] = fr[2];
    	to[0] = fr[3];
    }
    frag_words = frag_size/sizeof(int);
    word_offset += frag_words;
    rc = sendto( udp_socket, bfr, frag_size + sizeof(int), flags, to, tolen );
    bfr += frag_words;
    if ( rc < 0 ) break;
  }
  return rc;
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
  //int transfers = 0;

  if ( ethernet_init() ) return &err_rv;
  //safe_print("ethernet initialized\n");
  
  SPI_system_init();
  AD9510_Init( 0, 1 );
  
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
    //int status;

    // safe_print("udp_thread: waiting\n");
    if ( sem_wait( &udp_sem ) ) {
    	/* We never expect this to happen and know of no way to recover */
      print_mutex_lock();
      safe_printf(("Error %d from sem_wait() in udpThread\r\n", errno ));
      print_mutex_unlock();
      return &err_rv;
    }
    if ( ssp_config.CC != UDPCMD_ENABLE ) {
    	ssp_config.RV = 500; /* Invalid command at this time */
    	sem_post( &tcp_sem );
    } else {
    	int enabled = 1;
    	int n_channels;
	    unsigned int scan_xmit_length, words_remaining, words_read;
	    unsigned int scan_size;

    	if ( ssp_config.NE < 1 || ssp_config.NE > 7 ) {
    		safe_print("Invalid NE configuration\n");
    		ssp_config.NE = 1;
    	}
    	if ( ssp_config.NS > SSP_MAX_SAMPLES ) {
    		safe_print("NS exceeds SSP_MAX_SAMPLES\n");
    		ssp_config.NS = SSP_MAX_SAMPLES;
    	}
    	xfr_enable();
    	ssp_config.EN = 1;
    	ssp_config.RV = 200; /* OK */
    	sem_post( &tcp_sem );
    	safe_print("Enabled\n");
    	// Setup data transfer area (don't have to do this before enabling circuit
    	// because we are the thread that reads in the data)
    	// Need a buffer that holds 7+SSP_MAX_CHANNELS*SSP_MAX_SAMPLES words
    	switch ( ssp_config.NE ) {
    		case 1:
    		case 2:
    		case 4:
    			n_channels = 1;
    			break;
    		case 3:
    		case 5:
    		case 6:
    			n_channels = 2;
    			break;
    		case 7:
    			n_channels = 3;
    			break;
    		default:
    			safe_print("Cannot happen\n");
    			break;
    	}
    	scan_xmit_length = 7 + n_channels * ssp_config.NS;
    	words_remaining = scan_xmit_length;
    	words_read = 0;
    	scan_size = scan_xmit_length * sizeof(int);

	    while ( enabled ) {
	    	unsigned int nw;
	    	
	    	if ( sem_trywait( &udp_sem ) ) {
	    		// No command waiting: Look for data
	    		if ( errno != EAGAIN ) {
	    			safe_print("Error from sem_trywait\n");
	    		}
	    		nw = ssp_read_fifo( &scan[words_read+1], words_remaining );
	    		if ( nw == 0 ) {
	    			sleep(100);
	    			// yield();
	    		} else if ( words_remaining == nw ) {
            if ( scan_size > MAX_UDP_PAYLOAD )
              rc = sendfrags(udp_socket, scan, scan_size, 0, 
		          (struct sockaddr *) &udpSrvrAddr, 
		          sizeof(udpSrvrAddr));
            else
  		        rc = sendto(udp_socket, &scan[1], scan_size, 0, 
  		          (struct sockaddr *) &udpSrvrAddr, 
  		          sizeof(udpSrvrAddr));
		        if ( rc<0 ) {
		          print_mutex_lock();
		          safe_printf(( "udpThread: cannot send data: %d\r\n", errno));
		          print_mutex_unlock();
		          return &err_rv;
		        }
		        words_read = 0;
		        words_remaining = scan_xmit_length;
	    		} else {
	    			words_read += nw;
	    			words_remaining -= nw;
	    		}
	    	} else {
	    		// We have received a command from tcpThread
	        ssp_config.RV = 200;
	        switch (ssp_config.CC) {
	          case UDPCMD_DISABLE:
	            xfr_disable();
	            ssp_config.EN = 0;
	            safe_print("Disabled\n");
	            enabled = 0;
	            break;
	          case UDPCMD_TRIGGER:
	            set_trigger( );
	            safe_print("Trigger Reconfigured\n");
	            break;
	          default:
	            safe_print("Invalid UDPCMD\n");
	            ssp_config.RV = 500;
	            break;
	        }
	        sem_post( &tcp_sem );
	      }
	    }
	    for ( i = SSP_MAX_SCAN_LENGTH; i < SSP_MAX_SCAN_LENGTH+SCAN_GUARD; i++ ) {
	      if ( scan[i] ) {
	        print_mutex_lock();
	        safe_printf(("Overrun: scan[%d] = %d\r\n", i, scan[i]));
	        print_mutex_unlock();
	        break;
	      }
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
      sys_thread_new((void *)&tcpThread, (void *)tcpThreadContext, 1);
    }
  }    
}
  
static char rcv_msg[SSP_MAX_CTRL_MSG+1];

void *tcpThread( void *context ) {
  tcpThreadContext_t *tcpThreadContext =
    (tcpThreadContext_t *)context;
  int my_sock = tcpThreadContext->socket;
  int n;
  int done = 0;
  
  while (!done) {
    n = recv(my_sock, rcv_msg, SSP_MAX_CTRL_MSG, 0);
    rcv_msg[n] = '\0';
    print_mutex_lock();
    safe_printf(("tcpThread: received %d bytes: %s", n, rcv_msg));
    print_mutex_unlock();
    if ( n > SSP_MAX_CTRL_MSG ) {
      safe_print("tcpThread: recv overflow!\n");
      break;
    } else if ( n <= 0 ) break;
    else {
      unsigned int rv;
      rcv_msg[n] = '\0';
      sem_wait( &cfg_sem ); // lock the semaphore
      rv = parse_cmds(rcv_msg, tcpThreadContext);
      sem_post( &cfg_sem ); // unlock it
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

static void define_ip4addr( struct ip_addr *dest, int a, int b, int c, int d ) {
  IP4_ADDR( dest, a, b, c, d );
}

int ethernet_init(void) {
    struct ip_addr ipaddr, netmask, gateway;
    struct netif *server_netif;
    unsigned char mac_addr[] = { SSP_MAC_ADDRESS };
    sleep(100);
    define_ip4addr(&ipaddr, SSP_IP_ADDRESS );
    define_ip4addr(&netmask, SSP_IP_NETMASK );
    define_ip4addr(&gateway, SSP_IP_GATEWAY );
    
    // Set up the lwIP network interface
    print_mutex_lock();
    safe_printf(("MAC Address: %02x:%02x:%02x:%02x:%02x:%02x\r\n", SSP_MAC_ADDRESS ));
    safe_printf(("IP Address: %d.%d.%d.%d\r\n", SSP_IP_ADDRESS ));
    safe_printf(("IP Netmask: %d.%d.%d.%d\r\n", SSP_IP_NETMASK ));
    safe_printf(("IP Gateway: %d.%d.%d.%d\r\n", SSP_IP_GATEWAY ));
    print_mutex_unlock();
    
    // Allocate and configure the server's netif
    server_netif = malloc(sizeof(struct netif)); 
    if (server_netif == NULL) {
        safe_print("ERROR: netif_add(): Out of memory for default netif\n\r");
        return 1;
    }
    xemac_add(server_netif, &ipaddr, &netmask, &gateway,
              mac_addr, EMAC_BASEADDR );
    sleep(100);
    //safe_print("netif_added\n");
    netif_set_default(server_netif);
    sleep(100);
    //safe_print("default added\n");

  	/* specify that the network if is up */
  	netif_set_up(server_netif);

  	/* start packet receive thread - required for lwIP operation */
  	sys_thread_new((void *)&xemacif_input_thread, server_netif, 1);

    return 0;
}

/* check_fifo_status( int status, char *where );
 * if status is non-zero, reports and error
 * returns status
 */
int check_fifo_status( int status, char *where ) {
  if ( status ) {
    print_mutex_lock();
    safe_printf(("ERROR: status = %d while %s\r\n", status, where ));
    print_mutex_unlock();
  }
  return status;
}

static int enq_udpcmd( int cmdcode ) {
  ssp_config.CC = cmdcode;
  sem_post(&udp_sem);
  sem_wait(&tcp_sem);
  return ssp_config.RV;
}

static unsigned int limit_range( char *var, unsigned int val,
   unsigned int low, unsigned int high ) {
  if ( val < low ) {
  	val = low;
    print_mutex_lock();
    safe_printf(("Value for '%s' too low: using %d\r\n", var, val ));
    print_mutex_unlock();
  } else if ( val > high ) {
  	val = high;
    print_mutex_lock();
    safe_printf(("Value for '%s' too high: using %d\r\n", var, val ));
    print_mutex_unlock();
  }
  return val;
}

/*
  Currently we support one command per line/packet. All commands with
  numerical arguments begin with 'N'. The parser supports a minus
  sign in the number, but negative values are out of range for many
  commands.
  
  We hold the cfg_sem, so we can examine and make changes to ssp_config
  with impunity.
  
  Commands:
    EN Enable
    EX Quit
    DA Disable
    NS:xxxx N_Samples
    NA:xxxx N_Average (Pre-Adder)
    NC:xxxx N_Coadd
    NF:xx      Frequency Divisor
    NP:xxxxx UDP Port Number
    NE:x 1-7 bit-mapped
    NU:[-]xxxxx Level Trigger Rising
    ND:[-]xxxxx Level Trigger Falling
    NT:x (0-3)
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
    	if (ssp_config.EN) return(503); // busy
      if (!ssp_config.NP) {
        safe_print("xfr_enable: udp_port not initialized\n");
        return 400;
      }
      memcpy((char *)&udpSrvrAddr, (char *)&tcpThreadContext->cliAddr,
        sizeof(struct sockaddr_in) );
      udpSrvrAddr.sin_port = htons(ssp_config.NP);
      return enq_udpcmd( UDPCMD_ENABLE );
    } else if ( cmd[1] == 'X' ) {
    	if (ssp_config.EN) return(503); // busy
      app_done = 1;
      safe_print("Received Exit\n");
      return 410;
    }
  } else if ( cmd[0] == 'D' ) {
    if ( cmd[1] == 'A' ) {
    	if ( ssp_config.EN )
	      return enq_udpcmd( UDPCMD_DISABLE );
	    return 200;
    }
  } else if ( cmd[0] == 'N' && cmd[2] == ':' ) {
  	unsigned int newval = atoi(cmd+3);
  	
  	// None of the 'N' commands are legal when enabled
 		if (ssp_config.EN) return 503;
 		switch ( cmd[1] ) {
 			case 'S':
	  		ssp_config.NS = limit_range( "NS", newval, 1, SSP_MAX_SAMPLES );
	  		break;
  		case 'A':
	  		ssp_config.NA = limit_range( "NA", newval, 1, SSP_MAX_PREADD );
	  		break;
  		case 'C':
	  		ssp_config.NC = limit_range( "NC", newval, 1, SSP_MAX_COADD );
	  		break;
  		case 'P':
		    ssp_config.NP = newval;
		    break;
	    case 'E':
	  		ssp_config.NE = limit_range( "NE", newval, 1, SSP_MAX_NE );
	  		break;
      case 'F':
        ssp_config.NF = limit_range( "NF", newval, 1, 32 );
        break;
  		default:
	  		safe_print("tcpThread: unrecognized N command\n");
	  		return 400;
 		}
  	return 200;
  } else if ( cmd[0] == 'T' ) {
    if ( cmd[1] == 'S' && cmd[2] == ':' ) {
    	int val = limit_range( "TS", atoi(cmd+3), 0, SSP_TRIG_SRC_MAX );
    	ssp_config.TrigConfig =
    		(ssp_config.TrigConfig & ~SSP_TRIG_SRC_MASK) |
    		(val << SSP_TRIG_SRC_LSB);
      return ssp_config.EN ? enq_udpcmd( UDPCMD_TRIGGER ) : 200;
    } else if ( ( cmd[1] == 'U' || cmd[1] == 'D' ) && cmd[2] == ':' ) {
      ssp_config.TL = atoi(cmd+3);
      if ( cmd[1] == 'U' ) ssp_config.TrigConfig |= SSP_TRIG_RISING;
      else ssp_config.TrigConfig &= ~SSP_TRIG_RISING;
      return ssp_config.EN ? enq_udpcmd( UDPCMD_TRIGGER ) : 200;
    }
  } else if ( cmd[0] == 'A' ) {
    if ( cmd[1] == 'E' ) ssp_config.TrigConfig |= SSP_TRIG_AE;
    else if ( cmd[1] == 'D' ) ssp_config.TrigConfig &= ~ SSP_TRIG_AE;
    else return 500;
    return ssp_config.EN ? enq_udpcmd( UDPCMD_TRIGGER ) : 200;
  }
  return 500;
}
