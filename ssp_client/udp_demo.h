#ifndef udp_demo_h_included
#define udp_demo_h_included
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <unistd.h> /* close() */
#include <string.h> /* memset() */

extern int udp_create(void);
extern int udp_receive(void);
extern int tcp_create(void);
#define SSP_SERVER_PORT 1500

#endif
