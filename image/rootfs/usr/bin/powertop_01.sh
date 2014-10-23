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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# Contributors:
#     Rajagopal Venkat <rajagopal.venkat@linaro.org>
#       - initial API and implementation
#

# URL : https://wiki.linaro.org/WorkingGroups/PowerManagement/Doc/QA/Scripts#powertop_01

source /usr/bin/linaro-pm-qa-include/functions.sh

run_powertop() {

    local bin_path=`command -v powertop`
    local report=csv
    local seconds=10
    local iterations=2
    local report_name=PowerTOP*.csv

    # remove old reports if exists
    rm -f $report_name

    # run powertop for $(iterations) in report generation mode
    start_time=`date +%s`
    sudo $bin_path --$report --time=$seconds --iteration=$iterations
    end_time=`date +%s`

    # check if powertop run for desired time
    let expected_time="$iterations * $seconds"
    let actual_time="$end_time - $start_time"

    check "if powertop run for $expected_time sec" "test $actual_time -ge $expected_time"

    # check if $(iterations) number of reports are generated
    check "if reports are generated" "test $(ls -1 $report_name | wc -l) -eq $iterations"

    return 0
}

run_powertop
test_status_show
