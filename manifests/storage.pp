# Class: vision_bareos::storage
# ===========================
#
# Parameters
# ----------
#
# @param storage_config_dir Path to storage directory
# @param storage_password Password for Storage manager
# @param director_hostname Name of Bareos director
#

class vision_bareos::storage (

  String $storage_config_dir,
  String $storage_password  = $vision_bareos::director::storage_password,
  String $director_hostname = $::fqdn,

) {

  contain ::vision_bareos::storage::config

  package { ['bareos-storage', 'bareos-storage-python-plugin', 'bareos-tools']:
    ensure => present,
  }

  service { 'bareos-sd' :
    ensure  => running,
    enable  => true,
    require => Package['bareos-storage'],
  }

}
