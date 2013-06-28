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
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
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
    owner  => 'root',
    group  => $restricted_group,
    mode   => '0750',
    require => File[$homedir]
  }

  file { "${homedir}/.ssh/authorized_keys":
    ensure => present,
    owner  => 'root',
    group  => $restricted_group,
    mode   => '0440',
    require => File["${homedir}/.ssh"]
  }

  sshkeys::set_authorized_keys { $sandboxuser:
    keyname => $thehostname,
    user    => 'root',
    home    => $homedir,
    require => File["${homedir}/.ssh/authorized_keys"]
  }
}


