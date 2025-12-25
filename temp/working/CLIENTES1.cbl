>>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLIENTES.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS WS-KEY. *> Para capturar ESC, F10, etc.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       *> Variables para capturar los datos
       01  CLIENTE-DATA.
           05 ID-CLIENTE      PIC X(10) VALUE SPACES.
           05 NOMBRE          PIC X(30) VALUE SPACES.
           05 DIRECCION       PIC X(30) VALUE SPACES.
           05 COD-POSTAL      PIC X(10) VALUE SPACES.
           05 CATEGORIA       PIC X(10) VALUE SPACES.
       
       01  RESPUESTA          PIC X VALUE "S".
       01  WS-KEY             PIC 9(4). *> Almacena el código de la tecla presionada

       SCREEN SECTION.
       01 PANTALLA-SIESA.
           *> LIMPIEZA TOTAL CON AZUL
           05 BLANK SCREEN BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

           *> ENCABEZADO SUPERIOR
           05 LINE 1 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 1 COL 2  VALUE "TEST 8.5" 
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 1 COL 25 VALUE "        A.B.M   CLIENTES           "
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 LINE 1 COL 65 VALUE "SEPTIEMBRE 09, 2020" 
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 2 COL 2  VALUE "VERSION.01                  CREAR/EDITAR USUARIO"
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 2 COL 70 VALUE "   JD-TWINS   "
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

           *> RECUADRO DE PARAMETROS
           05 LINE 4 COL 2  VALUE "_______________________________[ PARAMETROS ]__________________________________"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           
           05 LINE 5 COL 4  VALUE "Id Cliente         :" BACKGROUND-COLOR 1.
           05 LINE 6 COL 4  VALUE "01 Nombre          :" BACKGROUND-COLOR 1.
           05 LINE 7 COL 4  VALUE "02 Direccion       :" BACKGROUND-COLOR 1.
           05 LINE 8 COL 4  VALUE "03 Cod. Postal     :" BACKGROUND-COLOR 1.
           05 LINE 9 COL 4  VALUE "04 Categoria       :" BACKGROUND-COLOR 1.

           *> INPUTS (Aquí es donde el cursor saltará automáticamente con ENTER)
           05 INP-ID        LINE 5 COL 25 PIC X(10) USING ID-CLIENTE  HIGHLIGHT.
           05 INP-NOM       LINE 6 COL 25 PIC X(30) USING NOMBRE      HIGHLIGHT.
           05 INP-DIR       LINE 7 COL 25 PIC X(30) USING DIRECCION   HIGHLIGHT.
           05 INP-COD       LINE 8 COL 25 PIC X(10) USING COD-POSTAL   HIGHLIGHT.
           05 INP-CAT       LINE 9 COL 25 PIC X(10) USING CATEGORIA   HIGHLIGHT.

           05 LINE 12 COL 2  VALUE "_______________________________________________________________________________"
              BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.

           *> PREGUNTA DE CONFIRMACION
           05 LINE 22 COL 35 VALUE "Es Correcto [S/N] ? ".
           05 CAMPO-RESP LINE 22 COL 55 PIC X USING RESPUESTA HIGHLIGHT.

           *> PIE DE PAGINA (GRIS)
           05 LINE 24 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.
           05 LINE 24 COL 55 VALUE "F10=Termina" 
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 24 COL 70 VALUE "<ESC>=Retorna" 
              BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           *> Habilita la captura de ESC (Código 2005) y otras teclas de función
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".

           PERFORM UNTIL WS-KEY = 2005 *> 2005 es el código estándar para ESC
               DISPLAY PANTALLA-SIESA
               ACCEPT PANTALLA-SIESA *> El cursor inicia en el primer campo de la sección
               
               *> Si presionó ESC durante el ACCEPT, salimos
               IF WS-KEY = 2005
                   EXIT PERFORM
               END-IF

               *> Lógica tras llenar los campos y confirmar con S
               IF RESPUESTA = "S" OR "s"
                   *> Aquí iría el guardado en archivos ABM
                   MOVE 2005 TO WS-KEY *> Forzamos salida tras éxito (opcional)
               END-IF
           END-PERFORM.

           EXIT PROGRAM.
           