# Programación paralela con OpenMP

Implementación paralela en C mediante **OpenMP** (Open Multi-Processing), una API de memoria compartida para la programación multihilo basada en directivas del compilador (`#pragma omp`).

> Desarrollado por **Javier González Fortes** y **José Victoria González** — Universidad de Almería, Departamento de Informática.

---

## ¿Qué es OpenMP?

OpenMP permite paralelizar programas en C/C++/Fortran mediante la anotación de bucles y regiones con directivas `#pragma omp`. Todos los subprocesos comparten el mismo espacio de memoria, lo que simplifica el intercambio de datos pero requiere un manejo cuidadoso de las condiciones de carrera.

Conceptos clave utilizados en este proyecto:

- `#pragma omp parallel for`: distribuye las iteraciones del bucle entre los subprocesos
- `#pragma omp critical` / reducciones — manejo seguro de variables compartidas
- Generadores de números aleatorios locales al subproceso (`lrand48_r`) — una secuencia independiente por subproceso
- Desenrollado de bucles — evita condiciones de carrera sin secciones críticas al garantizar que los subprocesos siempre trabajen en celdas no adyacentes

---

## Requisitos

- GCC con soporte para OpenMP (`-fopenmp`)
- Cualquier distribución estándar de Linux

```bash
# Verificar que OpenMP está disponible
gcc -fopenmp --version
```

---

## Compilación

```bash
make
```

Para limpiar los artefactos de compilación:

```bash
make clean
```

---

## Uso

```bash
./program [opciones]
./program -h    # Mostrar los parámetros disponibles
```

Ejecuta el script de benchmark para probar con diferentes números de subprocesos:

```bash
bash Run.sh
```

---

## Estrategia de paralelización

La versión secuencial sirve como referencia de base. La versión paralela se centra en el bucle que requiere mayor esfuerzo computacional, distribuyendo las iteraciones entre subprocesos mediante OpenMP.

Para controlar el número de subprocesos en tiempo de ejecución:

```bash
# Mediante variable de entorno
export OMP_NUM_THREADS=4
./program [opciones]

# O mediante un argumento (si es compatible)
./program -nt 4 [opciones]
```

### Programación

La cláusula `schedule` controla cómo se asignan las iteraciones a los subprocesos:

| Cláusula | Comportamiento |
|---|---|
| `static` | Bloques iguales asignados por adelantado — ideal cuando la carga de trabajo es uniforme |
| `dynamic` | Iteraciones asignadas bajo demanda — ideal cuando la carga de trabajo varía |
| `guided` | Tamaños de fragmentos decrecientes — equilibra la sobrecarga y la flexibilidad |

### Evitar condiciones de carrera

Cuando los subprocesos operan sobre estructuras de datos en las que interactúan elementos contiguos, el desenrollado de bucles garantiza que cada subproceso trabaje siempre con celdas separadas por al menos dos posiciones, lo que elimina la necesidad de secciones críticas y maximiza la eficiencia del paralelismo.

---

## Estructura del proyecto

```
.
├── program.c          # Implementación de referencia secuencial
├── program-OMP.c      # Implementación paralela OpenMP
├── argshand.c / .h    # Análisis de argumentos de la línea de comandos
├── getmem.c / .h      # Utilidades de asignación de memoria
├── utils.c / .h       # Funciones auxiliares
├── makefile           # Sistema de compilación
└── Run.sh             # Script de benchmark
```

---


## Notas

- Desactiva la salida gráfica durante las pruebas de rendimiento: la E/S es el factor que más influye en el tiempo de ejecución
- Establece `PRINT=0` en el código fuente antes de compilar para obtener resultados de tiempo precisos
- Compila sin las opciones `-g` o `-pg` al medir el rendimiento
