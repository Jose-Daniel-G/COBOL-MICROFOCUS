      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIESA-AUTO-DESPLIEGUE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  TECLA-MENU        PIC X VALUE SPACE.
       01  MODULO-ACTUAL     PIC 9 VALUE 0. *> 0:Ninguno, 1:Finan, 2:Comer
       01  OPCION-VENTANA    PIC X VALUE SPACE.
       SCREEN SECTION.
       *> --- BARRA SUPERIOR DINAMICA ---
       01  BARRA-SUPERIOR.
           05 LINE 1 COL 1 VALUE " SIESA 8.5  R.21.08.01" BACKGROUND-COLOR 4 FOREGROUND-COLOR 7.
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 2 COL 2 VALUE "[A] [E]" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

           *> Financiero
           05 LINE 2 COL 10 VALUE " Financiero "
           BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

           *> Comercial (Se resalta si MODULO-ACTUAL = 2)
           05 SC-COMERCIAL LINE 2 COL 23 VALUE " Comercial "
           BACKGROUND-COLOR 0 FOREGROUND-COLOR 7.
       *> --- MENU VERTICAL DESPLEGABLE (COMERCIAL) ---
       01  MENU-COMERCIAL.
           05 LINE 03 COL 20 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 04 COL 20 VALUE "| Comercial                |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 05 COL 20 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 06 COL 20 VALUE "| C. Confrontacion         |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 07 COL 20 VALUE "| V. Verificacion          |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 08 COL 20 VALUE "| A. Actualizacion         |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 09 COL 20 VALUE "| R. Retiro                |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 10 COL 20 VALUE "| S. Salir al Menu Sup.    |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 11 COL 20 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 13 COL 20 VALUE "ACCION: [ ]" BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 SC-OPC-V LINE 13 COL 29 PIC X TO OPCION-VENTANA.

           *> --- Estructuracion basica ---
       01  ESTRUCTURACION-BASICA.
           05 LINE 03 COL 05 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 04 COL 05 VALUE "| Estructuracion           |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 05 COL 05 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 06 COL 05 VALUE "| Empresas                 |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 07 COL 05 VALUE "| Centros de operacion     |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 08 COL 05 VALUE "| Proyectos y unidades     |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 09 COL 05 VALUE "| Tipos de Documentos      |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 10 COL 05 VALUE "| S. Salir al Menu Sup.    |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 11 COL 05 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 13 COL 05 VALUE "ACCION: [ ]" BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 SC-OPC-V LINE 13 COL 29 PIC X TO OPCION-VENTANA.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM UNTIL FUNCTION UPPER-CASE(TECLA-MENU) = "X"
               DISPLAY BARRA-SUPERIOR

               *> Fondo Azul Siesa
               DISPLAY " " LINE 3 COL 1 ERASE EOS BACKGROUND-COLOR 1
               PERFORM DIBUJAR-LOGO-FONDO

               DISPLAY "Presione C para Comercial o X para salir" LINE 24 COL 1
               ACCEPT TECLA-MENU LINE 24 COL 45 WITH NO-ECHO

               EVALUATE FUNCTION UPPER-CASE(TECLA-MENU)
                   WHEN "C"
                       MOVE 2 TO MODULO-ACTUAL
                       PERFORM DESPLEGAR-COMERCIAL
                   WHEN "E"
                       MOVE 1 TO MODULO-ACTUAL
                       PERFORM DESPLEGAR-ESTRUCTURACION
               END-EVALUATE
           END-PERFORM.
           STOP RUN.
       DESPLEGAR-COMERCIAL.
           MOVE SPACE TO OPCION-VENTANA.
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
               *> Redibujamos barra para mantener el resaltado negro
               DISPLAY BARRA-SUPERIOR
               DISPLAY MENU-COMERCIAL
               ACCEPT MENU-COMERCIAL

               EVALUATE FUNCTION UPPER-CASE(OPCION-VENTANA)
                   WHEN "C"
                       DISPLAY "ABRIENDO CONFRONTACION..." LINE 15 COL 20
                       ACCEPT OPCION-VENTANA
                   WHEN "S"
                       MOVE 0 TO MODULO-ACTUAL
                       EXIT PERFORM
               END-EVALUATE
           END-PERFORM.

       DESPLEGAR-ESTRUCTURACION.
           MOVE SPACE TO OPCION-VENTANA.
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
               *> Redibujamos barra para mantener el resaltado negro
               DISPLAY BARRA-SUPERIOR
               DISPLAY ESTRUCTURACION-BASICA
               ACCEPT ESTRUCTURACION-BASICA

               EVALUATE FUNCTION UPPER-CASE(OPCION-VENTANA)
                   WHEN "C"
                       DISPLAY "ABRIENDO CONFRONTACION..." LINE 15 COL 20
                       ACCEPT OPCION-VENTANA
                   WHEN "S"
                       MOVE 0 TO MODULO-ACTUAL
                       EXIT PERFORM
               END-EVALUATE
           END-PERFORM.

       DIBUJAR-LOGO-FONDO.
           DISPLAY " ######### " LINE 10 COL 10 FOREGROUND-COLOR 7.
           DISPLAY " ######### " LINE 11 COL 10 FOREGROUND-COLOR 7.
