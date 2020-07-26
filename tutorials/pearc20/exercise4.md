---
title: Exercise 4
layout: default
parent: PEARC 2020 Tutorial
nav_order: 6
---

# Exercise 4: Exploring our Testbed
## Open OnDemand, X2go, Containers, and Augmenting our Cluster

In [Exercise 3:](exercise3.html), we built an elastic cluster that has:

* A Management node also running X2go with the XFCE Desktop
* A Login node running Open OnDemand
* Elastic compute nodes with maximum of 2 nodes 

In this exercise, we discuss a variety of ways to explore and extend our Testbed including using:

* [Open OnDemand](https://openondemand.org/)
* [X2go](https://wiki.x2go.org/doku.php)
* [Podman](https://podman.io/)
* [Singularity](https://sylabs.io/docs/)

In addition, we document ways to extend our elastic cluster including:

* Changing the max number of elastic nodes
* Changing the default node type
* Adding a new queue with a different node type
* Adding ARM support

### Open OnDemand

[Open OnDemand](https://openondemand.org/) is an NSF-funded open-source HPC portal. 

The provided instance has:
* Web-based file management
* Command-line shell access to our OHPC cluster
* Job management and monitoring of our elastic OHPC cluster

The provided testbed uses Apache "basic authentication". Before deploying any production services, please consult the [Open OnDemand Authentication Documentation](https://osc.github.io/ood-documentation/master/authentication.html) and use a more secure authentication mechanism.

First, log into Open Ondemand. Go to the AWS Console and then Services > EC2 > Instances > Right click 'OODLogin' > Connect > Copy 'Public DNS' to Clipboard

Open up Firefox or Chrome and paste the 'Public DNS' entry to address bar.

***Note: Open OnDemand does not support Safari***

You will be presented with a dialogue box. Enter 'centos' for username and 'ood' for the password. Upon login, you'll be presented with the OOD web interface.

* File > Home Directory to open up the interactive file transfer menuu
* Jobs > Active Jobs to monitor active jobs
* Jobs > Job Composer to create and submit jobs from the web browser
* Clusters > PEARC Cluster Shell Acess to open web-based command line access to our elastic cluster

From here, one could [Setup Interactive Apps](https://osc.github.io/ood-documentation/master/app-development/interactive/setup.html) on Open OnDemand.

### X2go

In [Exercise 3:](exercise3.html), the Management node was also provisioned with [X2go](https://wiki.x2go.org/doku.php), an open source remote desktop software 
for Linux that uses a modified NX 3 protocol, from [Nomachine](https://www.nomachine.com/). 

As configured, it uses the [XFCE](https://www.xfce.org/) desktop. 

For more information about X2go, see the [New to X2go Page](https://wiki.x2go.org/doku.php/doc:newtox2go). 

### Podman

As part of the Exercise 3 cluster, podman-based containerization support was added. 
[Podman](https://podman.io/) is a daemonless container engine for developing, managing, and running OCI Containers.

Simply put: `alias docker=podman`. More details [here](https://podman.io/whatis.html).

~~~

[centos@ip-192-168-0-100 ~]$ alias docker=podman
[centos@ip-192-168-0-100 ~]$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

~~~

### Singularity 

jupyter compute node x2go tensorflow nightly

other singularity tutorials

