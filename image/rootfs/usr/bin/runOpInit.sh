# Module: oprofileInit
#
# Description: run Oprofile init
#
# Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
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
echo ""
echo ""
echo "Initializing Oprofile"
echo ""
vmlinux_version="/boot/vmlinux-`uname -r`"
echo $vmlinux_version
if [ -f "$vmlinux_version" ]
then
  vmlinux_temp=`echo $vmlinux_version | sed 's/+//'`
  vmlinux_temp=$vmlinux_temp"_oprofile_copy"
  if [ -f "$vmlinux_temp" ]
  then
    rm $vmlinux_temp
  fi
  ln $vmlinux_version $vmlinux_temp
  echo "running opcontrol --vmlinux=$vmlinux_temp"
  opcontrol --vmlinux=$vmlinux_temp
else
  echo "Error: $vmlinux_version not found
  please generate a vmlinux while building your kernel and copy it to the /boot directory"
fi
