# apachemodule
Puppet module used to install apache moduels from source
Tested only with debian 7 and 8

# Usage
Install mod_remoteip with custom config file
```Puppet
  apachemodule::install { "remoteip":
    gitsource => "https://github.com/ttkzw/mod_remoteip-httpd22.git"
  }

  file { 'remoteip.conf':
    path    => '/etc/apache2/mods-available/remoteip.conf',
    owner   => 'root',
    group   => 'root',
    ensure  => present,
    mode    => 0644,
    # using RemoteIPInternalProxy instade of RemoteIPTrustedProxy here becouse we use internal addresses on konf ;)
    # on production RemoteIPTrustedProxy is beter choice
    content => "RemoteIPHeader X-Forwarded-For\nRemoteIPInternalProxy 127.0.0.1",
    require => Apachemodule::Install['remoteip'],
    notify  => Class['apache::service']
  }

  ::apache::mod { 'remoteip':
    require => Apachemodule::Install['remoteip']
  }
```

Install mod_download_token without configuration
```Pupept
  apachemodule::install { "download_token":
    gitsource                => "https://github.com/ajakubek/mod_download_token.git",
    runbeforecompile         => '/bin/sed "s/\/usr\/lib\/apache2/\/usr\/share\/apache2/" Makefile > Makefile.new && mv Makefile.new Makefile',
    runbeforecompile_onlyif => '/bin/grep -q "/usr/lib/apache2" Makefile'
  }

  ::apache::mod { 'download_token':
    require => Apachemodule::Install['download_token']
  }
```
