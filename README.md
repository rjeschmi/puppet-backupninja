# puppet-backupninja

Sooo I sorta forked the project. The original was written by someone who seems to know ruby
but was on puppet 2.4 or something. This now uses hiera, a bit of a different file structure,
a completely reimplemented sandbox system using puppet stored configs (you'll need puppetdb)
and has next to no testing except for my very narrow usecase. It also is update to be a bit
closer to the Puppet Style Guide, though I'm sure I've violated it too.

That said this is a great project to build off of. I will be uploading docs on how to get it up
and running, and I encourage you to download it and change the options, add new ones, and send 
me pull requests. Please yell at me if anything looks idiotic, it probably is. 

I think that  duplicity + backupninja + puppet + sandboxed SFTP is a very architechtually secure 
backup system where the backup server doesn't need root on every box you have. 

## Requirements
As of now you'll need this module:
https://github.com/boklm/puppet-sshkeys

You will also need some way to ensure the Openssh SFTP only settings, which my puppet-openssh
module does. 

## Tested

Currently I have only tested Duplicity + SFTP on CentOS 6. Please don't expect this to work on anything
else yet, though I have the structure in place to rapidly support most differences.

## CONTACT ME
I will be supporting for my company and myself. If you don't know puppet but would like to use
this system, please email me at rhys@rhavenindustrys.com with your use case and I will add it in
with the best practices I can figure out. I respond within 24 hours usually. 

Cheerio,
--
Rhys

