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

int main( int argc, char **argv ) {
	int udp_port = udp_create();
	printf("Opened UDP port %d\n", udp_port);
  // open TCP connection to SSP board
  tcp_create();
  // transmit the command including UDP socket number
  // read a bunch of scans
  // send DA command
}

