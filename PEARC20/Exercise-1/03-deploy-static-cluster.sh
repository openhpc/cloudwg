##!/bin/bash


source 00-env-setup.sh 


if [[ -z "${OHPC_COMPUTE_AMI}" ]]; then
  echo ""
  echo "Please set OHPC_COMPUTE_AMI in: 00-env-setup.sh" 
  echo ""
  echo "Get AMI hash from Services > EC2 > AMI" after running ./01-packer-build-compute.sh
  exit 1
else
  echo ""
fi


if [[ -z "${OHPC_CONTROLLER_AMI}" ]]; then
  echo ""
  echo "Please set OHPC_CONTROLLER_AMI in: 00-env-setup.sh" 
  echo ""
  echo "Get AMI hash from Services > EC2 > AMI" after running ./02-packer-build-controller.sh 
  exit 1
else
  echo ""
fi

cp  cfn-templates/slurm-static-ohpc.yml.orig cfn-templates/slurm-static-ohpc.yml
perl -pi -e "s/OHPC_COMPUTE_AMI/${OHPC_COMPUTE_AMI}/" cfn-templates/slurm-static-ohpc.yml
perl -pi -e "s/OHPC_CONTROLLER_AMI/${OHPC_CONTROLLER_AMI}/" cfn-templates/slurm-static-ohpc.yml



echo "Deploying Static Cluster via CloudFormation..." "This will take a while ..."
echo ""

cd cfn-templates/ 
echo "Running the following command in" $PWD:
echo "aws cloudformation deploy --template-file slurm-static-ohpc.yml --capabilities CAPABILITY_IAM --stack-name ex1 --region $OHPC_AWS_REGION" 
aws cloudformation deploy --template-file slurm-static-ohpc.yml --capabilities CAPABILITY_IAM --stack-name ex1 --region $OHPC_AWS_REGION --tag STATUS=DEV && cd ..

