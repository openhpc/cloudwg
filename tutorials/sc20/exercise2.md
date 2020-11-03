---
title: Exercise 2
layout: default
parent: SC 2020 Tutorial
nav_order: 4
---

# Exercise 2: Deploying OpenHPC @ AWS
## Deploying our Elastic OpenHPC system at AWS with Cloudformation (30 mins)

In [Exercise 1](exercise1.html), we built an AMI to use for our login and compute nodes.
We will now use this along with an OpenHPC-provided controller node AMI to deploy our elastic cluster.

First, we are going to generate a new SSH key to use for our cluster access.

### Generating cluster SSH key

* Services > EC2 > Key Pairs > Create key pair 
* Name = cluster-sc20 (leave other settings as default)
* Create key pair

Your new private key should automatically be downloaded by your Web browser.

### Preparing for Cloud Formation Deployment



Now, we are going to deploy the cloud formation template that will setup our cluster.
But first, we need to update the template to include the AMIs we just built. The text editor `vi` is available by default.
Other text editors may be installed.

~~~

$ sudo dnf -y install emacs nano vim

~~~



Edit the centos8-slurm-x86_64.yml file in ~/SC20/cfn-templates/ and replace both instances EX1-AMI with the AMI IDs 
you just generated with packer in Exercise 1.

*Note: AMI IDs are available via the EC2 dasboard: Console > Services > EC2 > Images/AMIs*

~~~

$ cd ~/SC20/cfn-templates
$ vim centos8-slurm-x86_64.yml

~~~

Once you populate the AMI entries in the CloudFormation template, you are ready to deploy.

### Deploying the cluster with Cloud Formation
~~~

$ aws cloudformation deploy --template-file centos8-slurm-x86_64.yml --capabilities CAPABILITY_IAM --stack-name sc20-1 --region us-east-1

~~~

You can monitor the status of the deployment with the CloudFormation dashboard.

Console > Services > CloudFormation > Click the Stack name > Events

*Note: If you need to rerun the `aws cloudformation deploy` command, you'll need to either delete your stack or increment the index (i.e. --stack-name sc20-2) in order to rerun the command*

If everything worked correctly, you'll now be able to SSH into your login node using your "cluster-sc20" private key and the "centos" 
user account. 
You can identify the controller and login instances (and their DNS names or IP addresses) by accessing the EC2 page of your AWS console.

After the CloudFormation deployment command returns successfully, allow a few minutes for the NFS mount and Slurm configuration to 
complete before connecting via SSH.

### Accessing our cluster login node

First, we need to get the hostname of our login node from the EC2 console:

* Console > Services > EC2 > Running Instances 
* Right click Name=SlurmLogin > Connect > SSH client
* Save the hostname to your clipboard (example: ec2-xx-xx-xx-xxx.compute-1.amazonaws.com)

Now using your downloaded SSH private key and our login node host information, we can access our login node.

~~~
$ cp ~/Downloads/cluster-sc20.pem .
$ chmod 400 cluster-sc20.pem
$ ssh -i "cluster-sc20.pem" centos@ec2-xx-xxx-x-xxx.us-xxxx-x.compute.amazonaws.com

~~~

### Testing our cluster

And finally, we can submit a test job:

~~~

$ cp /opt/ohpc/pub/examples/mpi/hello.c .
$ mpicc hello.c
$ cp /opt/ohpc/pub/examples/slurm/job.mpi .
$ sbatch job.mpi

~~~

and monitor the job with watch

~~~

$ watch -n 5 squeue

~~~

Once the job is done, we can check the output to make sure everything worked correctly.


~~~

[centos@ip-192-168-0-200 ~]$ cat job.2.out 
[prun] Master compute host = ip-192-168-1-101
[prun] Resource manager = slurm
[prun] Launch cmd = mpiexec.hydra -bootstrap slurm ./a.out (family=mpich)

 Hello, world (16 procs total)
    --> Process #   8 of  16 is alive. -> ip-192-168-1-102.us-east-1.compute.internal
    --> Process #   9 of  16 is alive. -> ip-192-168-1-102.us-east-1.compute.internal
    --> Process #  10 of  16 is alive. -> ip-192-168-1-102.us-east-1.compute.internal
    --> Process #  11 of  16 is alive. -> ip-192-168-1-102.us-east-1.compute.internal
    --> Process #  12 of  16 is alive. -> ip-192-168-1-102.us-east-1.compute.internal
    --> Process #   0 of  16 is alive. -> ip-192-168-1-101.us-east-1.compute.internal
    --> Process #  13 of  16 is alive. -> ip-192-168-1-102.us-east-1.compute.internal
    --> Process #   1 of  16 is alive. -> ip-192-168-1-101.us-east-1.compute.internal
    --> Process #  14 of  16 is alive. -> ip-192-168-1-102.us-east-1.compute.internal
    --> Process #   4 of  16 is alive. -> ip-192-168-1-101.us-east-1.compute.internal
    --> Process #  15 of  16 is alive. -> ip-192-168-1-102.us-east-1.compute.internal
    --> Process #   5 of  16 is alive. -> ip-192-168-1-101.us-east-1.compute.internal
    --> Process #   6 of  16 is alive. -> ip-192-168-1-101.us-east-1.compute.internal
    --> Process #   7 of  16 is alive. -> ip-192-168-1-101.us-east-1.compute.internal
    --> Process #   2 of  16 is alive. -> ip-192-168-1-101.us-east-1.compute.internal
    --> Process #   3 of  16 is alive. -> ip-192-168-1-101.us-east-1.compute.internal
[centos@ip-192-168-0-200 ~]$ 

~~~

**If you get messages about "waiting for resources", just be patient. :)**

That it for Exercise 2. You can use this cluster to do [Exercise 3](exercise3.html) on working with the OpenHPC software stack.
If you are attending this tutorial live, you can use your provided "standalone cluster" account instead if needed.

