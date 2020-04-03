#!/bin/bash -xe

AWS_DEFAULT_MAC=$(curl -sS http://169.254.169.254/latest/meta-data/mac)
AWS_VPC_CIDR=$(curl -sS http://169.254.169.254/latest/meta-data/network/interfaces/macs/$AWS_DEFAULT_MAC/vpc-ipv4-cidr-block)

yum --nogpgcheck install munge munge-libs munge-devel -y
echo "openhpcslurmclusteronawsopenhpcslurmclusteronawsopenhpcslurmclusteronaws" | tee /etc/munge/munge.key
chown munge:munge /etc/munge/munge.key
chmod 600 /etc/munge/munge.key
chown -R munge /etc/munge/ /var/log/munge/
chmod 0700 /etc/munge/ /var/log/munge/
systemctl enable munge
systemctl start munge

yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad rpm-build mysql mysql-devel mariadb-server -y
yum groupinstall "Development Tools" -y

tar -xvf /root/slurm-*.tar.bz2 -C /root
cd /root/slurm-*
/root/slurm-*/configure --prefix=/cluster/slurm
make -j 4
make install

export SLURM_HOME=/cluster/slurm

mkdir -p $SLURM_HOME/etc/slurm
cp /root/slurm-*/etc/* $SLURM_HOME/etc/slurm
cp $SLURM_HOME/etc/slurm/slurmd.service /lib/systemd/system
cp $SLURM_HOME/etc/slurm/slurmctld.service /lib/systemd/system

cp /cluster/downloads/slurm.conf $SLURM_HOME/etc/
cp /cluster/downloads/topology.conf $SLURM_HOME/etc/
cp /cluster/downloads/slurm-compute* $SLURM_HOME/bin/

export IPADDR=$(curl -sS http://169.254.169.254/latest/meta-data/local-ipv4)
sed -i "s|@IP@|$IPADDR|g" $SLURM_HOME/etc/slurm.conf
sed -i "s|@HEADNODE@|slurm-controller|g" $SLURM_HOME/etc/slurm.conf

echo 'SLURM_HOME=/cluster/slurm' | tee /etc/profile.d/slurm.sh
echo 'SLURM_CONF=$SLURM_HOME/etc/slurm/slurm.conf' | tee -a /etc/profile.d/slurm.sh
echo 'PATH=$SLURM_HOME/bin:$PATH' | tee -a /etc/profile.d/slurm.sh

mkdir -p /var/spool/slurm
cp /cluster/downloads/slurm-aws* $SLURM_HOME/bin
chmod +x $SLURM_HOME/bin/slurm-aws*

systemctl enable slurmctld
systemctl start slurmctld
