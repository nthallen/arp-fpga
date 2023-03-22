#ifndef SSP_AD_H_INCLUDED
#define SSP_AD_H_INCLUDED
#include <stdint.h>

#define SSP_MAX_SAMPLES 4096
#define SSP_MAX_PREADD 256
#define SSP_MAX_COADD 16383
#define SSP_MAX_CHANNELS 3
#define SSP_MAX_NE ((1<<SSP_MAX_CHANNELS)-1)
#define SSP_NE_LSB 5
#define SSP_NE_MASK (SSP_MAX_NE<<SSP_NE_LSB)
#define SSP_TRIG_RISING 0x8
#define SSP_TRIG_AE 0x10
#define SSP_TRIG_SRC_MASK 0x6
#define SSP_TRIG_SRC_LSB 1
#define SSP_TRIG_SRC_MAX 3
#define SSP_TRIG_MASK (SSP_TRIG_SRC_MASK|SSP_TRIG_AE|SSP_TRIG_RISING)
#define SSP_RESET_MASK 1
#define SSP_CONTROL_MASK 0xFF
#define SSP_STATUS_NE_LSB 9
#define SSP_STATUS_NE_MASK (7<<SSP_STATUS_NE_LSB)
#define SSP_STATUS_NT_LSB 12
#define SSP_STATUS_NT_MASK (3<<SSP_STATUS_NT_LSB)
#define SSP_STATUS_TR 0x4000
#define SSP_STATUS_AE 0x8000

#define SSP_MAX_SCAN_LENGTH (7+SSP_MAX_CHANNELS*SSP_MAX_SAMPLES)
#define SSP_MAX_SCAN_SIZE (SSP_MAX_SCAN_LENGTH*sizeof(int32_t))
#define SSP_SERVER_PORT 1500
#define SSP_MAX_CTRL_MSG 80

typedef struct {
  uint16_t NWordsHdr;
  uint16_t FormatVersion;
  uint8_t  NChannels;
  uint8_t  NF;
  uint16_t NSamples;
  uint16_t NCoadd;
  uint16_t NAvg;
  uint16_t NSkL;
  uint16_t NSkP;
  uint32_t ScanNum;
  int16_t  T_HtSink;
  int16_t  T_FPGA;
} __attribute__((packed)) ssp_scan_header_t;

#define MAX_UDP_PAYLOAD 1472
#define SSP_MAX_FRAG_PAYLOAD (MAX_UDP_PAYLOAD-sizeof(int32_t))
#define SSP_MAX_FRAG_LENGTH (SSP_MAX_FRAG_PAYLOAD/sizeof(int32_t))
#define SSP_FRAG_FLAG 0x80000000L
#define SSP_LAST_FRAG_FLAG 0x40000000L
#define SSP_MAX_FRAGS ((SSP_MAX_SCAN_SIZE+SSP_MAX_FRAG_PAYLOAD-1)/SSP_MAX_FRAG_PAYLOAD)
#define SSP_CLIENT_BUF_LENGTH (SSP_MAX_FRAGS * SSP_MAX_FRAG_LENGTH + 1)

#endif
