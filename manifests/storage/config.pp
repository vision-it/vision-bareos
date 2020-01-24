# Class: vision_bareos::storage::config
# ===========================
#
# Manages the entire config on the Bareos Storagey.
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::storage::config
#

class vision_bareos::storage::config (

  String $director_hostname  = $vision_bareos::director_hostname,
  String $storage_hostname   = $vision_bareos::storage_hostname,
  String $storage_config_dir = $vision_bareos::storage::storage_config_dir,
  String $storage_password   = $vision_bareos::storage::storage_password,

) {

  #
  # Clean up config that comes with Bareos package
  #

  file { 'Manage SD directory':
    ensure => directory,
    path   => $storage_config_dir,
  }

  file {
    [
      "${storage_config_dir}/director/",
      "${storage_config_dir}/storage/",
      "${storage_config_dir}/messages/",
    ]:
      ensure  => directory,
      purge   => true,
      recurse => true,
      force   => true,
      owner   => 'bareos',
      group   => 'bareos',
  }

  #
  # Storage Daemon config
  #

  file { 'Manage selfconfig on SD':
    ensure  => present,
    path    => "${storage_config_dir}/storage/${storage_hostname}.conf",
    mode    => '0644',
    content => file('vision_bareos/bareos-sd.d/bareos-sd.conf'),
  }

  file { 'Manage Messages on SD':
    ensure  => present,
    path    => "${storage_config_dir}/messages/Standard.conf",
    mode    => '0644',
    content => template('vision_bareos/bareos-sd.d/Standard.conf.erb'),
  }

  file { 'Manage Director on SD':
    ensure  => present,
    path    => "${storage_config_dir}/director/${director_hostname}.conf",
    mode    => '0644',
    content => template('vision_bareos/bareos-sd.d/bareos-dir.conf.erb'),
  }

  file { 'Manage devices on SD':
    ensure  => directory,
    path    => "${storage_config_dir}/device/",
    mode    => '0644',
    purge   => true,
    recurse => true,
    source  => 'puppet:///modules/vision_bareos/bareos-sd.d/device/',
  }

}
