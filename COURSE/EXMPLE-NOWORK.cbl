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
           SELECT OPTIONAL CLIENTES ASSIGN TO "./clientes.dat"
                  ORGANIZATION INDEXED
                  ACCESS MODE IS DYNAMIC
                  RECORD KEY IS ID_CLIENTE
                  ALTERNATE KEY CLI_NOMBRE WITH DUPLICATES
                  ALTERNATE KEY CLI_ALT_2  WITH DUPLICATES
                  STATUS ST-FILE.

           SELECT ARCHIVO-CSV ASSIGN TO "./ventas.csv"
                  ORGANIZATION LINE SEQUENTIAL
                  STATUS ST-FILE.

       DATA DIVISION.
       FILE SECTION.

       FD CLIENTES.
       01 REG-CLIENTES.
           03 ID_CLIENTE.
               05 CLI_ID            PIC 9(8).
           03 CLI_SALDO            PIC S9(7)V9(3).
           03 CLI_NOMBRE           PIC X(60).
           03 CLI_DIRECCION        PIC X(80).
           03 CLI_CODPOST          PIC X(10).
           03 CLI_CATEGORIA        PIC X.
           03 CLI_ALT_2.
               05 CLI_CATEGORIA_2  PIC X.
               05 CLI_NOMBRE_2     PIC X(60).
           03 FILLER               PIC X(240).

       FD ARCHIVO-CSV.
       01 REGISTRO-CSV             PIC X(400).

       WORKING-STORAGE SECTION.
       01  ST-FILE    PIC XX.
       01  X          PIC X.

       01  MENSAJE    PIC X(70).
       01  FIN        PIC X     VALUES "N".
       01  EXISTE     PIC X.
       01  HUBO-ERROR PIC 9     VALUES 0.
       01  GUIONES    PIC X(80) VALUES ALL "-".
       01  OPCION     PIC 99.

       01  W-CLI-ID   PIC 9(07).
       01  W-CLI-ID-Z PIC Z(06)9.

       01  DATOS.
           02 W-CLI-NOMBRE        PIC X(70).
           02 W-CLI-NOMBRE-ANT    PIC X(70).
           02 W-CLI-DIRECCION     PIC X(80).
           02 W-CLI-CODPOST       PIC X(10).
           02 W-CLI-CATEGORIA     PIC X.

       01  FECHA-X.
           02 FECHA-TEXT          PIC X(08).
           02 FECHA9 REDEFINES FECHA-TEXT PIC 9(06).

       01  I                      PIC 99.
       01  CONTADOR-1             PIC 9(04).
       01  CONTADOR-2             PIC 9(04).
       01  TEXTO-CSV              PIC X(300).

       01  REG-CSV.
           02 CSV-FECHA           PIC X(08).
           02 CSV-IMPORTE         PIC X(10) JUST RIGHT.
           02 CSV-IMPORTE-9       REDEFINES CSV-IMPORTE PIC S9(7)V99.
           02 CSV-NROFACTURA      PIC 9(08).
           02 CSV-CLI-ID          PIC 9(08).

       LINKAGE SECTION.
           01 PARAMETROS.
               02 FECHA           PIC X(08).
               02 CATEGORIA       PIC X(05) JUST RIGHT.
               02 MONTO           PIC S9(06)V99.

       PROCEDURE DIVISION USING PARAMETROS.
       DECLARATIVES.

       MANEJO-ERROR SECTION.
           USE AFTER ERROR PROCEDURE CLIENTES ARCHIVO-CSV.

       END DECLARATIVES.

       JOSE SECTION.
           PERFORM VARYING I FROM 100  BY -1 UNTIL I = 0
           END-PERFORM.
      *-----------------------------------------------------------
           INITIALIZE REG-CLIENTES FECHA-X.

           INITIALIZE REG-CLIENTES
             REPLACING NUMERIC DATA BY ZERO
             ALPHANUMERIC DATA BY ALL "*".

           INITIALIZE REG-CLIENTES
             REPLACING NUMERIC DATA BY 100,00.

      *----------------------------------------
           MOVE ZERO TO CONTADOR-1, CONTADOR-2.
           INSPECT MENSAJE TALLYING
               CONTADOR-1 FOR LEADING "A" BEFORE INITIAL "L"
               CONTADOR-2 FOR LEADING "L" BEFORE INITIAL "A"

           MOVE ZERO TO CONTADOR-1
           INSPECT MENSAJE TALLYING
               CONTADOR-1 FOR ALL "L"  REPLACING
               ALL "A" BY "E" AFTER INITIAL "L".

           INSPECT MENSAJE REPLACING ALL "X" BY "Y",
                   "B" BY "Z", "W" BY "Q" AFTER INITIAL "R".

           INSPECT MENSAJE CONVERTING
            "abcdefghijklmnopqrstuvwxyz" TO
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
      *-----------------------------------------------
           CALL "CONSULTACLI" USING PARAMETROS.
           CANCEL "CONSULTACLI".
      *-----------------------------------------------
           READ ARCHIVO-CSV INTO TEXTO-CSV.

           UNSTRING TEXTO-CSV DELIMITED BY ";"
               INTO CSV-FECHA
                    CSV-IMPORTE
                    CSV-NROFACTURA
                    CSV-CLI-ID.


       END PROGRAM "JD-TWINS".
