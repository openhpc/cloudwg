#!/bin/bash


zypper -n update
#zypper -n config-manager --set-enabled PowerTools
#zypper -n install epel-release
rpm -ivh http://repos.openhpc.community/OpenHPC/2/Leap_15/x86_64/ohpc-release-2-1.leap15.x86_64.rpm
zypper -n --gpg-auto-import-keys install ohpc-base
zypper -n install ohpc-release
zypper -n install ohpc-slurm-server
zypper -n install lmod-ohpc

# dev packages
zypper -n install ohpc-autotools
zypper -n install EasyBuild-ohpc
zypper -n install hwloc-ohpc
zypper -n install spack-ohpc
zypper -n install valgrind-ohpc
# gnu9 serial/threaded packages
zypper -n install ohpc-gnu9-serial-libs
zypper -n install ohpc-gnu9-runtimes
zypper -n install hdf5-gnu9-ohpc
zypper -n install python3-numpy-gnu9-ohpc

# install gnu9/mpich and gnu9/openmpi package variants
zypper -n install ohpc-gnu9-mpich*
zypper -n install ohpc-gnu9-openmpi4*
zypper -n install lmod-defaults-gnu9-openmpi4-ohpc
zypper -n install wget curl python3-pip jq git make nfs-utils

# test suite
zypper -n install test-suite-ohpc

