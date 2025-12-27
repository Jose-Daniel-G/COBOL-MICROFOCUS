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
       
       *> Definimos las constantes para comparar
       78 KEY-ENTER      VALUE 0.
       *> SOLO ESTE BLOQUE ES EL QUE NO FUNCIONA
       78 KEY-LEFT       VALUE 2001.
       78 KEY-RIGHT      VALUE 2002.
       *> ********************************************
       78 KEY-UP         VALUE 2003.
       78 KEY-DOWN       VALUE 2004.
       78 KEY-ESC       VALUE 2005.

       78 KEY-TAB      VALUE 2007.
       78 KEY-BACKTAB  VALUE 2008.
      
       PROCEDURE DIVISION.
       MAIN.
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           SET ENVIRONMENT "COB_SCREEN_ESC"        TO "Y". 

           DISPLAY SPACES ERASE SCREEN.
           DISPLAY "--- MODO DIAGNOSTICO DE TECLAS ---" LINE 2 COL 5.
           DISPLAY "PRESIONA LAS FLECHAS O ESC"         LINE 4 COL 5.
           DISPLAY "PRESIONA 'X' PARA SALIR"            LINE 5 COL 5.
       
           PERFORM UNTIL WS-DUMMY = "X" OR WS-DUMMY = "x"
               MOVE 0 TO WS-KEY
               *> El ACCEPT se "rompe" al presionar una tecla especial
               ACCEPT WS-DUMMY LINE 5 COL 30
               
               *> Limpiamos la línea de mensajes anterior
               DISPLAY "                                      " LINE 10 COL 5
               
               IF WS-KEY NOT = 0
                  DISPLAY "CODIGO: " LINE 10 COL 5
                  DISPLAY WS-KEY     LINE 10 COL 13
                  
                  *> VALIDACION EN TIEMPO REAL
                  EVALUATE WS-KEY
                      WHEN KEY-UP
                          DISPLAY "- FLECHA ARRIBA" LINE 10 COL 18
                      WHEN KEY-DOWN
                          DISPLAY "- FLECHA ABAJO"  LINE 10 COL 18
                      WHEN KEY-ESC
                          DISPLAY "- TECLA ESC"     LINE 10 COL 18
                      WHEN KEY-ENTER
                          DISPLAY "- TECLA ENTER"     LINE 10 COL 18
                      WHEN KEY-TAB
                          DISPLAY "- FLECHA TAB" LINE 10 COL 18
                      WHEN KEY-BACKTAB
                          DISPLAY "- FLECHA BACKTAB" LINE 10 COL 18
                      WHEN KEY-LEFT
                          DISPLAY "- FLECHA IZQUIERDA" LINE 10 COL 18
                      WHEN KEY-RIGHT
                          DISPLAY "- FLECHA DERECHA" LINE 10 COL 18
                      WHEN 1008
                          DISPLAY "- FLECHA DELETE" LINE 10 COL 18
                      WHEN OTHER
                          DISPLAY "- OTRA TECLA"    LINE 10 COL 18
                  END-EVALUATE
               ELSE
                  DISPLAY "TECLA NORMAL: " LINE 10 COL 5
                  DISPLAY WS-DUMMY         LINE 10 COL 20
               END-IF
           END-PERFORM.
           STOP RUN.
           