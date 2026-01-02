
            IF MODULO-ACTUAL = 3         *> --- OPCION FINANCIERO ---
              DISPLAY " Financiero " LINE 2 COL 10
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 10 BACKGROUND-COLOR 7
              DISPLAY "F" LINE 2 COL 11 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "inanciero" LINE 2 COL 12 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.


           IF MODULO-ACTUAL = 4          *> --- OPCION COMERCIAL ---
              DISPLAY " Comercial "  LINE 2 COL 23
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 23 BACKGROUND-COLOR 7
              DISPLAY "C" LINE 2 COL 24 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "omercial" LINE 2 COL 25 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF. 
           
  