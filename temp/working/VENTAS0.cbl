       IDENTIFICATION DIVISION.
       PROGRAM-ID. VENTAS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 RESPUESTA PIC X.

       PROCEDURE DIVISION.
       MAIN.

           DISPLAY SPACE ERASE SCREEN

           *> ENCABEZADO
           DISPLAY "SIESA 8.5"                     AT LINE 1 COL 2
           DISPLAY "UCVE5044.21 GENERACION ARCHIVO PLANO FACTURACION ELECTRONICA"
                                                   AT LINE 2 COL 2
           DISPLAY "SEPTIEMBRE 09, 2020"           AT LINE 1 COL 65
           DISPLAY "MASTER"                       AT LINE 2 COL 70

           *> MARCO SUPERIOR
           DISPLAY ALL "=" AT LINE 3 COL 1

           *> MENSAJE USUARIO
           DISPLAY "Sr Usuario."                  AT LINE 5 COL 4
           DISPLAY "Este proceso genera un archivo plano de facturacion electronica."
                                                   AT LINE 6 COL 4

           *> TITULO PARAMETROS
           DISPLAY ALL "-"                        AT LINE 8 COL 2
           DISPLAY "[ PARAMETROS DE SELECCION ]"  AT LINE 9 COL 25
           DISPLAY ALL "-"                        AT LINE 10 COL 2

           *> PARAMETROS IZQUIERDA
           DISPLAY "Empresa        :"             AT LINE 12 COL 4
           DISPLAY "C.O.            :"             AT LINE 13 COL 4
           DISPLAY "Tipo Documento  :"             AT LINE 14 COL 4
           DISPLAY "Numero Inicial  :"             AT LINE 15 COL 4
           DISPLAY "Numero Final    :"             AT LINE 16 COL 4
           DISPLAY "Fecha Inicial   :"             AT LINE 17 COL 4
           DISPLAY "Fecha Final     :"             AT LINE 18 COL 4

           *> PARAMETROS DERECHA
           DISPLAY "PRUEBAS HCM FE"                AT LINE 12 COL 25
           DISPLAY "001  SALA NORTE"               AT LINE 13 COL 25
           DISPLAY "FE  FACTURA ELECTRONICA DE VENTA"
                                                   AT LINE 14 COL 25
           DISPLAY "010033"                        AT LINE 15 COL 25
           DISPLAY "010033"                        AT LINE 16 COL 25

           *> PIE
           DISPLAY ALL "="                        AT LINE 20 COL 1

           *> CONFIRMACION
           DISPLAY "Es Correcto [S/N] ?"           AT LINE 22 COL 30
           ACCEPT RESPUESTA                       AT LINE 22 COL 52

           STOP RUN.
