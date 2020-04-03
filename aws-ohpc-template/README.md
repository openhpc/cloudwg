# full-cluster

Deploys a standard SLURM cluster, making user of SLURM "power-saving"/"cloud bursting" functionality.
SLURM compiled from source, config files/settings saved to shared directory.
Uses a single shared AMI for all compute resources, deploys additional packages/config via post-install.

# ohpc-cluster

Stripped-down version of the previous template, aiming to replace compiled SLURM with OpenHPC package.
Uses 3 separate AMIs (controller, login, compute).
Work in progress - needs the following (not exhaustive):
 - slurm.conf file needs to be updated with hostname, IP, etc
 - SLURM config files and MUNGE key need to be copied (or otherwise made accessible) to other instances
 - NFS export required from controller to provide /opt/ohpc/pub

# Useful enhancements

 - Extract all common variables set in the CFn template to a single file which can be sourced as needed.
 - Minimize IAM permissions on the controller instance profile as much as possible.
 - Make "add on" features (Lustre in particular) available via a parameter toggle, similar to login node.
 - Provide templates both with and without managed services (mostly EFS as alternative to NFS).
 - Explore exuivalent functionality in PBS Pro.
 - Replicate deployment in SUSE Leap.

# Deployment process

Assuming sufficient IAM access enabled via instance profile or user keys on the machine used to deploy, and both Packer and AWS CLI are available:

Build AMIs (in packer-templates subirectories, run "packer build compute.yml" or equivalent) - remember to update the region being targeted, or extend the list of regions to copy AMIs to. Note that current Packer builds target a base CentOS AMI in eu-west-1 to begin from; need to update the base AMI ID if building in another region.

Update CFn template parameters to reflect newly built AMIs, and any other changes desired.

Create 2 S3 buckets - one to host CFn template uploads during CLI deployment, one to host post-install files.

Upload any files related to post-install steps to the appropriate S3 bucket.

From the cfn-templates directory, deploy the template using the following command (modified as needed):
```aws cloudformation deploy --template-file slurm-cluster-ohpc.yml --s3-bucket chrdowni-openhpc-cloud9-cfn-deployments-us-east-1 --force-upload --stack-name ohpc-slurm-2020-03-24-A --capabilities "CAPABILITY_NAMED_IAM" --region us-east-1```

Deployment will automatically roll back in the even of failure. If all components launch successfully but some part of the post-install process fails on an EC2 instance, the WaitCondition will not be satisfied and resources will roll back after 30 mins. To check what went wrong before that happens, SSH to the instance and check the contents of /var/log/user-data.log.
