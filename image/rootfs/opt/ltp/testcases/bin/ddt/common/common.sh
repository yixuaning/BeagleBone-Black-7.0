# /bin/sh
# 
# Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
#  
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as 
# published by the Free Software Foundation version 2.
# 
# This program is distributed "as is" WITHOUT ANY WARRANTY of any
# kind, whether express or implied; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
source "st_log.sh"
source "site_info"

########### DEFINE CONSTANTS ############
KB=1024
MB=1048576
GB=$((1024*1024*1024))
DEBUGFS_LOCATION=/sys/kernel/debug/
PSID="$0$$"
START_TIME=`date "+%s"`

########### DEFINE PLATFORM DATA ############
# This is done by ltp-ddt's runltp script, but it is optionally done
# here for cases where we are running the scripts outside ltp-ddt
# If the PATH in the target filesystem doesn't have below path exported,
# please add those path in order to run standalone ltp scripts.
# export PATH="${PATH}:/opt/ltp/testcases/bin:/opt/ltp/testcases/bin/ddt"

resolve_platform_name() {
  case $1 in
    *) PLATFORM="$1" ;; 
  esac
  echo $PLATFORM
}

if [ "x$SOC" == "x" ]
then
   LTPPATH='/opt/ltp'
   export PATH="${PATH}:${LTPPATH}/testcases/bin"$( find ${LTPPATH}/testcases/bin/ddt -type d -exec printf ":"{} \; )
   plat=`uname -a | cut -d' ' -f 2`
   i=0; DRIVERS=""
   while read -r file
   do
    echo $file | grep -e "^#.*" > /dev/null
    if [ "$?" == "0" ]; then
      continue
    fi
    mkdir -p ${PLATFORMDIR}/${file}
    case $i in
       0) ARCH="$file"
         export ARCH ;;
       1) SOC="$file"
         export SOC ;;
       2) MACHINE="$file"
         export MACHINE ;;
       3) DRIVERS="$file" ;;
       *) DRIVERS="${DRIVERS},${file}" ;;
    esac
    i=`expr $i + 1`
  done < ${LTPPATH}/platforms/`resolve_platform_name $plat`
  export DRIVERS

fi

########### FUNCTIONS #####################
# Default value for inverted_return is "false" but can
# be overridden by individual scripts.
inverted_return="false"

do_cmd() {
  CMD=$*
  test_print_trc "Inside do_cmd:CMD=$CMD"
  eval $CMD
  RESULT=$?
    if [ "$inverted_return" == "false" ]
    then
      if [ $RESULT -ne 0 ]
      then
        test_print_err "$CMD failed. Return code is $RESULT"
        exit $RESULT
      fi
    else
        if [ $RESULT -eq 0 ]
        then
        test_print_err "$CMD passed. It should fail."
        exit 1
        fi
    fi
}
#do_cmd "mount | grep mtdblock4 || echo notmounted"

# Check the given list of parameters and verify that they are set.
check_mandatory_inputs() {
    for x in $*
    do
        eval t="$"$x
        if [ "$t" == "" ]
        then
            test_print_trc "Mandatory input \"$x\" not specified"
            exit 1
        fi
    done
}

die() {
  test_print_err "FATAL: $*"
  exit 1
}

# Extract value from key value pair list file
#  $1: the file with key value list
#  $2: the key of the value to return
#  $3: the delimitor to seperate key value pair
get_value_for_key_from_file() {
  if [ $# -ne 3 ]; then
    die "Wrong number of arguments. \
                     Usage: get_value_for_key_from_file <file> <key name> <delimiter>"
  fi
  file=$1
  key=$2
  delimiter=$3

  val=`cat $file | grep "^\s*${key}\s*${delimiter}\s*" | cut -d "$delimiter" -f2 | sed 's/^ *//g'`
  echo "$val"
}

# Get value for key in "key1=value2 key2=value2" space seperated pairs
# Input:
#   $1 key
#   $2 key-value pairs 
#   $3 key-value delimiter

get_value_for_key() {
  if [ $# -ne 3 ]; then
    die "Wrong number of arguments. \
    Usage: get_value_for_key <key> <key-value pairs> <key-value delimiter>"
  fi

  key=$1
  key_value_pairs=$2
  key_value_delimiter=$3

  for pair in $key_value_pairs; do
    k=`echo $pair |cut -d"=" -f1`
    v=`echo $pair |cut -d"=" -f2` # note: value could be empty
    if [ "$k" == "$key" ]
    then
      rtn="$v"
    break
  fi
  done
  echo "$rtn"
}

# Compare two files based on md5sum
# Input:
#   $1 file1
#   $2 file2
# Return:
#   true if equal; false otherwise
compare_md5sum()
{
  FILE1=$1
  FILE2=$2
  a=$(md5sum "$FILE1"|cut -d' ' -f1)
  if [ $? -ne 0 ]; then
    echo "error getting md5sum of $FILE1"
    exit 1
  fi
  echo "$1: $a"
  b=$(md5sum "$FILE2"|cut -d' ' -f1)
  if [ $? -ne 0 ]; then
    echo "error getting md5sum of $FILE2"
    exit 1
  fi
  echo "$2: $b"
  [ "$a" = "$b" ]
}

# report something with delta time
report()
{
  CUR_TIME=`date "+%s"`
  delta=`expr $CUR_TIME - $START_TIME`
  echo "$PSID:$START_TIME->$CUR_TIME($delta):$test_iteration: $*"
  sync
}

_random()
{
  if [ $1 -gt 32767 ]; then
    max_mult=`expr $1 / 32767`
    mult=`expr $RANDOM  % $max_mult`
  else
    mult=0;
  fi
  v=`echo "$RANDOM + ($RANDOM * $mult)" | bc `
  echo $v
}
# random
# $1 - max_value
random()
{
  v=`_random $1`
  #v=`dd if=/dev/urandom count=1 2> /dev/null | cksum | cut -c 0-10`
  v1=`expr $1 + 1`
  expr $v % $v1
}

# random not equal to 0
random_ne0()
{
  v=`_random $1`
  #v=`dd if=/dev/urandom count=1 2> /dev/null | cksum | cut -c 0-10`
  expr $v % $1 + 1
}

# check different kernel errors
check_kernel_errors()
{
  type=$1
  case $type in
    kmemleak)
      kmemleaks="/sys/kernel/debug/kmemleak"
      if [ ! -e ${kmemleaks} ]; then
        die "kmemleak sys entry doesn't exist; Please enable DEBUG_KMEMLEAK"
      fi

      # clear the list of all current possible memory leaks before scan
      do_cmd "echo clear > ${kmemleaks}"

      # trigger memory scan
      do_cmd "echo scan > ${kmemleaks}"
      # give kernel some time to scan
      do_cmd sleep 30
      kmemleak_detail=`cat ${kmemleaks}`
      if [ -n "${kmemleak_detail}" ]; then
        die "There are memory leaks being detected. The details are displayed as below: ${kmemleak_detail}"
      else
        test_print_trc "No memory leaks being detected."
      fi 
       
    ;;
    spinlock)
      zcat /proc/config.gz | grep "DEBUG_SPINLOCK=y" || die "Please enable DEBUG_SPINLOCK"
      # Check dmesg to catch the error
      spinlock_errors="BUG: spinlock"
      dmesg |grep -i "${spinlock_errors}" && die "There is spinlock errors showing in dmesg" || test_print_trc "No spinlock related error found in dmesg"
    ;;
    *)
      die "check_kernel_errors: No logic for type $type yet."
    ;;
  esac
}

# Function to check if environment variable is set
# Input: $1 - environment variable to be checked
# returns true if set
# returns with error if not set
check_env_var() {                                               
  output_str=`env|grep $1`                            
  if [ ${#output_str} == 0 ]
  then                                                           
    die "$1 not defined"                                             
  fi                                                              
} 

# $1: check type, either 'y', 'm', 'ym' or 'n'
# $2: Options to check. Uses same syntax returned by get_modular_config.names.sh
#     which is CONFIG1^CONFIG2:module1 CONFIG3:module2 
check_config_options()
{
  case $1 in
    y) check='=y';;
    m) check='=m';;
    ym) check='(=y|=m)';;
    n) check=' is not set';;
    *) die "$1 is not a valid check_config_options() option"
  esac
  OIFS=$IFS
  IFS=' '
  shift
  x=$*
  x=${x[@]}
  y=()
  for i in $x
  do
    newval=`echo $i | cut -d':' -f 1`
    y+=($newval)
  done
  IFS='^';y=${y[@]}
  IFS=' '
  for option in $y; do
    zcat /proc/config.gz | egrep "$option$check" || die "$option is not $check"
  done
  IFS=$OIFS
}

# To get instance number from dev node
# Input: 
#   $1: dev node like /dev/rtc0, /dev/mmcblk0, /dev/sda1, /dev/mtdblk12 etc 
# Output:
#   instance number like '0', '1' etc
get_devnode_instance_num()
{
  devnode_entry=$1
  inst_num=`echo $devnode_entry |grep -oE "[[:digit:]]+$" ` || die "Failed to get instance number for dev node entry "$devnode_entry" " 
  echo $inst_num 
}

# Get filesize
#   $1: filename
#   return: file size in byte
get_filesize()
{
  inputfile=$1
  fs=`wc -c < $inputfile`
  echo $fs
}

# hexdump one byte at offset $oset from $filename
#   $1: filename
#   $2: offset
hexdump_onebyte()
{
  local filename=$1
  local offset=$2
  local byte=`hexdump -n 1 -s $offset -C $filename | head -1 | awk -F " " '{print $2}'`
  echo $byte
}

# replace one byte of inputfile 
# Input
#   $1: inputfile
#   $2: offset - decimal number and starting from 0
#   $3: new_byte - need to be hex
replace_onebyte()
{
  local inputfile=$1
  local offset=$2
  local new_byte=$3

  #local fs=`wc -c < $inputfile`
  local fs=`get_filesize $inputfile`
  echo "$inputfile size is: $fs"
  tempfile="$TMPDIR/tempfile_to_replace_$$"
  do_cmd "dd if=$inputfile of=$tempfile bs=1 count=$offset"
  test_print_trc "echo -ne "\x$new_byte" >> $tempfile"
  echo -ne "\x$new_byte" >> $tempfile 
  do_cmd "dd if=$inputfile of=$tempfile bs=1 count=$(( $fs - $offset - 1 )) skip=$(( $offset + 1 )) seek=$(( $offset + 1 ))"

  do_cmd "cp $tempfile $inputfile"
}

# wrapper for wget
Wget()
{
  wget $* || wget --proxy off $* || http_proxy=$SITE_HTTP_PROXY wget $*
}

