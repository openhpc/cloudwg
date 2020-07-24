#!/bin/bash


source 00-env-setup.sh 


if [[ -z "${OHPC_COMPUTE_AMI}" ]]; then
  echo ""
 echo "Have you done Exercise 1?" 
  echo "Please set OHPC_COMPUTE_AMI in ../Exercise1/00-env-setup.sh" 
  echo ""
  echo "Get AMI hash from Services > EC2 > AMI after running ./01-packer-build-compute.sh in ../Exercise-1"
  exit 1
else
  echo ""
fi


if [[ -z "${OHPC_CONTROLLER_AMI}" ]]; then
  echo ""
  echo "Please set OHPC_CONTROLLER_AMI in ../Exercisse-1/00-env-setup.sh" 
  echo ""
  echo "Get AMI hash from Services > EC2 > AMI after running ./02-packer-build-controller.sh in ../Exercisse-1"
  exit 1
else
  echo ""
fi

if [[ -z "${OHPC_LOGIN_AMI}" ]]; then
  echo ""
  echo "Please set OHPC_LOGIN_AMI 00-env-setup.sh" 
  echo ""
  echo "Get AMI hash from Services > EC2 > AMI after running ./01-ood-login-build-compute.sh"
  exit 1
else
  echo ""
fi

cp  cfn-templates/slurm-dynamic-ood-ohpc.yml.orig cfn-templates/slurm-dynamic-ood-ohpc.yml
perl -pi -e "s/OHPC_COMPUTE_AMI/${OHPC_COMPUTE_AMI}/" cfn-templates/slurm-dynamic-ood-ohpc.yml
perl -pi -e "s/OHPC_CONTROLLER_AMI/${OHPC_CONTROLLER_AMI}/" cfn-templates/slurm-dynamic-ood-ohpc.yml
perl -pi -e "s/OHPC_LOGIN_AMI/${OHPC_LOGIN_AMI}/" cfn-templates/slurm-dynamic-ood-ohpc.yml



echo "Deploying Dynamic Cluster via CloudFormation..." "This will take a while ..."
echo ""

cd cfn-templates/ 
echo "Running the following command in $PWD"
echo "aws cloudformation deploy --template-file slurm-dynamic-ood-ohpc.yml --capabilities CAPABILITY_IAM --stack-name ex3 --region $OHPC_AWS_REGION "
time aws cloudformation deploy --template-file slurm-dynamic-ood-ohpc.yml --capabilities CAPABILITY_IAM --stack-name ex321 --region $OHPC_AWS_REGION --tag STATUS=DEV && cd ..
