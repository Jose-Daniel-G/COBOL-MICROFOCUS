        
       01 TABLA-MESES-DATOS.
          05 FILLER PIC X(10) VALUE "ENERO     ".
          05 FILLER PIC X(10) VALUE "FEBRERO   ".
          05 FILLER PIC X(10) VALUE "MARZO     ".
          05 FILLER PIC X(10) VALUE "ABRIL     ".
          05 FILLER PIC X(10) VALUE "MAYO      ".
          05 FILLER PIC X(10) VALUE "JUNIO     ".
          05 FILLER PIC X(10) VALUE "JULIO     ".
          05 FILLER PIC X(10) VALUE "AGOSTO    ".
          05 FILLER PIC X(10) VALUE "SEPTIEMBRE".
          05 FILLER PIC X(10) VALUE "OCTUBRE   ".
          05 FILLER PIC X(10) VALUE "NOVIEMBRE ".
          05 FILLER PIC X(10) VALUE "DICIEMBRE ".
       
       01 TABLA-MESES REDEFINES TABLA-MESES-DATOS.
          05 NOMBRE-MES PIC X(10) OCCURS 12.


       01  WS-FECHA-TECNICA.
           05  WS-ANIO-T         PIC 9(4).
           05  WS-MES-T          PIC 9(2).
           05  WS-DIA-T          PIC 9(2).
           
       *> FORMATOS PARA VER FECHA
       01 WS-FECHA-TEXT.
          05 WS-MES-TXT          PIC X(10).
          05 WS-DIA-TXT          PIC 9(2).
          05 FILLER              VALUE ", ".
          05 WS-ANIO-TXT         PIC 9(4).

       01  WS-FECHA.
           05  WS-DIA-F          PIC 9(2).
           05  FILLER            VALUE "/".
           05  WS-MES-F          PIC 9(2).
           05  FILLER            VALUE "/".
           05  WS-ANIO-F         PIC 9(4).                       
