           >>SOURCE FORMAT FREE
           IDENTIFICATION DIVISION. 
           PROGRAM-ID. PROGRAM7.
           DATA DIVISION.
           WORKING-STORAGE SECTION. 
           01 NOMBRE    PIC X(18).
           01 SALIR     PIC X VALUE "N".
           01 CONT-PERSONAS PIC 9(4) VALUE 0.

           PROCEDURE DIVISION.
           PARA1. 
              
              PERFORM UNTIL SALIR = "S" OR SALIR = "s"
                     DISPLAY "PERSONA: "
                     ACCEPT NOMBRE
                     IF FUNCTION TRIM(NOMBRE) NOT = SPACES
                       ADD 1 TO CONT-PERSONAS
                     END-IF
                    DISPLAY "DESEA TERMINAR? (S/N): "
                    ACCEPT SALIR
              END-PERFORM
              DISPLAY "PERSONAS INGRESADAS: " CONT-PERSONAS.

           END PROGRAM PROGRAM7.
           