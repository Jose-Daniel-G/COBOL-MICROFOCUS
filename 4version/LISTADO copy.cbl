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
       01  MENSAJE        PIC X(70).
       01  WS-KEY         PIC 9(4).
       01  WS-FIN-LISTA   PIC X VALUE "N".
       
       01  WS-FILA        PIC 99.
       01  WS-FILA-INICIO PIC 99 VALUE 5.
       01  WS-FILA-MAX    PIC 99.
       01  WS-PUNTERO     PIC 99 VALUE 5.
       01  WS-INDICE      PIC 99 VALUE 1.
       01  WS-PAUSA       PIC X.

       01  TABLA-PANTALLA.
           05 REG-PANTALLA OCCURS 20 TIMES.
              10 T-ID      PIC 9(07).
              10 T-NOM     PIC X(30).
              10 T-DIR     PIC X(30).
              10 T-CAT     PIC X(01).

       SCREEN SECTION.
       01 PANTALLA-LISTADO.
           05 BLANK SCREEN BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 1 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 1 COL 2 VALUE "TEST 8.5" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 1 COL 30 VALUE "LISTADO INDEXADO DE CLIENTES" BACKGROUND-COLOR 1.
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 2 COL 2 VALUE "MODO SELECCION" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 3 COL 2  VALUE "ID"          BACKGROUND-COLOR 1.
           05 LINE 3 COL 15 VALUE "NOMBRE"      BACKGROUND-COLOR 1.
           05 LINE 3 COL 47 VALUE "DIRECCION"   BACKGROUND-COLOR 1.
           05 LINE 3 COL 78 VALUE "C"          BACKGROUND-COLOR 1.
           05 LINE 4 COL 1  PIC X(80) FROM ALL "_" BACKGROUND-COLOR 1.
           05 LINE 25 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 25 COL 2 VALUE "[FLECHAS] Navegar  [ENTER] Seleccionar  [ESC] Retorna" 
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

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
           
           *> IMPORTANTE: Limpiar banderas antes de empezar
           MOVE "N" TO WS-FIN-LISTA.
           MOVE 9999 TO WS-KEY. *> Valor inicial para que no entre con 0 o 2005
           
           PERFORM MOSTRAR-REGISTROS.
           
           *> Verificar si se cargaron registros antes de navegar
           IF WS-FILA-MAX >= WS-FILA-INICIO
               PERFORM NAVEGACION-BUCLE
           ELSE
               DISPLAY "NO HAY DATOS PARA MOSTRAR" LINE 10 COL 30
               ACCEPT WS-PAUSA LINE 25 COL 80
           END-IF.

           CLOSE CLIENTES.
           GOBACK.

       NAVEGACION-BUCLE.
           *> El bucle se mantiene mientras no sea ESC (2005) o ENTER (0)
           PERFORM UNTIL WS-KEY = 2005 OR WS-KEY = 0
               PERFORM RESALTAR-FILA
               
               *> Este ACCEPT es el que detiene el programa y espera la flecha
               ACCEPT WS-PAUSA LINE WS-PUNTERO COL 1 WITH NO-ECHO
               
               EVALUATE WS-KEY
                   WHEN 2002 *> Flecha Abajo
                       IF WS-PUNTERO < WS-FILA-MAX
                          PERFORM NORMALIZAR-FILA
                          ADD 1 TO WS-PUNTERO
                          ADD 1 TO WS-INDICE
                       END-IF
                   WHEN 2001 *> Flecha Arriba
                       IF WS-PUNTERO > WS-FILA-INICIO
                          PERFORM NORMALIZAR-FILA
                          SUBTRACT 1 FROM WS-PUNTERO
                          SUBTRACT 1 FROM WS-INDICE
                       END-IF
               END-EVALUATE
           END-PERFORM.

       MOSTRAR-REGISTROS.
           MOVE ZERO TO CLI_ID.
           START CLIENTES KEY IS NOT LESS THAN CLI_ID
               INVALID KEY
                   MOVE "S" TO WS-FIN-LISTA
           END-START.

           MOVE WS-FILA-INICIO TO WS-FILA. 
           MOVE 1 TO WS-INDICE.
           
           PERFORM UNTIL WS-FIN-LISTA = "S" OR WS-FILA > 22
               READ CLIENTES NEXT RECORD
                   AT END MOVE "S" TO WS-FIN-LISTA
                   NOT AT END
                       MOVE CLI_ID        TO T-ID(WS-INDICE)
                       MOVE CLI_NOMBRE    TO T-NOM(WS-INDICE)
                       MOVE CLI_DIRECCION TO T-DIR(WS-INDICE)
                       MOVE CLI_CATEGORIA TO T-CAT(WS-INDICE)
                       
                       PERFORM NORMALIZAR-PINTADO
                       ADD 1 TO WS-FILA
                       ADD 1 TO WS-INDICE
               END-READ
           END-PERFORM.
           
           *> Guardamos el limite real de lo que se pinto
           MOVE WS-FILA TO WS-FILA-MAX.
           SUBTRACT 1 FROM WS-FILA-MAX.
           
           *> Reset de punteros al primer registro de la lista
           MOVE 1 TO WS-INDICE.
           MOVE WS-FILA-INICIO TO WS-PUNTERO.

       NORMALIZAR-PINTADO.
           DISPLAY T-ID(WS-INDICE)  LINE WS-FILA COL 2  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-NOM(WS-INDICE) LINE WS-FILA COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-DIR(WS-INDICE) LINE WS-FILA COL 47 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CAT(WS-INDICE) LINE WS-FILA COL 78 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

       RESALTAR-FILA.
           DISPLAY T-ID(WS-INDICE)  LINE WS-PUNTERO COL 2  BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-NOM(WS-INDICE) LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-DIR(WS-INDICE) LINE WS-PUNTERO COL 47 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-CAT(WS-INDICE) LINE WS-PUNTERO COL 78 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.

       NORMALIZAR-FILA.
           DISPLAY T-ID(WS-INDICE)  LINE WS-PUNTERO COL 2  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-NOM(WS-INDICE) LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-DIR(WS-INDICE) LINE WS-PUNTERO COL 47 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CAT(WS-INDICE) LINE WS-PUNTERO COL 78 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
