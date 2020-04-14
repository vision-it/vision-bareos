# Define: vision_bareos::director::fileset
# ===========================
#
# Resource for fileset on Director
#
# Parameters
# ----------
#
# @param identifier Name of FileSet
# @param description Description of FileSet
# @param paths Paths in FileSet
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
