#!/bin/bash

dnf -y update
dnf -y config-manager --set-enabled PowerTools
dnf -y install epel-release
dnf -y install http://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm
dnf -y install ohpc-base
dnf -y install ohpc-release
dnf -y install ohpc-slurm-server
dnf -y install lmod-ohpc
dnf -y docs-ohpc

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
dnf -y install python3-numpy-gnu9-ohpc

# install gnu9/mpich and gnu9/openmpi package variants
dnf -y install ohpc-gnu9-mpich*
dnf -y install ohpc-gnu9-openmpi4*
dnf -y install lmod-defaults-gnu9-openmpi4-ohpc
dnf -y install wget curl python3-pip jq git make nfs-utils
# include optional mpich variant
dnf -y install mpich-ucx-gnu9-ohpc

# losf deps
dnf -y install perl-Sys-Syslog
dnf -y install perl-Log-Log4perl
dnf -y install perl-Config-IniFiles
dnf -y install perl-Env

pip3 install awscli

