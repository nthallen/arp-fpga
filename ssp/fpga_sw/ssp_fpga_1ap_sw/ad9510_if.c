/******************************************************************************
*
* @file ad9510_if.c
*
* Driver for SSP Prototype board: AD9510 Communication 
* using the Xilinx SPI Hardware and driver.
* ML-40x Virtex-4 Implementation
* 
* Version using Interrupts and high level calls.
*
* MODIFICATION HISTORY:
*
* Ver   Who Date               Changes
* ----- --- ------------------ -----------------------------------------------
* 1.00a mr  11:23 AM 9/26/2007  Initial release
* 1.01a nta 12:56 PM 10/09/2007 for use with xilkernel
*
*******************************************************************************/

/***************************** Include Files **********************************/
#include "xmk.h"
#include "sys/intr.h"
#include "xparameters.h"
#include "xspi.h"
#include "xio.h"
#include "ssp_ad.h"
#include "ssp_intr.h"
#include "ssp_status.h"
#include "ad9510_if.h"

/************************** Constant Definitions ******************************/
/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define SPI_DEVICE_ID			XPAR_XPS_SPI_0_DEVICE_ID
#define INTC_DEVICE_ID          XPAR_XPS_INTC_0_DEVICE_ID
#define SPI_IRPT_INTR           XPAR_XPS_INTC_0_XPS_SPI_0_IP2INTC_IRPT_INTR

// AD9510 SPI Interface Command constant definitions
#define WRITE_1BYTE				0x00
#define WRITE_2BYTES			0x20
#define WRITE_3BYTES			0x40
#define WRITE_STREAM			0x60
#define READ_1BYTE				0x80
#define READ_2BYTES				0xA0
#define READ_3BYTES				0xC0
#define READ_STREAM				0xE0

#define LVPECL_LVL_810 8
#define LVPECL_LVL_500 0
#define LVPECL_LVL_340 4
#define LVPECL_LVL_660 0xC
#define LVPECL_ON 0
#define LVPECL_SAFE_PD 2
#define LVPECL_TOTAL_PD 3
#define LVDS_ON 0
#define LVDS_PD 1
#define LVDS_3_5_MA 2
#define LVDS_1_75_MA 0
#define LVDS_5_25_MA 4
#define LVDS_7_MA 6
#define LVDS_LVDS 0
#define LVDS_CMOS 8

#define DIVIDER_BYPASS 0x80

// AD9510 Slave Select Address on SPI bus
#define AD9510_SS_ADDR			0x01
#define MAX6661_SS_ADDR     0x02
#define MAX6628_SS_ADDR     0x04

/**************************** Type Definitions ********************************/

/***************** Macros (Inline Functions) Definitions **********************/

/************************** Function Prototypes *******************************/

int SPI_system_init(void);
static XStatus SetupInterruptSystem(XSpi *SpiPtr);
static void SpiHandler(void *CallBackRef, Xuint32 StatusEvent, unsigned int ByteCount);
static void ad9510_Write(XSpi *SpiPtr, Xuint16 dat);
#if AD9510_READ_NEEDED
  static Xuint8 ad9510_Read(XSpi *SpiPtr, Xuint8 SPIaddr);
#endif
/************************** Variable Definitions ******************************/

static XSpi Spi;					// SPI device struct instance

/* the following variables are shared between non-interrupt processing and
 * interrupt processing such that they must be global.
 */
// static volatile Xboolean TransferInProgress;
sem_t spi_sem;

/******************************************************************************/
/** SPI_system_init()
*
* @param    None
*
* @return   XST_SUCCESS if successful, XST_FAILURE if unsuccessful
*
* @note     None
*
*******************************************************************************/
int SPI_system_init(void) {
    XStatus Status;
   
// Initialize Devices and Ports:
// SPI device
    Status = sem_init( &spi_sem, 0, 0 );
    if ( check_return( Status, "61", "sem_init(&spi_sem)"))
      return Status;
    Status = XSpi_Initialize(&Spi, SPI_DEVICE_ID);
    if ( check_return(Status, "612", "XSpi_Initialize()" ))
      return Status;

// Connect the SPI driver to the interrupt subsystem such that
// interrupts can occur.  This function is application specific.
    Status = SetupInterruptSystem(&Spi);
    if ( check_return( Status, "613", "SPI: SetupInterruptSystem()" ))
      return Status;
	
// Setup the handler for the SPI that will be called from the interrupt
// context when an SPI status occurs, specify a pointer to the SPI driver
// instance as the callback reference so the handler is able to access the
// instance data
    XSpi_SetStatusHandler(&Spi, &Spi, (XSpi_StatusHandler)SpiHandler);

// Set the SPI device as a master and in manual slave select mode such that
// the slave select signal does not toggle for every byte of a transfer,
// this must be done before the slave select is set
    Status = XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
    if ( check_return( Status, "614", "XSpi_SetOptions()" ))
      return Status;

// Select the slave on the SPI bus, the AD9510 device so that it can be
// read and written using the SPI bus
    Status = XSpi_SetSlaveSelect(&Spi, AD9510_SS_ADDR);
    if ( check_return( Status, "615", "XSpi_SetSlaveSelect()" ))
      return Status;

// Start the SPI driver so that interrupts and the device are enabled
    XSpi_Start(&Spi);
    return XST_SUCCESS;
}

/*****************************************************************************/
/** ad9510_Write
*
* This Function sends a Write 1 Byte command to the AD9510
* via the SPI Port. Receives nothing, and disregards the Receive FIFO
* when done.
*
* @param    SpiPtr is a pointer to the XSpi instance connected 
*			to the ad9510
*			 dat is a word containing the two byte code to be sent:
* 			  MSByte = AD9510 Address byte
* 			  LSByte = AD9510 Register Data byte to be written
*
* @return	nothing
*
******************************************************************************/
static void ad9510_Write(XSpi *SpiPtr, Xuint16 dat)
{
	//unsigned char byte;
	static unsigned char buf[3];		// buf conains cmd, addr and data
  int rc;
	
	buf[0] = WRITE_1BYTE;
	buf[1] = (dat >> 8);
	buf[2] = dat;

// send the write command, address, and data to the AD9510.
// No receive buffer is specified since there is nothing to receive
	//TransferInProgress = XTRUE;

	rc = XSpi_Transfer(SpiPtr, buf, XNULL, 0x3);		// Send Write Cmd, Addr, Data
  if ( check_return( rc, "621", "XSpi_Transfer()")) return;
	
  rc = sem_wait( &spi_sem );
  check_return( rc, "623", "sem_wait(&spi_sem)" );
}

/*****************************************************************************/
/**	AD9510_Init
*
* This Function sends an Initialization sequence to the AD9510
* via the SPI Port.
*
* @param    SpiPtr is a pointer to the XSpi instance connected 
*			to the AD9510
*
* @return	nothing
*
* AD9510 Initialization Strategy:
  Power down any unused portions of the board
  Use safe power down option for terminated LVPECL circuits
    All 4 LVPECL outputs are terminated on the SSP Proto board
    0, 1 and 2 are terminated on SSP, 3 is not.
    LVPECL Output level is (presumably) 810 mV
    Outputs 0, 1, 2 go to A/Ds (except on proto)
       On the proto board, if any channel is enabled, channel 0 must be,
       since it's the only real channel. Channels 1 & 2 go nowhere, so can be
       disabled always
       On SSP, if any channel is enabled, channel 0 must be, since it runs to
       the trigger circuit as well.
    Output 5 goes to FPGA USERCLK
    Output 6 goes to QCLI
    Outputs 3, 4 and 7 are currently unused
    CLK1 is 100MHz Oscillator. CLK1 is selected by default.
    CLK2 is 100MHz VCXO for use with PLL circuit. It will not be installed at the start,
    and we will not use the PLL block. PLL is powered down by default. CLK2 should
    be powered down as well to avoid any crosstalk. Can also power down PLL prescaler
    and REFIN.
    Each output can be divided by any integer from 1 to 32.
      Division by 1 is accomplished by bypassing the divider
      Division by greater values is accomplished by setting the number of input clock periods
      the output should remain high and low respectively.
    
****************************************************************************/
void AD9510_Init(int ChEn, int divisor) {
  int ch;
  unsigned short div_code_0, div_code_1;
    
  XSpi_ClearStats(&Spi);
  XStatus Status = XSpi_SetSlaveSelect(&Spi, AD9510_SS_ADDR);
  if ( check_return( Status, "624", "XSpi_SetSlaveSelect(AD9510_SS_ADDR)" ))
	return;

    #ifdef SSP_PROTO_A
	    if (ChEn) ChEn = 1;
	    ChEn &= 0x7;
	  #else
		#ifdef SSP_PMT_V1AP
		  // A/Ds 1 & 2 are unused, so never start their clocks
	      // Channel 5 is always required, both for PMT inputs and
	      // the trigger circuit
	      // Channel 6 is required for Clock out (e.g. to QCLI)
		  if (ChEn) ChEn |= 0x60;
		  ChEn &= 0x61; // channesl 1, 2, 3, 4 & 7 are unused
		#else // SSP_V1A
		  // Channel 0 is always required to provide the clock to the trigger circuit
		  // Channel 6 is required to drive the QCLI
		  if (ChEn) ChEn |= 0x41;
		  ChEn &= 0x67; // Channels 3, 4 & 7 are unused
		#endif
	  #endif
	  // AD9510 Serial Port Configuration leave as default
	  // PLL section leave in default power-down mode
	  // Find Adjust leave as bypassed
	  // LVPECL Outputs
	  for ( ch = 0; ch <= 3; ch++ ) {
	    unsigned short lvpecl_cfg = 0x3C00 + 0x100*ch + LVPECL_LVL_810;
	    if ( ChEn & (1<<ch) ) {
	      lvpecl_cfg |= LVPECL_ON; // actually a no-op
	    } else {
	      lvpecl_cfg |= LVPECL_SAFE_PD;
	    }
	    ad9510_Write(&Spi, lvpecl_cfg);
	  }
	  // LVDS Outputs
	  for ( ch = 4; ch <= 7; ch++ ) {
	    unsigned short lvds_cfg = 0x3C00 + 0x100*ch + LVDS_3_5_MA + LVDS_LVDS;
	    if ( ChEn & (1<<ch) ) {
	      lvds_cfg |= LVDS_ON; // no-op
	    } else {
	      lvds_cfg |= LVDS_PD;
	    }
	    ad9510_Write(&Spi, lvds_cfg);
	  }
	  // Dividers
	  for ( ch = 0; ch <= 7; ch++ ) {
      int dvsr = divisor;
      if (ChEn & (1<<ch)) {
        if ( ch == 6 ) dvsr = 25; // 4 MHz to QCLI
      } else dvsr = 0;
  	  if ( dvsr <= 1 ) {
  	    div_code_0 = 0;
  	    div_code_1 = DIVIDER_BYPASS;
  	  } else {
  	    if (dvsr > 32 ) dvsr = 32;
  	    div_code_0 = ((dvsr/2-1)<<4) + ((dvsr+1)/2-1);
  	    div_code_1 = 0;
  	  }
	    ad9510_Write(&Spi, 0x4800 + 0x200*ch + div_code_0 );
	    ad9510_Write(&Spi, 0x4900 + 0x200*ch + div_code_1 );
	    // could possibly reduce power a bit more by bypassing divider for disabled channels
	  }
	  // CLK Inputs
	  ad9510_Write(&Spi, ChEn ? 0x451D : 0x453F );
		ad9510_Write(&Spi, ChEn ? 0x0800 : 0x082C ); // STATUS led
	  ad9510_Write(&Spi, 0x5804 );  // Synch On
		ad9510_Write(&Spi , 0x5A01);					// Execute
	  ad9510_Write(&Spi, 0x5800 );  // Sync Off
	  ad9510_Write(&Spi , 0x5A01);					// Execute
    #if PRINT_ENABLE
      XSpi_GetStats(&Spi, &Stats);
      print_mutex_lock();
      if (Stats.ModeFaults)
        safe_printf(("SPI: %d mode faults\r\n", Stats.ModeFaults ));
      if (Stats.XmitUnderruns)
        safe_printf(("SPI: %d XmitUnderruns\r\n", Stats.XmitUnderruns ));
      if (Stats.RecvOverruns)
        safe_printf(("SPI: %d RecvOverruns\r\n", Stats.RecvOverruns ));
      if (Stats.SlaveModeFaults)
        safe_printf(("SPI: %d SlaveModeFaults\r\n", Stats.SlaveModeFaults ));
      safe_printf(("SPI: %d bytes transferred\r\n", Stats.BytesTransferred ));
      safe_printf(("SPI: %d interrupts\r\n", Stats.NumInterrupts ));
      print_mutex_unlock();
    #endif
}

/*****************************************************************************/
/** ad9510_Read
*
* For the ad9510, this function changes the SPI clock phase to CPHA = 1 
* (for clocking data on falling edge of SCLK), then sends one dummy byte 
* via SPI Port. When the transfer is done, it reads the returned byte
* from the Receive FIFO and returns it. The SPI CPHA Mode is 
* then returned to 0 (rising edge clocking)
*
* @param	SpiPtr is a pointer to the XSpi instance connected 
*			to the ad9510
*			SPIaddr is the desired Register's address within the SPI Port
*
* @return	Received byte
*
******************************************************************************/
#if AD9510_READ_NEEDED
static Xuint8 ad9510_Read(XSpi *SpiPtr, Xuint8 SPIaddr)
{
	static unsigned char obuf[3], ibuf[3];	// obuf conains cmd & addr
	
	obuf[0] = READ_1BYTE;
	obuf[1] = SPIaddr;
	obuf[2] = 0x11;
	
// send the read command, address, and data to the AD9510.
// No receive buffer is specified since there is nothing to receive
	TransferInProgress = XTRUE;

	XSpi_Transfer(SpiPtr, obuf, ibuf, 0x3);		// Send Read Cmd, get data
	
	while (TransferInProgress);			// wait for SPI transfer to be complete
	
	return ibuf[2];
}
#endif

int MAX6628_Read(void) {
	int rc;
  XStatus Status;
	Xint16 temp;
  XSpi_ClearStats(&Spi);
  Status = XSpi_SetSlaveSelect(&Spi, MAX6628_SS_ADDR);
  if ( check_return( Status, "624", "XSpi_SetSlaveSelect(MAX6628_SS_ADDR)" ))
    return 0x7FFF;
	rc = XSpi_Transfer(&Spi, (u8 *)&temp, (u8 *)&temp, 2);
  if ( check_return( rc, "621", "XSpi_Transfer()")) return 0x7FFF;
  rc = sem_wait( &spi_sem );
  check_return( rc, "623", "sem_wait(&spi_sem)" );
  Status = XSpi_SetSlaveSelect(&Spi, 0);
  if ( check_return( Status, "624", "XSpi_SetSlaveSelect(0)" ))
    return 0x7FFF;
  return temp;
}

int MAX6661_Read(void) {
	int rc;
  XStatus Status;
	Xint16 temp;
  u8 buf[2];
  XSpi_ClearStats(&Spi);
  Status = XSpi_SetSlaveSelect(&Spi, MAX6661_SS_ADDR);
  if ( check_return( Status, "624", "XSpi_SetSlaveSelect(MAX6661_SS_ADDR)" ))
    return 0x7FFF;
  buf[0] = 0x83; // RRH  Read Remote Temp. High Byte
	rc = XSpi_Transfer(&Spi, buf, buf, 2);
  if ( check_return( rc, "621", "XSpi_Transfer()")) return 0x7FFF;
  rc = sem_wait( &spi_sem );
  check_return( rc, "623", "sem_wait(&spi_sem)" );
  temp = buf[1] << 8;
  buf[0] = 0x81; // RRL Read Remote Temp. Low Byte
	rc = XSpi_Transfer(&Spi, buf, buf, 2);
  if ( check_return( rc, "621", "XSpi_Transfer()")) return 0x7FFF;
  rc = sem_wait( &spi_sem );
  check_return( rc, "623", "sem_wait(&spi_sem)" );
  temp = temp | buf[0];
  Status = XSpi_SetSlaveSelect(&Spi, 0);
  if ( check_return( Status, "624", "XSpi_SetSlaveSelect(0)" ))
    return 0x7FFF;
  return (int) temp;
}

/****************************************************************************/
/** SpiHandler
*
* This function is the handler which performs processing for the SPI driver.
* It is called from an interrupt context such that the amount of processing
* performed should be minimized.  It is called when a transfer of SPI data
* completes or an error occurs.
*
* This handler provides an example of how to handle SPI interrupts
* but is application specific.
*
* @param	None.
*
* @return	None.
*
****************************************************************************/
void SpiHandler(void *CallBackRef, Xuint32 StatusEvent,
                unsigned int ByteCount)
{
    if (StatusEvent == XST_SPI_TRANSFER_DONE)
      sem_post( &spi_sem );
    // else {
		  // print_mutex_lock();
		  // safe_printf(("AD9510: Status not done: %d\r\n", StatusEvent));
		  // print_mutex_unlock();
    // }
}

/****************************************************************************/
/** SetupInterruptSystem
*
* DESCRIPTION:
* This function setups the interrupt system such that interrupts can occur
* for the SPI driver.  This function is application specific since the actual
* system may or may not have an interrupt controller.  The SPI device could
* be directly connected to a processor without an interrupt controller.  The
* user should modify this function to fit the application.
*
* @param	SpiPtr contains a pointer to the instance of the XSpi component
*			which is going to be connected to the interrupt controller.
*
* @return	XST_SUCCESS if successful, otherwise XST_FAILURE.
*
****************************************************************************/
XStatus SetupInterruptSystem(XSpi *SpiPtr) {
    //XStatus Status;

// Connect a device driver handler that will be called when an interrupt
// for the device occurs, the device driver handler performs the specific
// interrupt processing for the device
    register_int_handler(SPI_IRPT_INTR,
                           (XInterruptHandler)XSpi_InterruptHandler,
                           (void *)SpiPtr);
    enable_interrupt(SPI_IRPT_INTR);
    return XST_SUCCESS;
}
