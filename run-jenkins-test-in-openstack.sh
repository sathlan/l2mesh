#!/bin/bash
#
# Copyright (C) 2012 Loic Dachary <loic@dachary.org>
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
set -e

function unit_tests() {
    apt-get install -y tinc
    apt-get install -y ruby1.8 rubygems 
    apt-get remove -y ruby1.9.1
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 1.1.3 diff-lcs
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 1.6.14 facter
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 0.0.1 metaclass
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 0.13.0 mocha
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 2.7.18 puppet
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 0.1.13 puppet-lint
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 0.2.0 puppetlabs_spec_helper
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 10.0.2 rake
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 2.12.0 rspec
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 2.12.0 rspec-core
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 2.12.0 rspec-expectations
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 2.12.0 rspec-mocks
    GEM_HOME=$HOME/.gem-installed gem install --include-dependencies --no-rdoc --no-ri --version 0.1.4 rspec-puppet
    export PATH=$HOME/.gem-installed/bin:$PATH ; GEM_HOME=$HOME/.gem-installed rake spec
}

function run() {
    unit_tests || return 1
}

case "$1" in
    TEST)
        # The tests start here
        set -x
        set -o functrace
        PS4=' ${FUNCNAME[0]}: $LINENO: '
        ;;

    *)
        run "$@"
        ;;
esac

# Interpreted by emacs
# Local Variables:
# compile-command: "bash run-jenkins-test-in-openstack.sh TEST"
# End:
