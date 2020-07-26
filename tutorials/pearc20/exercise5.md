---
title: Exercise 5
layout: default
parent: PEARC 2020 Tutorial
nav_order: 7
---


# Exercise 5: Driving our Testbed
## Using community resources for self-directed education
### R / RStudio

Let's first explore our Testbed system as a Personal CI system. To do this, we're going to look at using R with RStudio.

R/RStudio has seen steady increase in usage over the last few years. [A recent article](https://careers.hpcwire.com/2020/07/10/left-for-dead-r-surges-again/) featured in HPCWire discusses this trend.

Let's use our new Testbed system to setup RStudio. 
To do this, we will leverage the [Rocker project](https://github.com/rocker-org/rocker), a repository that contains Dockerfiles for R users.

Instructions for using the Rocker RStudio Docker containers are available on the [Rocker DockerHub](https://hub.docker.com/r/rocker/rstudio) site.
While, we do not have docker installed on our system, we have podman. First, let's install the podman-docker compability package.

~~~

[centos@ip-192-168-0-100 ~]$ sudo dnf -y install podman-docker

~~~

Then, simply copy and paste the docker command from DockerHub.

~~~

 docker run -d -p 8787:8787 -e PASSWORD=rstudio rocker/rstudio

~~~

Finally, open up a web browser and point it to port 8787 of your "X2goManagement" node. Console > Services > EC2 > Instances > Right Click 'X2goManagement' > Connect > Copy Public DNS to cliboard to get the host name. Paste the full Public DNS name of your server into a web browser and append :8787 to it.

i.e. ec2-xx-xxx-xxx-xxx.compute-1.amazonaws.com:8787 

Use the username rstudio and password rstudio (or set to a different password in the docker run command). 

From there, explore a few R tutorials:

* [Basic Data Analysis through R/Rstudio](http://web.cs.ucla.edu/~gulzar/rstudio/basic-tutorial.html)
* [The R Tutorial](https://www.tutorialspoint.com/r/index.htm) developed by the R Development Core Team 
* [R Tutorial for Beginners](https://www.guru99.com/r-tutorial.html)
* [R Examples](http://www.rexamples.com/)

Or, explore developing Shiny Apps by starting the [Welcome to Shiny](https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/) Tutorial. 
Shiny is an R package that makes it easy to develop and deploy interactive web applications using R.



## Example Jupyter Tutorial System
### Jupyter Tutorials

Let's now use our test system as a mock training system to be used for a Campus tutorial. 
For this exercise, we will use X2go, Community Github repos, DockerHub, Singularity and the dynamic cluster.

Connect to your X2goManagement node using X2go and open up a terminal. We are first going to clone [a public repository of Jupyter Examples](https://github.com/ibm-et/jupyter-samples) maintained by the [IBM Cloud Emerging Technologies](https://github.com/ibm-et) group.

~~~

$ cd ~
$ git clone https://github.com/ibm-et/jupyter-samples.git

~~~

Next, we are going to build a singularity container using the [Minimal Jupyter Notebook Stack](https://hub.docker.com/r/jupyter/minimal-notebook/) maintained
at DockerHub by the Jupyter project. We are going to build this container in the same directory as the notebooks we cloned from github.

~~~

$ cd ~/jupyter-samples/
$ module load singularity
$ singularity pull docker://jupyter/minimal-notebook

~~~

Now, instead of running this job on the master node, we are going to run it on our cluster.

~~~

$ cd ~/jupyter-samples/
$ module load singularity
$ srun -N 1 -n 1 --pty ./minimal-notebook_latest.sif 

~~~

Once launched, you can click on the URL to open up Firefox on the X2go Server. This will connect to the running tutorial notebook session on our elastic compute cluster.

We can now tar up the notebook directory along with the singularity container and distribute to attendees. 

***Note: When you are done with this cluster, you can delete it by going to Console > Services > CloudFormation > Select the stack name radio button (ex3-00) > Delete***


