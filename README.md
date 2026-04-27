# Parallel Programming with OpenMP

Parallel implementation in C using **OpenMP** (Open Multi-Processing), a shared-memory API for multi-threaded programming based on compiler directives (`#pragma omp`).

> Developed by **Javier González Fortes** and **Jose Victoria González** — University of Almería, Computer Science Dept.

---

## What is OpenMP?

OpenMP allows parallelizing C/C++/Fortran programs by annotating loops and regions with `#pragma omp` directives. All threads share the same memory space, which simplifies data sharing but requires careful handling of race conditions.

Key concepts used in this project:

- `#pragma omp parallel for` — distributes loop iterations across threads
- `#pragma omp critical` / reductions — safe handling of shared variables
- Thread-local random number generators (`lrand48_r`) — one independent sequence per thread
- Loop unrolling — avoids race conditions without critical sections by ensuring threads always work on non-adjacent cells

---

## Requirements

- GCC with OpenMP support (`-fopenmp`)
- Any standard Linux distribution

```bash
# Verify OpenMP is available
gcc -fopenmp --version
```

---

## Build

```bash
make
```

To clean build artifacts:

```bash
make clean
```

---

## Usage

```bash
./program [options]
./program -h    # Show available parameters
```

Run the benchmark script to test with different thread counts:

```bash
bash Run.sh
```

---

## Parallelization strategy

The sequential version serves as the baseline reference. The parallel version targets the most computationally expensive loop, distributing iterations across threads with OpenMP.

To control the number of threads at runtime:

```bash
# Via environment variable
export OMP_NUM_THREADS=4
./program [options]

# Or via argument (if supported)
./program -nt 4 [options]
```

### Scheduling

The `schedule` clause controls how iterations are assigned to threads:

| Clause | Behavior |
|---|---|
| `static` | Equal chunks assigned upfront — best when workload is uniform |
| `dynamic` | Iterations assigned on demand — best when workload varies |
| `guided` | Decreasing chunk sizes — balances overhead and flexibility |

### Avoiding race conditions

When threads operate on data structures where neighboring elements interact, loop unrolling ensures that each thread always works on cells that are at least 2 positions apart, eliminating the need for critical sections and maximizing parallel efficiency.

---

## Project structure

```
.
├── program.c          # Sequential reference implementation
├── program-OMP.c      # OpenMP parallel implementation
├── argshand.c / .h    # Command-line argument parsing
├── getmem.c / .h      # Memory allocation utilities
├── utils.c / .h       # Helper functions
├── makefile           # Build system
└── Run.sh             # Benchmark script
```

---

## Performance

Speedup is measured against the sequential version under identical conditions (same input size, no graphical output, fixed random seeds when applicable).

| Threads | Time (s) | Speedup |
|---------|----------|---------|
| Seq     | —        | 1.00    |
| 2       | —        | —       |
| 4       | —        | —       |

> Results depend on hardware. Tested on an Intel Core i5-12450H (4 cores, VM with 4 vCPUs, 4 GB RAM).

---

## Notes

- Disable graphical output when benchmarking — I/O dominates execution time
- Set `PRINT=0` in the source before compiling for clean timing results
- Compile without `-g` or `-pg` flags when measuring performance
