# Class: tftp
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Usage:
#
class tftp (
  $username  = $tftp::params::username,
  $directory = $tftp::params::directory,
  $address   = $tftp::params::address,
  $port      = $tftp::params::port,
  $options   = $tftp::params::options
) inherits tftp::params {
  package { 'tftpd-hpa':
    ensure => present,
  }

  file { '/etc/default/tftpd-hpa':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('tftp/tftpd-hpa.erb'),
    require => Package['tftpd-hpa'],
  }

  service { 'tftpd-hpa':
    ensure    => running,
    provider  => $tftp::params::provider,
    hasstatus => $tftp::params::hasstatus,
    pattern   => '/usr/sbin/in.tftpd',
    subscribe => File['/etc/default/tftpd-hpa'],
  }
}
