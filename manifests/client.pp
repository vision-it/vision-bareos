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

  String $client_password,
  Boolean $manage_repo,

  String $fqdn = $::fqdn,

) {

  if ($manage_repo) {
    contain vision_bareos::repo
    Class['::vision_bareos::repo']
    -> package { 'bareos-filedaemon':
      ensure => 'present',
    }
  } else {
    package { 'bareos-filedaemon':
      ensure => 'present',
    }
  }

  service { 'bareos-filedaemon':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['bareos-filedaemon'],
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

}
