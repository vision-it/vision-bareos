# Class: vision_bareos
# ===========================
#
# Parameters
# ----------
#
# @param type What type the node is (director or client)

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
