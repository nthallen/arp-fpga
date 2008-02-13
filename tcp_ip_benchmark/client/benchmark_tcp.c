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

#define SSP_SERVER_PORT 1500

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

int tcp_close(void) {
  close(tcp_socket);
  return 0;
}

#define RECV_BUF_SIZE 16384

void run_set( int nb, int nr ) {
  char cmdbuf[80];
  char recv_buf[RECV_BUF_SIZE];
  int nbs, rv, nb_rem, total_bytes;
  struct timeval t0, t1;
  double duration, Kbps;

  nl_error( 0, "Running set %d %d", nb, nr );
  if ( nb > RECV_BUF_SIZE )
    nl_error( 4, "nb(%d) > RECV_BUF_SIZE(%d)", nb, RECV_BUF_SIZE );
  nbs = sprintf( cmdbuf, "%d %d\n\r", nb, nr+1 );
  rv = send( tcp_socket, cmdbuf, nbs, 0);
  if (rv != nbs) nl_error( 3, "Sent %d, rv = %d", nbs, rv );
  nb_rem = (nr+1) * nb;
  rv = recv( tcp_socket, recv_buf, RECV_BUF_SIZE, 0 );
  if ( rv < 0 )
    nl_error( 3, "Received error in first packet\n" );
  nb_rem -= rv;
    //nl_error( 0, "Received first packet\n" );
  // start timing
  total_bytes = nb_rem;
  gettimeofday(&t0, NULL);
  while ( nb_rem > 0 ) {
    rv = recv( tcp_socket, recv_buf, RECV_BUF_SIZE, 0 );
    fputc('.',stderr); fflush(stderr);
    if ( rv < 0 )
      nl_error( 3, "Received error from recv\n" );
    else if ( rv > nb_rem )
      nl_error( 3, "More data than expected\n" );
    nb_rem -= rv;
  }
  fputc('\n', stderr); fflush(stderr);
  // stop timing
  gettimeofday(&t1, NULL);
  duration = t1.tv_sec - t0.tv_sec + (t1.tv_usec-t0.tv_usec)*1e-6;
  Kbps = (1e-3*total_bytes*8.0)/duration;
  printf( "%d %d %.3lf %.3lf\n", nb, nr, duration, Kbps );
}

int main( int argc, char **argv ) {
  int nb, nr, total;
  // FILE *ofp;
  // int scan_length;
  // char *dumpfile = NULL;

  // open TCP connection to SSP board
  if ( argc > 1 ) {
    total = atoi(argv[1]);
  } else total = 40000;
  printf("Total transmission per test will be %d bytes\n", total);
  tcp_create("10.0.0.200");
  // run_set( 128, 30 );
  // run_set( 256, 30 );
  // run_set( 512, 15 );
  // run_set( 1024, 5 );
  // run_set( 1200, 0 );
  //run_set( 1500, 0 );
  // run_set( 1800, 5 );
  // run_set( 2048, 5 );
  // run_set( 4096, 5 );
  for ( nb = 32; nb <= 8*1472;  nb = (nb * 5) / 4 ) {
  //for ( nb = 1024; nb >= 512; nb = (nb * 8) / 10 ) {
    nr = (total+nb-1)/nb;
    if ( nr > 400 ) nr = 400;
    run_set( nb, nr );
  }
  tcp_close();
  nl_error( 0, "Finished" );
  return 0;
}
