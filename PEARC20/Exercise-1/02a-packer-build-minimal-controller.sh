##!/bin/bash


source 00-env-setup.sh 

echo "Using CENTOS AMI" $OHPC_CENTOS_AMI "in the" $OHPC_AWS_REGION "region"

cp  packer-templates/controller/minimal/controller.yml.orig  packer-templates/controller/minimal/controller.yml
perl -pi -e "s/OHPC_AWS_REGION/${OHPC_AWS_REGION}/" packer-templates/controller/minimal/controller.yml
perl -pi -e "s/OHPC_CENTOS_AMI/${OHPC_CENTOS_AMI}/" packer-templates/controller/minimal/controller.yml

echo "Building Minimal Controller node AMI ..." "This will take a few minutes..."
echo ""

cd packer-templates/controller/minimal && echo "$ packer build controller.yml in $PWD" 
time packer build controller.yml && cd ../..

