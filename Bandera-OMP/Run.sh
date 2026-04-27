#!/bin/bash

#prevent threads migrating between cores
export export OMP_PROC_BIND=true
#set the number of threads
export OMP_NUM_THREADS=4

echo "Antes de compilar:"
echo "Secuencial: makefile sin -fopenmp"
echo "Paraleo:    makefile con -fopenmp" 

#######
make
time ./Bandera-OMP -r 1024 -c 1280 -o España 
eog España.png &
sleep 2
time ./Bandera-OMP -r 1200 -c 1920 -o España 

./Bandera-OMP -r 32768 -c 32768
time ./Bandera-OMP -r 32768 -c 32768
time ./Bandera-OMP -r 23552 -c 23552
./Bandera-OMP -r 23552 -c 23552 -o España
eog España.png
perf stat ./Bandera-OMP -r 1024 -c 1024
./Bandera-OMP -r 1024 -c 1024 -o España
make
export OMP_NUM_THREADS=2
time ./Bandera-OMP -r 23552 -c 23552
export OMP_NUM_THREADS=4
time ./Bandera-OMP -r 23552 -c 23552
export OMP_NUM_THREADS=2
perf stat ./Bandera-OMP -r 1024 -c 1024
export OMP_NUM_THREADS=4
perf stat ./Bandera-OMP -r 1024 -c 1024
make clean
make
perf stat ./Bandera-OMP -r 1024 -c 1024
make clean
make
export OMP_NUM_THREADS=2 
perf stat ./Bandera-OMP -r 1024 -c 1024
export OMP_NUM_THREADS=4
perf stat ./Bandera-OMP -r 1024 -c 1024
make clean
make
perf stat ./Bandera-OMP -r 1024 -c 1024
make clean
make
perf stat ./Bandera-OMP -r 23552 -c 23552
export OMP_NUM_THREADS=2 
perf stat ./Bandera-OMP -r 23552 -c 23552
perf stat -r 3 -ddd ./Bandera-OMP -r 1024 -c 1024
make clean
make
perf stat -r 3 -ddd ./Bandera-OMP -r 1024 -c 1024
make clean
make
perf stat ./Bandera-OMP -r 1024 -c 1024 -o España
perf stat ./Bandera-OMP -r 23552 -c 23552 -o España
make clean
make
export OMP_NUM_THREADS=4
perf stat ./Bandera-OMP -r 1024 -c 1024 -o España
export OMP_NUM_THREADS=2 
time ./Bandera-OMP -r 1024 -c 1024 -o España
export OMP_NUM_THREADS=4
time ./Bandera-OMP -r 1024 -c 1024 -o España
export OMP_NUM_THREADS=2 
time ./Bandera-OMP -r 23552 -c 23552 -o España
export OMP_NUM_THREADS=4
time ./Bandera-OMP -r 23552 -c 23552 -o España
make clean