# Networking template example

This template deploys only the networking components to be used within the cluster.

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

The end result of deploying this template is a virtual network into which compute resources could be deployed.

The only chargeable resource deployed is the NAT Gateway - this could be removed by allowing an EC2 instance in the public subnet to serve as a NAT host, if desired.

The networking configuration uses only one subnet (and therefore only one AZ) for "private" resources - this is the intended location for the compute nodes. Instances launched here can have their out-bound traffic routed to the internet via the NAT Gateway, but do not allow in-bound connections. Even if an instance is launched in this subnet with an IPv4 address and the "external access" security group attached, it will not be accessible directly from the public internet. For the public subnet, IPv4 addresses are routable directly via the IGW.

The security groups are created as examples and do not provide any functionality until they are applied to a network interface launched within the VPC (eg as part of EC2 instance creation). The external access SG allows in-bound SSH access from anywhere, while the cluster SG allows for unrestricted traffic to/from any interface which is also part of the same SG.
