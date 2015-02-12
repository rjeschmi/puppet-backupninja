class backupninja::server (
  $sandbox_type = "sftp",
  $sandbox_tag = "blah",
  $backupdir = '/home/backupninja',
  ) {

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
