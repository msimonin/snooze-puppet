class snoozeec2(
  $listenAddress          = 'localhost',
  $listenPort             = 4000,
  $imageRepositoryAddress = 'localhost',
  $imageRepositoryPort    = 4001,
  $bootstrapAddress       = 'localhost',
  $bootstrapPort          = 5000,
  $snoozeec2User          = 'snoozeec2admin',
  $snoozeec2Group         = 'snoozeec2'
){

  require 'java'

  user { $snoozeec2User:
    ensure  => "present",
    uid     => 34000,
    groups  => ["$snoozeec2Group"],
    require => [Group[$snoozeec2Group]]
  }

  group { $snoozeec2Group:
    ensure     => "present",
    gid        => 34001   
  }


  file { '/opt/snoozeec2':
    ensure => 'directory',
  }

  file { '/opt/snoozeec2/snoozeec2.deb':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/snoozeec2/snoozeec2.deb',
    require => File['/opt/snoozeec2'],
  }

  package { 'snoozeec2':
    provider => dpkg,
    source   => '/opt/snoozeec2/snoozeec2.deb',
    require  => [File['/opt/snoozeec2/snoozeec2.deb'],Package['openjdk-7-jre']],
  }

  file { 'snooze_ec2.cfg':
    ensure  => file,
    path    => '/usr/share/snoozeec2/configs/snooze_ec2.cfg',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('snoozeec2/snooze_ec2.cfg.erb'),
    require => Package['snoozeec2']
  }

  file { 'snoozeec2':
    ensure  => file,
    path    => '/etc/init.d/snoozeec2',
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => template('snoozeec2/snoozeec2.initd.erb'),
    require => Package['snoozeec2']
  }

}
