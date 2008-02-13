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
    NA:xxxx N_Average
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
#include <unistd.h>
#include <time.h>
#include <math.h>
#include <setjmp.h>
#include "nortlib.h"
#include "mlf.h"

int verbosity = 1;

/* If index == 0, this is a cleanup operation */
void move_lock( unsigned long index ) {
  static unsigned long prev_index;
  static int initialized = 0;
  char oldname[80], newname[80];
  
  sprintf( newname, "LOG/ssp_%lu.lock", index == 0L ? prev_index+1 : index );
  if ( ! initialized ) {
    FILE *fp = fopen( newname, "w" );
    fprintf( fp, "lock file\n" );
    fclose(fp);
    initialized = 1;
  } else {
    sprintf( oldname, "LOG/ssp_%lu.lock", prev_index );
    if ( index == 0 ) {
      unlink(oldname);
      unlink(newname);
      initialized = 0;
    } else {
      rename( oldname, newname );
    }
  }
  prev_index = index;
}

void cleanup(void) {
  unlink(PID_FILE);
  move_lock(0L);
  nl_error( 0, "cleanup" );
}

static sigjmp_buf env;

void sigint_handler(int sig) {
  siglongjmp(env,1);
}

int main( int argc, char **argv ) {
  char cmdbuf[80];
  long int scan[4096];
  int udp_port;
  int scan_length = 0;
  int scan_size;
  char *ssp_hostname;

  time_t last_rpt = 0, now;
  mlf_def_t *mlf = mlf_init( 3, 60, 1, "LOG", "dat", NULL );
  ssp_hostname = getenv("SSP_HOSTNAME");
  if ( ssp_hostname == 0 ) ssp_hostname = "10.0.0.200";
  else nl_error(0, "Addressing SSP %s", ssp_hostname );
  { FILE *fp = fopen( PID_FILE, "w" );
    if ( fp == 0 ) nl_error( 3, "Unable to write " PID_FILE );
    fprintf( fp, "%d\n", getpid() );
    fclose(fp);
  }
  move_lock(1L);
  if ( sigsetjmp( env, 1 ) == 0 ) {
    int i;
    unsigned long index;
    
    atexit(cleanup);
    signal(SIGINT, sigint_handler);
    udp_port = udp_create();
    nl_error(0, "Opened UDP port %d", udp_port);
    // open TCP connection to SSP board
    tcp_create(ssp_hostname);
    // transmit the command including UDP socket number
    sprintf(cmdbuf, "UP:%d\r\n", udp_port );
    tcp_send(cmdbuf);
    for ( i = 1; i < argc; i++ ) {
      sprintf( cmdbuf, "%s\r\n", argv[i] );
      if ( strncmp( cmdbuf, "NS:", 3 ) == 0 )
        scan_length = atoi(cmdbuf+3);
      else if ( strncmp( cmdbuf, "IX:", 3 ) == 0 ) {
      	index = strtoul(cmdbuf+3, NULL, 10);
      	mlf_set_index(mlf, index);
      	move_lock(index);
        continue; // skip the send
      }
      tcp_send(cmdbuf);
    }
    if ( scan_length == 0 ) {
      scan_length = 1024;
      sprintf(cmdbuf, "NS:%d\r\n", scan_length );
      nl_error( 0, "Setting scan_length to %d\n", scan_length );
      tcp_send(cmdbuf);
    }
    scan_size = (scan_length+1)*sizeof(long);
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
      	for ( j = 0; j <= scan_length; j++ ) {
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
  }
  nl_error( 0, "Normal exit" );
  // tcp_send("EX\r\n");
  return 0;
}
