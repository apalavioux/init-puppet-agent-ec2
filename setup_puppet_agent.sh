#!/bin/bash
sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y install puppet-agent
sudo ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet
sudo yum -y install git
(cd /opt/puppetlabs/puppet/modules/ && sudo git clone https://github.com/apalavioux/set_hostname_ec2.git)
sudo cp /opt/puppetlabs/puppet/modules/set_hostname_ec2/launch_hostname_check.sh /var/lib/cloud/scripts/per-boot/
sudo chmod +x /var/lib/cloud/scripts/per-boot/launch_hostname_check.sh