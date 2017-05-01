# Class: vision_bareos::storage::images
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
# contain ::vision_bareos::storage::images
#

class vision_bareos::storage::images (

  String $storage_daemon_version = $vision_bareos::storage::storage_daemon_version,

) {

  ::docker::image { 'bareos-storage':
    ensure    => present,
    image     => 'barcus/bareos-storage',
    image_tag => $storage_daemon_version,
  }

}
