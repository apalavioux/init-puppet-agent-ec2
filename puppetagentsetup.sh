#!/bin/bash
(cd /opt/puppetlabs/puppet/modules/puppetagentinit && git reset --hard HEAD)
git --git-dir=/opt/puppetlabs/puppet/modules/puppetagentinit/.git --work-tree=/opt/puppetlabs/puppet/modules/puppetagentinit/ pull
puppet apply --logdest console --logdest syslog -e "include puppetagentinit::ec2"
