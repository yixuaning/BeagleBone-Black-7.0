#!/bin/bash
#
# PM-QA validation test suite for the power management on Linux
#
# Copyright (C) 2011, Linaro Limited.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# Contributors:
#     Daniel Lezcano <daniel.lezcano@linaro.org> (IBM Corporation)
#       - initial API and implementation
#

source /usr/bin/linaro-pm-qa-include/functions.sh

CPUIDLE_STATS=./cpuidle_stats

if [ $(id -u) != 0 ]; then
    log_skip "run as non-root"
    exit 0
fi

check_cpuidle_stats() {
    trace-cmd record -e cpu_idle
    trace-cmd report trace.dat > trace-cpuidle.dat
    check "Running cpuidle_stats on collected data" "./$CPUIDLE_STATS" trace-cpuidle.dat
}

check_cpuidle_stats
