       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DETECTOR-FIJO.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-KEY           PIC 9(4).
       01 WS-FIN           PIC X VALUE "N".
       01 WS-DUMMY         PIC X.
       
       SCREEN SECTION.
       01 SCR-PRINCIPAL.
          05 BLANK SCREEN.
          05 LINE 2 COL 5 VALUE "--- MODO DETECCION FIJA ---".
          05 LINE 4 COL 5 VALUE "Presiona una flecha para ver el codigo".
          05 LINE 6 COL 5 VALUE "Presiona 'X' para salir".
          05 LINE 10 COL 5 VALUE "CODIGO RECIBIDO: ".
          05 L-VAL PIC 9(4) FROM WS-KEY LINE 10 COL 22 HIGHLIGHT.
       
       PROCEDURE DIVISION.
       MAIN.
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           DISPLAY SCR-PRINCIPAL.
           
           PERFORM UNTIL WS-FIN = "S" OR WS-FIN = "s"
               *> Al quitar el BEFORE TIME, el programa se detiene y NO parpadea
               ACCEPT SCR-PRINCIPAL
               
               IF WS-KEY NOT = 0
                  *> Mostramos el código detectado inmediatamente
                  DISPLAY L-VAL
               END-IF
       
               *> Si presionas una letra normal (como X), la capturamos aquí
               ACCEPT WS-DUMMY LINE 1 COL 1 BEFORE TIME 1
               IF WS-DUMMY = "S" OR WS-DUMMY = "s" OR WS-DUMMY = "X" OR WS-DUMMY = "x"
                  MOVE "S" TO WS-FIN
               END-IF
           END-PERFORM.
           STOP RUN.
