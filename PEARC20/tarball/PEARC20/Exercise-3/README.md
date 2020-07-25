
## Elastic cluster with OOD and X2go

All AMIs needed for this exercise are public. The packer-templates are included for those who wish to customize and deploy their own.


### Step 1 -- Deploying the cluster

~~~

$ cd ~/PEARC20/Exercise-3/cfn-templates
$ aws cloudformation deploy --template-file slurm-dynamic-ood-ohpc.yml --capabilities CAPABILITY_IAM --stack-name ex3-$$ --region us-east-1
~~~


