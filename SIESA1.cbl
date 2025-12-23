      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIESA-85-MENU.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
         DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  OPCION-WS       PIC X.
       01  USUARIO-LOG     PIC X(15) VALUE "CLIENTE PRUEBAS".

       SCREEN SECTION.
       *> --- PANTALLA BASE (EL FONDO AZUL) ---
       01  FONDO-AZUL.
         05 BLANK SCREEN BACKGROUND-COLOR 1.

         *> Barra de Título Superior
         05 LINE 1 COL 1
            VALUE " SIESA 8.5  R.15.06.01     MANTENIMIENTO     ABRIL 25, 2019"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

         *> Barra Inferior
         05 LINE 24 COL 1
            VALUE " Version UN08 V14  |  Licenciado a : Cliente Pruebas Siesa"
            BACKGROUND-COLOR 0 FOREGROUND-COLOR 7.

       *> --- VENTANA DE MENU COMERCIAL (EL RECUADRO GRIS) ---
       01  VENTANA-MENU.
         05 LINE 04 COL 20 VALUE "+------------------------------------------+"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
         05 LINE 05 COL 20 VALUE "| Comercial                                |"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
         05 LINE 06 COL 20 VALUE "+------------------------------------------+"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.

         05 LINE 07 COL 20 VALUE "|                                          |"
            BACKGROUND-COLOR 7.

         *> Opcion C
         05 LINE 08 COL 20 VALUE "|  " BACKGROUND-COLOR 7.
         05 LINE 08 COL 23 VALUE "C" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
         05 LINE 08 COL 24 VALUE "onfrontacion de Archivos             |"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

         *> Opcion V
         05 LINE 09 COL 20 VALUE "|  " BACKGROUND-COLOR 7.
         05 LINE 09 COL 23 VALUE "V" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
         05 LINE 09 COL 24 VALUE "erificacion de Archivos              |"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

         *> Opcion A
         05 LINE 10 COL 20 VALUE "|  " BACKGROUND-COLOR 7.
         05 LINE 10 COL 23 VALUE "A" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
         05 LINE 10 COL 24 VALUE "ctualizacion Directa                 |"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

         *> Opcion R
         05 LINE 11 COL 20 VALUE "|  " BACKGROUND-COLOR 7.
         05 LINE 11 COL 23 VALUE "R" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
         05 LINE 11 COL 24 VALUE "etiro Directo                        |"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

         *> Opcion S
         05 LINE 12 COL 20 VALUE "|  " BACKGROUND-COLOR 7.
         05 LINE 12 COL 23 VALUE "S" BACKGROUND-COLOR 7 FOREGROUND-COLOR 4.
         05 LINE 12 COL 24 VALUE "alir del Sistema                     |"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

         05 LINE 13 COL 20 VALUE "|                                          |"
            BACKGROUND-COLOR 7.
         05 LINE 14 COL 20 VALUE "+------------------------------------------+"
            BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.

         *> Entrada de datos abajo del menu
         05 LINE 16 COL 25 VALUE "SELECCIONE ACCION: [ ]"
            BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
         05 SC-OPCION LINE 16 COL 45 PIC X TO OPCION-WS
            FOREGROUND-COLOR 6.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
         PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-WS) = "S"
            DISPLAY FONDO-AZUL
            DISPLAY VENTANA-MENU
            ACCEPT VENTANA-MENU

            EVALUATE FUNCTION UPPER-CASE(OPCION-WS)
                  WHEN "C"
                     PERFORM MOSTRAR-CONFRONTACION
                  WHEN "S"
                     EXIT PERFORM
            END-EVALUATE
         END-PERFORM.
         STOP RUN.

       MOSTRAR-CONFRONTACION.
         *> Aquí simulamos que se abre otra tarea
         DISPLAY " ABRIENDO MODULO DE CONFRONTACION... " LINE 20 COL 22
                  WITH REVERSE-VIDEO.
         ACCEPT OPCION-WS. *> Pausa
         MOVE SPACE TO OPCION-WS.
