#include "SSP_Config.h"
#include "malloc.h"
#include "lwip/mem.h"
#include "lwip/netif.h"
#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "ssp_print.h"
#include "ssp_status.h"
#include "ssp_eeprom.h"
#include "http.h"

static thread_return_t serverAppThread(void *arg);
static thread_return_t tcpThread( void *context );

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
net_config_t cfg_opts[N_CFG_OPTS] = {
  { { 0,0xA,0x35,0x55,0x55,0x55 },
    { 10, 0, 0, 200 },
    { 255, 255, 255, 0 },
    { 10, 0, 0, 1 } },
  { { 0,0xA,0x35,0x55,0x55,0x56 },
    { 10, 0, 0, 201 },
    { 255, 255, 255, 0 },
    { 10, 0, 0, 1 } },
  { { 0,0xA,0x35,0x55,0x55,0x57 },
    { 10, 0, 0, 202 },
    { 255, 255, 255, 0 },
    { 10, 0, 0, 1 } },
  { { 0,0xA,0x35,0x55,0x55,0x58 },
    { 192, 168, 0, 200 },
    { 255, 255, 255, 0 },
    { 192, 168, 0, 1 } },
  { { 0,0xA,0x35,0x55,0x55,0x59 },
    { 192, 168, 0, 201 },
    { 255, 255, 255, 0 },
    { 192, 168, 0, 1 } }
};

thread_return_t main_main(void* arg) {
  int rv;
  extern void lwip_init();
  status_init();
  EE_Init();
  rv = EE_ReadConfig(&SSP_Config);
  if ( rv != 0 ) EE_DefaultConfig(&SSP_Config);
  status_set( rv==0, "\001\004" );
  safe_print(("\r\n\r\nSSP Configuration Software V1.0\r\n"));
  EE_print_config(&SSP_Config, rv==0 ?
        "Configuration loaded successfully:\r\n" :
        "Existing configuration invalid or unreadable:\r\n");
  if ( fields_init() )
    report_error( "fields_init: out of memory", "\002\003\004" );
  if ( fields_update(&SSP_Config) )
    report_error( "fields_update", "\002\003\005" );
  
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

static void define_ip4addr( struct ip_addr *dest, int a, int b, int c, int d ) {
  IP4_ADDR( dest, a, b, c, d );
}

static int ethernet_init(net_config_t *cfg) {
  uint8_t *mac_addr, *ip_addr;
  uint8_t *ip_netmask, *ip_gateway;
  struct ip_addr ipaddr, netmask, gateway;
  struct netif *server_netif;

  mac_addr = cfg->mac_address;
  ip_addr = cfg->ip_address;
  ip_netmask = cfg->ip_netmask;
  ip_gateway = cfg->ip_gateway;
  sleep(100);
  define_ip4addr(&ipaddr, ip_addr[0], ip_addr[1], ip_addr[2], ip_addr[3] );
  define_ip4addr(&netmask, ip_netmask[0], ip_netmask[1], ip_netmask[2], ip_netmask[3] );
  define_ip4addr(&gateway, ip_gateway[0], ip_gateway[1], ip_gateway[2], ip_gateway[3] );
  
  // Set up the lwIP network interface
  print_mutex_lock();
  safe_printf(("\r\nMAC Address: %02x:%02x:%02x:%02x:%02x:%02x\r\n",
    mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5] ));
  safe_printf(("IP Address: %d.%d.%d.%d\r\n",
    ip_addr[0], ip_addr[1], ip_addr[2], ip_addr[3] ));
  safe_printf(("IP Netmask: %d.%d.%d.%d\r\n",
    ip_netmask[0], ip_netmask[1], ip_netmask[2], ip_netmask[3] ));
  safe_printf(("IP Gateway: %d.%d.%d.%d\r\n",
    ip_gateway[0], ip_gateway[1], ip_gateway[2], ip_gateway[3] ));
  print_mutex_unlock();
  
  // Allocate and configure the server's netif
  server_netif = mem_malloc(sizeof(struct netif)); 
  if (server_netif == NULL) {
    report_error("ethernet_init: Out of memory", "\001\007");
    return 1;
  }
  if ( xemac_add(server_netif, &ipaddr, &netmask, &gateway,
            mac_addr, EMAC_BASEADDR ) == NULL ) {
    report_error("ethernet_init: xemac_add failed", "\001\007\001");
    return 1;
  }
  sleep(100);
  //safe_print("netif_added\n");
  netif_set_default(server_netif);
  sleep(100);
  //safe_print("default added\n");

  /* specify that the network if is up */
  netif_set_up(server_netif);

  /* start packet receive thread - required for lwIP operation */
  sys_thread_new((void *)&xemacif_input_thread, server_netif, 5);

  return 0;
}
 
typedef struct {
  int socket;
  char *recv_buf;
  char *send_buf;
} tcpThreadContext_t;
 
static thread_return_t serverAppThread(void *arg) {
  struct sockaddr_in servAddr, cliAddr;
  int tcp_socket, new_sock;
  tcpThreadContext_t *tcpThreadContext;
  net_config_t *cfg;
  int cfg_opt = read_jp1();

  if ( cfg_opt < N_CFG_OPTS ) cfg = &cfg_opts[cfg_opt];
  else if ( cfg_opt == 15 ) cfg = &SSP_Config.net_cfg;
  else return( (thread_return_t) report_error( "serverAppThread: Bad configuration option", "\002\001" ));
  ethernet_init(cfg);
  
  /* create socket */
  tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
  if (tcp_socket<0)
    return (thread_return_t) report_error( "serverAppThread: cannot open tcp_socket",
      "\002\001\002" );

  /* bind server port */
  servAddr.sin_family = AF_INET;
  servAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  servAddr.sin_port = htons(80);
  
  if ( bind(tcp_socket, (struct sockaddr *) &servAddr, sizeof(servAddr))<0)
    return (thread_return_t) report_error(
      "serverAppThread: cannot bind port", "\002\001\003" );

  if ( listen(tcp_socket,5) < 0 )
    return (thread_return_t) report_error(
      "serverAppThread: listen failed", "\002\001\004" );

  safe_print("serverAppThread: entering main loop\n");
  while(1) {
    int cliLen = sizeof(cliAddr);
    new_sock = accept(tcp_socket, (struct sockaddr *)&cliAddr, &cliLen);
    if ( new_sock<0 )
      return (thread_return_t) report_error(
        "serverAppThread: cannot accept connection", "\002\001\005" );
    safe_print("serverAppThread: accepted connection\n");
    tcpThreadContext = mem_malloc(sizeof(tcpThreadContext_t));
    if ( tcpThreadContext == 0 ) {
      report_error( "serverAppThread: memory allocation failure", "\002\001\006" );
      close(new_sock);
    } else {
      tcpThreadContext->socket = new_sock;
      tcpThreadContext->recv_buf = mem_malloc(RECV_BUFFER_LENGTH);
      tcpThreadContext->send_buf = mem_malloc(SEND_BUFFER_LENGTH);
      if ( tcpThreadContext->recv_buf == 0 ||
           tcpThreadContext->send_buf == 0) {
      	report_error( "serverAppThread: buffer allocation failure", "\002\001\007" );
      	close(new_sock);
        if ( tcpThreadContext->recv_buf != 0 )
          mem_free( tcpThreadContext->recv_buf );
        if ( tcpThreadContext->send_buf != 0 )
          mem_free( tcpThreadContext->send_buf );
      	mem_free(tcpThreadContext);
      }
      sys_thread_new((void *)&tcpThread, (void *)tcpThreadContext, 1);
    }
  }    
}
  
static thread_return_t tcpThread( void *context ) {
  tcpThreadContext_t *tcpThreadContext =
    (tcpThreadContext_t *)context;
  int sock = tcpThreadContext->socket;
  process_http(sock, tcpThreadContext->recv_buf, tcpThreadContext->send_buf);
  close(sock);
  // numConnections--;
  mem_free(tcpThreadContext->recv_buf);
  mem_free(tcpThreadContext->send_buf);
  mem_free(tcpThreadContext);
  return 0;
}
