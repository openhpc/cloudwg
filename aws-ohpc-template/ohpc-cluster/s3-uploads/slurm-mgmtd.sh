#!/bin/bash -xe

AWS_DEFAULT_MAC=$(curl -sS http://169.254.169.254/latest/meta-data/mac)
AWS_VPC_CIDR=$(curl -sS http://169.254.169.254/latest/meta-data/network/interfaces/macs/$AWS_DEFAULT_MAC/vpc-ipv4-cidr-block)

sms_name=$(hostname)

yum -y --nogpgcheck install ohpc-base
yum -y --nogpgcheck install ohpc-slurm-server
perl -pi -e "s/ControlMachine=\S+/ControlMachine=${sms_name}/" /etc/slurm/slurm.conf
