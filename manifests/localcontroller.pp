include "kadeploy3"
include "snoozeclient"

class { 
  'snoozenode':
    type                                 => "localcontroller",
}


exec { 'apt-update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

Exec['apt-update'] -> Class['snoozenode']
