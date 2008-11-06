#include "config.h"
#include "ssp_print.h"
#include "ssp_status.h"
#include "ssp_eeprom.h"


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

SSP_Config_t SSP_Config;

static void print_config( SSP_Config_t *cfg, char *heading ) {
  print_mutex_lock();
  safe_printf(("%s\r\n", heading));
  safe_printf(("  n_bytes: %d\r\n", cfg->hdr.n_bytes ));
  safe_printf(("  checksum: %04X\r\n", cfg->hdr.checksum ));
  safe_printf(("  cfg version: %d\r\n", cfg->version ));
  safe_printf(("  Board S/N: %d\r\n", cfg->serial ));
  safe_printf(("  Fab Date: %d/%d/%d\r\n", cfg->fab_year,
                  cfg->fab_mon, cfg->fab_day ));
  safe_printf(("  Cfg Date: %d/%d/%d\r\n", cfg->cfg_year,
                  cfg->cfg_mon, cfg->cfg_day ));
  safe_printf(("  Notes: %s\r\n", cfg->notes ));
  safe_printf(("  mac_address: %02X:%02X:%02X:%02X:%02X:%02X\r\n",
    cfg->mac_address[0],
    cfg->mac_address[1],
    cfg->mac_address[2],
    cfg->mac_address[3],
    cfg->mac_address[4],
    cfg->mac_address[5] ));
  safe_printf(("  ip_address: %d.%d.%d.%d\r\n",
    cfg->ip_address[0],
    cfg->ip_address[1],
    cfg->ip_address[2],
    cfg->ip_address[3] ));
  safe_printf(("  ip_netmask: %d.%d.%d.%d\r\n",
    cfg->ip_netmask[0],
    cfg->ip_netmask[1],
    cfg->ip_netmask[2],
    cfg->ip_netmask[3] ));
  safe_printf(("  ip_gateway: %d.%d.%d.%d\r\n\r\n",
    cfg->ip_gateway[0],
    cfg->ip_gateway[1],
    cfg->ip_gateway[2],
    cfg->ip_gateway[3] ));
  print_mutex_unlock();
}

void* main_main(void* arg) {
  int rv;
  extern void lwip_init();
  status_init();
  EE_Init();
  rv = EE_ReadConfig(&SSP_Config);
  if ( rv != 0 ) EE_DefaultConfig(&SSP_Config);
  status_set( rv==0, "\001\004" );
  safe_print(("\r\n\r\nSSP Configuration Software V1.0\r\n"));
  print_config(&SSP_Config, rv==0 ? "Configuration loaded successfully:\r\n" :
            "Existing configuration invalid or unreadable:\r\n");
  
  sleep(100);
  lwip_init(); // starts two more threads
  sleep(100); // msecs to finish message
  // Cannot initialize the ethernet here because
  // Xemacif_init call lwIP's mem_malloc, which requires
  // that the thread have been registered via sys_thread_new()
  // if ( ethernet_init() ) return &err_rv;
  // xil_printf("ethernet initialized\n");
  
  sys_thread_new((void *)&serverAppThread, 0, 1);

  return 0;
}
 
typedef struct {
  int socket;
} tcpThreadContext_t;
 
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
  servAddr.sin_port = htons(80);
  
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
      tcpThreadContext->socket = new_sock;
      sys_thread_new((void *)&tcpThread, (void *)tcpThreadContext, 1);
    }
  }    
}
  
void *tcpThread( void *context ) {
  tcpThreadContext_t *tcpThreadContext =
    (tcpThreadContext_t *)context;
  char rcv_msg[SSP_MAX_CTRL_MSG+1];
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
