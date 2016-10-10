class apachemodule {
  package { ['git', 'make', 'libaprutil1-dev', 'libapr1-dev']:
    ensure => present
  }

  package { 'apache2-prefork-dev':
    require => Package['libaprutil1-dev'],
    ensure  => present
  }
}
