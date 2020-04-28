# Compute template example

This template adds compute resources to be used within the cluster.

Networking components are (in order of appearance in the template):
 - VPC (with CIDR range 192.168.0.0/16 as per CWG request)
 - Internet gateway (allowing internet access for the VPC)
 - Gateway attachment (connecting the IGW to the VPC)
 - Route table for internal cluster traffic
 - Route table for external (internet) traffic
 - Route added to the external route table, directing traffic via the IGW
 - Elastic IP address for a NAT Gateway
 - NAT Gateway (to forward traffic from the "private" subnet to the internet)
 - NAT route (adding a route table rule to allow out-bound traffic via the NAT GW)
 - External access security group (allowing SSH access from any IP)
 - "Public" subnet (192.168.0.0/24) in the first AZ of the region
 - Association between the public subnet and the external traffic route table
 - "Private" subnet (192.168.1.0/24) in the first AZ of the region
 - Association between the private subnet and the internal traffic route table
 - Internal security group (to allow all traffic between resources in that SG)
 - Rule for the internal SG, opening access for all traffic

(These are identical to the network.yml template found in ../network)

The template adds Parameters, allowing for user input of the following values:
 - True/False selection of whether a login node should be provisioned as well as a controller
 - The name of the SSH key to be added to the default instance user account (must already be uploaded to AWS)
 - The AMI to be used for the controller instance (must be a pre-existing AMI in the same region)
 - The instance type to be launched for the controller
 - The AMI to be used for the login instance, if provisioned
 - The instance type to be launched for the login node, if provisioned

The template also includes a Condition, which converts the string value for the AllocateLoginNode to a boolean

Compute components are (in order of appearance):
 - Elastic IP address for the controller instance
 - Elastic IP address for the login instance (only if "AllocateLoginNode" was set to TRUE)
 - EC2 instance to serve as the SLURM controller
 - EC2 instance to serve as the SLURM login node (only if "AllocateLoginNode" was set to TRUE)

Deploying the template results in a set of Outputs being reported - these are the public and private IP addresses of the instances which have been created.

The end result of deploying this template is a virtual network with the same characteristics as that deployed by the network.yml template, with EC2 resources added.

Instances do not recieve an IAM profile, and user-data scripts are set as minimal working examples which update instance hostnames and disable SELinux.
