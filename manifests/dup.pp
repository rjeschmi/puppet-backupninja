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
#   password, include, exclude, vsinclude, incremental, keep, bandwithlimit,
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
#   - There's no support for a 'local' type in backupninja's duplicity
#     handler on version 0.9.6-4, which is the version available in stable and
#     testing debian repositories by the time of this writing.
define backupninja::duplicity( $order  = 90,
                               $ensure = present,
                               # options to the config file
                               $options     = false, #
                               $nicelevel   = 0, #
                               $testconnect = "yes", #
                               $tmpdir      = "/var/tmp/duplicity", #
                               # [gpg]
                               $sign       = "no",
                               $encryptkey = false,
                               $signkey    = false,
                               $password   = "a_very_complicated_passphrase",
                               # [source]
                               $include = [ "/var/spool/cron/crontabs",
                                            "/var/backups",
                                            "/etc",
                                            "/root",
                                            "/home",
                                            "/usr/local/*bin",
                                            "/var/lib/dpkg/status*" ],
                               $exclude = [ "/home/*/.gnupg",
                                            "/home/*/.local/share/Trash",
                                            "/home/*/.Trash",
                                            "/home/*/.thumbnails",
                                            "/home/*/.beagle",
                                            "/home/*/.aMule",
                                            "/home/*/.gnupg",
                                            "/home/*/.gpg",
                                            "/home/*/.ssh",
                                            "/home/*/gtk-gnutella-downloads",
                                            "/etc/ssh/*" ],
                               $vsinclude = false,
                               # [dest]
                               $incremental   = "yes",
                               $keep          = 60,
                               $bandwithlimit = "0",
                               $sshoptions    = false,
                               $destdir       = "/backups",
                               $desthost      = false,
                               $destuser      = false,
                               # configs to backupninja client
                               $backupkeystore       = false,
                               $backupkeytype        = '',
                               # options to backupninja server sandbox
                               $ssh_dir_manage       = true,
                               $ssh_dir              = false,
                               $authorized_keys_file = false,
                               $installuser          = true,
                               $backuptag            = false,
                               # key options
                               $installkey           = true ) {

  # the client with configs for this machine
  include backupninja::client

  case $host { false: { err("need to define a host for remote backups!") } }
  
  # guarantees there's a configured backup space for this backup
  backupninja::server::sandbox { "${user}-${name}":
    user                 => $destuser,
    host                 => $desthost,
    dir                  => $destdir,
    manage_ssh_dir       => $ssh_dir_manage,
    ssh_dir              => $ssh_dir,
    authorized_keys_file => $authorized_keys_file,
    installuser          => $installuser,
    backuptag            => $backuptag,
    backupkeys           => $backupkeystore,
    keytype              => $backupkeytype,
  }
  
  # the client's ssh key
  backupninja::client::key { "${destuser}-${name}":
    user       => $destuser,
    host       => $desthost,
    installkey => $installkey,
    keytype    => $backupkeytype,
  }

  # the backupninja rule for this duplicity backup
  file { "${backupninja::client::configdir}/${order}_${name}.dup":
    ensure  => $ensure,
    content => template('backupninja/dup.conf.erb'),
    owner   => root,
    group   => root,
    mode    => 0600,
    require => File["${backupninja::client::configdir}"]
  }
}
  