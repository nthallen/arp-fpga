#include <sys/types.h>
#include <time.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> /* close() */
#include <string.h> /* memset() */
#include <errno.h>
#include <ctype.h>
#include "nortlib.h"
#include "benchmark_udp.h"


static int tcp_socket;
static int verbosity = 0;

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

int tcp_close(void) {
  close(tcp_socket);
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
    fprintf(stderr, "Recv returned %d errno %d cmd='%s'\n", rv, errno, cmd );
    return -1;
  } else {
    int rnum = 0;
    for ( i = 0; i < rv && isdigit(recv_buf[i]); i++ ) {
      rnum = rnum*10 + recv_buf[i] - '0';
    }
    if ( verbosity )
      printf("tcp_send: returning %d, %d from command %s", rv, rnum, cmd );
    return rnum;
  }
}


void run_set( int nb, int nr ) {
  char cmdbuf[80];
  char recv_buf[UDP_MAX_MSG];
  int nbs, rv, i;
  struct timeval t0, t1;
  double duration, Kbps;

  nl_error( 0, "Running set %d %d", nb, nr );
  if ( nb > UDP_MAX_MSG )
    nl_error( 4, "nb(%d) > UDP_MAX_MSG(%d)", nb, UDP_MAX_MSG );
  nbs = sprintf( cmdbuf, "%d %d\n\r", nb, nr+1 );
  rv = tcp_send( cmdbuf );
  if (rv != 200) nl_error( 3, "tcp_send returned %d", rv );
  rv = udp_receive( recv_buf );
  if ( rv < nb ) {
    nl_error( 3, "Received %d, expected %d\n", rv, nb );
  } else if ( rv > nb )
    nl_error( 3, "First packet is larger than expected: %d > %d\n", rv, nb );
  // nl_error( 0, "Received first packet\n" );
  // start timing
  gettimeofday(&t0, NULL);
  for ( i = 0; i < nr; i++ ) {
    rv = udp_receive( recv_buf );
    if ( rv != nb )
      nl_error( 3, "Expected %d: Received %d\n", nb, rv );
    //fputc('.', stderr); fflush(stderr);
  }
  //fputc('\n', stderr); fflush(stderr);
  // stop timing
  gettimeofday(&t1, NULL);
  duration = t1.tv_sec - t0.tv_sec + (t1.tv_usec-t0.tv_usec)*1e-6;
  Kbps = (1e-3*nb*nr*8.0)/duration;
  printf( "%d %d %.3lf %.3lf\n", nb, nr, duration, Kbps );
}

int main( int argc, char **argv ) {
  int nb, nr, total;
  int udp_port;
  char cmdbuf[80];
  // FILE *ofp;
  // int scan_length;
  // char *dumpfile = NULL;

  // open TCP connection to SSP board
  if ( argc > 1 ) {
    total = atoi(argv[1]);
  } else total = 40000;
  // printf("Total transmission per test will be %d bytes\n", total);
  tcp_create("10.0.0.200");
  udp_port = udp_create();
	nl_error( 0, "Attached to UDP port %d", udp_port );
  sprintf( cmdbuf, "U%d\r\n", udp_port );
  tcp_send(cmdbuf);
  for ( nb = 32; nb <= 8*1472;  nb = (nb * 5) / 4 ) {
    nr = (total+nb-1)/nb;
    if ( nr > 20 ) nr = 20;
    run_set( nb, nr );
  }
  tcp_close();
  nl_error( 0, "Finished" );
  return 0;
}
