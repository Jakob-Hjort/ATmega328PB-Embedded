#ifndef TIMER_H_
#define TIMER_H_

/*
Det kaldes en include guard og forhindrer, at indholdet af den samme headerfil bliver behandlet flere gange i én kompileringsenhed.
*/


#include <stdint.h>

extern void Timer1_Init_ms(uint16_t timeout_ms);
extern volatile uint8_t timerFlag;

#endif /* TIMER_H_ */