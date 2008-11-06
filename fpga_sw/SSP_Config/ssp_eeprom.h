#ifndef SSP_EEPROM_H
#define SSP_EEPROM_H

extern int EE_Init(void);
extern int EE_Read( unsigned char addr, unsigned char *rbuf, int n_bytes );
extern int EE_Write( unsigned char addr, unsigned char *rbuf, int n_bytes );

typedef unsigned short uint16_t;
typedef unsigned char uint8_t;

typedef struct {
  uint16_t n_bytes;
  uint16_t checksum;
} __attribute__((packed)) SSP_Config_hdr_t;

typedef struct {
  SSP_Config_hdr_t hdr;
  uint16_t version;
  uint8_t mac_address[6];
  uint8_t ip_address[4];
  uint8_t ip_netmask[4];
  uint8_t ip_gateway[4];
  uint16_t serial;
  uint16_t fab_year;
  uint8_t fab_month;
  uint8_t fab_day;
  uint16_t cfg_year;
  uint8_t cfg_month;
  uint8_t cfg_day;
  char notes[80];
} __attribute__((packed)) SSP_Config_t;

extern int EE_ReadConfig( SSP_Config_t *cfg );
extern int EE_WriteConfig( SSP_Config_T *cfg );

#endif
