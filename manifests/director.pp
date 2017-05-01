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
  String $director_version,
  String $mysql_version,
  String $sql_password,
  String $webui_password,

  String $storage_hostname = $vision_bareos::storage_hostname,
  String $storage_password = $vision_bareos::storage_password,

  String $smtp_hostname    = $::fqdn,
  String $sql_host         = $::fqdn,
  Array $environment       = [],
  Hash  $filesets          = { },

) {

  contain ::vision_docker
  contain ::vision_bareos::director::images
  contain ::vision_bareos::director::run
  contain ::vision_bareos::director::config

  Class['::vision_bareos::director::images']
  -> Class['::vision_bareos::director::config']
  ~> Class['::vision_bareos::director::run']

}
