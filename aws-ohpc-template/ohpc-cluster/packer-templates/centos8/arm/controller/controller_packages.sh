#!/bin/bash


dnf -y update
dnf -y config-manager --set-enabled PowerTools
dnf -y install epel-release
dnf -y install http://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm
dnf -y install ohpc-base
dnf -y install ohpc-release
dnf -y install ohpc-slurm-server
dnf -y install lmod-ohpc
dnf -y install ohpc-gnu9-*
dnf -y install openmpi4-gnu9-ohpc
dnf -y install lmod-defaults-gnu9-openmpi4-ohpc
dnf -y install wget curl python3-pip jq git make nfs-utils

pip3 install awscli

