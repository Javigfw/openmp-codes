# Ejercicio: Bandera OMP.

# A rellenar por el alumno/grupo
## Nombre y apellidos alumno 1   : < Jose Victoria González >
## Nombre y apellidos alumno 2   : < Javier González Fortesr >
## Nombre y apellidos alumno 3   : < .... >
## Mayoría en GTA1, GTA2 o GTA3  : < GTA1 >
## Nombre de grupo de actividades: < GT3_08 >


# Descripción de la arquitectura utilizada:
## Arquitectura: 
  * Microprocesador: Intel(R) Core(TM) i5-10500 CPU @ 3.10GHz
  * Número de núcleos: 6
  * Cantidad de subprocesos por nucleo: 2
  * Tiene hyperthreading (SMT) activado en BIOS: Si
  * HDD/SDD: 96 GB
  * RAM: 16 GB
  * Se usa máquina virtual: No
    - Número de cores:
    - RAM: 
    - Capacidad HDD: 

## Instrucciones:

El ejemplo muestra como generar una imagen RGB de la bandera de España.

Los parámetros de anchura y altura se introducen por la línea de comandos.

La memoria se asigna de forma dinámica. Aunque se podría escribir directamente en el fichero de salida, se usan tres matrices (R, G y B) para generar los colores RGB de cada pixel.

Se pedirá al alumno que *decore* el programa con directivas OpenMP de forma que los colores ppRed, ppGren y ppBlue de cada pixel puedan calcularse en paralelo con varias hebras. 

El programa podrá ejecutarse en 
  * secuencial al compilarse con gcc  y 
  * en paralelo, al compilarse con gcc -fopenmp y distinto número de hebras.

En el makefile ya se ha puesto el flag OMP. 

Como tamaño de la bandera, se usarán los indicados en las tablas de la entrega. Se puede cambiar el Run.sh para todas las versiones paralelas.

Hay que comparar los tiempos obtenidos con distinto número de hebras y con la versión secuencial.

Según los [consejos/trucos/gotchas](https://www.archer.ac.uk/training/course-material/2017/08/openmp-ox/) de EPCC:
  * En las regiones paralelas 
    - usad siempre **default(none)** y usad **private**, **share**, ... para las variables.
    - Es mejor que las variables sean locales a la región paralela.

### A tener en cuenta:
  * En el Run.sh hay que poner todas las ejecuciones con y sin salida gráfica.
  * Cuando se miden tiempos hay que quitar el PRINT=1 y poner PRINT=0, ya que la salida por pantalla consume mucho tiempo.
  * Si se usa portátil, hay medir tiempos con el portátil enchufado a la corriente ya que si no los cores reducen su rendimiento.
  * Si se miden tiempos hay que compilar sin el -g ni el -pg.
  * Hay que tener en cuanta la opción -o España. Es decir con y sin salida gráfica.
	- $Bandera-OMP -r 200 -c 300 -o España (genera España.png)
	- $Bandera-OMP -r 200 -c 300     (no genera España.png)
  * No se realizan dos ficheros fuentes con el código secuencial y el paralelo. Es el mismo fichero para la versión secuencial y paralela haciendo uso de #ifdef _OPENMP e #ifndef _OPENMP.
  * Al compilar no debe haber warnings.
  * La memoria consumida dependerá del tamaño de la imagen y el tipo de datos a almacenar por pixel. Hay que calcularla.
  * Hay que responder a las preguntas y argumentar los resultados.


## Librerias
Se necesita tener instalados los siguientes paquetes:
  * netpbm-progs (o netpbm) para los comandos del sistema rawtoppm y rawtopng.
  * eog para visualizar la imagen.
  * Normalmente, los comandos OpenMP no están en las man. Hay que instalarlos. Ver como en [OpenMP-man-pages](https://github.com/Shashank-Shet/OpenMP-man-pages).


## Objetivos
 * Familiarizar al alumno con 
    - El uso de OpenMP sobre bucles for. 
 * Como medir el tiempo consumido. 
    - Para el tiempo total se usará la parte real del comando ```$ time programa < parámetros > ``` en la consola. 
    - Para el tiempo consumido de alguna parte del programa: 
        + En secuencial: gettimeoftheday().
        + En paralelo omp_get_wtime(). Hay un ejemplo en OpenMP/solution/pi/pi2.c al descomprimir OpenMPsingle.tar.gz.

- - - 
## Compilación

```console 
$ make 
```

## Ayuda parámetros 
```console
$ ./Bandera-OMP -h
```

## Ejemplo de compilacion, establecer parámetros  y ejecución
 * En el script Run.sh
 * Ver las variables de entorno para OpenMP.

- - -

# Entrega:

## Speed-up Teórico:

1. **Describe la formula del speed-up o ganancia de velocidad teórica usando la ley de Amdahl (SpA), en términos del porcentaje del código secuencial a paralelizar y del porcentaje del código secuencial que no se va ha paralelizar.**

 * Para calcular SpA(p) solo se miden tiempos del programa secuencial.
 * SpA(p)= 1/(%T.CsPar/p+%T.CsnPar)
 * p = número de elementos de proceso.
 * Se miden en secuencial dentro del código (con gettimeofday()):
    - T.CsPar: Tiempo del código secuencial a paralelizar.
    - T.CsnPar: Tiempo del código secuencial que no se va ha paralelizar.
 * Se miden con la parte real de ```$ time programa < parámetros >  ```
    - T.Sec: Tiempo total del programa secuencial.
 * T.CsnPar = T.Sec - T.CsPar.
 * %T.CsPar = T.CsPar/T.Sec.
 * %T.CsnPar = T.CsnPar/T.Sec.

2. **¿Cuanto es el valor de SpA(p) si p=1?**
1, debido a que el número de hilos utilizado es 1 por lo que no existe aceleración mayor que 1
3. **¿Cuanto es el valor de SpA(p) si todo el código no es paralelizable?**
1, debido a que aunque tengamos muchos numeros de hilos, si no existe región en el código que se pueda paralelizar significa que solo puede ser ejecutada por un hilo al mismo tiempo,
por lo que volvemos a que la aceleración máxima es 1
4. **¿Cuanto es el valor de SpA(p) si se puede paralelizar todo el código?**
L aceleración máxima será del valor de p, ya que dependerá del número de hilos que pueden ejecutar las regiones paralelas al mismo tiempo


 * Hay que elegir un número de filas y columnas (Rows=Col) múltiplo de 1024 (n*1204, n>1) que haga que el programa secuencial tarde varios segundos y que no consuma toda la RAM.
 * Cada pixel necesita tres bytes, uno para cada color.
 * 1 kB =1024 bytes.

5. **¿Que valor de Rows=Col has elegido? ¿Cuanta memoria (Mem.) ocupa la imagen?** 
Hemos escogido n=23, entonces tendremos unos valores de Rows=Cols=23552, la imagen ocupa 1.664.090.112 bytes, mas o menos 1,7 GB

6. **Rellena la siguiente tabla para la versión secuencial sin salida gráfica.**

 * Hay que compilar sin -fopenmp (en el makefile). _OPENMP no estará definido.
 * Ejemplo de ejecución
```console 
$ time Bandera-OMP -r Rows -c Cols
```

T.CsPar:
El tiempo del código secuencial que será paralelizado: relleno de las matrices ppRed, ppGreen y ppBlue. Ya está en el código la medición del tiempo secuencial que se tarda en la parte del código a paralelizar (bucles que establecen los colores de la bandera) de forma interna en el programa secuencial.

* Se adjunta una hoja de cálculo para calcular SpA() y Sp(). Hay que rellenar los campos T.Sec, T.CsPar, T(p) y p. Se visualiza ejecutando:

```console 
$ oocalc Speed-up.ods
```


| Ejecución   | -r 1024 -r 1024 |-r Rows -c Cols | 
| ----------- | --------------- | -------------- |
| Mem.        |    3.145.728    | 1.664.090.112  |
|T.Sec        |      0,008      |     1.562      |
|T.CsPar      |    0.002656     |    1.09609     |
|SpA(2)       |1,19904076738609 |1,54050229053558|
|SpA(4)       |1,33155792276964 |2,11100336855051|



## Speed-up real Sp(p): 

7. **Describe la formula de la ganancia en velocidad o speed-up real, describiendo los términos utilizados.**
 
 * Sp(p)=T.Sec/T(p)
 * Donde:
    - T(p) : Tiempo total del programa paralelo con p elementos de proceso.

8. **Describe qué realiza el schedule(static) y qué chunk usa por defecto.**
El schedule define la forma de división de trabajo que se va a realizar con los hilos, si hablamos del static, entonces la carga de trabajo se repartirá equitativamente
entre los hilos. En cuanto al chunk, su tamaño se define en función del schedule seleccionado, como estamos en static y se realiza equitativamente tendremos un chunk de tamaño
num iteraciones/num hilos.
9. **Rellena la siguiente tabla para la versión paralela. Se usará schedule(static) sin establecer el chunk.** 

 * Incluir el código OMP (decorar el código). Ver **//TODO**.
 * Hay que compilar con -fopenmp (en el makefile). _OPENMP estará definido.
 * Hay que establecer la variable de entorno con el número de hebras. Por ejemplo, para p=4 sería:
```console
$ export OMP_NUM_THREADS=4 
```
 * Al compilarse con -fopenmp, no se mide internamente el tiempo del código secuencial a paralelizar. Solo se mide si _OPENMP no está definido.


| Ejecución   |-r 1024 -r 1024 |-r Rows -c Cols  | 
| ----------- | -------------- | --------------- |
|T(2)         |   0,003909565  |      1,299      |
|T(4)         |   0,006897487  |      0,931      |
|Sp(2)        |1.02618163154822|1,20246343341032 |
|Sp(4)        |1,15984270793116|1,67776584317938 |


10. **¿Es el SpA(p) distinto del SP(p)? ¿Porqué?**

Porque el SpA(p) calcula la aceleración máxima teórica dentro de nuestro problema, mientras que el Sp recoge la aceleración real que se produce

11. **Teóricamente, ¿Mejoraría el Sp() si se establece el tamaño del chunk en el  schedule(static,chunk)? ¿Y si se usa otro scheduler?**

Depende del problema en el que se realice, si la carga de trabajo es equitativa para todos los hilos, tendrá mejor eficiencia establecer tamaños estáticos, sin embargo si la carga de trabajo es desigual, tendrá mejor eficiencia utilizar otros scheduler como dynamic o guided.


12. **¿Qué hace el collapse(2) en la directiva OMP?**

Fusiona los dos bucles for de forma de que se paralelizan a la vez

13. **Rellena la siguiente tabla para la versión paralela con schedule(static) y collapse(2)**

| Ejecución   |-r 1024 -r 1024 |-r Rows -c Cols   | 
| ----------- | -------------- | ---------------- |
|T(2)         |  0,003480276   |  1,078191167     |
|T(4)         |  0,002837264   |  0,831488865     |
|Sp(2)        |1,23645567190648| 1,45891990320859 |
|Sp(4)        |1,51667486705502| 1,89178065902302 |

**14. ¿Mejora el Sp(p)? ¿Porqué?**
 * Incluye y compara la salida de los rendimientos ( ```$ perf stat -r 3 -ddd programa < parámetros >``` usando o no collapse (2). 

Si, el Sp(p) mejora debido a que se realiza una mejor paralelización de los bucles al realizar el collapse, esta diferencia se nota mas cuanto más grande es el tamañoclea


## Experimentos con salida gráfica (-o España): 

15. **Rellena la siguiente tabla para la ejecución secuencial con salida gráfica.**
 * Hay que compilar sin -fopenmp (en el makefile). _OPENMP no estará definido.
 * Ejemplo de ejecución (Rows=Cols se establecieron en el punto 5):
```console 
$ time Bandera-OMP -r Rows -c Cols -o España
```

| Ejecución   | -r 1024 -r 1024 |-r Rows -c Cols | 
| ----------- | --------------- | -------------- |
| Mem.        |    3.145.728    | 1.664.090.112  |
|T.Sec        |  0,091469629    | 33,586927951   |
|T.CsPar      |    0.00224      |   1,10577      |
|SpA(2)       |1,01239628775897 |1,01673682512371|
|SpA(4)       |1,01871040139836 |1,02531710163693|


16. **Rellena la siguiente tabla para la ejecución paralela con salida gráfica, con schedule(static) y sin collapse().**

| Ejecución   |-r 1024 -r 1024 |-r Rows -c Cols  | 
| ----------- | -------------- | --------------- |
|T(2)         |     0,105      |      47,1       |
|T(4)         |     0,104      |     46.571      |
|Sp(2)        |  0,871139324   |   0,713098258   |
|Sp(4)        |  0,879515663   |   0,721198341   |



16. **¿Porqué ahora el SpA() y Sp(p) son peores que en la tablas 6 y 9?** 
* Responde usando como argumentos los porcentajes de código paralelizable y no paralelizable.

Esto es debido a que el porcentaje de sección paralela de nuestro programa es mucho menor que la sección en serie, por lo tanto el hecho de tener que realizar una salida gráfica es una acción que se ejecuta en serie, por lo que nuestro programa tiene peor rendimiento debido a esto


17. **¿Porque SpA(p) y Sp(p) no mejoran sustancialmente al aumentar el tamaño de la imagen?**

Debido a que nuestro código en paralelo es menor al código en serie, por lo tanto no se puede llegar a conseguir una mejora tan significativa ya que el código en serie no va a mejorar en ningún caso, por lo que solo la sección paralela nos da margen de mejora, en conclusión, siempre vamos a tener que contar con el tiempo de la ejecución de la parte en serie, ya que ese tiempo no se puede mejorar por muchos hilos que tengamos.



18. **¿Has hecho un *make clean* y borrado todas los ficheros innecesarios (imágenes, etc) para la entrega antes de comprimir?**

Si

- - - 

### Como ver este .md 
En linux instalar grip:

```console 
$ pip install grip 
```

y ejecutar
```console
$ grip -b README.md
```

### Markdown cheat sheet

Para añadir información a este README.md:

[Markdown cheat sheet](https://www.markdownguide.org/cheat-sheet/)

- - -

&copy; [Leocadio González Casado](https://sites.google.com/ual.es/leo). Dpto, Informática, UAL.
