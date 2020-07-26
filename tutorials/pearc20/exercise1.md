---
title: Exercise 1
layout: default
parent: PEARC 2020 Tutorial
nav_order: 3
---


# Exercise 1: HPC in the cloud
## Provisioning a simple OpenHPC system in Amazon EC2


In this exercise, we will be provisioning an OpenHPC system in Amazon Elastic Compute Cloud (Amazon EC2). 
In order to begin following along, you need to first follow the directions on the [Getting Started](getting-started.html) page in [Personal AWS cluster from scratch](getting-started.html#personal-aws-cluster-from-scratch) section or be running an [EventEngine tutorial cluster](getting-started.html#eventengine-tutorial-cluster). 

You will need:

* A Cloud9 IDE environment with packer installed
* A pearc20 key pair and the pearc20.pem file available on the cloud9 instance
* The aws command line tool configured with Access Key ID and Secret Access Key

If you are missing any of the above, please return to the [Getting Started](getting-started.html) page


Next, grab the tarball with the tutorial content and extract it.

~~~

$ cd ~
$ wget -c https://github.com/utdsimmons/pearc2020/raw/master/ohpc-pearc20-tutorial.tar.bz2 -O - | tar -xj

~~~

The remainder of this tutorial assumes you extracted the tarball into ~ and you'll be working in ~/PEARC20



### Building the AMIs

The first thing we need to do is to build two AMIs, one for the login/master node (controller) and one for the compute nodes.
To do this, we will be using [Packer](https://www.packer.io/) from [Hashicorp](https://www.hashicorp.com/). 
If you did not install packer in your Cloud9 instance previously, please return to the [Configure Cloud9 Instace](getting-started.html#create-and-configure-cloud9-instance) section of the [Getting Started](getting-started.html) page

***Note: Building both AMIs can be done in parallel. Either open two terminals in Cloud9, or use a virtual terminal multiplexer, such as `screen`***

#### Controller AMI

~~~

$ cd ~/PEARC20/Exercise-1/packer-templates/controller
$ packer build controller.yml

~~~

After the build completes, save the AMI hash for use in the cloud formation templates.


***Note: The AMI hash is returned to standard output as the last line of the `packer build` command. It is also available from the EC2 consoler: Services -> EC2 -> AMIs***

#### Compute AMI

~~~

$ cd ~/PEARC20/Exercise-1/packer-templates/compute
$ packer build compute.yml

~~~

### Bulding the cluster with Cloud Formation

~~~

$ cd ~/PEARC20/Exercise-1/cfn-templates

~~~

Now, we are going to run the cloud formation template that will deploy our cluster.
But first, we need to update the template to include the AMIs we just built. The text editors `vim`, `emacs`, and `nano` are all available.


Edit the slurm-static-ohpc.yml file in ~/PEARC20/Exercise-1/cfn-templates/slurm-static-ohpc.yml and replace OHPC_CONTROLLER_AMI and both entries of OHPC_COMPUTE_AMI with the AMI IDs you just generated with packer.

AMI IDs are also available via the EC2 dasboard: Console > Services > EC2 > Images/AMIs 

And then, finally deploy the cloud formation template:

~~~

$ aws cloudformation deploy --template-file slurm-static-ohpc.yml --capabilities CAPABILITY_IAM --stack-name ex1-00 --region us-east-1

~~~

You can monitor the status of the deployment with the CloudFormation dashboard.

Console > Services > CloudFormation > Click the Stack name > Events

***Note: If you need to rerun the `aws cloudformation deploy` command, you'll need to either delete your stack or increment the index (i.e. --stack-name ex1-01) in order to rerun the command***

If everything worked correctly, you'll now be able to SSH into your login node using your "pearc20" key pair and the "centos" user account. You can identify the controller and login instances (and their DNS names or IP addresses) by accessing the EC2 page of your AWS console.

After the CloudFormation deployment command returns successfully, allow a few minutes for the NFS mount and Slurm configuration to complete before connecting via SSH.

Console > Services > EC2 > Running Instances > Right click the one with Name=SlurmManagement > Connect > Save the hostname to your clipboard (example: ec2-xx-xx-xx-xxx.compute-1.amazonaws.com)

Then, in the Cloud9 IDE:

~~~

$ cd ~
$ ssh -i pearc20.pem centos@ec2-xx-xx-xx-xxx.compute-1.amazonaws.com


~~~

And finally, we can test our cluster:

~~~

$ cp /opt/ohpc/pub/examples/mpi/hello.c .
$ mpicc hello.c
$ srun -N 2 -n 16 --pty prun ./a.out 

~~~

If everything is working correctly, you should see something similar to the following:

~~~

[centos@ip-192-168-0-100 ~]$ srun -N 2 -n 16 --pty prun ./a.out 
[prun] Master compute host = ip-192-168-1-101
[prun] Resource manager = slurm
[prun] Launch cmd = mpirun ./a.out (family=openmpi4)

 Hello, world (16 procs total)
    --> Process #   5 of  16 is alive. -> ip-192-168-1-101.ec2.internal
    --> Process #   7 of  16 is alive. -> ip-192-168-1-101.ec2.internal
    --> Process #   9 of  16 is alive. -> ip-192-168-1-102.ec2.internal
    --> Process #  13 of  16 is alive. -> ip-192-168-1-102.ec2.internal
    --> Process #   8 of  16 is alive. -> ip-192-168-1-102.ec2.internal
    --> Process #  11 of  16 is alive. -> ip-192-168-1-102.ec2.internal
    --> Process #  10 of  16 is alive. -> ip-192-168-1-102.ec2.internal
    --> Process #   4 of  16 is alive. -> ip-192-168-1-101.ec2.internal
    --> Process #   1 of  16 is alive. -> ip-192-168-1-101.ec2.internal
    --> Process #   3 of  16 is alive. -> ip-192-168-1-101.ec2.internal
    --> Process #   0 of  16 is alive. -> ip-192-168-1-101.ec2.internal
    --> Process #   2 of  16 is alive. -> ip-192-168-1-101.ec2.internal
    --> Process #  15 of  16 is alive. -> ip-192-168-1-102.ec2.internal
    --> Process #   6 of  16 is alive. -> ip-192-168-1-101.ec2.internal
    --> Process #  14 of  16 is alive. -> ip-192-168-1-102.ec2.internal
    --> Process #  12 of  16 is alive. -> ip-192-168-1-102.ec2.internal
[centos@ip-192-168-0-100 ~]$ 

~~~

***If you get messages about "waiting for resources", just be patient. :)***

That it for Exercise 1. You can use this cluster to do [Exercise 2](exercise2.html) on working with the OpenHPC software stack.
If you are attending this tutorial live, you can use your provided "standalone cluster" account instead.

***Note: When you are done with this cluster, you can delete it by going to Console > Services > CloudFormation > Select the stack name radio button (ex1-00) > Delete***

<details>
    <summary>TLDR</summary>
    Simply copy/paste these commands into Cloud9 IDE to continue to Exercise 2
    <pre>
        <code>bash <(curl -s https://raw.githubusercontent.com/utdsimmons/pearc2020/master/Ex1-TLDR.sh)
</code>
    </pre>
</details>

