#include "lwip/sockets.h"
#include "netif/xemacif.h"
#include "lwip/tcpip.h"
#include "xmk.h"
#include "xparameters.h"
#include "scan_gen_sm_0.h"

extern void* main_main(void* arg);
extern void *udpThread(void *arg);
extern void *serverAppThread(void *arg);
extern void *tcpThread( void *socketptr );
extern int ethernet_init(void);
extern void check_fifo_status( int status, char *where );

#define SCAN_TZ 100
#define SCAN_TRAMP 1000
#define SCAN_LENGTH (7+SCAN_TRAMP+2*SCAN_TZ)
#define SSP_SERVER_PORT 1500
#define SSP_MAX_MSG 80
#define EMAC_INTERRUPT_ID XPAR_OPB_INTC_0_ETHERNET_MAC_IP2INTC_IRPT_INTR

/* External Declarations */
extern XEmacIf_Config XEmacIf_ConfigTable[];
