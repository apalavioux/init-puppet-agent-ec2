include aws

class puppetagentinit::ec2 {
		Exec {
			path => ["/usr/bin","/bin","/usr/sbin","/sbin"]
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

		exec { 	"host":
			command => "hostnamectl set-hostname ${host_name}.${host_name}",
		}

		line { preserve_host:
			file => "/etc/cloud/cloud.cfg",
			line => "preserve_hostname: true",
		}

		file { '/etc/sysconfig/network':
			path	=> '/etc/sysconfig/network',
			content => template('puppetagentinit/network.erb'),
			owner   => root,
			group   => root,
			ensure  => file,
			mode    => '644',
		}

		exec { 	"agent_puppet_server":
			command => "puppet config set --section agent server ${puppet_server}",
		}

		exec { 	"agent_env":
			command => "puppet config set --section agent environment production",
		}
		exec { 	"agent_certname":
			command => "puppet config set --section agent certname ${host_name}",
		}ll /
		exec { 	"agent_runinterval":
			command => "puppet config set --section agent runinterval 10m",
		}

		file { '/etc/hosts':
			path	=> '/etc/hosts',
			content => template('puppetagentinit/hosts.erb'),
			owner   => root,
			group   => root,
			ensure  => file,
			mode    => '644',
		}
}

		define line($file, $line, $ensure = 'present') {
			case $ensure {
				default : { err ( "unknown ensure value ${ensure}" ) }
				present: {
					exec { "/bin/echo '${line}' >> '${file}'":
						unless => "/bin/grep -qFx '${line}' '${file}'"
					}
				}
				absent: {
					exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
						onlyif => "/bin/grep -qFx '${line}' '${file}'"
					}
				}
			}
		}