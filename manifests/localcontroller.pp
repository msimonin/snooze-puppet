#include "kadeploy3"
#include "snoozeclient"

class { 
  'snoozenode':
    type                             => "groupmanager",
    numberOfEntriesPerGroupManager   => 60,
    numberOfEntriesPerVirtualMachine => 300
}

user {'snoozeadmin':
  ensure  => present,
  name    => 'snoozeadmin',
  uid     => 32000,
  groups  => ['snooze'],
  require => [Group['snooze']]
}

group { 'snooze':
  ensure => present,
  name   => 'snooze',
  gid    => 32001
}

exec { 'apt-update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

Exec['apt-update'] -> Class['snoozenode']
