/*
 * Uart.h
 *
 * Created: 15-01-2018 09:45:07
 *  Author: ltpe
 */ 


#ifndef UART_H_
#define UART_H_

//#include "Arduino.h"
#include <stdio.h>

#define UART_NORMAL_MODE
#ifdef UART_NORMAL_MODE
#define MyUBRR (unsigned int)(F_CPU/(16*BAUD) -1)   // normal mode
#else
#define MyUBRR (unsigned int)(F_CPU/(8*BAUD) -1)   // *2 mode
#endif

extern void RS232Init(void);
extern int uart_getch(FILE* stream);
extern int uart_putch(char ch, FILE* stream);
extern void Enable_UART_Receive_Interrupt();
extern void Disable_UART_Receive_Interupt();

//Opgave 2
void UART1_Init(void);
void UART1_SendChar(char c);
void UART1_SendString(const char *text);
uint8_t UART1_GetQueuedChar(char *character);

#endif /* UART_H_ */