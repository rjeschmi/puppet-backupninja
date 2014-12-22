class backupninja::client::package (
  $ensure = present
  ) {
  
  package { 'backupninja':
    ensure => $ensure
  }
}
