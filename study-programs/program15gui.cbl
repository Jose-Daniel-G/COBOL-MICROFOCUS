       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROGRAM15.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL. 
           SELECT OPTIONAL CLIENTES ASSIGN TO "./bin/DAT/clientes.dat"
                  ORGANIZATION INDEXED
                  ACCESS MODE IS DYNAMIC
                  RECORD KEY IS CLI-ID
                  STATUS ST-CLIENTES.     

          SELECT OPTIONAL FACTURAS
                 ASSIGN TO "./bin/DAT/facturas.dat"
                 ORGANIZATION IS SEQUENTIAL
                 ACCESS MODE IS SEQUENTIAL
                 FILE STATUS IS ST-FACTURAS.

       DATA DIVISION.
       FILE SECTION. 
       FD CLIENTES.
       01 CLIENTE-REG.
          05 CLI-ID        PIC 9(5).
          05 CLI-NOMBRE    PIC X(30).
          05 CLI-TELEFONO  PIC X(15).
          05 CLI-ESTADO    PIC X.      *> A=Activo  I=Inactivo
             88 CLI-ACTIVO             VALUE "A".
             88 CLI-INACTIVO           VALUE "I".
             
        FD FACTURAS.
        01 FACTURA-REG.
           05 FAC-NRO       PIC 9(7).
           05 FAC-FECHA     PIC 9(8).     *> AAAAMMDD
           05 FAC-CLI-ID    PIC 9(5).
           05 FAC-SUBTOTAL  PIC 9(11)V99.
           05 FAC-IVA       PIC 9(11)V99.
           05 FAC-TOTAL     PIC 9(11)V99.
           05 FAC-ESTADO    PIC X.   *> T = Temporal / C = Confirmada
              88 CLI-ACTIVO             VALUE "T".
              88 CLI-INACTIVO           VALUE "C".
              

       WORKING-STORAGE SECTION.
           01 MENSAJE         PIC X(70).
           01 ST-CLIENTES     PIC XX.
           01  WS-PAUSA       PIC X.
           01  FIN            PIC X VALUE "N".

           01 ST-FACTURAS     PIC XX.
           01 WS-CLI-ID       PIC 9(5).
           01 WS-NOMBRE       PIC X(30).

           01 WS-OK           PIC X VALUE "N".

       SCREEN SECTION.
       
       01  PANTALLA-BASE.
           05 BLANK SCREEN BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 01 COL 01 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7. 
           05 LINE 01 COL 02 VALUE "TEST 85 VER 1.0" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 01 COL 30 VALUE "LISTADO INDEXADO DE CLIENTES" BACKGROUND-COLOR 1.
           05 LINE 02 COL 01 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 03 COL 02 VALUE "MODO SELECCION" BACKGROUND-COLOR 1.
           05 LINE 04 COL 01  PIC X(80) FROM ALL "_" BACKGROUND-COLOR 1.
           05 LINE 05 COL 03 VALUE "1. Pedir Cliente" BACKGROUND-COLOR 1.
           05 LINE 06 COL 03 VALUE "2. Validar Cliente" BACKGROUND-COLOR 1.
           05 LINE 07 COL 03 VALUE "3. Crear Factura (temporal)" BACKGROUND-COLOR 1.
           05 LINE 08 COL 03 VALUE "4. Agregar Vehículos (detalle)" BACKGROUND-COLOR 1.
           05 LINE 09 COL 03 VALUE "5. Calcular totales" BACKGROUND-COLOR 1.
           05 LINE 10 COL 03 VALUE "6. Confirmar venta" BACKGROUND-COLOR 1.
           05 LINE 11 COL 03 VALUE "7. Grabar todo" BACKGROUND-COLOR 1. 
           05 LINE 25 COL 01 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 25 COL 02 VALUE "[F7] BUSCAR [F8] DEL [F9] TXT [F10] CSV [ENTER] EDITAR  [ESC] Retorna" 
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.


       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           DISPLAY PANTALLA-BASE.
           PERFORM ABRIR-CLIENTES.
           PERFORM OPCIONES
           PERFORM VALIDAR-CLIENTE
           IF WS-OK NOT = "S"
               DISPLAY "NO SE PUEDE CONTINUAR" LINE 16 COL 10
               GOBACK
           END-IF.
           
      
       ABRIR-CLIENTES.
           OPEN I-O CLIENTES
           IF ST-CLIENTES = "35"
               OPEN OUTPUT CLIENTES
               CLOSE CLIENTES
               OPEN I-O CLIENTES
           END-IF
       
           IF ST-CLIENTES > "07"
               STRING "ERROR CLIENTES: " ST-CLIENTES
                   DELIMITED BY SIZE
                   INTO MENSAJE
               DISPLAY MENSAJE LINE 22 COL 10
               ACCEPT OMITTED
               GOBACK
           END-IF.

       VALIDAR-CLIENTE.
         MOVE "N" TO WS-OK
     
         DISPLAY "ID CLIENTE: " LINE 12 COL 10
         ACCEPT WS-CLI-ID LINE 12 COL 25
     
         MOVE WS-CLI-ID TO CLI-ID
     
         READ CLIENTES
             INVALID KEY
                 DISPLAY "CLIENTE NO EXISTE" LINE 14 COL 10
             NOT INVALID KEY
                 IF CLI-ESTADO NOT = "A"
                     DISPLAY "CLIENTE INACTIVO" LINE 14 COL 10
                 ELSE
                     DISPLAY "CLIENTE: " CLI-NOMBRE LINE 14 COL 10
                     MOVE "S" TO WS-OK
                 END-IF
         END-READ.

       CREAR-FACTURA.
           ADD 1 TO FAC-NRO
           MOVE WS-CLI-ID TO FAC-CLI-ID
           MOVE FUNCTION CURRENT-DATE(1:8) TO FAC-FECHA
           MOVE 0 TO FAC-SUBTOTAL FAC-IVA FAC-TOTAL
           MOVE "T" TO FAC-ESTADO.

       AGREGAR-DETALLE.
       CALCULAR-TOTALES.
       CONFIRMAR-VENTA.

          
       END PROGRAM PROGRAM15.


