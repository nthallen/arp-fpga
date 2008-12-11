#ifndef SSP_INTR_H_INCLUDED
#define SSP_INTR_H_INCLUDED

#include "xmk.h"
#include "semaphore.h"
#include "xparameters.h"
#include "ssp_ad_scan_sm_0.h"
#include <string.h>
#include "lwip/tcpip.h"
#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "xparameters.h"
#include "ssp_ad.h"

extern void* main_main(void* arg);
extern void *udpThread(void *arg);
extern void *serverAppThread(void *arg);
extern void *tcpThread( void *socketptr );
extern int ethernet_init(void);
extern int check_fifo_status( int status, char *where );

extern void xfr_disable(void);
extern void xfr_enable(void);
extern void set_trigger( void );
// extern void sg_handler(void *);
// extern void setup_dsp_interrupt(void);
extern int ssp_read_fifo( unsigned int *buf, unsigned int nwords );

extern sem_t udp_sem, tcp_sem;

typedef struct {
	unsigned short CC;
	unsigned short RV;
	unsigned short EN; /* bool */
	unsigned short NS, NA, NC;
	unsigned short NP; /* udp port number */
	unsigned short NE;
  unsigned short NF; /* Frequency Divisor */
	signed short TL;
	unsigned short TrigConfig;
} ssp_config_t;
extern ssp_config_t ssp_config;

#define SCAN_GUARD 100
extern unsigned int scan[];
// extern unsigned int scan_xmit_length;
// extern unsigned int n_average, new_n_average, preaddr_enable;
// extern int xfrEnabled;
// extern signed short TriggerLevel;

#define SG_INTR_ID XPAR_INTC_0_SSP_AD_SCAN_SM_0_VEC_ID
#define ssp_ArrayRead( nw, buf ) ssp_ad_scan_sm_0_ArrayRead(SSP_AD_SCAN_SM_0_SRCSIGNAL, \
         SSP_AD_SCAN_SM_0_SRCSIGNAL_DOUT, \
         nw, buf )
#define ssp_ll_pctfull(words) ssp_ad_scan_sm_0_Read(SSP_AD_SCAN_SM_0_SRCSIGNAL, \
    SSP_AD_SCAN_SM_0_SRCSIGNAL_PERCENTFULL, words)
#define ssp_ll_empty(val) ssp_ad_scan_sm_0_Read(SSP_AD_SCAN_SM_0_SRCSIGNAL, \
    SSP_AD_SCAN_SM_0_SRCSIGNAL_EMPTY, val);
#define ssp_ll_control(val) ssp_ad_scan_sm_0_Write(SSP_AD_SCAN_SM_0_CONTROL, \
     SSP_AD_SCAN_SM_0_CONTROL_DIN, val)
#define ssp_ll_netsamples(val) ssp_ad_scan_sm_0_Write(SSP_AD_SCAN_SM_0_NETSAMPLES, \
     SSP_AD_SCAN_SM_0_NETSAMPLES_DIN, val)
#define ssp_ll_triggerlevel(val) ssp_ad_scan_sm_0_Write(SSP_AD_SCAN_SM_0_TRIGGERLEVEL, \
     SSP_AD_SCAN_SM_0_TRIGGERLEVEL_DIN, val)
#define ssp_ll_navg(val) ssp_ad_scan_sm_0_Write(SSP_AD_SCAN_SM_0_NAVG, \
     SSP_AD_SCAN_SM_0_NAVG_DIN, val)
#define ssp_ll_ncoadd(val) ssp_ad_scan_sm_0_Write(SSP_AD_SCAN_SM_0_NCOADD, \
     SSP_AD_SCAN_SM_0_NCOADD_DIN, val)

#define EMAC_INTERRUPT_ID XPAR_XPS_INTC_0_ETHERNET_MAC_IP2INTC_IRPT_INTR
#define EMAC_BASEADDR XPAR_EMACLITE_0_BASEADDR
//#ifndef SSP_BOARD_ID
//  #define SSP_BOARD_ID 0
//#endif
//#define SSP_MAC_ADDRESS 0,0xA,0x35,0x55,0x55,0x55+SSP_BOARD_ID
//#define SSP_IP_ADDRESS 10, 0, 0, 200+SSP_BOARD_ID
//#define SSP_IP_NETMASK 255, 255, 255, 0
//#define SSP_IP_GATEWAY 10, 0, 0, 1
//#define IP_ADDRESS(x) IP4_ADDR(x, )
//#define IP_NETMASK(x) IP4_ADDR(x, 255, 255, 255, 0)
//#define IP_GATEWAY(x) IP4_ADDR(x, 10, 0, 0, 1)


//#ifdef STDOUT_BASEADDRESS
//  #define PRINT_ENABLE 1
//  extern int print_mutex_lock(void);
//  extern void print_mutex_unlock(void);
//  extern void safe_print( char *text );
//  #define safe_printf(x) xil_printf x
//#else
//  #define PRINT_ENABLE 0
//  #define print_mutex_lock()
//  #define print_mutex_unlock()
//  #define safe_print(x)
//  #define safe_printf(x)
//#endif

// SSP_PROTO_A is defined for the SSP Proto Rev A
// Make this definition in the project build configuration
// #define SSP_PROTO_A 1
// Also be sure to define SSP_BOARD_ID if necessary

#endif
