       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION. 
       PROGRAM-ID. PROGRAM9.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PERSONAS-FILE
           ASSIGN TO "./DAT/personas.dat"
           ORGANIZATION IS SEQUENTIAL    
           FILE STATUS IS ST-FILE.
       DATA DIVISION.
       FILE SECTION.
           FD PERSONAS-FILE.
           01 PERSONA-REGISTRO.
              05 PER-NOMBRE PIC X(18).

       WORKING-STORAGE SECTION. 
           01 NOMBRE    PIC X(18).
           01 MENSAJE    PIC X(70).
           01 SALIR     PIC X VALUE "N".
           01 CONT-PERSONAS PIC 9(4) VALUE 0.
           01 ST-FILE         PIC XX.
           
       PROCEDURE DIVISION.
       PARA1.  
           PERFORM ABRO-ARCHIVO.
           PERFORM LISTAR-PERSONAS.
           
              PERFORM UNTIL SALIR = "S" OR SALIR = "s"
                     DISPLAY "PERSONA: "
                     ACCEPT NOMBRE
                     IF FUNCTION TRIM(NOMBRE) NOT = SPACES
                        MOVE NOMBRE TO PER-NOMBRE
                        ADD 1 TO CONT-PERSONAS
                        WRITE PERSONA-REGISTRO
                     END-IF
                    DISPLAY "DESEA TERMINAR? (S/N): "
                    ACCEPT SALIR
              END-PERFORM

              CLOSE PERSONAS-FILE.
              DISPLAY "PERSONAS INGRESADAS: " CONT-PERSONAS.

       
       LISTAR-PERSONAS.
           DISPLAY "----- LISTADO DE PERSONAS -----"
           PERFORM UNTIL ST-FILE = "10"
               READ PERSONAS-FILE
                   AT END
                       MOVE "10" TO ST-FILE
                   NOT AT END
                       DISPLAY "- " FUNCTION TRIM(PER-NOMBRE)
                       ADD 1 TO CONT-PERSONAS
               END-READ
           END-PERFORM 
           CLOSE PERSONAS-FILE
       
           DISPLAY "------------------------------"
           DISPLAY "TOTAL PERSONAS: " CONT-PERSONAS
           STOP RUN.
       ABRO-ARCHIVO.
           OPEN I-O PERSONAS-FILE.
           IF ST-FILE = "35"                                            *> Si el archivo no existe (Error 35), lo creamos
               OPEN OUTPUT PERSONAS-FILE 
               CLOSE PERSONAS-FILE 
               OPEN I-O PERSONAS-FILE.

           IF ST-FILE > "07"                                 
             STRING "Error al abrir Clientes " ST-FILE DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20
              MOVE "S" TO  SALIR.

           END PROGRAM PROGRAM9.
