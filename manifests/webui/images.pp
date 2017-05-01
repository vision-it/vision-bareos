# Class: vision_bareos::webui::images
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
# contain ::vision_bareos::webui::images
#

class vision_bareos::webui::images (

  String $version = $vision_bareos::webui::version,

) {

  ::docker::image { 'bareos-webui':
    ensure    => present,
    image     => 'barcus/bareos-webui',
    image_tag => $version,
  }

}
