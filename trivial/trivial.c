#include "xmk.h"
#include <stdio.h>

int main()
{
  xil_printf("Before xilkernel_main\n");
	xilkernel_main();
}

void *main_main(void *arg) {
  int i = 0;
  for (;;) {
    xil_printf("In main_main: %d\n", i++);
    sleep(2000);
  }
}
