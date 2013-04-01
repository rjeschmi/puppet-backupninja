class backupninja::client (
  $duplicity_conf = undef,
  $mysql_conf = undef
  ) inherits backupninja::params {
  
  Class['backupninja::client::package'] ->  Class['backupninja::client::config']
  Class['backupninja::client::config'] -> Class['backupninja::client::sshkeys'] 
   
  class { 'backupninja::client::package': 
  }
  class { 'backupninja::client::config':
    configdir => $backupninja::params::configdir
  }
  class { 'backupninja::client::sshkeys': 
    keydir => $backupninja::params::configdir
  }

  $duplicity_defaults = { 
    configdir  => $backupninja::params::configdir,
    sshoptions => "-oIdentityFile=${backupninja::params::configdir}/.ssh/id_rsa",
    desthost   => $backupninja::params::backup_server,
    destuser   => $backupninja::params::backup_user,
    destdir    => '/incoming',
    desttype   => 'sftp'
  }

  if $duplicity_conf {
    create_resources('backupninja::duplicity',$duplicity_conf,$duplicity_defaults)
  }
  
  $mysql_defaults = {
    configdir  => $backupninja::params::configdir
  }

  if $mysql_conf {
    create_resouces('backupninja::mysql',$mysql_conf,$mysql_defaults)
  }

  #makes sure variables don't change when they are consumed
  $thehostname  = "${::fqdn}.bn"

  case $backupninja::params::sandbox_type {
    'sftp' : {
      @@backupninja::sandbox::sftp { $thehostname:
        thehostname => $thehostname,
        sandboxuser => $backupninja::params::backup_user,
        tag         => $backupninja::params::sandbox_tag
      }
    }
  }
}
