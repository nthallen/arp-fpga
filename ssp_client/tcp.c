#include "udp_demo.h"

static int tcp_socket;

int tcp_create( char *hostname ) {

  int rc;
  struct sockaddr_in localAddr, servAddr;
  struct hostent *h;

  h = gethostbyname(hostname);
  if(h==NULL) {
    printf("Unknown host '%s'\n",hostname);
    exit(1);
  }

  servAddr.sin_family = h->h_addrtype;
  memcpy((char *) &servAddr.sin_addr.s_addr, h->h_addr_list[0], h->h_length);
  servAddr.sin_port = htons(SSP_SERVER_PORT);

  /* create socket */
  tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
  if (tcp_socket<0) {
    perror("cannot open socket ");
    exit(1);
  }

  /* bind any port number */
  localAddr.sin_family = AF_INET;
  localAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  localAddr.sin_port = htons(0);
  
  rc = bind(tcp_socket, (struct sockaddr *) &localAddr, sizeof(localAddr));
  if (rc<0) {
    printf("Cannot bind port TCP %u\n",SSP_SERVER_PORT);
    perror("error ");
    exit(1);
  }
				
  /* connect to server */
  rc = connect(tcp_socket, (struct sockaddr *) &servAddr, sizeof(servAddr));
  if (rc<0) {
    perror("cannot connect ");
    exit(1);
  }
  return 0;
}

// tcp_send() sends the specified command, then waits for a response,
// which should be an ascii-encoded integer. It returns the value.
int tcp_send( char * cmd ) {
	char recv_buf[RECV_BUF_SIZE];
	int rv, i;
	int cmdlen = strlen(cmd);
	rv = send( tcp_socket, cmd, cmdlen, 0);
	if ( rv != cmdlen ) {
		fprintf(stderr, "Send failed: %d: errno = %d\n", rv, errno );
		exit(1);
	}
	rv = recv( tcp_socket, recv_buf, RECV_BUF_SIZE, 0 );
	if ( rv <= 0 ) {
		fprintf(stderr, "Recv returned %d\n", rv );
		return -1;
	} else {
		int rnum = 0;
		for ( i = 0; i < rv && isdigit(recv_buf[i]); i++ ) {
			rnum = rnum*10 + recv_buf[i] - '0';
		}
		return rnum;
	}
}
