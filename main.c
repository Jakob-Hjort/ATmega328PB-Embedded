/**
 * @file main.c
 * @author ltpe
 * @date 2026-11-05
 * @brief Main function
 */

#include "Include/Timer/Timer.h"
#include "Include/UART/Uart.h"
#include "Include/ProjectDefines.h"
#include <util/atomic.h>
#include <stdio.h>
// #include <avr/io.h>
// #include <avr/interrupt.h>

// #define GreenLedBit PB5  // Antag at den grønne LED er tilsluttet pin PB2

// // Initialiseringsfunktion til Timer 1 med dynamisk millisekund-beregning
// void Timer1_Init_ms(uint16_t timeout_ms) {
//     // 1. Nulstil register for en sikkerheds skyld
//     TCCR1A = 0;
//     TCCR1B = 0;
//     TCNT1  = 0;

//     // 2. Vælg CTC-mode (Clear Timer on Compare Match)
//     // WGM13:0 = 0100 -> WGM12 sættes i TCCR1B
//     TCCR1B |= (1 << WGM12);

//     // 3. Vælg Prescaler = 256
//     // CS12 = 1, CS11 = 0, CS10 = 0 (giver prescaler 256)
//     TCCR1B |= (1 << CS12);

//     // 4. Beregn OCR1A-værdien ud fra ønskede millisekunder
//     // Formel: Ticks = (F_CPU / Prescaler / 1000) * timeout_ms
//     // For 16 MHz og prescaler 256 er frekvensen ind i timeren: 16.000.000 / 256 = 62.500 Hz (62,5 ticks pr. ms)
//     uint32_t ticks = ((F_CPU / 256UL) * timeout_ms) / 1000UL;

//     if (ticks > 0) {
//         ticks--; // Da sammenligningen starter fra 0
//     }

//     // Sørg for at værdien ikke overstiger 16-bit max (65535)
//     if (ticks > 65535) {
//         ticks = 65535;
//     }

//     OCR1A = (uint16_t)ticks;

//     // 5. Aktivér Compare Match A Interrupt for Timer 1
//     TIMSK1 |= (1 << OCIE1A);
// }

// // ISR (Interrupt Service Routine) for Timer 1 Compare Match A
// ISR(TIMER1_COMPA_vect) {
//     // Indsæt den kode, der skal udføres ved hvert timeout.
//     // F.eks. toggling af en LED eller flag-sætning til hovedprogrammet.
//     PORTB ^= (1 << GreenLedBit);
// }

int main(void)
{
    DDRB |= (1 << GreenLedBit); // Sæt PB1 som output for den grønne LED

    // Eksempel 1: Sæt timeout til 500 ms
    Timer1_Init_ms(1000);

    // Hvis du vil skifte til 250ms eller 1000ms, kalder du blot funktionen igen:
    // Timer1_Init_ms(250);
    // Timer1_Init_ms(1000);

    RS232Init();
    UART1_Init();
    Enable_UART_Receive_Interrupt();

    // Aktivér globale interrupts
    sei();

    uint32_t seconds = 0;

    
while (1)
{
    uint8_t oneSecondPassed = 0;

    // Kontrollér timerflaget
    ATOMIC_BLOCK(ATOMIC_RESTORESTATE)
    {
        if (timerFlag == 1)
        {
            timerFlag = 0;
            oneSecondPassed = 1;
        }
    }

    // Hvis der er gået et sekund
    if (oneSecondPassed)
    {
        seconds++;

        char message[48];

        snprintf(message, sizeof(message),
                 "Sekunder efter opstart: %lu\r\n",
                 (unsigned long)seconds);

        // Send sekundtælleren til UART1
        UART1_SendString(message);
    }

    // Send ventende karakterer til UART1
    char character;

    while (UART1_GetQueuedChar(&character))
    {
        UART1_SendChar(character);
    }
}

}
