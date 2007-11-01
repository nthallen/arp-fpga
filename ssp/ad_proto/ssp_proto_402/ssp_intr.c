#include "ssp_intr.h"
#include "sys/intr.h"
#include "pthread.h"

static pthread_mutex_t sg_mutex = PTHREAD_MUTEX_INITIALIZER;

signed short TriggerLevel = 0;

// return 1 on success
static int sg_mutex_lock(void) {
  int rv = pthread_mutex_lock(&sg_mutex);
  if ( rv ) {
    xil_printf("\r\nmutex lock failed: %d\r\n", rv );
    return 0;
  } else return 1;
}

static void sg_mutex_unlock(void) {
  int rv = pthread_mutex_unlock(&sg_mutex);
  if ( rv ) {
    xil_printf("\r\nmutex unlock failed: %d\r\n", rv );
  }
}

static void set_ssp_control( unsigned int mask, unsigned int val, char *where ) {
  static unsigned int control = 0x8000;
  unsigned int new_control;
  int status;
  sg_mutex_lock();
  new_control = ((control & ~mask) | (val & mask)) & 0x1F;
  if ( new_control != control ) {
    status = ssp_ll_control(new_control);
    control = new_control;
    check_fifo_status( status, where );
  }
  sg_mutex_unlock();
}

static void set_ssp_netsamples( unsigned int val ) {
  int status;
  sg_mutex_lock();
  status = ssp_ll_netsamples(val);
  check_fifo_status( status, "Setting NetSamples" );
  sg_mutex_unlock();
}

/* Reads from the fifo as long as at least nwords are present */
int ssp_read_fifo( int *buf, unsigned int nwords ) {
  int status;
  unsigned int words_read;
  sg_mutex_lock();

  status = ssp_ll_pctfull(&words_read);
  if ( check_fifo_status( status, "Reading PercentFull" ) ||
        words_read < nwords ) {
    words_read = 0;
  }  else {
    words_read = ssp_ArrayRead( nwords, buf );
  }
  sg_mutex_unlock();
  return words_read;
}

int ssp_read_pctfull( void ) {
  int words, status;
  sg_mutex_lock();
  status = ssp_ll_pctfull(&words);
  sg_mutex_unlock();
  return words;
}

/* Reads from the fifo as long as at least nwords are present.
 * Returns total number of words read. */
static unsigned int drain_fifo( void ) {
  unsigned int nwords, words_read, total_words = 0;
  int status;
  sg_mutex_lock();

  for (;;) {
    status = ssp_ll_pctfull(&nwords);
    if ( check_fifo_status( status, "Reading PercentFull in drain_fifo" ) ||
         nwords == 0 ) break;
    if ( nwords > MAX_SCAN_LENGTH ) nwords = MAX_SCAN_LENGTH;
    words_read = ssp_ArrayRead( nwords, scan );
    total_words += words_read;
    if ( words_read == 0 ) break;
  }
  sg_mutex_unlock();
  return total_words;
}

void xfr_init(void) {
  int i, words_before, words_after, words_drained;
  for ( i = MAX_SCAN_LENGTH; i < MAX_SCAN_LENGTH+SCAN_GUARD; i++ )
    scan[i] = 0;
  set_ssp_control( SSP_ENABLE_MASK, 0, "Clearing enable" );
  set_ssp_netsamples( new_scan_xmit_length );
  scan_xmit_length = new_scan_xmit_length;
  words_before = ssp_read_pctfull();
  set_ssp_control( SSP_RESET_MASK, SSP_RESET_MASK, "Resetting circuit" );
  sleep(20); // shortened from 200
//  status = ssp_ad_scan_sm_0_Write(SSP_AD_SCAN_SM_0_SRCSIGNAL,
//    SSP_AD_SCAN_SM_0_SRCSIGNAL_RST, 1);
//  GAAA! RST isn't defined.
  //words_after = ssp_read_pctfull();
  //xil_printf( " words: %d %d\n", words_before, words_after );
  words_drained = drain_fifo();
  set_ssp_control( SSP_RESET_MASK, 0, "Clearing circuit reset" );
}

void xfr_disable(void) {
  set_ssp_control( SSP_ENABLE_MASK, 0, "Clearing circuit enable" );
  // sleep( 200 ); // leave some time for processing
  // disable_interrupt( SG_INTR_ID );
  xfrEnabled = 0;
}

void xfr_enable(void) {
  enable_interrupt( SG_INTR_ID );
  set_ssp_control( SSP_ENABLE_MASK, SSP_ENABLE_MASK,
		  "Setting circuit enable" );
  xfrEnabled = 1;
}

void set_trigger_mode( int autoen ) {
  set_ssp_control( SSP_AUTOTRIG_MASK, autoen ? SSP_AUTOTRIG_MASK : 0,
		  "Setting trigger mode" );
}

void set_trigger_src( unsigned short mode ) {
  if ( mode == SSP_TRIG_LEVEL_UP || mode == SSP_TRIG_LEVEL_DN ) {
    int status;
    sg_mutex_lock();
    status = ssp_ll_triggerlevel(TriggerLevel);
    check_fifo_status( status, "Setting TriggerLevel" );
    sg_mutex_unlock();
  }
  set_ssp_control( SSP_TRIGSRC_MASK, mode, "Setting trigger src" );
}

void sg_handler(void *foo) {
  acknowledge_interrupt( SG_INTR_ID );
  sem_post(&udp_sem);
}

void setup_dsp_interrupt(void) {
  disable_interrupt( SG_INTR_ID );
  register_int_handler( SG_INTR_ID, sg_handler, NULL );
}
