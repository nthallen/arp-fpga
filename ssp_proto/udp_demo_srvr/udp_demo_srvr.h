#ifndef udp_demo_srvr_h_included
#define udp_demo_srvr_h_included
#include <sys/types.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <unistd.h> /* close() */
#include <string.h> /* memset() */
#include <errno.h>
#include <ctype.h>
#include <stdlib.h>

#define SSP_SERVER_PORT 1500
#define MAX_MSG 80
#define SCAN_LENGTH 1207
#define RAMP_MAX 60000.
extern int udp_enabled;
extern int app_done;
extern int tcp_init( void );
extern int tcp_read_cmd( int wait );
extern void udp_send( void );

#endif
