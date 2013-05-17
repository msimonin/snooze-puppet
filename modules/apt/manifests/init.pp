class apt{
  
  exec { 'apt-get_update':
    command => "/usr/bin/apt-get update",
  }
}
