class backupninja::server (
  $sandbox_type = $backupninja::params::sandbox_type,     # only sftp supported right now
  $sandbox_tag = $backupninja::params::backup_server,
  $backupdir = $backupninja::params::backupdir,
  ) inherits backupninja::params {

  file { $backupdir: 
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }
  
  case $sandbox_type {
    'sftp' : {
      Backupninja::Sandbox::Sftp <<| tag == $sandbox_tag |>> {
        sandboxdir       => $backupdir,
        restricted_group => $backupninja::params::sftp_restricted_group
      }
    }
  }
}
