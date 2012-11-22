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

function run() {
    return 0
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
