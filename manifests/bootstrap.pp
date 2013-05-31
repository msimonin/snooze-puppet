 import "./common.pp"
 include "snoozeclient"

$groupManagerHeartbeatPort = 1000+$idfromhost

class { 
  'snoozenode':
  type                      => "bootstrap",
  controlDataPort           => 5000,
  listenAddress             => $ipaddress,
  multicastAddress          => "225.4.5.16",
  groupManagerHeartbeatPort => $groupManagerHeartbeatPort,
  zookeeperHosts            => ["10.0.0.2"],
  virtualMachineSubnet      => ["10.0.1.0/24"],
}

class { 
  'zookeeper::zookeeperd': 
   zookeeperHosts            => ["10.0.0.2"],
}
