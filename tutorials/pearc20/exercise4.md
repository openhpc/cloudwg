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

In addition, we have ways to extend our elastic cluster including:

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

### X2go


### Podman


### Singularity 

