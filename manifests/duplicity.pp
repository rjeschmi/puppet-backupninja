# Run duplicity-backup as part of a backupninja run.
#
# Valid attributes for this type are:
#
#   order:
#
#      The prefix to give to the handler config filename, to set order in
#      which the actions are executed during the backup run.
#
#   ensure:
#
#      Allows you to delete an entry if you don't want it any more (but be
#      sure to keep the configdir, name, and order the same, so that we can
#      find the correct file to remove).
#
#   options, nicelevel, testconnect, tmpdir, sign, encryptkey, signkey,
#   password, include, exclude, vsinclude, incremental, keep, bandwidthlimit,
#   sshoptions, destdir, desthost, desuser:
#
#      As defined in the backupninja documentation.  The options will be
#      placed in the correct sections automatically.  The include and
#      exclude options should be given as arrays if you want to specify
#      multiple directories.
#
#   directory, ssh_dir_manage, ssh_dir, authorized_keys_file, installuser,
#   installkey, backuptag:
#
#      Options for the bakupninja::server::sandbox define, check that
#      definition for more info.
#
# Some notes about this handler:
#
#   - When specifying a password, be sure to enclose it in single quotes,
#     this is particularly important if you have any special characters, such
#     as a $ which puppet will attempt to interpret resulting in a different
#     password placed in the file than you expect!
#   - There's no support for a 'local' type in backupninja's duplicity
#     handler on version 0.9.6-4, which is the version available in stable and
#     testing debian repositories by the time of this writing.
define backupninja::duplicity ( 
  $order  = 90,
  $ensure = present,
  $configdir = '/etc/backup.d',
  # options to the config file
  $options     = undef,
  $nicelevel   = undef,
  $testconnect = undef,
  $tmpdir      = undef,
  # [gpg]
  $sign       = undef,
  $encryptkey = undef,
  $signkey    = undef,
  $password,
  # [source]
  $include = [ ],
  $exclude = [ ],
  $vsinclude = false,
  # [dest]
  $incremental   = 'yes',
  $keep          = undef,
  $bandwidthlimit = undef,
  $sshoptions    = undef,
  $destdir       = undef,
  $desthost      = undef,
  $destuser      = undef,
  $desttype      = undef,
  ) {
  
  $duplicity_backends = [
    'file',
    'ftp',
    'ftps',
    'gdocs',
    'hsi',
    'imap',
    'imaps',
    'rsync',
    's3',
    's3+http',
    'cf+http',
    'ssh',
    'scp',
    'sftp',
    'tahoe',
    'u1',
    'u1+http'
  ]

  if ! defined_with_params(Package['duplicity'], {'ensure' => 'present'}) {
    package { 'duplicity': ensure => present, }
  }
  if ! defined_with_params(Package['python-paramiko'], {'ensure' => 'present'}) {
    package { 'python-paramiko': ensure => present, }
  }
  
  validate_string($destuser)
  validate_string($destdir)
  validate_string($desthost)
  validate_re($desttype, $duplicity_backends)
  $desturl = "${desttype}://${destuser}@${desthost}${destdir}"

  file { "${configdir}/${order}_${name}.dup":
    ensure  => $ensure,
    content => template('backupninja/dup.conf.erb'),
    owner   => root,
    group   => root,
    mode    => 0600,
    require => File[$backupninja::client::config::configdir]
  }
}
