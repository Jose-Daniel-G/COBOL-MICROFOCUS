IDENTIFICATION DIVISION.
       PROGRAM-ID. FormularioCheck.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-CAMPOS.
           05 WS-TERMINOS         PIC X VALUE ' '.
              88 TERMINOS-ACEPTADOS     VALUE 'S', 's'.
           05 WS-BOLETIN          PIC X VALUE ' '.
              88 QUIERE-BOLETIN         VALUE 'S', 's'.
           05 WS-MODO-NOCTURNO    PIC X VALUE ' '.
              88 MODO-OSCURO            VALUE 'S', 's'.
       
       01  WS-CONTROL.
           05 WS-MENSAJE          PIC X(40) VALUE SPACES.

       SCREEN SECTION.
       01  PANTALLA-AVANZADA.
           05 BLANK SCREEN.
           05 LINE 02 COL 15 VALUE " CONFIGURACION DE USUARIO ".
           05 LINE 03 COL 15 VALUE "--------------------------".
           
           *> Simulación de Checkbox 1
           05 LINE 06 COL 10 VALUE "[ ] Aceptar Terminos y Condiciones (S/N)".
           05 LINE 06 COL 11 PIC X TO WS-TERMINOS.
           
           *> Simulación de Checkbox 2
           05 LINE 08 COL 10 VALUE "[ ] Deseo recibir publicidad por email".
           05 LINE 08 COL 11 PIC X TO WS-BOLETIN.
           
           *> Simulación de Checkbox 3
           05 LINE 10 COL 10 VALUE "[ ] Activar Modo Oscuro al iniciar".
           05 LINE 10 COL 11 PIC X TO WS-MODO-NOCTURNO.

           05 LINE 14 COL 10 VALUE "Mensaje: ".
           05 LINE 14 COL 19 PIC X(40) FROM WS-MENSAJE.
           
           05 LINE 16 COL 15 VALUE "Presione ENTER para confirmar".

       PROCEDURE DIVISION.
       100-CICLO-VALIDACION.
           PERFORM UNTIL TERMINOS-ACEPTADOS
               DISPLAY PANTALLA-AVANZADA
               ACCEPT  PANTALLA-AVANZADA
               
               IF NOT TERMINOS-ACEPTADOS
                   MOVE "ERROR: DEBE MARCAR LOS TERMINOS CON 'S'" 
                        TO WS-MENSAJE
               END-IF
           END-PERFORM.

       200-FINALIZAR.
           MOVE "CONFIGURACION GUARDADA EXITOSAMENTE" TO WS-MENSAJE.
           DISPLAY PANTALLA-AVANZADA.
           STOP RUN.
           