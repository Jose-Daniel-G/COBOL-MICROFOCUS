
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
       COPY "COLORES.cpy".
       COPY "TECLAS.cpy".
       COPY "FECHA.cpy".
       01  WS-KEY            PIC 9(4). 
       01  WS-MENU           PIC X VALUE "N". 
       01  WS-SUBM           PIC X VALUE "N".
       01  WS-SUBN           PIC X VALUE "N".
       01  WS-FILA-CONF      PIC 9 VALUE 1.  
       01  OPCION-CAPTURA    PIC X VALUE SPACE.
       01  MODULO-ACTUAL     PIC 9 VALUE 2. *> MENU-HORIZONTAL 
       01  OPCION-VENTANA    PIC X VALUE SPACE.
       *> VARIABLES PARA LA NAVEGACION
       01  WS-FILA-ACTUAL     PIC 9 VALUE 1. *> SUB-MENU 

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
                       MOVE "S" TO WS-SUBM                       
               END-EVALUATE
           END-PERFORM.
           STOP RUN.

       DIBUJAR-OPCIONES.
           COPY "DIBUJAR_LOGIC.cpy".

       LIMPIAR-AREA-MENU.
           DISPLAY " " LINE 3 COL 1 ERASE EOS BACKGROUND-COLOR 1. *> Limpia de la linea 3 hacia abajo
       DESP-FINANCIERO.
           MOVE "N" TO WS-MENU      
           MOVE  1  TO WS-FILA-ACTUAL

           PERFORM UNTIL WS-MENU       = "S"

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
                              PERFORM FINAN-CLIENTE 
                           WHEN 2  
                              PERFORM FINAN-FACTURA 
                           WHEN 3
                              DISPLAY "Status: pending" LINE 15 COL 10 
                           WHEN 4
                              DISPLAY "Status: pending" LINE 15 COL 10 
                           WHEN 5 
                               PERFORM LIMPIAR-AREA-MENU
                               MOVE "S" TO WS-MENU      
                       END-EVALUATE                     
               END-EVALUATE
               
               *> SALIDA POR TECLADO SI ESCRIBEN "S"
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  PERFORM LIMPIAR-AREA-MENU
                  MOVE "S" TO WS-MENU      
               END-IF
           END-PERFORM.
       DESP-COMERCIAL.
           MOVE "N" TO WS-MENU      
           MOVE 1 TO WS-FILA-ACTUAL

           PERFORM UNTIL WS-MENU       = "S"

               DISPLAY BARRA-SUPERIOR  
               PERFORM DIBUJAR-OPCIONES
               DISPLAY COMERCIAL
             *> DIBUJAR LAS OPCIONES CON RESALTADO DINAMICO
               IF WS-FILA-ACTUAL = 1
                  DISPLAY "| I. Inventarios   |" LINE 06 COL 23 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| I. Inventarios   |" LINE 06 COL 23 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               END-IF

               IF WS-FILA-ACTUAL = 2
                  DISPLAY "| #. ??            |" LINE 07 COL 23 WITH REVERSE-VIDEO   *>C. Compras
               ELSE
                  DISPLAY "| #. ??            |" LINE 07 COL 23 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1   *>C. Compras
               END-IF 
       
               IF WS-FILA-ACTUAL = 3
                  DISPLAY "| Regresar         |" LINE 08 COL 23 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Regresar         |" LINE 08 COL 23 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
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
                              PERFORM COM-INVENTARIO
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
                               PERFORM LIMPIAR-AREA-MENU
                               MOVE "S" TO WS-MENU      
                       END-EVALUATE                  
               END-EVALUATE
               
               *> SALIDA POR TECLADO SI ESCRIBEN "S"
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  PERFORM LIMPIAR-AREA-MENU
                  MOVE "S" TO WS-MENU      
               END-IF
           END-PERFORM.
       FINAN-CLIENTE.
           MOVE "N" TO WS-SUBM
           MOVE 1 TO WS-FILA-CONF
           
           PERFORM UNTIL WS-SUBM = "S"
               
               DISPLAY BARRA-SUPERIOR                                   *> Redibujamos lo anterior para que no se pierda
               PERFORM DIBUJAR-OPCIONES
               DISPLAY FINANCIERO
               
               DISPLAY SUBMENU-CLI                                      *> Dibujamos la caja del menú de SUMBMENU
               
               *> --- LÓGICA DE RESALTADO DINÁMICO ---
               IF WS-FILA-CONF = 1
                  DISPLAY "| 1. Crear / Editar  |" LINE 08 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 1. Crear / Editar  |" LINE 08 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               IF WS-FILA-CONF = 2
                  DISPLAY "| 2. Listar          |" LINE 09 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 2. Listar          |" LINE 09 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               
               IF WS-FILA-CONF = 3
                  DISPLAY "| Regresar           |" LINE 10 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| Regresar           |" LINE 10 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
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
                               MOVE "S" TO WS-SUBM
                       END-EVALUATE
                   WHEN KEY-ESC  
                       MOVE "S" TO WS-SUBM
               END-EVALUATE

               *> Opción de salida por letra
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  MOVE "S" TO WS-SUBM
               END-IF
           END-PERFORM.

           *> Al salir, limpiamos el área derecha (el cuadro verde)
           DISPLAY " " LINE 4 COL 45 ERASE EOS BACKGROUND-COLOR 1.
       FINAN-FACTURA.
           MOVE "N" TO WS-SUBM
           MOVE 1 TO WS-FILA-CONF
           
           PERFORM UNTIL WS-SUBM = "S"
               *> Redibujamos lo anterior para que no se pierda
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
               DISPLAY FINANCIERO
               
               *> Dibujamos la caja del menú de SUMBMENU
               DISPLAY SUBMENU-FACT
               
               *> --- LÓGICA DE RESALTADO DINÁMICO ---
               IF WS-FILA-CONF = 1
                  DISPLAY "| 1. Nueva Factura     |" LINE 07 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 1. Nueva Factura     |" LINE 07 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               IF WS-FILA-CONF = 2
                  DISPLAY "| 2. Consultar Factura |" LINE 08 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 2. Consultar Factura |" LINE 08 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               
               IF WS-FILA-CONF = 3
                  DISPLAY "| 3. Anular Factura    |" LINE 09 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 3. Anular Factura    |" LINE 09 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               IF WS-FILA-CONF = 4
                  DISPLAY "|    Regresar          |" LINE 10 COL 35 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "|    Regresar          |" LINE 10 COL 35 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
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
                               MOVE "S" TO WS-SUBM
                       END-EVALUATE
                   WHEN KEY-ESC 
                       MOVE "S" TO WS-SUBM
               END-EVALUATE

               *> Opción de salida por letra
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  MOVE "S" TO WS-SUBM
               END-IF
           END-PERFORM.

           *> Al salir, limpiamos el área derecha (el cuadro verde)
           DISPLAY " " LINE 4 COL 45 ERASE EOS BACKGROUND-COLOR 1.
       COM-INVENTARIO.
           MOVE "N" TO WS-SUBM
           MOVE 1 TO WS-FILA-CONF
           
           PERFORM UNTIL WS-SUBM = "S"

               DISPLAY BARRA-SUPERIOR               *> Redibujamos lo anterior para que no se pierda
               PERFORM DIBUJAR-OPCIONES
               DISPLAY COMERCIAL

               DISPLAY SUBMENU-COM               *> Dibujamos la caja del menú de SUMBMENU
               
               *> --- LÓGICA DE RESALTADO DINÁMICO ---
               IF WS-FILA-CONF = 1
                  DISPLAY "| 1. Productos (ABM)   |" LINE 08 COL 40 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 1. Productos (ABM)   |" LINE 08 COL 40 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               IF WS-FILA-CONF = 2
                  DISPLAY "| 2. Entradas de Stock |" LINE 09 COL 40 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 2. Entradas de Stock |" LINE 09 COL 40 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               
               IF WS-FILA-CONF = 3
                  DISPLAY "| 3. Bodegas (ABM)     |" LINE 10 COL 40 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 3. Bodegas (ABM)     |" LINE 10 COL 40 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               IF WS-FILA-CONF = 4
                  DISPLAY "| 4. Consulta Stock    |" LINE 11 COL 40 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 4. Consulta Stock    |" LINE 11 COL 40 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               IF WS-FILA-CONF = 5
                  DISPLAY "| 5. kardex            |" LINE 12 COL 40 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "| 5. kardex            |" LINE 12 COL 40 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF
               IF WS-FILA-CONF = 6
                  DISPLAY "|    Regresar          |" LINE 13 COL 40 WITH REVERSE-VIDEO
               ELSE
                  DISPLAY "|    Regresar          |" LINE 13 COL 40 BACKGROUND-COLOR 6 FOREGROUND-COLOR 7
               END-IF

               *> ACCEPT "INVISIBLE" PARA CAPTURAR LA TECLA
               ACCEPT OPCION-VENTANA LINE 25 COL 80

               EVALUATE WS-KEY
                   WHEN KEY-UP *> FLECHA ARRIBA
                       IF WS-FILA-CONF > 1 
                          SUBTRACT 1 FROM WS-FILA-CONF
                       END-IF
                   WHEN KEY-DOWN *> FLECHA ABAJO
                       IF WS-FILA-CONF < 6 
                          ADD 1 TO WS-FILA-CONF
                       END-IF
                   WHEN KEY-ENTER    *> TECLA ENTER
                       EVALUATE WS-FILA-CONF
                           WHEN 1
                               PERFORM SUBCOM-PRODUCTOS
                               PERFORM REFRESCAR-PANTALLA-TOTAL 
                           WHEN 2
                               PERFORM SUBCOM-STOCK
                               PERFORM REFRESCAR-PANTALLA-TOTAL  
                           WHEN 3 
                               PERFORM SUBCOM-BODEGAS
                               PERFORM REFRESCAR-PANTALLA-TOTAL  
                           WHEN 4
                               MOVE "S" TO WS-SUBM
                           WHEN 5
                               MOVE "S" TO WS-SUBM
                           WHEN 6
                               MOVE "S" TO WS-SUBM
                       END-EVALUATE
                   WHEN KEY-ESC 
                       MOVE "S" TO WS-SUBM
               END-EVALUATE

               *> Opción de salida por letra
               IF FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
                  MOVE "S" TO WS-SUBM
               END-IF
           END-PERFORM.

           DISPLAY " " LINE 4 COL 45 ERASE EOS BACKGROUND-COLOR 1.       *> Al salir, limpiamos el área derecha (el cuadro verde)
       
       
       SUBCOM-PRODUCTOS.                                                 *> TERCER NIVEL PRODUCTOS COMERCIAL
           MOVE "N" TO WS-SUBN
           MOVE 1   TO WS-FILA-CONF
       
           PERFORM UNTIL WS-SUBN = "S"
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
               DISPLAY COMERCIAL       
               DISPLAY SUBMENU-COM       
               DISPLAY SUBCOM-PROD
       
               IF WS-FILA-CONF = 1
                   DISPLAY "| 1. Productos       |" LINE 08 COL 59 WITH REVERSE-VIDEO
               ELSE
                   DISPLAY "| 1. Productos       |" LINE 08 COL 59 BACKGROUND-COLOR GRN FOREGROUND-COLOR 7
               END-IF
       
               IF WS-FILA-CONF = 2
                   DISPLAY "| 2. Listado General |" LINE 09 COL 59 WITH REVERSE-VIDEO
               ELSE
                   DISPLAY "| 2. Listado General |" LINE 09 COL 59 BACKGROUND-COLOR GRN FOREGROUND-COLOR 7
               END-IF
       
               IF WS-FILA-CONF = 3
                   DISPLAY "|    Regresar        |" LINE 10 COL 59 WITH REVERSE-VIDEO
               ELSE
                   DISPLAY "|    Regresar        |" LINE 10 COL 59 BACKGROUND-COLOR GRN FOREGROUND-COLOR 7
               END-IF
       
               ACCEPT OPCION-VENTANA LINE 25 COL 80
               
               EVALUATE WS-KEY
                   WHEN KEY-UP
                       IF WS-FILA-CONF > 1
                           SUBTRACT 1 FROM WS-FILA-CONF
                       END-IF
               
                   WHEN KEY-DOWN
                       IF WS-FILA-CONF < 3
                           ADD 1 TO WS-FILA-CONF
                       END-IF
               
                   WHEN KEY-ENTER
                       EVALUATE WS-FILA-CONF
                           WHEN 1
                               CALL "INVPRO01"
                               CANCEL "INVPRO01"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
               
                           WHEN 2
                               CALL "INVLPRO01"
                               CANCEL "INVLPRO01"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
               
                           WHEN 3
                               MOVE 1   TO WS-FILA-CONF
                               MOVE "S" TO WS-SUBN
                       END-EVALUATE
               
                   WHEN KEY-ESC
                       MOVE "S" TO WS-SUBN
               END-EVALUATE
           END-PERFORM.
       SUBCOM-STOCK.                                                 *> TERCER NIVEL STOCK COMERCIAL
           MOVE "N" TO WS-SUBN
           MOVE 1   TO WS-FILA-CONF
       
           PERFORM UNTIL WS-SUBN = "S"
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
               DISPLAY COMERCIAL       
               DISPLAY SUBMENU-COM       
               DISPLAY SUBCOM-STK
       
               IF WS-FILA-CONF = 1
                   DISPLAY "| 1. Stock     |" LINE 09 COL 59 WITH REVERSE-VIDEO
               ELSE
                   DISPLAY "| 1. Stock     |" LINE 09 COL 59 BACKGROUND-COLOR GRN FOREGROUND-COLOR 7
               END-IF
       
               IF WS-FILA-CONF = 2
                   DISPLAY "| 2. Listado   |" LINE 10 COL 59 WITH REVERSE-VIDEO
               ELSE
                   DISPLAY "| 2. Listado   |" LINE 10 COL 59 BACKGROUND-COLOR GRN FOREGROUND-COLOR 7
               END-IF
       
               IF WS-FILA-CONF = 3
                   DISPLAY "|    Regresar  |" LINE 11 COL 59 WITH REVERSE-VIDEO
               ELSE
                   DISPLAY "|    Regresar  |" LINE 11 COL 59 BACKGROUND-COLOR GRN FOREGROUND-COLOR 7
               END-IF
       
               ACCEPT OPCION-VENTANA LINE 25 COL 80
               
               EVALUATE WS-KEY
                   WHEN KEY-UP
                       IF WS-FILA-CONF > 1
                           SUBTRACT 1 FROM WS-FILA-CONF
                       END-IF
               
                   WHEN KEY-DOWN
                       IF WS-FILA-CONF < 3
                           ADD 1 TO WS-FILA-CONF
                       END-IF
               
                   WHEN KEY-ENTER
                       EVALUATE WS-FILA-CONF
                           WHEN 1
                               CALL "INVSTK01"
                               CANCEL "INVSTK01"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
               
                           WHEN 2
                                  DISPLAY "ERROR: PENDIENTE" LINE 15 COL 45  *>                         CALL "INVLSTK01" >                         CANCEL "INVLSTK01" >                         PERFORM REFRESCAR-PANTALLA-TOTAL
               
                           WHEN 3
                               MOVE 2   TO WS-FILA-CONF
                               MOVE "S" TO WS-SUBN
                       END-EVALUATE
               
                   WHEN KEY-ESC
                       MOVE "S" TO WS-SUBN
               END-EVALUATE
           END-PERFORM.

       SUBCOM-BODEGAS.                                                 *> TERCER NIVEL PRODUCTOS COMERCIAL
           MOVE "N" TO WS-SUBN
           MOVE 1   TO WS-FILA-CONF
       
           PERFORM UNTIL WS-SUBN = "S"
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES
               DISPLAY COMERCIAL       
               DISPLAY SUBMENU-COM       
               DISPLAY SUBCOM-PROD
       
               IF WS-FILA-CONF = 1
                   DISPLAY "| 1. Bodegas (ABM)   |" LINE 08 COL 59 WITH REVERSE-VIDEO
               ELSE
                   DISPLAY "| 1. Bodegas (ABM)   |" LINE 08 COL 59 BACKGROUND-COLOR GRN FOREGROUND-COLOR 7
               END-IF
       
               IF WS-FILA-CONF = 2
                   DISPLAY "| 2. Listado General |" LINE 09 COL 59 WITH REVERSE-VIDEO
               ELSE
                   DISPLAY "| 2. Listado General |" LINE 09 COL 59 BACKGROUND-COLOR GRN FOREGROUND-COLOR 7
               END-IF
       
               IF WS-FILA-CONF = 3
                   DISPLAY "|    Regresar        |" LINE 10 COL 59 WITH REVERSE-VIDEO
               ELSE
                   DISPLAY "|    Regresar        |" LINE 10 COL 59 BACKGROUND-COLOR GRN FOREGROUND-COLOR 7
               END-IF
       
               ACCEPT OPCION-VENTANA LINE 25 COL 80
               
               EVALUATE WS-KEY
                   WHEN KEY-UP
                       IF WS-FILA-CONF > 1
                           SUBTRACT 1 FROM WS-FILA-CONF
                       END-IF
               
                   WHEN KEY-DOWN
                       IF WS-FILA-CONF < 3
                           ADD 1 TO WS-FILA-CONF
                       END-IF
               
                   WHEN KEY-ENTER
                       EVALUATE WS-FILA-CONF
                           WHEN 1
                               CALL "INVBOD01"
                               CANCEL "INVBOD01"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
               
                           WHEN 2
                               CALL "INVBOD02"
                               CANCEL "INVBOD02"
                               PERFORM REFRESCAR-PANTALLA-TOTAL
               
                           WHEN 3
                               MOVE 1   TO WS-FILA-CONF
                               MOVE "S" TO WS-SUBN
                       END-EVALUATE
               
                   WHEN KEY-ESC
                       MOVE "S" TO WS-SUBN
               END-EVALUATE
           END-PERFORM.

       
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
