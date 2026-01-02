       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VENFAC01.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "cliente.sel".
           COPY "factura.sel".
       DATA DIVISION.
       FILE SECTION.
           COPY "cliente.fd".
           COPY "factura.fd".
           

       WORKING-STORAGE SECTION.

       01 ST-CLIENTES      PIC XX.
       01 ST-FACTURAS      PIC XX.

       01 WS-CLI-ID        PIC 9(5).
       01 WS-OK            PIC X VALUE "N".
       01 WS-PAUSA         PIC X.

       01 WS-MENSAJE       PIC X(80).

       SCREEN SECTION.

       01 PANTALLA-BASE.
           05 BLANK SCREEN.
           05 LINE 01 COL 02 VALUE "TEST 85 VER 1.0".
           05 LINE 01 COL 30 VALUE "VENTAS - FACTURACION".
           05 LINE 03 COL 02 VALUE "1. Validar Cliente".
           05 LINE 04 COL 02 VALUE "2. Crear Factura (temporal)".
           05 LINE 05 COL 02 VALUE "3. Confirmar Venta".

       PROCEDURE DIVISION.

       MAIN.
           DISPLAY PANTALLA-BASE
           PERFORM ABRIR-ARCHIVOS
           PERFORM VALIDAR-CLIENTE
           IF WS-OK NOT = "S"
               DISPLAY "NO SE PUEDE CONTINUAR" LINE 10 COL 10
               GOBACK
           END-IF
           PERFORM CREAR-FACTURA
           DISPLAY "FACTURA TEMPORAL CREADA" LINE 12 COL 10
           ACCEPT WS-PAUSA LINE 14 COL 10
           PERFORM CERRAR-ARCHIVOS
           STOP RUN.

       ABRIR-ARCHIVOS.
           OPEN I-O CLIENTES
           IF ST-CLIENTES = "35"
               OPEN OUTPUT CLIENTES
               CLOSE CLIENTES
               OPEN I-O CLIENTES
           END-IF

           IF ST-CLIENTES > "07"
               STRING "Error CLIENTES: " ST-CLIENTES
                   INTO WS-MENSAJE
               DISPLAY WS-MENSAJE LINE 20 COL 10
               STOP RUN
           END-IF

           OPEN EXTEND FACTURAS
           IF ST-FACTURAS = "35"
               OPEN OUTPUT FACTURAS
               CLOSE FACTURAS
               OPEN EXTEND FACTURAS
           END-IF

           IF ST-FACTURAS > "07"
               STRING "Error FACTURAS: " ST-FACTURAS
                   INTO WS-MENSAJE
               DISPLAY WS-MENSAJE LINE 21 COL 10
               STOP RUN
           END-IF.

       VALIDAR-CLIENTE.
           MOVE "N" TO WS-OK
           DISPLAY "ID CLIENTE: " LINE 8 COL 10
           ACCEPT WS-CLI-ID LINE 8 COL 25

           MOVE WS-CLI-ID TO CLI-ID

           READ CLIENTES
               INVALID KEY
                   DISPLAY "CLIENTE NO EXISTE" LINE 9 COL 10
               NOT INVALID KEY
                   IF CLI-ESTADO NOT = "A"
                       DISPLAY "CLIENTE INACTIVO" LINE 9 COL 10
                   ELSE
                       DISPLAY "CLIENTE: " CLI-NOMBRE LINE 9 COL 10
                       MOVE "S" TO WS-OK
                   END-IF
           END-READ.

       CREAR-FACTURA.
           MOVE 0 TO FAC-NRO
           ADD 1 TO FAC-NRO
           MOVE WS-CLI-ID TO FAC-CLI-ID
           MOVE FUNCTION CURRENT-DATE(1:8) TO FAC-FECHA
           MOVE 0 TO FAC-SUBTOTAL FAC-IVA FAC-TOTAL
           MOVE "T" TO FAC-ESTADO
           WRITE FACTURA-REG.

       CERRAR-ARCHIVOS.
           CLOSE CLIENTES
           CLOSE FACTURAS.

       END PROGRAM VENFAC01.
