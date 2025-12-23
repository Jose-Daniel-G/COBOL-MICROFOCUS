      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIESA-MENU-NAV.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  OPCION-CAPTURA    PIC X VALUE SPACE.
       01  MODULO-ACTUAL     PIC 9 VALUE 2. *> 1:Finan, 2:Comer, 3:Manuf
       01  FECHA-SISTEMA      PIC X(15) VALUE "ENERO 08, 2025".

       SCREEN SECTION.
       01  BARRA-ESTATICA.
           05 BLANK SCREEN BACKGROUND-COLOR 1.
           *> 1. BARRA DE TITULO AZUL OSCURO
           05 LINE 1 COL 1 VALUE " SIESA 8.5  R.21.08.01" BACKGROUND-COLOR 4
                                                          FOREGROUND-COLOR 7.
           05 LINE 1 COL 65 FROM FECHA-SISTEMA BACKGROUND-COLOR 4
                                               FOREGROUND-COLOR 7.
           *> 2. LA BARRA DE MENÚ HORIZONTAL (Gris con letras rojas)
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-CAPTURA) = "S"
               DISPLAY BARRA-ESTATICA
               PERFORM DIBUJAR-OPCIONES

               *> Captura de navegación en la barra inferior o mediante letras
               DISPLAY "MODULO: [ ] (F:Finan, C:Comer, M:Manuf, S:Salir)" LINE 24 COL 1
               ACCEPT OPCION-CAPTURA LINE 24 COL 10

               EVALUATE FUNCTION UPPER-CASE(OPCION-CAPTURA)
                   WHEN "A" MOVE 0 TO MODULO-ACTUAL
                   WHEN "E" MOVE 1 TO MODULO-ACTUAL
                   WHEN "F" MOVE 2 TO MODULO-ACTUAL
                   WHEN "C" MOVE 3 TO MODULO-ACTUAL
                   WHEN "M" MOVE 4 TO MODULO-ACTUAL
                   WHEN "D" MOVE 5 TO MODULO-ACTUAL
               END-EVALUATE
           END-PERFORM.
           STOP RUN.

       DIBUJAR-OPCIONES.

           *> --- A ---
           IF MODULO-ACTUAL = 0
              DISPLAY "[A]" LINE 2 COL 2
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY "[" LINE 2 COL 2 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
              DISPLAY "A" LINE 2 COL 3 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "]" LINE 2 COL 4 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.

           *> --- Estructura basica ---
           IF MODULO-ACTUAL = 1
              DISPLAY "[E]" LINE 2 COL 5
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY "[" LINE 2 COL 5 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
              DISPLAY "E" LINE 2 COL 6 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "]" LINE 2 COL 7 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.

           *> --- OPCION FINANCIERO ---
           IF MODULO-ACTUAL = 2
              DISPLAY " Financiero " LINE 2 COL 10
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 10 BACKGROUND-COLOR 7
              DISPLAY "F" LINE 2 COL 11 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "inanciero" LINE 2 COL 12 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.

           *> --- OPCION COMERCIAL ---
           IF MODULO-ACTUAL = 3
              DISPLAY " Comercial "  LINE 2 COL 23
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 23 BACKGROUND-COLOR 7
              DISPLAY "C" LINE 2 COL 24 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "omercial" LINE 2 COL 25 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.

           *> --- OPCION MANUFACTURA ---
           IF MODULO-ACTUAL = 4
              DISPLAY " Manufactura " LINE 2 COL 35
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 35 BACKGROUND-COLOR 7
              DISPLAY "M" LINE 2 COL 36 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "anufactura" LINE 2 COL 37 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.

           IF MODULO-ACTUAL = 5
              DISPLAY " Admon " LINE 2 COL 40
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 47 BACKGROUND-COLOR 7
              DISPLAY "A" LINE 2 COL 48 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
              DISPLAY "d" LINE 2 COL 49 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "mon" LINE 2 COL 50 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.
