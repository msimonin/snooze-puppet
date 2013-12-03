class {
  "snoozeimages":
    listenPort => 7654
}

class {
  "snoozeec2":
    listenPort          => 4567,
    imageRepositoryPort => 7654
}

exec { 'apt-update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

Exec['apt-update'] -> Class['snoozeimages'] -> Class['snoozeec2']

