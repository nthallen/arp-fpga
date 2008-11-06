/*
#include "xiic.h"
  #include "xtmrctr.h"
  #include "mb_interface.h"

  XTmrCtr TmrCtr;
#endif
#define RBUFSIZE 64
#define NPERROW 10
#define ADDR_24LC04B 0x50
#define EE_PAGE_SIZE 16 // 8 works

XIic Iic;
static volatile char send_complete, recv_complete, status_events;

static void Iic_StatusHandler(void *CallBackRef, int StatusEvent ) {
}

static void Iic_RecvHandler(void *CallBackRef, int ByteCount ) {
	recv_complete = 1;
}

static void Iic_SendHandler(void *CallBackRef, int ByteCount ) {
	send_complete = 1;
}

static int check_return( int rv, char *where, unsigned char *codes ) {
	if ( rv != XST_SUCCESS ) {
		safe_printf("Error from %s: %d\r\n", where, rv );
  }
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
   * this device very much at all. */
    for ( cnt = 0; cnt < (1<<10); ++cnt )
      rv += cnt;
  return send_complete ? XST_SUCCESS : XST_FAILURE;
}

int EE_Write( unsigned char addr, unsigned char *rbuf, int n_bytes ) {
	unsigned char pbuf[EE_PAGE_SIZE+1];
  if ( addr > EE_TOTAL_SIZE ) return XST_FAILURE;
  check_return( rv, "XIic_SetAddress", "\001\003" );
		int i;
		int p_bytes = EE_PAGE_SIZE - (addr & (EE_PAGE_SIZE-1));
		if ( n_bytes < p_bytes ) p_bytes = n_bytes;

		for ( i = 1; i <= p_bytes; i++ ) {
			pbuf[i] = *rbuf++;
		}
		i = Iic_Write(&Iic, pbuf, p_bytes+1);
		if ( i != XST_SUCCESS ) return i;
		n_bytes -= p_bytes;
		addr += p_bytes;
	}
	return XST_SUCCESS;
}

static int EE_SetReadAddress( XIic *Iicp, unsigned char addr ) {
	return Iic_Write( Iicp, &addr, 1 );
} 

int EE_Read( unsigned char addr, unsigned char *rbuf, int n_bytes ) {
	int rv, cnt = 0;
  recv_complete = 0;
  status_events = 0;
    check_return( rv, "XIic_SetAddress", "\001\002" );
    rv = EE_SetReadAddress( &Iic, addr & (EE_BLOCK_SIZE-1) );
    if ( rv != XST_SUCCESS ) return rv;
    rv = XIic_MasterRecv( &Iic, rbuf, n_bytes );
    if ( rv != XST_SUCCESS ) return rv;
    while ( !recv_complete && !status_events );
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
  return 0;
// Fletcher16 checksum algorithm from http://en.wikipedia.org/wiki/Fletcher%27s_checksum
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

