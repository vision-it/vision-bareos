# Class: vision_bareos::director
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::director
#

class vision_bareos::director (

  String $admin_mail,
  String $sql_password,
  String $director_config_dir,

  String $director_password = fqdn_rand_string(25),
  String $storage_password  = fqdn_rand_string(25),

  String $smtp_hostname    = $::fqdn,
  String $sql_host         = $::fqdn,
  Array $environment       = [],
  Hash  $filesets          = {},
  Hash  $hosts             = {},

) {

  contain ::vision_bareos::director::config

  package { [
    'bareos-director',
    'bareos-database-common',
    'bareos-database-mysql',
    'bareos-database-tools',
    'bareos-director-python-plugin',
    'bareos-bconsole',
  ]:
    ensure => present,
  }

  exec { 'bareos director init catalog':
    command => '/usr/lib/bareos/scripts/create_bareos_database mysql && /usr/lib/bareos/scripts/make_bareos_tables mysql && /usr/lib/bareos/scripts/grant_bareos_privileges mysql && /usr/bin/touch /var/lib/bareos/database_provisioned',
    notify  => Service['bareos-dir'],
    creates => '/var/lib/bareos/database_provisioned',
  }

  service { 'bareos-dir' :
    ensure  => running,
    enable  => true,
    require => Package['bareos-director'],
  }

}
