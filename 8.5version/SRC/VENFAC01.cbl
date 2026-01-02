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
       01 WS-CLIENTE-OK    PIC X VALUE "N".
       01 WS-ULT-FAC-NRO   PIC 9(7) VALUE 0.

       01 WS-PAUSA         PIC X.

       01 WS-MENSAJE       PIC X(80).

       SCREEN SECTION.
       01 PANTALLA-BASE.
           05 BLANK SCREEN BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 01 COL 01 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 01 COL 02 VALUE "TEST 8.5 VER 1.0" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 01 COL 30 VALUE "VENTAS - FACTURACION" BACKGROUND-COLOR 1.
           05 LINE 02 COL 01 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 02 COL 02 VALUE "MODO SELECCION" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 05 COL 03 VALUE "1. Validar Cliente" BACKGROUND-COLOR 1.
           05 LINE 06 COL 03 VALUE "2. Crear Factura (temporal)" BACKGROUND-COLOR 1.
           05 LINE 07 COL 03 VALUE "3. Confirmar Venta"   BACKGROUND-COLOR 1. 
      *>     05 LINE 04 COL 01  PIC X(80) FROM ALL "_" BACKGROUND-COLOR 1.
           05 LINE 25 COL 01 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 25 COL 02 VALUE "  [ESC] Retorna" 
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
       PROCEDURE DIVISION.

       MAIN.
           DISPLAY PANTALLA-BASE
           PERFORM ABRIR-ARCHIVOS
           PERFORM VALIDAR-CLIENTE
           IF WS-CLIENTE-OK = "S"
               PERFORM CREAR-FACTURA
      *>         PERFORM AGREGAR-DETALLE
      *>         PERFORM CALCULAR-TOTALES
      *>         PERFORM CONFIRMAR
      *>         PERFORM GRABAR
               DISPLAY "FACTURA TEMPORAL CREADA" LINE 12 COL 10
               ACCEPT WS-PAUSA LINE 14 COL 10
           ELSE
               DISPLAY "PRESIONE UNA TECLA PARA BUSCAR NUEVAMENTE..." LINE 11 COL 10
               ACCEPT WS-PAUSA LINE 11 COL 55
               PERFORM VALIDAR-CLIENTE
               GOBACK
           END-IF
           PERFORM CERRAR-ARCHIVOS
           GOBACK.

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
           MOVE "N" TO WS-CLIENTE-OK
           DISPLAY "ID: " LINE 16 COL 10
           ACCEPT WS-CLI-ID LINE 16 COL 25

           MOVE WS-CLI-ID TO CLI-ID

           READ CLIENTES
           END-READ
           
           EVALUATE ST-CLIENTES
              WHEN "00"
                 IF CLI-ESTADO NOT = "A"
                     DISPLAY "CLIENTE INACTIVO" LINE 9 COL 10
                     ACCEPT WS-PAUSA LINE 9 COL 55
                 ELSE
                     DISPLAY "CLIENTE: " CLI-NOMBRE LINE 9 COL 10
                     MOVE "S" TO WS-CLIENTE-OK
                 END-IF
           
              WHEN "23"
                 DISPLAY "CLIENTE NO EXISTE" LINE 9 COL 10
                 ACCEPT WS-PAUSA LINE 9 COL 55
           
              WHEN OTHER
                 STRING "ERROR CLIENTES: " ST-CLIENTES
                    INTO WS-MENSAJE
                 DISPLAY WS-MENSAJE LINE 20 COL 10
                 STOP RUN
           END-EVALUATE.


       CREAR-FACTURA.
       
           *> Obtener último número de factura
           MOVE 0 TO WS-ULT-FAC-NRO
       
           READ FACTURAS
               AT END
                   MOVE 1 TO WS-ULT-FAC-NRO
               NOT AT END
                   MOVE FAC-NRO TO WS-ULT-FAC-NRO
                   ADD 1 TO WS-ULT-FAC-NRO
           END-READ
       
           *> Crear factura temporal
           MOVE WS-ULT-FAC-NRO TO FAC-NRO
           MOVE WS-CLI-ID      TO FAC-CLI-ID
           MOVE FUNCTION CURRENT-DATE(1:8) TO FAC-FECHA
           MOVE 0 TO FAC-SUBTOTAL FAC-IVA FAC-TOTAL
           MOVE "T" TO FAC-ESTADO
       
           WRITE FACTURA-REG
       
           IF ST-FACTURAS NOT = "00"
               STRING "ERROR AL CREAR FACTURA: " ST-FACTURAS
                   INTO WS-MENSAJE
               DISPLAY WS-MENSAJE LINE 22 COL 10
               STOP RUN
           END-IF.
       CERRAR-ARCHIVOS.
           CLOSE CLIENTES
           CLOSE FACTURAS.

       END PROGRAM VENFAC01.
