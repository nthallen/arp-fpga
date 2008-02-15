/* hello.c

   Basic organization:
   main() invokes xilkernel_main()
   main_main() invoked as default thread from xilkernel
   serverAppThread() accept()s TCP connections from clients
   tcpThread() manages TCP connections after accept()
   
   Which benchmark is configured depends on which of the
   following symbols is defined to be non-zero
   HELLO:
     listens on 10.0.0.200 port 1500
     loops reading records and writing "Hello, World"
   BENCHMARK_TCP:
     listens on 10.0.0.200 port 1500
     loops reading record containing <nbytes> <nrecords>
     then writes <nrecords> of <nbytes> each
     
     On the other end, this can be used to write a benchmark
     app that records timing information.
   BENCHMARK_UDP:
     listens on 10.0.0.200 port 1500
     loops reading record containing:
       U <udp port>
         Sets destination udp port
       <nbytes> <nrecords>
         writes <nrecords> of <nbytes> each to previously
         defined udp port
*/
#include "xmk.h"
#include "mb_interface.h"
#include "lwip/tcpip.h"
#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "xparameters.h"
#include <stddef.h>
#include <string.h>

#ifdef STDOUT_BASEADDRESS
  extern int print_mutex_lock(void);
  extern void print_mutex_unlock(void);
  extern void safe_print( char *text );
  #define safe_printf(x) xil_printf x
#else
  #define print_mutex_lock()
  #define print_mutex_unlock()
  #define safe_print(x)
  #define safe_printf(x)
#endif


#define EMAC_INTERRUPT_ID XPAR_XPS_INTC_0_ETHERNET_MAC_IP2INTC_IRPT_INTR
#define EMAC_BASEADDR XPAR_EMACLITE_0_BASEADDR
#define IP_ADDRESS(x) IP4_ADDR(x, 10, 0, 0, 200)
#define IP_NETMASK(x) IP4_ADDR(x, 255, 255, 255, 0)
#define IP_GATEWAY(x) IP4_ADDR(x, 10, 0, 0, 1)
#define SSP_SERVER_PORT 1500
#define SSP_MAX_MSG 80
extern void *serverAppThread(void *arg);
extern void *tcpThread( void *context );
/* Define one of the following to be non-zero: */
#define HELLO 0
#define BENCHMARK_TCP 0
#define BENCHMARK_UDP 1

static int err_rv = 1;

typedef struct {
  int socket;
  struct sockaddr_in cliAddr;
} tcpThreadContext_t;

int main() {
  microblaze_init_icache_range(0, XPAR_MICROBLAZE_0_CACHE_BYTE_SIZE);
  microblaze_enable_icache();
  microblaze_init_dcache_range(0, XPAR_MICROBLAZE_0_DCACHE_BYTE_SIZE);
  microblaze_enable_dcache();
  xilkernel_main();
  // xilkernel_main() will start whatever threads are specified
  // in XPS Software Platform Settings, e.g. main_main
}

void* main_main(void* arg) {
  safe_print("In main_main\n");
  sleep(100);
  lwip_init();
  sleep(100); // msecs to finish message
  safe_print("lwIP initialized\n");
  // Cannot initialize the ethernet here because
  // Xemacif_init call lwIP's mem_malloc, which requires
  // that the thread have been registered via sys_thread_new()
  //We'll do it in the serverAppThread()
  // if ( ethernet_init() ) return &err_rv;
  // xil_printf("ethernet initialized\n");
  
  sys_thread_new((void *)&serverAppThread, 0, 2);
  // serverAppThread(0);
  // Since this is the end of the main_main() thread, we should
  // be able to simply call the serverAppThread and save the
  // thread create/destroy overhead, but lwip needs
  // to keep separate track of the threads.
}
  
void *serverAppThread(void *arg) {
   struct sockaddr_in servAddr, cliAddr;
   int tcp_socket, new_sock;
   tcpThreadContext_t *tcpThreadContext;

  if ( ethernet_init() ) return &err_rv;
  safe_print("ethernet initialized\n");

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

    tcpThreadContext = mem_malloc(sizeof(tcpThreadContext_t));
    if ( tcpThreadContext == 0 ) {
      safe_print("memory allocation failure\n");
    } else {
      // Spawn a new thread to handle the data for the new connection
      memcpy((char *)&tcpThreadContext->cliAddr, (char *)&cliAddr, cliLen );
      tcpThreadContext->socket = new_sock;
      sys_thread_new((void *)&tcpThread, (void *)tcpThreadContext, 4);
    }
  }    
}
  
static char rcv_msg[SSP_MAX_MSG+1];

#if HELLO
  #define TCP_SERVER(x,y) hello_server(x)

	void hello_server( int my_sock ) {
	  for (;;) {
	    int n;
	    unsigned int rv;
	
	    n = recv(my_sock, rcv_msg, SSP_MAX_MSG, 0);
	    print_mutex_lock();
	    safe_printf(("tcpThread: received %d bytes\n", n));
	    print_mutex_unlock();
	    if ( n == 0 ) break;
	    rv = send( my_sock, "Hello, World\n\r", 14, 0 );
	    print_mutex_lock();
	    safe_printf(("tcpThread: send(HelloWorld) returned %d\n", rv ));
	    print_mutex_unlock();
	  }
	}
#endif

#if BENCHMARK_TCP
  #define TCP_SERVER(x,y) bench_tcp_server(x)

    /* Returns non-zero on error */
    int parse_int( char **buf, int *n ) {
    	char *s = *buf;
    	int rv = 0;
    	while (isspace(*s)) s++;
    	if ( isdigit(*s) ) {
	    	while (isdigit(*s)) rv = rv*10 + *s++ - '0';
	    	*buf = s;
	    	*n = rv;
	    	return 0;
    	} else return 1;
    }
    
    /* On error, *nb and *nr are both set to zero and an error is printed. */
	void parse_msg( char *buf, int *nb, int *nr ) {
		char *s = buf;
		if ( parse_int( &s, nb ) || parse_int( &s, nr ) ) {
			safe_print("parse_msg: Error parsing input\n");
			*nb = 0;
			*nr = 0;
		}
	}
	
	void bench_tcp_server( int my_sock ) {
	  for (;;) {
	    int n, nb, nr, i;
	    unsigned int rv;
	    char *sbuf;
	
	    n = recv(my_sock, rcv_msg, SSP_MAX_MSG, 0);
	    print_mutex_lock();
	    safe_printf(("bench_tcp: received %d bytes\n", n));
	    print_mutex_unlock();
	    if ( n == 0 ) break;
	    parse_msg( rcv_msg, &nb, &nr );
	    if (nb > 0) {
	    	sbuf = mem_malloc(nb);
	    	if ( sbuf == 0 ) {
	    		safe_print("bench_tcp_server: mem_malloc failed\n");
	    	}
	    } else sbuf = 0;
    	if ( sbuf == 0 ) {
    		rv = send( my_sock, "500\n\r", 5, 0 );
    		continue;
    	}
    	for (i == 0; i < nb; i++) {
    		sbuf[i] = i & 0xff;
    	}
 	    print_mutex_lock();
	    safe_printf(("bench_tcp: running nb=%d nr=%d\n", nb, nr));
	    print_mutex_unlock();
    	
    	for (i = 0; i < nr; i++) {
		    rv = send( my_sock, sbuf, nb, 0 );
		    if ( rv != nb ) {
			    print_mutex_lock();
			    safe_printf(("tcpThread: send(%d) returned %d\n", nb, rv ));
			    print_mutex_unlock();
		    }
    	}
    	mem_free(sbuf);
    	safe_print("tcpThread: Finished run\n");
	  }
	}
#endif

#if BENCHMARK_UDP
  #define TCP_SERVER(x,y) bench_udp_server(x,y)

    /* Returns non-zero on error */
    int parse_int( char **buf, int *n ) {
    	char *s = *buf;
    	int rv = 0;
    	while (isspace(*s)) s++;
    	if ( isdigit(*s) ) {
	    	while (isdigit(*s)) rv = rv*10 + *s++ - '0';
	    	*buf = s;
	    	*n = rv;
	    	return 0;
    	} else return 1;
    }
    
    /* On error, *nb and *nr are both set to zero and an error is printed. */
	void parse_msg( char *buf, int *nb, int *nr ) {
		char *s = buf;
		if ( parse_int( &s, nb ) || parse_int( &s, nr ) ) {
			safe_print("parse_msg: Error parsing input\n");
			*nb = 0;
			*nr = 0;
		}
	}
	
	void bench_udp_server( int my_sock, tcpThreadContext_t *tcpThreadContext ) {
	  int udp_socket, rc, udp_port = 0;
      struct sockaddr_in udpCliAddr;
      struct sockaddr_in udpSrvrAddr;
	  
	  udp_socket = socket(AF_INET,SOCK_DGRAM,0);
	  if ( udp_socket < 0 ) {
	    safe_print("bench_udp_server: cannot open udp socket\n");
	    return;
	  }
	
	  /* bind any port */
	  udpCliAddr.sin_family = AF_INET;
	  udpCliAddr.sin_addr.s_addr = htonl(INADDR_ANY);
	  udpCliAddr.sin_port = htons(0);
	
	  /* We'll leave configuration of the udpSrvrAddr to the tcpThread */
	  rc = bind(udp_socket, (struct sockaddr *) &udpCliAddr, sizeof(udpCliAddr));
	  if ( rc<0 ) {
	    safe_print("bench_udp_server: cannot bind UDP port\n");
	    return;
	  }
	  safe_print("bench_udp_server: UDP bound\n");

	  for (;;) {
	    int n, nb, nr, i;
	    unsigned int rv;
	    char *sbuf;
	
	    n = recv(my_sock, rcv_msg, SSP_MAX_MSG, 0);
	    print_mutex_lock();
	    safe_printf(("bench_udp_server: received %d bytes\n", n));
	    print_mutex_unlock();
	    if ( n == 0 ) break;
	    if ( rcv_msg[0] == 'U' ) {
	      sbuf = rcv_msg+1;
	      parse_int( &sbuf, &udp_port );
	      print_mutex_lock();
	      safe_printf(("Setting UDP port to %d\n", udp_port));
	      print_mutex_unlock();
	      rv = send(my_sock, "200\n\r", 5, 0 );
	      memcpy((char *)&udpSrvrAddr, (char *)&tcpThreadContext->cliAddr,
	        sizeof(struct sockaddr_in) );
	      udpSrvrAddr.sin_port = htons(udp_port);
	    } else {
		    parse_msg( rcv_msg, &nb, &nr );
		    if (nb > 0) {
		    	sbuf = mem_malloc(nb);
		    	if ( sbuf == 0 ) {
		    		safe_print("bench_udp_server: mem_malloc failed\n");
		    	}
		    } else sbuf = 0;
	    	if ( sbuf == 0 ) {
	    		rv = send( my_sock, "500\n\r", 5, 0 );
	    		continue;
	    	}
	    	if ( udp_port == 0 ) {
	    		safe_print("bench_udp_server: UDP port not defined\n");
	    		rv = send( my_sock, "500\n\r", 5, 0 );
	    		return;
	    	}
	    	for (i = 0; i < nb; i++) {
	    		sbuf[i] = i & 0xff;
	    	}
	 	    print_mutex_lock();
		    safe_printf(("bench_udp: running nb=%d nr=%d\n", nb, nr));
		    print_mutex_unlock();
    		rv = send( my_sock, "200\n\r", 5, 0 );
//		    sleep(1000);
//		    safe_print("bench_udp: done sleeping\n" );
	    	
	    	for (i = 0; i < nr; i++) {
		        rc = sendto(udp_socket, sbuf, nb, 0, 
		          (struct sockaddr *) &udpSrvrAddr, 
		          sizeof(udpSrvrAddr));
			    if ( rc < 0 ) {
			    	safe_print("bench_udp_server: Failed to send\n");
			    }
	    	}
	    	mem_free(sbuf);
	    	safe_print("tcpThread: Finished run\n");
	    }
	  }
	  close(udp_socket);
	}
#endif

void *tcpThread( void *context ) {
  tcpThreadContext_t *tcpThreadContext =
    (tcpThreadContext_t *)context;
  int my_sock = tcpThreadContext->socket;
  TCP_SERVER( my_sock, tcpThreadContext );
  close(my_sock);
  safe_print("tcpThread: socket closed, exiting thread\n");
  mem_free(tcpThreadContext);
  return &err_rv;
}

int ethernet_init(void) {
    struct ip_addr ipaddr, netmask, gateway;
    struct netif *server_netif;
    unsigned char mac_addr[] = { 0,0xA,0x35,0x55,0x55,0x55};
    sleep(100);
    IP_ADDRESS(&ipaddr);
    IP_NETMASK(&netmask);
    IP_GATEWAY(&gateway);
    
    // Set up the lwIP network interface
    // Allocate and configure the server's netif
    server_netif = mem_malloc(sizeof(struct netif)); 
    if (server_netif == NULL) {
        safe_print("ERROR: netif_add(): Out of memory for default netif\n\r");
        return 1;
    }
    xemac_add(server_netif, &ipaddr, &netmask, &gateway,
              mac_addr, EMAC_BASEADDR );
    sleep(100);
    safe_print("netif_added\n");
    netif_set_default(server_netif);
    sleep(100);
    safe_print("default added\n");

  	/* specify that the network if is up */
  	netif_set_up(server_netif);

  	/* start packet receive thread - required for lwIP operation */
  	sys_thread_new((void *)&xemacif_input_thread, server_netif, 5);
    
    return 0;
}
