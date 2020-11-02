#!/bin/bash

aws cloudformation deploy \
    --template-file centos8-slurm-x86_64.yml \
    --capabilities CAPABILITY_IAM \
    --stack-name test$RANDOM \
    --region us-west-1 \
    --parameter-overrides \
        KeyName="YOUR-KEY" \
        HeadAMI="YOUR-CONTROLLER-AMI" \
        ComputeAMI="YOUR-COMPUTE-AMI" \
        LoginAMI="YOUR-COMPUTE-AMI-AGAIN"

### Other useful commands

# List deployed stacks:
# aws cloudformation list-stacks --region <REGION>

# Delete stack:
# aws cloudformation delete-stack --stack-name <NAME> --region <REGION>

