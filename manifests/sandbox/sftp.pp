define backupninja::sandbox::sftp (
  $sandboxdir,
  $thehostname,
  $sandboxuser,
  $restricted_group,
  ) {

  $homedir = "${sandboxdir}/${thehostname}"

  user { $sandboxuser:
    ensure  => present,
    comment => "Backupninja Sandbox",
    home    => $homedir,
    system  => true,
    gid     => $restricted_group
  }   

  file { $homedir:
    ensure => directory,
    owner  => $sandboxuser,
    group  => $restricted_group,
    mode   => '0700'
  }

  file { "${homedir}/incoming":
    ensure  => directory,
    owner   => $sandboxuser,
    group   => $restricted_group,
    mode    => '0700',
    require => File[$homedir]
  }

  file { "${homedir}/.ssh":
    ensure => directory,
    owner  => $sandboxuser,
    group  => $restricted_group,
    mode   => '0700',
    require => File[$homedir]
  }

  file { "${homedir}/.ssh/authorized_keys":
    ensure => present,
    owner  => $sandboxuser,
    group  => $restricted_group,
    mode   => '0440',
    require => File["${homedir}/.ssh"]
  }

  sshkeys::set_authorized_keys { $sandboxuser:
    keyname => $thehostname,
    user    => $sandboxuser,
    home    => $homedir,
    require => File["${homedir}/.ssh/authorized_keys"]
  }
}


