/*
  get_data
    Opens a UDP socket for receiving data
    Opens TCP command connection to SSP board
    Issues the configuration command, informing the SSP board
      what UDP port to send data to
    Reads some quantity of data from the UDP port
    Issues the stop command

  Commands:
    NS:xxxx N_Samples
    NC:xxxx N_Coadd
    UP:xxxxx UDP Port Number
    EN Enable
    DA Disable
    RS Return Status
  Return Values:
    200 OK
    500 Bad
*/
#include "ssp_get.h"
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "nortlib.h"
#include "mlf.h"

int verbosity = 1;

void move_lock( unsigned long index ) {
  static unsigned long prev_index;
  static int initialized = 0;
  char oldname[80], newname[80];
  
  sprintf( newname, "LOG/ssp_%lu.lock", index );
  if ( ! initialized ) {
    FILE *fp = fopen( newname, "w" );
    fprintf( fp, "lock file\n" );
    fclose(fp);
    initialized = 1;
  } else {
    sprintf( oldname, "LOG/ssp_%lu.lock", prev_index );
    rename( oldname, newname );
  }
  prev_index = index;
}

int main( int argc, char **argv ) {
  char cmdbuf[80];
  long int scan[4096];
  int udp_port;
  int scan_length = 999;
  int scan_size = (scan_length+1)*sizeof(long);
  char *ssp_hostname;

  time_t last_rpt = 0, now;
  mlf_def_t *mlf = mlf_init( 3, 60, 1, "LOG", "dat", NULL );
  ssp_hostname = getenv("SSP_HOSTNAME");
  if ( ssp_hostname == 0 ) ssp_hostname = "10.0.0.200";
  else nl_error(0, "Addressing SSP %s", ssp_hostname );
  move_lock(1L);
  udp_port = udp_create();
  nl_error(0, "Opened UDP port %d", udp_port);
  // open TCP connection to SSP board
  tcp_create(ssp_hostname);
  // transmit the command including UDP socket number
  sprintf(cmdbuf, "UP:%d\r\n", udp_port );
  tcp_send(cmdbuf);
  sprintf(cmdbuf, "NS:%d\r\n", scan_length );
  nl_error( 0, "Setting scan_length to %d\n", scan_length );
  tcp_send(cmdbuf);
  while (tcp_send("EN\r\n") == 503 ) sleep(1);
  tcp_close();
  for (;;) {
    int n = udp_receive(scan);
    if ( n != scan_size ) {
      nl_error( mlf->index ? 2 : 1,
        "Expected %d bytes, received %d\n", scan_size, n );
    } else {
      int j;
      FILE *ofp = mlf_next_file(mlf);
      for ( j = 0; j < scan_length; j++ ) {
	// temporary fix for signed data
	// signed long cts = scan[j];
	// if ( cts > 32767 )
	//   cts -= 65536L;
	fprintf( ofp, "%10ld\n", scan[j] );
      }
      fclose(ofp);
      move_lock(mlf->index+1);
      now = time(NULL);
      if ( difftime(now, last_rpt) > 5 ) {
	nl_error( 0, "Recorded Scan %lu", mlf->index );
	last_rpt = now;
      }
    }
  }

  // tcp_send("EX\r\n");
  return 0;
}
