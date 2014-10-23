#!/bin/bash
#
# PM-QA validation test suite for the power management on Linux
#
# Copyright (C) 2013, Linaro Limited.
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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
#
# Contributors:
#     Sanjay Singh Rawat <sanjay.rawat@linaro.org> (LG Electronics)
#       - initial API and implementation
#

# URL : https://wiki.linaro.org/WorkingGroups/PowerManagement/Doc/QA/Scripts#thermal_00

source /usr/bin/linaro-pm-qa-include/functions.sh
source /usr/bin/linaro-pm-qa-include/thermal_functions.sh

check_cooling_device_type() {
    local all_zones=$(ls $THERMAL_PATH | grep "cooling_device['$MAX_CDEV']")
    echo "Cooling Device list:"
    for i in $all_zones; do
	local type=$(cat $THERMAL_PATH/$i/type)
	echo "-    $type"
    done
}

check_thermal_zone_type() {
    local all_zones=$(ls $THERMAL_PATH | grep "thermal_zone['$MAX_ZONE']")
    echo "Thermal Zone list:"
    for i in $all_zones; do
	local type=$(cat $THERMAL_PATH/$i/type)
	echo "-    $type"
    done
}

for_each_thermal_zone check_thermal_zone_type
for_each_thermal_zone check_cooling_device_type
