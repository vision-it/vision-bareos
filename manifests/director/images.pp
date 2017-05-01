# Class: vision_bareos::director::images
# ===========================
#
# Gets the Docker images on the host
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::director::images
#

class vision_bareos::director::images (

  String $director_version = $vision_bareos::director::director_version,
  String $mysql_version    = $vision_bareos::director::mysql_version,

) {

  ::docker::image { 'bareos-director':
    ensure    => present,
    image     => 'barcus/bareos-director',
    image_tag => $director_version,
  }

  ::docker::image { 'bareos-db':
    ensure    => present,
    image     => 'mysql',
    image_tag => $mysql_version,
  }

}
