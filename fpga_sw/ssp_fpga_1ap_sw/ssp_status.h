#ifndef SSP_STATUS_H
#define SSP_STATUS_H

extern int status_init(void);
extern void status_set( int clear, char *codes, char *reason);
extern void status_error( char *codes );
extern unsigned int read_jp1(void);
int report_error( char *codes, char *reason );
int check_return( int rv, char *codes, char *where );
int report_errno( char *codes, char *reason );

/*
  Status sequences:
    1    Initialization
    1 2 Reading Configuration
    1 2 1 Invalid count in EEPROM
    1 2 3 Invalid checksum in EEPROM
    1 3 EE_WriteConfig
    1 4 Initialization Complete
  Error sequences:
    1 2   EE_Read call to XIic_SetAddress
    1 3   EE_Write call to XIic_SetAddress
    1 3 1 EE_Write second call to XIic_SetAddress
    1 4  EE_Init call to XIic_Initialize
    1 4 1  EE_Init call to XIic_SelfTest
    1 4 2  EE_Init call to XIntc_Initialize
    1 4 3  EE_Init call to XIntc_Start
    1 4 5 EE_Init call to XIntc_Connect
    1 4 6 EE_Init call to register_int_handler
    1 4 7 EE_Init call to Iic_Start
    1 5  EE_ReadConfig call to EE_Read
    1 5 1 EE _ReadConfig 2nd call to EE_Read
    1 6 EE_WriteConfig notes too long
    1 6 1 EE_WriteConfig error calling EE_Write
    1 7 ethernet_init memory allocation failed
    1 7 1 ethernet_init xemac_add failed
    2 1 Server_App_Thread invalid configuration option
    2 1 2 Server_App_Thread socket failed
    2 1 3 Server_App_Thread bind failed
    2 1 4 Server_App_Thread listen failed
    2 1 5 Server_App_Thread accept failed
    2 1 6 Server_App_Thread memory allocation failed
    2 1 7 Server_App_Thread buffer allocation failed
    2 3 1 process_http_get error from lwip_send
    2 3 2 process_http_get short write to lwip_send
    2 3 4 fields_init: out of memory
    2 3 5 fields_update
*/
#endif
