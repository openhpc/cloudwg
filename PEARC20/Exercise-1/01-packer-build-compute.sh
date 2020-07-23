#!/bin/bash

source 00-env-setup.sh 

echo "Using CENTOS AMI" $OHPC_CENTOS_AMI "in the" $OHPC_AWS_REGION "region"


cp  packer-templates/compute/compute.yml.orig  packer-templates/compute/compute.yml
perl -pi -e "s/OHPC_AWS_REGION/${OHPC_AWS_REGION}/" packer-templates/compute/compute.yml
perl -pi -e "s/OHPC_CENTOS_AMI/${OHPC_CENTOS_AMI}/" packer-templates/compute/compute.yml

echo ""
echo "Building Compute node AMI ..." "This should take 5-6 mins"
echo ""

cd packer-templates/compute/ && echo "$ packer build compute.yml in $PWD" 
time packer build compute.yml && cd ../..

