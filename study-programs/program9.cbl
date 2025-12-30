       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION. 
       PROGRAM-ID. PROGRAM8.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PERSONAS-FILE
           ASSIGN TO "./DAT/personas.dat"
           ORGANIZATION IS SEQUENTIAL
           FILE STATUS IS WS-FS.
       
       DATA DIVISION.
       FILE SECTION.
       FD PERSONAS-FILE.
       01 PERSONA-REGISTRO.
          05 PER-NOMBRE PIC X(18).
       
       WORKING-STORAGE SECTION. 
       01 NOMBRE         PIC X(18).
       01 MENSAJE         PIC X(70).
       01 SALIR          PIC X VALUE "N".   
       01 WS-FS          PIC XX.
       01 CONT-PERSONAS  PIC 9(4) VALUE 0.
       
       PROCEDURE DIVISION.
       
       MAIN.
           PERFORM ABRO-ARCHIVO
           PERFORM LISTAR-PERSONAS
           PERFORM INGRESAR-PERSONAS
           CLOSE PERSONAS-FILE
           DISPLAY "PERSONAS INGRESADAS: " CONT-PERSONAS
           STOP RUN.
       
       INGRESAR-PERSONAS.
           OPEN EXTEND PERSONAS-FILE
           PERFORM UNTIL SALIR = "S" OR SALIR = "s"
               DISPLAY "PERSONA: "
               ACCEPT NOMBRE
               IF FUNCTION TRIM(NOMBRE) NOT = SPACES
                   MOVE NOMBRE TO PER-NOMBRE
                   WRITE PERSONA-REGISTRO
                   ADD 1 TO CONT-PERSONAS
               END-IF
               DISPLAY "DESEA TERMINAR? (S/N): "
               ACCEPT SALIR
           END-PERFORM.
           
       
       LISTAR-PERSONAS. 
           DISPLAY "----- LISTADO DE PERSONAS -----"
           PERFORM UNTIL WS-FS = "10"
               READ PERSONAS-FILE
                   AT END
                       MOVE "10" TO WS-FS
                   NOT AT END
                       DISPLAY "- " FUNCTION TRIM(PER-NOMBRE)
               END-READ
           END-PERFORM
           CLOSE PERSONAS-FILE
           MOVE "00" TO WS-FS.
       
       ABRO-ARCHIVO.
           OPEN I-O PERSONAS-FILE.
           IF WS-FS = "35"                                              *> Si el archivo no existe (Error 35), lo creamos
               OPEN OUTPUT PERSONAS-FILE 
               CLOSE PERSONAS-FILE 
               OPEN I-O PERSONAS-FILE.

           IF WS-FS > "07"                                 
             STRING "Error al abrir Clientes " WS-FS DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20
              MOVE "S" TO  SALIR.
       
       END PROGRAM PROGRAM8.
       