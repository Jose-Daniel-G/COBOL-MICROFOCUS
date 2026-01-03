        >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION. 
       PROGRAM-ID. PROGRAM12.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT VEHICULOS-FILE
           ASSIGN TO "./DAT/vehiculos.dat"
           ORGANIZATION IS INDEXED
           ACCESS MODE IS DYNAMIC
           RECORD KEY IS VEH-ID
           FILE STATUS IS WS-FS.
       
       DATA DIVISION.
       FILE SECTION.
       FD VEHICULOS-FILE.
       01 VEHICULO-REG.
          05 VEH-ID PIC 9(5).
          05 VEH-MARCA PIC X(18).
          05 VEH-MODELO PIC X(18).
          05 VEH-PRECIO PIC 9(9)V99.
          05 VEH-ESTADO PIC X.
       
       WORKING-STORAGE SECTION. 
       01 WS-FS              PIC XX.
       01 WS-OPCION          PIC X.
       01 WS-SALIR           PIC X VALUE "N".
       01 WS-ID              PIC 9(5).
       01 WS-MENSAJE         PIC X(70).
       01 WS-MARCA           PIC X(18).
       01 WS-MODELO          PIC X(18).
       01 WS-PRECIO         PIC 9(9)V99.
       01 WS-ESTADO         PIC X.
       
       01 WS-OK             PIC X.
       01 WS-FIN            PIC X VALUE "N".
       01 WS-BUSCA-MARCA PIC X(18).

       PROCEDURE DIVISION.
       
       MAIN.
           PERFORM ABRIR-ARCHIVO.
           PERFORM MENU-PROGRAM
           CLOSE VEHICULOS-FILE
           STOP RUN.
       MENU-PROGRAM.

           PERFORM UNTIL WS-SALIR = "S" OR WS-SALIR = "s"
               DISPLAY "============[ CONSECIONARIO ]==============="
               DISPLAY "========  1. REGISTRAR VEHICULO   =========="
               DISPLAY "========  2. CONSULTAR VEHICULO   =========="
               DISPLAY "========  3. ACTUALIZAR VEHICULO  =========="
               DISPLAY "========  4. VENDER VEHICULO      ==========" 
               DISPLAY "========  5. LISTAR TODOS         =========="
               DISPLAY "========  6. LISTAR DISPONIBLES   =========="
               DISPLAY "========  7. LISTAR VENDIDOS      =========="
               DISPLAY "========  8. BUSCAR POR MARCA     =========="
               DISPLAY "========  9. SALIR               =========="
               DISPLAY "============================================"
                ACCEPT WS-OPCION
               EVALUATE WS-OPCION
                     WHEN "1"
                          PERFORM REGISTRAR
                     WHEN "2"
                          PERFORM CONSULTAR
                     WHEN "3"
                          PERFORM ACTUALIZAR
                     WHEN "4"
                          PERFORM VENDER
                     WHEN "5"
                           PERFORM LISTAR-TODOS
                     WHEN "6"
                           PERFORM LISTAR-DISPONIBLES
                     WHEN "7"
                           PERFORM LISTAR-VENDIDOS
                     WHEN "8" 
                           PERFORM BUSCAR-MARCA
                     WHEN "9"
                          MOVE "S" TO WS-SALIR
                     WHEN OTHER
                          DISPLAY "OPCION INVALIDA, INTENTE DE NUEVO."
                END-EVALUATE
           END-PERFORM.
           


       REGISTRAR.

           DISPLAY "ID VEHICULO: "
           ACCEPT WS-ID
           
           MOVE WS-ID TO VEH-ID
           READ VEHICULOS-FILE
                INVALID KEY  
                   DISPLAY "MARCA: "
                   ACCEPT WS-MARCA 
                   DISPLAY "MODELO: "
                   ACCEPT WS-MODELO
                   DISPLAY "PRECIO: "
                   ACCEPT WS-PRECIO
                   PERFORM VALIDAR-DATOS
                   IF WS-OK = "S"
                      INITIALIZE VEHICULO-REG   *> 🔥 CLAVE
                      MOVE WS-ID TO VEH-ID
                      MOVE WS-MARCA         TO VEH-MARCA
                      MOVE WS-MODELO        TO VEH-MODELO
                      MOVE WS-PRECIO        TO VEH-PRECIO
                      MOVE "D"              TO VEH-ESTADO
                      WRITE VEHICULO-REG
                      DISPLAY "VEHICULO INGRESADO CORRECTAMENTE"
                   END-IF

                NOT INVALID KEY
                   DISPLAY "EL REGISTRO YA EXISTE CON " 
                   DISPLAY "MARCA: " FUNCTION TRIM(VEH-MARCA)
                   DISPLAY "MODELO: " FUNCTION TRIM(VEH-MODELO)
           END-READ.
           
       CONSULTAR.
           DISPLAY "ID VEHICULO: "
           ACCEPT WS-ID
           MOVE   WS-ID TO VEH-ID.

           READ VEHICULOS-FILE
               INVALID KEY 
                   DISPLAY "VEHICULO NO ENCONTRADO."
               NOT INVALID KEY
                   DISPLAY "MARCA : " VEH-MARCA
                   DISPLAY "MODELO : " VEH-MODELO
                   DISPLAY "PRECIO : " VEH-PRECIO
                   DISPLAY "ESTADO : " 
                  EVALUATE VEH-ESTADO
                      WHEN "D" DISPLAY "DISPONIBLE"
                      WHEN "V" DISPLAY "VENDIDO"
                      WHEN OTHER DISPLAY "DESCONOCIDO"
                  END-EVALUATE
           END-READ.

       ACTUALIZAR.
           DISPLAY "ID VEHICULO: "
           ACCEPT WS-ID
           MOVE   WS-ID TO VEH-ID.

           READ VEHICULOS-FILE
               INVALID KEY 
                   DISPLAY "VEHICULO NO ENCONTRADO."
               NOT INVALID KEY

                   MOVE VEH-MARCA TO WS-MARCA
                   MOVE VEH-MODELO TO WS-MODELO
                   MOVE VEH-PRECIO TO WS-PRECIO
                   DISPLAY "MARCA: " WS-MARCA
                   ACCEPT   WS-MARCA
                   DISPLAY  "MODELO: " WS-MODELO
                   ACCEPT   WS-MODELO
                   DISPLAY  "PRECIO: " WS-PRECIO
                   ACCEPT   WS-PRECIO

                   MOVE WS-MARCA   TO VEH-MARCA
                   MOVE WS-MODELO  TO VEH-MODELO
                   MOVE WS-PRECIO  TO VEH-PRECIO
                   REWRITE VEHICULO-REG
                   DISPLAY "VEHICULO ACTUALIZADO CORRECTAMENTE."
           END-READ.
       VENDER.
           DISPLAY "ID VEHICULO: "
           ACCEPT WS-ID
           MOVE   WS-ID TO VEH-ID.

           READ VEHICULOS-FILE
               INVALID KEY 
                   DISPLAY "VEHICULO NO ENCONTRADO."
               NOT INVALID KEY
                   IF VEH-ESTADO = "V"
                       DISPLAY "EL VEHICULO YA FUE VENDIDO."
                   ELSE
                       MOVE "V" TO VEH-ESTADO
                       REWRITE VEHICULO-REG
                       DISPLAY "VEHICULO VENDIDO CORRECTAMENTE."
                   END-IF
           END-READ.

       LISTAR-TODOS.
           MOVE LOW-VALUES TO VEH-ID
           MOVE "N" TO WS-FIN
           START VEHICULOS-FILE KEY >= VEH-ID

           PERFORM UNTIL WS-FIN = "S"
               READ VEHICULOS-FILE NEXT
                   AT END
                       MOVE "S" TO WS-FIN
                   NOT AT END
                       PERFORM MOSTRAR-VEHICULO
               END-READ
           END-PERFORM.

       LISTAR-DISPONIBLES.
           MOVE LOW-VALUES TO VEH-ID

           MOVE "N" TO WS-FIN
           START VEHICULOS-FILE KEY >= VEH-ID

           PERFORM UNTIL WS-FIN = "S"
               READ VEHICULOS-FILE NEXT
                   AT END
                       MOVE "S" TO WS-FIN
                   NOT AT END
                       IF VEH-ESTADO = "D"
                           PERFORM MOSTRAR-VEHICULO
                       END-IF
               END-READ
           END-PERFORM.
       
       MOSTRAR-VEHICULO.
           DISPLAY "--------------------------------"
           DISPLAY "ID     : " VEH-ID
           DISPLAY "MARCA  : " VEH-MARCA
           DISPLAY "MODELO : " VEH-MODELO
           DISPLAY "PRECIO : " VEH-PRECIO
           DISPLAY "ESTADO : "
           EVALUATE VEH-ESTADO
               WHEN "D" DISPLAY "DISPONIBLE"
               WHEN "V" DISPLAY "VENDIDO"
               WHEN OTHER DISPLAY "DESCONOCIDO"
           END-EVALUATE.

       LISTAR-VENDIDOS.
           MOVE LOW-VALUES TO VEH-ID
           MOVE "N" TO WS-FIN
           START VEHICULOS-FILE KEY >= VEH-ID

           PERFORM UNTIL WS-FIN = "S"
               READ VEHICULOS-FILE NEXT
                   AT END
                       MOVE "S" TO WS-FIN
                   NOT AT END
                       IF VEH-ESTADO = "V"
                           PERFORM MOSTRAR-VEHICULO
                       END-IF
               END-READ
           END-PERFORM.

       BUSCAR-MARCA.
           DISPLAY "MARCA A BUSCAR: "
           ACCEPT WS-BUSCA-MARCA

           MOVE LOW-VALUES TO VEH-ID

           MOVE "N" TO WS-FIN
           MOVE "N" TO WS-OK

           START VEHICULOS-FILE KEY >= VEH-ID

           PERFORM UNTIL WS-FIN = "S"
               READ VEHICULOS-FILE NEXT
                   AT END
                       MOVE "S" TO WS-FIN
                   NOT AT END
                       IF VEH-MARCA = WS-BUSCA-MARCA
                           PERFORM MOSTRAR-VEHICULO
                           MOVE "S" TO WS-OK
                       END-IF
               END-READ
           END-PERFORM.
           
       VALIDAR-DATOS.
           IF WS-MARCA = SPACES
               DISPLAY "ERROR: MARCA OBLIGATORIA"
               MOVE "N" TO WS-OK
           ELSE
               IF WS-PRECIO <= 0
                   DISPLAY "ERROR: PRECIO INVALIDO"
                   MOVE "N" TO WS-OK
               ELSE
                   MOVE "S" TO WS-OK
               END-IF
           END-IF.

       ABRIR-ARCHIVO.
           OPEN I-O VEHICULOS-FILE.
           IF WS-FS = "35"                                              *> Si el archivo no existe (Error 35), lo creamos
               OPEN OUTPUT VEHICULOS-FILE 
               CLOSE VEHICULOS-FILE 
               OPEN I-O VEHICULOS-FILE

           IF WS-FS > "00"                                 
             STRING "Error archivo: " WS-FS DELIMITED BY SIZE
                     INTO WS-MENSAJE
              DISPLAY WS-MENSAJE LINE 10 COL 20
              MOVE "S" TO  WS-SALIR 
           END-IF.

       END PROGRAM PROGRAM12.

