           >>SOURCE FORMAT FREE
           IDENTIFICATION DIVISION. 
           PROGRAM-ID. PROGRAM6.
           DATA DIVISION.
           WORKING-STORAGE SECTION. 
           01 NOMBRE    PIC X(18).
           01 CIUDAD    PIC X(18).
           01 EDAD      PIC 9(2).
           01 EDAD-EDIT PIC X(2).
           01 RESPUESTA PIC X(18).
           01 SALIR     PIC X VALUE "N".

           PROCEDURE DIVISION.
           PARA1. 
              
              PERFORM UNTIL SALIR = "S" OR SALIR = "s"
                     DISPLAY "CUAL ES TU NOMBRE: "
                     ACCEPT NOMBRE
                     DISPLAY "CUAL ES TU EDAD: "
                     ACCEPT EDAD-EDIT
                     PERFORM ERROR-EDAD

                     DISPLAY "DE QUE CIUDAD ERES: "
                     ACCEPT CIUDAD
       
                     DISPLAY "TE LLAMAS " FUNCTION TRIM(NOMBRE) " Y ERES DE LA CIUDAD " FUNCTION TRIM(CIUDAD) 
                     MOVE EDAD-EDIT TO EDAD

                     IF EDAD >= 18
                        MOVE "ERES MAYOR DE EDAD" TO RESPUESTA
                     ELSE
                        MOVE "ERES MENOR DE EDAD" TO RESPUESTA
                     END-IF


                     DISPLAY "TU TIENES (" EDAD")Y VAMOS A VER: " RESPUESTA
                     
                     IF FUNCTION MOD(EDAD, 2) = 0
                        DISPLAY "TU EDAD ES PAR"
                     ELSE
                        DISPLAY "TU EDAD ES IMPAR"
                     END-IF
                     DISPLAY "DESEAS TERMINAR EL PROGRAMA? (S/N): "
                       ACCEPT SALIR
              END-PERFORM. 

           ERROR-EDAD.
              IF EDAD-EDIT IS NOT NUMERIC
                   DISPLAY "*********************************"
                   DISPLAY "ERROR: LA EDAD DEBE SER NUMERICA"
                   DISPLAY "*********************************"
                   GO TO PARA1.

           END PROGRAM PROGRAM6.
           