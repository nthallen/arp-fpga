#include "ssp_intr.h"
#include "ssp_status.h"
#include "ad9510_if.h"
#include "sys/intr.h"
#include "pthread.h"

static pthread_mutex_t sg_mutex = PTHREAD_MUTEX_INITIALIZER;

// return 1 on success
static int sg_mutex_lock(void) {
  int rv = pthread_mutex_lock(&sg_mutex);
  check_return( rv, "351", "pthread_mutex_lock(&sg_mutex)" );
  return !rv;
}

static void sg_mutex_unlock(void) {
  int rv = pthread_mutex_unlock(&sg_mutex);
  check_return( rv, "352", "pthread_mutex_unlock(&sg_mutex)" );
}

static void set_ssp_control( unsigned int mask, unsigned int val,
            char *codes, char *where ) {
  static unsigned int control = ~SSP_CONTROL_MASK | SSP_RESET_MASK;
  unsigned int new_control;
  int status;
  sg_mutex_lock();
  new_control = ((control & ~mask) | (val & mask)) & SSP_CONTROL_MASK;
  if ( new_control != control ) {
    status = ssp_ll_control(new_control);
    control = new_control;
    check_return( status, codes, where );
  }
  sg_mutex_unlock();
}

static void set_ssp_netsamples( unsigned int val ) {
  int status;
  sg_mutex_lock();
  status = ssp_ll_netsamples(val);
  check_return( status, "717", "Setting NetSamples" );
  sg_mutex_unlock();
}

static void set_ssp_navg( unsigned int val ) {
  int status;
  sg_mutex_lock();
  status = ssp_ll_navg(val);
  check_return( status, "718", "Setting Navg" );
  sg_mutex_unlock();
}

static void set_ssp_ncoadd( unsigned int val ) {
  int status;
  sg_mutex_lock();
  status = ssp_ll_ncoadd(val);
  check_return( status, "719", "Setting Navg" );
  sg_mutex_unlock();
}

/* Reads up to nwords from the fifo */
int ssp_read_fifo( unsigned int *buf, unsigned int nwords ) {
  int status;
  unsigned int n_words_ready = 0, is_empty;
  
  sg_mutex_lock();
  status = ssp_ll_empty(&is_empty);
  if ( ! check_return( status, "71J", "Reading Empty" ) && !is_empty ) {
    status = ssp_ll_pctfull(&n_words_ready);
    if ( !check_return( status, "71K", "Reading PercentFull" ) ) {
		  if ( n_words_ready < nwords )
		  	nwords = n_words_ready+1;
		  n_words_ready = ssp_ad_scan_sm_0_ArrayRead(SSP_AD_SCAN_SM_0_SRCSIGNAL,
		         SSP_AD_SCAN_SM_0_SRCSIGNAL_DOUT,
		         nwords, buf );
    }
  }
  sg_mutex_unlock();
  return n_words_ready;
}

int ssp_read_pctfull( void ) {
  int status;
  unsigned int words;
  sg_mutex_lock();
  status = ssp_ll_pctfull(&words);
  sg_mutex_unlock();
  return words;
}

/* Reads from the fifo as long as at least nwords are present.
 * Returns total number of words read. */
//static unsigned int drain_fifo( void ) {
//  unsigned int nwords, words_read, total_words = 0;
//  int status;
//  sg_mutex_lock();
//
//  for (;;) {
//    status = ssp_ll_pctfull(&nwords);
//    if ( check_fifo_status( status, "Reading PercentFull in drain_fifo" ) ||
//         nwords == 0 ) break;
//    if ( nwords > MAX_SCAN_LENGTH ) nwords = MAX_SCAN_LENGTH;
//    words_read = ssp_ArrayRead( nwords, scan );
//    total_words += words_read;
//    if ( words_read == 0 ) break;
//  }
//  sg_mutex_unlock();
//  return total_words;
//}

void xfr_disable(void) {
  set_ssp_control( SSP_RESET_MASK, SSP_RESET_MASK, "712", "Reseting circuit" );
  AD9510_Init( 0, 1 );
}

void xfr_enable(void) {
  int i, status;
  unsigned int is_empty;
  
  for ( i = SSP_MAX_SCAN_LENGTH; i < SSP_MAX_SCAN_LENGTH+SCAN_GUARD; i++ )
    scan[i] = 0;
  set_ssp_control( SSP_RESET_MASK, SSP_RESET_MASK, "713", "Reseting circuit" );
  AD9510_Init( ssp_config.NE, ssp_config.NF );
  set_ssp_netsamples( ssp_config.NS );
  set_ssp_navg( ssp_config.NA-1 );
  set_ssp_ncoadd( ssp_config.NC );
  
  set_ssp_control( SSP_NE_MASK, ssp_config.NE << SSP_NE_LSB, "714", "During init" );
  set_trigger();

  // Verify that fifo is empty
  status = ssp_ll_empty(&is_empty);
  check_return( status, "721", "Reading Empty during init" );
  if ( !is_empty )
  	status_set( 0, "712", "FIFO non-empty during init\n");
  set_ssp_control( SSP_RESET_MASK, 0, "715", "Enabling Circuit" );
}

void set_trigger( void ) {
	int status;
  sg_mutex_lock();
  status = ssp_ll_triggerlevel(ssp_config.TL);
  check_return( status, "723", "Setting TriggerLevel" );
  sg_mutex_unlock();
  set_ssp_control( SSP_TRIG_MASK, ssp_config.TrigConfig, "716", "Setting Trigger Config" );
}
