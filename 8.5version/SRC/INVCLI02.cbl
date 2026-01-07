       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. LISTADO.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           COPY "cliente.sel".

       DATA DIVISION.
       FILE SECTION.
           COPY "cliente.fd".

       WORKING-STORAGE SECTION.
           COPY "TECLAS.cpy".
           
       01 WS-UI-CONTROLES.
          05 WS-TITULO-PANTALLA    PIC X(40) VALUE SPACES.
          05 WS-MODULO-PANTALLA    PIC X(26) VALUE SPACES.
          05 WS-PROGRAMA           PIC X(10) VALUE SPACES.

       01  ST-CLIENTES    PIC XX.
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
       01 WS-BUSCA-NOMBRE      PIC X(20).       *>--------- --- BUSQUEDA --- -------------
       01 WS-MODO-BUSQUEDA     PIC X VALUE "N".
          88 BUSCANDO          VALUE "S".
          88 NO-BUSCANDO       VALUE "N".           
       01  MENSAJE    PIC X(70).       *>----------------------------------------

       01  TABLA-PANTALLA.
          05 REG-PANTALLA OCCURS 20 TIMES.
             10 T-ID      PIC 9(07).
             10 T-NOM     PIC X(30).
             10 T-DIR     PIC X(30).
             10 T-CAT     PIC X(01).
       01 WS-LINEA-PLANO PIC X(200).

       SCREEN SECTION.
       01 PANTALLA-BASE.
           COPY "HEADER.cpy". 
           05 LINE 03 COL 02  VALUE "ID"         BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 15 VALUE "NOMBRE"      BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 47 VALUE "DIRECCION"   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 69 VALUE "CATEGORIA"   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 04 COL 01  PIC X(80) FROM ALL "_" BACKGROUND-COLOR 1. 

       PROCEDURE DIVISION.
       
       MAIN-LOGIC.

           MOVE "LISTADO INDEXADO DE CLIENTES" TO WS-TITULO-PANTALLA           *> 1. Configuras los datos del encabezado
           MOVE "MODO CONSULTA"                TO WS-MODULO-PANTALLA
           MOVE "VERSION.01" TO WS-PROGRAMA

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

           CLOSE CLIENTES.
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
                           PERFORM BUSCAR-CLIENTE
                       WHEN KEY-F8  *> tecla Suprimir/Delete
                           PERFORM ELIMINAR-REGISTRO
                       WHEN KEY-F9  *> tecla F9 (Generar Plano)
                           PERFORM GENERAR-PLANO
                           DISPLAY "Archivo plano 'clientes.txt' generado."   
                               LINE 22 COL 20
                           ACCEPT WS-PAUSA LINE 23 COL 55
                       WHEN KEY-F10  *> tecla F10 (Generar CSV)
                           PERFORM GENERAR-CSV
                           DISPLAY "Archivo CSV 'clientes.CSV' generado."    
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
           
           IF BUSCANDO                                                         *> Si estamos en modo búsqueda, usar la clave alternativa
               MOVE WS-BUSCA-NOMBRE TO CLI-NOMBRE
               START CLIENTES KEY IS NOT LESS THAN CLI-NOMBRE
                   INVALID KEY SET FIN-LISTA TO TRUE
               END-START
           ELSE
               MOVE ZERO TO CLI-ID                                             *> Modo normal: mostrar todos desde el inicio
               START CLIENTES KEY IS NOT LESS THAN CLI-ID
                   INVALID KEY SET FIN-LISTA TO TRUE
               END-START
           END-IF.

           MOVE WS-FILA-INICIO TO WS-FILA. 
           MOVE 1 TO WS-INDICE.
           
           PERFORM UNTIL FIN-LISTA OR WS-FILA > 22
               READ CLIENTES NEXT RECORD
                   AT END SET FIN-LISTA TO TRUE
                   NOT AT END
                       IF BUSCANDO                                      *> Si estamos buscando, filtrar por coincidencia parcial
                           IF CLI-NOMBRE(1:FUNCTION LENGTH(
                              FUNCTION TRIM(WS-BUSCA-NOMBRE))) 
                              = FUNCTION TRIM(WS-BUSCA-NOMBRE)
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
           MOVE CLI-ID        TO T-ID(WS-INDICE)
           MOVE CLI-NOMBRE    TO T-NOM(WS-INDICE)
           MOVE CLI-DIRECCION TO T-DIR(WS-INDICE)
           MOVE CLI-CATEGORIA TO T-CAT(WS-INDICE)
           PERFORM NORMALIZAR-PINTADO
           ADD 1 TO WS-FILA
           ADD 1 TO WS-INDICE.

       NORMALIZAR-PINTADO.
           DISPLAY T-ID(WS-INDICE)  LINE WS-FILA COL 2  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-NOM(WS-INDICE) LINE WS-FILA COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-DIR(WS-INDICE) LINE WS-FILA COL 47 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CAT(WS-INDICE) LINE WS-FILA COL 78 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

       RESALTAR-FILA.
           DISPLAY ALL " " LINE WS-PUNTERO COL 1 SIZE 80 BACKGROUND-COLOR 7.
           DISPLAY T-ID(WS-INDICE)  LINE WS-PUNTERO COL 2  BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-NOM(WS-INDICE) LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-DIR(WS-INDICE) LINE WS-PUNTERO COL 47 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-CAT(WS-INDICE) LINE WS-PUNTERO COL 78 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.

       NORMALIZAR-FILA.
           DISPLAY ALL " " LINE WS-PUNTERO COL 1 SIZE 80 BACKGROUND-COLOR 1.
           DISPLAY T-ID(WS-INDICE)  LINE WS-PUNTERO COL 2  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-NOM(WS-INDICE) LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-DIR(WS-INDICE) LINE WS-PUNTERO COL 47 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CAT(WS-INDICE) LINE WS-PUNTERO COL 78 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

       BUSCAR-CLIENTE.
           DISPLAY ALL " " LINE 22 COL 1 SIZE 80 BACKGROUND-COLOR 1.    *> Limpiar línea de búsqueda
           
           DISPLAY "Ingrese nombre a buscar: " LINE 22 COL 20 
                   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7
           
           MOVE SPACES TO WS-BUSCA-NOMBRE
           ACCEPT WS-BUSCA-NOMBRE LINE 22 COL 45 
                  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7
           
           IF WS-BUSCA-NOMBRE NOT = SPACES                              *> Si ingresó algo, activar modo búsqueda
               SET BUSCANDO TO TRUE
               DISPLAY "MODO BUSQUEDA: " LINE 2 COL 2 
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
               DISPLAY WS-BUSCA-NOMBRE LINE 2 COL 18
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           ELSE
               SET NO-BUSCANDO TO TRUE                                  *> Si no ingresó nada, desactivar búsqueda
               DISPLAY "MODO SELECCION" LINE 2 COL 2 
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF
           
           PERFORM RECARGAR-LISTADO                                     *> Recargar el listado con el filtro
           MOVE 0 TO WS-KEY.

       ELIMINAR-REGISTRO. 
               DISPLAY "Desea ELIMINAR el cliente [S/N]? " LINE 22 
                       COL 20 WITH BACKGROUND-COLOR 4
               ACCEPT RESPUESTA LINE 22 COL 53
               
               IF FUNCTION UPPER-CASE(RESPUESTA) = "S"
                   MOVE T-ID(WS-INDICE) TO CLI-ID
                   READ CLIENTES
                       KEY IS CLI-ID
                       INVALID KEY
                           DISPLAY "REGISTRO NO ENCONTRADO" 
                           LINE 23 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                       NOT INVALID KEY
                           DELETE CLIENTES RECORD
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
           OPEN I-O CLIENTES.
           IF ST-CLIENTES = "35" 
               OPEN OUTPUT CLIENTES 
               CLOSE CLIENTES 
               OPEN I-O CLIENTES.

           IF ST-CLIENTES > "07"                                 
             STRING "Error al abrir Clientes " ST-CLIENTES DELIMITED BY SIZE
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
           OPEN OUTPUT CLIENTES-PLANO
           SET NO-FIN-LISTA TO TRUE

           MOVE ZERO TO CLI-ID
           START CLIENTES KEY IS NOT LESS THAN CLI-ID
               INVALID KEY
                   CLOSE CLIENTES-PLANO
                   EXIT PARAGRAPH
           END-START
       
           PERFORM UNTIL FIN-LISTA
               READ CLIENTES NEXT RECORD
                   AT END
                       SET FIN-LISTA TO TRUE
                   NOT AT END
                       STRING
                           CLI-ID        DELIMITED BY SIZE
                           " | " 
                           CLI-NOMBRE    DELIMITED BY SIZE
                           " | "
                           CLI-DIRECCION DELIMITED BY SIZE
                           " | "
                           CLI-CATEGORIA DELIMITED BY SIZE
                           INTO WS-LINEA-PLANO
       
                       WRITE REG-PLANO FROM WS-LINEA-PLANO
               END-READ
           END-PERFORM
           CLOSE CLIENTES-PLANO
           SET NO-FIN-LISTA TO TRUE.
*> 
       GENERAR-CSV.         
           SET NO-FIN-LISTA TO TRUE
           OPEN OUTPUT CLIENTES-CSV
          
           MOVE ZERO TO CLI-ID
           START CLIENTES KEY IS NOT LESS THAN CLI-ID
               INVALID KEY
                   CLOSE CLIENTES-CSV
                   EXIT PARAGRAPH
           NOT INVALID KEY
           MOVE "ID;NOMBRE;DIRECCION;CATEGORIA" TO REG-CSV
           WRITE REG-CSV
           PERFORM UNTIL FIN-LISTA
               READ CLIENTES NEXT RECORD
                   AT END
                       SET FIN-LISTA TO TRUE
                   NOT AT END
                       INITIALIZE REG-CSV
                       STRING
                           CLI-ID        DELIMITED BY SIZE
                           ";"
                           CLI-NOMBRE    DELIMITED BY SIZE
                           ";"
                           CLI-DIRECCION DELIMITED BY SIZE
                           ";"
                           CLI-CATEGORIA DELIMITED BY SIZE
                           INTO REG-CSV
       
                       WRITE REG-CSV
               END-READ
           END-PERFORM
           END-START
           CLOSE CLIENTES-CSV
           SET NO-FIN-LISTA TO TRUE.
