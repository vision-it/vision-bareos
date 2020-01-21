# Class: vision_bareos::director::fileset
# ===========================
#
# Parameters
# ----------
#
#

define vision_bareos::director::fileset (

  String $identifier,
  String $description,
  Array  $paths,

  String $director_config_dir = $vision_bareos::director::director_config_dir,

) {

  file { "fileset - ${title}":
    ensure  => present,
    path    => "${director_config_dir}/fileset/${identifier}.conf",
    mode    => '0644',
    content => template('vision_bareos/bareos-dir.d/fileset.conf.erb'),
  }

}
