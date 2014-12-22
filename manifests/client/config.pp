class backupninja::client::config (
  $ensure = present,
  $configfile = '/etc/backupninja.conf',
  $loglvl = '4',
  $reportemail = 'root',
  $reportsuccess = 'yes',
  $reportinfo = 'no',
  $reportwarning = 'yes',
  $reportspace = 'no',
  $reporthost = '',
  $reportuser = 'ninja',
  $reportdir = '/var/lib/backupninja/reports',
  $configdir = '/etc/backup.d',
  $scriptdir = '/usr/share/backupninja',
  $logfile = '/var/log/backupninja.log',
  $usecolors = 'yes',
  $vservers = 'no',
  $when = 'everyday at 01:00' 
  ) {
 
  $real_reportsuccess = str2bool($reportsuccess)
  $real_reportinfo = str2bool($reportinfo)
  $real_reportwarning = str2bool($reportwarning)
  $real_reportspace = str2bool($reportspace)
  $real_usecolors = str2bool($usecolors)
  $real_vservers = str2bool($vservers)

  file { $configfile:
    ensure  => $ensure,
    content => template('backupninja/backupninja.conf.erb')
  }

  file { $configdir:
    ensure => $ensure ? {
      'present' => 'directory',
      'latest'  => 'directory',
      'absent'  => 'absent'
    },
    owner  => 'root',
    group  => 'root',
    mode   => '0700'
  }
}
