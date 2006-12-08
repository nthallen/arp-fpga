#include "udp_demo_srvr.h"

int udp_enabled = 0;
int app_done = 0;
int udp_port = 0;
static int tcp_socket, cur_socket;
static struct sockaddr_in udpCliAddr, udpSrvrAddr;
static int udp_socket;
static unsigned long scan[SCAN_LENGTH];

static void scan_init( void ) {
  int tz = SCAN_LENGTH/20;
  int ramp = SCAN_LENGTH - 2*tz;
  double b = RAMP_MAX/(ramp * (double) ramp);
  int i;
  for ( i = 0; i < SCAN_LENGTH; i++ ) {
  	scan[i] = 0l;
  }
  for ( i = 0; i < ramp; i++ ) {
  	double dx = i - ramp;
  	scan[tz+i] = RAMP_MAX - b * dx * dx;
  }
}

// Returns non-zero on error
int tcp_init( void ) {
   struct sockaddr_in servAddr;

   /* create socket */
   scan_init();
   udp_socket = -1;
   tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
   if(tcp_socket<0) {
      perror("cannot open socket ");
      return 1;
  }

  /* bind server port */
  servAddr.sin_family = AF_INET;
  servAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  servAddr.sin_port = htons(SSP_SERVER_PORT);
  
  if(bind(tcp_socket, (struct sockaddr *) &servAddr, sizeof(servAddr))<0) {
    perror("cannot bind port ");
    return 1;
  }

  if ( listen(tcp_socket,5) < 0 ) {
  	perror("listen failed ");
  	return 1;
  }
  cur_socket = -1;
  printf("Listening on port %d\n", SSP_SERVER_PORT );
  return 0;
}

/*
  get_data
    Opens a UDP socket for receiving data
    Opens TCP command connection to SSP board
    Issues the configuration command, informing the SSP board
      what UDP port to send data to
    Reads some quantity of data from the UDP port
    Issues the stop command

  Commands:
    EN Enable
    DA Disable
    EX Quit
    NS:xxxx N_Samples
    NC:xxxx N_Coadd
    UP:xxxxx UDP Port Number
    RS Return Status
  Return Values:
    200 OK
    500 Bad
*/
static int parse_cmds( char *cmd ) {
	if ( cmd[0] == 'E' ) {
		if ( cmd[1] == 'N' ) {
			udp_enabled = 1;
			printf("Transfers Enabled\n");
			fflush(stdout);
			return 0;
		} else if ( cmd[1] == 'X' ) {
			app_done = 1;
			printf("\nReceived Exit\n");
			fflush(stdout);
			return 0;
		}
	} else if ( cmd[0] == 'D' ) {
		if ( cmd[1] == 'A' ) {
			udp_enabled = 0;
			printf("\nReceived Disable\n");
			fflush(stdout);
			return 0;
		}
	} else if ( cmd[0] == 'U' && cmd[1] == 'P' && cmd[2] == ':' ) {
		udp_port = atoi(cmd+3);
		printf("Setting UDP port to %d\n", udp_port );
		return 0;
	}
	return 1;
}

// enable = tcp_read_cmd( wait );
// Reads and processes commands.
// Returns true if the circuit is enabled
static char rcv_msg[MAX_MSG+1];
int tcp_read_cmd( int nowait ) {
	int cliLen, n;
	struct sockaddr_in cliAddr;
	if ( cur_socket < 0 ) {
		cliLen = sizeof(cliAddr);
		// Set tcp_socket as non-blocking if !wait
		fcntl( tcp_socket, F_SETFL, nowait ? O_NONBLOCK : 0);
		cur_socket = accept(tcp_socket, (struct sockaddr *) &cliAddr, &cliLen);
		if ( cur_socket<0 ) {
			if ( errno == EWOULDBLOCK ) return udp_enabled;
		  perror("cannot accept connection ");
		  exit(1);
		} else {
 			memcpy((char *)&udpSrvrAddr, (char *)&cliAddr,
 			  sizeof(cliAddr) );
		}
	}
	fcntl(cur_socket, F_SETFL, O_RDWR | (nowait ? O_NONBLOCK : 0 ));
	n = recv(cur_socket, rcv_msg, MAX_MSG, 0);
	if ( n < 0 ) {
		if (errno != EWOULDBLOCK) {
			close(cur_socket);
			cur_socket = -1;
		}
	}
	if ( n > MAX_MSG ) {
		fprintf(stderr, "Overflow!");
		exit(1);
	}
	if ( n > 0 ) {
		int rv;
		rcv_msg[n] = '\0';
		rv = parse_cmds(rcv_msg);
		itoa(rv, rcv_msg, 10);
		rv = strlen(rcv_msg);
		rcv_msg[rv++] = '\r';
		rcv_msg[rv++] = '\n';
		rcv_msg[rv++] = '\0';
		rv = send( cur_socket, rcv_msg, rv, 0 );
	}
	return udp_enabled;
}

void udp_send( void ) {
	int rc;
	if ( udp_socket < 0 ) {
		/* socket creation */
		udp_socket = socket(AF_INET,SOCK_DGRAM,0);
		if ( udp_socket < 0 ) {
		    printf("cannot open udp socket\n");
		    exit(1);
		}

	    /* get server IP address (no check if input is IP address or DNS name */
		// Send back to the same client:
		udpSrvrAddr.sin_port = htons(udp_port);
 
		/* bind any port */
		udpCliAddr.sin_family = AF_INET;
		udpCliAddr.sin_addr.s_addr = htonl(INADDR_ANY);
		udpCliAddr.sin_port = htons(0);
  
        rc = bind(udp_socket, (struct sockaddr *) &udpCliAddr, sizeof(udpCliAddr));
        if ( rc<0 ) {
		    printf("cannot bind UDP port\n");
		    exit(1);
		}
	}

    rc = sendto(udp_socket, scan, sizeof(scan), 0, 
		(struct sockaddr *) &udpSrvrAddr, 
		sizeof(udpSrvrAddr));

    if ( rc<0 ) {
      fprintf(stderr, "cannot send data: %s\n", strerror(errno));
      close(udp_socket);
      udp_socket = -1;
      exit(1);
    }
}
