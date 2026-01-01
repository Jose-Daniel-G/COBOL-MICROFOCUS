cobc -x SRC\MENU85.cbl SRC\LISTADO.cbl SRC\CLIENTES.cbl SRC\CLIENTES-PROGRAM.cbl -I CPY -I FD -I FILES\SEL


Cuando domines CRUD:

🔹 Archivos con llaves alternas
🔹 Control de concurrencia (LOCK)
🔹 Pantallas formateadas (LINE/COL)
🔹 Modularización (CALL)
🔹 Logs de errores

🔜 FASES
1️⃣ Corregimos ACTUALIZAR sin UPDATE (versión final estable)✅
2️⃣ Pasamos a FASE 3: Clientes + Ventas + Factura
3️⃣ Pantallas tipo SIESA (SCREEN SECTION)

![menu](images/menu.png)
![menu](images/read.png)
![program](images/program.png)
```
*> 1. Compila los subprogramas como módulos dinámicos
*> 2. Compila el menú como el ejecutable principal
cobc -m -free PROGRAM.cbl CLIENTES.cbl
cobc -x -free MENU.cbl -o sistema.exe
```
```
cobc -x -free menu.cbl
cobc -x -free MENU.cbl CLIENTES.cbl PROGRAM.cbl LISTADO.cbl -o sistema.exec
cobc -x -free MENU85.cbl CLIENTES-PROGRAM.cbl CLIENTES.cbl LISTADO.cbl -o sistema.exec
```

ARCHIVOS COBOL
.CPY	
.FD	
.SEL

- ORDEN CORRECTO
   
<details open>
  <summary><b>📁 8.5version (Proyecto COBOL)</b></summary>
  <br>

  <details>
    <summary>📂 <b>CPY/</b> - Copybooks (Código reutilizable)</summary>
    <ul>
      <li><code>CLIENTES-FD.CPY</code></li>
      <li><code>UTILIDADES.CPY</code></li>
      <li><code>OTRO-UTIL.CPY</code></li>
    </ul>
  </details>

  <details>
    <summary>📂 <b>FD/</b> - File Descriptions reales</summary>
    <ul>
      <li><code>CLIENTES.FD</code></li>
    </ul>
  </details>

  <details>
    <summary>📂 <b>BIN/</b> - Ejecutables y Datos</summary>
    <details style="margin-left: 20px;">
      <summary>📁 <b>DAT/</b> - Archivos indexados/binarios</summary>
      <ul><li><code>CLIENTES.DAT</code></li></ul>
    </details>
  </details>

  <details>
    <summary>📂 <b>FILES/</b> - Archivos secuenciales</summary>
    <ul>
      <li><code>CLIENTES.TXT</code></li>
      <li><code>CLIENTES.CSV</code></li>
    </ul>
    <details style="margin-left: 20px;">
      <summary>📁 <b>SEL/</b> - Archivos de selección/control</summary>
      <ul><li><code>CLIENTES.SEL</code></li></ul>
    </details>
  </details>

  <details>
    <summary>📂 <b>SRC/</b> - Programas COBOL (.cob, .cbl)</summary>
    <ul>
      <li><code>PROGRAMA1.COB</code></li>
      <li><code>PROGRAMA2.COB</code></li>
      <li><code>MENU.COB</code></li>
    </ul>
  </details>

  <details>
    <summary>📂 <b>LIB/</b> - Librerías externas</summary>
    <ul>
      <li><code>LIBUTIL.CPY</code></li>
    </ul>
  </details>

</details>



CLIENTES.DAT   ← datos reales (persisten)
CLIENTES.FD    ← definición lógica (estructura - TABLA)
CLIENTES.SEL   ← cómo se accede
CLIENTES.CPY   ← copia reutilizable de estructuras

MAIN
 ├─ Inicializa entorno
 ├─ Abre archivos
 ├─ LOOP PRINCIPAL
 │   ├─ Muestra pantalla
 │   ├─ Carga datos
 │   └─ Navega (teclas)
 └─ Cierra archivos


:: por jose daniel JDGO en GnuCOBOL / Windows
set COB_SCREEN_EXCEPTIONS=Y
set COB_COPY_DIR=C:\GC32\cobol\CPY

:: new cmd to stay open if not started directly from cmd.exe window

Color	Código
Negro	 0
Azul	 1
Verde	 2
Cian	 3
Rojo	 4
Magenta	 5
Amarillo 6
Blanco	 7

- EJEMPLOS DE COPYBOOKS (.CPY)
   78 COLOR-ROJO  VALUE 4.
   

*> CODIGOS DE TECLAS (GnuCOBOL / Windows)
78 TECLA-ENTER      VALUE 0.
78 TECLA-ARRIBA     VALUE 2003.
78 TECLA-ABAJO      VALUE 2004.
78 TECLA-ESC        VALUE 2005.
78 TECLA-DERECHA    VALUE 2002.

(POSIBLE-PROBAR)
F1	1001 
F2	1002

*HABILITAR TECLAS*
```
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           SET ENVIRONMENT "COB_SCREEN_ESC"        TO "Y". *> Agrega esta línea específica
```
| Código | ✅ Estados “normales” (NO error)   |
| ------ | ----------------------------------- |
| `"00"` | Operación exitosa                   |
| `"02"` | Registro duplicado (según contexto) |
| `"04"` | Operación parcial                   |
| `"05"` | Archivo opcional no existe          |
| `"07"` | Fin de datos / condición esperada   |


| Código |❌Estados de ERROR REAL              |
| ------ | ------------------------------------|
| `"10"` | Fin de archivo (EOF)                |
| `"21"` | Registro no encontrado              |
| `"23"` | Clave inválida                      |
| `"30"` | Archivo no es el que se espera      |
| `"35"` | Archivo no existe                   |
| `"39"` | Archivo incompatible                |
| `"41"` | Archivo ya abierto                  |
| `"46"` | Archivo bloqueado                   |
