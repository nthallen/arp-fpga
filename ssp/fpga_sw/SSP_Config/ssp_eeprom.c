/* * This file will abstract the read/write interfaces to the 24LC04B EEPROM on the XPS IIC Bus. * It was originally written and tested in a standalone environment, so the interrupts were * connected directly to the interrupt controller. Since it will be used in applications that * also require TCP/IP, it will need to use the xilkernel interfaces instead. */#include "config.h"#include <string.h>#include "ssp_print.h"#include "ssp_status.h"#include "xparameters.h"
#include "xiic.h"#ifdef __XMK__  #include "sys/timer.h"#else  #include "xintc.h"
  #include "xtmrctr.h"
  #include "mb_interface.h"
  XIntc Intc;
  XTmrCtr TmrCtr;
#endif
#define RBUFSIZE 64
#define NPERROW 10
#define ADDR_24LC04B 0x50
#define EE_PAGE_SIZE 16 // 8 works#define EE_TOTAL_SIZE 512#define EE_BLOCK_SIZE 256

XIic Iic;
static volatile char send_complete, recv_complete, status_events;

static void Iic_StatusHandler(void *CallBackRef, int StatusEvent ) {  status_events = 1;
}

static void Iic_RecvHandler(void *CallBackRef, int ByteCount ) {
	recv_complete = 1;
}

static void Iic_SendHandler(void *CallBackRef, int ByteCount ) {
	send_complete = 1;
}
// return non-zero if error reported
static int check_return( int rv, char *where, unsigned char *codes ) {
	if ( rv != XST_SUCCESS ) {    print_mutex_lock();
		safe_printf("Error from %s: %d\r\n", where, rv );    print_mutex_unlock();    status_error(codes);    return 1;
  }  return 0;
}

/* Iic_Write() writes n_bytes of data from buf to the Iic device.
 * The first byte of buf is the address inside the device. */
int Iic_Write( XIic *Iicp, unsigned char *rbuf, int n_bytes ) {
	int rv, cnt = 0;
  send_complete = 0;
  status_events = 0;
  rv = XIic_MasterSend( Iicp, rbuf, n_bytes );
  if ( rv != XST_SUCCESS ) return rv;
  
  while ( !send_complete && !status_events );
  /* Arbitrary post-write delay. The limit here was empirically tested
   * and worked without a hitch down to 1<<9. I backed off to 1<<10.
   * It might be possible to go much lower, but it really isn't
   * necessary, because we don't intend to be reading or writing
   * this device very much at all. */  #ifdef __XMK__    // This is a guess, may need to be extended    sleep(10);  #else    // ### This may be optimized out of existence!
    for ( cnt = 0; cnt < (1<<10); ++cnt )
      rv += cnt;  #endif
  return send_complete ? XST_SUCCESS : XST_FAILURE;
}
// Deail with block boundaries
int EE_Write( unsigned char addr, unsigned char *rbuf, int n_bytes ) {
	unsigned char pbuf[EE_PAGE_SIZE+1];
  if ( addr > EE_TOTAL_SIZE ) return XST_FAILURE;  if ( addr + n_bytes > EE_TOTAL_SIZE ) n_bytes = EE_TOTAL_SIZE - addr;  rv = XIic_SetAddress( &Iic, XII_ADDR_TO_SEND_TYPE, ADDR_24LC04B +    (addr < EE_BLOCK_SIZE ? 0 : 1));
  check_return( rv, "XIic_SetAddress", "\001\003" );	while (n_bytes > 0) {
		int i;
		int p_bytes = EE_PAGE_SIZE - (addr & (EE_PAGE_SIZE-1));
		if ( n_bytes < p_bytes ) p_bytes = n_bytes;
		pbuf[0] = addr & (EE_BLOCK_SIZE-1);
		for ( i = 1; i <= p_bytes; i++ ) {
			pbuf[i] = *rbuf++;
		}
		i = Iic_Write(&Iic, pbuf, p_bytes+1);
		if ( i != XST_SUCCESS ) return i;
		n_bytes -= p_bytes;
		addr += p_bytes;    if ( n_bytes > 0 && addr == EE_BLOCK_SIZE ) {      rv = XIic_SetAddress( &Iic, XII_ADDR_TO_SEND_TYPE, ADDR_24LC04B + 1 );      check_return( rv, "XIic_SetAddress", "\001\003\001" );    }
	}
	return XST_SUCCESS;
}

static int EE_SetReadAddress( XIic *Iicp, unsigned char addr ) {
	return Iic_Write( Iicp, &addr, 1 );
} 
/* This needs to be expanded to deal with the two pages of memory and note the limited size of memory */
int EE_Read( unsigned char addr, unsigned char *rbuf, int n_bytes ) {
	int rv, cnt = 0;
  recv_complete = 0;
  status_events = 0;  if ( addr > EE_TOTAL_SIZE ) return XST_FAILURE;  if ( addr + n_bytes > EE_TOTAL_SIZE ) n_bytes = EE_TOTAL_SIZE - addr;  while ( n_bytes > 0 ) {    int r_bytes;    rv = XIic_SetAddress( &Iic, XII_ADDR_TO_SEND_TYPE, ADDR_24LC04B +      (addr < EE_BLOCK_SIZE ? 0 : 1));
    check_return( rv, "XIic_SetAddress", "\001\002" );    r_bytes = (addr < EE_BLOCK_SIZE && addr+n_bytes > EE_BLOCK_SIZE) ?      EE_BLOCK_SIZE - addr : n_bytes;
    rv = EE_SetReadAddress( &Iic, addr & (EE_BLOCK_SIZE-1) );
    if ( rv != XST_SUCCESS ) return rv;
    rv = XIic_MasterRecv( &Iic, rbuf, n_bytes );
    if ( rv != XST_SUCCESS ) return rv;
    while ( !recv_complete && !status_events );    if ( !recv_complete ) return XST_FAILURE;    addr += r_bytes;    rbuf += r_bytes;    n_bytes -= r_bytes;  }  return XST_SUCCESS;
}

int EE_Init(void) {
	int cnt, i, rv;
	unsigned char rbuf[RBUFSIZE+1];
	
  rv = XIic_Initialize(&Iic, XPAR_IIC_EEPROM_DEVICE_ID );
  check_return( rv, "XIic_Initialize", "\001\004" );
  rv = XIic_SelfTest( &Iic );
  check_return( rv, "XIic_SelfTest", "\001\004\001" );
  XIic_SetStatusHandler(&Iic, NULL, Iic_StatusHandler );
  XIic_SetSendHandler(&Iic, NULL, Iic_SendHandler );
  XIic_SetRecvHandler(&Iic, NULL, Iic_RecvHandler );
    #ifdef __XMK__    rv = register_int_handler(XPAR_XPS_INTC_0_IIC_EEPROM_IIC2INTC_IRPT_INTR,      XIic_InterruptHandler, &Iic );    check_return( rv, "register_int_handler", "\001\004\006" );    enable_interrupt(XPAR_XPS_INTC_0_IIC_EEPROM_IIC2INTC_IRPT_INTR);  #else
    microblaze_disable_interrupts();
    rv = XIntc_Initialize( &Intc, XPAR_XPS_INTC_0_DEVICE_ID );
    check_return( rv, "XIntc_Initialize", "\001\004\002" );
    rv = XIntc_Start(&Intc, XIN_REAL_MODE);
    check_return( rv, "XIntc_Start", "\001\004\003" );
    rv = XIntc_Connect(&Intc, XPAR_XPS_INTC_0_IIC_EEPROM_IIC2INTC_IRPT_INTR,
      XIic_InterruptHandler, &Iic);
    check_return( rv, "XIntc_Connect", "\001\004\005" );
    microblaze_register_handler((XInterruptHandler)XIntc_InterruptHandler, &Intc);
    microblaze_enable_interrupts();
    XIntc_Enable(&Intc, XPAR_XPS_INTC_0_IIC_EEPROM_IIC2INTC_IRPT_INTR);
  #endif  
  rv = XIic_Start(&Iic);
  check_return( rv, "XIic_Start", "\001\004\007" );
  { u32 Options = XIic_GetOptions( &Iic );
  	XIic_SetOptions( &Iic, Options & ~XII_SEND_10_BIT_OPTION );
  }
  return 0;} 
// Fletcher16 checksum algorithm from http://en.wikipedia.org/wiki/Fletcher%27s_checksumstatic uint16_t fletcher16( uint8_t *data, size_t len ) {
  uint16_t sum1 = 0xff, sum2 = 0xff;

  while (len) {
          size_t tlen = len > 21 ? 21 : len;
          len -= tlen;
          do {
                  sum1 += *data++;
                  sum2 += sum1;
          } while (--tlen);
          sum1 = (sum1 & 0xff) + (sum1 >> 8);
          sum2 = (sum2 & 0xff) + (sum2 >> 8);
  }
  /* Second reduction step to reduce sums to 8 bits */
  sum1 = (sum1 & 0xff) + (sum1 >> 8);
  sum2 = (sum2 & 0xff) + (sum2 >> 8);
  return ((sum1&0xff) << 8) + (sum2&0xff);
}
// return 0 on success, 1 on errorint EE_ReadConfig( SSP_Config_t *cfg ) {  int rv;  uint16_t check;  status_set( 1, "\001\002" );  rv = EE_Read( 0, cfg, sizeof(SSP_Config_hdr_t));  if ( check_return( rv, "EE_Read", "\001\005" ) ) return 1;  if ( cfg->hdr.n_bytes > EE_TOTAL_SIZE ||       cfg->hdr.n_bytes < offsetof(SSP_Config_t,notes)) {    status_set( 1, "\001\002\001" );    return 1;  }  rv = EE_Read( 0, &cfg->version, cfg->hdr.n_bytes );  if ( check_return( rv, "EE_Read 2", "\001\005\001" ) ) return 1;  check = fletcher16( (uint8_t *)&cfg->version, cfg->hdr.n_bytes - sizeof(cfg->hdr));  if ( check != cfg->hdr.checksum ) {    status_set( 1, "\001\002\003" );    return 1;  }  return 0;}static void store_IP4( uint8_t *addr, uint8_t a, uint8_t b, uint8_t c, uint8_t d ) {  addr[0] = a;  addr[1] = b;  addr[2] = c;  addr[3] = d;}static void store_mac( uint8_t *addr, uint8_t a, uint8_t b, uint8_t c,                      uint8_t d, uint8_t e, uint8_t f ) {  addr[0] = a;  addr[1] = b;  addr[2] = c;  addr[3] = d;  addr[4] = e;  addr[5] = f;}void EE_DefaultConfig(SSP_Config_t *cfg) {  cfg->version = 0;  store_mac(cfg->mac_address, 0, 0xA, 0x35, 0x55, 0x55, 0x55 );  store_IP4(cfg->ip_address, 10, 0, 0, 200 );  store_IP4(cfg->ip_netmask, 255, 255, 255, 0 );  store_IP4(cfg->ip_gateway, 10, 0, 0, 1 );  cfg->serial = 0;  cfg->fab_year = 2008;  cfg->fab_month = 7;  cfg->fab_day = 1;  cfg->cfg_year = 2008;  cfg->cfg_month = 11;  cfg->cfg_day = 1;  cfg->notes[0] = '\0';  cfg->hdr.n_bytes = offsetof(SSP_Config_t,notes) + 1;  cfg->hdr.checksum =    fletcher16( (uint8_t *)&cfg->version, cfg->hdr.n_bytes - sizeof(cfg->hdr));}
int EE_WriteConfig( SSP_Config_T *cfg ) {  int rv;  cfg->hdr.n_bytes = offsetof(SSP_Config_t,notes) + strlen(cfg->notes) + 1;  if ( cfg->hdr.n_bytes > EE_TOTAL_SIZE ) {    status_error( "\001\006" );    return 1;  }  cfg->hdr.checksum =    fletcher16( (uint8_t *)&cfg->version, cfg->hdr.n_bytes - sizeof(cfg->hdr));  status_set( 1, "\001\003" );  rv = EE_Write( 0, cfg, cfg->hdr.n_bytes );  if ( rv != 0 ) status_error( "\001\006\001" );}
