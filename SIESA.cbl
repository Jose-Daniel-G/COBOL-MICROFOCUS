      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIESA.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01  DETALLES-SISTEMA.
           05  USUARIO-WS      PIC X(10) VALUE "JOSE_GRIJ".
           05  FECHA-WS        PIC X(10) VALUE "22/12/2025".
       01  OPCION-WS           PIC X.

       SCREEN SECTION.
       01  PANTALLA-MENU.
           05  BLANK SCREEN.
           *> Barra Superior
           05  LINE 1 COL 1 VALUE " SIESA ENTERPRISE 8.5 " REVERSE-VIDEO.
           05  LINE 1 COL 30 VALUE "MODULO: CLIENTES" REVERSE-VIDEO.
           05  LINE 1 COL 60 FROM FECHA-WS REVERSE-VIDEO.

           *> Logo ASCII simplificado para evitar errores de continuacion
           05  LINE 04 COL 25 VALUE " ____  ___  ____ ____      _    ".
           05  LINE 05 COL 25 VALUE "/ ___||_ _|| ___/ ___|    / \   ".
           05  LINE 06 COL 25 VALUE "\___ \ | | |  _|\___  \  / _ \  ".
           05  LINE 07 COL 25 VALUE " ___) || | | |___ ___) |/ /_\ \ ".
           05  LINE 08 COL 25 VALUE "|____/|___||____|____/_/_/   \_\".
           05  LINE 10 COL 30 VALUE "SISTEMA DE GESTION INTEGRAL".

           *> Cuadro de opciones
           05  LINE 13 COL 25 VALUE "1. MAESTRO DE CLIENTES".
           05  LINE 14 COL 25 VALUE "2. MOVIMIENTOS DIARIOS".
           05  LINE 15 COL 25 VALUE "3. INFORMES FISCALES".
           05  LINE 16 COL 25 VALUE "4. SALIR DEL SISTEMA".

           05  LINE 18 COL 25 VALUE "SELECCIONE OPCION: [ ]".
           05  SC-OPCION LINE 18 COL 45 PIC X TO OPCION-WS.

           *> Barra Inferior
           05  LINE 24 COL 1 VALUE " [F1] AYUDA   [F3] SALIR   [ESC] VOLVER"
                                   REVERSE-VIDEO.

       PROCEDURE DIVISION.
       MAIN-PROC.
           PERFORM UNTIL OPCION-WS = "4"
               DISPLAY PANTALLA-MENU
               ACCEPT PANTALLA-MENU

               EVALUATE OPCION-WS
                   WHEN "1"
                       DISPLAY "ENTRANDO A CLIENTES..." LINE 20 COL 25
                       *> Aquí llamarías a tu subprograma
                   WHEN "4"
                       EXIT PROGRAM
               END-EVALUATE
           END-PERFORM
           STOP RUN.
