       >>SOURCE FORMAT FREE
      *> ******************************************************************
      *> * Author:   JOSE DANIEL GRIJALBA
      *> * Date:     12/23/2025
      *> * Purpose:  LEARN
      *> * Tectonics: cobc
      *> ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVPRO01.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.
       
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "producto.sel".
       
       DATA DIVISION.
       FILE SECTION. 
           COPY "producto.fd".
            
       WORKING-STORAGE SECTION. 
           COPY "TECLAS.cpy".
       01 WS-UI-CONTROLES.
          05 WS-TITULO-PANTALLA    PIC X(40) VALUE SPACES.
          05 WS-MODULO-PANTALLA    PIC X(26) VALUE SPACES.
          05 WS-PROGRAMA           PIC X(10) VALUE SPACES.
       
       01  ST-PRODUCTOS        PIC XX.
       01  MENSAJE             PIC X(70).
       01  WS-PAUSA            PIC X.
       01  RESPUESTA           PIC X     VALUE "S".
       01  FIN                 PIC X     VALUE "N".
       01  EXISTE              PIC X.
       01  WS-KEY              PIC 9(4).
       
       *> Variables de Trabajo para el ID
       01  W-PRD-CODIGO       PIC 9(10).
       
       *> Variables para capturar datos en pantalla (SIN decimales en ACCEPT)
       01  DATOS-TRABAJO.
           05 W-DESCRIPCION    PIC X(40).
           05 W-PRECIO         PIC 9(9)V99.
           *> Campos puente para la pantalla:
           05 W-PRECIO-DISP    PIC Z(9).99.
           05 W-IVA            PIC 99.
           05 W-IVA-DISP       PIC Z9.
           05 W-ESTADO         PIC X.
       
       SCREEN SECTION.
       01 PANTALLA-BASE.
           COPY "HEADER.cpy". 
           05 LINE 2 COL 70 VALUE " JD-TWINS "
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 4 COL 2  VALUE "  +-------------------------[ PARAMETROS ]-----------------------+"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 5 COL 4  VALUE "| Id Producto       :" BACKGROUND-COLOR 1.
           05 LINE 5 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 6 COL 4  VALUE "| 01 Descripcion    :" BACKGROUND-COLOR 1.
           05 LINE 6 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 7 COL 4  VALUE "| 02 Precio         :" BACKGROUND-COLOR 1.
           05 LINE 7 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 8 COL 4  VALUE "| 03 Iva            :" BACKGROUND-COLOR 1.
           05 LINE 8 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 9 COL 4  VALUE "| 04 Estado (A/I)   :" BACKGROUND-COLOR 1.
           05 LINE 9 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 10 COL 2 VALUE "  +--------------------------------------------------------------+"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           *> Barra inferior
           05 LINE 25 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 25 COL 67 VALUE "<ESC>=Retorna" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
        
       PROCEDURE DIVISION.
       MAIN-LOGIC. 
           MOVE "        A.B.M   PRODUCTO        " TO WS-TITULO-PANTALLA
           MOVE "CREAR/EDITAR PRODUCTO"            TO WS-MODULO-PANTALLA
           MOVE "INVPRO01"                         TO WS-PROGRAMA
           PERFORM ABRO-ARCHIVO.
           
           PERFORM UNTIL FIN = "S"
               DISPLAY PANTALLA-BASE
               INITIALIZE DATOS-TRABAJO PRODUCTO-REG
               MOVE "S" TO RESPUESTA
               MOVE 0 TO WS-KEY
               
               PERFORM INGRESO-ID
               
               IF WS-KEY = KEY-ESC 
                   MOVE "S" TO FIN
               ELSE
                   PERFORM LEO-PRODUCTOS
                   PERFORM EDITAR-DATOS
                   IF WS-KEY NOT = KEY-ESC
                      PERFORM CONFIRMAR-Y-GUARDAR
                   END-IF
               END-IF
           END-PERFORM.
       
           PERFORM CIERRO-ARCHIVO.
           EXIT PROGRAM.
       
       INGRESO-ID.
           MOVE 0 TO W-PRD-CODIGO.
           ACCEPT W-PRD-CODIGO LINE 5 COL 25 WITH PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.
           IF W-PRD-CODIGO = 0 GO TO INGRESO-ID.
       
       LEO-PRODUCTOS.
           MOVE "S" TO EXISTE.
           MOVE W-PRD-CODIGO TO PRD-CODIGO.
           READ PRODUCTOS INVALID KEY 
               MOVE "N" TO EXISTE.
           
           IF EXISTE = "S"
               MOVE PRD-DESCRIPCION TO W-DESCRIPCION
               MOVE PRD-PRECIO      TO W-PRECIO
               MOVE PRD-IVA         TO W-IVA    
               MOVE PRD-ESTADO      TO W-ESTADO
               DISPLAY "MODO: EDICION" LINE 23 COL 1 BACKGROUND-COLOR 1
           ELSE
               INITIALIZE DATOS-TRABAJO
               MOVE "A" TO W-ESTADO
               DISPLAY "MODO: ALTA   " LINE 23 COL 1 BACKGROUND-COLOR 1
           END-IF.
       
       *> ============================================================
       *> SOLUCIÓN PRINCIPAL: ACCEPT campo por campo
       *> ============================================================
       EDITAR-DATOS.
           *> 1. DESCRIPCION
           ACCEPT W-DESCRIPCION LINE 6 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.
           
           *> 2. PRECIO
           MOVE W-PRECIO TO W-PRECIO-DISP.
           ACCEPT W-PRECIO-DISP LINE 7 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.
           *> Convertimos de vuelta al campo numérico
           COMPUTE W-PRECIO = FUNCTION NUMVAL(W-PRECIO-DISP).

           *> 3. IVA (TU REGLA: El cursor se detiene aquí sí o sí)
           MOVE W-IVA TO W-IVA-DISP.
           ACCEPT W-IVA-DISP LINE 8 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.
           MOVE FUNCTION NUMVAL(W-IVA-DISP) TO W-IVA.
           
           *> 4. ESTADO
           ACCEPT W-ESTADO LINE 9 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.
       
       CONFIRMAR-Y-GUARDAR.
           DISPLAY "Es Correcto [S/N] ? " LINE 22 COL 35 BACKGROUND-COLOR 1.
           ACCEPT RESPUESTA LINE 22 COL 55 WITH HIGHLIGHT.
           
           IF FUNCTION UPPER-CASE(RESPUESTA) = "S"
               MOVE W-PRD-CODIGO    TO PRD-CODIGO
               MOVE W-DESCRIPCION   TO PRD-DESCRIPCION
               MOVE W-PRECIO        TO PRD-PRECIO
               MOVE W-IVA           TO PRD-IVA
               MOVE W-ESTADO        TO PRD-ESTADO
       
               IF EXISTE = "S"
                   REWRITE PRODUCTO-REG
               ELSE
                   WRITE PRODUCTO-REG
               END-IF
               DISPLAY "GRABADO EXITOSO! Presione una tecla..." LINE 23 COL 1 
                       BACKGROUND-COLOR 2 FOREGROUND-COLOR 7
               ACCEPT WS-PAUSA LINE 23 COL 40
           END-IF.
       
       ABRO-ARCHIVO.
           OPEN I-O PRODUCTOS.
           
           IF ST-PRODUCTOS = "35"
               OPEN OUTPUT PRODUCTOS 
               CLOSE PRODUCTOS 
               OPEN I-O PRODUCTOS
           END-IF.
       
           IF ST-PRODUCTOS > "07"                                 
             STRING "Error al abrir Productos " ST-PRODUCTOS 
                     DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20
              MOVE "S" TO FIN
           END-IF.
       
       CIERRO-ARCHIVO.
           CLOSE PRODUCTOS.
       
       END PROGRAM INVPRO01.
       