#!/bin/bash

mkdir -p /tmp/packer
cd /tmp/packer

yum -y update
yum -y install --nogpgcheck epel-release
yum -y install --nogpgcheck wget curl python3-pip jq git make nano nfs-utils rpm-build
yum -y install --nogpgcheck libjpeg-turbo libjpeg-turbo-devel libjpeg-turbo-utils
yum -y install --nogpgcheck bc gnuplot zip
pip3 install awscli

git clone https://github.com/aws/efs-utils
pushd efs-utils
make rpm
yum -y install ./build/amazon-efs-utils*rpm
popd

wget https://fsx-lustre-client-repo-public-keys.s3.amazonaws.com/fsx-rpm-public-key.asc
rpm --import fsx-rpm-public-key.asc
wget https://fsx-lustre-client-repo.s3.amazonaws.com/el/7/fsx-lustre-client.repo -O /etc/yum.repos.d/aws-fsx.repo
yum install -y kmod-lustre-client lustre-client

wget https://s3-us-west-2.amazonaws.com/aws-efa-installer/aws-efa-installer-1.8.3.tar.gz
tar -xf aws-efa-installer-1.8.3.tar.gz
pushd aws-efa-installer
./efa_installer.sh -y
popd

yum-config-manager --add-repo https://yum.repos.intel.com/setup/intelproducts.repo
yum install -y --nogpgcheck intel-mpi

cd /tmp
rm -rf /tmp/packer
