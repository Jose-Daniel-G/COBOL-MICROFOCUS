       IDENTIFICATION DIVISION.       
       PROGRAM-ID.  INVBOD01.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "bodega.sel".
       DATA DIVISION.

       FILE SECTION.
           COPY "bodega.fd".
       WORKING-STORAGE SECTION.
           COPY "TECLAS.cpy".

       01 WS-UI-CONTROLES.
          05 WS-TITULO-PANTALLA    PIC X(40) VALUE SPACES.
          05 WS-MODULO-PANTALLA    PIC X(26) VALUE SPACES.
          05 WS-PROGRAMA           PIC X(10) VALUE SPACES.


       01  FIN        PIC X VALUE "N".
       01  EXISTE     PIC X.
       01  RESPUESTA  PIC X VALUE "S".
       01  WS-PAUSA   PIC X.
       01  WS-KEY     PIC 9(4).
       01  ST-BODEGAS       PIC XX.
       01  MENSAJE          PIC X(70).
       01 W-BOD-CODIGO      PIC 9(04).

       01 DATOS-BODEGA.
          05 W-BOD-NOMBRE   PIC X(30).
          05 W-BOD-ESTADO   PIC X VALUE "A".

       SCREEN SECTION.
       01 PANTALLA-BASE.
           COPY "HEADER.cpy".

           05 LINE 4 COL 2 VALUE
              "  +-------------------------[ BODEGAS ]---------------------------+"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
        
           05 LINE 5 COL 4 VALUE "| Codigo Bodega    :" BACKGROUND-COLOR 1.
           05 LINE 5 COL 67 VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 6 COL 4 VALUE "| Nombre Bodega    :" BACKGROUND-COLOR 1.
           05 LINE 6 COL 67 VALUE "|" BACKGROUND-COLOR 1.
           05 LINE 7 COL 4 VALUE "| Estado (A/I)     :" BACKGROUND-COLOR 1.
           05 LINE 7 COL 67 VALUE "|" BACKGROUND-COLOR 1.
        
           05 LINE 8 COL 2 VALUE
              "  +---------------------------------------------------------------+"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
        
           05 LINE 25 COL 67 VALUE "<ESC>=Retorna"
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
    
           01 FORM-BODEGA.
              05 F-BOD-CODIGO LINE 5 COL 25 PIC 9(04) USING W-BOD-CODIGO.
              05 F-BOD-NOMBRE LINE 6 COL 25 PIC X(30) USING W-BOD-NOMBRE.
              05 F-BOD-ESTADO LINE 7 COL 25 PIC X     USING W-BOD-ESTADO. 
                      
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           MOVE "        A.B.M   BODEGA        " TO WS-TITULO-PANTALLA
           MOVE "VERSION.01" TO WS-PROGRAMA
           MOVE "CREAR/EDITAR BODEGA" TO WS-MODULO-PANTALLA
           PERFORM ABRO-ARCHIVO.

           PERFORM UNTIL FIN = "S"
              DISPLAY PANTALLA-BASE
              INITIALIZE DATOS-BODEGA
              ACCEPT F-BOD-CODIGO
           
              IF WS-KEY = KEY-ESC
                 MOVE "S" TO FIN
              ELSE
                 PERFORM LEER-BODEGA
                 PERFORM EDITAR-DATOS
                   IF WS-KEY NOT = KEY-ESC
                      PERFORM CONFIRMAR-Y-GUARDAR
                   END-IF
              END-IF
           END-PERFORM.

           PERFORM CIERRO-ARCHIVO.
           EXIT PROGRAM.            

       LEER-BODEGA.
          MOVE "S" TO EXISTE
          MOVE W-BOD-CODIGO TO BOD-CODIGO
       
          READ BODEGAS
             INVALID KEY MOVE "N" TO EXISTE
          END-READ
       
          IF EXISTE = "S"
             MOVE BOD-NOMBRE TO W-BOD-NOMBRE
             MOVE BOD-ESTADO TO W-BOD-ESTADO
             DISPLAY "MODO: EDICION" LINE 23 COL 1
          ELSE
             MOVE "A" TO W-BOD-ESTADO
             DISPLAY "MODO: ALTA" LINE 23 COL 1
          END-IF.

       EDITAR-DATOS.
      *>    ACCEPT W-BOD-CODIGO LINE 6 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
      *>    IF WS-KEY = KEY-ESC EXIT PARAGRAPH.
           ACCEPT W-BOD-NOMBRE LINE 6 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.
           ACCEPT W-BOD-ESTADO LINE 7 COL 25 WITH UPDATE PROMPT HIGHLIGHT.
           IF WS-KEY = KEY-ESC EXIT PARAGRAPH.

       CONFIRMAR-Y-GUARDAR.
           DISPLAY "Es Correcto [S/N] ? " LINE 22 COL 35 BACKGROUND-COLOR 1.
           ACCEPT RESPUESTA LINE 22 COL 55 WITH HIGHLIGHT.
           
           IF FUNCTION UPPER-CASE(RESPUESTA) = "S"
               MOVE W-BOD-CODIGO TO BOD-CODIGO
               MOVE W-BOD-NOMBRE TO BOD-NOMBRE
               MOVE W-BOD-ESTADO TO BOD-ESTADO  
               
               IF EXISTE = "S"
                   REWRITE BODEGAS-REG
               ELSE
                   WRITE BODEGAS-REG
               END-IF
               DISPLAY "GRABADO EXITOSO! Presione una tecla..." LINE 23 COL 1 
                       BACKGROUND-COLOR 2 FOREGROUND-COLOR 7
               ACCEPT WS-PAUSA LINE 23 COL 40
           END-IF.

       ABRO-ARCHIVO.
           OPEN I-O BODEGAS.
           IF ST-BODEGAS = "35" 
               OPEN OUTPUT BODEGAS 
               CLOSE BODEGAS 
               OPEN I-O BODEGAS.

           IF ST-BODEGAS > "07"                                 
             STRING "Error al abrir Clientes " ST-BODEGAS DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20 
              ACCEPT WS-PAUSA LINE 23 COL 55
              GOBACK
           END-IF.      
           
       CIERRO-ARCHIVO.
           CLOSE BODEGAS.

