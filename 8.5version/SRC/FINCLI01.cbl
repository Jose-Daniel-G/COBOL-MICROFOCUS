       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. FINCLI01.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "cliente.sel".

       DATA DIVISION.
       FILE SECTION.
           COPY "cliente.fd".

       WORKING-STORAGE SECTION.
       *> Estados de Archivo y Control
           COPY "TECLAS.cpy".
       01 WS-UI-CONTROLES.
          05 WS-TITULO-PANTALLA    PIC X(40) VALUE SPACES.
          05 WS-MODULO-PANTALLA    PIC X(26) VALUE SPACES.
          05 WS-PROGRAMA           PIC X(10) VALUE SPACES.

       01  ST-CLIENTES        PIC XX.
       01  MENSAJE        PIC X(70).
       01  WS-PAUSA       PIC X.
       01  RESPUESTA      PIC X     VALUE "S".
       01  FIN            PIC X     VALUE "N".
       01  EXISTE         PIC X.
       01  WS-KEY         PIC 9(4).
       
       *> Variables de Trabajo para el ID
       01  W-CLI-ID       PIC 9(08).
       01  W-CLI-ID-Z     PIC Z(06)9.

       *> Variables para capturar datos en pantalla
       01  DATOS-TRABAJO.
           05 W-NOMBRE    PIC X(30).
           05 W-DIR       PIC X(30).
           05 W-CP        PIC X(10).
           05 W-CAT       PIC X(01).
      *>     05 W-ESTADO    PIC X(01).

       SCREEN SECTION.
       01 PANTALLA-BASE.
           COPY "HEADER.cpy". 
           05 LINE 2 COL 70 VALUE " JD-TWINS "
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 4 COL 2  VALUE "  +-------------------------[ PARAMETROS ]-----------------------+"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 5 COL 4  VALUE "| Id Cliente       :" BACKGROUND-COLOR 1.
           05 LINE 5 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 6 COL 4  VALUE "| 01 Nombre        :" BACKGROUND-COLOR 1.
           05 LINE 6 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 7 COL 4  VALUE "| 02 Direccion     :" BACKGROUND-COLOR 1.
           05 LINE 7 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 8 COL 4  VALUE "| 03 Cod. Postal   :" BACKGROUND-COLOR 1.
           05 LINE 8 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 9 COL 4  VALUE "| 04 Categoria     :" BACKGROUND-COLOR 1.
           05 LINE 9 COL 67  VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 10 COL 2 VALUE "  +--------------------------------------------------------------+"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           *> Barra inferior
           05 LINE 25 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.      *>     05 LINE 25 COL 53 VALUE "F10=Termina" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 25 COL 67 VALUE "<ESC>=Retorna" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

       01 FORMULARIO.
           05 INP-NOM LINE 6 COL 25 PIC X(30) USING W-NOMBRE HIGHLIGHT.
           05 INP-DIR LINE 7 COL 25 PIC X(30) USING W-DIR    HIGHLIGHT.
           05 INP-CP  LINE 8 COL 25 PIC X(10) USING W-CP     HIGHLIGHT.
           05 INP-CAT LINE 9 COL 25 PIC X(01) USING W-CAT    HIGHLIGHT.

       PROCEDURE DIVISION.
       MAIN-LOGIC. 
           MOVE "        A.B.M   CLIENTES        " TO WS-TITULO-PANTALLA
           MOVE "VERSION.01" TO WS-PROGRAMA
           MOVE "CREAR/EDITAR CLIENTE" TO WS-MODULO-PANTALLA
           PERFORM ABRO-ARCHIVO.
           
           PERFORM UNTIL FIN = "S"
               DISPLAY PANTALLA-BASE
               INITIALIZE DATOS-TRABAJO CLIENTES-REG
               MOVE "S" TO RESPUESTA
               
               PERFORM INGRESO-ID
               
               IF WS-KEY = KEY-ESC 
                   MOVE "S" TO FIN
               ELSE
                   PERFORM LEO-CLIENTES
                   PERFORM EDITAR-DATOS
                   IF WS-KEY NOT = KEY-ESC
                      PERFORM CONFIRMAR-Y-GUARDAR
                   END-IF
               END-IF
           END-PERFORM.

           PERFORM CIERRO-ARCHIVO.
           EXIT PROGRAM.

       INGRESO-ID.
           MOVE 0 TO W-CLI-ID.
           ACCEPT W-CLI-ID LINE 5 COL 25 WITH PROMPT HIGHLIGHT.
           IF WS-KEY = 2005 EXIT PARAGRAPH.
           IF W-CLI-ID = 0 GO TO INGRESO-ID.

       LEO-CLIENTES.
           MOVE "S" TO EXISTE.
           MOVE W-CLI-ID TO CLI-ID.
           READ CLIENTES INVALID KEY 
               MOVE "N" TO EXISTE.
           
           IF EXISTE = "S"
               MOVE CLI-NOMBRE    TO W-NOMBRE
               MOVE CLI-DIRECCION TO W-DIR
               MOVE CLI-CODPOST   TO W-CP
               MOVE CLI-CATEGORIA TO W-CAT
               DISPLAY "MODO: EDICION" LINE 23 COL 1 BACKGROUND-COLOR 1
           ELSE
               INITIALIZE DATOS-TRABAJO
               DISPLAY "MODO: ALTA   " LINE 23 COL 1 BACKGROUND-COLOR 1
           END-IF.

       EDITAR-DATOS.
           ACCEPT FORMULARIO.

       CONFIRMAR-Y-GUARDAR.
           DISPLAY "Es Correcto [S/N] ? " LINE 22 COL 35 BACKGROUND-COLOR 1.
           ACCEPT RESPUESTA LINE 22 COL 55 WITH HIGHLIGHT.
           
           IF FUNCTION UPPER-CASE(RESPUESTA) = "S"
               MOVE W-CLI-ID TO CLI-ID
               MOVE W-NOMBRE TO CLI-NOMBRE
               MOVE W-DIR    TO CLI-DIRECCION
               MOVE W-CP     TO CLI-CODPOST
               MOVE W-CAT    TO CLI-CATEGORIA
               SET CLI-ACTIVO TO TRUE

               IF EXISTE = "S"
                   REWRITE CLIENTES-REG
               ELSE
                   WRITE CLIENTES-REG
               END-IF
               DISPLAY "GRABADO EXITOSO! Presione una tecla..." LINE 23 COL 1 
                       BACKGROUND-COLOR 2 FOREGROUND-COLOR 7
               ACCEPT WS-PAUSA LINE 23 COL 40
           END-IF.
       ABRO-ARCHIVO.
           OPEN I-O CLIENTES. 

           IF ST-CLIENTES = "35" 
               OPEN OUTPUT CLIENTES 
               CLOSE CLIENTES 
               OPEN I-O CLIENTES.

           IF ST-CLIENTES > "07"                                 
             STRING "Error al abrir Clientes " ST-CLIENTES 
                     DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20
              MOVE "S" TO FIN.

       CIERRO-ARCHIVO.
           CLOSE CLIENTES.

           