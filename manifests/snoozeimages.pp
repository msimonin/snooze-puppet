class {
  "snoozeimages":
    listenPort  => 7654,
    libvirtPool => {
      'name'    => 'snoozePool',
      'target'  => '/tmp/snoozePool/images',
      'type'    => 'dir'
    } 
}


exec { 'apt-update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

Exec['apt-update'] -> Class['snoozeimages'] 

