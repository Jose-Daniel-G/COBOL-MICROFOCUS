       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVPRO01-pro.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "producto.sel".

       DATA DIVISION.
       FILE SECTION.
           COPY "producto.fd".

       WORKING-STORAGE SECTION.

       01 ST-PRODUCTOS        PIC XX.
       01 WS-OPCION           PIC X.
       01 WS-PAUSA            PIC X.
       01 WS-MENSAJE          PIC X(80).

       SCREEN SECTION.
       01 PANTALLA-PROD.
           05 BLANK SCREEN.
           05 LINE 02 COL 20 VALUE "ABM PRODUCTOS".
           05 LINE 04 COL 10 VALUE "1. Alta Producto".
           05 LINE 05 COL 10 VALUE "2. Modificar Producto".
           05 LINE 06 COL 10 VALUE "3. Baja Producto".
           05 LINE 07 COL 10 VALUE "4. Consultar Producto".
           05 LINE 08 COL 10 VALUE "5. Salir".
           05 LINE 10 COL 10 VALUE "Opcion: ".

       PROCEDURE DIVISION.

       MAIN.
           PERFORM ABRIR-ARCHIVO
           PERFORM MENU-PROGRAM
           PERFORM CERRAR-ARCHIVO
           GOBACK.

       MENU-PROGRAM.
           PERFORM UNTIL WS-OPCION = "5"
               DISPLAY PANTALLA-PROD
               ACCEPT WS-OPCION LINE 10 COL 18
               EVALUATE WS-OPCION
                   WHEN "1" PERFORM ALTA-PRODUCTO
                   WHEN "2" PERFORM MODIFICAR-PRODUCTO
                   WHEN "3" PERFORM BAJA-PRODUCTO
                   WHEN "4" PERFORM CONSULTAR-PRODUCTO
               END-EVALUATE
           END-PERFORM.

       ABRIR-ARCHIVO.
           OPEN I-O PRODUCTOS
           IF ST-PRODUCTOS = "35"
               OPEN OUTPUT PRODUCTOS
               CLOSE PRODUCTOS
               OPEN I-O PRODUCTOS
           END-IF

           IF ST-PRODUCTOS > "07"
               STRING "ERROR PRODUCTOS: " ST-PRODUCTOS
                   INTO WS-MENSAJE
               DISPLAY WS-MENSAJE
               STOP RUN
           END-IF.

       ALTA-PRODUCTO.
           DISPLAY "Codigo: " LINE 12 COL 10
           ACCEPT PRD-CODIGO LINE 12 COL 20

           READ PRODUCTOS
           IF ST-PRODUCTOS = "00"
               DISPLAY "PRODUCTO YA EXISTE" LINE 14 COL 10
               ACCEPT WS-PAUSA
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Descripcion: " LINE 13 COL 10
           ACCEPT PRD-DESCRIPCION LINE 13 COL 25
           DISPLAY "Precio: " LINE 14 COL 10
           ACCEPT PRD-PRECIO LINE 14 COL 25
           DISPLAY "IVA %: " LINE 15 COL 10
           ACCEPT PRD-IVA LINE 15 COL 25

           MOVE "A" TO PRD-ESTADO
           WRITE PRODUCTO-REG

           DISPLAY "PRODUCTO CREADO" LINE 17 COL 10
           ACCEPT WS-PAUSA.

       MODIFICAR-PRODUCTO.
           DISPLAY "Codigo: " LINE 12 COL 10
           ACCEPT PRD-CODIGO LINE 12 COL 20

           READ PRODUCTOS
           IF ST-PRODUCTOS NOT = "00"
               DISPLAY "NO EXISTE" LINE 14 COL 10
               ACCEPT WS-PAUSA
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Descripcion: " LINE 13 COL 10
           ACCEPT PRD-DESCRIPCION LINE 13 COL 25
           DISPLAY "Precio: " LINE 14 COL 10
           ACCEPT PRD-PRECIO LINE 14 COL 25
           DISPLAY "IVA %: " LINE 15 COL 10
           ACCEPT PRD-IVA LINE 15 COL 25

           REWRITE PRODUCTO-REG

           DISPLAY "PRODUCTO MODIFICADO" LINE 17 COL 10
           ACCEPT WS-PAUSA.

       BAJA-PRODUCTO.
           DISPLAY "Codigo: " LINE 12 COL 10
           ACCEPT PRD-CODIGO LINE 12 COL 20

           READ PRODUCTOS
           IF ST-PRODUCTOS NOT = "00"
               DISPLAY "NO EXISTE" LINE 14 COL 10
               ACCEPT WS-PAUSA
               EXIT PARAGRAPH
           END-IF

           MOVE "I" TO PRD-ESTADO
           REWRITE PRODUCTO-REG

           DISPLAY "PRODUCTO INACTIVO" LINE 16 COL 10
           ACCEPT WS-PAUSA.

       CONSULTAR-PRODUCTO.
           DISPLAY "Codigo: " LINE 12 COL 10
           ACCEPT PRD-CODIGO LINE 12 COL 20

           READ PRODUCTOS
           IF ST-PRODUCTOS = "00"
               DISPLAY "Descripcion: " PRD-DESCRIPCION LINE 14 COL 10
               DISPLAY "Precio: " PRD-PRECIO LINE 15 COL 10
               DISPLAY "IVA: " PRD-IVA LINE 16 COL 10
               DISPLAY "Estado: " PRD-ESTADO LINE 17 COL 10
           ELSE
               DISPLAY "NO EXISTE" LINE 14 COL 10
           END-IF

           ACCEPT WS-PAUSA.

       CERRAR-ARCHIVO.
           CLOSE PRODUCTOS.

       END PROGRAM INVPRO01-pro.
