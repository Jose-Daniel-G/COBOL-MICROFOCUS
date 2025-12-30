           >>SOURCE FORMAT FREE
           IDENTIFICATION DIVISION. 
           PROGRAM-ID. 5program.
           DATA DIVISION.
           WORKING-STORAGE SECTION. 
           01 NOMBRE    PIC X(18).
           01 CIUDAD    PIC X(18).
           01 EDAD      PIC 9(2).
           01 EDAD-EDIT PIC ZZZ9.
           01 RESPUESTA PIC X(18).
           01 SALIR     PIC X VALUE "N".

           PROCEDURE DIVISION.
           PARA1. 
              
              PERFORM UNTIL SALIR = "S" OR SALIR = "s"
                     DISPLAY "CUAL ES TU NOMBRE: "
                     ACCEPT NOMBRE
                     DISPLAY "CUAL ES TU EDAD: "
                     ACCEPT EDAD
                     DISPLAY "DE QUE CIUDAD ERES: "
                     ACCEPT CIUDAD
       
                     DISPLAY "TE LLAMAS " FUNCTION TRIM(NOMBRE) " Y ERES DE LA CIUDAD " FUNCTION TRIM(CIUDAD) 
                     IF EDAD >= 18
                        MOVE "ERES MAYOR DE EDAD" TO RESPUESTA
                     ELSE
                        MOVE "ERES MENOR DE EDAD" TO RESPUESTA
                     END-IF

                     MOVE EDAD TO EDAD-EDIT
                     DISPLAY "TU TIENES (" FUNCTION TRIM(EDAD) ")Y VAMOS A VER: " RESPUESTA
                     DISPLAY "DESEAS TERMINAR EL PROGRAMA? (S/N): "
                       ACCEPT SALIR
              END-PERFORM. 
           END PROGRAM 5program.
           