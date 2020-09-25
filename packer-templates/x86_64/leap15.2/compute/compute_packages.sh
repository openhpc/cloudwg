#!/bin/bash

zypper -n update
rpm -ivh http://repos.openhpc.community/OpenHPC/2/Leap_15/x86_64/ohpc-release-2-1.leap15.x86_64.rpm
zypper -n --gpg-auto-import-keys install ohpc-base
zypper -n install ohpc-release
zypper -n install ohpc-slurm-client
zypper -n install lmod-ohpc

