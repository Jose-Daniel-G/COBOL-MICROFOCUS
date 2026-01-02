
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MENU85.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY. 
       INPUT-OUTPUT SECTION. 
       DATA DIVISION. 
       WORKING-STORAGE SECTION.
       *>Aqui puedes poner tus cpy
       COPY "TECLAS.cpy".
       COPY "FECHA.cpy".
       01  WS-KEY            PIC 9(4). 
       01  WS-FIN-CONF       PIC X VALUE "N".
       01  WS-FILA-CONF      PIC 9 VALUE 1. *> 1:Listar, 2:Alta/Mod, 3:Salir

       01  OPCION-CAPTURA    PIC X VALUE SPACE.
       01  MODULO-ACTUAL     PIC 9 VALUE 2. *> MENU-HORIZONTAL 
       01  OPCION-VENTANA    PIC X VALUE SPACE.
       *> VARIABLES PARA LA NAVEGACION
       01  WS-FILA-ACTUAL     PIC 9 VALUE 1. *> SUB-MENU 
       01  WS-FIN-SUBMENU-CLI     PIC X VALUE "N". 

       SCREEN SECTION.
       *> --- BARRA SUPERIOR DINAMICA ---
       01  BARRA-SUPERIOR.
           05 LINE 1 COL 1 VALUE " TEST 8.5  " BACKGROUND-COLOR 4
                                               FOREGROUND-COLOR 7.
           05 LINE 1 COL 63 FROM WS-FECHA-TEXT BACKGROUND-COLOR 4
                                               FOREGROUND-COLOR 7.
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.   *> 2. LA BARRA DE MENU HORIZONTAL (Gris con letras rojas)

       *> --- MENU VERTICAL DESPLEGABLE ---
       COPY "MENUS.screen".

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           CALL "SYSTEM" USING "MODE CON: COLS=80 LINES=25".
           PERFORM FECHA-SISTEMA-TEXT.  
           DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1.     *> Borramos pantalla solo una vez al inicio
           
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-CAPTURA) = "S"
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
              
               ACCEPT OPCION-CAPTURA LINE 25 COL 80

               EVALUATE FUNCTION UPPER-CASE(OPCION-CAPTURA)
                   WHEN "F"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 3 TO MODULO-ACTUAL
                       PERFORM DESP-FINANCIERO
                   WHEN "C"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 4 TO MODULO-ACTUAL
                       PERFORM DESP-COMERCIAL
                   WHEN KEY-ESC 
                       MOVE "S" TO WS-FIN-CONF                       
               END-EVALUATE
           END-PERFORM.
           STOP RUN.

       DIBUJAR-OPCIONES.
           COPY "DIBUJAR_LOGIC.cpy".

       LIMPIAR-AREA-MENU.
           DISPLAY " " LINE 3 COL 1 ERASE EOS BACKGROUND-COLOR 1. *> Limpia de la linea 3 hacia abajo
       DESP-FINANCIERO.
           MOVE "N" TO WS-FIN-SUBMENU-CLI
           MOVE 1 TO WS-FILA-ACTUAL

           PERFORM UNTIL WS-FIN-SUBMENU-CLI = "S"

               DISPLAY BARRA-SUPERIOR  
               PERFORM DIBUJAR-OPCIONES
               DISPLAY FINANCIERO
             *> DIBUJAR LAS OPCIONES CON RESALTADO DINAMICO
               IF WS-FILA-ACTUAL = 1
                  DISPLAY "| C. Clientes              |" LINE 06 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| C. Clientes              |" LINE 06 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF

               IF WS-FILA-ACTUAL = 2
                  DISPLAY "| V. Ventas - Facturacion  |" LINE 07 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| V. Ventas - Facturacion  |" LINE 07 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 3
                  DISPLAY "| #. ........              |" LINE 08 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| #. ........              |" LINE 08 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 4
                  DISPLAY "| #. ........              |" LINE 09 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| #. ........              |" LINE 09 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               IF WS-FILA-ACTUAL = 5
                  DISPLAY "| Regresar                 |" LINE 10 COL 10 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Regresar                 |" LINE 10 COL 10 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
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
                              PERFORM SUB-FINAN-CLI
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR

                           WHEN 2  
                              PERFORM SUB-FINAN-FACT
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR      
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
                               MOVE "S" TO WS-FIN-SUBMENU-CLI
                       END-EVALUATE                     
               END-EVALUATE
               
               *> SALIDA POR TECLADO SI ESCRIBEN "S"
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  PERFORM LIMPIAR-AREA-MENU
                  MOVE "S" TO WS-FIN-SUBMENU-CLI
               END-IF
           END-PERFORM.
       DESP-COMERCIAL.
           MOVE "N" TO WS-FIN-SUBMENU-CLI
           MOVE 1 TO WS-FILA-ACTUAL

           PERFORM UNTIL WS-FIN-SUBMENU-CLI = "S"

               DISPLAY BARRA-SUPERIOR  
               PERFORM DIBUJAR-OPCIONES
               DISPLAY COMERCIAL
             *> DIBUJAR LAS OPCIONES CON RESALTADO DINAMICO
               IF WS-FILA-ACTUAL = 1
 
                  DISPLAY "| #. ??                    |" LINE 06 COL 23 WITH REVERSE-VIDEO   *>V. Ventas
               ELSE
                  DISPLAY "| #. ??                    |" LINE 06 COL 23 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1   *>V. Ventas
               END-IF

               IF WS-FILA-ACTUAL = 2
                  DISPLAY "| #. ??                    |" LINE 07 COL 23 WITH REVERSE-VIDEO   *>C. Compras
               ELSE
                  DISPLAY "| #. ??                    |" LINE 07 COL 23 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1   *>C. Compras
               END-IF
       
               IF WS-FILA-ACTUAL = 3
                  DISPLAY "| I. Inventarios           |" LINE 08 COL 23 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| I. Inventarios           |" LINE 08 COL 23 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
               IF WS-FILA-ACTUAL = 4
                  DISPLAY "| #. ??                    |" LINE 09 COL 23 WITH REVERSE-VIDEO *> A. Actualizacion
               ELSE
                  DISPLAY "| #. ??                    |" LINE 09 COL 23 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1 *> A. Actualizacion
               END-IF
       
               IF WS-FILA-ACTUAL = 5
                  DISPLAY "| #. ??                    |" LINE 10 COL 23 WITH REVERSE-VIDEO *> R. Retiro
               ELSE
                  DISPLAY "| #. ??                    |" LINE 10 COL 23 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1 *> R. Retiro
               END-IF
       
               IF WS-FILA-ACTUAL = 6
                  DISPLAY "| Regresar                 |" LINE 11 COL 23 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Regresar                 |" LINE 11 COL 23 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF
       
               *> ACCEPT "INVISIBLE" PARA CAPTURAR LA TECLA
               ACCEPT OPCION-VENTANA LINE 25 COL 80
               
               EVALUATE WS-KEY
                   WHEN KEY-UP       *> FLECHA ARRIBA
                       IF WS-FILA-ACTUAL > 1 SUBTRACT 1 FROM WS-FILA-ACTUAL
                   WHEN KEY-DOWN     *> FLECHA ABAJO
                       IF WS-FILA-ACTUAL < 6 ADD 1 TO WS-FILA-ACTUAL
                   WHEN KEY-ENTER    *> ENTER
                       EVALUATE WS-FILA-ACTUAL
                           WHEN 1   
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR

                           WHEN 2
                              DISPLAY "CARGANDO COMERCIAL..." LINE 15 COL 10
                              CALL "COMERCIAL" 
                              ON EXCEPTION
                                 DISPLAY "ERROR: NO SE ENCONTRO COMERCIAL" LINE 15 COL 10
                              END-CALL
                              CANCEL "COMERCIAL"
                           WHEN 3  
                              PERFORM SUB-COM-INV
                              DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1
                              DISPLAY BARRA-SUPERIOR
                           WHEN 4
                              DISPLAY "CARGANDO LISTADO DE COMERCIAL..." LINE 15 COL 10 
                           WHEN 5 
                              DISPLAY "CARGANDO LISTADO DE COMERCIAL..." LINE 15 COL 10 
                           WHEN 6 
                               PERFORM LIMPIAR-AREA-MENU
                               MOVE "S" TO WS-FIN-SUBMENU-CLI
                       END-EVALUATE                  
               END-EVALUATE
               
               *> SALIDA POR TECLADO SI ESCRIBEN "S"
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  PERFORM LIMPIAR-AREA-MENU
                  MOVE "S" TO WS-FIN-SUBMENU-CLI
               END-IF
           END-PERFORM.
       SUB-FINAN-CLI.
           MOVE "N" TO WS-FIN-CONF
           MOVE 1 TO WS-FILA-CONF
           
           PERFORM UNTIL WS-FIN-CONF = "S"
               
               DISPLAY BARRA-SUPERIOR                                   *> Redibujamos lo anterior para que no se pierda
               PERFORM DIBUJAR-OPCIONES
               DISPLAY FINANCIERO
               
               DISPLAY SUBMENU-CLI                                      *> Dibujamos la caja del menú de SUMBMENU
               
               *> --- LÓGICA DE RESALTADO DINÁMICO ---
               IF WS-FILA-CONF = 1
                  DISPLAY "| A.B.M CLIENTES              |" LINE 06 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| A.B.M CLIENTES              |" LINE 06 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               IF WS-FILA-CONF = 2
                  DISPLAY "| Listar                      |" LINE 08 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Listar                      |" LINE 08 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               
               IF WS-FILA-CONF = 3
                  DISPLAY "| Regresar                    |" LINE 09 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Regresar                    |" LINE 09 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
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
                               CANCEL "CLIENTES"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
                               DISPLAY FINANCIERO 

                           WHEN 2 
                               CALL "LISTADO" 
                               ON EXCEPTION
                                  DISPLAY "ERROR: NO SE ENCONTRO PROG" LINE 15 COL 45
                               END-CALL
                               CANCEL "LISTADO" 
                               PERFORM REFRESCAR-PANTALLA-TOTAL
                               DISPLAY FINANCIERO 
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
       SUB-FINAN-FACT.
           MOVE "N" TO WS-FIN-CONF
           MOVE 1 TO WS-FILA-CONF
           
           PERFORM UNTIL WS-FIN-CONF = "S"
               *> Redibujamos lo anterior para que no se pierda
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
               DISPLAY FINANCIERO
               
               *> Dibujamos la caja del menú de SUMBMENU
               DISPLAY SUBMENU-FACT
               
               *> --- LÓGICA DE RESALTADO DINÁMICO ---
               IF WS-FILA-CONF = 1
                  DISPLAY "| 1. NUEVA FACTURA            |" LINE 07 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 1. NUEVA FACTURA            |" LINE 07 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               IF WS-FILA-CONF = 2
                  DISPLAY "| 2. CONSULTAR FACTURA        |" LINE 08 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 2. CONSULTAR FACTURA        |" LINE 08 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               
               IF WS-FILA-CONF = 3
                  DISPLAY "| 3. ANULAR FACTURA           |" LINE 09 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 3. ANULAR FACTURA           |" LINE 09 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               IF WS-FILA-CONF = 4
                  DISPLAY "| Regresar                    |" LINE 10 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Regresar                    |" LINE 10 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               *> ACCEPT "INVISIBLE" PARA CAPTURAR LA TECLA
               ACCEPT OPCION-VENTANA LINE 25 COL 80

               EVALUATE WS-KEY
                   WHEN KEY-UP *> FLECHA ARRIBA
                       IF WS-FILA-CONF > 1 
                          SUBTRACT 1 FROM WS-FILA-CONF
                       END-IF
                   WHEN KEY-DOWN *> FLECHA ABAJO
                       IF WS-FILA-CONF < 4 
                          ADD 1 TO WS-FILA-CONF
                       END-IF
                   WHEN KEY-ENTER    *> TECLA ENTER
                       EVALUATE WS-FILA-CONF
                           WHEN 1
                               CALL "VENFAC01" 
                               ON EXCEPTION
                                  DISPLAY "ERROR: NO SE ENCONTRO PROG" LINE 15 COL 45
                               END-CALL
                               CANCEL "VENFAC01"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
                           WHEN 2 
                               CALL "LISTADO" 
                               ON EXCEPTION
                                  DISPLAY "ERROR: NO SE ENCONTRO PROG" LINE 15 COL 45
                               END-CALL
                               CANCEL "LISTADO"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
                           WHEN 4
                               MOVE "S" TO WS-FIN-CONF
                       END-EVALUATE
                   WHEN KEY-ESC 
                       MOVE "S" TO WS-FIN-CONF
               END-EVALUATE

               *> Opción de salida por letra
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  MOVE "S" TO WS-FIN-CONF
               END-IF
           END-PERFORM.

           *> Al salir, limpiamos el área derecha (el cuadro verde)
           DISPLAY " " LINE 4 COL 45 ERASE EOS BACKGROUND-COLOR 1.
       SUB-COM-INV.
           MOVE "N" TO WS-FIN-CONF
           MOVE 1 TO WS-FILA-CONF
           
           PERFORM UNTIL WS-FIN-CONF = "S"
               *> Redibujamos lo anterior para que no se pierda
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
               DISPLAY COMERCIAL
               
               *> Dibujamos la caja del menú de SUMBMENU
               DISPLAY SUBMENU-COM
               
               *> --- LÓGICA DE RESALTADO DINÁMICO ---
               IF WS-FILA-CONF = 1
                  DISPLAY "| 1. Productos (ABM)          |" LINE 08 COL 49 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 1. Productos (ABM)          |" LINE 08 COL 49 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               IF WS-FILA-CONF = 2
                  DISPLAY "| 2. Stock                    |" LINE 10 COL 49 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 2. Stock                    |" LINE 10 COL 49 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               
               IF WS-FILA-CONF = 3
                  DISPLAY "| 3. Consulta General         |" LINE 11 COL 49 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 3. Consulta General         |" LINE 11 COL 49 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               IF WS-FILA-CONF = 4
                  DISPLAY "| Regresar                    |" LINE 12 COL 49 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Regresar                    |" LINE 12 COL 49 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               *> ACCEPT "INVISIBLE" PARA CAPTURAR LA TECLA
               ACCEPT OPCION-VENTANA LINE 25 COL 80

               EVALUATE WS-KEY
                   WHEN KEY-UP *> FLECHA ARRIBA
                       IF WS-FILA-CONF > 1 
                          SUBTRACT 1 FROM WS-FILA-CONF
                       END-IF
                   WHEN KEY-DOWN *> FLECHA ABAJO
                       IF WS-FILA-CONF < 4 
                          ADD 1 TO WS-FILA-CONF
                       END-IF
                   WHEN KEY-ENTER    *> TECLA ENTER
                       EVALUATE WS-FILA-CONF
                           WHEN 1
                               CALL "INVPRO01" 
                               ON EXCEPTION
                                  DISPLAY "ERROR: NO SE ENCONTRO PROG" LINE 15 COL 45
                               END-CALL
                               CANCEL "INVPRO01"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
                           WHEN 2 
                               CALL "VENFAC01" 
                               ON EXCEPTION
                                  DISPLAY "ERROR: NO SE ENCONTRO PROG" LINE 15 COL 45
                               END-CALL
                               CANCEL "VENFAC01"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
                           WHEN 3 
                               CALL "LISTADO" 
                               ON EXCEPTION
                                  DISPLAY "ERROR: NO SE ENCONTRO PROG" LINE 15 COL 45
                               END-CALL
                               CANCEL "LISTADO"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
                           WHEN 4
                               MOVE "S" TO WS-FIN-CONF
                       END-EVALUATE
                   WHEN KEY-ESC 
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
           PERFORM DIBUJAR-OPCIONES.

       FECHA-SISTEM.
           ACCEPT WS-FECHA-TECNICA FROM DATE YYYYMMDD.           *> Captura la fecha en formato AAAAMMDD
           
           MOVE WS-DIA-T TO WS-DIA-F.                            *> Mueve los datos individuales al formato DD/MM/AAAA
           MOVE WS-MES-T TO WS-MES-F.
           MOVE WS-ANIO-T TO WS-ANIO-F.

       FECHA-SISTEMA-TEXT.
           ACCEPT WS-FECHA-TECNICA FROM DATE YYYYMMDD.
           MOVE WS-DIA-T  TO WS-DIA-TXT.
           MOVE NOMBRE-MES(WS-MES-T) TO WS-MES-TXT.
           MOVE WS-ANIO-T TO WS-ANIO-TXT.
