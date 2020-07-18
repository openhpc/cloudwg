#!/bin/bash

export SLURM_HEADNODE_IPADDR=$(curl -sS http://169.254.169.254/latest/meta-data/local-ipv4)
export SLURM_HEADNODE_AWS_REGION=$(curl -sS http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
export COMPUTE_SG=@COMPUTESG@
export COMPUTE_SUBNET_ID=@SUBNETID@
export AWS_DEFAULT_MAC=$(curl -sS http://169.254.169.254/latest/meta-data/mac)
export AWS_SECURITY=$(curl -sS http://169.254.169.254/latest/meta-data/network/interfaces/macs/$AWS_DEFAULT_MAC/security-group-ids)
export AWS_AMI=@COMPUTEAMI@
export AWS_KEYNAME=@KEYNAME@
export SLURM_ROOT=/etc/slurm
export SLURM_POWER_LOG=$SLURM_ROOT/power_save.log

function start_node()
{
    NODE_JSON=$(mktemp)

    aws ec2 run-instances --image-id $AWS_AMI \
                          --instance-type t3.2xlarge \
                          --key-name $AWS_KEYNAME \
                          --security-group-ids "$COMPUTE_SG" \
                          --subnet-id "$COMPUTE_SUBNET_ID" \
                          --private-ip-address $2 \
                          --iam-instance-profile Name=$COMPUTE_PROFILE \
                          --user-data file://$SLURM_ROOT/slurm-compute-userdata.sh \
                          --region $SLURM_HEADNODE_AWS_REGION \
                          --block-device-mappings \
                            '[
                              {
                               "DeviceName":"/dev/sda1",
                               "Ebs": {
                                       "DeleteOnTermination": true,
                                       "VolumeSize": 340
                                      }
                              }
                             ]' \
                          --tag-specifications \
                            "ResourceType=instance,Tags= \
                              [{Key=Name,Value=SlurmCompute},
                               {Key=SlurmLabel,Value=$1}]" \
    |& tee $NODE_JSON >> $SLURM_POWER_LOG
}

function nametoip()
{
    echo $1 | tr "-" "." | cut -c 4-
}

echo "`date` Resume invoked $0 $*" >> $SLURM_POWER_LOG
hosts=$(/usr/bin/scontrol show hostnames $1)
num_hosts=$(echo "$hosts" | wc -l)
for hostname in $hosts
do
  private_ip=$(nametoip $hostname)
  start_node $hostname $private_ip
  /usr/bin/scontrol update nodename=$hostname nodehostname=$hostname nodeaddr=$private_ip
  rm $NODE_JSON
done
