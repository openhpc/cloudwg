#!/bin/bash

mkdir -p /tmp/packer
cd /tmp/packer

yum -y update
yum -y install --nogpgcheck epel-release
yum -y install --nogpgcheck wget curl python-pip python3-pip jq git make nfs-utils rpm-build
yum -y install --nogpgcheck http://build.openhpc.community/OpenHPC:/1.3/CentOS_7/x86_64/ohpc-release-1.3-1.el7.x86_64.rpm
yum -y install --nogpgcheck ohpc-base
yum -y install --nogpgcheck ohpc-release
yum -y install --nogpgcheck ohpc-slurm-server
yum -y install --nogpgcheck lmod-ohpc

pip install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
chmod +x /bin/cfn-*

pip3 install awscli

git clone https://github.com/aws/efs-utils
pushd efs-utils
make rpm
yum -y install ./build/amazon-efs-utils*rpm
popd

cd /tmp
rm -rf /tmp/packer
