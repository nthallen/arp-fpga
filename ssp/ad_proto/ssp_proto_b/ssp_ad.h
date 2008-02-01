#include "xmk.h"
#include <string.h>
#include "lwip/tcpip.h"
#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "xparameters.h"
#include "ssp_ad_scan_sm_0.h"

extern void* main_main(void* arg);
extern void *udpThread(void *arg);
extern void *serverAppThread(void *arg);
extern void *tcpThread( void *socketptr );
extern int ethernet_init(void);
extern int check_fifo_status( int status, char *where );

#define SCAN_TZ 100
#define SCAN_TRAMP 1000
#define SCAN_LENGTH (7+SCAN_TRAMP+2*SCAN_TZ)
#define SSP_SERVER_PORT 1500
#define SSP_MAX_MSG 80
#define EMAC_INTERRUPT_ID XPAR_XPS_INTC_0_ETHERNET_MAC_IP2INTC_IRPT_INTR
#define EMAC_BASEADDR XPAR_EMACLITE_0_BASEADDR
#define IP_ADDRESS(x) IP4_ADDR(x, 10, 0, 0, 200)
#define IP_NETMASK(x) IP4_ADDR(x, 255, 255, 255, 0)
#define IP_GATEWAY(x) IP4_ADDR(x, 10, 0, 0, 1)
