      ******************************************************************
      * Author:  JOSE DANIEL GRIJALBA
      * Date:    12/23/2025
      * Purpose: LEARN
      * Tectonics: cobc
      ******************************************************************
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIESA-MENU-NAV.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS TECLA-STATUS.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  OPCION-CAPTURA    PIC X VALUE SPACE.
       01  TECLA-STATUS      PIC 9(4).
           88  FLECHA-DER    VALUE 2009.
           88  FLECHA-IZQ    VALUE 2010.
           88  TECLA-ENTER   VALUE 0.
       01  MODULO-ACTUAL     PIC 9 VALUE 2. *> 1:Finan, 2:Comer, 3:Manuf
       01  FECHA-SISTEMA     PIC X(15) VALUE "ENERO 08, 2025".
       01  OPCION-VENTANA    PIC X VALUE SPACE.
       
       SCREEN SECTION.
       *> --- BARRA SUPERIOR DINAMICA ---
       01  BARRA-SUPERIOR. 
       
           05 LINE 1 COL 1 VALUE " TEST 8.5 " BACKGROUND-COLOR 4 
                                                          FOREGROUND-COLOR 7.
                                                          
           05 LINE 1 COL 65 FROM FECHA-SISTEMA BACKGROUND-COLOR 4  
                                               FOREGROUND-COLOR 7.
          
           05 LINE 2 COL 1 PIC X(80) FROM ALL " " BACKGROUND-COLOR 7.   *> 2. LA BARRA DE MENÚ HORIZONTAL (Gris con letras rojas)
           
           
       *> --- MENU  ---
       01  MENU-COMERCIAL.
           05 LINE 03 COL 20 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 04 COL 20 VALUE "| Comercial                |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 05 COL 20 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 06 COL 20 VALUE "| C. Confrontacion         |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 07 COL 20 VALUE "| V. Verificacion          |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 08 COL 20 VALUE "| A. Actualizacion         |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 09 COL 20 VALUE "| R. Retiro                |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 10 COL 20 VALUE "| S. Salir al Menu Sup.    |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 11 COL 20 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 13 COL 20 VALUE "ACCION: [ ]" BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 SC-OPC-V LINE 13 COL 29 PIC X TO OPCION-VENTANA.  
       
       01  ESTRUCTURACION-BASICA.  
           05 LINE 03 COL 05 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 04 COL 05 VALUE "| Estructuracion           |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 05 COL 05 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 06 COL 05 VALUE "| Empresas                 |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 07 COL 05 VALUE "| Centros de operacion     |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 08 COL 05 VALUE "| Proyectos y unidades     |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 09 COL 05 VALUE "| Tipos de Documentos      |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 10 COL 05 VALUE "| S. Salir al Menu Sup.    |" BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
           05 LINE 11 COL 05 VALUE "+--------------------------+" BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
           05 LINE 13 COL 05 VALUE "ACCION: [ ]" BACKGROUND-COLOR 1 FOREGROUND-COLOR 7.
           05 SC-OPC-V LINE 13 COL 29 PIC X TO OPCION-VENTANA.
           
       01  MENU-CONFRONTACION. 
            05  GRUPO-VERDE BACKGROUND-COLOR 6 FOREGROUND-COLOR 7.*> Grupo con color Turquesa/Verde (Fondo 6 o 3 dependiendo del terminal)
            10 LINE 04 COL 45 VALUE "+-----------------------------+".
            10 LINE 05 COL 45 VALUE "| Confrontacion de Archivos   |".
            10 LINE 06 COL 45 VALUE "+-----------------------------+".
            10 LINE 07 COL 45 VALUE "| CMMAE vs CMMOVIN            |".
            10 LINE 08 COL 45 VALUE "| CMM E vs ARCHIVOS           |".
            10 LINE 09 COL 45 VALUE "|-----------------------------|".
            10 LINE 10 COL 45 VALUE "| CM STAD  vs CMMOVIN         |".
            10 LINE 11 COL 45 VALUE "| CM OCIN  vs CMMOVIN         |".
            10 LINE 12 COL 45 VALUE "| S. Salir a Comercial        |".
            10 LINE 13 COL 45 VALUE "+-----------------------------+".
            05  LINE 15 COL 45 VALUE "SELECCION: [ ]" BACKGROUND-COLOR 1.
            05  SC-OPC-CONF LINE 15 COL 57 PIC X TO OPCION-VENTANA.     
            
       PROCEDURE DIVISION.
       MAIN-LOGIC.
           DISPLAY " " LINE 1 COL 1 BLANK SCREEN BACKGROUND-COLOR 1. *> Borramos pantalla solo una vez al inicio
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-CAPTURA) = "S"
               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES

               *> El ACCEPT captura tanto la letra como la tecla especial (flecha)
               ACCEPT OPCION-CAPTURA LINE 24 COL 10

               EVALUATE TRUE
                   WHEN FLECHA-DER
                       IF MODULO-ACTUAL < 5
                          ADD 1 TO MODULO-ACTUAL
                       ELSE
                          MOVE 0 TO MODULO-ACTUAL
                       END-IF
                   WHEN FLECHA-IZQ
                       IF MODULO-ACTUAL > 0
                          SUBTRACT 1 FROM MODULO-ACTUAL
                       ELSE
                          MOVE 5 TO MODULO-ACTUAL
                       END-IF
                   WHEN TECLA-ENTER OR OPCION-CAPTURA NOT = SPACE
                       PERFORM PROCESAR-SELECCION
               END-EVALUATE

           END-PERFORM.
           STOP RUN.
           
       PROCESAR-SELECCION.
               
               EVALUATE FUNCTION UPPER-CASE(OPCION-CAPTURA)
                   WHEN "A" 
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 0 TO MODULO-ACTUAL
                       PERFORM DESPLEGAR-COMERCIAL
                   WHEN "E" 
                       PERFORM LIMPIAR-AREA-MENU                  
                       MOVE 1 TO MODULO-ACTUAL 
                       PERFORM DESPLEGAR-ESTRUCTURACION
                   WHEN "F" 
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 2 TO MODULO-ACTUAL
                       PERFORM DESPLEGAR-COMERCIAL
                   WHEN "C" 
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 3 TO MODULO-ACTUAL
                       PERFORM DESPLEGAR-COMERCIAL
                   WHEN "M" 
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 4 TO MODULO-ACTUAL
                       PERFORM DESPLEGAR-COMERCIAL
                   WHEN "D"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 5 TO MODULO-ACTUAL
                       PERFORM DESPLEGAR-COMERCIAL
               END-EVALUATE
           
           *> Ejecuta el despliegue según el módulo resaltado
           EVALUATE MODULO-ACTUAL
               WHEN 0 PERFORM DESPLEGAR-COMERCIAL
               WHEN 1 PERFORM DESPLEGAR-ESTRUCTURACION
               *> ... resto de módulos ...
           END-EVALUATE.
               
       DIBUJAR-OPCIONES. 
           
           IF MODULO-ACTUAL = 0         *> --- A ---
              DISPLAY "[A]" LINE 2 COL 2
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY "[" LINE 2 COL 2 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
              DISPLAY "A" LINE 2 COL 3 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "]" LINE 2 COL 4 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.
               
           
           IF MODULO-ACTUAL = 1         *> --- Estructura basica ---
              DISPLAY "[E]" LINE 2 COL 5
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY "[" LINE 2 COL 5 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
              DISPLAY "E" LINE 2 COL 6 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "]" LINE 2 COL 7 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.
               
       
           IF MODULO-ACTUAL = 2        *> --- OPCION FINANCIERO ---
              DISPLAY " Financiero " LINE 2 COL 10
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 10 BACKGROUND-COLOR 7
              DISPLAY "F" LINE 2 COL 11 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "inanciero" LINE 2 COL 12 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.


           IF MODULO-ACTUAL = 3           *> --- OPCION COMERCIAL ---
              DISPLAY " Comercial "  LINE 2 COL 23
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 23 BACKGROUND-COLOR 7
              DISPLAY "C" LINE 2 COL 24 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "omercial" LINE 2 COL 25 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.


           IF MODULO-ACTUAL = 4           *> --- OPCION MANUFACTURA ---
              DISPLAY " Manufactura " LINE 2 COL 35
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 35 BACKGROUND-COLOR 7
              DISPLAY "M" LINE 2 COL 36 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "anufactura" LINE 2 COL 37 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.

           IF MODULO-ACTUAL = 5
              DISPLAY " Admon " LINE 2 COL 40
                      BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
              DISPLAY " " LINE 2 COL 47 BACKGROUND-COLOR 7
              DISPLAY "A" LINE 2 COL 48 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
              DISPLAY "d" LINE 2 COL 49 BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
              DISPLAY "mon" LINE 2 COL 50 BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.
               
       LIMPIAR-AREA-MENU.
           DISPLAY " " LINE 3 COL 1 ERASE EOS BACKGROUND-COLOR 1. *> Limpia de la linea 3 hacia abajo      
           
       DESPLEGAR-COMERCIAL.
           MOVE SPACE TO OPCION-VENTANA.
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
               
               DISPLAY BARRA-SUPERIOR   *> Redibujamos barra para mantener el resaltado negro
               PERFORM DIBUJAR-OPCIONES *> ESTA ES LA CLAVE: Volver a dibujar para que no se borre
               DISPLAY MENU-COMERCIAL
               ACCEPT MENU-COMERCIAL
               
               EVALUATE FUNCTION UPPER-CASE(OPCION-VENTANA)
                   WHEN "C"
                       PERFORM DESPLEGAR-CONFRONTACION 
                   WHEN "H"
                       DISPLAY "ABRIENDO CONFRONTACION..." LINE 15 COL 20
                       ACCEPT OPCION-VENTANA                       
                   WHEN "S"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 0 TO MODULO-ACTUAL
                       EXIT PERFORM
               END-EVALUATE
           END-PERFORM.
               
       DESPLEGAR-ESTRUCTURACION.        
           MOVE SPACE TO OPCION-VENTANA.
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
               
               DISPLAY BARRA-SUPERIOR   *> Redibujamos barra para mantener el resaltado negro
               PERFORM DIBUJAR-OPCIONES *> ESTA ES LA CLAVE: Volver a dibujar para que no se borre              
               DISPLAY ESTRUCTURACION-BASICA
               ACCEPT ESTRUCTURACION-BASICA
               
               EVALUATE FUNCTION UPPER-CASE(OPCION-VENTANA)
                   WHEN "C"
                       DISPLAY "ABRIENDO CONFRONTACION..." LINE 15 COL 20
                       ACCEPT OPCION-VENTANA
                   WHEN "S"
                       PERFORM LIMPIAR-AREA-MENU
                       MOVE 0 TO MODULO-ACTUAL
                       EXIT PERFORM
               END-EVALUATE
           END-PERFORM.           
               
       DESPLEGAR-CONFRONTACION.
         MOVE SPACE TO OPCION-VENTANA.
         PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
             *> Mantenemos visibles los niveles anteriores
             DISPLAY BARRA-SUPERIOR 
             PERFORM DIBUJAR-OPCIONES
             DISPLAY MENU-COMERCIAL
             
             *> Mostramos el nuevo nivel a la derecha
             DISPLAY MENU-CONFRONTACION
             ACCEPT MENU-CONFRONTACION
             
             EVALUATE FUNCTION UPPER-CASE(OPCION-VENTANA)
                 WHEN "C"
                     DISPLAY "PROCESANDO CMMAE..." LINE 17 COL 45
                     ACCEPT OPCION-VENTANA
             END-EVALUATE
         END-PERFORM.
         *> Limpiamos solo el área del menú verde al salir
         DISPLAY " " LINE 4 COL 45 ERASE EOS BACKGROUND-COLOR 1
