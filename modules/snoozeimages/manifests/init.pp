class snoozeimages(){

  file { "/opt/snoozeimages":
    ensure => "directory",
  }

 file { "/opt/snoozeimages/snoozeimages.deb":
   ensure  => present,
   owner   => root,
   group   => root,
   mode    => 644,
   source  => "puppet:///modules/snoozeimages/snoozeimages.deb",
   require => File['/opt/snoozeimages'],
 }

 package { 'snoozeimages':
   provider => dpkg,
   source  => "/opt/snoozeimages/snoozeimages.deb",
   require => [File["/opt/snoozeimages/snoozeimages.deb"],Package["openjdk-7-jre"]],
  }

}
