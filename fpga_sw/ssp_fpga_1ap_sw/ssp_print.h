#ifndef SSP_PRINT_H
#define SSP_PRINT_H

#include "xmk.h" // must include xmk.h if we're using xilkernel
#include <stdio.h> // to define xil_printf(), print()
#include "xparameters.h"

#ifdef STDOUT_BASEADDRESS
  #define PRINT_ENABLE 1
  extern void safe_print( char *text );
  #define safe_printf(x) xil_printf x
#else
  #define PRINT_ENABLE 0
  #define safe_print(x)
  #define safe_printf(x)
#endif

#if PRINT_ENABLE && defined(__XMK__)
  extern int print_mutex_lock(void);
  extern void print_mutex_unlock(void);
#else
  #define print_mutex_lock()
  #define print_mutex_unlock()
#endif


#endif
