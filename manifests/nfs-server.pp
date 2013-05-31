class {
  'nfs::server':
    shared => "/tmp/snooze",
    uid    => "snoozeadmin",
    gid    => "snooze"
}
