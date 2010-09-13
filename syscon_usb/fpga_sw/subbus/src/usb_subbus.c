/******************************************************************************
*
* @file usb_subbus
* 
* Listens for commands from USB port (using EPC) 
* and controls the SUBBUS interface
* 
* MODIFICATION HISTORY:
*
* Ver   Who	 Date	 Changes
* ----- --- -------- -----------------------------------------------
* 0.00	mr	11/2/09  Initial release
* 1.00  nta 9/8/10   Full implementation
*
*******************************************************************************/

/***************************** Include Files **********************************/
#include <ctype.h>
#include <stdlib.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xio.h"
#include "string.h"

/* BOARD_REV includes the SUBBUS_SUBFUNCTION code (5 for DACS) and the
 * SUBBUS_FEATURES bitmap (in hex). Values are defined in subbus.h
 */
#define BOARD_REV                   "V5:178:Syscon Rev.C.0.03"
#define	CPU_FREQ					XPAR_CPU_CORE_CLOCK_FREQ_HZ
#define FTDI_ADDRESS 				XPAR_XPS_EPC_0_PRH0_BASEADDR
#define DATA_RDY_DEVICE_ID    		XPAR_XPS_GPIO_DATA_RDY_DEVICE_ID    	
#define HBLED_DEVICE_ID				XPAR_XPS_GPIO_HBLED_DEVICE_ID
#define SUBBUS_CTRL_DEVICE_ID       XPAR_XPS_GPIO_SB_CTRL_DEVICE_ID
#define SUBBUS_STATUS_DEVICE_ID     XPAR_XPS_GPIO_SB_STATUS_DEVICE_ID
#define SUBBUS_ADDR_DEVICE_ID 		XPAR_XPS_GPIO_SB_ADDR_DEVICE_ID
#define SUBBUS_DATA_DEVICE_ID 		XPAR_XPS_GPIO_SB_DATA_DEVICE_ID
#define FTDI_SI_DEVICE_ID           XPAR_XPS_GPIO_FTDI_SI_DEVICE_ID

#define SBCTRL_RD                   0x1
#define SBCTRL_WR                   0x2
#define SBCTRL_CS                   0x4
#define SBCTRL_CE                   0x8
#define SBCTRL_RST                  0x10
#define SBSTAT_DONE                 0x1
#define SBSTAT_ACK                  0x2
#define SBSTAT_INTR                 0x4

#define EXPRD_NS					1000
#define EXPWR_NS					1000
#define CMDSTRB_NS					500
#define	CMD_RCV_TIMEOUT				100000
#define ALL_OUT						0x0000
#define	ALL_IN						0xFFFF
#define EXPRD_PAD					10
#define EXPWR_PAD					10

typedef struct {
  unsigned short address;
  unsigned short bitmask;
} board_intr_t;

static const board_intr_t bd_intrs[] = {
    { 0x0A00, 0x0001 }
};

#define N_INTERRUPTS (sizeof(bd_intrs)/sizeof(board_intr_t))

typedef struct {
  unsigned short intr_id;
  int active;
} interrupt_t;

static interrupt_t interrupts[N_INTERRUPTS];

static void SendUSB(char *);			// Send String Back to Host via USB
static void SendUSB0(char code);
static void SendUSB1(char, unsigned short);
static void SendError(char *code);
static void init_interrupts(void);
static int subbus_read( unsigned short addr, unsigned short *rv );
static int subbus_write( unsigned short addr, unsigned short data);

XGpio FTDI_SI;
XGpio Data_Rdy;
XGpio Subbus_Addr, Subbus_Data;
XGpio Subbus_Ctrl, Subbus_Status;
static unsigned short FailReg = 0;
static unsigned short subb_ctrl = 0;

static void init_gpios(void) {
  // Initialize all GPIO's
  XGpio_Initialize(&Data_Rdy, DATA_RDY_DEVICE_ID);
  XGpio_Initialize(&Subbus_Addr, SUBBUS_ADDR_DEVICE_ID);
  XGpio_Initialize(&Subbus_Data, SUBBUS_DATA_DEVICE_ID);
  XGpio_Initialize(&Subbus_Status, SUBBUS_STATUS_DEVICE_ID);
  XGpio_Initialize(&Subbus_Ctrl, SUBBUS_CTRL_DEVICE_ID);
  XGpio_Initialize(&FTDI_SI, FTDI_SI_DEVICE_ID);
  XGpio_DiscreteWrite(&FTDI_SI,1,1);
}

static void subbus_reset(void) {
  subb_ctrl = 0;
  XGpio_DiscreteWrite(&Subbus_Ctrl, 1, subb_ctrl | SBCTRL_RST);
  XGpio_DiscreteWrite(&Subbus_Ctrl, 1, subb_ctrl);
}

static void init_interrupts(void) {
  int i;
  for ( i = 0; i < N_INTERRUPTS; i++) {
    interrupts[i].active = 0;
  }
}

/**
 * Associates the interrupt at the specified base address with the
 * specified interrupt ID. Does not check to see if the interrupt
 * is already active, since that should be handled in the driver.
 * The only possible error is that the specified address is not
 * in our defined list, so ENOENT.
 * @return non-zero on success. Will return zero if board not listed in table,
 * or no acknowledge detected.
 */
static int intr_attach( int id, unsigned short addr ) {
  int i;
  for ( i = 0; i < N_INTERRUPTS; i++ ) {
    if ( bd_intrs[i].address == addr ) {
      interrupts[i].active = 1;
      interrupts[i].intr_id = id;
      return subbus_write( addr, 0x20 );
    }
  }
  return 0;
}

/**
 * @return non-zero on success. Will return zero if board is not listed in the table
 * or no acknowledge is detected.
 */
static int intr_detach( unsigned short addr ) {
  int i;
  for ( i = 0; i < N_INTERRUPTS; i++ ) {
    if ( bd_intrs[i].address == addr ) {
      interrupts[i].active = 0;
      return subbus_write(addr, 0);
      return 1;
    }
  }
  return 0;
}

static void intr_service(void) {
  unsigned short ivec;
  if ( subbus_read(0x40, &ivec) ) {
    int i;
    for ( i = 0; i < N_INTERRUPTS; i++ ) {
      if (ivec & bd_intrs[i].bitmask) {
        if (interrupts[i].active) {
          SendUSB1('I', interrupts[i].intr_id);
          return;
        } // ### else could send an error, attempt to disable...
      }
    }
  } else SendError("11"); // No ack on INTA
}

/**
 * Reads hex string and sets return value and updates the
 * string pointer to point to the next character after the
 * hex string.
 * @param pointer to pointer to start of hex string
 * @param pointer to return value
 * @return non-zero on error (no number)
 */
static int read_hex( char **sp, unsigned short *rvp) {
  char *s = *sp;
  unsigned short rv = 0;
  if (! isxdigit(*s)) return 1;
  while ( isxdigit(*s)) {
    rv *= 16;
    if (isdigit(*s)) rv += *s - '0';
    else rv += tolower(*s) - 'a' + 10;
    ++s;
  }
  *rvp = rv;
  *sp = s;
  return 0;
}

static void hex_out(unsigned short data) {
  static char hex[] = { '0', '1', '2', '3', '4', '5', '6', '7',
                    '8','9', 'A', 'B', 'C', 'D', 'E', 'F' };
  if (data & 0xFFF0) {
    if (data & 0xFF00) {
      if (data & 0xF000)
        XIo_Out8(FTDI_ADDRESS, hex[(data>>12)&0xF]);
      XIo_Out8(FTDI_ADDRESS, hex[(data>>8)&0xF]);
    }
    XIo_Out8(FTDI_ADDRESS, hex[(data>>4)&0xF]);
  }
  XIo_Out8(FTDI_ADDRESS, hex[data&0xF]);
}

static int pulse_rdwr(Xuint8 subb_ctrl) {
  Xuint8 subb_status;
  XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);		// Issue EXPRD
  for (;;) {
    subb_status = XGpio_DiscreteRead(&Subbus_Status,1);
    if (subb_status & SBSTAT_DONE) break;
  }
  return (subb_status & SBSTAT_ACK) ? 1 : 0;
}

/**
 * @return non-zero if EXPACK is detected.
 */
static int subbus_read( unsigned short addr, unsigned short *rv ) {
  int expack;
  XGpio_DiscreteWrite(&Subbus_Addr,1,addr);  // put it on ADDR bus
  expack = pulse_rdwr(subb_ctrl | SBCTRL_RD);
  *rv = XGpio_DiscreteRead(&Subbus_Data,1); // Read SUBBUS Data
  XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);
  return expack;
}

static int subbus_write( unsigned short addr, unsigned short data) {
  int expack;
  XGpio_DiscreteWrite(&Subbus_Addr,1,addr);  // put it on ADDR bus
  XGpio_DiscreteWrite(&Subbus_Data,1,data);  // put it on DATA bus
  expack = pulse_rdwr(subb_ctrl | SBCTRL_WR);
  XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);
  return expack;
}

static void parse_command(char *cmd) {
  int nargs = 0;
  char cmd_code;
  unsigned short arg1, arg2;
  unsigned short rv;
  int expack;

  switch(*cmd) {
    case 'B':
    case 'f':
    case 'D':
    case 'T':
    case 'A':
    case 'V': nargs = 0; break;
    case 'R':
    case 'C':
    case 'S':
    case 'u':
    case 'F': nargs = 1; break;
    case 'i':
    case 'W': nargs = 2; break;
    case '\n': SendUSB("0"); return; // special case: NOP
    default: SendError("1"); return; // Code 1: Unrecognized command
  }
  cmd_code = *cmd++;
  if (nargs > 0) {
    if (read_hex(&cmd,&arg1)) {
      SendError("3");
      return;
    }
    if (nargs > 1) {
      if (*cmd++ != ':' || read_hex(&cmd,&arg2)) {
        SendError("3");
        return;
      }
    }
  }
  if (*cmd != '\n') {
    SendError("3");
    return;
  }
  switch(cmd_code) {
    case 'R':                         // READ with ACK 'R'
      expack = subbus_read(arg1, &rv);
      SendUSB1(expack ? 'R' : 'r', rv);
      break;
    case 'W':                         // WRITE with ACK 'W'
      expack = subbus_write(arg1, arg2);
      XGpio_DiscreteWrite(&Subbus_Addr,1,arg1);  // put it on ADDR bus
      XGpio_DiscreteWrite(&Subbus_Data,1,arg2);  // put it on DATA bus
      expack = pulse_rdwr(subb_ctrl | SBCTRL_WR);
      XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);
      SendUSB(expack ? "W" : "w");
      break;
    case 'F':
      // ### Need to write to hardware
      FailReg = arg1;
      SendUSB( "F" );
      break;
    case 'f':
      // ### Need to read from hardware
      SendUSB1('f', FailReg);
      break;
    case 'C':
    case 'S':
      { unsigned short bit = (cmd_code == 'C') ? SBCTRL_CE : SBCTRL_CS;
        if (arg1) subb_ctrl |= bit;
        else subb_ctrl &= ~bit;
        XGpio_DiscreteWrite(&Subbus_Ctrl,1,subb_ctrl);
      }
      SendUSB0(cmd_code);
      break;
    case 'B':
      subbus_reset();
      init_interrupts();
      SendUSB("B");
      break;
    case 'V':                         // Board Rev.
      SendUSB(BOARD_REV);             // Respond with Board Rev info
      break;
    case 'D': // Read Switches
      // ### Actually read from hardware
      SendUSB1('D', 0);
      break;
    case 'T': // Tick
      // ### Actually write to hardware
      // No return output
      break;
    case 'A': // Disarm 2-second reboot
      // ### Actually write to hardware
      SendUSB("A");
      break;
    case 'i':
      if ( intr_attach(arg1, arg2))
        SendUSB1('i', arg1);
      else SendError("4");
      break;
    case 'u':
      if ( intr_detach(arg1) )
        SendUSB1('u', arg1);
      else SendError("4");
      break;
    default:                          // Not a command
      SendError("10");       // Should not happen
      break;
  }
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
int main(void) {
  char cmd[15];							// Current Command
  int cmd_byte_num = 0;
  int cmd_rcv_timer = 0;
  
  init_gpios();
  subbus_reset();
  
  while(1) {
    if ( XGpio_DiscreteRead(&Data_Rdy,1) == 1 ) {
      int c = XIo_In8(FTDI_ADDRESS);
      cmd[cmd_byte_num++] = c;
      if ( c == '\n' ) {
        parse_command(cmd);
        cmd_byte_num = 0;
      } else if (cmd_byte_num >= 15) {
        SendError("8"); // Error code 8: Too many bytes before NL
        while ( XGpio_DiscreteRead(&Data_Rdy,1) == 1 && XIo_In8(FTDI_ADDRESS) != '\n' ) ;
        cmd_byte_num = 0;
      }
    } else if (cmd_byte_num > 0 && ++cmd_rcv_timer > CMD_RCV_TIMEOUT) {
      SendError("2"); // Code 2: Rcv Timeout
      cmd_byte_num = 0;
    }
    if ( XGpio_DiscreteRead(&Subbus_Status,1) & SBSTAT_INTR)
      intr_service();
  }
  return 0;
}		

/******************************************************************************
*
* SendError(char *code) : Send Error Code Back to Host via USB
*
* @param    Error code string (w/o 'E')
* @return   None
* @note     None
*
*******************************************************************************/
static void SendError(char *code) {
  XIo_Out8(FTDI_ADDRESS, 'E');
  SendUSB(code);
}

/**
 * Sends String Back to Host via USB, appending a newline and
 * strobing the FTDI "Send Immediate" line. Every response
 * should end by calling this function.
 *
 * @param    String to be sent back to Host via USB
 * @return   None
 *
 */
static void SendUSB(char *msg) {
  while (*msg)
    XIo_Out8(FTDI_ADDRESS, *msg++);
  XIo_Out8(FTDI_ADDRESS, '\n');			// End with NL
  // Strobe the FTDI "Send Immediate" line:
  XGpio_DiscreteWrite(&FTDI_SI,1,0);
  XGpio_DiscreteWrite(&FTDI_SI,1,1);
}

static  void SendUSB1(char code, unsigned short val) {
  XIo_Out8(FTDI_ADDRESS, code);
  hex_out(val);
  SendUSB("");
}

static void SendUSB0(char code) {
  XIo_Out8(FTDI_ADDRESS, code);
  SendUSB("");
}
