<!-- -*- mode: markdown -*- -->
tinc based L2 mesh
=====================

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
