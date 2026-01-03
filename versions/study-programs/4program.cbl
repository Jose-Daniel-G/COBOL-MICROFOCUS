           >>SOURCE FORMAT FREE
           IDENTIFICATION DIVISION. 
           PROGRAM-ID. 4program.
           DATA DIVISION.
           WORKING-STORAGE SECTION. 
           01 EDAD  PIC 9(2).   
           01 RESPUESTA PIC X(18).

           PROCEDURE DIVISION.
           PARA1. 
              DISPLAY "ERES MAYOR DE EDAD? ".
              ACCEPT EDAD.


              IF EDAD >= 18
                 MOVE "ERES MAYOR DE EDAD" TO RESPUESTA
              ELSE
                 MOVE "ERES MENOR DE EDAD" TO RESPUESTA
              END-IF.

              DISPLAY "(" EDAD ") VAMOS A VER: " RESPUESTA. 
           END PROGRAM 4program.
           