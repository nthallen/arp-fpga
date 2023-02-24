/*
  ssp_sim.c
    Simulates the ssp_log functionality without an ssp board.
    Generates ringdown data with noise.

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
#include "ringdown.h"
#include "nl.h"
#include "mlf.h"
#include "nl_assert.h"

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
  msg( 0, "cleanup" );
}

static sigjmp_buf env;

void sigint_handler(int sig) {
  siglongjmp(env,1);
}

static long int scan0 = 6, scan1, scan5 = 0l;
static int raw_length;

typedef struct {
  ssp_scan_header_t hdr;
  long int idata[SSP_CLIENT_BUF_LENGTH-6];
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
    msg( 2, "NWordsHdr(%u) != %u", scan->hdr.NWordsHdr, scan0 );
    return;
  }
  if ( scan->hdr.FormatVersion > 1 ) {
    msg( 2, "Unsupported FormatVersion: %u", scan->hdr.FormatVersion );
    return;
  }
  if ( my_scan_length + 7 != raw_length ) {
    msg( 2, "Header reports NS:%u NC:%u -- raw_length is %d",
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
      (scan->hdr.T_FPGA>>3)/16., (unsigned long)scan->idata[raw_length-7] );
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
      (scan->hdr.T_FPGA>>3)/16., (unsigned long)scan->idata[raw_length-7] );
  }
  fflush(hdr_fp);
  
  { unsigned long n_l;
    n_l = scan->hdr.NSamples;
    fwrite( &n_l, sizeof(unsigned long), 1, ofp );
    n_l = scan->hdr.NChannels;
    fwrite( &n_l, sizeof(unsigned long), 1, ofp );
  }

  fwrite( fdata, scan->hdr.NChannels*scan->hdr.NSamples*sizeof(float), 1, ofp );
  fclose(ofp);
  move_lock(mlf->index+1);
  if ( difftime(now, last_rpt) > 5 ) {
    msg( 0, "Recorded Scan %lu", mlf->index );
    last_rpt = now;
  }
  
  // Perform some sanity checks on the inbound scan
  //if ( (scan[1] & 0xFFFF00FF) != scan1 )
  //  msg( 1, "%lu: scan[1] = %08lX (not %08lX)\n", mlf->index, scan[1], scan1 );
  //if ( scan->hdr.FormatVersion == 0 && scan[5] != scan5 )
  //  msg( 1, "%lu: scan[5] = %08lX (not %08lX)\n", mlf->index, scan[5], scan5 );
}

double gasdev(void) {
  static int iset = 0;
  static double gset;
  double fac, rsq, v1, v2;
  
  if (iset==0) {
    do {
      v1 = 2.0*drand48() - 1.0;
      v2 = 2.0*drand48() - 1.0;
      rsq = v1*v1+v2*v2;
    } while (rsq >= 1.0 || rsq == 0.0);
    fac = sqrt(-2.0*log(rsq)/rsq);
    gset = v1 * fac;
    iset = 1;
    return v2 * fac;
  } else {
    iset = 0;
    return gset;
  }
}

/* Generate ringdowns. Start with:
    tau = 15 usec
    A = 6000
    Z = -3000
    N = .02
    y = A * (exp(-t/tau) + N * (drand48()-.5))
    t = i*dt = (i * NF / 100 ) usec
 */
int sim_scan( ssp_scan_header_t *hdr, long int *scan_buf, unsigned long def_status ) {
  double A = 40000.;
  double Z = -20000.;
  double N = .02;
  double tau = 15.; // usecs
  double dt = hdr->NF/100.; // usecs
  static unsigned long ScanNum = 0;
  int chan;
  int scan_words = hdr->NWordsHdr + hdr->NSamples*hdr->NChannels + 1;
  nl_assert( hdr->NChannels <= SSP_MAX_CHANNELS);
  nl_assert( hdr->NSamples <= SSP_MAX_SAMPLES);
  nl_assert( hdr->NCoadd <= SSP_MAX_COADD );
  nl_assert( hdr->NAvg+1 < SSP_MAX_PREADD );
  hdr->ScanNum = ++ScanNum;
  memcpy(scan_buf, hdr, hdr->NWordsHdr * sizeof(long));
  // Initialize the buffers to zero
  memset(&scan_buf[hdr->NWordsHdr], 0, hdr->NSamples * hdr->NChannels * sizeof(long));
  for ( chan = 0; chan < hdr->NChannels; ++chan ) {
    int NC = hdr->NChannels;
    int sample, avg, coadd;
    for ( coadd = 0; coadd < hdr->NCoadd; ++coadd ) {
      long int *scan = &scan_buf[hdr->NWordsHdr + chan];
      double t = 0.;
      for ( sample = 0; sample < hdr->NSamples; ++sample ) {
        for ( avg = 0; avg <= hdr->NAvg; ++avg ) {
          double y = A * ( exp( - t/tau ) + N * (gasdev())) + Z;
          if ( y > 32767. || y < -32768) {
            // record adovf
          }
          long ly = (long) floor(y);
          *scan += ly; // check for ovf
          t += dt;
        }
        scan += NC;
      }
    }
    tau -= 2.;
  }
  scan_buf[scan_words - 1] = def_status;
  usleep( 1000000L/5000 );
  return(scan_words * sizeof(long));
}

static long int scan_buf[SSP_CLIENT_BUF_LENGTH];

int main( int argc, char **argv ) {
  char cmdbuf[80];
  int scan_length = 0;
  int NE = 0;
  int scan_size, n_channels;
  int RD_n_skip, RD_n_off;
  ssp_scan_header_t hdr;
  unsigned long def_status = 0;

  hdr.NWordsHdr = 6;
  hdr.FormatVersion = 1;
  hdr.NSkL = 0;
  hdr.NSkP = 0;
  hdr.T_HtSink = (unsigned short)(floor(30.3 * 8)) <<5;
  hdr.T_FPGA = (unsigned short)(floor(30.5 * 16)) << 3;
  mlf_def_t *mlf = mlf_init( 3, 60, 1, LOGROOT, "dat", NULL );
  msg( 0, "SSP_CLIENT_BUF_LENGTH = %d", SSP_CLIENT_BUF_LENGTH );
  { FILE *fp = fopen( PID_FILE, "w" );
    if ( fp == 0 ) msg( 3, "Unable to write " PID_FILE );
    fprintf( fp, "%d\n", getpid() );
    fclose(fp);
  }
  hdr_fp = fopen( HDR_LOG, "a" );
  if ( hdr_fp == 0 ) msg( 3, "Unable to write " HDR_LOG );

  move_lock(1L);
  if ( sigsetjmp( env, 1 ) == 0 ) {
    int i;
    unsigned long index;
    
    atexit(cleanup);
    signal(SIGINT, sigint_handler);
    srand48(1);
    for ( i = 1; i < argc; i++ ) {
      if (strncmp( argv[i], "RD:", 3 ) == 0 ) {
        char *ns = argv[i]+3;
        if ( ! isdigit((unsigned char)(*ns)) ) msg(3, "Expected digit after RD: argument" );
        RD_n_skip = atoi(ns);
        while (isdigit((unsigned char)(*ns))) ++ns;
        if ( *ns != ',' ) msg(3, "Expected comma after RD:## argument" );
        ++ns;
        if ( ! isdigit((unsigned char)(*ns)) )
          msg(3, "Expected digit after RD:##, argument: '%c' in '%s'", *ns, argv[i] );
        RD_n_off = atoi(ns);
        RD = 1;
      } else {
        sprintf( cmdbuf, "%s\r\n", argv[i] );
        if ( strncmp( cmdbuf, "NS:", 3 ) == 0 ) {
          scan_length = atoi(cmdbuf+3);
          if ( scan_length < 1 || scan_length > SSP_MAX_SAMPLES )
            msg( 3, "Invalid scan length: %d", scan_length );
          hdr.NSamples = scan_length;
        } else if ( strncmp( cmdbuf, "NE:", 3 ) == 0 ) {
          NE = atoi(cmdbuf+3);
          if ( NE < 1 || NE > 7 )
            msg( 3, "Invalid channel configuration: %d", NE );
        } else if ( strncmp( cmdbuf, "IX:", 3 ) == 0 ) {
          index = strtoul(cmdbuf+3, NULL, 10);
          mlf_set_index(mlf, index);
          move_lock(index);
          continue; // skip the send
        } else if ( strncmp( cmdbuf, "NF:", 3 ) == 0 ) {
          int NF = atoi(cmdbuf+3);
          if ( NF < 0 || NF >= 32 )
            msg( 3, "Invalid divisor: %d", NF );
          hdr.NF = NF;
        } else if ( strncmp( cmdbuf, "NC:", 3 ) == 0 ) {
          int NC = atoi(cmdbuf+3);
          if ( NC < 0 || NC > SSP_MAX_COADD )
            msg( 3, "Invalid NC: %d", NC );
          hdr.NCoadd = NC;
        } else if ( strncmp( cmdbuf, "NA:", 3 ) == 0 ) {
          int NA = atoi(cmdbuf+3);
          if ( NA <= 0 || NA > SSP_MAX_PREADD )
            msg( 3, "Invalid NA: %d", NA );
          hdr.NAvg = NA - 1;
        } else if (  strncmp( cmdbuf, "NT:", 3 ) == 0 ) {
          int NT = atoi(cmdbuf+3);
          if ( NT < 0 || NT > 3 )
            msg( 3, "Invalid NT: %d", NT );
          def_status = (def_status & ~SSP_STATUS_NT_MASK) |
            ( NT << SSP_STATUS_NT_LSB );
        } else if ( strncmp( cmdbuf, "NU:", 3 ) == 0 ) {
          def_status = def_status | SSP_STATUS_TR;
        } else if ( strncmp( cmdbuf, "ND:", 3 ) == 0 ) {
          def_status = def_status & ~SSP_STATUS_TR;
        } else if ( strncmp( cmdbuf, "AE", 2 ) == 0 ) {
          def_status = def_status | SSP_STATUS_AE;
        }
        // tcp_send(cmdbuf);
      }
    }
    if ( scan_length == 0 ) {
      scan_length = 1024;
      msg( 0, "Setting scan_length to %d\n", scan_length );
      // sprintf(cmdbuf, "NS:%d\r\n", scan_length );
      // tcp_send(cmdbuf);
    }
    if ( NE == 0 ) {
      NE = 1;
      msg( 0, "Setting NE to %d\n", NE );
      // sprintf(cmdbuf, "NE:%d\r\n", NE );
      // tcp_send(cmdbuf);
    }
    def_status = (def_status & ~SSP_STATUS_NE_MASK) |
      (NE << SSP_STATUS_NE_LSB);
    switch ( NE ) {
      case 1: case 2: case 4: n_channels = 1; break;
      case 3: case 5: case 6: n_channels = 2; break;
      case 7: n_channels = 3; break;
      default: msg( 4, "Invalid NE configuration" );
    }
    hdr.NChannels = n_channels;
    if ( RD )
      ringdown_setup( RD_n_skip, RD_n_off );
    raw_length = (7 + scan_length*n_channels);
    scan_size = raw_length*sizeof(long);
    scan1 = (scan_length << 16) + n_channels;
    // while (tcp_send("EN\r\n") == 503 ) sleep(1);
    // tcp_close();
    
    int cur_word, scan_serial_number, frag_hold, scan_OK;
    cur_word = 0;
    scan_OK = 1;
    for (;;) {
      // int n = udp_receive(scan_buf+cur_word,
      //   cur_word ? MAX_UDP_PAYLOAD : SSP_MAX_SCAN_SIZE);
      int n = sim_scan( &hdr, scan_buf, def_status );
      if ( n < 0 )
        msg( 2, "Error from udp_receive: %d", errno );
      else if ( cur_word == 0 && !(*scan_buf & SSP_FRAG_FLAG) ) {
        if ( n == scan_size ) output_scan((ssp_raw_scan *)scan_buf, mlf);
        else msg( mlf->index ? 2 : 1,
          "Expected %d bytes, received %d", scan_size, n );
      } else if ( !( scan_buf[cur_word] & SSP_FRAG_FLAG ) ) {
        msg( 2, "Expected scan fragment" );
      } else {
        int frag_hdr = scan_buf[cur_word];
        int frag_offset = frag_hdr & 0xFFFFL;
        int frag_sn;
        if ( frag_offset != cur_word ) {
          if ( frag_offset == 0 ) {
            memmove( scan_buf, scan_buf+cur_word, n );
            if ( scan_OK ) msg( 2, "Lost end of scan." );
            cur_word = 0;
            scan_OK = 1;
          } else if ( scan_OK ) {
            msg( 2, "Lost fragment" );
            scan_OK = 0;
          }
        }
        frag_sn = frag_hdr & 0x3FFF0000L;
        if ( cur_word == 0 ) scan_serial_number = frag_sn;
        else {
          scan_buf[cur_word] = frag_hold;
          if ( scan_OK && scan_serial_number != frag_sn ) {
            scan_OK = 0;
            msg( 2, "Lost data: SN skip" );
          }
        }
        cur_word = frag_offset + (n/sizeof(long)) - 1;
        if ( frag_hdr & SSP_LAST_FRAG_FLAG ) {
          if ( scan_OK ) {
            if ( cur_word == raw_length )
              output_scan( (ssp_raw_scan *)(scan_buf+1), mlf );
            else msg( 2, "Scan length error: expected %d words, received %d",
              raw_length, cur_word );
          }
          cur_word = 0;
          scan_OK = 1;
        } else {
          frag_hold = scan_buf[cur_word];
        }
        if ( cur_word + SSP_MAX_FRAG_LENGTH > SSP_CLIENT_BUF_LENGTH ) {
          msg( 2, "Bad fragment offset: %d(%d)", frag_offset, n );
          cur_word = 0;
          scan_OK = 1;
        }
      }
    }
  }
  msg( 0, "Normal exit" );
  // tcp_send("EX\r\n");
  return 0;
}
