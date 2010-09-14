/* status.c
 * Module to provide status indications via LEDs
 * Also supports the JP1 dipswitch interface.
 * Must call status_init() before any other functions.
 *
 * Status messages should be a string of values all between 1 and 15 inclusive along with an indication of warning or error status
 * Maintain a list of current status codes and a list of error codes. Error codes remain, but we only support a limited number of them,
 * so they will overwrite at some point.
 * Current status messages can be cleared
 * The status update will cycle through the current status messages and the current error messages.
 * To be thread-safe, the messages to set status will need to acquire a mutex before modifying the queues
 * Similarly, the status update routine will need to acquire the mutex before advancing.
 *
 * I will use only the 4 low-order bits of each status string, so we can use printable ASCII codes "123456789JKLMNO"
 * Unfortunately the alpha codes don't map naturally to hex, but this will be a bit more readable than octal codes.
 * J: 0xA 1010
 * K: 0xB 1011
 * L: 0xC 1100
 * M: 0xD 1101
 * N: 0xE 1110
 * O: 0xF 1111
 * Lower case works just as well.
 */
#include "xmk.h" // was config.h in SSP_Config
#ifdef __XMK__
  #include <sys/timer.h>
  #include <pthread.h>
#endif
#include <errno.h>
#include "xparameters.h"
#include "xgpio.h"
#include "ssp_status.h"
#include "ssp_print.h"

#define MAX_STATUS_SETS 6
#define MAX_ERROR_SETS 6
static char *status_list[MAX_STATUS_SETS];
static int n_status_sets = 0;
static int cur_status_set = 0;
static char *error_list[MAX_ERROR_SETS];
static int n_error_sets = 0;
static int cur_error_set = 0;
static int cur_elt = 0;

XGpio JP1, LED;

#ifdef __XMK__
static pthread_mutex_t status_mutex = PTHREAD_MUTEX_INITIALIZER;
static pthread_t status_tid;

static void set_status( int val ) {
  XGpio_DiscreteWrite(&LED,1,val);
}

static void status_lock(void) {
  int rv;
  rv = pthread_mutex_lock(&status_mutex);
  if ( rv != 0 ) set_status( 0x1F );
}

static void status_unlock(void) {
  int rv;
  rv = pthread_mutex_unlock(&status_mutex);
  if ( rv != 0) set_status( 0x1E);
}

static void *status_thread(void *param) {
  for (;;) {
    int cur_value;
    sleep(500);
    status_lock();
    if ( cur_error_set < n_error_sets ) {
      cur_value = error_list[cur_error_set][cur_elt] & 0xF;
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
      cur_value = status_list[cur_status_set][cur_elt] & 0xF;
      if ( cur_value == 0 ) {
        cur_elt = 0;
        if (++cur_status_set == n_status_sets) {
          if ( n_error_sets > 0 ) {
            cur_error_set = 0;
            // cur_value |= 0x10;
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

#endif /* __XMK__ */

int status_init(void) {
  // int rv;
  // initialize the GPIO hardware
	XGpio_Initialize(&LED, XPAR_XPS_GPIO_1_DEVICE_ID );
	XGpio_SetDataDirection(&LED, 1, 0 );
  XGpio_DiscreteWrite(&LED,1,0x1F);
	
	XGpio_Initialize(&JP1, XPAR_XPS_GPIO_0_DEVICE_ID );
	XGpio_SetDataDirection(&JP1, 1, 0xF );

  status_set( 0, "1", "Init" );
  
  #ifdef __XMK__
  // I think using pthread_create is OK since this thread does not access any LwIP stuff.
  return pthread_create( &status_tid, NULL, status_thread, NULL );
  #else
    return 0;
  #endif
}

/* if clear == 0, appends the specified codes */
void status_set( int clear, char *codes, char *reason) {
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
    } else if (n_status_sets < MAX_STATUS_SETS &&
          cur_status_set >= n_status_sets) {
      ++cur_status_set;
    }
    if ( n_status_sets < MAX_STATUS_SETS )
	    status_list[n_status_sets++] = codes;
    status_unlock();
  #else
    set_status(codes[0]);
  #endif
  print_mutex_lock();
  safe_printf(("STATUS: %s\r\n", reason));
  print_mutex_unlock();
}

void status_error( char *codes ) {
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

// return non-zero if error reported
int check_return( int rv, char *codes, char *where ) {
	if ( rv != XST_SUCCESS ) {
    print_mutex_lock();
		safe_printf(("Error from %s: %d\r\n", where, rv));
    print_mutex_unlock();
    status_error(codes);
    return 1;
  }
  return 0;
}

int report_error( char *codes, char *reason ) {
  status_error( codes );
  print_mutex_lock();
  safe_printf(("%s\r\n", reason));
  print_mutex_unlock();
  return 0;
}

int report_errno( char *codes, char *reason ) {
  status_error( codes );
  print_mutex_lock();
  safe_printf(("Error from %s: errno %d\r\n", reason, errno));
  print_mutex_unlock();
  return 0;
}

unsigned int read_jp1(void) {
	return XGpio_DiscreteRead(&JP1,1);
}
