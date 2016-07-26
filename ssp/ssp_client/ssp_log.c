/*
  get_data
    Opens a UDP socket for receiving data
    Opens TCP command connection to SSP board
    Issues the configuration command, informing the SSP board
      what UDP port to send data to
    Reads some quantity of data from the UDP port
    Issues the stop command

  Commands:
    NS:xxxx N_Samples
    NC:xxxx N_Coadd
    NA:xxxx N_Average
    UP:xxxxx UDP Port Number
    EN Enable
    DA Disable
    RS Return Status
  Return Values:
    200 OK
    500 Bad
*/
#include "ssp_get.h"
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <math.h>
#include <setjmp.h>
#include <stdint.h>
#include "ringdown.h"
#include "nortlib.h"
#include "mlf.h"

FILE *hdr_fp;

int verbosity = 1;
static int RD = 0;

/* If index == 0, this is a cleanup operation */
void move_lock( unsigned long index ) {
  static unsigned long prev_index;
  static int initialized = 0;
  char oldname[80], newname[80];
  
  sprintf( newname, LOGROOT "/ssp_%lu.lock", index == 0L ? prev_index+1 : index );
  if ( ! initialized ) {
    FILE *fp = fopen( newname, "w" );
    fprintf( fp, "lock file\n" );
    fclose(fp);
    initialized = 1;
  } else {
    sprintf( oldname, LOGROOT "/ssp_%lu.lock", prev_index );
    if ( index == 0 ) {
      unlink(oldname);
      unlink(newname);
      initialized = 0;
    } else {
      rename( oldname, newname );
    }
  }
  prev_index = index;
}

void cleanup(void) {
  unlink(PID_FILE);
  move_lock(0L);
  nl_error( 0, "cleanup" );
}

static sigjmp_buf env;

void sigint_handler(int sig) {
  siglongjmp(env,1);
}

static long int scan0 = 6, scan1;
// static long scan5 = 0l;
static int raw_length;

typedef struct {
  ssp_scan_header_t hdr;
  uint32_t idata[SSP_CLIENT_BUF_LENGTH-6];
} ssp_raw_scan;
  
static void output_scan( ssp_raw_scan *scan, mlf_def_t *mlf ) {
  int i, j;
  FILE *ofp;
  float fdata[SSP_MAX_CHANNELS][SSP_MAX_SAMPLES];
  time_t now;
  static time_t last_rpt = 0;
  float divisor = 1/(scan->hdr.NCoadd * (float)(scan->hdr.NAvg+1));
  int my_scan_length = scan->hdr.NSamples * scan->hdr.NChannels;

  // scan is guaranteed to be raw_length words long. Want to verify that NSamples*NChannels + NWordsHdr + 1 == raw_length
  if ( scan->hdr.NWordsHdr != scan0 ) {
    nl_error( 2, "NWordsHdr(%u) != %u", scan->hdr.NWordsHdr, scan0 );
    return;
  }
  if ( scan->hdr.FormatVersion > 1 ) {
    nl_error( 2, "Unsupported FormatVersion: %u", scan->hdr.FormatVersion );
    return;
  }
  if ( my_scan_length + 7 != raw_length ) {
    nl_error( 2, "Header reports NS:%u NC:%u -- raw_length is %d",
      scan->hdr.NSamples, scan->hdr.NChannels, raw_length );
    return;
  }
  ofp = mlf_next_file(mlf);
  now = time(NULL);

  for ( j = 0; j < scan->hdr.NChannels; ++j ) {
    for ( i = 0; i < scan->hdr.NSamples; ++i ) {
      fdata[j][i] = scan->idata[i * scan->hdr.NChannels + j] * divisor;
    }
  }
  if (RD) {
    fprintf( hdr_fp, "%ld %lu %u %u %u %u %u %u %u %u %u %lu %.4f %.4f %lu",
      now, mlf->index,
      scan->hdr.NWordsHdr, scan->hdr.FormatVersion, scan->hdr.NChannels, scan->hdr.NF,
      scan->hdr.NSamples, scan->hdr.NCoadd, scan->hdr.NAvg, scan->hdr.NSkL, scan->hdr.NSkP,
      scan->hdr.ScanNum, (scan->hdr.T_HtSink & 0xFFE0)/256.,
      (scan->hdr.T_FPGA>>3)/16., (uint32_t)scan->idata[raw_length-7] );
    for ( j = 0; j < scan->hdr.NChannels; ++j ) {
      Ringdown_t *rdf = ringdown_fit(&scan->hdr, fdata[0] + j*scan->hdr.NSamples);
      fprintf( hdr_fp, " %.3lf %.3lf %.4lf %.4lf", rdf->tau, rdf->dtau, rdf->b, rdf->a );
    }
    fprintf( hdr_fp, "\n" );
  } else {
    fprintf( hdr_fp, "%ld %lu %u %u %u %u %u %u %u %u %u %lu %.4f %.4f %lu\n",
      now, mlf->index,
      scan->hdr.NWordsHdr, scan->hdr.FormatVersion, scan->hdr.NChannels, scan->hdr.NF,
      scan->hdr.NSamples, scan->hdr.NCoadd, scan->hdr.NAvg, scan->hdr.NSkL, scan->hdr.NSkP,
      scan->hdr.ScanNum, (scan->hdr.T_HtSink & 0xFFE0)/256.,
      (scan->hdr.T_FPGA>>3)/16., (uint32_t)scan->idata[raw_length-7] );
  }
  fflush(hdr_fp);
  
  { uint32_t n_l;
    n_l = scan->hdr.NSamples;
    fwrite( &n_l, sizeof(uint32_t), 1, ofp );
    n_l = scan->hdr.NChannels;
    fwrite( &n_l, sizeof(uint32_t), 1, ofp );
  }

  fwrite( fdata, scan->hdr.NChannels*scan->hdr.NSamples*sizeof(float), 1, ofp );
  fclose(ofp);
  move_lock(mlf->index+1);
  if ( difftime(now, last_rpt) > 5 ) {
    nl_error( 0, "Recorded Scan %lu", mlf->index );
    last_rpt = now;
  }
  
  // Perform some sanity checks on the inbound scan
  //if ( (scan[1] & 0xFFFF00FF) != scan1 )
  //  nl_error( 1, "%lu: scan[1] = %08lX (not %08lX)\n", mlf->index, scan[1], scan1 );
  //if ( scan->hdr.FormatVersion == 0 && scan[5] != scan5 )
  //  nl_error( 1, "%lu: scan[5] = %08lX (not %08lX)\n", mlf->index, scan[5], scan5 );
}

static int32_t scan_buf[SSP_CLIENT_BUF_LENGTH];

int main( int argc, char **argv ) {
  char cmdbuf[80];
  int udp_port;
  int scan_length = 0;
  int NE = 0;
  int scan_size, n_channels;
  int RD_n_skip, RD_n_off;
  char *ssp_hostname;

  mlf_def_t *mlf = mlf_init( 3, 60, 1, LOGROOT, "dat", NULL );
  nl_error( 0, "SSP_CLIENT_BUF_LENGTH = %d", SSP_CLIENT_BUF_LENGTH );
  ssp_hostname = getenv("SSP_HOSTNAME");
  if ( ssp_hostname == 0 ) ssp_hostname = "10.0.0.200";
  else nl_error(0, "Addressing SSP %s", ssp_hostname );
  { FILE *fp = fopen( PID_FILE, "w" );
    if ( fp == 0 ) nl_error( 3, "Unable to write " PID_FILE );
    fprintf( fp, "%d\n", getpid() );
    fclose(fp);
  }
  hdr_fp = fopen( HDR_LOG, "a" );
  if ( hdr_fp == 0 ) nl_error( 3, "Unable to write " HDR_LOG );

  move_lock(1L);
  if ( sigsetjmp( env, 1 ) == 0 ) {
    int i;
    unsigned long index;
    
    atexit(cleanup);
    signal(SIGINT, sigint_handler);
    udp_port = udp_create();
    nl_error(0, "Opened UDP port %d", udp_port);
    // open TCP connection to SSP board
    tcp_create(ssp_hostname);
    // disable first, because no config commands can be send while enabled
    tcp_send( "DA\r\n" );
    // transmit the command including UDP socket number
    sprintf(cmdbuf, "NP:%d\r\n", udp_port );
    tcp_send(cmdbuf);
    for ( i = 1; i < argc; i++ ) {
      if (strncmp( argv[i], "RD:", 3 ) == 0 ) {
        char *ns = argv[i]+3;
        if ( ! isdigit((unsigned char)(*ns)) ) nl_error(3, "Expected digit after RD: argument" );
        RD_n_skip = atoi(ns);
        while (isdigit((unsigned char)(*ns))) ++ns;
        if ( *ns != ',' ) nl_error(3, "Expected comma after RD:## argument" );
        if ( ! isdigit((unsigned char)(*++ns)) ) nl_error(3, "Expected digit after RD:##, argument" );
        RD_n_off = atoi(ns);
        RD = 1;
      } else {
        sprintf( cmdbuf, "%s\r\n", argv[i] );
        if ( strncmp( cmdbuf, "NS:", 3 ) == 0 ) {
          scan_length = atoi(cmdbuf+3);
          if ( scan_length < 1 || scan_length > SSP_MAX_SAMPLES )
            nl_error( 3, "Invalid scan length: %d", scan_length );
        } else if ( strncmp( cmdbuf, "NE:", 3 ) == 0 ) {
          NE = atoi(cmdbuf+3);
          if ( NE < 1 || NE > 7 )
            nl_error( 3, "Invalid channel configuration: %d", NE );
        } else if ( strncmp( cmdbuf, "IX:", 3 ) == 0 ) {
          index = strtoul(cmdbuf+3, NULL, 10);
          mlf_set_index(mlf, index);
          move_lock(index);
          continue; // skip the send
        }
        tcp_send(cmdbuf);
      }
    }
    if ( scan_length == 0 ) {
      scan_length = 1024;
      sprintf(cmdbuf, "NS:%d\r\n", scan_length );
      nl_error( 0, "Setting scan_length to %d\n", scan_length );
      tcp_send(cmdbuf);
    }
    if ( NE == 0 ) {
      NE = 1;
      sprintf(cmdbuf, "NE:%d\r\n", NE );
      nl_error( 0, "Setting NE to %d\n", NE );
      tcp_send(cmdbuf);
    }
    switch ( NE ) {
      case 1: case 2: case 4: n_channels = 1; break;
      case 3: case 5: case 6: n_channels = 2; break;
      case 7: n_channels = 3; break;
      default: nl_error( 4, "Invalid NE configuration" );
    }
    if ( RD )
      ringdown_setup( RD_n_skip, RD_n_off );
    raw_length = (7 + scan_length*n_channels);
    scan_size = raw_length*sizeof(uint32_t);
    scan1 = (scan_length << 16) + n_channels;
    while (tcp_send("EN\r\n") == 503 ) sleep(1);
    tcp_close();
    
    int cur_word, scan_serial_number, frag_hold, scan_OK;
    cur_word = 0;
    scan_OK = 1;
    for (;;) {
      int n = udp_receive(scan_buf+cur_word,
        cur_word ? MAX_UDP_PAYLOAD : SSP_MAX_SCAN_SIZE);
      if ( n < 0 )
        nl_error( 2, "Error from udp_receive: %d", errno );
      else if ( cur_word == 0 && !(*scan_buf & SSP_FRAG_FLAG) ) {
        if ( n == scan_size ) output_scan((ssp_raw_scan *)scan_buf, mlf);
        else nl_error( mlf->index ? 2 : 1,
          "Expected %d bytes, received %d", scan_size, n );
      } else if ( !( scan_buf[cur_word] & SSP_FRAG_FLAG ) ) {
        nl_error( 2, "Expected scan fragment" );
      } else {
        int frag_hdr = scan_buf[cur_word];
        int frag_offset = frag_hdr & 0xFFFFL;
        int frag_sn;
        if ( frag_offset != cur_word ) {
          if ( frag_offset == 0 ) {
            memmove( scan_buf, scan_buf+cur_word, n );
            if ( scan_OK ) nl_error( 2, "Lost end of scan." );
            cur_word = 0;
            scan_OK = 1;
          } else if ( scan_OK ) {
            nl_error( 2, "Lost fragment" );
            scan_OK = 0;
          }
        }
        frag_sn = frag_hdr & 0x3FFF0000L;
        if ( cur_word == 0 ) scan_serial_number = frag_sn;
        else {
          scan_buf[cur_word] = frag_hold;
          if ( scan_OK && scan_serial_number != frag_sn ) {
            scan_OK = 0;
            nl_error( 2, "Lost data: SN skip" );
          }
        }
        cur_word = frag_offset + (n/sizeof(uint32_t)) - 1;
        if ( frag_hdr & SSP_LAST_FRAG_FLAG ) {
          if ( scan_OK ) {
            if ( cur_word == raw_length )
              output_scan( (ssp_raw_scan *)(scan_buf+1), mlf );
            else nl_error( 2, "Scan length error: expected %d words, received %d",
              raw_length, cur_word );
          }
          cur_word = 0;
          scan_OK = 1;
        } else {
          frag_hold = scan_buf[cur_word];
        }
        if ( cur_word + SSP_MAX_FRAG_LENGTH > SSP_CLIENT_BUF_LENGTH ) {
          nl_error( 2, "Bad fragment offset: %d(%d)", frag_offset, n );
          cur_word = 0;
          scan_OK = 1;
        }
      }
    }
  }
  nl_error( 0, "Normal exit" );
  // tcp_send("EX\r\n");
  return 0;
}
