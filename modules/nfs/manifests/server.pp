class nfs::server ($shared="", $uid="root", $gid="root") {
  package { 'nfs-kernel-server':
    ensure => installed,
  }

  service { 'nfs-kernel-server':
    name      => nfs-kernel-server,
    ensure    => running,
    enable    => true,
    require   => Package['nfs-kernel-server']
  }

  file {
    "$shared":
    ensure => directory,
    owner => $uid,
    group => $gid,
  }


  file {
    '/etc/exports':
       ensure  => file,
       content => "$shared *(rw,async,no_subtree_check,no_root_squash)",
       require => File["$shared"],
       notify => Service['nfs-kernel-server'],
  }    
} 
