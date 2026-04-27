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

La versión secuencial sirve como referencia de base
