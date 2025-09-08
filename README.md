# Sum of Consecutive Squares Actor Model Project 

Project implementing the Actor model using Gleam, to find consecutive squares that add up to a perfect square by distributing the work across multiple workers with a set work unit.

#To test out the impact of the work unit on performance we tested with the command:
```sh
time gleam run 10000000 4
```
The work unit is hard coded as a const and printed first.
For the purpose of testing we used workunits [1_000, 10_000, 100_000, 1_000_000]

For reference:
real = wall clock time(real time)
user = CPU time in user space
sys = CPU time in kernel space

```sh
$ time gleam run 10000000 2
  Compiling main
   Compiled in 0.44s
    Running main.main
WorkUnit: 1000
23660
3
20
119
696
137903
4059
803760
4684659

real    0m4.708s
user    0m0.062s
sys     0m0.061s
```


```sh
$ time gleam run 10000000 2
  Compiling main
   Compiled in 0.46s
    Running main.main
WorkUnit: 10000
803760
23660
3
20
119
696
4059
137903
4684659

real    0m1.276s
user    0m0.045s
sys     0m0.031s
```
###10_000 Work Unit Case:
Real Time 

```sh
$ time gleam run 10000000 2
  Compiling main
   Compiled in 0.47s
    Running main.main
WorkUnit: 100000
137903
803760
3
20
119
696
4059
23660
4684659

real    0m1.277s
user    0m0.045s
sys     0m0.077s

```

```sh
$ time gleam run 10000000 2
  Compiling main
   Compiled in 0.45s
    Running main.main
WorkUnit: 1000000
3
20
119
696
4059
23660
137903
803760
4684659

real    0m1.332s
user    0m0.062s
sys     0m0.046s
```
### 
## CPU TIME : REAL TIME

U



## Largest Problem

```sh
```
