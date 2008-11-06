/* status.c
 * Module to provide status indications via LEDs
 * Status messages should be a string of values all between 1 and 15 inclusive along with an indication of warning or error status
 * Maintain a list of current status codes and a list of error codes. Error codes remain, but we only support a limited number of them,
 * so they will overwrite at some point.
 * Current status messages can be cleared
 * The status update will cycle through the current status messages and the current error messages.
 * To be thread-safe, the messages to set status will need to acquire a mutex before modifying the queues
 * Similarly, the status update routine will need to acquire the mutex before advancing.
 */
#include "config.h"
#ifdef __XMK__
  #include <sys/timer.h>
  #include <pthread.h>
#endif
#include "xparameters.h"
#include "xgpio.h"
#include "ssp_status.h"

#define MAX_STATUS_SETS 6
#define MAX_ERROR_SETS 6
static unsigned char *status_list[MAX_STATUS_SETS];
static int n_status_sets = 0;
static int cur_status_set = 0;
static unsigned char *error_list[MAX_ERROR_SETS];
static int n_error_sets = 0;
static int cur_error_set = 0;
static int cur_elt = 0;

static unsigned char s_init[] = { 1, 0 };
static unsigned char s_ready[] = { 1, 2, 4, 8, 0 };

XGpio LED;

#ifdef __XMK__
static pthread_mutex_t status_mutex = PTHREAD_MUTEX_INITIALIZER;
static pthread_t status_tid;

static void *status_thread(void *param) {
  for (;;) {
    int cur_value;
    sleep(250);
    pthread_mutex_lock(&status_mutex);
    if ( cur_error_set < n_error_sets ) {
      cur_value = error_list[cur_error_set][cur_elt];
      if ( cur_value == 0 ) {
        cur_elt = 0;
        if (++cur_error_set == n_error_sets) {
          if ( n_status_sets > 0 ) {
            cur_status_set = 0;
          } else {
            cur_error_set = 0;
            cur_value |= 0x10;
          }
        }
      } else {
        cur_value |= 0x10;
        ++cur_elt;
      }
    } else if ( cur_status_set < n_status_sets ) {
      cur_value = status_list[cur_status_set][cur_elt];
      if ( cur_value == 0 ) {
        cur_elt = 0;
        if (++cur_status_set == n_status_sets) {
          if ( n_error_sets > 0 ) {
            cur_error_set = 0;
            cur_value |= 0x10;
          } else {
            cur_status_set = 0;
          }
        }
      } else {
        ++cur_elt;
      }
    } else if ( n_error_sets > 0 ) {
      cur_error_set = 0;
      cur_elt = 0;
      cur_value = 0x10;
    } else if ( n_status_sets > 0 ) {
      cur_status_set = 0;
      cur_elt = 0;
      cur_value = 0;
    }
    status_unlock();
    set_status(cur_value);
  }
}

static void status_lock(void) {
  int rv = pthread_mutex_lock(&status_mutex);
  if ( rv != 0 ) set_status( 0x1F );
}

static void status_unlock(void) {
  int rv = pthread_mutex_unlock(&status_mutex);
  if ( rv != 0) set_status( 0x1E);
}

#endif /* __XMK__ */

int status_init(void) {
  int rv;
  // initialize the GPIO hardware
	XGpio_Initialize(&LED, XPAR_XPS_GPIO_1_DEVICE_ID );
	XGpio_SetDataDirection(&LED, 1, 0 );
  XGpio_DiscreteWrite(&LED,1,0x1F);

  status_set( 0, s_init );
  
  #ifdef __XMK__
  // I think using pthread_create is OK since this thread does not access any LwIP stuff.
  return pthread_create( &status_tid, NULL, status_thread, NULL );
  #else
    return 0;
  #endif
}

static void set_status( int val ) {
  XGpio_DiscreteWrite(&LED,1,val);
}

/* if clear == 0, appends the specified codes */
void status_set( int clear, unsigned char *codes) {
  #ifdef __XMK__
    status_lock();
    if ( clear ) {
      if (cur_status_set < n_status_sets) {
        cur_status_set = 1;
        cur_elt = 0;
      } else {
        cur_status_set = 1; // future n_status_sets
      }
      n_status_sets = 0;
    } else {
      if (n_status_sets >= MAX_STATUS_SETS) return;
      if (cur_status_set >= n_status_sets)
        ++cur_status_set;
    }
    status_list[n_status_sets++] = codes;
    status_unlock();
  #else
    set_status(codes[0]);
  #endif
}

void status_error( unsigned char *codes ) {
  #ifdef __XMK__
    status_lock();
    if ( n_error_sets < MAX_ERROR_SETS ) {
      if (cur_error_set >= n_error_sets)
        ++cur_error_set;
      error_list[n_error_sets++] = codes;
    }
    status_unlock();
  #else
    set_status(codes[0] | 0x10 );
  #endif
}
