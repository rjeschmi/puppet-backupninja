class backupninja::puppetserver {
  include sshkeys::keymaster
  Sshkeys::Create_key <<| tag == 'backupninja' |>>
}

