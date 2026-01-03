       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DIAGNOSTICO.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-KEY     PIC 9(4).
       01 WS-DUMMY   PIC X.
       PROCEDURE DIVISION.
       MAIN.
           *> Activamos el soporte de teclas especiales
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           SET ENVIRONMENT "COB_SCREEN_ESC"        TO "Y". 

           DISPLAY SPACES ERASE SCREEN.
           DISPLAY "PRESIONA UNA FLECHA PARA VER SU CODIGO" LINE 5 COL 5.
           DISPLAY "PRESIONA 'X' PARA SALIR" LINE 6 COL 5.
       
           PERFORM UNTIL WS-DUMMY = "X" OR WS-DUMMY = "x"
               *> Limpiamos la variable antes de cada lectura
               MOVE 0 TO WS-KEY
               *> ACCEPT obliga al programa a esperar una tecla física
               ACCEPT WS-DUMMY LINE 8 COL 5
               
               IF WS-KEY NOT = 0
                  DISPLAY "CODIGO DETECTADO: " LINE 10 COL 5
                  DISPLAY WS-KEY LINE 10 COL 23
               END-IF
           END-PERFORM.
           STOP RUN.
           