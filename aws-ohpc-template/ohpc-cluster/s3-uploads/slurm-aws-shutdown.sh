#!/bin/bash

export SLURM_ROOT=/cluster/slurm
export SLURM_CONF=$SLURM_ROOT/etc/slurm.conf
export CLUSTER_REGION=$(curl -sS http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
export SLURM_POWER_LOG=$SLURM_ROOT/power_save.log

function aws_shutdown()
{
    COMPUTE_INSTANCE=$(aws ec2 describe-instances \
        --filter Name=tag:SlurmLabel,Values=$1 \
        --query 'Reservations[].Instances[].InstanceId' \
        --region $CLUSTER_REGION \
    | jq -r '.[]')

    aws ec2 terminate-instances \
        --instance-ids $COMPUTE_INSTANCE \
        --region $CLUSTER_REGION \
    >> $SLURM_POWER_LOG 2>&1
}

echo "`date` Suspend invoked $0 $*" >> $SLURM_POWER_LOG
hosts=$($SLURM_ROOT/bin/scontrol show hostnames $1)
num_hosts=$(echo "$hosts" | wc -l)
for host in $hosts
do
   aws_shutdown $host
   $SLURM_ROOT/bin/scontrol reconfigure
   sleep 1
done
