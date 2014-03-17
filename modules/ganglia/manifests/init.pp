#
# install and configure gmond on host
#
class ganglia (
  $cluster_name      = "Snooze",
  $cluster_owner     = "Snooze",
  $cluster_latlong   = "N?W?",
  $cluster_url       = "http://snooze.inria.fr",
  $host_location     = "grid5000",
  $udp_recv_channel  = [ { port  => 8649 } ],
  $udp_send_channel  = [ { port  => 8649 } ], 
  $tcp_accept_channel = [ { port => 8649 } ],
)
{
  
  package { 'ganglia-monitor':
    ensure => installed,
  }

  service { 'ganglia-monitor':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    status    => "pgrep -u ganglia -f /usr/sbin/gmond",
    require   => Package['ganglia-monitor'],
  }
 
  file { '/etc/ganglia/gmond.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ganglia/gmond.conf.erb'),
    require => Package['ganglia-monitor'],
    notify  => Service['ganglia-monitor']

  }

}
