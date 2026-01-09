       >>SOURCE FORMAT FREE
      *> ******************************************************************
      *> * Author:   JOSE DANIEL GRIJALBA
      *> * Date:     12/23/2025
      *> * Purpose:  LEARN
      *> * Tectonics: cobc
      *> ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVSTK01.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "stock.sel".
           COPY "producto.sel".


       DATA DIVISION.
       FILE SECTION.
           COPY "stock.fd".
           COPY "producto.fd".


       WORKING-STORAGE SECTION.
       *> Estados de Archivo y Control
           COPY "TECLAS.cpy".
       01 WS-UI-CONTROLES.
          05 WS-TITULO-PANTALLA    PIC X(40) VALUE SPACES.
          05 WS-MODULO-PANTALLA    PIC X(26) VALUE SPACES.
          05 WS-PROGRAMA           PIC X(10) VALUE SPACES.

       01  ST-STOCK        PIC XX.
       01  ST-PRODUCTOS    PIC XX.
       01  MENSAJE        PIC X(70).
       01  WS-PAUSA       PIC X.
       01  RESPUESTA      PIC X     VALUE "S".
       01  FIN            PIC X     VALUE "N".
       01  EXISTE         PIC X.
       01  WS-KEY         PIC 9(4).
       
       *> Variables de Trabajo para el ID
       01  W-CODIGO      PIC X(10).     *> FK Producto
       01  W-CODIGO-Z      PIC X(10).     

       *> Variables para capturar datos en pantallaV
       01  DATOS-TRABAJO. 
           05 W-CANTIDAD    PIC ZZZZZZZZ9.
           05 W-MINIMO      PIC ZZZZZZZZZ9.
           05 W-MAXIMO      PIC ZZZZZZZZZ9.
           05 W-IVA         PIC 9(07)V99.
           05 W-IVA-DISP    PIC Z9.

       SCREEN SECTION.
       01 PANTALLA-BASE.
           COPY "HEADER.cpy". 
           05 LINE 2 COL 70 VALUE " JD-TWINS "
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 4 COL 02  VALUE "  +-------------------------[ PARAMETROS ]-----------------------+"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 5 COL 04  VALUE "| Codigo       :" BACKGROUND-COLOR 1.
           05 LINE 5 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 6 COL 04  VALUE "| 01. Cantidad :" BACKGROUND-COLOR 1.
           05 LINE 6 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 7 COL 04  VALUE "| 02. Minimo   :" BACKGROUND-COLOR 1.
           05 LINE 7 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 8 COL 04  VALUE "| 03 Maximo    :" BACKGROUND-COLOR 1. 
           05 LINE 8 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 09 COL 04 VALUE "| 04 Iva    :" BACKGROUND-COLOR 1. 
           05 LINE 09 COL 67 VALUE "| " BACKGROUND-COLOR 1.
           05 LINE 10 COL 02 VALUE "  +--------------------------------------------------------------+"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           *> Barra inferior
           05 LINE 25 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.      *>     05 LINE 25 COL 53 VALUE "F10=Termina" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 25 COL 67 VALUE "<ESC>=Retorna" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

       PROCEDURE DIVISION.
       MAIN-LOGIC. 
           MOVE "        A.B.M   STOCK        " TO WS-TITULO-PANTALLA
           MOVE "VERSION.01" TO WS-PROGRAMA
           MOVE "CREAR/EDITAR STOCK" TO WS-MODULO-PANTALLA
           PERFORM ABRO-ARCHIVO.
           
           PERFORM UNTIL FIN = "S"
               DISPLAY PANTALLA-BASE
               INITIALIZE DATOS-TRABAJO STOCK-REG
               MOVE "S" TO RESPUESTA
               
               PERFORM INGRESO-ID
               
               IF WS-KEY = KEY-ESC 
                   MOVE "S" TO FIN
               ELSE
                   PERFORM LEO-STOCK
                   PERFORM EDITAR-DATOS
                   IF WS-KEY NOT = KEY-ESC
                      PERFORM CONFIRMAR-Y-GUARDAR
                   END-IF
               END-IF
           END-PERFORM.

           PERFORM CIERRO-ARCHIVO.
           EXIT PROGRAM.

       INGRESO-ID.
           MOVE 0 TO W-CODIGO.
           ACCEPT W-CODIGO LINE 5 COL 25 WITH PROMPT HIGHLIGHT.
           IF WS-KEY = 2005 EXIT PARAGRAPH.
           IF W-CODIGO = 0 GO TO INGRESO-ID.

       LEO-STOCK.
           MOVE "S" TO EXISTE.
           MOVE W-CODIGO TO PRD-CODIGO
           READ PRODUCTOS INVALID KEY 
           DISPLAY "ERROR: PRODUCTO NO EXISTE" LINE 23 COL 1
                          MOVE "N" TO EXISTE
                          EXIT PARAGRAPH.
           *> 2. Si existe, traemos el IVA del producto a una variable de trabajo
           MOVE PRD-IVA TO W-IVA.
           *> 3. Ahora leemos el archivo de STOCK
           MOVE W-CODIGO TO STK-CODIGO.

           READ STOCK INVALID KEY 
               MOVE "N" TO EXISTE.

           IF EXISTE = "S"
               MOVE STK-CANTIDAD  TO W-CANTIDAD
               MOVE STK-MINIMO    TO W-MINIMO
               MOVE STK-MAXIMO    TO W-MAXIMO 
               MOVE W-IVA         TO PRD-IVA
               DISPLAY "MODO: EDICION" LINE 23 COL 1 BACKGROUND-COLOR 1
           ELSE
               INITIALIZE DATOS-TRABAJO
               DISPLAY "MODO: ALTA   " LINE 23 COL 1 BACKGROUND-COLOR 1
           END-IF.


       EDITAR-DATOS.
           *> Campo Cantidad
           ACCEPT W-CANTIDAD LINE 6 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.

           ACCEPT W-MINIMO   LINE 7 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.

           ACCEPT W-MAXIMO   LINE 8 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.

           *> 3. IVA (TU REGLA: El cursor se detiene aquí sí o sí)
           MOVE W-IVA TO W-IVA-DISP.
           ACCEPT W-IVA-DISP LINE 9 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.
           MOVE FUNCTION NUMVAL(W-IVA-DISP) TO W-IVA.


       CONFIRMAR-Y-GUARDAR.
           DISPLAY "Es Correcto [S/N] ? " LINE 22 COL 35 BACKGROUND-COLOR 1.
           ACCEPT RESPUESTA LINE 22 COL 55 WITH HIGHLIGHT.
           
           IF FUNCTION UPPER-CASE(RESPUESTA) = "S"
               MOVE W-CODIGO TO STK-CODIGO
               MOVE W-CANTIDAD TO STK-CANTIDAD
               MOVE W-MINIMO    TO STK-MINIMO 
               MOVE W-MAXIMO    TO STK-MAXIMO
               
               IF EXISTE = "S"
                   REWRITE STOCK-REG
               ELSE
                   WRITE STOCK-REG
               END-IF
               DISPLAY "GRABADO EXITOSO! Presione una tecla..." LINE 23 COL 1 
                       BACKGROUND-COLOR 2 FOREGROUND-COLOR 7
               ACCEPT WS-PAUSA LINE 23 COL 40
           END-IF.
       ABRO-ARCHIVO.
           OPEN I-O STOCK. 
           OPEN I-O PRODUCTOS. 

           IF ST-STOCK = "35" 
               OPEN OUTPUT STOCK 
               CLOSE STOCK 
               OPEN I-O STOCK.
               
           IF ST-PRODUCTOS NOT = "00"
               DISPLAY "ERROR AL ABRIR ARCHIVO PRODUCTOS: " ST-PRODUCTOS
           END-IF.

           IF ST-STOCK > "07"                                 
             STRING "Error al abrir Clientes " ST-STOCK 
                     DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20
              MOVE "S" TO FIN.

       CIERRO-ARCHIVO.
           CLOSE STOCK.

           
