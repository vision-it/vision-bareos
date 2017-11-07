# Class: vision_bareos::client
# ===========================
#
# Manages the Bareos File Daemon on the client
# And makes sure the client config gets exported so that the Director can collect it
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::client
#

class vision_bareos::client (

  String $director_hostname,
  String $director_address,

  Variant[String, Integer] $port,
  Integer $max_concurrent,
  String $auto_prune,
  String $job_retention,
  String $file_retention,
  String $fileset,
  Boolean $manage_repo,

  Hash $job = {},
  String $director_config_dir = $vision_bareos::director_config_dir,
  String $fqdn                = $::fqdn,
  String $address             = $::ipaddress,
  String $collection_tag      = $vision_bareos::collection_tag,

) {

  $client_password = fqdn_rand_string(25)

  if $manage_repo {
    contain vision_bareos::repo

    Class['::vision_bareos::repo']
    -> package { 'bareos-filedaemon':
      ensure => 'present',
    }
  }

  service { 'bareos-filedaemon':
    ensure  => 'running',
    enable  => true,
    require => Package['bareos-filedaemon'],
  }

  #
  # Purge default configuration that comes with the package
  #

  file { '/etc/bareos/bareos-fd.conf':
    ensure => absent,
  }

  file {
    [
      '/etc/bareos/bareos-fd.d',
      '/etc/bareos/bareos-fd.d/client',
      '/etc/bareos/bareos-fd.d/director',
      '/etc/bareos/bareos-fd.d/messages',
    ]:
      ensure  => directory,
      owner   => root,
      group   => root,
      recurse => true,
      purge   => true,
      require => Package['bareos-filedaemon'],
  }

  #
  # The clients configuration on the client
  #

  file { '/etc/bareos/bareos-fd.d/client/myself.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('vision_bareos/bareos-fd.d/myself.conf.erb'),
    require => Package['bareos-filedaemon'],
    notify  => Service['bareos-filedaemon']
  }

  file { '/etc/bareos/bareos-fd.d/director/bareos-dir.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('vision_bareos/bareos-fd.d/bareos-dir.conf.erb'),
    require => Package['bareos-filedaemon'],
    notify  => Service['bareos-filedaemon']
  }

  file { '/etc/bareos/bareos-fd.d/messages/Standard.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('vision_bareos/bareos-fd.d/Standard.conf.erb'),
    require => Package['bareos-filedaemon'],
    notify  => Service['bareos-filedaemon']
  }

  #
  # The client and job configuration for each client gets exported and collected on the Director
  #

  @@::vision_bareos::job { $fqdn:
    *      => $job,
    tag    => $collection_tag,
    client => $fqdn,
  }

  @@file { "${fqdn}-bareos-client.conf":
    ensure  => present,
    tag     => $collection_tag,
    path    => "${director_config_dir}/client/${fqdn}.conf",
    mode    => '0644',
    content => template('vision_bareos/bareos-dir.d/client.conf.erb'),
  }

}
