class snoozeimages(
  $listenAddress     = 'localhost',
  $listenPort        = '4000',
  $repositoryType    = 'libvirt',
  $libvirtRepository = {},
  $libvirtPool       = {'name' => 'snooze', 'type' => 'dir', 'target' => '/tmp/snooze/images'},
  $snoozeimagesUser  = 'snoozeimagesadmin',
  $snoozeimagesGroup = 'snoozeimages'
){

  require 'java'
  require 'libvirt'

  user { $snoozeimagesUser:
    ensure  => "present",
    uid     => 33000,
    groups  => ["$snoozeimagesGroup"],
    require => [Group[$snoozeimagesGroup]]
  }

  group { $snoozeimagesGroup:
    ensure     => "present",
    gid        => 33001   
  }

  file { '/opt/snoozeimages':
    ensure => 'directory',
  }

  file { '/opt/snoozeimages/snoozeimages.deb':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/snoozeimages/snoozeimages.deb',
    require => File['/opt/snoozeimages'],
  }

  package { 'snoozeimages':
    provider => dpkg,
    source   => '/opt/snoozeimages/snoozeimages.deb',
    require  => [File['/opt/snoozeimages/snoozeimages.deb'], Package['openjdk-7-jre']],
  }

  file { 'snooze_images.cfg':
    ensure  => file,
    path    => '/usr/share/snoozeimages/configs/snooze_images.cfg',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('snoozeimages/snooze_images.cfg.erb'),
    require => Package['snoozeimages']
  }

  file { 'snoozeimages':
    ensure  => file,
    path    => '/etc/init.d/snoozeimages',
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => template('snoozeimages/snoozeimages.initd.erb'),
    require => Package['snoozeimages']
  }

  libvirt_pool{ $libvirtPool['name']:
    ensure => active,
    type   => $libvirtPool['type'],
    target => $libvirtPool['target']
  }

}
