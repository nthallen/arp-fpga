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

#include "xparameters.h"
#include "xspi.h"
#include "xio.h"
#include "ssp_ad.h"
#include "ad9510_if.h"

/************************** Constant Definitions ******************************/
/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define SPI_DEVICE_ID			XPAR_OPB_SPI_0_DEVICE_ID
#define INTC_DEVICE_ID          XPAR_OPB_INTC_0_DEVICE_ID
#define SPI_IRPT_INTR           XPAR_OPB_INTC_0_OPB_SPI_0_IP2INTC_IRPT_INTR

// AD9510 SPI Interface Command constant definitions
#define WRITE_1BYTE				0x00
#define WRITE_2BYTES			0x20
#define WRITE_3BYTES			0x40
#define WRITE_STREAM			0x60
#define READ_1BYTE				0x80
#define READ_2BYTES				0xA0
#define READ_3BYTES				0xC0
#define READ_STREAM				0xE0

// AD9510 Slave Select Address on SPI bus
#define AD9510_SS_ADDR			0x01

/**************************** Type Definitions ********************************/

/***************** Macros (Inline Functions) Definitions **********************/

/************************** Function Prototypes *******************************/

int SPI_system_init(void);
void AD9510_Init(void);
static XStatus SetupInterruptSystem(XSpi *SpiPtr);
static void SpiHandler(void *CallBackRef, Xuint32 StatusEvent, unsigned int ByteCount);
static void ad9510_Write(XSpi *SpiPtr, Xuint16 dat);
static Xuint8 ad9510_Read(XSpi *SpiPtr, Xuint8 SPIaddr);

/************************** Variable Definitions ******************************/

static XSpi Spi;					// SPI device struct instance

/* the following variables are shared between non-interrupt processing and
 * interrupt processing such that they must be global.
 */
static volatile Xboolean TransferInProgress;

/* the following variable tracks any errors that occur during interrupt
 * processing
 */
static int ErrorCnt;

static int check_status( int Status, char *reason ) {
	if (Status != XST_SUCCESS) {
	  print_mutex_lock();
	  xil_printf("AD9510: %s\n");
	  print_mutex_unlock();
	  return 1;
	}
	return 0;
}
	
/******************************************************************************/
/** Main function
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
	unsigned char byte;						// SPI xferred byte
	Xuint8 ad9510RegAddr, ad9510RegVal=1;	// AD9510 Register address and value
	Xuint32 SlaveSel;						// SPI Slave Select Register Contents
   
// Initialize Devices and Ports:
// SPI device
    Status = XSpi_Initialize(&Spi, SPI_DEVICE_ID);
    if ( check_status(Status, "Could not initialize SPI" ))
      return Status;

// Connect the SPI driver to the interrupt subsystem such that
// interrupts can occur.  This function is application specific.
    Status = SetupInterruptSystem(&Spi);
    if ( check_status( Status, "Could not connect handler" ))
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
    if ( check_status( Status, "Could not set SPI Driver Options" ))
      return Status;

// Select the slave on the SPI bus, the AD9510 device so that it can be
// read and written using the SPI bus
    Status = XSpi_SetSlaveSelect(&Spi, AD9510_SS_ADDR);
    if ( check_status( Status, "Could not SetSlaveSelect" ))
      return Status;

// Start the SPI driver so that interrupts and the device are enabled
    XSpi_Start(&Spi);
    
/********************* End Device Initializations ************************/
	
	// AD9510_Init();							// Initialize AD9510

/************************ Begin Main Loop *****************************/
	
//	xil_printf("\r\n -- AD9510 Register File --\r\n");

//	for( ad9510RegAddr = 0 ; ad9510RegAddr <= 0x5A ; ad9510RegAddr++ ) {
//		ad9510RegVal = ad9510_Read(&Spi, ad9510RegAddr);	// Read Register
//		xil_printf("AD9510 [%02x] = %02x \r\n", ad9510RegAddr, ad9510RegVal);
//	}
	
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
	unsigned char byte;
	static unsigned char buf[3];		// buf conains cmd, addr and data
	
	buf[0] = WRITE_1BYTE;
	buf[1] = (dat >> 8);
	buf[2] = dat;

// send the write command, address, and data to the AD9510.
// No receive buffer is specified since there is nothing to receive
	TransferInProgress = XTRUE;

	XSpi_Transfer(SpiPtr, buf, XNULL, 0x3);		// Send Write Cmd, Addr, Data
	
	while (TransferInProgress);			// wait for SPI transfer to be complete
	
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
****************************************************************************/
void AD9510_Init(void) {
// Write AD9510 Initializaton strings
	ad9510_Write(&Spi , 0x3C08);					// Turn on OUT0
	ad9510_Write(&Spi , 0x3D0A);					// Turn off OUT1
	ad9510_Write(&Spi , 0x3E0A);					// Turn off OUT2
	ad9510_Write(&Spi , 0x3F0A);					// Turn off OUT3
	ad9510_Write(&Spi , 0x4003);					// Turn off OUT4
//	ad9510_Write(&Spi , 0x4103);					// Turn off OUT5
	ad9510_Write(&Spi , 0x4102);					// Turn on OUT5 
	ad9510_Write(&Spi , 0x4203);					// Turn off OUT6
	ad9510_Write(&Spi , 0x4303);					// Turn off OUT7
//	ad9510_Write(&Spi , 0x4844);					// Divide OUT0 by 10
	ad9510_Write(&Spi , 0x4899);					// Divide OUT0 by 20
	ad9510_Write(&Spi , 0x5244);					// Divide OUT5 by 10
	ad9510_Write(&Spi , 0x082C);					// Turn off STATUS led

	ad9510_Write(&Spi , 0x5A01);					// Execute
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
    /* Indicate the transfer on the SPI bus is no longer in progress
     * regardless of the status event
     */
    TransferInProgress = XFALSE;

    /* If the event was not transfer done, then track it as an error */

    if (StatusEvent != XST_SPI_TRANSFER_DONE)
        ErrorCnt++;
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
    XStatus Status;

// Connect a device driver handler that will be called when an interrupt
// for the device occurs, the device driver handler performs the specific
// interrupt processing for the device
    register_int_handler(SPI_IRPT_INTR,
                           (XInterruptHandler)XSpi_InterruptHandler,
                           (void *)SpiPtr);
    enable_interrupt(SPI_IRPT_INTR);
    return XST_SUCCESS;
}
