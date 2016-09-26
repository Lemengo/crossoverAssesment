file { '/etc/icinga/objects/icinga.cfg':
        ensure => 'present',
        owner => 'root',
        group => 'root',
        mode => '664',
		replace => 'no',
        content => '
define host{
        use                     generic-host
        host_name               remote
        alias                   remote
        address                 172.31.53.3
}
define service {
        use                     generic-service
        host_name               remote
        service_description     HTTP
        check_command           check_http
}
define service {
        use                     generic-service
        host_name               remote
        service_description     MYSQL
        check_command           check_tcp -p 3306
},
}