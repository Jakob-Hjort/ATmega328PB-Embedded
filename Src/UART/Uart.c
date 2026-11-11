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

#include <util/atomic.h>

#define UART1_BUFFER_SIZE 128

// Buffer til tegn, som skal sendes på UART1
static volatile char uart1Buffer[UART1_BUFFER_SIZE];

// Position hvor næste tegn gemmes
static volatile uint8_t uart1Head = 0;

// Position hvor næste tegn hentes
static volatile uint8_t uart1Tail = 0;

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


/*
 * Gem et tegn i UART1-bufferen.
 * Kaldes fra UART0 Receive Interrupt.
 */
static void UART1_QueueChar(char character)
{
    // Beregn næste ledige position
    uint8_t nextHead = (uart1Head + 1) % UART1_BUFFER_SIZE;

    // Gem kun tegnet, hvis bufferen ikke er fuld
    if (nextHead != uart1Tail)
    {
        uart1Buffer[uart1Head] = character;
        uart1Head = nextHead;
    }
}


/*
 * Hent et tegn fra UART1-bufferen.
 * Returnerer 1 hvis der blev hentet et tegn.
 * Returnerer 0 hvis bufferen er tom.
 */
uint8_t UART1_GetQueuedChar(char *character)
{
    uint8_t received = 0;

    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        if (uart1Tail != uart1Head)
        {
            *character = uart1Buffer[uart1Tail];

            uart1Tail =
                (uart1Tail + 1) % UART1_BUFFER_SIZE;

            received = 1;
        }
    }

    return received;
}



 
ISR(USART0_RX_vect)
{
    // Læs karakteren fra UART0
    char ReceivedByte = UDR0;

    // Stort bogstav -> lille bogstav
    if (ReceivedByte >= 'A' && ReceivedByte <= 'Z')
    {
        ReceivedByte += 32;
    }

    // Lille bogstav -> stort bogstav
    else if (ReceivedByte >= 'a' && ReceivedByte <= 'z')
    {
        ReceivedByte -= 32;
    }

    // Vent indtil UART0 er klar til at sende
    while (!(UCSR0A & (1 << UDRE0)))
    {
    }

    // Send tegnet tilbage på UART0
    UDR0 = ReceivedByte;

    // Læg samme tegn i kø til UART1
    UART1_QueueChar(ReceivedByte);
}


// Opgave 2 funktioner

void UART1_Init(void)
{
    // Beregn baudrate til UART1 (9600 baud)
    uint16_t ubrr = (F_CPU / (16UL * BAUD)) - 1;

    // Indstil UART1 baudrate
    UBRR1H = (uint8_t)(ubrr >> 8);
    UBRR1L = (uint8_t)ubrr;

    // Normal hastighed (ikke double speed)
    UCSR1A = 0;

    // Aktivér UART1 transmitter
    UCSR1B = (1 << TXEN1);

    // 8 databits, ingen paritet, 1 stopbit
    UCSR1C = (1 << UCSZ11) | (1 << UCSZ10);
}


// Sender én karakter gennem UART1
void UART1_SendChar(char c)
{
    // Vent indtil UART1 er klar til at sende
    while (!(UCSR1A & (1 << UDRE1)))
    {
    }

    UDR1 = c;
}


// Sender en hel tekst gennem UART1
void UART1_SendString(const char *text)
{
    while (*text != '\0')
    {
        UART1_SendChar(*text);
        text++;
    }
}
