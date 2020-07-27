---
title: CheatSheet
layout: default
parent: PEARC 2020 Tutorial
nav_order: 8
---

#### Links

#### Login node for shared cluster (for use with training accounts)

#### Clean up AMIs

    Console > Services > EC2 > AMIs > Select > Right Click > Deregister > Continue

#### Open cloud9

    Console > Services > Cloud9 > Open IDE

#### Download Tutorial Files

    cd ~ && wget -c https://github.com/utdsimmons/pearc2020/raw/master/ohpc-pearc20-tutorial.tar.bz2 -O - | tar -xj

#### Packer build not working as expected

Check the following:
* Did you download and install Packer from Hashicorp? If you missed this step, you may be using an unrelated application already installed on the Cloud9 environment.
* Are your account API keys in place? Packer uses API calls to walk through the image generation steps, and requires the ability to perform a few EC2-related actions. The easiest way to have API keys available to Packer is to set them as environment variables - in EventEngine, simply paste the full set of credentials from the dashboard into your terminal. In a standard account, set the two keys downloaded from your IAM console to `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.


Packer Sanity Check

~~~

 $ md5sum `which packer`
779d009e3f39c2d167191962b16a304b  /home/ec2-user/bin/packer

~~~

AWS Credential Check:

~~~

$ env | grep -i "AWS_ACCESS_KEY_ID\|AWS_SECRET_ACCESS_KEY"
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxx
~~~

If either is not set, the tutorial will not work.


