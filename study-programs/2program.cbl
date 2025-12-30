           IDENTIFICATION DIVISION. 
           PROGRAM-ID. 2program.
           DATA DIVISION.
           WORKING-STORAGE SECTION. 
           01 NOMBRE PIC X(42).
           01 EDAD PIC X(2).     
           PROCEDURE DIVISION.
           PARA1. 
              DISPLAY "DIGITE SU NOMBRE AQUI: ".
              ACCEPT NOMBRE.
              DISPLAY "DIGITE SU EDAD AQUI: ".
              ACCEPT EDAD. 
              DISPLAY "HOLA "FUNCTION TRIM(NOMBRE) " TIENES "  EDAD
                                                   " ANOS ". 
           END PROGRAM 2program.
           

      *ACCEPT (leer teclado)
      *Números
      *Sumar y restar
      *Errores comunes en Windows
