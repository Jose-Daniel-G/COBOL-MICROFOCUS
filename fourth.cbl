      ******************************************************************
      * Author:
      * Date:
      * Purpose:
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. "JD-TWINS".
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            COPY "./sel/clientes.sel"
       DATA DIVISION.
       FILE SECTION.
            COPY "./fd/clientes.fd"

       WORKING-STORAGE SECTION.
       01  ST-FILE    PIC XX.
       01  X          PIC X.

       01  MENSAJE    PIC X(70).
       01  FIN        PIC X VALUES "N".
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INICIALIZACION.
           PERFORM ABRO-ARCHIVO.
           PERFORM PROCESO UNTIL FIN = "S".
           PERFORM CIERRO-ARCHIVO.
           GO TO FINALIZAR.

       INICIALIZACION.
           MOVE "N" TO FIN.
       ABRO-ARCHIVO.
           OPEN I-O CLIENTES.
           IF ST-SIC > "07"
              STRING "Error al abrir Clientes " ST-SIC DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20
              MOVE "S" TO FIN.

       CIERRE-ARCHIVO.
           CLOSE CLIENTES.

       FINALIZAR.
           EXIT PROGRAM.
       END PROGRAM "JD-TWINS".
