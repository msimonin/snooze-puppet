class snoozeec2(
  $listenAddress          = "localhost",
  $listenPort             = 4000,
  $imageRepositoryAddress = "localhost",
  $imageRepositoryPort    = 4001,
  $bootstrapAddress       = "localhost",
  $bootstrapPort          = 5000
){

  file { "/opt/snoozeec2":
    ensure => "directory",
  }

 file { "/opt/snoozeec2/snoozeec2.deb":
   ensure  => present,
   owner   => root,
   group   => root,
   mode    => 644,
   source  => "puppet:///modules/snoozeec2/snoozeec2.deb",
   require => File['/opt/snoozeec2'],
 }

  package { 'snoozeec2':
   provider => dpkg,
   source   => "/opt/snoozeec2/snoozeec2.deb",
   require  => [File["/opt/snoozeec2/snoozeec2.deb"],Package["openjdk-7-jre"]],
  }

  file { 'snooze_ec2.cfg':
    path    => '/usr/share/snoozenode/configs/snooze_ec2.cfg',
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => "0644",
    content => template("snoozeec2/snooze_ec2.cfg.erb"),
    require => Package["snoozeec2"]
  }
}
