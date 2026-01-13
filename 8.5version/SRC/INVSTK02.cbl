       >>SOURCE FORMAT FREE
      *> ******************************************************************
      *> * Author:   JOSE DANIEL GRIJALBA
      *> * Date:     01/08/2026
      *> * Purpose:  LEARN
      *> * Tectonics: cobc
      *> ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVSTK02.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "stock.sel".
           COPY "producto.sel".

       DATA DIVISION.
       FILE SECTION.
           COPY "stock.fd".
           COPY "producto.fd".

       WORKING-STORAGE SECTION.
           COPY "TECLAS.cpy".
           COPY "LIST-NAV.cpy".
           
       01 WS-UI-CONTROLES.
          05 WS-TITULO-PANTALLA    PIC X(40) VALUE SPACES.
          05 WS-MODULO-PANTALLA    PIC X(26) VALUE SPACES.
          05 WS-PROGRAMA           PIC X(10) VALUE SPACES.

       01  ST-STOCK    PIC XX.
       01  ST-PRODUCTOS    PIC XX.
       01  WS-KEY         PIC 9(4).
       01  WS-PAUSA       PIC X.
       01  RESPUESTA      PIC X     VALUE "S".

 
       01 WS-BUSCA-CODIGO      PIC X(20).      
        *>--------- --- BUSQUEDA --- -------------
       01 WS-MODO-BUSQUEDA     PIC X VALUE "N".
          88 BUSCANDO          VALUE "S".
          88 NO-BUSCANDO       VALUE "N".           
       01  MENSAJE    PIC X(70).       
       *>----------------------------------------

       01  TABLA-PANTALLA.
          05 REG-PANTALLA OCCURS 20 TIMES.
             10 T-FECHA-ACT      PIC 9(08).
             10 T-CODIGO         PIC X(10).
             10 T-BODEGA         PIC X(04).
             10 T-MAX            PIC 9(05).
             10 T-MIN            PIC 9(05).
             10 T-CANT           PIC 9(09).

       01  WS-HISTORIAL-PAGINAS.
           05 WS-COD-INICIO    PIC X(10) OCCURS 100 TIMES.

       SCREEN SECTION.
       01 PANTALLA-BASE.
           COPY "HEADER.cpy". 
           05 LINE 02 COL 70 VALUE "PAG:".
           05 LINE 02 COL 75 PIC ZZ9 FROM WS-PAG-ACTUAL.
           05 LINE 03 COL 02  VALUE "FECHA ACT"         BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 15 VALUE "CODIGO"      BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 35 VALUE "BODEGA"   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 50 VALUE "MAXIMO"   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 58 VALUE "MINIMO"   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 69 VALUE "CANTIDAD"   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 04 COL 01  PIC X(80) FROM ALL "_" BACKGROUND-COLOR 1. 

       PROCEDURE DIVISION.
       
       MAIN-LOGIC.

           MOVE "LISTADO INDEXADO DE STOCK" TO WS-TITULO-PANTALLA           *> 1. Configuras los datos del encabezado
           MOVE "MODO CONSULTA"                TO WS-MODULO-PANTALLA
           MOVE "INVSTK02" TO WS-PROGRAMA

           PERFORM ABRO-ARCHIVO.
           DISPLAY PANTALLA-BASE
           SET NO-BUSCANDO TO TRUE.
           PERFORM INICIALIZAR-LISTADO

           PERFORM UNTIL WS-KEY = KEY-ESC 
               IF WS-FILA-MAX >= WS-FILA-INICIO
                   PERFORM MOSTRAR-PANTALLA-ACTUAL
                   PERFORM NAVEGACION-BUCLE 
               ELSE
                   DISPLAY "NO HAY DATOS - [ESC] SALIR" LINE 12 COL 30
                           WITH REVERSE-VIDEO
                   ACCEPT WS-PAUSA LINE 1 COL 1 WITH NO-ECHO
               END-IF
           END-PERFORM.

           CLOSE STOCK.
           GOBACK.

       NAVEGACION-BUCLE.
           MOVE 0 TO WS-KEY.
           PERFORM UNTIL WS-KEY = KEY-ESC OR WS-KEY = KEY-F7
               IF WS-FILA-MAX >= WS-FILA-INICIO
                   PERFORM RESALTAR-FILA 
                   ACCEPT WS-PAUSA LINE 1 COL 1 WITH NO-ECHO
                   
                   EVALUATE WS-KEY
                   WHEN KEY-DOWN
                       IF WS-PUNTERO < WS-FILA-MAX
                           PERFORM NORMALIZAR-FILA
                           ADD 1 TO WS-PUNTERO
                           ADD 1 TO WS-INDICE
                       ELSE
                           IF NO-FIN-LISTA
                               *> 1. Tomamos el último código mostrado para saltarlo
                               MOVE T-CODIGO(20) TO STK-CODIGO
                               START STOCK KEY IS GREATER THAN STK-CODIGO
                               READ STOCK NEXT RECORD
                                  AT END SET FIN-LISTA TO TRUE
                                  NOT AT END
                                      ADD 1 TO WS-PAG-ACTUAL
                                      *> 2. Guardamos el código donde empieza la NUEVA página
                                      MOVE STK-CODIGO TO WS-COD-INICIO(WS-PAG-ACTUAL)
                                      
                                      *> 3. Reposicionamos y recargamos
                                      START STOCK KEY IS NOT LESS THAN STK-CODIGO
                                      PERFORM RECARGAR-PAGINA
                                      DISPLAY PANTALLA-BASE
                                      PERFORM MOSTRAR-PANTALLA-ACTUAL
                                      MOVE WS-FILA-INICIO TO WS-PUNTERO
                                      MOVE 1 TO WS-INDICE
                               END-READ
                           END-IF
                       END-IF
               WHEN KEY-UP
                   IF WS-PUNTERO > WS-FILA-INICIO
                       PERFORM NORMALIZAR-FILA
                       SUBTRACT 1 FROM WS-PUNTERO
                       SUBTRACT 1 FROM WS-INDICE
                   ELSE
                       IF WS-PAG-ACTUAL > 1
                           SUBTRACT 1 FROM WS-PAG-ACTUAL
                           *> Recuperamos el código que dio inicio a esta página anteriormente
                           MOVE WS-COD-INICIO(WS-PAG-ACTUAL) TO STK-CODIGO
                           
                           START STOCK KEY IS NOT LESS THAN STK-CODIGO
                           SET NO-FIN-LISTA TO TRUE
                           PERFORM RECARGAR-PAGINA 
                           DISPLAY PANTALLA-BASE
                           PERFORM MOSTRAR-PANTALLA-ACTUAL
                           
                           MOVE WS-FILA-MAX TO WS-PUNTERO
                           COMPUTE WS-INDICE = WS-FILA-MAX - WS-FILA-INICIO + 1
                       END-IF
                   END-IF
               WHEN KEY-F7
                        PERFORM BUSCAR-STOCK
                        DISPLAY PANTALLA-BASE
                        PERFORM MOSTRAR-PANTALLA-ACTUAL
                     WHEN KEY-F8  *> tecla Suprimir/Delete
                         PERFORM ELIMINAR-REGISTRO
                         DISPLAY PANTALLA-BASE
                         PERFORM MOSTRAR-PANTALLA-ACTUAL
                     WHEN KEY-F9  *> tecla F9 (Generar Plano)
                         PERFORM GENERAR-PLANO
                         DISPLAY "Archivo plano 'stocks.txt' generado." LINE 22 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                     WHEN KEY-F10  *> tecla F10 (Generar CSV)
                         PERFORM GENERAR-CSV
                         DISPLAY "Archivo CSV 'stocks.CSV' generado."   LINE 22 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                     WHEN KEY-ENTER
                         CONTINUE 
                 END-EVALUATE
             ELSE
                 *> Si no hay registros, forzamos esperar F7 o ESC
                 DISPLAY "No hay registros."   LINE 22 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                 ACCEPT WS-PAUSA LINE 1 COL 1 WITH NO-ECHO
                 PERFORM INICIALIZAR-LISTADO
                 IF WS-KEY = KEY-F7 PERFORM BUSCAR-STOCK END-IF
             END-IF
         END-PERFORM.

 
       AGREGAR-A-TABLA.
           MOVE STK-FECHA-ACT  TO T-FECHA-ACT(WS-INDICE)
           MOVE STK-CODIGO     TO T-CODIGO(WS-INDICE)
           MOVE STK-BODEGA     TO T-BODEGA(WS-INDICE)
           MOVE STK-MAXIMO     TO T-MAX(WS-INDICE)   
           MOVE STK-MINIMO     TO T-MIN(WS-INDICE)   
           MOVE STK-CANTIDAD   TO T-CANT(WS-INDICE)
           ADD 1 TO WS-INDICE.

       MOSTRAR-PANTALLA-ACTUAL.
           PERFORM VARYING WS-INDICE FROM 1 BY 1 
               UNTIL WS-INDICE > 20 *>(WS-FILA-MAX - WS-FILA-INICIO + 1)
               
               IF T-FECHA-ACT(WS-INDICE) > ZERO
                   COMPUTE WS-FILA = WS-FILA-INICIO + WS-INDICE - 1
                   PERFORM NORMALIZAR-PINTADO
               END-IF
           END-PERFORM.
           MOVE 1 TO WS-INDICE.
       NORMALIZAR-PINTADO.
           DISPLAY T-FECHA-ACT(WS-INDICE) LINE WS-FILA COL 02 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CODIGO(WS-INDICE)    LINE WS-FILA COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-BODEGA(WS-INDICE)    LINE WS-FILA COL 35 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-MAX(WS-INDICE)       LINE WS-FILA COL 50 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-MIN(WS-INDICE)       LINE WS-FILA COL 67 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CANT(WS-INDICE)      LINE WS-FILA COL 69 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

       RESALTAR-FILA.
           DISPLAY ALL " " LINE WS-PUNTERO COL 1 SIZE 80 BACKGROUND-COLOR 7.
           DISPLAY T-FECHA-ACT(WS-INDICE) LINE WS-PUNTERO COL 02 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-CODIGO(WS-INDICE)    LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-BODEGA(WS-INDICE)    LINE WS-PUNTERO COL 35 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-MAX(WS-INDICE)       LINE WS-PUNTERO COL 50 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-MIN(WS-INDICE)       LINE WS-PUNTERO COL 67 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-CANT(WS-INDICE)      LINE WS-PUNTERO COL 69 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.

       NORMALIZAR-FILA.
           DISPLAY ALL " " LINE WS-PUNTERO COL 1 SIZE 80 BACKGROUND-COLOR 1.
           DISPLAY T-FECHA-ACT(WS-INDICE) LINE WS-PUNTERO COL 02 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CODIGO(WS-INDICE)    LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-BODEGA(WS-INDICE)    LINE WS-PUNTERO COL 35 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-MAX(WS-INDICE)       LINE WS-PUNTERO COL 50 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-MIN(WS-INDICE)       LINE WS-PUNTERO COL 67 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CANT(WS-INDICE)      LINE WS-PUNTERO COL 69 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

       BUSCAR-STOCK.
           DISPLAY ALL " " LINE 22 COL 1 SIZE 80 BACKGROUND-COLOR 1.    *> Limpiar línea de búsqueda
           
           DISPLAY "Ingrese nombre a buscar: " LINE 22 COL 20 
                   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7
           
           MOVE SPACES TO WS-BUSCA-CODIGO
           ACCEPT WS-BUSCA-CODIGO LINE 22 COL 45 
                  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7
           
           IF WS-BUSCA-CODIGO NOT = SPACES                              *> Si ingresó algo, activar modo búsqueda
               SET BUSCANDO TO TRUE
           ELSE
               SET NO-BUSCANDO TO TRUE 
           END-IF 

           PERFORM INICIALIZAR-LISTADO                                     *> Recargar el listado con el filtro
           MOVE 0 TO WS-KEY.

       ELIMINAR-REGISTRO. 
               DISPLAY "Desea ELIMINAR el stock [S/N]? " LINE 22 
                       COL 20 WITH BACKGROUND-COLOR 4
               ACCEPT RESPUESTA LINE 22 COL 53
               
               IF FUNCTION UPPER-CASE(RESPUESTA) = "S"
                   MOVE T-FECHA-ACT(WS-INDICE) TO STK-FECHA-ACT
                   READ STOCK
                       KEY IS STK-FECHA-ACT
                       INVALID KEY
                           DISPLAY "REGISTRO NO ENCONTRADO" 
                           LINE 23 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                       NOT INVALID KEY
                           DELETE STOCK RECORD
                              INVALID KEY
                                DISPLAY "ERROR AL ELIMINAR" LINE 
                                23 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                              NOT INVALID KEY
                                   PERFORM INICIALIZAR-LISTADO
                                   MOVE 0 TO WS-KEY
                           END-DELETE
                   END-READ
               END-IF.   
       
       ABRO-ARCHIVO.
           OPEN I-O STOCK.
           IF ST-STOCK = "35" 
               OPEN OUTPUT STOCK 
               CLOSE STOCK 
               OPEN I-O STOCK.

           IF ST-STOCK > "07"                                 
             STRING "Error al abrir Clientes " ST-STOCK DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20 
              ACCEPT WS-PAUSA LINE 23 COL 55
              GOBACK
           END-IF.      
           
       LIMPIAR-LISTADO.
           PERFORM VARYING WS-FILA FROM WS-FILA-INICIO BY 1 UNTIL WS-FILA > 24
               DISPLAY ALL " " LINE WS-FILA COL 1 SIZE 80 BACKGROUND-COLOR 1
           END-PERFORM.
       
       INICIALIZAR-LISTADO.
           MOVE 1 TO WS-PAG-ACTUAL.
           IF BUSCANDO
               MOVE WS-BUSCA-CODIGO TO STK-CODIGO
           ELSE
               MOVE SPACES TO STK-CODIGO
           END-IF.
           
           START STOCK KEY IS NOT LESS THAN STK-CODIGO
              INVALID KEY SET FIN-LISTA TO TRUE
              NOT INVALID KEY
                  READ STOCK NEXT RECORD *> Leemos el primero real
                  MOVE STK-CODIGO TO WS-COD-INICIO(1)
                  START STOCK KEY IS NOT LESS THAN STK-CODIGO *> Volvemos a apuntar a él
           END-START.
           PERFORM RECARGAR-PAGINA.
       RECARGAR-PAGINA.
           PERFORM LIMPIAR-LISTADO.
           INITIALIZE TABLA-PANTALLA.
           SET NO-FIN-LISTA TO TRUE.
           MOVE 1 TO WS-INDICE.
           SET ES-PRIMER-REGISTRO TO TRUE.
           
           *> Lee hasta llenar 20 registros o fin de archivo
           PERFORM UNTIL WS-INDICE > 20 OR FIN-LISTA
               IF ES-PRIMER-REGISTRO
                   *> Primera lectura: leer el registro posicionado por START
                   READ STOCK 
                       AT END SET FIN-LISTA TO TRUE
                       NOT AT END 
                           IF BUSCANDO
                               IF STK-CODIGO(1:FUNCTION LENGTH(FUNCTION TRIM(WS-BUSCA-CODIGO))) 
                                  = FUNCTION TRIM(WS-BUSCA-CODIGO)
                                   PERFORM AGREGAR-A-TABLA
                               END-IF
                           ELSE
                               PERFORM AGREGAR-A-TABLA
                           END-IF
                   END-READ
                   SET NO-ES-PRIMER-REGISTRO TO TRUE
               ELSE
                   *> Lecturas subsecuentes: leer el siguiente registro
                   READ STOCK NEXT RECORD
                       AT END SET FIN-LISTA TO TRUE
                       NOT AT END 
                           IF BUSCANDO
                               IF STK-CODIGO(1:FUNCTION LENGTH(FUNCTION TRIM(WS-BUSCA-CODIGO))) 
                                  = FUNCTION TRIM(WS-BUSCA-CODIGO)
                                   PERFORM AGREGAR-A-TABLA
                               END-IF
                           ELSE
                               PERFORM AGREGAR-A-TABLA
                           END-IF
                   END-READ
               END-IF
           END-PERFORM.

           IF WS-INDICE > 1
               COMPUTE WS-FILA-MAX = WS-FILA-INICIO + WS-INDICE - 2 
           ELSE
               MOVE 0 TO WS-FILA-MAX
               DISPLAY "SIN COINCIDENCIAS" LINE 12 COL 30 WITH REVERSE-VIDEO
           END-IF.
       GENERAR-PLANO.
           OPEN OUTPUT STOCK-PLANO
           SET NO-FIN-LISTA TO TRUE

           MOVE ZERO TO STK-CODIGO
           START STOCK KEY IS NOT LESS THAN STK-CODIGO
               INVALID KEY
                   CLOSE STOCK-PLANO
                   EXIT PARAGRAPH
           END-START
       
           PERFORM UNTIL FIN-LISTA
               READ STOCK NEXT RECORD
                   AT END
                       SET FIN-LISTA TO TRUE
                   NOT AT END
                       STRING
                           STK-FECHA-ACT        DELIMITED BY SIZE
                           " | " 
                           STK-CODIGO    DELIMITED BY SIZE
                           " | "
                           STK-BODEGA    DELIMITED BY SIZE
                           " | "
                           STK-MAXIMO    DELIMITED BY SIZE
                           " | "
                           STK-MINIMO    DELIMITED BY SIZE
                           " | "
                           STK-CANTIDAD DELIMITED BY SIZE
                           INTO WS-LINEA-PLANO
       
                       WRITE REG-STOCK-PLANO FROM WS-LINEA-PLANO
               END-READ
           END-PERFORM
           CLOSE STOCK-PLANO
           SET NO-FIN-LISTA TO TRUE. 
       GENERAR-CSV.         
           SET NO-FIN-LISTA TO TRUE
           OPEN OUTPUT STOCK-CSV
          
           MOVE ZERO TO STK-CODIGO
           START STOCK KEY IS NOT LESS THAN STK-CODIGO
               INVALID KEY
                   CLOSE STOCK-CSV
                   EXIT PARAGRAPH
           NOT INVALID KEY
           MOVE "ID;NOMBRE;DIRECCION;CATEGORIA" TO REG-STOCK-CSV
           WRITE REG-STOCK-CSV
           PERFORM UNTIL FIN-LISTA
               READ STOCK NEXT RECORD
                   AT END
                       SET FIN-LISTA TO TRUE
                   NOT AT END
                       INITIALIZE REG-STOCK-CSV
                       STRING
                           STK-FECHA-ACT        DELIMITED BY SIZE
                           ";"
                           STK-CODIGO    DELIMITED BY SIZE
                           ";"
                           STK-BODEGA    DELIMITED BY SIZE
                           ";"
                           STK-CANTIDAD DELIMITED BY SIZE
                           INTO REG-STOCK-CSV
       
                       WRITE REG-STOCK-CSV
               END-READ
           END-PERFORM
           END-START
           CLOSE STOCK-CSV
           SET NO-FIN-LISTA TO TRUE.
           
