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
* [Charliecloud containers are run on the cluster](http://0.0.0.0:4000/tutorials/sc20/exercise4.html#simple-container-execution-live-tutorial-users-start-here) (Live tutorial users start here)



### Build HPC containers from Dockerfiles

#### On the Desktop or laptop (demonstrated) ####

##### Build docker image from Dockerfile

In the directory where the Dockerfile is located, execute the following command:


```console

$ sudo docker build -t image_name .

```

View the new Docker image in your local Docker repository:

```console


$ sudo docker image ls

REPOSITORY                             TAG                IMAGE ID                  CREATED             SIZE
image_name                            latest              02d6e22ec5ec              2 days ago         5.74GB
bash                                  latest              16463e0c481e              7 weeks ago         15.2MB
ubuntu                                16.04               7e87e2b3bf7a              7 months ago        117MB
hello-world                           latest              fce289e99eb9              8 months ago        1.84kB
debian                                stretch             de8b49d4b0b3              8 months ago        101MB

```

##### Convert docker image to charliecloud on desktop

```console
$ sudo ch-builder2tar image /dir/to/save
```

This creates the file */dir/to/save/image_name.tar.gz*

##### Copy the tar.gz file to the HPC system


```console
$ scp -i .ssh/id_rsa -r image_name.tar.gz centos@ec2-54-177-114-95.us-west-1.compute.amazonaws.com:
```

#### On the HPC system (hands on) ####

##### Load the charliecloud module

```console
$ module load charliecloud
```

##### Unpack charliecloud archive on OHPC cloud

```console
$ cd /home/centos/ContainersHPC
$ ch-tar2dir pico_quant.tar.gz .
```

*Note if you're attending this event live, the containers are already unpacked and ready to be used*

### Simple container execution (Live tutorial users start here)

Now that we have ...
* built our docker containers from a Dockerfile
* converted it to a gzip'd charliecloud image
* transfered it to our cluster
* and unpacked our charliecloud image

We are ready to run our containers. If you are attending this tutorial live, the containers are available in $HOME/ContainersHPC.


The first thing we will do is invoke a bash shell in our Charliecloud container.
This is done via the `ch-run` command. 


*Note: the -w flag mounts the image read-write (by default, the image is mounted read-only)*

***If you didn't previously, you'll need to `ml load charliecloud` before proceeding.***


#### Start a bash shell in the container

```console
$ ch-run -w ./a408704d3f3d/ -- bash
$ ls
$ exit
```

***bash: /opt/ohpc/admin/lmod/lmod/libexec/lmod: No such file or directory?***


In Exercise 3, we set up module collections and added `module restore` to our ~/.bashrc.
However our containers are not set up to use lmod. Future versions of this tutorial will cover integration of OpenHPC modules
into container environments.

For now, we can edit our ~/.bashrc and set it up to check for the existence of the /WEIRD_AL_YANKOVIC file.
Charliecloud images always have this file at the top level of their virtual file system.

~~~console
$ pwd
/home/centos/ContainersHPC/intel-oneapi
$ cat WEIRD_AL_YANKOVIC 
This directory is a Charliecloud image.
~~~

Edit your ~/.bashrc and replace the `module restore` command with this if statement (or simply remove / comment out the module command).

~~~bash
# User specific aliases and functions

if [ -f /WEIRD_AL_YANKOVIC ]
then
        echo "inside container; not restoring lmod defaults" #NOOP
else
        module restore
fi
~~~

#### Compile "hello world" mpi C program

Next, we will compile an MPI hello world program that is inside the container using the container compiler and MPI stacks.

```console
$ ch-run -w a408704d3f3d -- mpicc -g -O3 -o /MPI_TEST/HelloWorld/mpi_hello_world /MPI_TEST/HelloWorld/mpi_hello_world.c
```

#### Execute MPI "hello world"

And now, we can run the freshly compiled mpi hello world example.

```console
$ mpiexec -n 2 ch-run -w ./a408704d3f3d/ -- /MPI_TEST/HelloWorld/mpi_hello_world
```

### TensorFlow example

Now that we've looked at a simple example, let's use the same container to run [Horovod](https://eng.uber.com/horovod/).
Horovod is Uber's open source deep learning framework on top of [TensorFlow](https://eng.uber.com/horovod/).


#### Run distributed TensorFlow horovod interactively (print out horovod ranks)

```console
$ mpiexec -n 2 ch-run -w ./a408704d3f3d/ -- python /MPI_TEST/Horovod/simple_mpi.py
```

#### Run distributed TensorFlow example on our elastic cluster via Slurm 

```console
$ sbatch slurm_sc_tutorial_charliecloud.sh
```

```console
#!/bin/bash
#SBATCH --job-name="charliecloud_sc_tutorial_mpich_test"
#SBATCH --output="output_charliecloud_horovod_sc_tutorial_mpich_test.txt"
#SBATCH --error="error_charliecloud_horovod_sc_tutorial_mpich_test.txt"
#SBATCH --time=00:30:00
#SBATCH -N 2 # Request two nodes
#SBATCH -n 2 # Request 2 cores; one MPI task per node

#load charliecloud module
module load charliecloud

#tensorflow cpu best practice from:
#https://software.intel.com/content/www/us/en/develop/articles/maximize-tensorflow-performance-on-cpu-considerations-and-recommendations-for-inference.html
#Recommended settings for CNN → OMP_NUM_THREADS = num physical cores
export OMP_NUM_THREADS=8

#Recommended affinity setting for systems with hyperthreading on (can confirm with $ cat /proc/cpuinfo  | grep ht)
export KMP_AFFINITY=granularity=fine,verbose,compact,1,0

#Recommended settings (RTI) → intra_op_parallelism = # physical cores
#Recommended settings → inter_op_parallelism = 2
#Recommended settings → data_format = NCHW
#Recommended settings for CNN → KMP_BLOCKTIME=0

time prun ch-run -w /home/centos/ContainersHPC/a408704d3f3d --  python /tensorflow/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py -
-model alexnet --batch_size 128 --data_format NCHW --num_batches 100 --distortions=False --mkl=True --local_parameter_device cpu --num_warmup_
batches 10 --optimizer rmsprop --display_every 10 --variable_update horovod --horovod_device cpu --num_intra_threads 8 --kmp_blocktime 0 --num
_inter_threads 2

```


### Other features of Charliecloud

#### Mounting directory from host into container

Using the `-b` flag, it is possible to mount directories from the host system directly into the container.
This can be used to "augment" the container with files / binaries from the host system.


```console
$ ch-run -w -b /opt/ohpc/.:/opt/ohpc/ ./a408704d3f3d/ -- bash
$ ls /opt/ohpc
$ exit
```

#### Set environment to docker environment

When a Charliecloud image is built, a special file is created in $IMAGE/ch/environment that allows you to inherit the environment 
specified by the builder (Docker).

Default OHPC paths based on loaded modules.

~~~console
$ echo $PATH
/opt/ohpc/pub/libs/charliecloud/0.15/bin:/home/centos/.local/bin:/home/centos/bin:/opt/ohpc/pub/mpi/libfabric/1.10.1/bin:/opt/ohpc/pub/mpi/mpi
ch-ofi-gnu9-ohpc/3.3.2/bin:/opt/ohpc/pub/compiler/gcc/9.3.0/bin:/opt/ohpc/pub/utils/prun/2.0:/opt/ohpc/pub/utils/autotools/bin:/opt/ohpc/pub/b
in:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
~~~

Simply starting a container does not set your PATH to the same as the container build environment.
~~~console
$ ch-run -w ./intel-oneapi -- bash
$ echo $PATH
/home/centos/.local/bin:/home/centos/bin:/opt/ohpc/pub/libs/charliecloud/0.15/bin:/home/centos/.local/bin:/home/centos/bin:/opt/ohpc/pub/mpi/l
ibfabric/1.10.1/bin:/opt/ohpc/pub/mpi/mpich-ofi-gnu9-ohpc/3.3.2/bin:/opt/ohpc/pub/compiler/gcc/9.3.0/bin:/opt/ohpc/pub/utils/prun/2.0:/opt/ohp
c/pub/utils/autotools/bin:/opt/ohpc/pub/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/bin
$ exit
~~~

However, you can use the --set-env option to modify your environment upon starting the container and if you use $IMAGE/ch/environment,
it will be your original builder (Docker) runtime environment.

~~~console
$ ch-run --set-env=./intel-oneapi/ch/environment -w ./intel-oneapi -- bash
$ echo $PATH
/home/centos/.local/bin:/home/centos/bin:/opt/intel/oneapi/inspector/2021.1-beta10/bin64:/opt/intel/oneapi/itac/2021.1-beta10/bin:/opt/intel/o
neapi/itac/2021.1-beta10/bin:/opt/intel/oneapi/clck/2021.1-beta10/bin/intel64:/opt/intel/oneapi/debugger/10.0-beta10/gdb/intel64/bin:/opt/inte
l/oneapi/dev-utilities/2021.1-beta10/bin:/opt/intel/oneapi/intelpython/latest/bin:/opt/intel/oneapi/intelpython/latest/condabin:/opt/intel/one
api/mpi/2021.1-beta10/libfabric/bin:/opt/intel/oneapi/mpi/2021.1-beta10/bin:/opt/intel/oneapi/vtune/2021.1-beta10/bin64:/opt/intel/oneapi/mkl/
2021.1-beta10/bin/intel64:/opt/intel/oneapi/compiler/2021.1-beta10/linux/lib/oclfpga/llvm/aocl-bin:/opt/intel/oneapi/compiler/2021.1-beta10/li
nux/lib/oclfpga/bin:/opt/intel/oneapi/compiler/2021.1-beta10/linux/bin/intel64:/opt/intel/oneapi/compiler/2021.1-beta10/linux/bin:/opt/intel/o
neapi/compiler/2021.1-beta10/linux/ioc/bin:/opt/intel/oneapi/advisor/2021.1-beta10/bin64:/opt/intel/oneapi/vpl/2021.1-beta10/bin:/usr/local/sb
in:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
$ exit
~~~

### Additional Exercise -- Quantum computing simulator setup

```console
$ ch-run --set-env=./pico_quant/ch/environment -w ./pico_quant -- bash
$ julia
$ using Pkg
$ Pkg.add("PicoQuant")
$ Pkg.activate("/PicoQuant")
$ Pkg.test("PicoQuant")
$ exit
```

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

If you'd like to build containers from Dockerfiles or Docker/OCI container registeries and don't have access to a system with Docker
or you want to build them directly on an HPC system, you can use Podman (if it's installed on your HPC system).

Podman is a daemonless Docker/OCI container runtime that can run without escalated privledges.
More info on Podman is available on [their whatis page](https://podman.io/whatis.html).

In this exercise, you were provided with Charliecloud image directories. 
These directories were built from Dockerfiles that were provided as part of the tarball from Exercise 1.
These Dockerfiles are available in the ~/SC20/Dockerfiles directory on your "bastion"/manually launched EC2 instance.

```console
$ cd ~/SC20/misc/Dockerfiles/
$ sh install-deps.sh
```

Log out and log back in (or run `bash -l`) to setup lmod in your environment.

```console
$ ml load charliecloud
$ podman build -t myoneapi -f Dockerfile_intel-oneapi
$ ch-builder2tar myoneapi .
```

```console
$ podman build -t mypq -f Dockerfile_PicoQuant
$ ch-builder2tar mypq .
```

From here, you can transfer your gzip'd charliecloud image tarballs to your HPC system, extract them, and run them.

~~~console
$ ch-tar2dir image.tar.gz .
~~~

