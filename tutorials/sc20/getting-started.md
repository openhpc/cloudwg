---
title: Getting Started 
layout: default
parent: SC 2020 Tutorial
nav_order: 0
---

## Getting Started


This site and the resulting tutorial is designed to be experienced in 3 ways:
* [Standalone tutorial cluster](#standalone-tutorial-cluster) run by the OpenHPC team on which you have a user account
* [EventEngine tutorial cluster](#eventengine-tutorial-cluster) which you provision as part of this tutorial during SC
* [Personal AWS cluster](#personal-aws-cluster-from-scratch) you provision from scratch on your own AWS account

### Standalone Tutorial Cluster

As part of SC 2020, the OpenHPC cloud working group has provisioned an OpenHPC cluster at AWS. 
User accounts will be provided to tutorial attendees and they can be used for [Exercise 3](exercise3.html) and [Exercise 4](exercise4.html).

These accounts are only meant to be used in the event that you are unable to get your EventEngine cluster working. 

### EventEngine Tutorial Cluster

Also as part of SC 2020,
[EventEngine](https://dashboard.eventengine.run/login) hashes will be available
upon request on November 12th during the tutorial.

In order to request acess, join the [OpenHPC
Slack](https://join.slack.com/t/openhpc/shared_invite/enQtODAyNTgyMTUyNDUwLWIyMjc5MmJlMjJlY2ExNzYyYzcyN2M3OTkyMTcwOWI4YzlkMmEyMzIzODZhYzIxYzIwZDE2NWEyNmMzNzVhMTY)
and request a hash in the #tutorials channel.

Once you have the hash, go to [EventEngine](https://dashboard.eventengine.run/login) and enter the hash to access a dashboard containing 
account credentials and log-in links. **While on this page, you should save the pre-created private key and API keys before clicking the link 
to enter the AWS console.**

At this stage, you will be presented with a clean, temporary AWS account into which you can deploy the templates from the tutorial. 
Accounts deployed using EventEngine will be available for around 72 hours from the start of the tutorial, after which point all accounts 
and their contents will be deleted.

For the purposes of this tutorial, the EventEngine account will function similarly to a standard newly-created AWS account; 
you can follow the instructions below to get started. 

Key differences to note:
* EventEngine accounts are temporary, but free - you will not need to enter any payment information.
* Within an EventEngine account, you will *not* need to create an IAM user; 
your login user will already have the required permissions to take any actions needed in the console.

All documented instructions assume you will work from an EC2 instance that will be configured with your AWS API keys 
and have packer installed.
Alternatively, users who are already familiar with the AWS CLI can apply the API keys from the dashboard to their own local environment.

**If you have an EventEngine account and have saved your API and SSH keys, you are now ready to start [Exercise 1](exercise1.html).**

### Personal AWS cluster from scratch

The third way to experience this tutorial is to use your own AWS account. This is the only supported method when done outside of SC20.

#### Create a new AWS account

* Go to https://aws.amazon.com/console/ -> create a free account.
* Set up a Basic Plan (Free).
* You will be required to enter payment information, but exercises described here use free-tier compute resources by default.
* Sign into AWS as the "Root user" with the account you just created.
* Navigate to Services -> IAM -> Add user.
* Enter user name and select both the "Programmatic access" and the "AWS Management Console access" boxes.
* Hit next to go to the Set permissions page and select the 3rd box from the top menu "Attach existing policies directly".
* Check AdministratorAccess -> Next -> Create user
* **Save the Access Key ID and the Secret access key for later use.**

Sign out of AWS as the Root user and sign back in, this time using the IAM user account you just created.

Note that this IAM user account has effectively unrestricted access to create/delete resources within your AWS account - take care when experimenting and ensure that resources are deleted when you are finished to avoid unnecessary charges.


#### Create and configure the EC2 instance

(Applies to personal AWS cluster only; this instance is automatically spawned for EventEngine clusters)

* Navigate to Services > EC2 > Instances > Launch Instances
* Enter the CentOS 8.2 AMI into the Search Box for your region from the [Official and current CentOS Public Images
](https://wiki.centos.org/Cloud/AWS) page
* Community AMIs > Select
* Choose an Instance Type > t2.micro > Review and Launch > Launch
* Create a new key pair > packer-sc20 > Download key pair > Launch Instances > View Instances
* Once the status checks pass, right click the instance > Connect > SSH client > copy Public DNS
* Connect to instance using your packer-SC20.pem SSH key

```console
$ cp ~/Downloads/packer-sc20.pem .
$ chmod 400 packer-sc20.pem
$ ssh -i "packer-sc20.pem" centos@ec2-xx-xxx-x-xxx.us-xxxx-x.compute.amazonaws.com
```


Once connected to the EC2 instance, install the aws cli client.

You will need to set these API keys each time you log in to this instance.


~~~console

$ sudo dnf -y install python36 wget zip
$ pip3 install --user awscli

~~~

Finally, we need to download and install [Packer](https://www.packer.io/) from [Hashicorp](https://www.hashicorp.com/). Packer is a CLI tool which automates the creation of Amazon Machine Images (AMIs) using a simple config file. An AMI is effectively a golden image, containing a set of user-defined packages and configuration changes applied on top of a base image (usually provided by AWS or the OS provider).

~~~console

$ mkdir ~/bin && cd ~/bin
$ wget https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip 
$ unzip packer_1.6.0_linux_amd64.zip

~~~


You are now ready to start [Exercise 1](exercise1.html).
