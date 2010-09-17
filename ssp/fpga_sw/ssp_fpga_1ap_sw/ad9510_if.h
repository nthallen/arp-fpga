#ifndef AD9510_IF_H_
#define AD9510_IF_H_

extern int SPI_system_init(void);
extern void AD9510_Init(int ChEn, int divisor);
int MAX6628_Read(void);
int MAX6661_Read(void);

#endif /*AD9510_IF_H_*/
