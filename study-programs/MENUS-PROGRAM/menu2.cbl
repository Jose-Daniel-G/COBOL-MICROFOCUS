
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIESA-MENU-NAV.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            COPY "./bin/clientes.sel".
       DATA DIVISION.
       FILE SECTION.
            COPY "./bin/clientes.fd".
       WORKING-STORAGE SECTION.
       01  WS-KEY            PIC 9(4).
       01  ST-FILE           PIC XX.
       01  MENSAJE    PIC X(70).
       01  OPCION-CAPTURA    PIC X VALUE SPACE.
       01  MODULO-ACTUAL     PIC 9 VALUE 2. *> 1:Finan, 2:Comer, 3:Manuf
       01  FECHA-SISTEMA     PIC X(17) VALUE "DECEMBER 24, 2025".
       01  OPCION-VENTANA    PIC X VALUE SPACE.
       *> VARIABLES PARA LA NAVEGACION
       01  WS-FILA-ACTUAL     PIC 9 VALUE 1. *> 1:Facturas, 2:Cobros, 3:Notas, 4:Salir
       01  WS-FIN-SUBMENU     PIC X VALUE "N".
       *> ---- PROGRAMA CLIENTES  ----
       01  DATOS.
           02 W-CLI-NOMBRE        PIC X(10).
           02 W-CLI-NOMBRE-ANT    PIC X(10).
           02 W-CLI-DIRECCION PIC X(80).
           02 W-CLI-CODPOST   PIC X(10).
           02 W-CLI-CATEGORIA PIC X.

       SCREEN SECTION.
       *> --- BARRA SUPERIOR DINAMICA ---
       01  BARRA-SUPERIOR.
           05 LINE 1 COL 1 VALUE " TEST 8.5  " BACKGROUND-COLOR 4
                                               FOREGROUND-COLOR 7.
           05 LINE 1 COL 65 FROM FECHA-SISTEMA BACKGROUND-COLOR 4
                                               FOREGROUND-COLOR 7.
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.   *> 2. LA BARRA DE MEN� HORIZONTAL (Gris con letras rojas)

       *> --- MENU VERTICAL DESPLEGABLE ---

       01  FINANCIERO.
           05 LINE 03 COL 10 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 04 COL 10 VALUE "| Financiero               |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 05 COL 10 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 06 COL 10 VALUE "| F. Facturas              |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 07 COL 10 VALUE "| C. Cobros                |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 08 COL 10 VALUE "| N. Notas Credito         |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 09 COL 10 VALUE "| S. Salir al Menu Sup.    |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 10 COL 10 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 12 COL 10 VALUE "ACCION: [ ]" BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 SC-OPC-V LINE 12 COL 29 PIC X TO OPCION-VENTANA.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".               *> Habilita teclas especiales
           DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1.     *> Borramos pantalla solo una vez al inicio
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-CAPTURA) = "S"
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
              
               ACCEPT OPCION-CAPTURA LINE 24 COL 10

               EVALUATE FUNCTION UPPER-CASE(OPCION-CAPTURA)
                   WHEN "E"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 1 TO MODULO-ACTUAL
                   WHEN "F"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 2 TO MODULO-ACTUAL
                       PERFORM DESPLEGAR-FINANCIERO
               END-EVALUATE
           END-PERFORM.
           STOP RUN.

       DIBUJAR-OPCIONES.
           IF MODULO-ACTUAL = 1         *> --- Estructura basica ---
              DISPLAY "[E]" LINE 2 COL 5
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY "[" LINE 2 COL 5 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
              DISPLAY "E" LINE 2 COL 6 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "]" LINE 2 COL 7 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.
           IF MODULO-ACTUAL = 2        *> --- OPCION FINANCIERO ---
              DISPLAY " Financiero " LINE 2 COL 10
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 10 BACKGROUND-COLOR 7
              DISPLAY "F" LINE 2 COL 11 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "inanciero" LINE 2 COL 12 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.

       LIMPIAR-AREA-MENU.
           DISPLAY " " LINE 3 COL 1 ERASE EOS BACKGROUND-COLOR 1. *> Limpia de la linea 3 hacia abajo
       DESPLEGAR-FINANCIERO.
           MOVE "N" TO WS-FIN-SUBMENU
           MOVE 1 TO WS-FILA-ACTUAL

           PERFORM UNTIL WS-FIN-SUBMENU = "S"

               DISPLAY BARRA-SUPERIOR  
               PERFORM DIBUJAR-OPCIONES
               DISPLAY FINANCIERO
             *> DIBUJAR LAS OPCIONES CON RESALTADO DINAMICO
               IF WS-FILA-ACTUAL = 1
                  DISPLAY "| F. Facturas              |" LINE 06 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| F. Facturas              |" LINE 06 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 2
                  DISPLAY "| C. Cobros                |" LINE 07 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| C. Cobros                |" LINE 07 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 3
                  DISPLAY "| N. Notas Credito         |" LINE 08 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| N. Notas Credito         |" LINE 08 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 4
                  DISPLAY "| S. Salir al Menu Sup.    |" LINE 09 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| S. Salir al Menu Sup.    |" LINE 09 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               *> ACCEPT "INVISIBLE" PARA CAPTURAR LA TECLA
               ACCEPT OPCION-VENTANA LINE 12 COL 19
               
               EVALUATE WS-KEY
                   WHEN 2003 *> FLECHA ARRIBA
                       IF WS-FILA-ACTUAL > 1 SUBTRACT 1 FROM WS-FILA-ACTUAL
                   WHEN 2004 *> FLECHA ABAJO
                       IF WS-FILA-ACTUAL < 4 ADD 1 TO WS-FILA-ACTUAL
                   WHEN 0    *> ENTER
                       EVALUATE WS-FILA-ACTUAL
                           WHEN 1 DISPLAY "ABRIENDO FACTURAS..." LINE 15 COL 10
                           WHEN 2 DISPLAY "ABRIENDO COBROS..."   LINE 15 COL 10
                           WHEN 3 DISPLAY "ABRIENDO NOTAS CREDITO..." LINE 15 COL 10
                           WHEN 4 
                               PERFORM LIMPIAR-AREA-MENU
                               MOVE "S" TO WS-FIN-SUBMENU
                       END-EVALUATE
               END-EVALUATE
               
               *> SALIDA POR TECLADO SI ESCRIBEN "S"
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  PERFORM LIMPIAR-AREA-MENU
                  MOVE "S" TO WS-FIN-SUBMENU
               END-IF
           END-PERFORM.

           