      ******************************************************************
      * Author:  JOSE DANIEL GRIJALBA
      * Date:    12/22/2025
      * Purpose: LEARN
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ENTRY-LEVEL.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *     COPY "./clients.sel"
           SELECT OPTIONAL CLIENTS ASSIGN TO "./clients.dat"
                  ORGANIZATION IS INDEXED
                  ACCESS MODE IS DYNAMIC
                  RECORD KEY IS CLI-ID
                  ALTERNATE KEY CLI-NAME   WITH DUPLICATES
                  ALTERNATE KEY CLI-ALT-2  WITH DUPLICATES
                  STATUS ST-FILE.
       DATA DIVISION.
       FILE SECTION.
      *     COPY "./clients.fd"
       FD CLIENTS.
       01 REG-CLIENTS.
           03 CLI-ID             PIC 99.
           03 CLI-NAME           PIC X(60).
           03 CLI-AGE            PIC 999.
           03 CLI-BALANCE        PIC S9(7)V9(3).
           03 CLI-ADDRESS        PIC X(80).
           03 CLI-CATEGORY       PIC X.

           03 CLI-ALT-2.
               05 CLI-CATEGORY-2  PIC X.
               05 CLI-NAME_2     PIC X(60).

          03 CLI-STATE PIC X.
              88 ACTIVE   VALUE "A".
              88 INACTIVE VALUE "I".

           03 FILLER               PIC X(240).
       WORKING-STORAGE SECTION.
       01  ST-FILE    PIC XX.

       01 CLIENT.
           05 W-CLI-ID     PIC 99.
           05 W-CLI-NAME   PIC X(70).
           05 W-CLI-AGE    PIC 999.
           05 W-CLI-STATE PIC X.
               88 ACTIVE   VALUE "A".
               88 INACTIVE VALUE "I".

       01  GUIONES    PIC X(80) VALUES ALL "-".
       01  MENSAJE    PIC X(70).
       01  FIN        PIC X     VALUES "N".

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           PERFORM OPEN-FILE.
           PERFORM TASK THRU F-TASK UNTIL FIN = "S".

       OPEN-FILE.
           OPEN I-O CLIENTS.
           IF ST-FILE > "07"
             STRING "Error al abrir Clientes " ST-FILE DELIMITED BY SIZE
                     INTO MENSAJE
              DISPLAY MENSAJE LINE 10 COL 20
              MOVE "S" TO FIN.

       TASK.
           PERFORM MOSTRAR-MENU.

       F-TASK.
           EXIT.

       MOSTRAR-MENU.
           DISPLAY " "                           LINE 1  COL 1 ERASE EOS
                   "        ENTRY-LEVEL       "  LINE 3  COL 32
                   GUIONES                       LINE 4  COL 1
                   "1 - Mostrar nombre cliente"  LINE 7  COL 10
                   "2 - Cambiar nombre: "        LINE 8  COL 10
                   "3 - Cambiar edad  : "        LINE 9  COL 10
                   "4 - Salir"                   LINE 10  COL 10.

       END PROGRAM ENTRY-LEVEL.
