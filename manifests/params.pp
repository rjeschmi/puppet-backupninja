class backupninja::params {
  $backup_server  = hiera('backupninja::backup_server',undef)
  $backup_user    = hiera('backupninja::backup_user',"bn-${::hostname}${::uniqueid}")
  $backupdir      = hiera('backupninja::backupdir','/home/backupninja')
  $configdir      = hiera('backupninja::configdir','/etc/backup.d')
  $sandbox_type   = hiera('backupninja::sandbox_type','sftp')
  $sandbox_tag    = hiera('backupninja::sandbox_tag','default')
  
  $sftp_restricted_group = hiera('backupninja::sftp_restricted_group','sftponly')

}
