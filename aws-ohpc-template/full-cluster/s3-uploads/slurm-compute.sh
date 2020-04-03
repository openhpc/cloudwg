#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

export INSTANCE_ID=$(curl -sS http://169.254.169.254/latest/meta-data/instance-id)
export AWS_REGION=$(curl -sS http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
export LABEL=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" --region $AWS_REGION | jq -r '.Tags[] | select(.Key=="SlurmLabel") | .Value')

hostname $LABEL
echo $LABEL > /etc/hostname
sed -i "s|enforcing|disabled|g" /etc/selinux/config
setenforce 0

mkdir -p /cluster
mkdir -p /data
mkdir -p /lustre
cat <<EOF >> /etc/fstab
@EFS_HOME@:/  /home  efs  defaults,_netdev,fsc 0 0
@EFS_SLURM@:/  /cluster  efs  defaults,_netdev,fsc 0 0
@EFS_DATA@:/  /data  efs  defaults,_netdev,fsc 0 0
@LUSTRE_FS_DNS@@tcp:/@LUSTRE_FS_NAME@ /lustre lustre defaults,noatime,flock,_netdev 0 0
EOF

mount -a

export SLURM_HOME=/cluster/slurm

yum --nogpgcheck install munge munge-libs munge-devel -y
echo "openhpcslurmclusteronawsopenhpcslurmclusteronawsopenhpcslurmclusteronaws" | sudo tee /etc/munge/munge.key
chown munge:munge /etc/munge/munge.key
chmod 600 /etc/munge/munge.key
chown -R munge /etc/munge/ /var/log/munge/
chmod 0700 /etc/munge/ /var/log/munge/

systemctl enable munge
systemctl start munge

sudo yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel \
                 readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad rpm-build libXt libSM -y

mkdir -p /var/spool/slurm

echo 'SLURM_HOME=/cluster/slurm' | tee /etc/profile.d/slurm.sh
echo 'SLURM_CONF=$SLURM_HOME/etc/slurm.conf' | tee -a /etc/profile.d/slurm.sh
echo 'PATH=$SLURM_HOME/bin:$PATH' | tee -a /etc/profile.d/slurm.sh

cp $SLURM_HOME/etc/slurm/slurmd.service /lib/systemd/system

systemctl enable slurmd.service
systemctl start slurmd.service
