#
# File: echo_color.sh
#

red="\033[0;31m"
blue="\033[0;34m"
cyan="\033[0;36m"
green="\033[0;32m"
yellow="\033[1;33m"
purple="\033[0;35m"

light_blue="\033[1;34m"
light_red="\033[1;31m"
light_green="\033[1;32m"
light_gray="\033[0;37m"
light_purple="\033[1;35m"

reset_color="\033[0;00m"

echo_light_green()
{
  printf $light_green
  echo "$1"
  printf $reset_color
}

echo_blue()
{
  printf $blue
  echo "$1"
  printf $reset_color
}

echo_light_blue()
{
  printf $light_blue
  echo "$1"
  printf $reset_color
}

echo_yellow()
{
  printf $yellow
  echo -n "$1"
  printf $reset_color
}

echo_red()
{
  printf $red
  echo "$1"
  printf $reset_color
}

echo_light_purple()
{
  printf $light_purple
  echo "$1"
  printf $reset_color
}

