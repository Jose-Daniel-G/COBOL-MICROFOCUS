       >>SOURCE FORMAT FREE
      *> ******************************************************************
      *> * Author:   JOSE DANIEL GRIJALBA
      *> * Date:     12/23/2025
      *> * Purpose:  LEARN
      *> * Tectonics: cobc
      *> ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVLPRO01.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "producto.sel".

       DATA DIVISION.
       FILE SECTION.
           COPY "producto.fd".

       WORKING-STORAGE SECTION.
           COPY "TECLAS.cpy".
           
       01 WS-UI-CONTROLES.
          05 WS-TITULO-PANTALLA    PIC X(40) VALUE SPACES.
          05 WS-MODULO-PANTALLA    PIC X(26) VALUE SPACES.
          05 WS-PROGRAMA           PIC X(10) VALUE SPACES.

       01  ST-PRODUCTOS    PIC XX.
       01  WS-KEY         PIC 9(4).
       01  WS-PAUSA       PIC X.
       01  RESPUESTA      PIC X     VALUE "S".

       01  WS-FILA        PIC 99.      *> Navegación y control de filas
       01  WS-FILA-INICIO PIC 99 VALUE 5.
       01  WS-FILA-MAX    PIC 99.
       01  WS-PUNTERO     PIC 99 VALUE 5.
       01  WS-INDICE      PIC 99 VALUE 1.

       01  WS-FIN-LISTA       PIC X VALUE "N".
           88 FIN-LISTA          VALUE "S".
           88 NO-FIN-LISTA       VALUE "N".
       01 WS-BUS-DESCRIPCION      PIC X(20).      
        *>--------- --- BUSQUEDA --- -------------
       01 WS-MODO-BUSQUEDA     PIC X VALUE "N".
          88 BUSCANDO          VALUE "S".
          88 NO-BUSCANDO       VALUE "N".           
        *>----------------------------------------
       01  MENSAJE    PIC X(70).      

       01  TABLA-PANTALLA.
          05 REG-PANTALLA OCCURS 20 TIMES.
             10 T-COD     PIC 9(07).
             10 T-DES     PIC X(30).
             10 T-PRE     PIC Z(9).99.
             10 T-IVA     PIC X(01).
             10 T-EST     PIC X(01).
       01 WS-LINEA-PLANO PIC X(200).

       SCREEN SECTION.
       01 PANTALLA-BASE.
           COPY "HEADER.cpy". 
           05 LINE 03 COL 02  VALUE "ID"         BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 15 VALUE "DESCRIPCION" BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 47 VALUE "PRECIO"      BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 69 VALUE "CATEGORIA"   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 04 COL 01  PIC X(80) FROM ALL "_" BACKGROUND-COLOR 1. 

       PROCEDURE DIVISION.
       
       MAIN-LOGIC.

           MOVE "LISTADO INDEXADO DE PRODUCTOS" TO WS-TITULO-PANTALLA           *> 1. Configuras los datos del encabezado
           MOVE "MODO CONSULTA"                 TO WS-MODULO-PANTALLA
           MOVE "VERSION.01"                    TO WS-PROGRAMA

           PERFORM ABRO-ARCHIVO.

           PERFORM UNTIL WS-KEY = KEY-ESC
               DISPLAY PANTALLA-BASE
               PERFORM RECARGAR-LISTADO
               SET NO-FIN-LISTA TO TRUE
               MOVE 0 TO WS-KEY
               
               PERFORM MOSTRAR-REGISTROS
               
               IF WS-FILA-MAX >= WS-FILA-INICIO
                   PERFORM NAVEGACION-BUCLE
               ELSE
                   DISPLAY "NO HAY DATOS - [ESC] SALIR" LINE 12 COL 30
                           WITH REVERSE-VIDEO
                   ACCEPT WS-PAUSA LINE 1 COL 1 WITH NO-ECHO
               END-IF
           END-PERFORM.

           CLOSE PRODUCTOS.
           GOBACK.

       NAVEGACION-BUCLE.
           MOVE 0 TO WS-KEY.
           PERFORM UNTIL WS-KEY = KEY-ESC
               IF WS-FILA-MAX >= WS-FILA-INICIO
                   PERFORM RESALTAR-FILA 
                   ACCEPT WS-PAUSA LINE 1 COL 1 WITH NO-ECHO
                   
                   EVALUATE WS-KEY
                       WHEN KEY-DOWN
                           IF WS-PUNTERO < WS-FILA-MAX
                              PERFORM NORMALIZAR-FILA
                              ADD 1 TO WS-PUNTERO
                              ADD 1 TO WS-INDICE
                           END-IF
                       WHEN KEY-UP
                           IF WS-PUNTERO > WS-FILA-INICIO
                              PERFORM NORMALIZAR-FILA
                              SUBTRACT 1 FROM WS-PUNTERO
                              SUBTRACT 1 FROM WS-INDICE
                           END-IF
                       WHEN KEY-F7  *> BÚSQUEDA POR NOMBRE
                           PERFORM BUSCAR-PRODUCTO
                       WHEN KEY-F8  *> tecla Suprimir/Delete
                           PERFORM ELIMINAR-REGISTRO
                       WHEN KEY-F9  *> tecla F9 (Generar Plano)
                           PERFORM GENERAR-PLANO
                           DISPLAY "Archivo plano 'productos.txt' generado."   
                               LINE 22 COL 20
                           ACCEPT WS-PAUSA LINE 23 COL 55
                       WHEN KEY-F10  *> tecla F10 (Generar CSV)
                           PERFORM GENERAR-CSV
                           DISPLAY "Archivo CSV 'productos.CSV' generado."    
                               LINE 22 COL 20
                           ACCEPT WS-PAUSA LINE 23 COL 55
                       WHEN KEY-ENTER
                           CONTINUE                                          *> Aquí iría tu lógica de EDITAR
                   END-EVALUATE
               ELSE
                   DISPLAY "LISTA VACIA - PRESIONE [ESC] PARA SALIR" 
                           LINE 12 COL 25 WITH REVERSE-VIDEO
                   ACCEPT WS-PAUSA LINE 1 COL 1 WITH NO-ECHO
               END-IF
           END-PERFORM.

       MOSTRAR-REGISTROS.
           SET NO-FIN-LISTA TO TRUE.
           
           IF BUSCANDO                                                     *> Si estamos en modo búsqueda, usar la clave alternativa
               MOVE WS-BUS-DESCRIPCION TO PRD-DESCRIPCION            
                   START PRODUCTOS KEY IS NOT LESS THAN PRD-DESCRIPCION
                   INVALID KEY SET FIN-LISTA TO TRUE
               END-START
           ELSE
               MOVE ZERO TO PRD-CODIGO                                             *> Modo normal: mostrar todos desde el inicio
               START PRODUCTOS KEY IS NOT LESS THAN PRD-CODIGO
                   INVALID KEY SET FIN-LISTA TO TRUE
               END-START
           END-IF.

           MOVE WS-FILA-INICIO TO WS-FILA. 
           MOVE 1 TO WS-INDICE.
           
           PERFORM UNTIL FIN-LISTA OR WS-FILA > 22
               READ PRODUCTOS NEXT RECORD
                   AT END SET FIN-LISTA TO TRUE
                   NOT AT END
                       IF BUSCANDO                                  *> Si estamos buscando, filtrar por coincidencia parcial
                           IF PRD-DESCRIPCION(1:FUNCTION LENGTH(
                              FUNCTION TRIM(WS-BUS-DESCRIPCION))) 
                              = FUNCTION TRIM(WS-BUS-DESCRIPCION)
                               PERFORM AGREGAR-A-TABLA
                           END-IF
                       ELSE
                           PERFORM AGREGAR-A-TABLA
                       END-IF
               END-READ
           END-PERFORM.
           
           MOVE WS-FILA TO WS-FILA-MAX.
           SUBTRACT 1 FROM WS-FILA-MAX.
           MOVE 1 TO WS-INDICE.
           MOVE WS-FILA-INICIO TO WS-PUNTERO.

       AGREGAR-A-TABLA.
           MOVE PRD-CODIGO         TO T-COD(WS-INDICE)
           MOVE PRD-DESCRIPCION    TO T-DES(WS-INDICE)
           MOVE PRD-PRECIO         TO T-PRE(WS-INDICE)
           MOVE PRD-ESTADO         TO T-EST(WS-INDICE)
           PERFORM NORMALIZAR-PINTADO
           ADD 1 TO WS-FILA
           ADD 1 TO WS-INDICE.

       NORMALIZAR-PINTADO.
           DISPLAY T-COD(WS-INDICE)  LINE WS-FILA COL 2  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-DES(WS-INDICE) LINE WS-FILA COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-PRE(WS-INDICE) LINE WS-FILA COL 47 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-EST(WS-INDICE) LINE WS-FILA COL 78 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

       RESALTAR-FILA.
           DISPLAY ALL " " LINE WS-PUNTERO COL 1 SIZE 80 BACKGROUND-COLOR 7.
           DISPLAY T-COD(WS-INDICE)  LINE WS-PUNTERO COL 2  BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-DES(WS-INDICE) LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-PRE(WS-INDICE) LINE WS-PUNTERO COL 47 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-EST(WS-INDICE) LINE WS-PUNTERO COL 78 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.

       NORMALIZAR-FILA.
           DISPLAY ALL " " LINE WS-PUNTERO COL 1 SIZE 80 BACKGROUND-COLOR 1.
           DISPLAY T-COD(WS-INDICE) LINE WS-PUNTERO COL 02 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-DES(WS-INDICE) LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-PRE(WS-INDICE) LINE WS-PUNTERO COL 47 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-EST(WS-INDICE) LINE WS-PUNTERO COL 78 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

       BUSCAR-PRODUCTO.
           DISPLAY ALL " " LINE 22 COL 1 SIZE 80 BACKGROUND-COLOR 1.    *> Limpiar línea de búsqueda
           
           DISPLAY "Ingrese nombre a buscar: " LINE 22 COL 20 
                   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7
           
           MOVE SPACES TO WS-BUS-DESCRIPCION
           ACCEPT WS-BUS-DESCRIPCION LINE 22 COL 45 
                  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7
           
           IF WS-BUS-DESCRIPCION NOT = SPACES                              *> Si ingresó algo, activar modo búsqueda
               SET BUSCANDO TO TRUE
               DISPLAY "MODO BUSQUEDA: " LINE 2 COL 2 
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               DISPLAY WS-BUS-DESCRIPCION LINE 2 COL 18
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           ELSE
               SET NO-BUSCANDO TO TRUE                                  *> Si no ingresó nada, desactivar búsqueda
               DISPLAY "MODO SELECCION" LINE 2 COL 2 
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF
           
           PERFORM RECARGAR-LISTADO                                     *> Recargar el listado con el filtro
           MOVE 0 TO WS-KEY.

       ELIMINAR-REGISTRO. 
               DISPLAY "Desea ELIMINAR el producto [S/N]? " LINE 22 
                       COL 20 WITH BACKGROUND-COLOR 4
               ACCEPT RESPUESTA LINE 22 COL 53
               
               IF FUNCTION UPPER-CASE(RESPUESTA) = "S"
                   MOVE T-COD(WS-INDICE) TO PRD-CODIGO
                   READ PRODUCTOS
                       KEY IS PRD-CODIGO
                       INVALID KEY
                           DISPLAY "REGISTRO NO ENCONTRADO" 
                           LINE 23 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                       NOT INVALID KEY
                           DELETE PRODUCTOS RECORD
                              INVALID KEY
                                DISPLAY "ERROR AL ELIMINAR" LINE 
                                23 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                              NOT INVALID KEY
                                   PERFORM RECARGAR-LISTADO
                                   MOVE 0 TO WS-KEY
                           END-DELETE
                   END-READ
               END-IF.   
       
       ABRO-ARCHIVO.
           OPEN I-O PRODUCTOS.
           IF ST-PRODUCTOS = "35" 
               OPEN OUTPUT PRODUCTOS 
               CLOSE PRODUCTOS 
               OPEN I-O PRODUCTOS.

           IF ST-PRODUCTOS > "07"                                 
             STRING "Error al abrir Clientes " ST-PRODUCTOS DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20 
              ACCEPT WS-PAUSA LINE 23 COL 55
              GOBACK
           END-IF.      
           
       LIMPIAR-LISTADO.
           PERFORM VARYING WS-FILA FROM WS-FILA-INICIO BY 1
               UNTIL WS-FILA > 22
               DISPLAY ALL " " LINE WS-FILA COL 1 SIZE 80 BACKGROUND-COLOR 1
           END-PERFORM.
       
       RECARGAR-LISTADO.
           PERFORM LIMPIAR-LISTADO
           MOVE "N" TO WS-FIN-LISTA
           MOVE WS-FILA-INICIO TO WS-PUNTERO
           MOVE 1 TO WS-INDICE
           PERFORM MOSTRAR-REGISTROS.
       
       GENERAR-PLANO.
           OPEN OUTPUT PRODUCTOS-PLANO
           SET NO-FIN-LISTA TO TRUE

           MOVE ZERO TO PRD-CODIGO
           START PRODUCTOS KEY IS NOT LESS THAN PRD-CODIGO
               INVALID KEY
                   CLOSE PRODUCTOS-PLANO
                   EXIT PARAGRAPH
           END-START
       
           PERFORM UNTIL FIN-LISTA
               READ PRODUCTOS NEXT RECORD
                   AT END
                       SET FIN-LISTA TO TRUE
                   NOT AT END
                       STRING
                           PRD-CODIGO     DELIMITED BY SIZE
                           " | "                        
                           PRD-DESCRIPCION     DELIMITED BY SIZE
                           " | "
                           PRD-PRECIO     DELIMITED BY SIZE
                           " | "    
                           PRD-IVA     DELIMITED BY SIZE
                           " | "
                           PRD-ESTADO DELIMITED BY SIZE
                           INTO WS-LINEA-PLANO
       
                       WRITE REG-PROD-PLANO FROM WS-LINEA-PLANO
               END-READ
           END-PERFORM
           CLOSE PRODUCTOS-PLANO
           SET NO-FIN-LISTA TO TRUE. 
       GENERAR-CSV.         
           SET NO-FIN-LISTA TO TRUE
           OPEN OUTPUT PRODUCTOS-CSV
          
           MOVE ZERO TO PRD-CODIGO
           START PRODUCTOS KEY IS NOT LESS THAN PRD-CODIGO
               INVALID KEY
                   CLOSE PRODUCTOS-CSV
                   EXIT PARAGRAPH
           NOT INVALID KEY
           MOVE "ID;CODIGO;DESCRIPCION;PRECIO;IVA;ESTADO" TO REG-PROD-CSV
           WRITE REG-PROD-CSV
           PERFORM UNTIL FIN-LISTA
               READ PRODUCTOS NEXT RECORD
                   AT END
                       SET FIN-LISTA TO TRUE
                   NOT AT END
                       INITIALIZE REG-PROD-CSV
                       STRING
                           PRD-CODIGO DELIMITED BY SIZE
                           ";"                        
                           PRD-DESCRIPCION DELIMITED BY SIZE
                           ";"
                           PRD-PRECIO DELIMITED BY SIZE
                           ";"
                           PRD-IVA DELIMITED BY SIZE
                           ";"
                           PRD-ESTADO DELIMITED BY SIZE
                           INTO REG-PROD-CSV
       
                       WRITE REG-PROD-CSV
               END-READ
           END-PERFORM
           END-START
           CLOSE PRODUCTOS-CSV
           SET NO-FIN-LISTA TO TRUE.


