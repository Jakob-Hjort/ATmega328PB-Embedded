# ATmega328PB – Embedded opgaver

Dette repository indeholder embedded-opgaver udviklet i C til **ATmega328PB Xplained Mini**.

## Opgave 2 – Timer Interrupt, UART0 og UART1

### Formål

Programmet bygger videre på opgave 1 og skal få en LED til at skifte tilstand hvert sekund ved hjælp af et timer-interrupt. Samtidig skal programmet tælle sekunder efter opstart og sende sekundtælleren til computeren via UART1.

Når der modtages tekst på UART0, skal store bogstaver konverteres til små og omvendt. Tal og specialtegn sendes uændret videre. De behandlede karakterer skal sendes til både UART0 og UART1.

### Hardware og udviklingsmiljø

- Mikrocontroller: ATmega328PB Xplained Mini
- Sprog: C
- Compiler: AVR-GCC
- Udviklingsmiljø: VS Code med MPLAB-udvidelser
- UART0: Boardets USB-forbindelse (`/dev/ttyACM0` på Ubuntu)
- UART1: Ekstern CP2101/CP2102 USB-UART-adapter (`/dev/ttyUSB0` på Ubuntu)
- UART-indstillinger: 9600 baud, 8 databits, ingen paritet, 1 stopbit
- LED: PB5
- Timer1: CTC-mode med interrupt hvert 1000 ms

### Projektets opbygning

| Fil | Funktion |
| --- | --- |
| `main.c` | Initialiserer Timer1, UART0 og UART1, håndterer sekundtælleren og sender data via UART1. |
| `Timer.c` / `Timer.h` | Konfigurerer Timer1, styrer LED'en og sætter et flag hvert sekund. |
| `Uart.c` / `Uart.h` | Håndterer UART0, UART1, bogstavkonvertering og videresendelse af karakterer. |
| `ProjectDefines.h` | Samler fælles definitioner som CPU-frekvens, baudrate og LED-pins. |

### Sådan fungerer programmet

Ved opstart konfigureres LED-pinnen som output. Timer1 initialiseres i **CTC-mode**, så `TIMER1_COMPA_vect` udløses cirka hvert **1000 ms**. Interrupt-funktionen skifter LED'ens tilstand og sætter variablen `timerFlag` til 1.

Hovedprogrammet kontrollerer `timerFlag` i sit `while (1)`-loop. Når flaget er sat, bliver det nulstillet, og sekundtælleren øges med 1. Ved hjælp af `ATOMIC_BLOCK` sikres det, at aflæsningen og nulstillingen sker uden afbrydelse fra et interrupt.

Sekundtallet omdannes til tekst og sendes via **UART1** til computeren gennem CP2101/CP2102-adapteren.

UART0 initialiseres til **9600 baud**, og modtage-interruptet aktiveres. Når en karakter modtages, udløses `USART0_RX_vect`. Programmet undersøger karakterens ASCII-værdi:

- `A`–`Z` ændres til `a`–`z`.
- `a`–`z` ændres til `A`–`Z`.
- Tal, mellemrum og specialtegn sendes uændret videre.

Den konverterede karakter sendes direkte tilbage på UART0 og gemmes samtidig i en **ringbuffer**, som hovedprogrammet efterfølgende læser fra og sender videre til UART1.

Ringbufferen anvendes for at undgå, at UART0-interruptet og hovedprogrammet forsøger at sende data på UART1 samtidig.

De globale interrupts aktiveres med `sei()`, hvorefter hovedprogrammet fortsætter i et uendeligt loop. Timer- og UART-interrupts håndteres separat, mens UART1-afsendelsen udføres fra hovedprogrammet.

### Test

Programmet er testet med LED-blink og to samtidige serielle forbindelser.

**Timer1 og UART1:**

LED'en skifter tilstand cirka hvert sekund, og UART1 viser sekundtælleren:

```text
Sekunder efter opstart: 1
Sekunder efter opstart: 2
Sekunder efter opstart: 3
```

**UART0 og UART1:**

Bogstavkonverteringen er testet ved at sende tekst til UART0 og kontrollere, at samme konverterede tekst modtages på begge UART-forbindelser.

| Sendt på UART0 | Modtaget på UART0 | Modtaget på UART1 |
| --- | --- | --- |
| `Hej 123!` | `hEJ 123!` | `hEJ 123!` |

Ved testen blev det bekræftet, at UART1 modtog både sekundtælleren og den konverterede tekst, mens UART0 returnerede den konverterede tekst.

Den konverterede tekst kan blive vist på samme linje som en sekundbesked, hvis teksten ikke afsluttes med et linjeskift.

### Konklusion

Opgave 2 demonstrerer, hvordan **Timer1, UART0 og UART1** kan anvendes i samme program.

Timer1 styrer LED'en og giver hovedprogrammet besked om, at der er gået et sekund. UART0 modtager og konverterer karakterer, mens UART1 sender både sekundtælleren og en kopi af de konverterede karakterer.

Ved hjælp af interrupts, et timerflag og en ringbuffer kan mikrocontrolleren håndtere de forskellige funktioner uden at hovedprogrammet konstant skal overvåge hardwareregistrene.
