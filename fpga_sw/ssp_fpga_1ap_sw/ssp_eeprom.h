#ifndef SSP_EEPROM_H
#define SSP_EEPROM_H

extern int EE_Init(void);
extern int EE_Read( unsigned addr, unsigned char *rbuf, int n_bytes );
extern int EE_Write( unsigned addr, unsigned char *rbuf, int n_bytes );

typedef unsigned short uint16_tn;
typedef unsigned char uint8_tn;

typedef struct {
  uint16_t n_bytes;
  uint16_t checksum;
} __attribute__((packed)) SSP_EE_Config_hdr_t;

typedef struct {
  uint8_tn mac_address[6];
  uint8_tn ip_address[4];
  uint8_tn ip_netmask[4];
  uint8_tn ip_gateway[4];
} __attribute__((packed)) net_config_t;

typedef struct {
  uint16_t year;
  uint8_tn month;
  uint8_tn day;
} __attribute__((packed)) SSP_date_t;
#define N_CFG_OPTS 5
#define SSP_MAX_NOTE_LENGTH 80
typedef struct {
  SSP_EE_Config_hdr_t hdr;
  uint16_tn version;
  net_config_t net_cfg;
  uint16_tn serial;
  SSP_date_t fab_date;
  SSP_date_t cfg_date;
  char notes[SSP_MAX_NOTE_LENGTH];
} __attribute__((packed)) SSP_EE_Config_t;

extern int EE_ReadConfig( SSP_EE_Config_t *cfg );
extern int EE_WriteConfig( SSP_EE_Config_t *cfg );
extern void EE_print_config( SSP_EE_Config_t *cfg, char *heading );
extern void EE_DefaultConfig(SSP_EE_Config_t *cfg);
extern SSP_EE_Config_t SSP_EE_Config;
#define EE_READ_ONLY 1

#endif
