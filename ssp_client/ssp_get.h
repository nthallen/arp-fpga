#ifndef ssp_get_h_included
#define ssp_get_h_included
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <unistd.h> /* close() */
#include <string.h> /* memset() */
#include <errno.h>
#include <ctype.h>

extern int udp_create(void);
extern int udp_receive(unsigned long int *scan );
extern int tcp_create(char *hostname);
extern int tcp_send( char * cmd );
#define SSP_SERVER_PORT 1500
#define RECV_BUF_SIZE 80
#define UDP_MAX_MSG (4096*4)
extern int verbosity;

#endif
