#include "stdio.h"
#include "xparameters.h"
#include "xgpio.h"
#include "xutil.h"
#include "xtmrctr.h"
#include "mb_interface.h"

//====================================================

XGpio led,Push,ledPush;
XTmrCtr XTC;
int push_check=0;
volatile int intr_count = 0;

void gpio_init( void ) {
   XStatus returned_stat=1;

    returned_stat = XGpio_Initialize(&led,XPAR_LEDS_4BIT_DEVICE_ID);
    xil_printf("LEDS XGpio_Initialize returned: %0x\r\n", returned_stat);

    returned_stat = XGpio_Initialize(&ledPush,XPAR_LEDS_POSITIONS_DEVICE_ID);
    xil_printf("LEDS POSITIONS XGpio_Initialize returned: %0x\r\n", returned_stat);
    
    returned_stat = XGpio_Initialize(&Push,XPAR_PUSH_BUTTONS_POSITION_DEVICE_ID);
    xil_printf("PUSH_BUTTONS XGpio_Initialize returned: %0x\r\n", returned_stat);
    
    XGpio_SetDataDirection(&led,1,0x0);
    XGpio_SetDataDirection(&ledPush,1,0x0);
    XGpio_SetDataDirection(&Push,1,0xffffffff);
    
    xil_printf("Press center push button to exit\r\n");
    xil_printf("Any other to see corresponding LED turn ON\r\n");
    
    push_check = XGpio_DiscreteRead(&Push,1);
    xil_printf("Initial push_check: %0x\r\n", push_check);
}

// return non-zero if center button is pressed
int gpio_check( void ) {
    int push_check1 = XGpio_DiscreteRead(&Push,1);
    if(push_check1 != push_check)
    {
        push_check=push_check1;
        if(push_check)
            xil_printf("Push buttons status %0x\r\n", push_check1);
    }
    if(push_check==0x10)
        return 1;
    // XGpio_DiscreteWrite(&led,1,push_check);
    return 0;
}

void TimerCounterHandler(void *CallBackRef, Xuint8 TmrCtrNumber);

int main (void) {
    int old_count = 0;

    gpio_init();
    XGpio_DiscreteWrite(&led,1,0);
    XGpio_DiscreteWrite(&ledPush,1,0x1);
    xil_printf("-- Entering main() --\r\n");
    XTmrCtr_Initialize(&XTC, XPAR_OPB_TIMER_0_DEVICE_ID );
    XTmrCtr_SetOptions(&XTC, 0, XTC_DOWN_COUNT_OPTION | XTC_INT_MODE_OPTION );
    XTmrCtr_SetHandler(&XTC, TimerCounterHandler, &XTC);
    microblaze_enable_interrupts();
    XTmrCtr_SetResetValue ( &XTC, 0, 300*1000000L );
    XTmrCtr_Start( &XTC, 0 );
    XGpio_DiscreteWrite(&ledPush,1,0x3);
    while(1) {
        if (gpio_check()) break;
	    if ( old_count != intr_count ) {
		  xil_printf("  TmrCtr update %d\r\n", intr_count );
          XGpio_DiscreteWrite(&led,1,3);
	      XGpio_DiscreteWrite(&ledPush,1,0x10 | (intr_count&0xF));
		  old_count = intr_count;
		}
    }
	XTmrCtr_Stop(&XTC, 0 );
	microblaze_disable_interrupts();
    XGpio_DiscreteWrite(&ledPush,1,0x10);
    xil_printf("-- Exiting main() --\r\n");
    return 0;
}

void TimerCounterHandler(void *CallBackRef, Xuint8 TmrCtrNumber)
{
  XTmrCtr *XTC = (XTmrCtr *)CallBackRef;
  XTmrCtr_Stop(XTC, 0 );
  //XGpio_DiscreteWrite(&led,1,1);
  intr_count++;
}
