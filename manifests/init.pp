#
#    Copyright (C) 2012 eNovance <licensing@enovance.com>
#	
#    Author: Loic Dachary <loic@dachary.org>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# How to write documentation http://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
#
# == Define: l2mesh
#
# Create and update L2 ( http://en.wikipedia.org/wiki/Link_layer ) mesh. The mesh
# named *lemesh* will show as a new interface on each machine participating in the mesh, as
# a new ethernet interface. For instance:
#
#   $ ip link show dev lemesh
#   4: lemesh: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
#      link/ether 72:75:6e:60:59:f0 brd ff:ff:ff:ff:ff:ff
# 
# The interface is created by a *tincd* daemon ( one per mesh ) which maintains a connection to other
# machines in the mesh. 
#
# tinc is not limited to the use case implemented by this module, see http://www.tinc-vpn.org/ for more
# information.
#
# == Starting and reloading the tinc daemon
#
# There is one daemon for each mesh and all of them are run by a single /etc/init.d/tinc script
# which is uncommon. To cope with this situation, a combination of calls to the /etc/init.d/tinc script and
# the *tincd* binary is used, as follows:
# 
# [add a mesh] when a new mesh is created, no daemon is running for it. When tincd tries to signal 
# 	it with USR1 to check for its existence, it will fail. /etc/init.d/tinc is called and will
#       attempt to start all mesh. It will fail for all but the newly created, because they already
#       run. But it will succeed for the newly created mesh, which is the intended outcome.
#
# [reboot and shutdown] The init script will loop over all mesh and start / stop them.
#
# [configuration change] The status of the deamon for which a configuration file was changed
#      is tested by sending it the USR1 signal. If sending the signal fails, the mesh will be
#      started as if it has just been created. If sending the signal succeeds, the daemon will
#      be sent the HUP signal and will gracefully reload the configuration files. In particular
#      it will notice a change in the list of tincd peers it must connect to.
#
# [remove a mesh] there is no support to remove a mesh other than removing the files 
#      and exported resources from the puppet database manually.
#
# There may be a race condition when multiple mesh are added
# simultaneously, as puppet will run the /etc/init.d/tinc script many
# times. As a result the *tincd* daemon for *lemesh* will attempt to
# launch more than once. If there is a window of opportunity for two
# deamons to be run if they are launched at exactly the same time, it
# create a race condition. This is a uncommon use case for tinc
# therefore if such a race condition actually exists, it is possible
# that it will be triggered.
#
# == Parameters
#
# [*name*] name of the mesh 
#
# [*ip*] ip address of the node
#
# == Example
#
#  include l2mesh::params
#  l2mesh { 'lemesh':
#      ip	=> $::ipaddress_eth0,
#  }
# 
# == Dependencies
#
#   Class['concat']
#
# == Authors
#
#   Loic Dachary <loic@dachary.org>
#
# == Copyright
#
# Copyright 2012 eNovance <licensing@enovance.com>
#
define l2mesh(
              $ip,
) {

  include l2mesh::params
  include concat::setup

  package { $::l2mesh::params::tinc_package_name:
    ensure => present,
  }

  $service = "${::l2mesh::params::tinc_service_name}_${name}"

  service { $service:
    require	=> Package[$::l2mesh::params::tinc_package_name],
    ensure	=> running,
    status	=> "tincd --net=${name} --kill=USR1",
    restart	=> "tincd --net=${name} --kill=HUP",
    enable	=> true,
  }

  file {"/etc/tinc/nets.boot":
    ensure	=> present,
    require	=> Package[$::l2mesh::params::tinc_package_name],
    before	=> Service[$service],
    owner	=> root,
    group	=> 0,
    mode	=> 0400;
  }

  $root = "/etc/tinc/${name}"

  file { $root:
    owner	=> root,
    group	=> root,
    mode	=> 0755,
    ensure	=> 'directory',
  }

  $private = "${root}/rsa_key.priv"
  $public = "${root}/rsa_key.pub"

  $keys = tinc_keygen()
  $private_key = $keys[0]
  $public_key = $keys[1]

  file { $private:
    owner	=> root,
    group	=> root,
    mode	=> 0400,
    content	=> $private_key,
    before	=> Service[$service],
  }

  file { $public:
    owner	=> root,
    group	=> root,
    mode	=> 0444,
    content	=> $public_key,
    before	=> Service[$service],
  }

  $hosts = "${root}/hosts"

  file { $hosts:
    owner	=> root,
    group	=> root,
    mode	=> 0755,
    ensure	=> 'directory',
  }

  $fqdn = regsubst($::fqdn, '[._-]+', '', 'G')
  $host = "${hosts}/${fqdn}"

  $tag = "tinc_${name}"

  @@concat { $host:
    owner	=> root,
    group	=> root,
    mode	=> 644,
    require	=> File[$hosts],
    notify	=> Service[$service],
    tag		=> $tag,
  }

  @@concat::fragment { "${host}_head":
    target	=> $host,
    order	=> 01,
    content	=> "Address = $ip
Port = 655
Compression = 0

${public_key}",
    tag		=> $tag,
  }

  @@concat::fragment { "${host}_key":
    target	=> $host,
    order	=> 02,
    content	=> "file(${public})",
    tag		=> $tag,
  }

  Concat <<| tag == $tag |>>

  Concat::Fragment <<| tag == $tag |>>
}
