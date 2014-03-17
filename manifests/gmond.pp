include 'ganglia'

exec { 'apt-update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

Exec['apt-update'] -> Class['ganglia']
