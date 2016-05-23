Exec {
		path => ["/usr/bin","/bin","/usr/sbin","/sbin"]
}

exec { 	"host":
		command => "hostnamectl set-hostname puppet-agent-1",
}

$userdata = parse_userdata()

exec { 	"userdata":
		command => "echo $userdata",
}

    if has_key($userdata, 'hostname') {
        $hostname = $userdata['hostname']
    } else {
        warning('Unable to parse hostname from userdata')
        $hostname = false
    }
    if has_key($userdata, 'puppet') and has_key($userdata['puppet'], 'server') {
        $puppet_server = $userdata['puppet']['server']
    } else {
        $puppet_server = false
    }

exec { 	"hostname":
		command => "echo $hostname",
}
exec { 	"puppet_server":
		command => "echo $puppet_server",
}