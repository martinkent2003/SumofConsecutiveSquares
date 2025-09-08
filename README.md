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

### Work Unit:1,000
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
Here we can see that the very low work unit takes a lot more scheduling and messaging overhead resulting in more time required than the following units.
 
### Work Unit:10,000
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
Much faster thatn 1,000, clear reduction in overhead.

### 100_000 Work Unit Case:
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
### 1_000_000 Work Unit Case:

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
Now the time is starting to increase, showing that the decrease in distribution of work to actors or parallelism is impacting the perfomance negatively.

## CPU TIME : REAL TIME
The CPU TIME = USER + SYS time (user space + kernel space)
FOr the examples above we can see that the ratio of CPU Time to Real Time is not near 1:1 and we have parallelism working.


## Largest Problem
```sh
$ time gleam run 1000000000 24
   Compiled in 0.04s
    Running main.main
12602701
3029784
3500233
342988229
8329856
296889028
124753981
1
9
20
25
44
76
121
197
304
353
540
856
1301
2053
3112
3597
5448
8576
12981
20425
30908
35709
54032
84996
128601
202289
306060
353585
534964
841476
5295700
196231265
1273121
2002557
34648837
19823373
82457176
52422128
29991872
518925672
816241996

real    1m14.110s
user    0m0.030s
sys     0m0.140s
```
