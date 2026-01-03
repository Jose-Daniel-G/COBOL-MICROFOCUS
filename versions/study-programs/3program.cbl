           >>SOURCE FORMAT FREE
           IDENTIFICATION DIVISION. 
           PROGRAM-ID. 3program.
           DATA DIVISION.
           WORKING-STORAGE SECTION. 
           01 NUM1  PIC 9(2).
           01 NUM2  PIC 9(2).     
           01 SUMA  PIC ZZZ9.     
           01 RESTA PIC ZZZ9.     
           01 RESULTADO-TXT PIC X(4).

           PROCEDURE DIVISION.
           PARA1. 
              DISPLAY "DIGITE EL PRIMER NUMERO ".
              ACCEPT NUM1.
              DISPLAY "DIGITE EL SEGUNDO NUMERO: ".
              ACCEPT NUM2. 
              ADD  NUM1 TO NUM2 GIVING SUMA.
              MOVE SUMA TO RESULTADO-TXT.
              DISPLAY "RESULTADO DE LA SUMA ES: " RESULTADO-TXT. 
              SUBTRACT NUM1 FROM NUM2 GIVING RESTA.
              MOVE RESTA TO RESULTADO-TXT.
              DISPLAY "RESULTADO DE LA RESTA ES: " RESULTADO-TXT. 
           END PROGRAM 3program.

      *ACCEPT (leer teclado)
      *Números
      *Sumar y restar
      *Errores comunes en Windows