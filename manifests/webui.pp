# Class: vision_bareos::webui
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::webui
#

class vision_bareos::webui (

  String $version,
  Integer $http_port,
  String $director_hostname = $vision_bareos::director_hostname,

) {

}
