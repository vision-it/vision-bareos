# Class: vision_bareos::storage::run
# ===========================
#
# Starts the Docker containers and manages their environments
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::storage::run
#

class vision_bareos::storage::run (

  String $storage_path = $::vision_bareos::storage::storage_path,
  String $version      = $::vision_bareos::storage::storage_daemon_version,

) {

  #
  # Attention: /storage/backups is not created by Puppet
  #

  file { 'bareos storage path':
    ensure => directory,
    owner  => root,
    group  => root,
    path   => "${storage_path}/local",
    mode   => '0777',
  }

  ::docker::run { 'bareos-storage':
    image   => "barcus/bareos-storage:${version}",
    volumes => [
      '/data/bareos/storage:/etc/bareos',
      "${storage_path}:/mnt/:rw"
    ],
    ports   => [ '9103:9103' ],
    require => File['bareos storage path'],
  }

}
