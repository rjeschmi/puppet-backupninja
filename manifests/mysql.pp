# Safe MySQL dumps, as part of a backupninja run.
#
# Valid attributes for this type are:
#
#   order: The prefix to give to the handler config filename, to set
#      order in which the actions are executed during the backup run.
#
#   ensure: Allows you to delete an entry if you don't want it any more
#      (but be sure to keep the configdir, name, and order the same, so
#      that we can find the correct file to remove).
#
#   user, dbusername, dbpassword, dbhost, databases, backupdir,
#   hotcopy, sqldump, compress, configfile: As defined in the
#   backupninja documentation, with the caveat that hotcopy, sqldump,
#   and compress take true/false rather than yes/no.
# 
define backupninja::mysql (
  $order = 10,
  $ensure = present, 
  $configdir = '/etc/backup.d',
  $user = undef, 
  $dbusername = undef, 
  $dbpassword = undef,
  $dbhost = 'localhost', 
  $databases = 'all', 
  $backupdir = '/var/backups/mysql', 
  $hotcopy = undef,
  $sqldump = undef, 
  $sqldumpoptions = undef,
  $compress = undef, 
  $configfile = undef,
  $vsname = undef 
  ) {

  $real_hotcopy = str2bool($hotcopy)
  $real_sqldump = str2bool($sqldump)
  $real_compress = str2bool($compress)

  file { "${configdir}/${order}_${name}.mysql":
    ensure => $ensure,
    content => template('backupninja/mysql.conf.erb'),
    owner => root,
    group => root,
    mode => 0600
  }
}

