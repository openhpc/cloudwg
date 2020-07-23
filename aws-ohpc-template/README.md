# ohpc-cluster

Templates to deploy AWS clusters using OpenHPC packages.
Uses 2 separate AMIs (controller, login/compute).

# Future enhancements

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

From the cfn-templates directory, deploy the template using the following command (modified as needed):
```aws cloudformation deploy --template-file slurm-cluster-ohpc.yml --stack-name <your-stack-name> --capabilities "CAPABILITY_IAM" --region us-east-1```

Deployment will automatically roll back in the even of failure. If all components launch successfully but some part of the post-install process fails on an EC2 instance, check what went wrong by inspecting the contents of `/var/log/user-data.log`.
