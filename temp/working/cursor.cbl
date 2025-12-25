       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DIAGNOSTICO-FINAL.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-KEY           PIC 9(4).
       01 WS-DUMMY         PIC X.
       
       SCREEN SECTION.
       01 SCR-LIMPIA.
          05 BLANK SCREEN.
       01 SCR-CAPTURAR.
          *> Usamos un campo invisible en la esquina para no estorbar
          05 LINE 24 COL 1 PIC X TO WS-DUMMY.
       
       PROCEDURE DIVISION.
       MAIN.
           *> Activamos la escucha de teclas especiales de PDCurses
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           
           PERFORM UNTIL WS-DUMMY = "X" OR WS-DUMMY = "x"
               DISPLAY SCR-LIMPIA
               DISPLAY "--- DETECTOR DE CODIGOS REALES ---" LINE 2 COL 5
               DISPLAY "Presiona cualquier flecha o tecla especial" LINE 4 COL 5
               DISPLAY "Presiona 'X' para salir" LINE 5 COL 5
               
               IF WS-KEY NOT = 0
                  DISPLAY "CODIGO DETECTADO: " LINE 8 COL 5
                  DISPLAY WS-KEY LINE 8 COL 23 WITH HIGHLIGHT
               END-IF
       
               MOVE 0 TO WS-KEY
               *> ACCEPT con EXCEPTION permite capturar flechas al instante
               ACCEPT SCR-CAPTURAR
           END-PERFORM.
           STOP RUN.
           