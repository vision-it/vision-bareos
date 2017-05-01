# Class: vision_bareos::webui::run
# ===========================
#
# Starts the Docker containers and manages their environments
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::webui::run
#

class vision_bareos::webui::run (

  String $director_hostname = $::vision_bareos::webui::director_hostname,
  Integer $http_port        = $::vision_bareos::webui::http_port,
  String $version           = $::vision_bareos::webui::version,

) {

  ::docker::run { 'bareos-webui':
    image => "barcus/bareos-webui:${version}",
    ports => [ "${http_port}:80" ],
    env   => [
      "BAREOS_DIR_HOST=${director_hostname}",
    ],
    links => [
      'bareos-director',
    ]
  }

}
