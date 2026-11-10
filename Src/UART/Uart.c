/*
 * Uart.c
 *
 * Created: 15-01-2018 09:44:48
 *  Author: ltpe
 */ 


#include <stdio.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include "../../Include/ProjectDefines.h"
#include "../../Include/UART/Uart.h"

 static FILE uart_output = FDEV_SETUP_STREAM(uart_putch, NULL, _FDEV_SETUP_WRITE);
 static FILE uart_input = FDEV_SETUP_STREAM(NULL, uart_getch, _FDEV_SETUP_READ);


 void RS232Init(void)
 {
	 // Set baud rate
	 UBRR0L = (unsigned char)(MyUBRR & 0xff);
	 UBRR0H = (unsigned char)(MyUBRR>>8);
	 #ifdef UART_NORMAL_MODE
	 UCSR0A = 0x00;
	 #else
	 UCSR0A = 1<<U2X; // Set *2 mode
	 #endif
	 UCSR0B = (1<<RXEN0) | (1<<TXEN0);  //0x18 , enable receive and transmit
	 UCSR0C = (1 << UCSZ01) | (1 << UCSZ00); // 8 data bit 1 stop bit
	 stdout = &uart_output;
	 stdin = &uart_input;
 }

 void Enable_UART_Receive_Interrupt()
 {
	 UCSR0B |= (1 << RXCIE0); // Enable the USART Recieve Complete interrupt (USART_RXC)
 }

 void Disable_UART_Receive_Interupt()
 {
	UCSR0B &= ~(1 << RXCIE0); // Disable the USART Recieve Complete interrupt (USART_RXC)
 }

 int uart_getch(FILE* stream)
 {
	 while( !(UCSR0A & (1<<RXC0)))  ; // do nothing but wait
	 return( UDR0);
 }

 int uart_putch(char ch, FILE* stream)
 {
	 while( !(UCSR0A & (1<<UDRE0))) ;
	 UDR0 = ch;
	 return 0;
 }

 ISR(USART0_RX_vect)
{
    char ReceivedByte = UDR0;

    // Stort bogstav A-Z -> lille bogstav a-z
    if (ReceivedByte >= 'A' && ReceivedByte <= 'Z')
    {
        ReceivedByte += 32;
    }
    // Lille bogstav a-z -> stort bogstav A-Z
    else if (ReceivedByte >= 'a' && ReceivedByte <= 'z')
    {
        ReceivedByte -= 32;
    }

    // Vent indtil UART0 er klar til at sende
    while (!(UCSR0A & (1 << UDRE0)))
    {
    }

    // Send det konverterede tegn tilbage
    UDR0 = ReceivedByte;
}