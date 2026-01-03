       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. LISTADO.

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
       01  ST-FILE        PIC XX.
       01  MENSAJE    PIC X(70).
 
       01  WS-KEY         PIC 9(4).
       01  WS-FIN-LISTA   PIC X VALUE "N".
       01  WS-CONTADOR    PIC 99 VALUE 0.
       01  WS-FILA        PIC 99 VALUE 0.
       01  WS-PAUSA       PIC X.

       SCREEN SECTION.
       01 PANTALLA-LISTADO.
           05 BLANK SCREEN BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 1 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 1 COL 2 VALUE "TEST 8.5" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 1 COL 30 VALUE "LISTADO INDEXADO DE CLIENTES" BACKGROUND-COLOR 1.
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 2 COL 2 VALUE "VERSION.01                  CREAR/EDITAR USUARIO" 
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 2 COL 70 VALUE " JD-TWINS "
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           *> Encabezados de columna
           05 LINE 3 COL 2  VALUE "ID"          BACKGROUND-COLOR 1.
           05 LINE 3 COL 15 VALUE "NOMBRE"      BACKGROUND-COLOR 1.
           05 LINE 3 COL 47 VALUE "DIRECCION"   BACKGROUND-COLOR 1.
           05 LINE 3 COL 78 VALUE "C"           BACKGROUND-COLOR 1.
           05 LINE 4 COL 1  PIC X(80) FROM ALL "_" BACKGROUND-COLOR 1.

           
           *> Barra inferior
           05 LINE 24 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 24 COL 55 VALUE "F10=Termina" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 24 COL 70 VALUE "<ESC>=Retorna" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           SET ENVIRONMENT "COB_SCREEN_ESC"        TO "Y".
           OPEN INPUT CLIENTES.
           
           IF ST-FILE NOT = "00"
               DISPLAY "ERROR AL ABRIR ARCHIVO: " ST-FILE LINE 10 COL 20
               ACCEPT WS-PAUSA
               GOBACK
           END-IF.

           DISPLAY PANTALLA-LISTADO.
           PERFORM MOSTRAR-REGISTROS.
           
           *> Esperar a que el usuario presione ESC para salir
           PERFORM UNTIL WS-KEY = 2005
               ACCEPT WS-PAUSA LINE 24 COL 80
           END-PERFORM.

           CLOSE CLIENTES.
           GOBACK.

       MOSTRAR-REGISTROS.
           *> 1. Posicionar el puntero al inicio del archivo indexado
           MOVE ZERO TO CLI_ID.
           START CLIENTES KEY IS NOT LESS THAN CLI_ID
               INVALID KEY
                   DISPLAY "ARCHIVO VACIO" LINE 10 COL 35
                   MOVE "S" TO WS-FIN-LISTA
           END-START.

           *> 2. Leer secuencialmente desde esa posicion
           MOVE 5 TO WS-FILA. *> Empezamos a mostrar en la linea 5
           
           PERFORM UNTIL WS-FIN-LISTA = "S" OR WS-FILA > 22
               READ CLIENTES NEXT RECORD
                   AT END 
                       MOVE "S" TO WS-FIN-LISTA
                   NOT AT END
                       PERFORM PINTAR-LINEA
                       ADD 1 TO WS-FILA
               END-READ
           END-PERFORM.

       PINTAR-LINEA.
           DISPLAY CLI_ID        LINE WS-FILA COL 2 BACKGROUND-COLOR 1.
           DISPLAY CLI_NOMBRE    LINE WS-FILA COL 15 BACKGROUND-COLOR 1.
           DISPLAY CLI_DIRECCION LINE WS-FILA COL 47 BACKGROUND-COLOR 1.
           DISPLAY CLI_CATEGORIA LINE WS-FILA COL 78 BACKGROUND-COLOR 1.
