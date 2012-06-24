# Class: tftp::params
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Usage:
#
class tftp::params {
  $address  = '0.0.0.0'
  $port     = '69'
  $username = 'tftp'
  $options  = '--secure'

  case $::operatingsystem {
    'debian': {
      # hasstatus is to get around an issue where the service script appears to
      # be broken.
      $directory = '/srv/tftp'
      $hasstatus = false
      $provider  = undef
    }
    'ubuntu': {
      $directory = '/var/lib/tftpboot'
      $hasstatus = true
      $provider  = 'upstart'
    }
    default: {
      warning("tftp:: not verified on operatingsystem ${::operatingsystem}.")
      $directory = '/var/lib/tftpboot'
      $hasstatus = true
      $provider  = undef
    }
  }
}
