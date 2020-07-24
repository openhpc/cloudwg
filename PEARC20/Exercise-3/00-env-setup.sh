#!/bin/bash


source ../Exercise-1/00-env-setup.sh

export OHPC_LOGIN_AMI=



export OHPC_AWS_REGION=`aws configure get region`

if [[ -z "${OHPC_CENTOS_AMI}" ]]; then
  echo "Have you done Exercise 1?" 
  echo "Please set OHPC_CENTOS_AMI in: ../Exercise/1/00-env-setup.sh" 
  echo "Get AMI hash from https://wiki.centos.org/Cloud/AWS for your region" $OHPC_AWS_REGION
  exit 1
else
  echo ""
fi

