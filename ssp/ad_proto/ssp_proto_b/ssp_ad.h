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

typedef struct {
	unsigned short CC;
	unsigned short RV;
	unsigned short EN; /* bool */
	unsigned short NS, NA, NC;
	unsigned short NP; /* udp port number */
	unsigned short NE;
	signed short TL;
	unsigned short TrigConfig;
} ssp_config_t;
extern ssp_config_t ssp_config;


#define SSP_MAX_SAMPLES 4096
#define SSP_MAX_PREADD 5
#define SSP_MAX_COADD 7
#define SSP_MAX_CHANNELS 3
#define SSP_MAX_NE ((1<<SSP_MAX_CHANNELS)-1)
#define SSP_NE_LSB 5
#define SSP_NE_MASK (SSP_MAX_NE<<SSP_NE_LSB)
#define SSP_TRIG_RISING 0x8
#define SSP_TRIG_AE 0x10
#define SSP_TRIG_SRC_MASK 0x6
#define SSP_TRIG_SRC_LSB 1
#define SSP_TRIG_SRC_MAX 3
#define SSP_TRIG_MASK (SSP_TRIG_SRC_MASK|SSP_TRIG_AE|SSP_TRIG_RISING)
#define SSP_RESET_MASK 1
#define SSP_CONTROL_MASK 0x3F

#define SSP_MAX_SCAN_LENGTH (7+SSP_MAX_CHANNELS*SSP_MAX_SAMPLES)
#define SSP_SERVER_PORT 1500
#define SSP_MAX_MSG 80
#define EMAC_INTERRUPT_ID XPAR_XPS_INTC_0_ETHERNET_MAC_IP2INTC_IRPT_INTR
#define EMAC_BASEADDR XPAR_EMACLITE_0_BASEADDR
#define IP_ADDRESS(x) IP4_ADDR(x, 10, 0, 0, 200)
#define IP_NETMASK(x) IP4_ADDR(x, 255, 255, 255, 0)
#define IP_GATEWAY(x) IP4_ADDR(x, 10, 0, 0, 1)
