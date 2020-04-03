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

cat <<EOF >> /etc/fstab
@EFS_HOME@:/  /home  efs  defaults,_netdev,fsc 0 0
@EFS_SLURM@:/  /cluster  efs  defaults,_netdev,fsc 0 0
EOF

mount -a

systemctl enable slurmd.service
systemctl start slurmd.service
