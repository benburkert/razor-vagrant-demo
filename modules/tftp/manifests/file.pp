# Define: tftp::file
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Usage:
#
define tftp::file (
  $ensure  = file,
  $owner   = 'tftp',
  $group   = 'tftp',
  $mode    = '0644',
  $content = undef,
  $source  = undef
) {
  include 'tftp'

  file { "${tftp::directory}/${name}":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    source  => $source,
    require => Class['tftp'],
  }
}
