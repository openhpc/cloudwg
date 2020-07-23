#!/bin/bash

dnf -y update
dnf -y config-manager --set-enabled PowerTools
dnf -y install epel-release
dnf -y install http://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm
dnf -y install ohpc-base-compute
dnf -y install ohpc-release
dnf -y install ohpc-slurm-client
dnf -y install wget curl python3-pip jq git make nfs-utils libnfs
dnf -y install lmod-ohpc

# losf and deps
dnf -y install losf-ohpc
dnf -y install perl-Sys-Syslog
dnf -y install perl-Log-Log4perl
dnf -y install perl-Config-IniFiles
dnf -y install perl-Env
