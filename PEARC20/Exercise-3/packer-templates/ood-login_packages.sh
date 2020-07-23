#!/bin/bash

dnf -y update
dnf -y config-manager --set-enabled PowerTools
dnf -y install epel-release
dnf -y install https://yum.osc.edu/ondemand/1.7/ondemand-release-web-1.7-1.noarch.rpm
dnf -y install ondemand
#dnf -y install http://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm
#dnf -y install ohpc-base
#dnf -y install ohpc-release
#dnf -y install ohpc-slurm-client
dnf -y install wget curl python3-pip jq git make nfs-utils libnfs
