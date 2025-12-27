       01  TABLA-MESES-DATOS.
           05  FILLER PIC X(10) VALUE "ENERO".
           05  FILLER PIC X(10) VALUE "FEBRERO".
           05  FILLER PIC X(10) VALUE "MARZO".
           05  FILLER PIC X(10) VALUE "ABRIL".
           05  FILLER PIC X(10) VALUE "MAYO".
           05  FILLER PIC X(10) VALUE "JUNIO".
           05  FILLER PIC X(10) VALUE "JULIO".
           05  FILLER PIC X(10) VALUE "AGOSTO".
           05  FILLER PIC X(10) VALUE "SEPTIEMBRE".
           05  FILLER PIC X(10) VALUE "OCTUBRE".
           05  FILLER PIC X(10) VALUE "NOVIEMBRE".
           05  FILLER PIC X(10) VALUE "DICIEMBRE".

       01  TABLA-MESES REDEFINES TABLA-MESES-DATOS.
           05  NOMBRE-MES PIC X(10) OCCURS 12 TIMES.

       01  WS-FECHA-SISTEMA-TEC.
           05  WS-ANIO-TEC   PIC 9(4).
           05  WS-MES-TEC    PIC 9(2).
           05  WS-DIA-TEC    PIC 9(2).

       01  WS-FECHA-TEXTO.
           05  WS-DIA-TXT    PIC 9(2).
           05  FILLER        VALUE " DE ".
           05  WS-MES-TXT    PIC X(10).
           05  FILLER        VALUE " DE ".
           05  WS-ANIO-TXT   PIC 9(4).
           