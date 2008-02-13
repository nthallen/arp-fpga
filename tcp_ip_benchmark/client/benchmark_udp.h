#ifndef BENCHMARK_UDP_H_INCLUDED
#define BENCHMARK_UDP_H_INCLUDED
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
extern int udp_receive(char *scan );
#define UDP_MAX_MSG (4096*4)
#define SSP_SERVER_PORT 1500
#define RECV_BUF_SIZE 80

#endif
