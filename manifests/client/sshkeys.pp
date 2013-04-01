class backupninja::client::sshkeys (
  $keydir = '/etc/backup.d',
  $keytype = 'rsa',
  $keylength = '2048'
  ) {
  
  if ! defined( File[$keydir] ) {
    file { $keydir:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0700'
    }
  }
  
  if ! defined( File["${keydir}/.ssh"] ) {
    file { "${keydir}/.ssh":
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0700'
    }
  }

  # make sure vars don't change when consumed
  $thehostname = "${::fqdn}.bn"

  @@sshkeys::create_key { $thehostname:
    tag => 'backupninja'
  }
  
  sshkeys::set_client_key_pair { $thehostname:
    keyname => $thehostname,
    home    => $keydir,
    user    => 'root',
    require => File["${keydir}/.ssh"]
  }
}
