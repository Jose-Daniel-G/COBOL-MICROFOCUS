      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIESA-MENU-SUPERIOR.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  OPCION-MENU-SUP    PIC X.
       01  FECHA-SISTEMA      PIC X(15) VALUE "ENERO 08, 2025".
       SCREEN SECTION.
       01  PANTALLA-PRINCIPAL.
           05 BLANK SCREEN BACKGROUND-COLOR 1.

           *> 1. BARRA DE TITULO AZUL OSCURO
           05 LINE 1 COL 1 VALUE " SIESA 8.5  R.21.08.01"
           BACKGROUND-COLOR 4 FOREGROUND-COLOR 7.
           05 LINE 1 COL 65 FROM FECHA-SISTEMA
           BACKGROUND-COLOR 4 FOREGROUND-COLOR 7.
           *> 2. LA BARRA DE MENÚ HORIZONTAL (Gris con letras rojas)
           05 LINE 2 COL 1 PIC X(80) FROM ALL " "
           BACKGROUND-COLOR 7.

           *> Opción [A]
           05 LINE 2 COL 2 VALUE "[" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05           VALUE "A" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
           05           VALUE "]" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

           *> Opción [E]
           05 LINE 2 COL 6 VALUE "[" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05           VALUE "E" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
           05           VALUE "]" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           *> Modulo Financiero
           05 LINE 2 COL 11 VALUE " " BACKGROUND-COLOR 7.
           05            VALUE "F" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
           05            VALUE "inanciero" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           *> Modulo Comercial (Seleccionado en Negro en la imagen)
           05 LINE 2 COL 23 VALUE " Comercial "
           BACKGROUND-COLOR 0 FOREGROUND-COLOR 7.
           *> Modulo Manufactura
           05 LINE 2 COL 35 VALUE " " BACKGROUND-COLOR 7.
           05            VALUE "M" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
           05            VALUE "anufactura" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           *> Modulo Admon
           05 LINE 2 COL 48 VALUE " " BACKGROUND-COLOR 7.
           05            VALUE "Ad" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05            VALUE "m"  BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
           05            VALUE "on" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           *> Modulo Otros
           05 LINE 2 COL 57 VALUE " " BACKGROUND-COLOR 7.
           05            VALUE "O" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
           05            VALUE "tros" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           *> Info Gcial
           05 LINE 2 COL 65 VALUE " " BACKGROUND-COLOR 7.
           05            VALUE "I" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
           05            VALUE "nfo_Gcial" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           *> Opción [M]
           05 LINE 2 COL 77 VALUE "[" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05           VALUE "M" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
           05           VALUE "]" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           *> 3. CONTENIDO DEL FONDO (Logo Siesa hecho con #)
           05 LINE 05 COL 10 VALUE " ################           #" FOREGROUND-COLOR 7.
           05 LINE 06 COL 10 VALUE " ################         ###" FOREGROUND-COLOR 7.
           05 LINE 07 COL 10 VALUE " #########              #####" FOREGROUND-COLOR 7.
           05 LINE 08 COL 10 VALUE " #########            #######" FOREGROUND-COLOR 7.
           05 LINE 09 COL 10 VALUE " #######            #########" FOREGROUND-COLOR 7.

           *> 4. AREA DE CAPTURA INFERIOR
           05 LINE 24 COL 1 VALUE " Seleccione Modulo o use Atajos [ ]"
           BACKGROUND-COLOR 4 FOREGROUND-COLOR 7.
           05 SC-INPUT LINE 24 COL 34 PIC X TO OPCION-MENU-SUP.
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-MENU-SUP) = "S"
               DISPLAY PANTALLA-PRINCIPAL
               ACCEPT PANTALLA-PRINCIPAL

               EVALUATE FUNCTION UPPER-CASE(OPCION-MENU-SUP)
                   WHEN "F"
                       DISPLAY "CARGANDO FINANCIERO..." LINE 15 COL 30
                   WHEN "C"
                       DISPLAY "MODULO COMERCIAL ACTIVO" LINE 15 COL 30
                   WHEN "S"
                       STOP RUN
               END-EVALUATE
           END-PERFORM.
           STOP RUN.
