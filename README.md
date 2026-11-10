# ATmega328PB – Embedded opgaver

Dette repository indeholder embedded-opgaver udviklet i C til **ATmega328PB Xplained Mini**.

## Opgave 1 – Timer Interrupt og UART0

### Formål
Programmet skal få en LED til at blinke ved hjælp af et timer-interrupt og samtidig modtage tekst fra en computer via UART0. Store bogstaver konverteres til små, små bogstaver til store, mens andre tegn sendes uændret tilbage.

### Hardware og udviklingsmiljø
- Mikrocontroller: ATmega328PB Xplained Mini
- Sprog: C
- Compiler: AVR-GCC
- Udviklingsmiljø: VS Code med MPLAB-udvidelser
- Seriel forbindelse: UART0 via boardets USB-forbindelse (`/dev/ttyACM0` på Ubuntu)
- UART-indstillinger: 9600 baud, 8 databits, ingen paritet, 1 stopbit
- LED: PB5

### Projektets opbygning
| Fil | Funktion |
| --- | --- |
| `main.c` | Initialiserer LED, Timer1 og UART0 samt aktiverer globale interrupts. |
| `Timer.c` / `Timer.h` | Konfigurerer Timer1 og håndterer timer-interruptet. |
| `Uart.c` / `Uart.h` | Initialiserer UART0 og håndterer modtagelse, bogstavkonvertering og afsendelse. |
| `ProjectDefines.h` | Samler fælles projektdefinitioner, hvor de anvendes. |

### Sådan fungerer programmet
Ved opstart sættes PB5 som output. Timer1 initialiseres i **CTC-mode** med prescaler **256**. Ved en clockfrekvens på 16 MHz sættes compare-værdien, så `TIMER1_COMPA_vect` udløses cirka hvert **500 ms**. Interrupt-funktionen skifter LED'ens tilstand, så den skiftevis tænder og slukker. En fuld tænd/sluk-cyklus varer cirka ét sekund.

UART0 initialiseres til **9600 baud**, og modtage-interruptet aktiveres. Når en karakter modtages, udløses `USART0_RX_vect`. Programmet undersøger karakterens ASCII-værdi:

- `A`–`Z` ændres til `a`–`z`.
- `a`–`z` ændres til `A`–`Z`.
- Tal, mellemrum og specialtegn sendes uændret tilbage.

Det behandlede tegn sendes tilbage til computeren via UART0. `sei()` aktiverer de globale interrupts, hvorefter `main()` kører i et tomt `while (1)`-loop. Timer- og UART-hændelserne håndteres af to separate interrupt-rutiner; CPU'en udfører dem én ad gangen.

### Test
Programmet er testet med LED-blink og seriel kommunikation. For eksempel:

| Sendt på UART0 | Forventet svar |
| --- | --- |
| `test` | `TEST` |
| `ABC` | `abc` |
| `Hej 123!` | `hEJ 123!` |
| `987!?` | `987!?` |

Ved testen blev bogstavkonverteringen med `test` → `TEST` bekræftet, samtidig med at LED'en blinkede. De øvrige eksempler er egnede som ekstra kontroltest.

### Konklusion
Opgave 1 demonstrerer, hvordan to forskellige hardware-interrupts kan bruges i samme program: **Timer1** til LED-blink og **UART0 Receive Interrupt** til seriel kommunikation og tegnkonvertering.

## Opgave 2 – UART0 og UART1

*Tilføjes, når opgave 2 er implementeret og testet.*
