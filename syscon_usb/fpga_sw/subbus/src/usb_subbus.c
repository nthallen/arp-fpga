/******************************************************************************
*
* @file usb_subbus
* 
* Listens for commands from USB port (using EPC) 
* and places SUBBUS (16bit version) address and data on 
* DLP_FPGA pins
* 
* MODIFICATION HISTORY:
*
* Ver   Who	 Date	 Changes
* ----- --- -------- -----------------------------------------------
* 0.00	mr	11/2/09  Initial release
*
*******************************************************************************/

/***************************** Include Files **********************************/
#include <ctype.h>
#include <stdlib.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xio.h"
// #include "xtmrctr.h"
#include "string.h"

/************************** Constant Definitions *****************************/

#define BOARD_REV                   "VSyscon Rev.C.0.02"
#define	CPU_FREQ					XPAR_CPU_CORE_CLOCK_FREQ_HZ
#define FTDI_ADDRESS 				XPAR_XPS_EPC_0_PRH0_BASEADDR
#define DATA_RDY_DEVICE_ID    		XPAR_XPS_GPIO_DATA_RDY_DEVICE_ID    	
#define HBLED_DEVICE_ID				XPAR_XPS_GPIO_HBLED_DEVICE_ID 			
#define SUBBUS_CTRL_DEVICE_ID       XPAR_XPS_GPIO_SB_CTRL_DEVICE_ID
#define SUBBUS_STATUS_DEVICE_ID     XPAR_XPS_GPIO_SB_STATUS_DEVICE_ID
#define SUBBUS_ADDR_DEVICE_ID 		XPAR_XPS_GPIO_SB_ADDR_DEVICE_ID
#define SUBBUS_DATA_DEVICE_ID 		XPAR_XPS_GPIO_SB_DATA_DEVICE_ID
#define FTDI_SI_DEVICE_ID           XPAR_XPS_GPIO_FTDI_SI_DEVICE_ID
//#define SUBBUS_DATAI_DEVICE_ID 		XPAR_XPS_GPIO_SB_DATAI_DEVICE_ID
#define SBCTRL_RD                   0x1
#define SBCTRL_WR                   0x2
#define SBCTRL_CS                   0x4
#define SBCTRL_CE                   0x8
#define SBCTRL_RST                  0x10
#define SBSTAT_DONE                 0x1
#define SBSTAT_ACK                  0x2

#define EXPRD_NS					1000
#define EXPWR_NS					1000
#define CMDSTRB_NS					500
#define	CMD_RCV_TIMEOUT				100000
#define ALL_OUT						0x0000
#define	ALL_IN						0xFFFF
#define EXPRD_PAD					10
#define EXPWR_PAD					10

/************************** Function Prototypes *******************************/

void ErrorCode(char code);		// Send Error Code back to Host via USB
void BoardRev();					// Send Board Rev info back to Host
void SendUSB(char *);			// Send String Back to Host via USB

/************************** Variable Definitions ******************************/

void hex_out(unsigned short data) {
  static char hex[] = { '0', '1', '2', '3', '4', '5', '6', '7',
                    '8','9', 'A', 'B', 'C', 'D', 'E', 'F' };
  XIo_Out8(FTDI_ADDRESS, hex[(data>>12)&0xF]);
  XIo_Out8(FTDI_ADDRESS, hex[(data>>8)&0xF]);
  XIo_Out8(FTDI_ADDRESS, hex[(data>>4)&0xF]);
  XIo_Out8(FTDI_ADDRESS, hex[data&0xF]);
}

int pulse_rdwr(XGpio *ctrl, XGpio *status, Xuint8 subb_ctrl, Xuint8 bit) {
  Xuint8 subb_status;
  subb_ctrl |= bit;
  XGpio_DiscreteWrite(ctrl,1,subb_ctrl);		// Issue EXPRD
  for (;;) {
  subb_status = XGpio_DiscreteRead(status,1);
  if (subb_status & SBSTAT_DONE) break;
  }
  subb_ctrl &= ~bit;
  //XGpio_DiscreteWrite(ctrl,1,subb_ctrl);
  return (subb_status & SBSTAT_ACK) ? 1 : 0;
}

/******************************************************************************
*
* Main function. Reads data from FTDI chip when available and places it on
* alternating address and data buses
*
* @param    None
* @return   XST_SUCCESS if successful, XST_FAILURE if unsuccessful
* @note     None
*
*******************************************************************************/
int main(void)
{
  //XStatus Status;
  XGpio Data_Rdy;
  //XGpio HB_Led;
  XGpio Subbus_Addr, Subbus_Data;
  XGpio Subbus_Ctrl, Subbus_Status;
  XGpio FTDI_SI;
  
  char cmd[15];							// Current Command
  Xuint16 subb_addr, subb_data;
  Xuint8 subb_ctrl = 0;
  char cmd_error, hb;
  int expack;
  Xuint8 cmdstrb_true = 0x1;	     // CMDSTRB True when High = Default
  // Xuint8	delay;										// Delay Timer var
  Xuint16 cmd_byte_num;
  int cmd_rcv_timer;
  char * pEnd;
  
  // Initialize all GPIO's
  XGpio_Initialize(&Data_Rdy, DATA_RDY_DEVICE_ID);
  //XGpio_Initialize(&HB_Led, HBLED_DEVICE_ID);
  XGpio_Initialize(&Subbus_Addr, SUBBUS_ADDR_DEVICE_ID);
  XGpio_Initialize(&Subbus_Data, SUBBUS_DATA_DEVICE_ID);
  XGpio_Initialize(&Subbus_Status, SUBBUS_STATUS_DEVICE_ID);
  XGpio_Initialize(&Subbus_Ctrl, SUBBUS_CTRL_DEVICE_ID);
  XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);
  XGpio_Initialize(&FTDI_SI, FTDI_SI_DEVICE_ID);
  XGpio_DiscreteWrite(&FTDI_SI,1,1);
  cmdstrb_true = 0x1;							// CMDSTRB True when High = Default

  XGpio_DiscreteWrite(&Subbus_Ctrl, 1, subb_ctrl | SBCTRL_RST);
  XGpio_DiscreteWrite(&Subbus_Ctrl, 1, subb_ctrl);
        
/************************ End Initializations *****************************/
  
  // Begin main loop
  while(1) {
    if (0x01 == XGpio_DiscreteRead(&Data_Rdy,1)) {	// If FTDI usb has new Cmds
      hb = 0xff;									// HeartBeat LED off (DLP-FPGA board)
      cmd_error = 0;
      cmd_rcv_timer = 0;
      cmd_byte_num = 0;
      
      // Read full command
      do {
        int ftdi_stat = XGpio_DiscreteRead(&Data_Rdy,1);
        if ( ftdi_stat == 0x01) {
        cmd[cmd_byte_num] = XIo_In8(FTDI_ADDRESS);
        if ('\n' == cmd[cmd_byte_num]) break;		// \n = EOC
        if (cmd_byte_num > 11) cmd_error = '8';		// Code 8: Too many bytes before NL
        if (cmd_byte_num == 5) {
          if (cmd[cmd_byte_num] == ':')
            cmd[cmd_byte_num]=' ';	// make colon=\n=space
          else cmd_error = '6';					// Code 6: Non-Hex cmd payload
        } else if (cmd_byte_num > 0 && !isxdigit(cmd[cmd_byte_num]))
          cmd_error = '6';						// Code 6: Non-Hex cmd payload
          cmd_byte_num++;
        } else if (++cmd_rcv_timer > CMD_RCV_TIMEOUT) {
          cmd_error = '2';	// Code 2: Rcv Timeout
        }
      } while (0 == cmd_error);
      
      // Execute command
      if (cmd_error == 0) {
        switch(cmd[0]) {
          case '\n':							// NOOP
            SendUSB("0");
            break;
          case 'R':							// READ with ACK 'R'
            cmd[0] = ' '; 					// Wipe out Cmd with Space
            subb_addr = strtoul (cmd,NULL,16);				// Addr = to Hex
            XGpio_DiscreteWrite(&Subbus_Addr,1,subb_addr);	// put it on ADDR bus
            expack = pulse_rdwr(&Subbus_Ctrl, &Subbus_Status, subb_ctrl, SBCTRL_RD);
            subb_data = XGpio_DiscreteRead(&Subbus_Data,1);	// Read SUBBUS Data
            XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);
            // Respond R or r depending on Expack... ???
            XIo_Out8(FTDI_ADDRESS, expack ? 'R' : 'r');	// Respond with R
            hex_out(subb_data);
            XIo_Out8(FTDI_ADDRESS, '\n');					// + newline
            break;
          case 'W':							// WRITE with ACK 'W'
            cmd[0] = ' '; 					// Wipe out Cmd with Space
            subb_addr = strtoul (cmd,&pEnd,16);				// Addr = to Hex
            subb_data = strtoul (pEnd,NULL,16);				// Data = to Hex
            XGpio_DiscreteWrite(&Subbus_Addr,1,subb_addr);	// put it on ADDR bus
            XGpio_DiscreteWrite(&Subbus_Data,1,subb_data);	// put it on DATA bus
            expack = pulse_rdwr(&Subbus_Ctrl, &Subbus_Status, subb_ctrl, SBCTRL_WR);
            XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);
            XIo_Out8(FTDI_ADDRESS, expack ? 'W' : 'w'); 	// Respond with W or w
            XIo_Out8(FTDI_ADDRESS, '\n');					// + newline
            break;
          case 'V':							// Board Rev.
            BoardRev();						// Respond with Board Rev info
            break;
          case 'C': 
            switch (cmd[1]) {
              case '0': 
                subb_ctrl &= ~SBCTRL_CE;			// Clear CMDENBL
                break;
              case '1': 
                subb_ctrl |= SBCTRL_CE;			// Set CMDENBL
                break;
              default:
                cmd_error = '3';		// Illegal CMDENBL Option
                break;
            }
            if (cmd_error == 0) {
              XIo_Out8(FTDI_ADDRESS, 'C');			// Respond with r
              XIo_Out8(FTDI_ADDRESS, (subb_ctrl & SBCTRL_CE) ? '1' : '0' );		// + cmdenbl status
              XIo_Out8(FTDI_ADDRESS, '\n');			// + newline
              XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);	// Activate CMDENBL
            }
            break;
          case 'S': 
            switch (cmd[1]) {
              case '0':
                subb_ctrl &= ~SBCTRL_CS;			// Clear CMDSTRB
                break;
              case '1':
                subb_ctrl |= SBCTRL_CS;			// Set CMDSTRB
                break;
              default:
                cmd_error = '4';		// Illegal CMDSTRB Option
                break;
            }
            if (cmd_error == 0) {
              XIo_Out8(FTDI_ADDRESS, 'S');
              XIo_Out8(FTDI_ADDRESS, (subb_ctrl & SBCTRL_CS) ? '1' : '0' );
              XIo_Out8(FTDI_ADDRESS, '\n');
              XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);	// Activate CMDSTRB
            }
            break;
          default:							// Not a command
            cmd_error = '1';				// Code 2: Unrecognized Cmd
            break;
        }
      } else {
        while (XGpio_DiscreteRead(&Data_Rdy,1) == 0x01)
        cmd[cmd_byte_num] = XIo_In8(FTDI_ADDRESS);
      }

      if (cmd_error != 0) {
        ErrorCode(cmd_error);					// Send ErrorCode back to Host
        hb = 0x0;								// Set HB_Led variable to on
      }

      // Strobe the FTDI "Send Immediate" line:
      XGpio_DiscreteWrite(&FTDI_SI,1,0);
      XGpio_DiscreteWrite(&FTDI_SI,1,1);
    }
    
    
  }
  return 0;
}		

/******************************************************************************
*
* ErrorCode(Xuint8) : Send Error Code Back to Host via USB
*
* @param    Xuint8 Error Code value
* @return   None
* @note     None
*
*******************************************************************************/
void ErrorCode(char code)
{
  char ErrorMsg[8];
  
  //strcpy(ErrorMsg,"E");
  //strcat(ErrorMsg, &code);
  ErrorMsg[0] = 'E';
  ErrorMsg[1] = code;
  ErrorMsg[2] = '\0';
  SendUSB(ErrorMsg);				// Send Code back to Host
}

/******************************************************************************
*
* BoardRev() : Send Board Rev Info Back to Host via USB
*
* @param    None
* @return   None
* @note     None
*
*******************************************************************************/
void BoardRev() {
  SendUSB(BOARD_REV);
}

/******************************************************************************
*
* SendUSB(char *) : Send String Back to Host via USB
*
* @param    String to be sent back to Host via USB
* @return   None
* @note     None
*
*******************************************************************************/
void SendUSB(char *msg)
{
  //Xuint8 i;
  
  while (*msg) {
    XIo_Out8(FTDI_ADDRESS, *msg++);
  }
  //for  (i = 0; i < strlen(msg); i++)	// Send msg string
  //	XIo_Out8(FTDI_ADDRESS, msg[i]);
  XIo_Out8(FTDI_ADDRESS, '\n');			// End with NL
}

