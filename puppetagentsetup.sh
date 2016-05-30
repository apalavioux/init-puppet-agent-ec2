#!/bin/bash
(cd /home/centos/puppet-modules/puppetagentinit && git reset --hard HEAD)
git --git-dir=/home/centos/puppet-modules/puppetagentinit/.git --work-tree=/home/centos/puppet-modules/puppetagentinit/ pull
puppet apply --modulepath /home/centos/puppet-modules --logdest console --logdest syslog -e "include puppetagentinit::ec2"
