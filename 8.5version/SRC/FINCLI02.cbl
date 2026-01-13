       >>SOURCE FORMAT FREE
      *> ******************************************************************
      *> * Author:   JOSE DANIEL GRIJALBA
      *> * Date:     12/23/2025
      *> * Purpose:  LEARN
      *> * Tectonics: cobc
      *> ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. FINCLI02.

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
           COPY "LIST-NAV.cpy".
           
       01 WS-UI-CONTROLES.
          05 WS-TITULO-PANTALLA    PIC X(40) VALUE SPACES.
          05 WS-MODULO-PANTALLA    PIC X(26) VALUE SPACES.
          05 WS-PROGRAMA           PIC X(10) VALUE SPACES.

       01  ST-CLIENTES    PIC XX.
       01  WS-KEY         PIC 9(4).
       01  WS-PAUSA       PIC X.
       01  RESPUESTA      PIC X     VALUE "S".

 
       01 WS-BUSCA-NOMBRE      PIC X(20).      
        *>--------- --- BUSQUEDA --- -------------
       01 WS-MODO-BUSQUEDA     PIC X VALUE "N".
          88 BUSCANDO          VALUE "S".
          88 NO-BUSCANDO       VALUE "N".           
       01  MENSAJE    PIC X(70).       
       *>----------------------------------------

       01  TABLA-PANTALLA.
          05 REG-PANTALLA OCCURS 20 TIMES.
             10 T-ID      PIC 9(07).
             10 T-NOM     PIC X(30).
             10 T-DIR     PIC X(30).
             10 T-CAT     PIC X(01).



       SCREEN SECTION.
       01 PANTALLA-BASE.
           COPY "HEADER.cpy". 
           05 LINE 02 COL 70 VALUE "PAG:".
           05 LINE 02 COL 75 PIC ZZ9 FROM WS-PAG-ACTUAL.
           05 LINE 03 COL 02  VALUE "ID"         BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 15 VALUE "NOMBRE"      BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 47 VALUE "DIRECCION"   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 03 COL 69 VALUE "CATEGORIA"   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 04 COL 01  PIC X(80) FROM ALL "_" BACKGROUND-COLOR 1. 

       PROCEDURE DIVISION.
       
       MAIN-LOGIC.

           MOVE "LISTADO INDEXADO DE CLIENTES" TO WS-TITULO-PANTALLA           *> 1. Configuras los datos del encabezado
           MOVE "MODO CONSULTA"                TO WS-MODULO-PANTALLA
           MOVE "FINCLI02"                     TO WS-PROGRAMA

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

           CLOSE CLIENTES.
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
                              *> Leer el siguiente registro para guardar su ID
                              MOVE T-ID(WS-INDICE) TO CLI-ID
                              START CLIENTES KEY IS GREATER THAN CLI-ID
                              READ CLIENTES NEXT RECORD
                                  AT END
                                      SET FIN-LISTA TO TRUE
                                  NOT AT END
                                      *> Guardar el ID del PRIMER registro de la próxima página
                                      ADD 1 TO WS-PAG-ACTUAL
                                      MOVE CLI-ID TO WS-IDS-INICIO(WS-PAG-ACTUAL)
                                      
                                      *> Reposicionar para recargar
                                      START CLIENTES KEY IS NOT LESS THAN CLI-ID
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
                              MOVE WS-IDS-INICIO(WS-PAG-ACTUAL) TO CLI-ID
                              START CLIENTES KEY IS NOT LESS THAN CLI-ID
                              
                              *> NO DESCARTAR NADA - RECARGAR DIRECTO
                              SET NO-FIN-LISTA TO TRUE
                              PERFORM RECARGAR-PAGINA 
                              DISPLAY PANTALLA-BASE
                              PERFORM MOSTRAR-PANTALLA-ACTUAL
                              
                              MOVE WS-FILA-MAX TO WS-PUNTERO
                              COMPUTE WS-INDICE = WS-FILA-MAX - WS-FILA-INICIO + 1
                         END-IF
                     END-IF
                    WHEN KEY-F7
                        PERFORM BUSCAR-CLIENTE
                        DISPLAY PANTALLA-BASE
                        PERFORM MOSTRAR-PANTALLA-ACTUAL
                     WHEN KEY-F8  *> tecla Suprimir/Delete
                         PERFORM ELIMINAR-REGISTRO
                         DISPLAY PANTALLA-BASE
                         PERFORM MOSTRAR-PANTALLA-ACTUAL
                     WHEN KEY-F9  *> tecla F9 (Generar Plano)
                         PERFORM GENERAR-PLANO
                         DISPLAY "Archivo plano 'clientes.txt' generado." LINE 22 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                     WHEN KEY-F10  *> tecla F10 (Generar CSV)
                         PERFORM GENERAR-CSV
                         DISPLAY "Archivo CSV 'clientes.CSV' generado."   LINE 22 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                     WHEN KEY-ENTER
                         CONTINUE 
                 END-EVALUATE
             ELSE
                 *> Si no hay registros, forzamos esperar F7 o ESC
                 DISPLAY "No hay registros."   LINE 22 COL 20 ACCEPT WS-PAUSA LINE 23 COL 55
                 ACCEPT WS-PAUSA LINE 1 COL 1 WITH NO-ECHO
                 PERFORM INICIALIZAR-LISTADO
                 IF WS-KEY = KEY-F7 PERFORM BUSCAR-CLIENTE END-IF
             END-IF
         END-PERFORM.

 
       AGREGAR-A-TABLA.
           MOVE CLI-ID        TO T-ID(WS-INDICE)
           MOVE CLI-NOMBRE    TO T-NOM(WS-INDICE)
           MOVE CLI-DIRECCION TO T-DIR(WS-INDICE)
           MOVE CLI-CATEGORIA TO T-CAT(WS-INDICE)
           ADD 1 TO WS-INDICE.

       MOSTRAR-PANTALLA-ACTUAL.
           PERFORM VARYING WS-INDICE FROM 1 BY 1 
               UNTIL WS-INDICE > 20 *>(WS-FILA-MAX - WS-FILA-INICIO + 1)
               
               IF T-ID(WS-INDICE) > ZERO
                   COMPUTE WS-FILA = WS-FILA-INICIO + WS-INDICE - 1
                   PERFORM NORMALIZAR-PINTADO
               END-IF
           END-PERFORM.
           MOVE 1 TO WS-INDICE.
       NORMALIZAR-PINTADO.
           DISPLAY T-ID(WS-INDICE)  LINE WS-FILA COL 2  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-NOM(WS-INDICE) LINE WS-FILA COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-DIR(WS-INDICE) LINE WS-FILA COL 47 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CAT(WS-INDICE) LINE WS-FILA COL 75 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

       RESALTAR-FILA.
           DISPLAY ALL " " LINE WS-PUNTERO COL 1 SIZE 80 BACKGROUND-COLOR 7.
           DISPLAY T-ID(WS-INDICE)  LINE WS-PUNTERO COL 2  BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-NOM(WS-INDICE) LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-DIR(WS-INDICE) LINE WS-PUNTERO COL 47 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           DISPLAY T-CAT(WS-INDICE) LINE WS-PUNTERO COL 75 BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.

       NORMALIZAR-FILA.
           DISPLAY ALL " " LINE WS-PUNTERO COL 1 SIZE 80 BACKGROUND-COLOR 1.
           DISPLAY T-ID(WS-INDICE)  LINE WS-PUNTERO COL 2  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-NOM(WS-INDICE) LINE WS-PUNTERO COL 15 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-DIR(WS-INDICE) LINE WS-PUNTERO COL 47 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           DISPLAY T-CAT(WS-INDICE) LINE WS-PUNTERO COL 75 BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

       BUSCAR-CLIENTE.
           DISPLAY ALL " " LINE 22 COL 1 SIZE 80 BACKGROUND-COLOR 1.    *> Limpiar línea de búsqueda
           
           DISPLAY "Ingrese nombre a buscar: " LINE 22 COL 20 
                   BACKGROUND-COLOR 1 FOREGROUND-COLOR 7
           
           MOVE SPACES TO WS-BUSCA-NOMBRE
           ACCEPT WS-BUSCA-NOMBRE LINE 22 COL 45 
                  BACKGROUND-COLOR 1 FOREGROUND-COLOR 7
           
           IF WS-BUSCA-NOMBRE NOT = SPACES                              *> Si ingresó algo, activar modo búsqueda
               SET BUSCANDO TO TRUE
           ELSE
               SET NO-BUSCANDO TO TRUE 
           END-IF 

           PERFORM INICIALIZAR-LISTADO                                     *> Recargar el listado con el filtro
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
                                   PERFORM INICIALIZAR-LISTADO
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
           PERFORM VARYING WS-FILA FROM WS-FILA-INICIO BY 1 UNTIL WS-FILA > 24
               DISPLAY ALL " " LINE WS-FILA COL 1 SIZE 80 BACKGROUND-COLOR 1
           END-PERFORM.
       
       INICIALIZAR-LISTADO.
           SET NO-FIN-LISTA TO TRUE.
           IF BUSCANDO
               MOVE WS-BUSCA-NOMBRE TO CLI-NOMBRE
               START CLIENTES KEY IS NOT LESS THAN CLI-NOMBRE
                   INVALID KEY SET FIN-LISTA TO TRUE
               END-START
           ELSE
               MOVE ZERO TO CLI-ID
               START CLIENTES KEY IS NOT LESS THAN CLI-ID
                   INVALID KEY SET FIN-LISTA TO TRUE
               END-START
           END-IF.
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
                   READ CLIENTES 
                       AT END SET FIN-LISTA TO TRUE
                       NOT AT END 
                           IF BUSCANDO
                               IF CLI-NOMBRE(1:FUNCTION LENGTH(FUNCTION TRIM(WS-BUSCA-NOMBRE))) 
                                  = FUNCTION TRIM(WS-BUSCA-NOMBRE)
                                   PERFORM AGREGAR-A-TABLA
                               END-IF
                           ELSE
                               PERFORM AGREGAR-A-TABLA
                           END-IF
                   END-READ
                   SET NO-ES-PRIMER-REGISTRO TO TRUE
               ELSE
                   *> Lecturas subsecuentes: leer el siguiente registro
                   READ CLIENTES NEXT RECORD
                       AT END SET FIN-LISTA TO TRUE
                       NOT AT END 
                           IF BUSCANDO
                               IF CLI-NOMBRE(1:FUNCTION LENGTH(FUNCTION TRIM(WS-BUSCA-NOMBRE))) 
                                  = FUNCTION TRIM(WS-BUSCA-NOMBRE)
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
       
                       WRITE REG-CLIENTE-PLANO FROM WS-LINEA-PLANO
               END-READ
           END-PERFORM
           CLOSE CLIENTES-PLANO
           SET NO-FIN-LISTA TO TRUE. 
       GENERAR-CSV.         
           SET NO-FIN-LISTA TO TRUE
           OPEN OUTPUT CLIENTES-CSV
          
           MOVE ZERO TO CLI-ID
           START CLIENTES KEY IS NOT LESS THAN CLI-ID
               INVALID KEY
                   CLOSE CLIENTES-CSV
                   EXIT PARAGRAPH
           NOT INVALID KEY
           MOVE "ID;NOMBRE;DIRECCION;CATEGORIA" TO REG-CLIENTE-CSV
           WRITE REG-CLIENTE-CSV
           PERFORM UNTIL FIN-LISTA
               READ CLIENTES NEXT RECORD
                   AT END
                       SET FIN-LISTA TO TRUE
                   NOT AT END
                       INITIALIZE REG-CLIENTE-CSV
                       STRING
                           CLI-ID        DELIMITED BY SIZE
                           ";"
                           CLI-NOMBRE    DELIMITED BY SIZE
                           ";"
                           CLI-DIRECCION DELIMITED BY SIZE
                           ";"
                           CLI-CATEGORIA DELIMITED BY SIZE
                           INTO REG-CLIENTE-CSV
       
                       WRITE REG-CLIENTE-CSV
               END-READ
           END-PERFORM
           END-START
           CLOSE CLIENTES-CSV
           SET NO-FIN-LISTA TO TRUE.
