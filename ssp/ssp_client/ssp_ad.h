#ifndef SSP_AD_H_INCLUDED
#define SSP_AD_H_INCLUDED

#define SSP_MAX_SAMPLES 4096
#define SSP_MAX_PREADD 5
#define SSP_MAX_COADD 7
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
#define SSP_CONTROL_MASK 0x3F

#define SSP_MAX_SCAN_LENGTH (7+SSP_MAX_CHANNELS*SSP_MAX_SAMPLES)
#define SSP_MAX_SCAN_SIZE (SSP_MAX_SCAN_LENGTH*sizeof(int))
#define SSP_SERVER_PORT 1500
#define SSP_MAX_CTRL_MSG 80

#endif
