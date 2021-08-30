define apachemodule::install (
  $gitsource = undef,
  $runbeforecompile = undef,
  $runbeforecompile_onlyif = undef
) {
  if $gitsource {
    exec { "${name}_src_download":
      command => "/usr/bin/git clone ${gitsource} ${name}",
      cwd     => "/usr/src",
      creates => "/usr/src/${name}",
      require => Package['git']
    }

    exec { "${name}_src_update":
      command => "/usr/bin/git pull origin master",
      cwd     => "/usr/src/${name}",
      require => Exec["${name}_src_download"]
    }
  }

  if $runbeforecompile {
    exec { "${name}_before_compile":
      command => $runbeforecompile,
      onlyif  => $runbeforecompile_onlyif,
      cwd     => "/usr/src/${name}",
      require => Exec["${name}_src_update"],
      before  => Exec["${name}_compile"]
    }
  }

  if ($::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '13.10') >= 0) or ($::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '8') >= 0) {
    $apache2dev = "apache2-dev"
  } else {
    $apache2dev = "apache2-prefork-dev"
  }
  
  exec { "${name}_compile":
    command => "/usr/bin/make",
    cwd     => "/usr/src/${name}",
    creates => "/usr/lib/apache2/modules/mod_${name}.so",
    require => [
      Exec["${name}_src_update"],
      Package['make'],
      Package['libaprutil1-dev'],
      Package['libapr1-dev'],
      Package["${apache2dev}"]
    ]
  }

  exec { "${name}_install":
    command => "/usr/bin/make install",
    cwd     => "/usr/src/${name}",
    creates => "/usr/lib/apache2/modules/mod_${name}.so",
    require => [
      Exec["${name}_compile"],
      Package['make']
    ]
  }
}
