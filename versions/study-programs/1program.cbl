           IDENTIFICATION DIVISION. 
           PROGRAM-ID. 1program.
           DATA DIVISION.
           WORKING-STORAGE SECTION. 
           01 NOMBRE PIC X(42).
           01 EDAD PIC X(20).     
           PROCEDURE DIVISION.
           PARA1. 
              MOVE "HOLA ME LLAMO JOSE DANIEL GRIJALBA OSORIO " 
                                                              TO NOMBRE.
              MOVE "Y TENGO 28 ANOS"                          TO EDAD.
              DISPLAY NOMBRE.
              DISPLAY EDAD. 
           END PROGRAM 1program.
           
      *MOVE	Asignar valor
      *DISPLAY	Mostrar
      *STOP RUN	Finalizar