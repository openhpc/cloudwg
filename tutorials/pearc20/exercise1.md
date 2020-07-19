---
title: Exercise 1
layout: default
parent: PEARC 2020 Tutorial
nav_order: 3
---

# Exercise 1

In this exercise, we will be provisioning an OpenHPC system in Amazon Elastic Compute Cloud (Amazon EC2). 
In order to begin following along, you need to first follow the directions on the [Getting Started](getting-started.html) page in the [Personal AWS cluster from scratch](getting-started.html#personal-aws-cluster-from-scratch.html) section.

If followed correctly, you should have a Cloud9 IDE terminal setup.
The first thing we need to do is grab the tarball with the tutorial content and extract it.

~~~

$ cd ~/environment
$ wget /path/to/gist/pearc20.tar.gz -O - | tar -xz

~~~

The remainder of this tutorial assumes you extracted the tarball into ~/environment, the default directory that Cloud9 starts in.
## Building the AMIs

The first thing we need to do is to build two AMIs, one for the login/master node (controller) and one for the compute nodes.
To do this we will be using [Packer](https://www.packer.io/) from [Hashicorp](https://www.hashicorp.com/).

### Controller AMI

~~~

$ cd ~/environment/ex1/packer-templates/controller
$ packer build controller.yml

~~~

After the build completes, save the AMI hash for usage in the cloud formation templates.


***Note: The AMI hash is returned to standard output as the last line of the `packer build` command***

### Compute AMI

~~~

$ cd ~/environment/ex1/packer-templates/compute
$ packer build compute.yml

~~~

## Bulding the cluster with Cloud Formation

~~~

$ cd ~/environment/ex1/cfn-templates

~~~

Now, we are going to run the cloud formation template that will deploy our cluster.
But first, we need to update the template to include the AMIs we just built.

If you are working on a fresh AWS account, you can use the following commands to retrieve your AMI hashes.

~~~

$ aws ec2 describe-images --owners self | grep ami

~~~

The first one will be the controller and the second one will be the compute if you've followed this tutorial on a fresh AWS account.

~~~

$ export AMI_CONTROLLER=`aws ec2 describe-images --owners self | grep ami | head -n 1 | cut -f 4 -d\"`
$ export AMI_COMPUTE=`aws ec2 describe-images --owners self | grep ami | tail -n 1 | cut -f 4 -d\"`

~~~

Next, let's capture our current AWS region:

~~~

$ export OHPC_REGION=`aws configure get region`

~~~


Now let's update our "static" cloud formation template with the proper AMI values.

~~~

$ perl -pi -e "s/ohpc-ami-controller/${AMI_CONTROLLER}/" slurm-static-ohpc.yml
$ perl -pi -e "s/ohpc-ami-compute/${AMI_COMPUTE}/g" slurm-static-ohpc.yml

~~~

And deploy our template

~~~

$ aws cloudformation deploy --template-file slurm-static-ohpc.yml --capabilities CAPABILITY_IAM --stack-name ohpc00 --region $OHPC_REGION

~~~

If everything worked correctly, you'll now be able to SSH into your login node using your SSH keys and the "centos" user account.

~~~

$ command/to/get/ip of login node and log in
$ ssh -i ~/.ssh/pearc2020.pem" centos@ec2-3-18-128-251.us-east-2.compute.amazonaws.com

~~~

