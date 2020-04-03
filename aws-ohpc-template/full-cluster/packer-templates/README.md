Packer template and installation script

Usage:
`packer build compute.yml`

Generates an AMI which is copied to each region specified in "ami_regions"
AMI IDs are specified in the packer output, for example:
> eu-west-1: ami-0b536ffb85116fe75
> us-east-1: ami-051c24308ce13dd87
