---
title: PEARC 2020 Tutorial
layout: default
has_children: true
has_toc: false
---

## PEARC 2020 Tutorial
---
#### Customizing OpenHPC: Integrating Additional Software and Provisioning New Services including Open OnDemand
##### Tutorial Level: Intermediate
##### Tutorial Length: 3 hours
##### Instructors:
* Christopher S. Simmons
* Karl W. Schulz
* Derek Simmel

##### Target Audience: HPC cluster operators and users, computational science application developers with an interest in portable HPC software tools and environments including containers, VMs and Cloud Deployments.

---

Since its inception as a Linux Foundation project in 2015, the OpenHPC project (<https:///openhpc.community>) 
has steadily grown to provide a modern, consistent, reference collection of HPC cluster provisioning tools, 
together with a curated repository of common cluster management software, I/O clients, advanced computational 
science libraries and software development tools, container-based execution facilities, and application 
performance profiling tools.

Although the primary focus of OpenHPC remains enabling the on-premises deployment of new HPC clusters rapidly, 
the OpenHPC software repository itself serves as a reliable, portable, integrated collection of software, 
libraries, tools and user environment that can be employed in containers and VMs in the cloud. 

This can be particularly useful for those environments that one to either:
* augment their on premises HPC resources with additional cloud-based resources (a hybrid cloud model)
* deploy a full cloud solution

The goal of this tutorial is to help HPC cluster operators, users, and computational science application 
developers gain a better understanding of OpenHPC, and how it can be customized and extended to provide 
additional services that are commonly requested by our community. This tutorial will cover extending an 
OpenHPC cluster to support additional software and features for both the on-premise and cloud models.

This half-day tutorial will begin with a brief, advanced introduction to OpenHPC. 
We will then demonstrate customizing and extending OpenHPC through several practical exercise modules 
including:
* provisioning a cloud-based, OpenHPC cluster
* integrating additional software into the lmod-based (<https://lmod.readthedocs.io/>)
software management system
* customizing OpenHPC-based cluster compute node images
* adding support for a web-based login node with Open OnDemand (<https://openondemand.org/>)
* running example workloads via the CLI and the web portal