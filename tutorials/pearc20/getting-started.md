---
title: Getting Started 
layout: default
parent: PEARC 2020 Tutorial
nav_order: 0
---

## Getting Started

<span style="color: red"> ***Note: This will be finalized last once everything else is frozen.*** </span>
{: .fs-2}

This site and the resulting tutorial is designed to be experienced in 3 ways:
* [Standalone tutorial cluster](#standalone-tutorial-cluster) run by the OpenHPC team on which you have a user account
* [EventEngine tutorial cluster](#eventengine-tutorial-cluster) on which you have you are provided an account and a cloud9 IDE terminal
* [Personal AWS cluster](#personal-aws-cluster-from-scratch) you provision from scratch on your own AWS account 

### Standalone Tutorial Cluster

As part of PEARC 2020, the OpenHPC cloud working group has provisioned an OpenHPC cluster at AWS. 
This cluster will be available from Monday, July 27th 2020 until Friday, August 7th.

User accounts will be provided to tutorial attendees and they will be used for [Exercise 2](exercise2.html) and [Exercise 5](exercise5.html).


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

### Personal AWS cluster from scratch

The third way to experience this tutorial is to use your own AWS account and follow along with Exercises 1 and 3. 
After finishing these two exercises, you will have your own system that can then be used to do Exercise 5.

#### Create a new AWS account

* Go to https://aws.amazon.com/console/ -> create a free account.
* Set up a Basic Plan (Free).
* You will be required to enter payment information, but exercises described here use free-tier compute resources by default.
* Sign into AWS as the "Root user" with the account you just created.
* Navigate to Services -> IAM -> Add user.
* Enter user name and select both the "Programmatic access" and the "AWS Management Console access" boxes.
* Hit next to go to the Set permissions page and select the 3rd box from the top menu "Attach existing policies directly".
* Check AdministratorAccess -> Next -> Create user
* Capture the Access Key ID and the Secret access key for later use.

Sign out of AWS as the Root user and sign back in, this time using the IAM user account you just created.

Note that this IAM user account has effectively unrestricted access to create/delete resources within your AWS account - take care when experimenting and ensure that resources are deleted when you are finished to avoid unnecessary charges.

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
