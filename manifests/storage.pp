# Class: vision_bareos::storage
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::storage
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
