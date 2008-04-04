#include "xmk.h"
#include "semaphore.h"
#include "xparameters.h"
#include "ssp_ad_scan_sm_0.h"

extern void xfr_disable(void);
extern void xfr_enable(void);
extern void set_trigger( void );
// extern void sg_handler(void *);
// extern void setup_dsp_interrupt(void);
extern int ssp_read_fifo( unsigned int *buf, unsigned int nwords );
extern sem_t udp_sem, tcp_sem;
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
    SSP_AD_SCAN_SM_0_SRCSIGNAL_PERCENTFULL, (unsigned int *)words)
#define ssp_ll_empty(val) ssp_ad_scan_sm_0_Read(SSP_AD_SCAN_SM_0_SRCSIGNAL, \
    SSP_AD_SCAN_SM_0_SRCSIGNAL_EMPTY, &val);
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
