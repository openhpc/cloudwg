#!/bin/bash

source 00-env-setup.sh 


cp packer-templates/x2go-controller/x2go-controller.yml.orig  packer-templates/x2go-controller/x2go-controller.yml
perl -pi -e "s/OHPC_AWS_REGION/${OHPC_AWS_REGION}/" packer-templates/x2go-controller/x2go-controller.yml
perl -pi -e "s/OHPC_CENTOS_AMI/${OHPC_CENTOS_AMI}/" packer-templates/x2go-controller/x2go-controller.yml

echo ""
echo "Building x2go + management node AMI ... This should take 5-6 mins"
echo ""

cd packer-templates/x2go-controller && echo "$ packer build x2go-controller.yml in $PWD" 
time packer build x2go-controller.yml && cd ../..

