      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIESA.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01  OPCION-WS       PIC X.
       01  FECHA-SIST      PIC X(10) VALUE "22/12/2025".
       01  USUARIO-WS      PIC X(10) VALUE "JOSE_GRIJ".

       SCREEN SECTION.
       01  MENU-PRINCIPAL.
           *> --- FONDO Y MARCO ---
           05 BLANK SCREEN.
           05 LINE 01 COL 01 VALUE " Siesa Enterprise 8.5" REVERSE-VIDEO.
           05 LINE 01 COL 60 VALUE "Fecha: " REVERSE-VIDEO.
           05 LINE 01 COL 67 FROM FECHA-SIST REVERSE-VIDEO.

           *> --- LOGO ASCII (Estilo Siesa) ---
           05 LINE 04 COL 25 VALUE "   _____  _____  ______   _____          ".
           05 LINE 05 COL 25 VALUE "  / ____||_   _||  ____| / ____|   /\    ".
           05 LINE 06 COL 25 VALUE " | (___    | |  | |__   | (___    /  \   ".
           05 LINE 07 COL 25 VALUE "  \___ \   | |  |  __|   \___ \  / /\ \  ".
           05 LINE 08 COL 25 VALUE "  ____) | _| |_ | |____  ____) |/ ____ \ ".
           05 LINE 09 COL 25 VALUE " |_____/ |_____||______||_____//_/    \_\".
           05 LINE 11 COL 32 VALUE "SISTEMA DE GESTION EMPRESARIAL".

           *> --- CUADRO DE OPCIONES ---
           05 LINE 14 COL 25 VALUE "1. Administracion de Clientes".
           05 LINE 15 COL 25 VALUE "2. Procesos de Facturacion".
           05 LINE 16 COL 25 VALUE "3. Consultas y Reportes".
           05 LINE 17 COL 25 VALUE "4. Salir del Sistema".

           *> --- CAMPO DE CAPTURA ---
           05 LINE 19 COL 25 VALUE "Seleccione Modulo: [ ]".
           05 INPUT-OPCION LINE 19 COL 45 PIC X TO OPCION-WS BLINK.

           *> --- BARRA INFERIOR ---
           05 LINE 24 COL 01 VALUE " [F1] Ayuda   [F3] Salir   [F10] Menu Anterior" REVERSE-VIDEO.
       END PROGRAM SIESA.
