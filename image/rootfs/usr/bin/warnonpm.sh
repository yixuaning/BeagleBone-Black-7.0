# Module: warnonpm
#
# Description: This script can be used as a wrapper to check for boards and
#              software versions that have PM issues and print warnings to
#              the screen.
# 
# Copyright (C) 2012 Texas Instruments Incorporated
# http://www.ti.com/
#
#  Redistribution and use in source and binary forms, with or withou
#  modification, are permitted provided that the following conditions
#  are met:
#
#  Redistributions of source code must retain the above copyright
#  notice, this list of conditions and the following disclaimer.
#  
#  Redistributions in binary form must reproduce the above copyright
#  notice, this list of conditions and the following disclaimer in the
#  documentation and/or other materials provided with the
#  distribution.
#
#  Neither the name of Texas Instruments Incorporated nor the names of
#  its contributors may be used to endorse or promote products derived
#  from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# This script will do some PM checks and then use the parameters it was
# given to invoke the next script.  For example to call setclockspeed.sh
# with a value of 600000 do:
# ./warnonpm.sh setclockspeed.sh 600000

print_pm_bbb_warning() {
cat << EOM
 WARNING: There have been reports of system lockups when doing system
          suspend/resume operations on some beaglebone boards.  This is
          currently being root caused.  If you encounter a lockup you will
          need to power cycle your EVM.  Once this has been resolved, the
          SDK will be updated and this message will be removed
EOM
}

print_pm_cpld_warning() {
cat << EOM

 WARNING: There is a known issue in older versions of the CPLD code
          than can cause an i2c bus lockup when doing power management
          operations.  If you encounter a lockup you will need to
          power cycle your EVM.  To avoid this lockup, a future update
          of the CPLD version is required

  --- When CPLD fix becomes available, you can update your CPLD software
      version and the board EEPROM to reflect this update.  You can find
      instructions on how to do this at:
      http://processors.wiki.ti.com/index.php/AM335x_General_Purpose_EVM_HW_User_Guide

EOM
}

# Get the eeprom values if they exist and save them to file in
# the /var/volatile directory so that they will have to be
# regenerated on each reboot.  If /var/volatile does not exist then
# we will have to read the EEPROMs each time.
eeprom_board="unknown"
eeprom_daughtercard="unknown"
eeprom_cpld="unknown"
get_eeprom_values(){
    # Base EEPROM locations
    base_eeprom="/sys/devices/platform/omap/omap_i2c.1/i2c-1/"

    if [ ! -e $base_eeprom/1-0050 ]
    then
        # There was no EEPROM found to ID the board so bail and leave
        # the defaults in place
        return 0
    fi

    # The EEPROM at 1-0050 has the board name in it in bytes 5-12
    # So first let's check that the board is an EVM and not some other
    # board that has no CPLD.
    cd $base_eeprom/1-0050

    if [ -e /var/volatile/eeprom_board ]
    then
        eeprom_board=`cat /var/volatile/eeprom_board`
    else
        eeprom_board=`head eeprom -c 12 | cut -b 5-12`
        echo "$eeprom_board" > /var/volatile/eeprom_board
    fi

    if [ ! -e $base_eeprom/1-0051 ]
    then
        # There was no EEPROM found to ID the daughter board so bail and leave
        # the defaults in place
        return 0
    fi

    # The EEPROM on the daughtercard at 1-0051 has the CPLD version in bytes
    # 61-68 and the daughtercard type in bytes 5-12
    # The EEPROM at 1-0051 has the daughtercard name in it in bytes 5-12
    # So first let's check that the daughtercard is the GP and not some other
    # daughtercard
    cd $base_eeprom/1-0051

    if [ -e /var/volatile/eeprom_daughtercard ]
    then
        eeprom_daughtercard=`cat /var/volatile/eeprom_daughtercard`
    else
        eeprom_daughtercard=`head eeprom -c 12 2>/dev/null | cut -b 5-12`
        echo "$eeprom_daughtercard" > /var/volatile/eeprom_daughtercard
    fi

    # The EEPROM at 1-0051 has the CPLD version in it in bytes 61-68
    if [ -e /var/volatile/eeprom_cpld ]
    then
        eeprom_cpld=`cat /var/volatile/eeprom_cpld`
    else
        eeprom_cpld=`head eeprom -c 68 2>/dev/null | cut -b 61-68`
        echo "$eeprom_cpld" > /var/volatile/eeprom_cpld
    fi
}

# There are two cases where we want to disable PM features and print a
# message to the user.
#   1. On the EVM when the CPLD version is too early to support PM
#   2. Currenlty on the Beaglebone there is the possibility of a lockup
#      when doing suspend/resume operations, and we do not want to allow
#      suspend until this has been root caused.
check_enable_pm() {
    # Check if we have already marked PM as enabled
    if [ -e /var/volatile/enable_pm ]
    then
        # PM is supported so go on
        return 0
    fi

    # Get the eeprom values
    get_eeprom_values

    check_beaglebone_suspend
    check_cpld_version
}

# Check if this is a beaglebone.  If so then check if we are calling the
# suspend/resume script.  If we are then print a warning for now and exit,
# else go ahead and allow the operation.  Do not set the enable_pm flag
# because we want to check the demo being called each time and prevent
# running the pm_suspend.sh operation.
check_beaglebone_suspend() {
    if [ "$eeprom_board" != "A335BONE" ]
    then
        # This is NOT a beaglebone so no need to continue
        return 0
    fi

    # Check if the pm_suspend demo is being called
    echo $program | grep pm_suspend > /dev/null

    if [ "$?" = "0" ]
    then
        print_pm_bbb_warning
        #exit 1
        return 0
    fi
}

# Check if the CPLD version is sufficient to allow for PM operations
# This is only needed for the EVM so also check if this is an EVM
# or not.  The CPLD with the potential to lockup the i2c bus and hang
# the board during PM operations is only on the general purpose
# daughter card.
check_cpld_version() {
    if [ "$eeprom_board" != "A33515BB" ]
    then
        # This is NOT an EVM so no need to continue
        return 0
    fi

    if [ "$eeprom_daughtercard" != "A335GPBD" ]
    then
        # This is NOT a general purpose daughtercard
        touch /var/volatile/enable_pm
        return 0
    fi

    # check that the eeprom CPLD version looks valid.  The CPLD version
    # should look like CPLD<number>.<number><alpha>
    echo "$eeprom_cpld" | grep -e "CPLD[0-9]\.[0-9].*" > /dev/null
    if [ "$?" = "1" ]
    then
        echo "INVALID CPLD VERSION FOUND"
        print_pm_cpld_warning
        #exit 1
        return 0
    fi

    # Now that we know the CPLD has a valid version, check to make sure it
    # is greater than 1.0Z.  To do this we will combine the version with
    # the 1.0Z version, sort the two versions in reverse order, and then
    # grab the first entry.  If that entry is CPLD1.0Z then that means the
    # CPLD version we read was:
    #   - Garbage (i.e. not programmed)
    #   - Less than 1.0Z
    #   - 1.0Z as well
    # Therefore we want to not do PM operations
    broken_ver="CPLD1.0Z"
    sorted=`echo -e "$eeprom_cpld""\n""$broken_ver" | sort -r`
    first=`echo $sorted | cut -d ' ' -f1`

    if [ "$first" = "$broken_ver" ]
    then
        # This is a version that is not supported
        echo "FOUND UNSUPPORTED CPLD VERSION ($eeprom_cpld)"
        print_pm_cpld_warning
        #exit 1
        return 0
    else
        # This is a supported version
        touch /var/volatile/enable_pm
    fi
}

# Get the program being called
program="$1"

# Get the machine type
. /etc/init.d/functions

case $(machine_id) in
    am335xevm )
        check_enable_pm
        ;;
    * )
        ;;
esac

# Invoke the real command
$*
