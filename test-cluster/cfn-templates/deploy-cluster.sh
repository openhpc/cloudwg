#!/bin/bash

aws cloudformation deploy --template-file centos8-slurm-x86_64.yml --capabilities CAPABILITY_IAM --stack-name test$RANDOM --region us-west-1

