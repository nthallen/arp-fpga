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
#include "udp_demo.h"
#include <time.h>
#include <sys/neutrino.h>
#include <inttypes.h>
#include <sys/syspage.h>
#include <math.h>

#define SCANS_PER_TEST 100
int verbosity = 0;

int main( int argc, char **argv ) {
	char cmdbuf[80];
	int i, scan_length;
	int udp_port = udp_create();
	unsigned long int scan[4096];
	FILE *ofp;

	uint64_t cps = SYSPAGE_ENTRY(qtime)->cycles_per_sec;
	printf("Opened UDP port %d\n", udp_port);
	// open TCP connection to SSP board
	tcp_create("10.0.0.200");
	// transmit the command including UDP socket number
	sprintf(cmdbuf, "UP:%d\r\n", udp_port );
	tcp_send(cmdbuf);
	ofp = fopen("udp_demo.log", "w");
	if ( ofp == NULL ) {
	  fprintf(stderr,"Cannot open udp_demo.log\n");
	  exit(1);
	}
	for ( scan_length = 25; scan_length < 1207; scan_length += 25 ) {
		int scan_size = (scan_length+1)*sizeof(long);
		int n;
    uint64_t start_time, end_time;
		double duration;
		double sdS, sdS2, mean_dS, std_dS;
		long int last_scan;
		int total_bytes;
		
		sprintf(cmdbuf, "NS:%d\r\n", scan_length );
		tcp_send(cmdbuf);
  	tcp_send("EN\r\n");
		for (;;) {
			n = udp_receive(scan);
			if ( n == scan_size ) break;
			fprintf(stderr, "Expected %d bytes, received %d\n", scan_size, n );
		}
		sdS = sdS2 = 0.;
		start_time = ClockCycles( );
		// read a bunch of scans
		for (i = 0; i < SCANS_PER_TEST; i++ ) {
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
		}
		end_time = ClockCycles( );
		// send DA command
		tcp_send("DA\r\n");
		// Calculate throughput
		duration = (end_time - start_time) / (double)cps;
		total_bytes = scan_size * SCANS_PER_TEST;
		mean_dS = sdS/SCANS_PER_TEST;
		std_dS = sqrt(sdS2/SCANS_PER_TEST - mean_dS*mean_dS);
		printf( "%4d  %4d  %5.4f %.1f %.2f\n",
		  scan_length,SCANS_PER_TEST, duration, mean_dS, std_dS );
		fprintf(ofp, "%4d  %4d  %5.4f %.1f %.2f\n",
		  scan_length,SCANS_PER_TEST, duration, mean_dS, std_dS );
	}
	tcp_send("EX\r\n");
	fclose(ofp);
	return 0;
}

