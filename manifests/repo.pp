# Class: vision_bareos::repo
# ===========================
#
# Manages the Bareos repository
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_bareos::repo
#

class vision_bareos::repo (

  String $bareos_repo_keyid,
  String $bareos_repo_key,
  String $bareos_repo_location,
  String $bareos_repo_release = '/',

) {

  apt::source { 'bareos':
    location => $bareos_repo_location,
    key      => {
      id      => $bareos_repo_keyid,
      content => $bareos_repo_key,
    },
    release  => $bareos_repo_release,
    repos    => '', # This is correct
  }
  -> exec { 'bareos_apt_get_update':
    command => 'apt-get update',
    cwd     => '/tmp',
    path    => ['/usr/bin'],
    unless  => '/usr/bin/dpkg --list | /bin/grep -q bareos-filedaemon',
  }

}
