---
title: Getting Started 
layout: default
parent: SC 2020 Tutorial
nav_order: 0
---

## Getting Started


## DO WE NEED 3 WAYS OR IS EventEngine enough?

This site and the resulting tutorial is designed to be experienced in 3 ways:
* [Standalone tutorial cluster](#standalone-tutorial-cluster) run by the OpenHPC team on which you have a user account
* [EventEngine tutorial cluster](#eventengine-tutorial-cluster) on which you have you are provided an account and a cloud9 IDE terminal
* [Personal AWS cluster](#personal-aws-cluster-from-scratch) you provision from scratch on your own AWS account 


### EventEngine Tutorial Cluster

Also as part of PEARC 2020,
[EventEngine](https://dashboard.eventengine.run/login) hashes will be available
upon request on July 27th and August 3rd via the OpenHPC Slack. 

In order to request acess, join the [OpenHPC
Slack](https://join.slack.com/t/openhpc/shared_invite/enQtODAyNTgyMTUyNDUwLWIyMjc5MmJlMjJlY2ExNzYyYzcyN2M3OTkyMTcwOWI4YzlkMmEyMzIzODZhYzIxYzIwZDE2NWEyNmMzNzVhMTY)
and request a hash in the #tutorials channel.

Once you have the hash, go to [EventEngine](https://dashboard.eventengine.run/login) and enter the hash to access a dashboard containing account credentials and log-in links. While on this page, you should save the pre-created private-key and API keys, then click the link to enter the AWS console.

At this stage, you will be presented with a clean, temporary AWS account into which you can deploy the templates from the tutorial. Accounts deployed using EventEngine will be available for 48 hours from the start of the tutorial, after which point all accounts and their contents will be deleted.

For the purposes of this tutorial, the EventEngine account will function similarly to a standard newly-created AWS account; you can follow the instructions below to get started. Key differences to note:

* EventEngine accounts are temporary, but free - you will not need to enter any payment information.
* Within an EventEngine account, you will *not* need to create an IAM user; your login user will already have the required permissions to take any actions needed in the console.
* Instead of creating your own keypair, you can use the pre-created key whose contents were shown on the EventEngine dashboard - note however that if you use the EventEngine keypair, you will need to edit any CloudFormation templates you deploy to adjust the key name. For simplicity, we suggest just creating a new SSH key as per the instructions provided here.

All documented instructions assume you will work from a Cloud9 browser-based terminal/IDE - you can follow the instructions below to create a Cloud9 environment to work from. Alternatively, users who are already familiar with the AWS CLI can apply the API keys from the dashboard to their own local environment.

### Create an EC2 Key Pair

(Applies to both EventEngine and standard personal accounts)

* Navigate to Services -> EC2 -> Key Pairs.
* Create key pair.
* name=pearc20; file format pem -> create key pair
* Your web browser will now download pearc20.pem
* Save the pearc20.pem private key; we will need it later

### Create and configure Cloud9 Instance

(Applies to both EventEngine and standard personal accounts)

* Services > Cloud9 > create environment
* Accept the default environment settings -> create environment
* Services > Cloud9 > Open IDE

In the cloud9 terminal, set your API credentials as environment variables (if you are using and EventEngine account, you should paste the full set of credentials which were presented just before accessing the console). You will need to set these API keys each time you log in to a Cloud9 session.

Finally, we need to download and install [Packer](https://www.packer.io/) from [Hashicorp](https://www.hashicorp.com/). Packer is a CLI tool which automates the creation of Amazon Machine Images (AMIs) using a simple config file. An AMI is effectively a golden image, containing a set of user-defined packages and configuration changes applied on top of a base image (usually provided by AWS or the OS provider).

~~~

$ mkdir ~/bin && cd ~/bin
$ wget https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip 
$ unzip packer_1.6.0_linux_amd64.zip

~~~

You are now ready to start [Exercise 1](exercise1.html).
