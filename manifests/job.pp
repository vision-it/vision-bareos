# Class: vision_bareos::job
# ===========================
#
# Parameters
# ----------
#
#

define vision_bareos::job (

  String $client,

  String $identifier          = $title,
  String $enabled             = 'yes',
  String $job_defs            = 'DefaultJob',
  String $fileset             = 'LinuxDefault',
  String $job_type            = 'Backup',
  String $director_config_dir = $vision_bareos::director::director_config_dir,

) {

  file { "job - ${title}":
    ensure  => present,
    path    => "${director_config_dir}/job/${identifier}.conf",
    mode    => '0644',
    content => template('vision_bareos/bareos-dir.d/job.conf.erb'),
  }

}
