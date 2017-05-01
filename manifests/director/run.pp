# Class: vision_bareos::director::run
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
# contain ::vision_bareos::director::run
#

class vision_bareos::director::run (

  Array $environment       = $::vision_bareos::director::environment,
  String $admin_mail       = $::vision_bareos::director::admin_mail,
  String $sql_password     = $::vision_bareos::director::sql_password,
  String $storage_hostname = $::vision_bareos::director::storage_hostname,
  String $smtp_hostname    = $::vision_bareos::director::smtp_hostname,
  String $storage_password = $::vision_bareos::director::storage_password,
  String $webui_password   = $::vision_bareos::director::webui_password,
  String $mysql_version    = $::vision_bareos::director::mysql_version,

) {

  $docker_environment = concat([
    'DB_HOST=bareos-db',
    'DB_PORT=3306',
    "DB_PASSWORD=${sql_password}",
    "BAREOS_SD_HOST=${storage_hostname}",
    "BAREOS_SD_PASSWORD=${storage_password}",
    "BAREOS_WEBUI_PASSWORD=${webui_password}",
    "SMTP_HOST=${smtp_hostname}",
    "ADMIN_MAIL=${admin_mail}",
  ], $environment)

  ::docker::run { 'bareos-db':
    image   => "mysql:${mysql_version}",
    volumes => [
      '/data/bareos/database:/var/lib/mysql',
    ],
    env     => [
      "MYSQL_ROOT_PASSWORD=${sql_password}"
    ],
  }

  ::docker::run { 'bareos-director':
    image   => 'barcus/bareos-director:mysql',
    volumes => [
      '/data/bareos/director:/etc/bareos',
    ],
    env     => $docker_environment,
    ports   => [ '9101:9101' ],
    links   => [
      'bareos-storage',
      'bareos-db',
    ]
  }

}
