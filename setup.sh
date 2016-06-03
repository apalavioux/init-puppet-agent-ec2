#!/bin/bash
sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y install puppet-agent
sudo ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet
sudo yum -y install git
(cd /opt/puppetlabs/puppet/modules/ && sudo git clone https://github.com/apalavioux/init-puppet-agent-ec2.git puppetagentinit)
sudo cp /opt/puppetlabs/puppet/modules/puppetagentinit/puppetagentsetup.sh /var/lib/cloud/scripts/per-boot/
sudo chmod +x /var/lib/cloud/scripts/per-boot/puppetagentsetup.sh