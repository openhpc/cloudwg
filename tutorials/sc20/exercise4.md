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
That is, you must have escalated privledges (root) in order to use it.
Because of this, most HPC systems do not support Docker.

However, there are multiple, alternative container technologies that allow users to run Docker/OCI containers 
in userspace without admin privledges.
OpenHPC has support for [Singularity](https://sylabs.io/) and [Charliecloud](https://hpc.github.io/charliecloud/)
and both [RHEL](https://www.redhat.com/en)/[CentOS](https://www.centos.org/) and [SuSE](https://www.suse.com/)
 have support for [Podman](https://podman.io/).

In this exercise, we will take Docker containers, convert them to Charliecloud containers and then run them on our elastic OpenHPC cluster.
Previously, we have given [other tutorials](https://docs.google.com/presentation/d/1u-GRzaeSGTNb4Qnk_rjBLb9go5xmW3mirqmchyH2Wjg/)
that include discussion of [different virtualization and containerization tools including 
Singularity](https://docs.google.com/presentation/d/1u-GRzaeSGTNb4Qnk_rjBLb9go5xmW3mirqmchyH2Wjg/edit#slide=id.g5dedef83a8_14_6).

If you are attending this tutorial live, the containers are already available and ready to be used in $HOME/ContainersHPC.
Below (and live), we will demo the typical use case where Docker is installed (and used for development)
 on your personal laptop/desktop and you want to run Docker images on an HPC system. 
At the end of this exercise are instructions for building the tutorial content in userspace using Podman.


## Working with containers (45 mins)

First, we will demonstrate the typical use case. 

* End users develop with Docker on their personal machines
* Dockerfiles are converted to gzip'd compressed charliecloud images
* Images are transferred to our HPC system
* Charliecloud compressed images are unpacked into a directory
* SLURM jobs are submitted to run the Charliecloud workloads



### Build HPC containers from Dockerfiles

#### On the Desktop or laptop (demonstrated) ####

##### Build docker image from Dockerfile

In the directory where the Dockerfile is located, execute the following command:

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

##### Convert docker image to charliecloud on desktop

~~~

$ sudo ch-builder2tar image /dir/to/save

~~~

This creates the file */dir/to/save/image_name.tar.gz*

##### Copy the tar.gz file to the HPC system

~~~

$ scp -i .ssh/id_rsa -r image_name.tar.gz centos@ec2-54-177-114-95.us-west-1.compute.amazonaws.com:

~~~

#### On the HPC system (hands on) ####

##### Load the charliecloud module

~~~

$ module load charliecloud

~~~

##### Unpack charliecloud archive on OHPC cloud

~~~

$ cd /home/centos/ContainersHPC
$ ch-tar2dir pico_quant.tar.gz .

~~~

*Note if you're attending this event live, the containers are already unpacked and ready to be used*

### Simple container execution

Now that we have ...
* built our docker containers from a Dockerfile
* converted it to a gzip'd charliecloud image
* transfered it to our cluster
* and unpacked our charliecloud image

We are ready to run our containers. Also, note if you are attending this tutorial live, the containers are available in $HOME/ContainersHPC.


The first thing we will do is invoke a bash shell in our Charliecloud container.
This is done via the `ch-run` command. 


*Note: the -w flag mounts the image read-write (by default, the image is mounted read-only)*

***If you didn't previously, you'll need to `ml load charliecloud` before proceeding.***


#### Start a bash shell in the container

~~~

$ ch-run -w ./a408704d3f3d/ -- bash
$ ls
$ exit

~~~

#### Compile "hello world" mpi C program

Next, we will compile an MPI hello world program that is inside the container using the container compiler and MPI stacks.
~~~

$ ch-run -w a408704d3f3d -- mpicc -g -O3 -o /MPI_TEST/HelloWorld/mpi_hello_world /MPI_TEST/HelloWorld/mpi_hello_world.c

~~~

#### Execute MPI "hello world"

And now, we can run the freshly compiled mpi hello world example.

~~~

$ mpiexec -n 2 ch-run -w ./a408704d3f3d/ -- /MPI_TEST/HelloWorld/mpi_hello_world

~~~

### TensorFlow example

Now that we've looked at a simple example, let's use the same container to run [Horovod](https://eng.uber.com/horovod/).
Horovod is Uber's open source deep learning framework on top of [TensorFlow](https://eng.uber.com/horovod/).


#### Run distributed TensorFlow horovod interactively (print out horovod ranks)

~~~

$ mpiexec -n 2 ch-run -w ./a408704d3f3d/ -- python /MPI_TEST/Horovod/simple_mpi.py

~~~

#### Run distributed TensorFlow example on our elastic cluster via Slurm 

~~~

$ sbatch slurm_sc_tutorial_charliecloud.sh

~~~

### Other features of Charliecloud

#### Mounting directory from host into container

Using the `-b` flag, it is possible to mount directories from the host system directly into the container.
This can be used to "augment" the container with files / binaries from the host system.


~~~

$ ch-run -w -b /opt/ohpc/.:/opt/ohpc/ ./a408704d3f3d/ -- bash

~~~

#### Set environment to docker environment

When a Charliecloud image is built, a special file is created in $IMAGE/ch/environment that allows you to inherit the environment 
specified by the builder (Docker).

~~~
$ echo $PATH

$ ch-run -w ./oneapi_hpc_mod -- bash

$ echo $PATH

$ exit

$ ch-run --set-env=./oneapi_hpc_mod/ch/environment -w ./oneapi_hpc_mod -- bash
$ echo $PATH
$ exit


~~~

### Additional Exercise -- Quantum computing simulator setup

~~~

$ ch-run --set-env=./pico_quant/ch/environment -w ./pico_quant -- bash
$ julia
$ using Pkg
$ Pkg.add("PicoQuant")
$ Pkg.activate("/PicoQuant")
$ Pkg.test("PicoQuant")
$ exit

~~~

That concludes Exercise 4 and the tutorial. 
Below are the instructions to generate the Charliecloud image directories that you just used.

### Gotchas, tips and "real world" examples

* In your dockerfile avoid building your application and copying/storing your data in /home, as when executing the Charliecloud container the users /home directory will map to the containers /home directory and you will not be able to access the data the dockerfile build placed in /home.

* Mount your data directory such as $SCRATCH and/or $WORK in the container to avoid storing your data in the container.

* Use the system MPI environment (via mounting) when executing on a production HPC system.

* Install the software/drivers of the high performance interconnects inside the container. 
The transport layer can default to TCP instead of using the high performance network.

* Keep your container as small as possible. As creating the container is done on your laptop or desktop.

* Use the HPC module system inside the container if possible for optimized, tested and/or licensed software.


### Appendix: Building and Converting Dockerfiles in Userspace

If you'd like to build containers from Dockerfiles or on Docker/OCI container registeries and don't have access to a system with Docker
or you want to build them directly on an HPC system, you can use Podman (if it's installed on your HPC system).

Podman is a daemonless Docker/OCI container runtime that can run without escalated privledges.
More info on Podman is available on [their whatis page](https://podman.io/whatis.html).

In this exercise, you were provided with Charliecloud image directories. 
These directories were built from Dockerfiles that were provided as part of the tarball from Exercise 1.
These Dockerfiles are available in the ~/SC20/Dockerfiles directory on your "bastion"/manually launched EC2 instance.

~~~
$ cd ~/SC20/Dockerfiles
$ ml load charliecloud
$ ch-build -t myoneapi -f Dockerfile_oneAPI_mod
$ ch-builder2tar myoneapi .

~~~

~~~
$ ch-build -t mypq -f Dockerfile_PicoQuant
$ ch-builder2tar mypq .
~~~

From here, you can transfer your gzip'd charliecloud image tarballs to your HPC system and extract them with `ch-tar2dir image.tar.gz .`.
