#ifndef ssp_get_h_included
#define ssp_get_h_included

#include <sys/types.h>
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
#include <stdint.h>
#include "ssp_ad.h"

extern int udp_create(void);
extern int udp_receive(uint32_t *scan, size_t length );
extern int tcp_create(char *hostname);
extern int tcp_send( char * cmd );
extern int tcp_close(void);

#define RECV_BUF_SIZE SSP_MAX_CTRL_MSG

extern int verbosity;
/*
#define LOGROOT "CPCI14"
#define PID_FILE LOGROOT "/ssp_log.pid"
#define HDR_LOG LOGROOT "/ssp.log"
*/

#endif
