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

  String $director_hostname = $::fqdn,
  String $storage_hostname  = $::fqdn,

) {

  if ($type == 'director') {
    contain vision_bareos::director
    contain vision_bareos::storage
  }

  contain vision_bareos::client

}
