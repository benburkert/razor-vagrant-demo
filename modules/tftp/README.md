# puppet tftp module

## Overview

Install tftp-hpa package and configuration files for osfamily Debian.

## Usage

### class tftp

Parameters:

* username: tftp daemon user, default tftp.
* directory: service directory, deafult see params class.
* address: bind address, default 0.0.0.0.
* port: bind port, default 69.
* options: service option, default --secure.

Example:

    class tftp {
      directory => '/opt/tftp',
      address   => $::ipaddress,
      options   => '--secure --ipv6 --timeout 60',
    }

### tftp::file

Parameters:

*  ensure: file type, default file.
*  owner: file owner, default tftp.
*  group: file group. default tftp.
*  mode: file mode, default 0644 (puppet will change to 0755 for directories).
*  content: file content.
*  source: file source.

Example:

    tftp::file { 'pxelinux.0':
      source => 'puppet:///modules/acme/pxelinux.0',
    }
    
    tftp::file { 'pxelinux.cfg':
      ensure => directory,
    }
    
    tftp::file { 'pxelinux.cfg/default':
      source => 'puppet:///modules/acme/default',
    }

## Example

1. tftp directories not in the OS package defaults should be managed as file resources.
2. customization for the class tftp must be declared before using tftp::file resources.

Example:

    file { '/opt/tftp':
      ensure => directory,
    }
    
    class { 'tftp':
      directory => '/opt/tftp',
      address   => $::ipaddress,
    }
    
    tftp::file { 'pxelinux.0':
      source => 'puppet:///modules/acme/pxelinux.0',
    }

The examples use a module acme and the tftp files should be placed in calling module path i.e. (/etc/puppet/modules/acme/files).

## Supported Platforms

The module have been tested on the following operating systems. Testing and patches for other platforms are welcomed.

* Debian Wheezy
* Ubuntu Oneiric
