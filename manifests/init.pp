Exec {
		path => ["/usr/bin","/bin","/usr/sbin","/sbin"]
}

$userdata = parse_userdata()

if has_key($userdata, 'hostname') {
	$host_name = $userdata['hostname']
}
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
	command => "puppet config set --section agent server ${puppet_server}",
}

exec { 	"agent_env":
	command => "puppet config set --section agent environment production",
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