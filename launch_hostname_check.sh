#!/bin/bash
(cd /opt/puppetlabs/puppet/modules/set_hostname_ec2 && git reset --hard HEAD)
git --git-dir=/opt/puppetlabs/puppet/modules/set_hostname_ec2/.git --work-tree=/opt/puppetlabs/puppet/modules/set_hostname_ec2/ pull
puppet apply --logdest console --logdest syslog -e "include set_hostname_ec2"
puppet agent -t