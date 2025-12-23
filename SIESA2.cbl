      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIESA-DESPLEGABLE.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  OPCION-WS       PIC X.
       01  OPCION-SUB      PIC X.
       SCREEN SECTION.
       *> --- PANTALLA BASE AZUL ---
       01  FONDO-AZUL.
           05 BLANK SCREEN BACKGROUND-COLOR 1.
           05 LINE 1 COL 1 VALUE " SIESA 8.5  R.15.06.01       MANTENIMIENTO       ENERO 08, 2025"
           BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 24 COL 1 VALUE " Version UN08 V14  |  Licenciado a : Inversiones Casduran SAS"
           BACKGROUND-COLOR 0 FOREGROUND-COLOR 7.
       *> --- MENU PRINCIPAL (GRIS) ---
       01  VENTANA-GRIS.
           05 LINE 04 COL 15 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 05 COL 15 VALUE "| COMERCIAL                |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 06 COL 15 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 07 COL 15 VALUE "| C. Confrontacion         |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 08 COL 15 VALUE "| V. Verificacion          |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 09 COL 15 VALUE "| S. Salir                 |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 10 COL 15 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
       *> --- MENU DESPLEGABLE (VERDE) ---
       01  VENTANA-VERDE.
           *> Borde superior y titulo
           05 LINE 05 COL 45 VALUE "+---------------------------------------+" BACKGROUND-COLOR 2 FOREGROUND-COLOR 7.
           05 LINE 06 COL 45 VALUE "|       CONFRONTACION DE ARCHIVOS       |" BACKGROUND-COLOR 2 FOREGROUND-COLOR 7.
           05 LINE 07 COL 45 VALUE "+---------------------------------------+" BACKGROUND-COLOR 2 FOREGROUND-COLOR 7.

           *> Opciones del sub-menu verde
           05 LINE 08 COL 45 VALUE "| 1. Confrontacion CMMAE vs CMMOVIN     |" BACKGROUND-COLOR 2 FOREGROUND-COLOR 7.
           05 LINE 09 COL 45 VALUE "| 2. Confrontacion CMM E vs ARCHIVOS    |" BACKGROUND-COLOR 2 FOREGROUND-COLOR 7.
           05 LINE 10 COL 45 VALUE "| 3. Confrontacion CM STAD vs CMMOVIN   |" BACKGROUND-COLOR 2 FOREGROUND-COLOR 7.
           05 LINE 11 COL 45 VALUE "| 4. Confrontacion CM OCIN vs CMMOVIN   |" BACKGROUND-COLOR 2 FOREGROUND-COLOR 7.
           05 LINE 12 COL 45 VALUE "| 5. Volver al menu anterior            |" BACKGROUND-COLOR 2 FOREGROUND-COLOR 7.

           05 LINE 13 COL 45 VALUE "+---------------------------------------+" BACKGROUND-COLOR 2 FOREGROUND-COLOR 7.

           *> Captura de opcion en la ventana verde
           05 LINE 15 COL 45 VALUE "Seleccione: [ ]" BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 SC-SUBOPCION LINE 15 COL 58 PIC X TO OPCION-SUB FOREGROUND-COLOR 6.
       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-WS) = "S"
               DISPLAY FONDO-AZUL
               DISPLAY VENTANA-GRIS

               DISPLAY "ACCION: [ ]" LINE 12 COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7
               ACCEPT OPCION-WS LINE 12 COL 24

               EVALUATE FUNCTION UPPER-CASE(OPCION-WS)
                   WHEN "C"
                       PERFORM DESPLEGAR-CONFRONTACION
                   WHEN "S"
                       EXIT PERFORM
               END-EVALUATE
           END-PERFORM.
           STOP RUN.

       DESPLEGAR-CONFRONTACION.
           SET OPCION-SUB TO SPACE.
           PERFORM UNTIL OPCION-SUB = "5"
               DISPLAY VENTANA-VERDE
               ACCEPT VENTANA-VERDE

               EVALUATE OPCION-SUB
                   WHEN "1"
                       DISPLAY "EJECUTANDO CMMAE..." LINE 20 COL 45 BEEP
                   WHEN "5"
                       EXIT PERFORM
               END-EVALUATE
           END-PERFORM.
