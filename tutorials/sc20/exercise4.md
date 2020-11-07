---
title: Exercise 4
layout: default
parent: SC 2020 Tutorial
nav_order: 6
---

# Exercise 4: OpenHPC and Containers

In this exercise we will be working with containers. 
[Containers](https://en.wikipedia.org/wiki/OS-level_virtualization) are an OS-level virtualization paradigm that allow multiple, isolated user environments to run concurrently.
There are several different container technologies that address a variety of use cases and 
due to the [Open Container Initiative](https://opencontainers.org/) (OCI), we can convert containers from one format to another.

The first container technology that most people learn is [Docker](https://www.docker.com/).
Docker is designed in such a way that the IAM model does not map well to HPC systems.
That is, you must have escalated privledges (root) in order to use docker.
Because of this, most HPC systems do not support Docker.

There are multiple, alternative container technologies that allow users to run OCI/Docker containers in userspace without admin privledges.
OpenHPC has support for [Singularity](https://sylabs.io/) and [Charliecloud](https://hpc.github.io/charliecloud/)
and both RHEL/CentOS and SuSE have support for [Podman](https://podman.io/).

In this exercise, we will take Docker containers, convert them to Charliecloud containers and then run them on our elastic OpenHPC cluster.
Previously, we have given tutorials on the usage of Singularity and the 
[slides are available](https://docs.google.com/presentation/d/1u-GRzaeSGTNb4Qnk_rjBLb9go5xmW3mirqmchyH2Wjg/edit)
for additional, self-directed learning.

If you are attending this tutorial live, the containers are already available and ready to be used in /home/centos/ContainersHPC.
Below (and live), we will demo the typical use case where Docker is installed on your personal laptop/desktop and you want to run 
Docker images on an HPC system. 
At the end of this exercise are instructions for building the tutorial content in userspace using podman.


## Working with containers (45 mins)

First, we will demonstrate the typical use case. 

* End users develop with Docker on their personal machines
* Dockerfiles are converted to gzip'd compressed charliecloud images
* Images are transferred to our HPC system
* Charliecloud compressed images are unpacked into a directory
* SLURM jobs are submitted to run the Charliecloud workloads



### Build HPC containers from Dockerfiles

#### On the Desktop or laptop (demonstrated) ####

1) Build docker image from Dockerfile

In the deirectory where the Dockerfile is located, execute the following command:

~~~

$ sudo docker build -t image_name .

~~~

View the new Docker image in your local Docker repository:

~~~

$ sudo docker image ls

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
