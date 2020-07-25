---
title: Exercise 3
layout: default
parent: PEARC 2020 Tutorial
nav_order: 5
---

# Exercise 3: Building a Testbed 
## An elastic OpenHPC system with Open OnDemand and X2go

In this exercise, we will be provisioning a second OpenHPC system in Amazon Elastic Compute Cloud (Amazon EC2). 

This system will feature:

* a full OpenHPC software stack
* containerization support using Podman and Singularity
* Open Ondeman web portal
* X2go login node for remote X sessions

In order to begin following along, you need to first follow the directions on the [Getting Started](getting-started.html) page in [Personal AWS cluster from scratch](getting-started.html#personal-aws-cluster-from-scratch) section or be running an [EventEngine tutorial cluster](getting-started.html#eventengine-tutorial-cluster). 

You will need:

* A Cloud9 IDE environment with packer installed
* A pearc20 key pair and the pearc20.pem file available on the cloud9 instance
* The aws command line tool configured with Access Key ID and Secret Access Key

If you are missing any of the above, please return to the [Getting Started](getting-started.html) page

Additionally, you'll need to tutorial content. 

~~~

$ cd ~
$ wget -c https://github.com/utdsimmons/pearc2020/raw/master/ohpc-pearc20-tutorial.tar.bz2 -O - | tar -xj

~~~

The remainder of this tutorial assumes you extracted the tarball into ~ and you'll be working in ~/PEARC20



### The AMIs

In Exercise 1 we built our own AMIs using using [Packer](https://www.packer.io/). 
In this Exercise, we will use pre-built AMIs. 


| AMI Name|Region|AMI ID
| X2goManagement|us-east-1|ami-0834bf7fd0bc7f1d9
| OODLogin|us-east-1|ami-095a1fbc357e55b1e
| Computer|us-east-1|ami-06762eb064725ebde

If you'd like to build and customize your own AMIs, the sources are located in ~/PEARC20/Exercise-3/packer-templates/

### Bulding the cluster with Cloud Formation

Since we are using pre-built AMIs, all we need to do is deploy the template and wait.
~~~

$ cd ~/PEARC20/Exercise-3/cfn-templates
$ aws cloudformation deploy --template-file slurm-dynamic-ood-ohpc.yml --capabilities CAPABILITY_IAM --stack-name ex3-$$ --region us-east-1
~~~

To monitor, go to Console > Services > CloudFormation > Click the stack name (ex3-xxxxx) > Events


### Testing the cluster

#### SSH Access

Go to the EC2 Dashboard and find the public DNS 

Console > Services > EC2 > Instances > Right Click 'X2goManagement' > Connect > Copy Public DNS to cliboard 

In Cloud9

~~~

$ cd ~
$ ssh -i pearc20.pem centos@ec2-34-194-250-228.compute-1.amazonaws.com
$ cp /opt/ohpc/pub/examples/mpi/hello.c .
$ mpicc hello.c
$ cp /opt/ohpc/pub/examples/slurm/job.mpi .
$ sbatch job.mpi
$ watch -n 10 squeue

~~~

In Exercise 1, we deployed a cluster with 2 compute nodes. These compute nodes were static/persistent.

For this exercise, we've deployed an "elastic" cluster. When a job is submitted, the cluster will create EC2 instances for the compute nodes on demand.
It will take between 5-6 mins from submission time for the job to start.

#### X2go Access

In addition to command line access, this management node can also be used to provide remote desktops.

***Note: This is NOT good practice. This is just an educational exercise. For production use separate x2go from management services***

Testing X2go:

* [install the X2go client](https://wiki.x2go.org/doku.php/download:start) and launch it
* x2go > Session > New Session
* Session name: ohpc@aws
* Host: Paste the Public DNS entry from the clipboard
* Login: centos
* Use RSA/DSA key for ssh connection: pearc20.pem from OS specific browser downloads folder
* Session type: XFCE 
* Media Tab
* De-select "Enable sound support" and "Client side printing support"
* Select Ok to save the profile
* Click the newly create profile "box" and select "yes" to trust the host key

You should now have a remote desktop running XFCE.

#### Open OnDemand Web Portal

In Exercise 1, we provised a management node and 2 compute nodes. In this Exercise, we've created an elastic cluster with a management node running x2go and an additional login node.
This additional login node has been provisioned with [Open OnDemand](https://openondemand.org/), an NSF-funded open-source HPC portal.

It provides:

* Plugin-free / "clientless" HPC
* Drag and Drop file management
* Command-line shell access to our cluster
* Job management, monitoring, and submissions via a robust templating system
* Optional graphical desktop environments and desktop applications (not configured here)

In order to access the web portal, we will need its Public DNS info. 

Console > Services > Ec2 > Instances > Right Click 'OODLogin' > Connect > Copy Public DNS to clipboard

Paste this DNS entry into a web browser and enter username: 'centos' and password: 'ood'.


This concludes Exercise 3. This cluster will be used for the remaining exercises.



