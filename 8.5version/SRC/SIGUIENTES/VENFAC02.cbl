       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VENFAC02.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "factura.sel".
           COPY "detalle.sel".
       
       DATA DIVISION.
       FILE SECTION.
           COPY "factura.fd".
           COPY "detalle.fd".
       
       WORKING-STORAGE SECTION.
       
       01 ST-FACTURAS       PIC XX.
       01 ST-DETALLES       PIC XX.
       
       01 WS-FAC-NRO        PIC 9(7).
       01 WS-ITEM           PIC 9(3) VALUE 0.
       01 WS-MAS            PIC X VALUE "S".
       01 WS-PAUSA          PIC X.
       
       01 WS-PROD-ID        PIC X(10).
       01 WS-DESCRIP        PIC X(30).
       01 WS-CANT           PIC 9(3).
       01 WS-PRECIO         PIC 9(11)V99.
       
       01 WS-MENSAJE        PIC X(80).
       
       SCREEN SECTION.
       01 PANTALLA-BASE.
           05 BLANK SCREEN.
           05 LINE 01 COL 02 VALUE "VENTAS - AGREGAR DETALLE".
           05 LINE 03 COL 02 VALUE "FACTURA:".
       
       PROCEDURE DIVISION.
       
       MAIN.
           DISPLAY PANTALLA-BASE
           PERFORM ABRIR-ARCHIVOS
           PERFORM VALIDAR-FACTURA
           PERFORM AGREGAR-DETALLE
           PERFORM CERRAR-ARCHIVOS
           GOBACK.
       
       ABRIR-ARCHIVOS.
           OPEN I-O FACTURAS
           IF ST-FACTURAS = "35"
               OPEN OUTPUT FACTURAS
               CLOSE FACTURAS
               OPEN I-O FACTURAS
           END-IF
       
           IF ST-FACTURAS > "07"
               STRING "ERROR FACTURAS: " ST-FACTURAS
                   INTO WS-MENSAJE
               DISPLAY WS-MENSAJE LINE 22 COL 10
               STOP RUN
           END-IF
       
           OPEN EXTEND DETALLES
           IF ST-DETALLES = "35"
               OPEN OUTPUT DETALLES
               CLOSE DETALLES
               OPEN EXTEND DETALLES
           END-IF
       
           IF ST-DETALLES > "07"
               STRING "ERROR DETALLES: " ST-DETALLES
                   INTO WS-MENSAJE
               DISPLAY WS-MENSAJE LINE 23 COL 10
               STOP RUN
           END-IF.
       
       VALIDAR-FACTURA.
           DISPLAY "NUMERO FACTURA: " LINE 03 COL 12
           ACCEPT WS-FAC-NRO        LINE 03 COL 30
       
           MOVE WS-FAC-NRO TO FAC-NRO
           READ FACTURAS
               INVALID KEY
                   DISPLAY "FACTURA NO EXISTE" LINE 05 COL 10
                   ACCEPT WS-PAUSA
                   STOP RUN
           END-READ
       
           IF FAC-ESTADO NOT = "T"
               DISPLAY "FACTURA NO ES TEMPORAL" LINE 06 COL 10
               ACCEPT WS-PAUSA
               STOP RUN
           END-IF.
       
       AGREGAR-DETALLE.
           MOVE "S" TO WS-MAS
           MOVE 0   TO WS-ITEM
       
           PERFORM UNTIL WS-MAS NOT = "S"
       
               ADD 1 TO WS-ITEM
       
               DISPLAY "PRODUCTO ID : " LINE 08 COL 10
               ACCEPT WS-PROD-ID    LINE 08 COL 30
       
               DISPLAY "DESCRIPCION : " LINE 09 COL 10
               ACCEPT WS-DESCRIP    LINE 09 COL 30
       
               DISPLAY "CANTIDAD    : " LINE 10 COL 10
               ACCEPT WS-CANT       LINE 10 COL 30
       
               DISPLAY "PRECIO      : " LINE 11 COL 10
               ACCEPT WS-PRECIO     LINE 11 COL 30
       
               COMPUTE DET-SUBTOTAL =
                   WS-CANT * WS-PRECIO
       
               MOVE WS-FAC-NRO   TO DET-FAC-NRO
               MOVE WS-ITEM      TO DET-ITEM
               MOVE WS-PROD-ID   TO DET-PROD-ID
               MOVE WS-DESCRIP   TO DET-DESCRIP
               MOVE WS-CANT      TO DET-CANT
               MOVE WS-PRECIO    TO DET-PRECIO
       
               WRITE DETALLE-REG
       
               IF ST-DETALLES NOT = "00"
                   DISPLAY "ERROR AL GRABAR DETALLE" LINE 20 COL 10
                   EXIT PARAGRAPH
               END-IF
       
               DISPLAY "¿OTRO ITEM? (S/N): " LINE 13 COL 10
               ACCEPT WS-MAS         LINE 13 COL 35
       
           END-PERFORM.
       
       CERRAR-ARCHIVOS.
           CLOSE FACTURAS
           CLOSE DETALLES.
       
       END PROGRAM VENFAC02.
       