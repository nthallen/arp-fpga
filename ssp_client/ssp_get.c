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
#include <time.h>
// #include <sys/neutrino.h>
// #include <inttypes.h>
// #include <sys/syspage.h>
#include <math.h>

#define SCANS_PER_TEST 100
#define VERBOSE_LOG 1
#define BENCHMARK_UDP 0
int verbosity = 1;

void process_scan_set( int scan_length, int n_scans, FILE *logfp, FILE *dumpfp ) {
  char cmdbuf[80];
  int scan_size = (scan_length+1)*sizeof(long);
  int n;
  clock_t start_time, end_time;
  double duration;
  double sdS, sdS2, mean_dS, std_dS;
  long int last_scan = 0;
  int total_bytes, i, j;
  unsigned long int scan[4096];
  clock_t cps = CLOCKS_PER_SEC;

  sprintf(cmdbuf, "NS:%d\r\n", scan_length );
  printf("Setting scan_length to %d\n", scan_length );
  tcp_send(cmdbuf);
  while (tcp_send("EN\r\n") == 503 ) sleep(1);
  for (;;) {
    n = udp_receive(scan);
    if ( n == scan_size ) break;
    fprintf(stderr, "Expected %d bytes, received %d\n", scan_size, n );
  }
  sdS = sdS2 = 0.;
  start_time = clock( );
  // read a bunch of scans
  for (i = 0; i < n_scans; i++ ) {
    n = udp_receive(scan );
    if ( n != scan_size )
      fprintf( stderr, "!Expected %d bytes, received %d\n", scan_size, n);
    else if ( i == 0 ) {
      printf("  First scan = %08lX\n", scan[scan_length] );
    } else {
      unsigned long int dS = scan[scan_length] - last_scan;
      sdS += dS;
      sdS2 += dS*dS;
    }
    last_scan = scan[scan_length];
    if ( dumpfp ) {
      printf( "Dumping Scan %d/%d: %ld\n", i, n_scans, last_scan );
      // fprintf( dumpfp, "Scan %d\n", i );
      for ( j = 0; j <= scan_length; j++ )
        fprintf( dumpfp, "%10ld\n", scan[j] );
      fflush(dumpfp);
    }
  }
  end_time = clock( );
  // send DA command
  printf("Sending Disable\n");
  while (tcp_send("DA\r\n") == 503 ) sleep(1);
  // Calculate throughput
  duration = (end_time - start_time) / (double)cps;
  total_bytes = scan_size * n_scans;
  mean_dS = sdS/n_scans;
  std_dS = sqrt(sdS2/n_scans - mean_dS*mean_dS);
  printf( "%4d  %4d  %5.4f %.1f %.2f\n",
    scan_length,n_scans, duration, mean_dS, std_dS );
  fprintf(logfp, "%4d  %4d  %5.4f %.1f %.2f\n",
    scan_length,n_scans, duration, mean_dS, std_dS );
}

int main( int argc, char **argv ) {
  char cmdbuf[80];
  int udp_port = udp_create();
  FILE *ofp, *vfp;
  int scan_length;

  printf("Opened UDP port %d\n", udp_port);
  // open TCP connection to SSP board
  tcp_create("10.0.0.200");
  // transmit the command including UDP socket number
  sprintf(cmdbuf, "UP:%d\r\n", udp_port );
  tcp_send(cmdbuf);
  ofp = fopen("ssp_get.log", "w");
  if ( ofp == NULL ) {
    fprintf(stderr,"Cannot open ssp_get.log\n");
    exit(1);
  }
  #if VERBOSE_LOG
    vfp = fopen("ssp_get_v.log", "w");
    if (vfp == NULL) {
      fprintf(stderr, "Cannot open ssp_get_v.log\n");
    }
  #else
    vfp = NULL;
  #endif
//  for ( scan_length = 999; scan_length < 1207; scan_length += 25 ) {
  #if BENCHMARK_UDP
    for ( scan_length = 999; scan_length > 25; scan_length -= 25 ) {
      process_scan_set( scan_length, SCANS_PER_TEST, ofp, vfp );
    }
  #else
    process_scan_set( 999, 10, ofp, vfp );
  #endif
  // tcp_send("EX\r\n");
  fclose(ofp);
  return 0;
}
