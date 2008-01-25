#include "xmk.h"
#include "semaphore.h"
#include "xparameters.h"
#include "ssp_ad_scan_sm_0.h"

extern void xfr_disable(void);
extern void xfr_enable(void);
extern void xfr_init(void);
extern void set_trigger_mode( int autoen );
extern void set_trigger_src( unsigned short src );
extern void sg_handler(void *);
extern void setup_dsp_interrupt(void);
extern int ssp_read_fifo( int *buf, unsigned int nwords );
extern sem_t udp_sem;
#define MAX_SCAN_LENGTH 2048
#define SCAN_GUARD 100
extern unsigned int scan[];
extern int scan_xmit_length, new_scan_xmit_length;
extern int xfrEnabled;
extern signed short TriggerLevel;

#define SG_INTR_ID XPAR_OPB_INTC_0_SSP_AD_SCAN_SM_0_SCANINTR_INTR
#define ssp_ArrayRead( nw, buf ) ssp_ad_scan_sm_0_ArrayRead(SSP_AD_SCAN_SM_0_SRCSIGNAL, \
         SSP_AD_SCAN_SM_0_SRCSIGNAL_DOUT, \
         nw, buf )
#define ssp_ll_pctfull(words) ssp_ad_scan_sm_0_Read(SSP_AD_SCAN_SM_0_SRCSIGNAL, \
    SSP_AD_SCAN_SM_0_SRCSIGNAL_PERCENTFULL, words)
#define ssp_ll_control(val) ssp_ad_scan_sm_0_Write(SSP_AD_SCAN_SM_0_CONTROL, \
     SSP_AD_SCAN_SM_0_CONTROL_DIN, val)
#define ssp_ll_netsamples(val) ssp_ad_scan_sm_0_Write(SSP_AD_SCAN_SM_0_NETSAMPLES, \
     SSP_AD_SCAN_SM_0_NETSAMPLES_DIN, val)
#define ssp_ll_triggerlevel(val) ssp_ad_scan_sm_0_Write(SSP_AD_SCAN_SM_0_TRIGGERLEVEL, \
     SSP_AD_SCAN_SM_0_TRIGGERLEVEL_DIN, val)

#define SSP_ENABLE_MASK 1
#define SSP_RESET_MASK  2
#define SSP_TRIGSRC_MASK 0xC
#define SSP_AUTOTRIG_MASK 0x10
#define SSP_TRIG_EXTERNAL 0
#define SSP_TRIG_LEVEL_UP 0x4
#define SSP_TRIG_LEVEL_DN 0x8

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

