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
  
  C:\GC32\COBOL
 ├── SRC   ← programas COBOL (.cob)
 ├── CPY   ← copybooks (.cpy)
 ├── OBJ   ← objetos intermedios (opcional)
 └── BIN   ← ejecutables (.exe)
      └── DAT   ← archivos de datos (.dat, .idx)

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
