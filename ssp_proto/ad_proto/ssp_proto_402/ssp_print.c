#include "xmk.h"
#include "xparameters.h"
#include <stdio.h>
#include <pthread.h>
//#include "ssp_ad.h"

#ifdef STDOUT_BASEADDRESS

static pthread_mutex_t print_mutex = PTHREAD_MUTEX_INITIALIZER;

// return 1 on success
int print_mutex_lock(void) {
  int rv = pthread_mutex_lock(&print_mutex);
  if ( rv ) {
    xil_printf("\r\nprint mutex lock failed: %d\r\n", rv );
    return 0;
  } else return 1;
}

void print_mutex_unlock(void) {
  int rv = pthread_mutex_unlock(&print_mutex);
  if ( rv ) {
    xil_printf("\r\nprint mutex unlock failed: %d\r\n", rv );
  }
}

void safe_print( char *text ) {
	print_mutex_lock();
	print(text);
	print_mutex_unlock();
}

#else
void xil_printf( const char *fmt, ... ) {}
void print( char *txt ) {}
#endif /* STDOUT_BASEADDRESS */
