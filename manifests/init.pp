Exec {
		path => ["/usr/bin","/bin","/usr/sbin","/sbin"]
}


$userdata = parse_userdata()

notify {"userdata: ${userdata}":}

    if has_key($userdata, 'hostname') {
        $hostname = $userdata['hostname']
    }
    if has_key($userdata, 'puppet') and has_key($userdata['puppet'], 'server') {
        $puppet_server = $userdata['puppet']['server']
    }

notify {"hostname: ${hostname}":}
notify {"puppet_server: ${puppet_server}":}


exec { 	"host":
		command => "hostnamectl set-hostname ${hostname}",
}