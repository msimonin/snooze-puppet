class snoozenode(
    $type                                 = "bootstrap",
    $controlDataPort                      = 5000,
    $listenAddress                        = "localhost",
    $httpMaxIoIdleTimeMs                  = "60000",
    $multicastAddress                     = "225.4.5.6",
    $groupManagerHeartbeatPort            = 9000,
    $zookeeperHosts                       = ["localhost"],
    $virtualMachineSubnet                 = ["192.168.122.0/24"],
    $externalNotificationHost             = "localhost",
    $databaseType                         = "memory",
    $databaseCassandraHosts               = ["localhost"],
    $migrationMethod                      = "live",
    $migrationTimeout                     = 60,
    $numberOfEntriesPerGroupManager       = 20,
    $numberOfEntriesPerVirtualMachine     = 30,
    $groupManagerSchedulerPluginsDirectory= "/usr/share/snoozenode/plugins/groupManagerScheduler",
    $placementPolicy                      = "RandomScheduling",
    $imageRepositoryDiskPolicy            = "backing",
    $imageRepositorySource                = "/var/lib/libvirt/snoozeimages",
    $imageRepositoryDestination           = "/var/lib/libvirt/images",
    $reconfigurationEnabled               = false,
    $reconfigurationPolicy                = "Sercon",
    $reconfigurationInterval              = "0 0/1 *  * * ?",
    $energyManagementEnabled              = false,
    $energyManagementIdleTime             = 120,
    $energyManagementPowerSavingAction    = "suspendToRam",
    $energyManagementThresholdsWakeupTime = 300,
    $enableVnc                            = false 
    )
{

  require 'java'
  require 'libvirt'
  require 'zookeeper'

  package { 'pm-utils':
    ensure => "installed"
  }

  user { 'snoozeadmin':
    ensure  => "present",
    uid     => 32000,
    groups  => ["snooze", "libvirt"],
    require => [Group["snooze"],Group["libvirt"]]
  }

  group { 'snooze':
    ensure     => "present",
    gid        => 32001   
  }

  group { 'libvirt':
    ensure  => "present",
    require => Package["libvirt-bin"]
  }

  exec { $imageRepositoryDestination:
    command => "mkdir -p $imageRepositoryDestination",
    path    => "/bin"
  }

  file { $imageRepositoryDestination:
    ensure  => directory,
    owner   => "snoozeadmin",
    group   => "snooze",
    require => [Exec[$imageRepositoryDestination], User['snoozeadmin'], Group['snooze']]
  }


  file { 'snoozeadmin-sudoers':
    path   => '/etc/sudoers.d/snoozeadmin',
    ensure => file,
    owner  => "root",
    group  => "root",
    mode   => '0440',
    source => "puppet:///modules/snoozenode/etc/sudoers.d/snoozeadmin",
  }


  file { "/opt/snoozenode":
    ensure => "directory",
  }

  file { "/opt/snoozenode/snoozenode.deb":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => "puppet:///modules/snoozenode/snoozenode.deb",
    require => File['/opt/snoozenode'],
  }

  package { 'snoozenode':
    provider => dpkg,
    source   => "/opt/snoozenode/snoozenode.deb",
    require  => [File["/opt/snoozenode/snoozenode.deb"],Package["openjdk-7-jre"]],
  }

  file { 'snooze_node.cfg':
    path    => '/usr/share/snoozenode/configs/snooze_node.cfg',
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode    => '0644',
    content => template("snoozenode/snooze_node.cfg.erb"),
    require => Package["snoozenode"],
  }

}
