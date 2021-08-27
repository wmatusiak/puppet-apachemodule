class apachemodule {
  package { ['git', 'make', 'libaprutil1-dev', 'libapr1-dev']:
    ensure => present
  }

  if ($::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '13.10') >= 0) or ($::operatingsystem == 'Debian' and versioncmp($::operatingsystemrelease, '8') >= 0) {
    package { 'apache2-dev':
      require => Package['libaprutil1-dev'],
      ensure  => present
    }
  } else {
    package { 'apache2-prefork-dev':
      require => Package['libaprutil1-dev'],
      ensure  => present
    }
  }
}
