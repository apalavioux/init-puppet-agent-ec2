# set_hostname_ec2, base class to set hostname on ec2 instances. Only CentOs 7
# for now.
class set_hostname_ec2 {

  Exec {
    path => ['/usr/bin','/bin','/usr/sbin','/sbin']
  }

  $userdata = parse_userdata()

  if has_key($userdata, 'hostname') {
    $host_name = $userdata['hostname']
  }

  if has_key($userdata, 'domainname') {
    $domain_name = $userdata['domainname']
  }

  $metadata = parse_metadata()
  $privateip = $metadata[local-ipv4]

  if has_key($userdata, 'puppet') and has_key($userdata['puppet'], 'server') {
    $puppet_server = $userdata['puppet']['server']
  }

  exec {   'host':
    command => "hostnamectl set-hostname ${host_name}.${domain_name}",
  }

  set_hostname_ec2::line { 'preserve_host':
    file => '/etc/cloud/cloud.cfg',
    line => 'preserve_hostname: true',
  }

  file { '/etc/sysconfig/network':
    ensure  => file,
    path    => '/etc/sysconfig/network',
    content => template('set_hostname_ec2/network.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  exec {   'agent_puppet_server':
    command => "puppet config set --section agent server ${puppet_server}",
  }

  exec {   'agent_env':
    command => 'puppet config set --section agent environment production',
  }

  exec {   'agent_certname':
    command => "puppet config set --section agent certname ${host_name}",
  }

  exec {   'agent_runinterval':
    command => 'puppet config set --section agent runinterval 10m',
  }

  file { '/etc/hosts':
    ensure  => file,
    path    => '/etc/hosts',
    content => template('set_hostname_ec2/hosts.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }
}
