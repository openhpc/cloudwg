#!/bin/bash
BASEDIR=/home/csim/git/cloudwg2/tutorial/


cd $BASEDIR/bin

for i in id_rsa*
do cat $i #>> ~/.ssh/authorized_keys
done

chmod 600 ~/.ssh/authorized_keys


