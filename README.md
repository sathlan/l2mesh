<!-- -*- mode: markdown -*- -->
tinc based L2 mesh
=====================

 Create a L2 ( http://en.wikipedia.org/wiki/Link_layer ) mesh using
 tinc ( http://www.tinc-vpn.org/ ). It will create a new interface on
 each machine participating in the mesh, as a new ethernet
 interface. For instance, if the mesh is named "lemesh":

   $ ip link show dev lemesh
   4: lemesh: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
      link/ether 72:75:6e:60:59:f0 brd ff:ff:ff:ff:ff:ff

 Each tinc daemon is configured to connect with all the others, to
 maximize the number of fallbacks in case one connection stops
 working.

 A detailed manual page can be found in manifests/init.pp

License
=======

    Copyright (C) 2012 eNovance <licensing@enovance.com>
	
	Author: Loic Dachary <loic@dachary.org>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


Running tests
=============

GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri puppet  puppet-lint rspec-puppet rspec-expectations mocha puppetlabs_spec_helper rake
export PATH=$HOME/.gem-installed/bin:$PATH ; GEM_HOME=$HOME/.gem-installed rake spec
