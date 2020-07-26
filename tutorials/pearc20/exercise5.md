---
title: Exercise 5
layout: default
parent: PEARC 2020 Tutorial
nav_order: 7
---


# Exercise 5: Driving our Testbed
## Using community resources for self-directed education

podman run hello-world


git clone https://github.com/ibm-et/jupyter-samples.git &&  podman run -p 8888:8888 -v ~/jupyter-samples:/home/jovyan jupyter/minimal-notebook

sudo podman run -d -p 8787:8787 -v $(pwd):/home/rstudio -e PASSWORD=rstudio rocker/rstudio:devel


***Note: When you are done with this cluster, you can delete it by going to Console > Services > CloudFormation > Select the stack name radio button (ex3-00) > Delete***

