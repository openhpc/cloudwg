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

* If you are using an EventEngine account, also set your AWS_SESSION_TOKEN

~~~

$ export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEJ3//////////wEaCXVzLWVhc3QtMSJHMEUCIG7pNhU9MREozHRR8xccBiSyOe9uW1pNAbTONkCnxyQ4AiEA6jcpzZQD8gLN84+6Y/2fUIfmT7kbFZLEjvm0i6tYrL4qoAII9v//////////ARABGgw5MzAwMTcwNDE3ODMiDJNZVNzJsnTb23a3OSr0AebUmrjYXazdkzVLYCqDIsMfRsz8xMcysNpLteslZhe+5iUspmNcMGI9dDsCqTdy1cVoOyZRXjzAFTFlvTyjAi4QLGBFi04xInvzMAjIr5ZqGm+oVrvWxy0UU6v2fAaN0MH8QLchfL93Nrp7OF8Qmg5hZAsQE7FT0xtXvv96zjqzWAOtNELtz8zSl+41i0/1ev5SOJ1NQjrbS09ZEnfmL16aaelutVjHuK+1YrUi+Bo2crAru8PakJL6kR3+kOTniOG1Gl+EpUcyx70+k61kVM2f+6VRJ5ORiybtHUkknzit/YgVL3oIJ9d4CQv1YIa5wfgY3CgwkcyR/QU6nQElm5DSJRrbsRL/lt/lKIiOmlpDDT+JMCsPdifQP8yQr3D9hE1Kvv9GVpNALME79tiXH4IZZ8veMIddw9RCjl64v02Wm7BF/8+aYs3EWkAipJiVQpliBp416iY+aRAG1C8IG4UCB68+soouV5+HTjKyAPoZ2kJFcJnOfBIzrA+xAU8NAaw6FoiT+TyvzEnVGrdNvsLzEXAMPLETOKEN

~~~

*Note: You do not have to set the SESSION TOKEN if you are using a personal AWS account*

* Download the tutorial content tarball and extract it.

~~~

$ cd ~
$ wget -c https://github.com/utdsimmons/sc2020/raw/master/ohpc-sc20-tutorial.tar.gz -O - | tar -xz

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

**Once your packer builder is done and you have recorded your compute node AMI, you may continue 
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

