
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MENU5.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY. 
       INPUT-OUTPUT SECTION. 
       DATA DIVISION. 
       WORKING-STORAGE SECTION.
       *>Aqui puedes poner tus cpy
       COPY "./CPY/TECLAS.cpy".
       01  WS-KEY            PIC 9(4). 
       01  WS-FIN-CONF       PIC X VALUE "N".
       01  WS-FILA-CONF      PIC 9 VALUE 1. *> 1:Listar, 2:Alta/Mod, 3:Salir

       01  OPCION-CAPTURA    PIC X VALUE SPACE.
       01  MODULO-ACTUAL     PIC 9 VALUE 2. *> 1:Finan, 2:Comer, 3:Manuf 
       01  OPCION-VENTANA    PIC X VALUE SPACE.
       *> VARIABLES PARA LA NAVEGACION
       01  WS-FILA-ACTUAL     PIC 9 VALUE 1. *> 1:Facturas, 2:Cobros, 3:Notas, 4:Salir
       01  WS-FIN-SUBMENU     PIC X VALUE "N".
       01  FECHA-SISTEMA     PIC X(17) VALUE "DECEMBER 24, 2025".
       
       01  WS-FECHA-TECNICA.
           05  WS-ANIO-T         PIC 9(4).
           05  WS-MES-T          PIC 9(2).
           05  WS-DIA-T          PIC 9(2).

       01  WS-FECHA-FORMATEADA.
           05  WS-DIA-F          PIC 9(2).
           05  FILLER            VALUE "/".
           05  WS-MES-F          PIC 9(2).
           05  FILLER            VALUE "/".
           05  WS-ANIO-F         PIC 9(4).

       SCREEN SECTION.
       *> --- BARRA SUPERIOR DINAMICA ---
       01  BARRA-SUPERIOR.
           05 LINE 1 COL 1 VALUE " TEST 8.5  " BACKGROUND-COLOR 4
                                               FOREGROUND-COLOR 7.
           05 LINE 1 COL 64 FROM FECHA-SISTEMA BACKGROUND-COLOR 4
                                               FOREGROUND-COLOR 7.
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.   *> 2. LA BARRA DE MENU HORIZONTAL (Gris con letras rojas)

       *> --- MENU VERTICAL DESPLEGABLE ---
       COPY "./CPY/MENUS.screen".

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           CALL "SYSTEM" USING "MODE CON: COLS=80 LINES=25".
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".               *> Habilita teclas especiales 
           SET ENVIRONMENT "COB_CURSOR_MODE" TO "0".
           DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1.     *> Borramos pantalla solo una vez al inicio
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-CAPTURA) = "S"
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
              
               ACCEPT OPCION-CAPTURA LINE 25 COL 80

               EVALUATE FUNCTION UPPER-CASE(OPCION-CAPTURA)
                   WHEN "A"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 1 TO MODULO-ACTUAL
                   WHEN "E"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 2 TO MODULO-ACTUAL
                   WHEN "F"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 3 TO MODULO-ACTUAL
                       PERFORM DESPLEGAR-FINANCIERO
                   WHEN "C"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 4 TO MODULO-ACTUAL
                   WHEN "N"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 5 TO MODULO-ACTUAL
                   WHEN "D"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 6 TO MODULO-ACTUAL
                   WHEN "O"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 7 TO MODULO-ACTUAL
                   WHEN "I"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 8 TO MODULO-ACTUAL
                   WHEN "M"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 9 TO MODULO-ACTUAL
               END-EVALUATE
           END-PERFORM.
           STOP RUN.

       DIBUJAR-OPCIONES.
           COPY "./CPY/DIBUJAR_LOGIC.cpy".

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
                  DISPLAY "| M. SUBMENU               |" LINE 06 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| M. SUBMENU               |" LINE 06 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF

               IF WS-FILA-ACTUAL = 2
                  DISPLAY "| P. Program               |" LINE 07 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| P. Program               |" LINE 07 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 3
                  DISPLAY "| C. Clientes              |" LINE 08 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| C. Clientes              |" LINE 08 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 4
                  DISPLAY "| L. LISTADO               |" LINE 09 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| L. LISTADO               |" LINE 09 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 5
                  DISPLAY "| S. Salir al Menu Sup.    |" LINE 10 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| S. Salir al Menu Sup.    |" LINE 10 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               *> ACCEPT "INVISIBLE" PARA CAPTURAR LA TECLA
               ACCEPT OPCION-VENTANA LINE 25 COL 80
               
               EVALUATE WS-KEY
                   WHEN KEY-UP       *> FLECHA ARRIBA
                       IF WS-FILA-ACTUAL > 1 SUBTRACT 1 FROM WS-FILA-ACTUAL
                   WHEN KEY-DOWN     *> FLECHA ABAJO
                       IF WS-FILA-ACTUAL < 5 ADD 1 TO WS-FILA-ACTUAL
                   WHEN KEY-ENTER    *> ENTER
                       EVALUATE WS-FILA-ACTUAL
                           WHEN 1   
                              PERFORM DESPLEGAR-SUBMENU
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR

                           WHEN 2  
                                 DISPLAY "CARGANDO ABM CLIENTES..." LINE 15 COL 10
                              CALL "CLIENTES-PROGRAM" 
                              ON EXCEPTION
                                 DISPLAY "ERROR: NO SE ENCONTRO CLIENTES-PROGRAM" LINE 15 COL 10
                              END-CALL
                              CANCEL "CLIENTES-PROGRAM"
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR
                              DISPLAY FINANCIERO
       
                           WHEN 3
                              DISPLAY "CARGANDO CLIENTES..." LINE 15 COL 10
                              CALL "CLIENTES" 
                              ON EXCEPTION
                                 DISPLAY "ERROR: NO SE ENCONTRO CLIENTES-PROGRAM" LINE 15 COL 10
                              END-CALL
                              CANCEL "CLIENTES"
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR
                              DISPLAY FINANCIERO
                           WHEN 4
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
                           WHEN 5 
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

       DESPLEGAR-SUBMENU.
           MOVE "N" TO WS-FIN-CONF
           MOVE 1 TO WS-FILA-CONF
           
           PERFORM UNTIL WS-FIN-CONF = "S"
               *> Redibujamos lo anterior para que no se pierda
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
               DISPLAY FINANCIERO
               
               *> Dibujamos la caja del menú de SUMBMENU
               DISPLAY MENU-SUBMENU
               
               *> --- LÓGICA DE RESALTADO DINÁMICO ---
               IF WS-FILA-CONF = 1
                  DISPLAY "| A.B.M CLIENTES              |" LINE 06 COL 33 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| A.B.M CLIENTES              |" LINE 06 COL 33 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               IF WS-FILA-CONF = 2
                  DISPLAY "| Listar                      |" LINE 08 COL 33 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Listar                      |" LINE 08 COL 33 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               
               IF WS-FILA-CONF = 3
                  DISPLAY "| Regresar                    |" LINE 09 COL 33 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Regresar                    |" LINE 09 COL 33 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               ACCEPT OPCION-VENTANA LINE 25 COL 80


               EVALUATE WS-KEY
                   WHEN KEY-UP *> FLECHA ARRIBA
                       IF WS-FILA-CONF > 1 
                          SUBTRACT 1 FROM WS-FILA-CONF
                       END-IF
                   WHEN KEY-DOWN *> FLECHA ABAJO
                       IF WS-FILA-CONF < 3 
                          ADD 1 TO WS-FILA-CONF
                       END-IF
                   WHEN KEY-ENTER    *> TECLA ENTER
                       EVALUATE WS-FILA-CONF
                           WHEN 1
                               CALL "CLIENTES" 
                               ON EXCEPTION
                                  DISPLAY "ERROR: NO SE ENCONTRO PROG" LINE 15 COL 45
                               END-CALL
                               PERFORM REFRESCAR-PANTALLA-TOTAL
                           WHEN 2 
                               CALL "LISTADO" 
                               ON EXCEPTION
                                  DISPLAY "ERROR: NO SE ENCONTRO PROG" LINE 15 COL 45
                               END-CALL
                               PERFORM REFRESCAR-PANTALLA-TOTAL
                           WHEN 3
                               MOVE "S" TO WS-FIN-CONF
                       END-EVALUATE
                   WHEN 2001 *> Tecla ESC (Si tu compilador lo soporta como 2001)
                       MOVE "S" TO WS-FIN-CONF
               END-EVALUATE

               *> Opción de salida por letra
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  MOVE "S" TO WS-FIN-CONF
               END-IF
           END-PERFORM.

           *> Al salir, limpiamos el área derecha (el cuadro verde)
           DISPLAY " " LINE 4 COL 45 ERASE EOS BACKGROUND-COLOR 1.
       REFRESCAR-PANTALLA-TOTAL.
           DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
           DISPLAY BARRA-SUPERIOR
           PERFORM DIBUJAR-OPCIONES
           DISPLAY FINANCIERO. 

           