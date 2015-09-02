include "::ntp"

file_line { "add s3 apt repository":
    path => "/etc/apt/sources.list",
    line => "deb https://octo-debian-packages.s3.amazonaws.com stable main",
    notify => Exec["apt-get update"],
}

exec { "apt-get update":
    command => "/usr/bin/apt-get update",
}

package { "helloworld":
    ensure => "installed",
    install_options => "--force-yes",
    require => File_Line["add s3 apt repository"],
}
