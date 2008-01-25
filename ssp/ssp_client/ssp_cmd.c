/*
  ssp_cmd
    Opens TCP command connection to SSP board, sends a command or commands and closes
    This program is an auxiliary program, so it will not allow commands that alter the
    basic sampling. Just the triggering modes for now.

  Commands:
    # EN Enable
    # DA Disable
    # EX Quit
    # NS:xxxx N_Samples
    # NC:xxxx N_Coadd
    # UP:xxxxx UDP Port Number
    TE Trigger External
    TU:[-]xxxxx Level Trigger Rising
    TD:[-]xxxxx Level Trigger Falling
    AE Autotrig Enable
    AD Autotrig Disable
  Return Values:
    200 OK
    500 Bad
*/
#include <stdio.h>
#include <stdlib.h>
#include "ssp_get.h"
#include <time.h>
#include <math.h>
#include "nortlib.h"
#include "mlf.h"

int verbosity = 1;

int main( int argc, char **argv ) {
  char cmdbuf[80];
  char *ssp_hostname;
  int i;

  // open TCP connection to SSP board
  ssp_hostname = getenv("SSP_HOSTNAME");
  if ( ssp_hostname == 0 ) ssp_hostname = "10.0.0.200";
  else nl_error(0, "Addressing SSP %s", ssp_hostname );
  tcp_create(ssp_hostname);
  if ( argc > 1 ) {
    for ( i = 1; i < argc; i++ ) {
      snprintf( cmdbuf, 20, "%s\r\n", argv[i] );
      while ( tcp_send( cmdbuf ) == 503 ) sleep(1);
    }
  } else {
    for (;;) {
      int tries = 0, rv;
      if ( fgets(cmdbuf, 20, stdin) == 0 ) break;
      if ( cmdbuf[0] == '\n' ) break;
      for (;;) {
	rv = tcp_send(cmdbuf);
	if ( rv == 503 && ++tries < 5 ) sleep(2);
	else break;
      }
    }
  }
  tcp_close();
  return 0;
}