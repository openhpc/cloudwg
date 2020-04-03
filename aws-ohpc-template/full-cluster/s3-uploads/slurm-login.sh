#!/bin/bash

export SLURM_HOME=/cluster/slurm

# Setup MUNGE
yum --nogpgcheck install munge munge-libs munge-devel -y
echo "openhpcslurmclusteronawsopenhpcslurmclusteronawsopenhpcslurmclusteronaws" | tee /etc/munge/munge.key
chown munge:munge /etc/munge/munge.key
chmod 600 /etc/munge/munge.key
chown -R munge /etc/munge/ /var/log/munge/
chmod 0700 /etc/munge/ /var/log/munge/

systemctl enable munge
systemctl start munge

sleep 3

#Setup SLURM user tools
echo 'SLURM_HOME=/cluster/slurm' | tee /etc/profile.d/slurm.sh
echo 'SLURM_CONF=$SLURM_HOME/etc/slurm/slurm.conf' | tee -a /etc/profile.d/slurm.sh
echo 'PATH=$SLURM_HOME/bin:$PATH' | tee -a /etc/profile.d/slurm.sh
