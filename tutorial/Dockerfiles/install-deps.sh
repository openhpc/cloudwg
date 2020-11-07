#!/bin/bash

sudo dnf -y update
sudo dnf -y config-manager --set-enabled PowerTools
sudo dnf -y install epel-release
sudo dnf -y install http://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm
sudo dnf -y install ohpc-base
sudo dnf -y install ohpc-release
sudo dnf -y install lmod-ohpc

# dev packages
sudo dnf -y install ohpc-autotools
sudo dnf -y install hwloc-ohpc

# gnu9 serial/threaded packages
sudo dnf -y install ohpc-gnu9-serial-libs
sudo dnf -y install ohpc-gnu9-runtimes

# install gnu9/mpich and gnu9/openmpi package variants
sudo dnf -y install mpich-ofi-gnu9-ohpc 
sudo dnf -y install lmod-defaults-gnu9-mpich-ofi-ohpc
sudo dnf -y install wget curl python3-pip jq git make nfs-utils

pip3 install --user awscli

# basic utils and parallel python
sudo dnf -y install zip multitail vim
sudo dnf -y install python3-mpi4py-gnu9-mpich-ohpc python3-numpy-gnu9-ohpc python3-scipy-gnu9-mpich-ohpc

# grab podman and docker interface to run optional from scratch without docker locally
sudo dnf -y install podman-docker

