/*
  ssp_cmd
    Opens TCP command connection to 10.0.0.200 or the IP address specified in the
    environment variable SSP_HOSTNAME. Sends the list of commands passed on
    the command line. If the disable command (DA) is sent, attempts to shut down
    ssp_log if it is running. Otherwise, ssp_cmd does not attempt to interpret the
    commands.

  Commands:
    EN Enable
    DA Disable
    EX Quit
    NS:xxxx N_Samples
    NA:xxxx N_Avg
    NC:xxxx N_Coadd
    NP:xxxxx UDP Port Number
    NE:x Channel Enable (1-7)
    TU:[-]xxxxx Level Trigger Rising
    TD:[-]xxxxx Level Trigger Falling
    TS:x Trigger Source (0-3)
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
#include <signal.h>
#include <string.h>
#include "nl.h"
#include "mlf.h"

#define LOGROOT "LOG"
#define PID_FILE LOGROOT "/ssp_log.pid"
#define HDR_LOG LOGROOT "/ssp.log"

int verbosity = 1;

static void stop_log(void) {
  pid_t ssp_log_pid;
  FILE *fp = fopen( PID_FILE, "r" );
  if ( fp == 0 ) msg( 2, "PID_FILE %s not found", PID_FILE );
  else {
    if ( fscanf(fp, "%d", &ssp_log_pid) == 1 ) {
      msg( 0, "sending SIGINT to pid %d", ssp_log_pid );
      kill(ssp_log_pid, SIGINT);
    } else {
      msg( 2, "Problem reading PID_FILE" );
    }
    fclose(fp);
  }
}

int main( int argc, char **argv ) {
  char cmdbuf[80];
  char *ssp_hostname;
  int simulate = 0;
  int i;

  // open TCP connection to SSP board
  ssp_hostname = getenv("SSP_HOSTNAME");
  if ( ssp_hostname == 0 ) ssp_hostname = "10.0.0.200";
  else msg(0, "Addressing SSP %s", ssp_hostname );
  if ( strcmp(ssp_hostname, "simulator") == 0 )
    simulate = 1;
  else tcp_create(ssp_hostname);
  if ( argc > 1 ) {
    for ( i = 1; i < argc; i++ ) {
      snprintf( cmdbuf, 20, "%s\r\n", argv[i] );
      if ( ! simulate ) {
        while ( tcp_send( cmdbuf ) == 503 ) sleep(1);
      }
      if ( strncmp( argv[i], "DA", 2) == 0 )
        stop_log();
    }
  } else {
    for (;;) {
      int tries = 0, rv;
      if ( fgets(cmdbuf, 20, stdin) == 0 ) break;
      if ( cmdbuf[0] == '\n' ) break;
      for (;;) {
      	rv = simulate ? 200 : tcp_send(cmdbuf);
      	if ( rv == 503 && ++tries < 5 ) sleep(2);
      	else break;
      }
    }
  }
  if ( ! simulate ) tcp_close();
  return 0;
}
