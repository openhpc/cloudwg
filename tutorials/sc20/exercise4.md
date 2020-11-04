---
title: Exercise 4
layout: default
parent: SC 2020 Tutorial
nav_order: 6
---

# Exercise 4: OpenHPC and Containers
## Working with containers (45 mins)

In Exercise 4, we introduce HPC containers, demonstrate how to deploy HPC containers on an OpenHPC cluster and describe "real world" use cases of containers in a production HPC environment.

### Build HPC containers from Dockerfiles

#### On the Desktop or laptop (demonstrated) ####

1) Build docker image from Dockerfile

In the deirectory where the Dockerfile is located, execute the following command:

~~~

$ sudo docker build -t image_name .

~~~

View the new Docker image in your local Docker repository:

~~~

$ sudo docker build -t image_name .

REPOSITORY                             TAG                IMAGE ID                  CREATED             SIZE
image_name                            latest              02d6e22ec5ec              2 days ago         5.74GB
bash                                  latest              16463e0c481e              7 weeks ago         15.2MB
ubuntu                                16.04               7e87e2b3bf7a              7 months ago        117MB
hello-world                           latest              fce289e99eb9              8 months ago        1.84kB
debian                                stretch             de8b49d4b0b3              8 months ago        101MB

~~~

2) Convert docker image to charliecloud on desktop

~~~

$ sudo ch-builder2tar image /dir/to/save

~~~

This creates the file */dir/to/save/image_name.tar.gz*

4) Copy the tar.gz file to the hPC system

~~~

$ scp -i .ssh/id_rsa -r ./image_name.tar.gz centos@ec2-54-177-114-95.us-west-1.compute.amazonaws.com:~

~~~

#### On the HPC system (hands on) ####

5) Load the required modules

~~~

$ module load mpich
$ module load charliecloud

~~~

6) Unpack charliecloud archive on OHPC cloud

~~~

$ cd /home/centos/ContainersHPC
$ ch-tar2dir pico_quant.tar.gz .

~~~


### Simple container execution

1) Start a bash in the container

~~~

$ ch-run -w ./a408704d3f3d/ -- bash
$ ls
$ exit

~~~

2) Compile "hello world" mpi C program

~~~

$ ch-run -w a408704d3f3d -- mpicc -g -O3 -o /MPI_TEST/HelloWorld/mpi_hello_world /MPI_TEST/HelloWorld/mpi_hello_worl                                           d.c

~~~

3) Execute MPI "hello world"

~~~

$ mpiexec -n 2 ch-run -w ./a408704d3f3d/ -- /MPI_TEST/HelloWorld/mpi_hello_world

~~~

4) Execute distributed TensorFlow horovod (print out horovod ranks)

~~~

$ mpiexec -n 2 ch-run -w ./a408704d3f3d/ -- python /MPI_TEST/Horovod/simple_mpi.py

~~~


5) Mounting host directory /opt/ohpc in container

~~~

$ ch-run -w -b /opt/ohpc/.:/opt/ohpc/ ./a408704d3f3d/ -- bash

~~~

6) Set environment to docker environment

~~~
$echo $PATH
ch-run -w ./oneapi_hpc_mod -- bash
$ echo $PATH
$ exit
ch-run --set-env=./oneapi_hpc_mod/ch/environment -w ./oneapi_hpc_mod -- bash
$ echo $PATG
$ exit

$ ch-run --set-env=./oneapi_hpc_mod/ch/environment -w ./oneapi_hpc_mod -- bash

~~~

7) execute distributed TensorFlow example using mpiexec/mpirun via Slurm (need to start execution early due to time)

~~~

$ sbatch slurm_sc_tutorial_charliecloud.sh

~~~

8) Quantum computing simulator setup

~~~

$ ch-run --set-env=./pico_quant/ch/environment -w ./pico_quant -- bash
$ julia
$ using Pkg
$ Pkg.add("PicoQuant")
$ Pkg.activate("/PicoQuant")
$ Pkg.test("PicoQuant")
$ exit

~~~

### Gotchas, tips and "real world" examples

1) In your dockerfile avoid building your application and copying/storing your data in /home, as when executing the Charliecloud container the users /home directory will map to the containers /home directory and you will not be able to access the data the dockerfile build placed in /home.

2) Mount your data directory such as $SCRATCH and/or $WORK in the container to avoid storing your data in the container.

3) Use the system MPI environment (via mounting) when executing on a production HPC system.

4) Install the software/drivers of the high performance interconnects inside the container. the transport layer can default to TCP instead of using the high performance network.

5) Keep your container as small as possible. As creating the container is done on your laptop or desktop.

6) Use the HPC module system inside the container if possible for optimized, tested and/or licenced software.
