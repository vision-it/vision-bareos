# Class: vision_bareos::director::config
# ===========================
#
# Manages the entire config on the Bareos Directory.
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::director::config
#

class vision_bareos::director::config (

  String $director_hostname   = $vision_bareos::director_hostname,
  String $storage_hostname    = $vision_bareos::storage_hostname,

  String $director_config_dir = $vision_bareos::director::director_config_dir,
  String $director_password   = $vision_bareos::director::director_password,
  String $storage_password    = $vision_bareos::director::storage_password,

  Hash   $filesets            = $::vision_bareos::director::filesets,
  Hash   $hosts               = $::vision_bareos::director::hosts,

) {

  #
  # Clean up config that comes with Bareos package
  #

  file { '/etc/bareos':
    ensure => directory,
  }

  file { 'Manage DIR directory':
    ensure => directory,
    path   => $director_config_dir,
  }

  file {
    [
      "${director_config_dir}/director/",
      "${director_config_dir}/storage/",
      "${director_config_dir}/job/",
      "${director_config_dir}/client/",
      "${director_config_dir}/fileset/",
    ]:
      ensure  => directory,
      purge   => true,
      recurse => true,
      force   => true,
      owner   => 'bareos',
      group   => 'bareos',
  }

  #
  # Custom FileSets via Hiera
  #

  create_resources(vision_bareos::director::fileset, $filesets);

  #
  # Create Client and Job config for each host
  #

  each ($hosts) | $host, $params | {
    vision_bareos::job { $host:
      client => $host,
      *      => $params['job'],
    }

    # TODO: host fqdn param
    # TODO: host passwrd param
    file { "${host}-bareos-client.conf":
      ensure  => present,
      path    => "${director_config_dir}/client/${host}.conf",
      mode    => '0640',
      content => template('vision_bareos/bareos-dir.d/client.conf.erb'),
    }
  }

  #
  # Director config
  #

  file { 'Manage Schedules on DIR':
    ensure  => directory,
    path    => "${director_config_dir}/schedule/",
    purge   => true,
    recurse => true,
    source  => 'puppet:///modules/vision_bareos/bareos-dir.d/schedule',
  }

  file { 'Manage JobDefs on DIR':
    ensure  => directory,
    path    => "${director_config_dir}/jobdefs/",
    purge   => true,
    recurse => true,
    source  => 'puppet:///modules/vision_bareos/bareos-dir.d/jobdefs',
  }

  file { 'Manage selfconfig on DIR':
    ensure  => present,
    path    => "${director_config_dir}/director/${director_hostname}.conf",
    mode    => '0640',
    content => template('vision_bareos/bareos-dir.d/director.conf.erb'),
  }

  file { 'Manage bconsole.conf on DIR':
    ensure  => present,
    path    => "${director_config_dir}/director/bconsole.conf",
    mode    => '0640',
    content => template('vision_bareos/bareos-dir.d/bconsole.conf.erb'),
  }

  file { 'Manage bconsole.conf':
    ensure  => present,
    path    => '/etc/bareos/bconsole.conf',
    mode    => '0640',
    content => template('vision_bareos/bconsole.conf.erb'),
  }

  file { 'Manage Storage config on DIR':
    ensure  => present,
    path    => "${director_config_dir}/storage/DefaultStorage.conf",
    mode    => '0640',
    content => template('vision_bareos/bareos-dir.d/storage.conf.erb'),
  }

  ::vision_bareos::job { 'Default-RestoreJob':
    client   => $::fqdn,
    job_type => 'Restore',
    enabled  => 'no',
  }

}
