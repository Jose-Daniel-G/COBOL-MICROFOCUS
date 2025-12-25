       >>SOURCE FORMAT FREEk
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MENU-FINAL.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-KEY           PIC 9(4).
       01 WS-OPTION        PIC 9 VALUE 1.
       01 WS-FIN           PIC X VALUE "N".
       01 WS-TECLA         PIC X.
       
       PROCEDURE DIVISION.
       MAIN.
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           DISPLAY SPACES ERASE SCREEN.
           
           PERFORM UNTIL WS-FIN = "S"
               DISPLAY "FLECHAS PARA MOVER | ENTER PARA SALIR" LINE 2 COL 5
               
               IF WS-OPTION = 1
                  DISPLAY "> OPCION 1 <" LINE 5 COL 10 WITH REVERSE-VIDEO
                  DISPLAY "  OPCION 2  " LINE 6 COL 10
               ELSE
                  DISPLAY "  OPCION 1  " LINE 5 COL 10
                  DISPLAY "> OPCION 2 <" LINE 6 COL 10 WITH REVERSE-VIDEO
               END-IF
       
               *> Usamos ACCEPT de una variable para que no estorbe el puntero
               ACCEPT WS-TECLA LINE 1 COL 1
               
               EVALUATE WS-KEY
                   WHEN 2003 MOVE 1 TO WS-OPTION  *> Tu código para ARRIBA
                   WHEN 2004 MOVE 2 TO WS-OPTION  *> Tu código para ABAJO
                   WHEN 0    MOVE "S" TO WS-FIN   *> ENTER para salir
               END-EVALUATE
           END-PERFORM.
           STOP RUN.
       
                  