       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-ARROWS.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-KEY           PIC 9(4).
          88 KEY-UP        VALUE 2007.
          88 KEY-DOWN      VALUE 2008.
          88 KEY-ESC       VALUE 2005. *> Usaremos ESC para salir, no Enter
       01 WS-OPTION        PIC 9 VALUE 1.
       01 WS-FIN           PIC X VALUE "N".
       01 WS-DUMMY         PIC X.
       
       SCREEN SECTION.
       01 SCR-DUMMY.
          *> El secreto es que el campo sea pequeño y no pida Enter
          05 LINE 1 COL 1 PIC X USING WS-DUMMY.
       
       PROCEDURE DIVISION.
       MAIN.
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           DISPLAY SPACES ERASE SCREEN.
           
           PERFORM UNTIL WS-FIN = "S"
               DISPLAY "FLECHAS PARA MOVER | ESC PARA SALIR" LINE 2 COL 5
               
               IF WS-OPTION = 1
                  DISPLAY "> OPCION 1 <" LINE 5 COL 10 WITH REVERSE-VIDEO
                  DISPLAY "  OPCION 2  " LINE 6 COL 10
               ELSE
                  DISPLAY "  OPCION 1  " LINE 5 COL 10
                  DISPLAY "> OPCION 2 <" LINE 6 COL 10 WITH REVERSE-VIDEO
               END-IF
       
               *> Agregamos un límite de tiempo para que la lectura sea inmediata
               ACCEPT SCR-DUMMY BEFORE TIME 1
               
               EVALUATE WS-KEY
                   WHEN 2007  MOVE 1 TO WS-OPTION
                   WHEN 2008  MOVE 2 TO WS-OPTION
                   WHEN 2005  MOVE "S" TO WS-FIN
               END-EVALUATE
           END-PERFORM.
           STOP RUN.
