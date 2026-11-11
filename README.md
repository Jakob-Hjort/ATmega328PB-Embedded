# ATmega328PB – Embedded opgave 1 og 2

Dette repository indeholder to embedded-opgaver skrevet i **C** til **ATmega328PB Xplained Mini**. Opgave 2 bygger videre på opgave 1. Programmet bruger hardware-interrupts til at blinke med en LED og behandle seriel kommunikation.

## Hardware og udviklingsmiljø

- **Mikrocontroller:** ATmega328PB Xplained Mini
- **Udvikling:** Visual Studio Code med MPLAB-udvidelser på Ubuntu
- **Compiler:** AVR-GCC 14.3.0
- **Programmering:** Boardets mEDBG via USB (AVRDude)
- **UART0:** Boardets USB-forbindelse, typisk `/dev/ttyACM0`
- **UART1:** Ekstern CP2101/CP2102 USB-UART-adapter, typisk `/dev/ttyUSB0`
- **Serielle indstillinger:** 9600 baud, 8 databits, ingen paritet, 1 stopbit (8N1)
- **CPU-frekvens:** 16 MHz som angivet af `F_CPU`
- **LED:** Styres af `GreenLedBit` på port B. Den konkrete pin skal passe til boardets/LED'ens tilslutning og værdien i `ProjectDefines.h`.

## Projektstruktur

```text
IOT-projekt1/
├── .vscode/                    # MPLAB-projektindstillinger
├── Include/
│   ├── ProjectDefines.h       # Fælles definitioner
│   ├── Timer/
│   │   └── Timer.h            # Timer-deklarationer og timerFlag
│   └── UART/
│       └── Uart.h             # UART-funktioner
├── Src/
│   ├── Timer/
│   │   └── Timer.c            # Timer1 og timer-interrupt
│   └── UART/
│       └── Uart.c             # UART0/UART1 og ringbuffer
├── main.c                     # Initialisering og hovedloop
├── README.md
└── softwarebeskrivelse-opgave1.odt
```

*Buildmapper såsom `_build/` og `out/` dannes lokalt og behøver ikke ligge på GitHub.*

---

## Opgave 1 – Timer Interrupt og UART0

### Formål

Programmet skal få en LED til at blinke med et skift hvert **500 ms** og samtidig modtage karakterer fra en PC gennem UART0. Store bogstaver skal ændres til små, små bogstaver til store, og alle andre tegn skal returneres uændret.

### Sådan virker programmet

Ved opstart konfigurerer `main.c` LED-pinnen som output. Timer1 sættes op i **CTC-mode** (Clear Timer on Compare Match) med en prescaler på **256**. Ved 16 MHz svarer compare-værdien `OCR1A = 31249` til ca. 500 ms. Når timeren når værdien, aktiveres `ISR(TIMER1_COMPA_vect)`, som skifter LED'ens tilstand. Den er dermed tændt og slukket i skiftende intervaller på ca. 500 ms.

UART0 sættes op til **9600 baud, 8N1**, og UART0's modtage-interrupt aktiveres. Når der kommer en karakter fra PC'en, udføres `ISR(USART0_RX_vect)`. Her kontrolleres karakteren ud fra ASCII:

- `A`–`Z` konverteres til `a`–`z`.
- `a`–`z` konverteres til `A`–`Z`.
- Tal, mellemrum og specialtegn ændres ikke.

Derefter sendes karakteren tilbage gennem UART0. `sei()` aktiverer globale interrupts, og hovedprogrammet kan være i et tomt `while (1)`-loop. Timer1 og UART0 er **to separate interruptkilder**; CPU'en håndterer dem efter tur.

### Test

| Sendt på UART0 | Forventet svar |
| --- | --- |
| `test` | `TEST` |
| `ABC` | `abc` |
| `Hej 123!` | `hEJ 123!` |
| `987!?` | `987!?` |

LED-blink og `test` → `TEST` blev afprøvet under udviklingen. De øvrige rækker viser, hvad programmet skal returnere.

---

## Opgave 2 – Timerflag, sekundtæller og UART1

### Formål

Opgave 2 videreudvikler løsningen, så **begge UART-enheder** bruges. Timer1 skal udløse et interrupt hvert **1000 ms**, hvor LED'en skifter tilstand og et flag sættes. Hovedloopet skal nulstille flaget, tælle sekunder og udskrive `Sekunder efter opstart: N` på **UART1**. Tegn modtaget på UART0 konverteres som i opgave 1, men skal nu sendes tilbage på **både UART0 og UART1**.

### Timer1 og flaget

Timer1 er fortsat i CTC-mode. Med prescaler 256, 16 MHz og et interval på 1000 ms bliver `OCR1A = 62499`.

Ved hvert compare match:

1. LED'en skifter tilstand.
2. Timer-interruptet sætter `timerFlag = 1`.
3. Hovedloopet læser og nulstiller flaget i en `ATOMIC_BLOCK`, så aflæsning og nulstilling sker samlet.
4. Variablen `seconds` øges, og en besked formateres med `snprintf()`.
5. Beskeden sendes på UART1 med `UART1_SendString()`.

Flaget er deklareret `volatile`, fordi det ændres i et interrupt. Programmet bruger et enkelt flag frem for en hændelsestæller; det forudsætter, at hovedloopet når at behandle flaget inden næste sekund.

Eksempel på output fra UART1:

```text
Sekunder efter opstart: 1
Sekunder efter opstart: 2
Sekunder efter opstart: 3
```

### UART0, UART1 og ringbuffer

UART0 modtager karakterer fra PC'en og aktiverer `USART0_RX_vect`. Hvert tegn bliver konverteret som i opgave 1 og sendt direkte tilbage på UART0.

Det samme konverterede tegn lægges i en **ringbuffer**. Hovedloopet henter tegnene fra bufferen og sender dem videre via UART1. På den måde er det kun hovedloopet, der skriver til UART1, både når der sendes sekundbeskeder og tegn fra UART0. Det reducerer risikoen for, at de to afsendelser forstyrrer hinanden.

Ringbufferen har en begrænset kapacitet. Hvis den bliver fuld, kan nye tegn til UART1 blive sprunget over i denne enkle implementering.

### Fysisk tilslutning

| ATmega328PB | CP2101/CP2102 | Funktion |
| --- | --- | --- |
| PB3 / TXD1 | RXD | Data fra UART1 til PC |
| PB4 / RXD1 | TXD | Data fra PC til UART1 (valgfri til denne opgaves sendetest) |
| GND | GND | Fælles stel |

Boardets almindelige USB-kabel bruges fortsat til UART0 og programmering. Kontroller, at adapterens logikniveau er kompatibelt med mikrocontrolleren; forbind ikke to separate strømforsyninger direkte uden at have kontrolleret deres specifikationer.

### Test og resultat

Der blev åbnet to serielle monitorer på Ubuntu:

| Port | Resultat |
| --- | --- |
| `/dev/ttyACM0` (UART0) | `Hej 123!` blev returneret som `hEJ 123!` |
| `/dev/ttyUSB0` (UART1) | Sekundbeskeder blev vist, og den konverterede tekst `hEJ 123!` blev modtaget |

Et eksempel fra UART1-testen:

```text
Sekunder efter opstart: 25
Sekunder efter opstart: 26
hEJ 123!Sekunder efter opstart: 27
Sekunder efter opstart: 28
```

Teksten kan stå lige foran en sekundbesked, fordi tegnene fra UART0 ikke nødvendigvis afsluttes med linjeskift. Det ændrer ikke ved, at de modtages og videresendes korrekt. LED'en blev samtidig observeret skifte tilstand med cirka ét sekund mellem skiftene.

### Konklusion

Opgave 2 demonstrerer anvendelse af **Timer1 Interrupt**, **UART0 Receive Interrupt**, et delt timerflag og en **ringbuffer**. Timer1 styrer LED og sekundtælling, UART0 konverterer modtagne tegn, og UART1 udsender både sekundstatus og de konverterede tegn. Hovedloopet koordinerer afsendelsen på UART1, mens interrupts håndterer hardwarehændelserne.

---

## Byg og programmér boardet

1. Åbn projektet i VS Code og byg den relevante MPLAB-konfiguration (`default`).
2. Stop eventuel aktiv debug-session, så programmeringsenheden er ledig.
3. Kontrollér, at firmwarefilen findes, og programmér boardet fra projektmappen:

```bash
ls -lh out/Opgave1/default.hex
avrdude -c xplainedmini -p m328pb -P usb -U flash:w:out/Opgave1/default.hex:i
```

En vellykket programmering afsluttes typisk med `flash verified` og `avrdude done. Thank you.`

**Bemærk:** I det aktuelle projekt hedder MPLAB-konfigurationen stadig `Opgave1`, selvom kildekoden er blevet videreudviklet til opgave 2. Versionshistorik eller en separat Git-branch kan bruges til at finde den oprindelige version af opgave 1.

## Læringspunkter

- Konfiguration af hardware-timere, prescaler og CTC-mode.
- Brug af interrupts i stedet for konstant polling i hovedloopet.
- UART-kommunikation med 8N1 og ASCII-konvertering.
- Deling af data mellem interrupt og hovedloop med `volatile` og atomiske operationer.
- Buffering og videresendelse af data mellem to UART-enheder.
