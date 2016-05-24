class agent {
		Exec {
			path => ["/usr/bin","/bin","/usr/sbin","/sbin"]
		}

		$userdata = parse_userdata()

		if has_key($userdata, 'hostname') {
			$host_name = $userdata['hostname']
		}

		$public_dns = $facts['public-ipv4']

		if has_key($userdata, 'puppet') and has_key($userdata['puppet'], 'server') {
			$puppet_server = $userdata['puppet']['server']
		}

		exec { 	"host":
			command => "hostnamectl set-hostname ${host_name}",
		}

		line { preserve_host:
			file => "/etc/cloud/cloud.cfg",
			line => "preserve_host: true",
		}

		line { network_host:
			file => "/etc/sysconfig/network",
			line => "HOSTNAME=${host_name}",
		}

		exec { 	"agent_puppet_server":
			command => "puppet config set --section main server ${puppet_server}",
		}

		exec { 	"agent_env":
			command => "puppet config set --section main environment production",
		}
		exec { 	"agent_certname":
			command => "puppet config set --section main certname ${host_name}",
		}
		exec { 	"agent_runinterval":
			command => "puppet config set --section main runinterval 10m",
		}

		file { '/etc/hosts':
			content => template('init-puppet-agent-ec2/hosts.erb'),
			owner   => root,
			group   => root,
			ensure  => present,
			mode    => 755,
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
}