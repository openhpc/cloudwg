---
title: Exercise 1
layout: default
parent: SC 2020 Tutorial
nav_order: 3
---


# Exercise 1: AWS and OpenHPC
## Setting up your AWS (Amazon Web Services) account and building OpenHPC Amazon Machine Images (AMI) (30 mins)


In this exercise, we will configure our AWS account and build an Amazon Machine Image (AMI). 
In order to begin following along, you need to first follow the directions on the [Getting Started](getting-started.html) page in 
the [Personal AWS cluster from scratch](getting-started.html#personal-aws-cluster-from-scratch) section or be running an [EventEngine tutorial cluster](getting-started.html#eventengine-tutorial-cluster). 

You will need:

* An EC2 instance with [packer](https://packer.io) installed (or packer installed locally)
* Your ee-default-keypair (packer-sc20 if personal cluster) private key 


If you are missing any of the above, please return to the [Getting Started](getting-started.html) page.


### Preparing to build the AMI

* Log into your EC2 packer building instance (this was automatically created if using EventEngine)
  * Services > EC2 > Instances > Right click instance > Connect > SSH client > copy ssh command example
  * SSH into packer builder

~~~
$ ssh -i "ee-default-keypair.pem" centos@ecx-xx-xxx-xxx-xxx.us-east-1.compute.amazonaws.com
~~~

* Set your AWS API keys

~~~

$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE # use your AWS_ACCESS_KEY
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY # use your AWS_SECRET_ACCESS_KEY
$ export AWS_DEFAULT_REGION=us-east-1

~~~

* Download the tutorial content tarball and extract it.

~~~

$ cd ~
$ wget -c https://github.com/utdsimmons/sc2020/raw/master/ohpc-sc20-tutorial.tar.bz2 -O - | tar -xj

~~~

The remainder of this tutorial assumes you extracted the tarball into ~ and you'll be working in ~/SC20



### Building the AMIs

In a typical OpenHPC cloud installation, the first thing we'd do is build two AMIs, one for the controller node (master) and
one for the login and compute nodes. However, the controller node AMI build takes 30+ minutes.
So, we will build our own login / compute node AMI and use a public controller node AMI published by the OpenHPC project.

To do this, we will be using [Packer](https://www.packer.io/) from [Hashicorp](https://www.hashicorp.com/). 

*Note: The packer yaml and shell script needed to build the controller AMI is available in the tutorial tarball for your reference.*

~~~

$ cd ~/SC20/packer-templates/compute
$ packer build compute.yml

~~~

*Note: The AMI hash is returned to standard output as the last line of the `packer build` command. It is also available from the EC2 console: Services -> EC2 -> AMIs*

**Once your packer builder is done and you have your own compute node AMI, you may continue to 
to [Exercise 2](exercise2.html).**

<details>
<summary>Building the Controller AMI (optional)</summary>
<pre>
<code>
$ cd ~/SC20/packer-templates/controller
$ packer build controller.yml
</code>
</pre>
</details>

