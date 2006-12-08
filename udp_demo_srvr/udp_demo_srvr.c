#include "udp_demo_srvr.h"

int main(int argc, char *argv[]) {
	// listen on TCP port SSP_SERVER_PORT
	tcp_init();
	while ( !app_done ) {
		if ( udp_enabled ) udp_send();
		tcp_read_cmd( udp_enabled );
	}
	return 0;
}
