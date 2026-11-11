/*
 * ProjectDefines.h
 *
 * Created: 15-01-2018 14:56:37
 *  Author: ltpe
 */ 

#ifndef PROJECTDEFINES_H_
#define PROJECTDEFINES_H_

#define F_CPU 16000000UL  // Antager 16 MHz krystal (ret hvis din kører med f.eks. 8 MHz)
#define GreenLedBit PORTB5
#define BAUD 9600UL

#include <avr/io.h>
#include <avr/interrupt.h>

#if defined (_AVR_IOM168_H_) || defined (_AVR_IOM328P_H_)
#define USR0_Vect_Num USART_RX_vect

#endif

#if defined (_AVR_IOM2560_H_) || defined (_AVR_ATMEGA328PB_H_INCLUDED)
#define USR0_Vect_Num USART0_RX_vect 

#endif

#if defined(_AVR_IOM2560_H_) || defined (_AVR_ATMEGA328PB_H_INCLUDED)
#define GreenLedBit		PORTB5
#define YellowLedBit    PORTB1
#define RedLedBit		PORTB2
#endif

#endif /* PROJECTDEFINES_H_ */