node gold {
  $hostname = 'gold.localdomain'
  $ipaddr   = '172.16.0.2'
  $hostaddr = '172.16.0.1'

  class { dhcp:
    dnsdomain   => [ 'localdomain' ],
    nameservers => [ $hostaddr ],
    ntpservers  => [ $hostaddr ],
    interfaces  => [ 'eth1' ],
    pxeserver   => [ $ipaddr ],
    pxefilename => 'pxelinux.0',
  }

  dhcp::pool { 'localdomain':
    network => '172.16.0.0',
    mask    => '255.255.0.0',
    range   => '172.16.0.100 172.16.0.200',
    gateway => $ipaddr,
  }

  include razor

  sudo::conf { 'vagrant':
    content => 'vagrant ALL=(ALL) NOPASSWD: ALL',
  }

  exec { '/opt/razor/bin/razor_daemon.rb start':
    user    => 'root',
    group   => 'root',
    cwd     => '/opt/razor',
    path    => ['/usr/bin','/bin'],
    require => Class['razor', 'dhcp']
  }
}
