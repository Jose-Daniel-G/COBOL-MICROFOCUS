       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION. 
       PROGRAM-ID. PROGRAM11.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PERSONAS-FILE
           ASSIGN TO "./DAT/personas.dat"
           ORGANIZATION IS INDEXED
           ACCESS MODE IS DYNAMIC
           RECORD KEY IS PER-ID
           FILE STATUS IS WS-FS.
       
       DATA DIVISION.
       FILE SECTION.
       FD PERSONAS-FILE.
       01 PERSONA-REGISTRO.
          05 PER-ID PIC 9(5).
          05 PER-NOMBRE PIC X(18).
       
       WORKING-STORAGE SECTION. 
       01 WS-FS              PIC XX.
       01 WS-ID              PIC 9(5).
       01 WS-NOMBRE          PIC X(18).
       01 WS-MENSAJE         PIC X(70).
       01 WS-SALIR           PIC X VALUE "N".   
       01 WS-CONT-PERSONAS   PIC 9(4) VALUE 0.
       
       PROCEDURE DIVISION.
       
       MAIN.
           PERFORM ABRO-ARCHIVO.

           PERFORM INGRESAR-PERSONAS
           CLOSE PERSONAS-FILE
           DISPLAY "PERSONAS INGRESADAS: " WS-CONT-PERSONAS
           STOP RUN.
       
       INGRESAR-PERSONAS.

           PERFORM UNTIL WS-SALIR = "S" OR WS-SALIR = "s"
               DISPLAY "ID PERSONA: "
               ACCEPT WS-ID
               
               MOVE WS-ID TO PER-ID
               READ PERSONAS-FILE
                    INVALID KEY  
                       DISPLAY "INGRESE NOMBRE: "
                       ACCEPT WS-NOMBRE
                       MOVE WS-NOMBRE TO PER-NOMBRE
                       WRITE PERSONA-REGISTRO
                       DISPLAY "PERSONA INGRESADA CORRECTAMENTE"
                    NOT INVALID KEY
                       DISPLAY "EL REGISTRO YA EXISTE: " PER-NOMBRE
                       DISPLAY FUNCTION TRIM(PER-NOMBRE)
               END-READ
                       
               DISPLAY "DESEA TERMINAR? (S/N): "
               ACCEPT WS-SALIR
           END-PERFORM
           CLOSE PERSONAS-FILE.
           STOP RUN.

       ABRO-ARCHIVO.
           OPEN I-O PERSONAS-FILE.
           IF WS-FS = "35"                                              *> Si el archivo no existe (Error 35), lo creamos
               OPEN OUTPUT PERSONAS-FILE 
               CLOSE PERSONAS-FILE 
               OPEN I-O PERSONAS-FILE.

           IF WS-FS > "07"                                 
             STRING "Error al abrir Clientes " WS-FS DELIMITED BY SIZE
                     INTO WS-MENSAJE
              DISPLAY WS-MENSAJE LINE 10 COL 20
              MOVE "S" TO  WS-SALIR.
       END PROGRAM PROGRAM11.
       