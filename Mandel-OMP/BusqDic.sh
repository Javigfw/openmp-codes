#!/usr/bin/env bash
# Búsqueda dicotómica mínima para schedule(dynamic,chunk)
# Ajusta estos 4 valores si cambias tamaños o hilos:
APP=./Mandel-OMP
ARGS="-r 1024 -c 1024 -mx -2 -my -2 -sx 4 -sy 4 -mi 100000"   # sin -o
P=4            # nº de hebras (tu VM: 2 vCPU -> 2)
NITER=1024     # iteraciones del bucle paralelo (si paralelizas filas => NITER = -r)

export OMP_NUM_THREADS=$P OMP_PROC_BIND=close OMP_PLACES=cores

measure(){  # devuelve el "real" en segundos
  OMP_SCHEDULE="dynamic,$1" /usr/bin/time -f "%e" -o .t $APP $ARGS >/dev/null 2>&1
  cat .t
}

min=1
max=$(( (NITER + P - 1) / P ))   # ceil(NITER/P)
t_min=$(measure $min)
t_max=$(measure $max)
echo "init  min=$min t=$t_min   |   max=$max t=$t_max"

while (( max - min > 1 )); do
  med=$(((min + max) / 2))
  t_med=$(measure $med)
  echo "step  med=$med t=$t_med   ||  [min=$min t=$t_min] [max=$max t=$t_max]"
  # Regla del enunciado:
  if awk "BEGIN{exit !($t_min < $t_max)}"; then
    max=$med; t_max=$t_med
  else
    min=$med; t_min=$t_med
  fi
done

# Elige el mejor de los extremos finales
best_chunk=$min; best_time=$t_min
awk "BEGIN{exit !($t_max < $best_time)}" && { best_chunk=$max; best_time=$t_max; }

echo "=== RESULTADO ==="
echo "chunk=$best_chunk   time=${best_time}s   (p=$P, dynamic)"

