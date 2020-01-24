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

  # Note: In Stretch we're using the bareos-filedaemon from the Debian Repo
  $bareos_repo_location_os = $facts['os']['name'] ? {
    'Debian' => $facts['os']['release']['major'] ? {
      '10' => "${bareos_repo_location}/Debian_10.0/",
      '9' => "${bareos_repo_location}/Debian_9.0/",
      '8' => "${bareos_repo_location}/Debian_8.0/",
      default => "${bareos_repo_location}/Debian_8.0/",
    },
    default => "${bareos_repo_location}/Debian_8.0/"
  }

  apt::source { 'bareos':
    location => $bareos_repo_location_os,
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
