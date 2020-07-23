#!/bin/bash


export OHPC_CENTOS_AMI=

export OHPC_COMPUTE_AMI=

export OHPC_CONTROLLER_AMI=



export OHPC_AWS_REGION=`aws configure get region`

if [[ -z "${OHPC_CENTOS_AMI}" ]]; then
  echo ""
  echo "Please set OHPC_CENTOS_AMI in: 00-env-setup.sh" 
  echo ""
  echo "Get AMI hash from https://wiki.centos.org/Cloud/AWS for your region" $OHPC_AWS_REGION
  exit 1
else
  echo ""
fi

