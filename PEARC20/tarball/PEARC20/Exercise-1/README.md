
## Static cluster with 2 compute nodes

### Step 0 -- Pre-reqs

* pearc20.pem key
* aws configure set up
* packer installed

~~~

$ mkdir ~/bin && cd ~/bin
$ wget https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip
$ unzip packer_1.6.0_linux_amd64.zip

~~~

### Step 1 -- compute AMI

~~~

$ cd ~/PEARC20/Exercise-1/packer-templates/compute 
$ packer build compute.yml

~~~

### Step 2 -- controller AMI
~~~

$ cd ~/PEARC20/Exercise-1/packer-templates/controller
$ packer build controller.yml

~~~


### Step 3 -- Configuring the cluster

Edit ~/PEARC20/Exercise-1/cfn-templates/slurm-static-ohpc.yml 

Replace both entries of OHPC_COMPUTE_AMI with the AMI from Step 1
Replace OHPC_CONTROLLER_AMI with the AMI from Step 2


### Step 4 -- Deploying the cluster

~~~

$ cd ~/PEARC20/Exercise-1/cfn-templates
$ aws cloudformation deploy --template-file slurm-static-ohpc.yml --capabilities CAPABILITY_IAM --stack-name ex1-$$ --region us-east-1
~~~


