#include <stdlib.h>
#include "ssp_get.h"

static int udp_socket;

int udp_create(void) {
  struct sockaddr_in servAddr;
  int port, rc;
  socklen_t servAddr_len = sizeof(servAddr);

  /* socket creation */
  udp_socket=socket(AF_INET, SOCK_DGRAM, 0);
  if (udp_socket<0) {
    printf("Cannot open UDP socket \n");
    exit(1);
  }

  /* bind local server port */
  servAddr.sin_family = AF_INET;
  servAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  servAddr.sin_port = htons(0);
  rc = bind (udp_socket, (struct sockaddr *) &servAddr,sizeof(servAddr));
  if(rc<0) {
    printf("cannot bind port number %d \n",  0);
    exit(1);
  }
  rc = getsockname( udp_socket, (struct sockaddr *)&servAddr,
    &servAddr_len);
  port = ntohs(servAddr.sin_port);
  printf("UDP port is %d\n", port );
  fflush(stdout);
  return port;
}

int udp_receive(uint32_t *scan, size_t length ) {
    struct sockaddr_in cliAddr;
  	int n, cliLen;

    cliLen = sizeof(cliAddr);
    n = recvfrom(udp_socket, scan, length, 0, 
		 (struct sockaddr *) &cliAddr, &cliLen);
     return n;
}
