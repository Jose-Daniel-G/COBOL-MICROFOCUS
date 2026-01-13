       01  WS-FILA        PIC 99.      *> Navegación y control de filas
       01  WS-FILA-INICIO PIC 99 VALUE 7.
       01  WS-FILA-MAX    PIC 99.
       01  WS-PUNTERO     PIC 99 VALUE 7.
       01  WS-INDICE      PIC 99 VALUE 1.

       01  WS-FIN-LISTA       PIC X VALUE "N".
           88 FIN-LISTA          VALUE "S".
           88 NO-FIN-LISTA       VALUE "N".

       01 WS-PAGINACION.
          05 WS-PAG-ACTUAL    PIC 999 VALUE 1.
          05 WS-IDS-INICIO    PIC 9(07) OCCURS 100 TIMES.

       01 WS-LINEA-PLANO PIC X(200).
       01 WS-PRIMER-REGISTRO PIC X VALUE "N".
          88 ES-PRIMER-REGISTRO VALUE "S".
          88 NO-ES-PRIMER-REGISTRO VALUE "N".
          