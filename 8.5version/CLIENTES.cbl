>>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLIENTES.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "./clientes.sel".

       DATA DIVISION.
       FILE SECTION.
           COPY "./clientes.fd".

       WORKING-STORAGE SECTION.
       *> Estados de Archivo y Control
           COPY "./CPY/TECLAS.cpy".
       01  ST-FILE        PIC XX.
       01  MENSAJE        PIC X(70).
       01  WS-PAUSA       PIC X.
       01  RESPUESTA      PIC X     VALUE "S".
       01  FIN            PIC X     VALUE "N".
       01  EXISTE         PIC X.
       01  WS-KEY         PIC 9(4).
       
       *> Variables de Trabajo para el ID
       01  W-CLI-ID       PIC 9(07).
       01  W-CLI-ID-Z     PIC Z(06)9.

       *> Variables para capturar datos en pantalla
       01  DATOS-TRABAJO.
           05 W-NOMBRE    PIC X(30).
           05 W-DIR       PIC X(30).
           05 W-CP        PIC X(10).
           05 W-CAT       PIC X(01).

       SCREEN SECTION.
       01 PANTALLA-BASE.
           05 BLANK SCREEN BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           *> Encabezado Siesa
           05 LINE 1 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 1 COL 2 VALUE "TEST 8.5" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 1 COL 25 VALUE "        A.B.M   CLIENTES           " 
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 2 COL 2 VALUE "VERSION.01                  CREAR/EDITAR USUARIO" 
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
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
           05 LINE 25 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
      *>     05 LINE 25 COL 53 VALUE "F10=Termina" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 25 COL 67 VALUE "<ESC>=Retorna" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

       01 FORMULARIO.
           05 INP-NOM LINE 6 COL 25 PIC X(30) USING W-NOMBRE HIGHLIGHT.
           05 INP-DIR LINE 7 COL 25 PIC X(30) USING W-DIR    HIGHLIGHT.
           05 INP-CP  LINE 8 COL 25 PIC X(10) USING W-CP     HIGHLIGHT.
           05 INP-CAT LINE 9 COL 25 PIC X(01) USING W-CAT    HIGHLIGHT.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           SET ENVIRONMENT "COB_SCREEN_ESC"        TO "Y". 

           PERFORM ABRO-ARCHIVO.
           
           PERFORM UNTIL FIN = "S"
               DISPLAY PANTALLA-BASE
               INITIALIZE DATOS-TRABAJO REG-CLIENTES
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

       ABRO-ARCHIVO.
           OPEN I-O CLIENTES.
           *> Si el archivo no existe (Error 35), lo creamos
           IF ST-FILE = "35" 
               OPEN OUTPUT CLIENTES 
               CLOSE CLIENTES 
               OPEN I-O CLIENTES.

           IF ST-FILE > "07"                                 
             STRING "Error al abrir Clientes " ST-FILE DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20
              MOVE "S" TO FIN.
       INGRESO-ID.
           MOVE 0 TO W-CLI-ID.
           ACCEPT W-CLI-ID LINE 5 COL 25 WITH PROMPT HIGHLIGHT.
           IF WS-KEY = 2005 EXIT PARAGRAPH.
           IF W-CLI-ID = 0 GO TO INGRESO-ID.

       LEO-CLIENTES.
           MOVE "S" TO EXISTE.
           MOVE W-CLI-ID TO CLI_ID.
           READ CLIENTES INVALID KEY 
               MOVE "N" TO EXISTE.
           
           IF EXISTE = "S"
               MOVE CLI_NOMBRE    TO W-NOMBRE
               MOVE CLI_DIRECCION TO W-DIR
               MOVE CLI_CODPOST   TO W-CP
               MOVE CLI_CATEGORIA TO W-CAT
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
               MOVE W-CLI-ID TO CLI_ID
               MOVE W-NOMBRE TO CLI_NOMBRE
               MOVE W-DIR    TO CLI_DIRECCION
               MOVE W-CP     TO CLI_CODPOST
               MOVE W-CAT    TO CLI_CATEGORIA
               
               IF EXISTE = "S"
                   REWRITE REG-CLIENTES
               ELSE
                   WRITE REG-CLIENTES
               END-IF
               DISPLAY "GRABADO EXITOSO! Presione una tecla..." LINE 23 COL 1 
                       BACKGROUND-COLOR 2 FOREGROUND-COLOR 7
               ACCEPT WS-PAUSA LINE 23 COL 40
           END-IF.

       CIERRO-ARCHIVO.
           CLOSE CLIENTES.

           