#!/bin/sh
# distribute-SDK.sh
# Author: Ronny Mei§ner
# A bash to crop card graphics. Used ImageMagick.
#
# Usage: ldpi mdpi hdpi xhdpi xxhdpi

txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White

print_green()
{
	echo "\033[1m\033[32;40m$1\033[0m"
}

print_red()
{
 echo "\e[39m$1${txtblk}"
	echo "\033[1m\033[31;40m$1\033[0m"
}

print_blink()
{
	echo "\x1b[5m$1\x1b[25m"
}
#echo -e "${txtred}asd${txtwht}"