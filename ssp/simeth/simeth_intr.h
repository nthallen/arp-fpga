#include "xmk.h"
#include "semaphore.h"
extern void xfr_disable(void);
extern void xfr_enable(void);
extern void xfr_init(void);
extern void sg_handler(void *);
extern void setup_interrupt(void);
extern sem_t udp_sem;
#define SG_INTR_ID XPAR_OPB_INTC_0_SCAN_GEN_SM_0_SCANINTR_INTR
#define MAX_SCAN_LENGTH 2048
#define SCAN_GUARD 100
extern unsigned int scan[];
extern int scan_xmit_length;
extern int xfrEnabled;
