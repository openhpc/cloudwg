#!/bin/bash

source 00-env-setup.sh 


cp packer-templates/ood-login.yml.orig  packer-templates/ood-login.yml
perl -pi -e "s/OHPC_AWS_REGION/${OHPC_AWS_REGION}/" packer-templates/ood-login.yml
perl -pi -e "s/OHPC_CENTOS_AMI/${OHPC_CENTOS_AMI}/" packer-templates/ood-login.yml

echo ""
echo "Building OOD Login node AMI ... This should take 5-6 mins"
echo ""

cd packer-templates/ && echo "$ packer build ood-login.yml in $PWD" 
time packer build ood-login.yml && cd ..

