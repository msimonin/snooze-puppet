 import "./common.pp"
 include "libvirt"
 include "zookeeper"
 include "java"

$groupManagerHeartbeatPort = 1000+$idfromhost

class { 
  'snoozenode':
    type                      => "groupmanager",
    controlDataPort           => 5000,
    listenAddress             => $ipaddress,
    multicastAddress          => "225.4.5.16",
    groupManagerHeartbeatPort => $groupManagerHeartbeatPort,
		zookeeperHosts            => ["10.0.0.2"],
		virtualMachineSubnet      => ["10.0.1.0/24"]
}
