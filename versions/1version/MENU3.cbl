
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MENU3.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY. 
       INPUT-OUTPUT SECTION. 
       DATA DIVISION. 
       WORKING-STORAGE SECTION.
       *>Aqui puedes poner tus cpy
       01  WS-KEY            PIC 9(4). 

       01  OPCION-CAPTURA    PIC X VALUE SPACE.
       01  MODULO-ACTUAL     PIC 9 VALUE 2. *> 1:Finan, 2:Comer, 3:Manuf
       01  FECHA-SISTEMA     PIC X(17) VALUE "DECEMBER 24, 2025".
       01  OPCION-VENTANA    PIC X VALUE SPACE.
       *> VARIABLES PARA LA NAVEGACION
       01  WS-FILA-ACTUAL     PIC 9 VALUE 1. *> 1:Facturas, 2:Cobros, 3:Notas, 4:Salir
       01  WS-FIN-SUBMENU     PIC X VALUE "N".
        

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
           05 LINE 06 COL 10 VALUE "| P. Program               |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 07 COL 10 VALUE "| C. Clientes              |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 08 COL 10 VALUE "| L. LISTADO               |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 09 COL 10 VALUE "| S. Salir al Menu Sup.    |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 10 COL 10 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.

       01  MENU-CONFRONTACION.
            05  GRUPO-VERDE BACKGROUND-COLOR 6 FOREGROUND-COLOR 7.*> Grupo con color Turquesa/Verde (Fondo 6 o 3 dependiendo del terminal)
            10 LINE 07 COL 33 VALUE "+-----------------------------+".
            10 LINE 08 COL 33 VALUE "| A.B.M CLIENTES              |".
            10 LINE 09 COL 33 VALUE "+-----------------------------+".
            10 LINE 10 COL 33 VALUE "| Listar                      |". 
            10 LINE 11 COL 33 VALUE "| Regresar                    |". 
            10 LINE 12 COL 33 VALUE "+-----------------------------+".  

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
                  DISPLAY "| P. Program               |" LINE 06 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| P. Program               |" LINE 06 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 2
                  DISPLAY "| C. Clientes              |" LINE 07 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| C. Clientes              |" LINE 07 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 3
                  DISPLAY "| L. LISTADO               |" LINE 08 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| L. LISTADO               |" LINE 08 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
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
                           WHEN 1  
                                 DISPLAY "CARGANDO ABM CLIENTES..." LINE 15 COL 10
                              CALL "CLIENTES-PROGRAM" 
                              ON EXCEPTION
                                 DISPLAY "ERROR: NO SE ENCONTRO CLIENTES-PROGRAM" LINE 15 COL 10
                              END-CALL
                              CANCEL "CLIENTES-PROGRAM"
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR
                              DISPLAY FINANCIERO
       
                           WHEN 2 
                              DISPLAY "CARGANDO CLIENTES..." LINE 15 COL 10
                              CALL "CLIENTES" 
                              ON EXCEPTION
                                 DISPLAY "ERROR: NO SE ENCONTRO CLIENTES-PROGRAM" LINE 15 COL 10
                              END-CALL
                              CANCEL "CLIENTES"
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR
                              DISPLAY FINANCIERO
                           WHEN 3 
                              DISPLAY "CARGANDO LISTADO DE CLIENTES..." LINE 15 COL 10
                              CALL "LISTADO" 
                              ON EXCEPTION
                                 DISPLAY "ERROR: NO SE ENCONTRO LIST" LINE 15 COL 10
                              END-CALL
                              CANCEL "LISTADO"
                              *> Al regresar, limpiamos y redibujamos el menú
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR
                              DISPLAY FINANCIERO
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

           