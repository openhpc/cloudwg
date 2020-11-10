---
title: Dev. Environment
layout: default
parent: Exercise 3
grand_parent: SC 2020 Tutorial
nav_order: 1
---

### Development Environment

OpenHPC endeavors to include a consistent set of variables for
accessing elements of installed packages. In particular, many development
packages provide a set of header files, one or more runtime libraries, and
potentially, some number of pre-built binaries. The OpenHPC
modulefiles set environment variables based on the package name to map
to the top-level path of each package installation along with the
location of include files, binaries, and libraries.

The `module show` command is a quick way to indicate which variables
are set by a particular module.  Run this command for the [PETSc
parallel library](https://www.mcs.anl.gov/petsc/) package visible in
your current modules hierarchy:

~~~~console
$ module load petsc
$ module show petsc
-------------------------------------------------------------------------------------------
   /opt/ohpc/pub/moduledeps/gnu9-mpich/petsc/3.13.1:
-------------------------------------------------------------------------------------------
whatis("Name: petsc built with gnu9 compiler and mpich MPI ")
whatis("Version: 3.13.1 ")
whatis("Category: runtime library ")
whatis("Description: Portable Extensible Toolkit for Scientific Computation ")
whatis("http://www.mcs.anl.gov/petsc/ ")
depends_on("phdf5")
depends_on("scalapack")
prepend_path("PATH","/opt/ohpc/pub/libs/gnu9/mpich/petsc/3.13.1/bin")
prepend_path("INCLUDE","/opt/ohpc/pub/libs/gnu9/mpich/petsc/3.13.1/include")
prepend_path("LD_LIBRARY_PATH","/opt/ohpc/pub/libs/gnu9/mpich/petsc/3.13.1/lib")
setenv("PETSC_DIR","/opt/ohpc/pub/libs/gnu9/mpich/petsc/3.13.1")
setenv("PETSC_BIN","/opt/ohpc/pub/libs/gnu9/mpich/petsc/3.13.1/bin")
setenv("PETSC_INC","/opt/ohpc/pub/libs/gnu9/mpich/petsc/3.13.1/include")
setenv("PETSC_LIB","/opt/ohpc/pub/libs/gnu9/mpich/petsc/3.13.1/lib")
help([[ 
This module loads the PETSc library built with the gnu9 compiler
toolchain and the mpich MPI stack.
 

Version 3.13.1
~~~~

Note how this modulefile sets four PETSC related paths:

* `PETSC_DIR`      (path to top-level installation)
* `PETSC_BIN`      (path to PETSc-related binaries)
* `PETSC_INC`      (path to PETSc-related header files)
* `PETSC_LIB`      (path to PETSc-related runtime libraries for linkage)

This convention is similar for other packages across the development
environment. While specific compilation instructions using available
libraries in OpenHPC will differ, you may find it convenient to
leverage these available environment variables in your own build system or on the command line.

---

#### Build an example with PETSc

Let us now use several of the environment variables mentioned above to
build a working example with PETSc, a popular linear algebra
library. To begin, copy the source code for a C example housed within
`$PETSC_DIR` into your current directory. This example solves a linear
system arising from a simple 5-point stencil (in parallel).

```
$ cp $PETSC_DIR/share/petsc/examples/src/ksp/ksp/tutorials/ex12.c 
```

To compile, we need to resolve a `petscksp.h` header file and also
link against `libpetsc.so`.  An example compilation using the module
provided variables is as follows:

```
$ mpicc -O3 -o ex12 -I$PETSC_INC ex12.c -L$PETSC_LIB -lpetsc -lm
```

Next, let's run this binary on a single node for two processor
counts. Begin by requesting an interactive job. We will only ask for 1
task, but since the compute hosts are configured for exclusive usage,
you will be able to run multiple tasks on the node:


~~~~console
$ srun -n 1 --pty /bin/bash
~~~~

The above should give you an interactive shell on the assigned compute
node. Now, let's run the PETSc binary serially. We will provide
additional command-line options to set the overall matrix dimensions, enable detailed profiling data,
and use a conjugate-gradient solver.

```
$ mpiexec -n 1 ./ex12 -n 900 -m 900 -log_view -ksp_type cg
```

If successful, you should se detailed profiling information. Take note of the linear solver time denoted as `KSPSolve`. For example:

```
KSPSolve               1 1.0 1.3239e+01 1.0 2.16e+10 1.0 0.0e+00 0.0e+00 0.0e+00 98100  0  0  0  98100  0  0  0  1635
```

The 4th column contains the wallclock time for the solve step (13.2 secs in the above example).

Now, repeat the same process using 2 cores and take note of the runtime required for `KSPSolve`:

```
$ mpiexec -n 2 ./ex12 -n 900 -m 900 -log_view -ksp_type cg
```


*What is going on here?*


