# Class: vision_bareos::storage::nfs
# ===========================
#
# Manages the entire nfs on the Bareos Storagey.
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::storage::nfs
#

class vision_bareos::storage::nfs (

  String $mount_source,

  String $kerberos_security = 'krb5p',
  String $storage_path      = $::vision_bareos::storage::storage_path,
  String $mount_destination = "${storage_path}/fileserver",

) {

  contain ::vision_kerberos::client

  file { 'NFS storage path':
    ensure => directory,
    owner  => root,
    group  => root,
    path   => $mount_destination,
    mode   => '0777',
  }

  package { 'nfs-common':
    ensure => present,
  }

  file_line { 'fstab_fileserver':
    ensure  => present,
    path    => '/etc/fstab',
    line    => "${mount_source} ${mount_destination} nfs4 sec=${kerberos_security} 0 0",
    match   => ".*${mount_destination}.*nfs4.*sec=${kerberos_security}.*0.*0",
    replace => true,
  }

}
