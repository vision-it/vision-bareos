# Class: vision_bareos
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos
#

class vision_bareos (

  String $type,
  String $collection_tag,
  String $director_config_dir,
  String $storage_config_dir,

  String $director_hostname = $::fqdn,
  String $storage_hostname  = $::fqdn,

  String $director_password = fqdn_rand_string(25),
  String $storage_password  = fqdn_rand_string(25),

) {

  if ($type == 'director') {

    contain vision_bareos::director
    contain vision_bareos::storage
    # contain vision_bareos::webui

  }

  contain vision_bareos::client

}
