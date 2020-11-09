#!/bin/bash



dnf -y update
dnf -y config-manager --set-enabled PowerTools
dnf -y install epel-release
dnf -y install http://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm
dnf -y install ohpc-base
dnf -y install ohpc-release
dnf -y install ohpc-slurm-server
dnf -y install lmod-ohpc

# dev packages
dnf -y install ohpc-autotools
dnf -y install EasyBuild-ohpc
dnf -y install hwloc-ohpc
dnf -y install spack-ohpc
dnf -y install valgrind-ohpc

# gnu9 serial/threaded packages
dnf -y install ohpc-gnu9-serial-libs
dnf -y install ohpc-gnu9-runtimes
dnf -y install hdf5-gnu9-ohpc

# install gnu9/mpich and gnu9/openmpi package variants
dnf -y install openmpi4-gnu9-ohpc mpich-ofi-gnu9-ohpc mpich-ucx-gnu9-ohpc
dnf -y install ohpc-gnu9-mpich* ohpc-gnu9-openmpi4*
dnf -y install lmod-defaults-gnu9-mpich-ofi-ohpc
dnf -y install wget curl python3-pip jq git make nfs-utils

pip3 install awscli

# basic utils and parallel python
dnf -y install zip multitail vim
dnf -y install python3-mpi4py-gnu9-mpich-ohpc python3-mpi4py-gnu9-openmpi4-ohpc python3-numpy-gnu9-ohpc python3-scipy-gnu9-mpich-ohpc python3-scipy-gnu9-openmpi4-ohpc

# grab podman and docker interface to run optional from scratch without docker locally
dnf -y install podman-docker

# increase S3 performance
cat <<-EOF | install -D /dev/stdin /root/.aws/config
[default]
s3 =
    max_concurrent_requests = 100
    max_queue_size = 1000
    multipart_threshold = 256MB
    multipart_chunksize = 128MB
EOF
# prebake tutorial content
/usr/local/bin/aws s3 cp s3://ohpc-sc20-tutorial/ContainersHPC-v7.tar.gz - --no-sign-request | tar xz -C /home/centos

