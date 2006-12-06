#include "udp_demo.h"

#define MAX_MSG (4096*4)

static int udp_socket;

int udp_create(void) {
  struct sockaddr_in servAddr;
  int port, rc;

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
  port = ntohs(servAddr.sin_port);
  return port;
}

int udp_receive(void) {
    struct sockaddr_in cliAddr;
	char msg[MAX_MSG];
	int n, cliLen;

    cliLen = sizeof(cliAddr);
    n = recvfrom(udp_socket, msg, MAX_MSG, 0, 
		 (struct sockaddr *) &cliAddr, &cliLen);

    return n;
}
