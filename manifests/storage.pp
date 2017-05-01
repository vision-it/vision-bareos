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

  String $storage_daemon_version,
  String $storage_path,

  String $storage_password  = $vision_bareos::storage_password,
  String $director_hostname = $::fqdn,

) {

  contain ::vision_docker
  contain ::vision_bareos::storage::images
  contain ::vision_bareos::storage::run
  contain ::vision_bareos::storage::config

  Class['::vision_bareos::storage::images']
  -> Class['::vision_bareos::storage::config']
  ~> Class['::vision_bareos::storage::run']

}
