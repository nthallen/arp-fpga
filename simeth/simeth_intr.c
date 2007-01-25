#include "simeth_intr.h"
#include "sys/intr.h"
#include "xparameters.h"
#include "pthread.h"
#include "scan_gen_sm_0.h"

static pthread_mutex_t sg_mutex = PTHREAD_MUTEX_INITIALIZER;

// return 1 on success
static int sg_mutex_lock(void) {
  int rv = pthread_mutex_lock(&sg_mutex);
  if ( rv ) {
    xil_printf("mutex lock failed: %d\n", rv );
    return 0;
  } else return 1;
}

static void sg_mutex_unlock(void) {
  int rv = pthread_mutex_unlock(&sg_mutex);
  if ( rv ) {
    xil_printf("mutex unlock failed: %d\n", rv );
  }
}

static void set_scan_gen_control( unsigned int val, char *where ) {
  int status;
  sg_mutex_lock();
  status = scan_gen_sm_0_Write(SCAN_GEN_SM_0_CONTROL,
     SCAN_GEN_SM_0_CONTROL_DIN, val);
  check_fifo_status( status, where );
  sg_mutex_unlock();
}

static void set_scan_gen_netsamples( unsigned int val ) {
  int status;
  sg_mutex_lock();
  status = scan_gen_sm_0_Write(SCAN_GEN_SM_0_NETSAMPLES,
     SCAN_GEN_SM_0_NETSAMPLES_DIN, val);
  check_fifo_status( status, "Setting NetSamples" );
  sg_mutex_unlock();
}

int scan_gen_read_fifo( int *buf, int nwords ) {
  int words_read;
  sg_mutex_lock();
  words_read = scan_gen_sm_0_ArrayRead(SCAN_GEN_SM_0_SRCSIGNAL,
       SCAN_GEN_SM_0_SRCSIGNAL_DOUT,
       nwords, (int **)buf );
  sg_mutex_unlock();
  return words_read;
}

static void drain_fifo( char *where) {
  int status;
  for (;;) {
    status = scan_gen_read_fifo( scan, MAX_SCAN_LENGTH );
    if ( status == 0 ) {
      break;
    } else if ( status < 0 ) {
      xil_printf("drain_fifo: ####ArrayRead returned %d %s\n", status, where);
      break;
    }
  }
}

void xfr_init(void) {
  int i;
  for ( i = MAX_SCAN_LENGTH; i < MAX_SCAN_LENGTH+SCAN_GUARD; i++ )
    scan[i] = 0;
  set_scan_gen_control( 0, "Clearing enable" );
  set_scan_gen_netsamples( scan_xmit_length );
  set_scan_gen_control( 2, "Resetting circuit" );
  sleep(20); // shortened from 200
//  status = scan_gen_sm_0_Write(SCAN_GEN_SM_0_SRCSIGNAL,
//    SCAN_GEN_SM_0_SRCSIGNAL_RST, 1);
//  GAAA! RST isn't defined.
  drain_fifo("during reset");
  // sleep(100); // This time is apparently essential
  set_scan_gen_control( 0, "Clearing circuit reset" );
  // sleep(200); // As is this one
}

void xfr_disable(void) {
  set_scan_gen_control( 0, "Clearing circuit enable" );
  sleep( 200 ); // leave some time for processing
  disable_interrupt( SG_INTR_ID );
  xfrEnabled = 0;
}

void xfr_enable(void) {
  enable_interrupt( SG_INTR_ID );
  set_scan_gen_control( 1, "Setting circuit enable" );
  xfrEnabled = 1;
}

void sg_handler(void *foo) {
  sem_post(&udp_sem);
  acknowledge_interrupt( SG_INTR_ID );
}

void setup_interrupt(void) {
  disable_interrupt( SG_INTR_ID );
  register_int_handler( SG_INTR_ID, sg_handler, NULL );
}
