#!/bin/sh
# distribute-SDK.sh
# Author: Ronny Meißner
# A bash to crop card graphics. Used ImageMagick.
#
# Usage: ldpi mdpi hdpi xhdpi xxhdpi

source sub_script/text_style.sh
source sub_script/dirs.sh

IMAGETYPES=("*.jpg" "*.jpeg" "*.png" "*.tif" "*.tiff" "*.gif" "*.xcf")
MOVIETYPES=("*.mp4" "*.mov" "*.avi" "*.mkv" "*.mpg" "*.mv4")

function msg { printf "%25s" "$@"; }

function try {
  "$@"
  if [[ $? != 0 ]]; then
    echo " [FAILED]"
    echo ""
    exit 1
  fi
  return $status
}

doFilterImage()
{
    if [ -z "$1" -o -z "$2" -o -z "$3"]; then
    	print_red "missing variable."
    	print_blink "STOP"
    	exit 1
	fi
source="$1"
target="$2"
type="$3"
#-iname "*.jpeg" -iname "*.png" -iname "*.tif" -iname "*.tiff" -iname "*.gif" -iname "*.xcf"
find "$source" -type f -iname "*.${type}"  | while read file ; do
   date=$(exiv2 "$file" 2> /dev/null | awk '/Image timestamp/ { print $4 }')
   [ -z "$date" ] && echo "$file" >> ~/error.txt && continue
   year=${date%%:*}
   month=${date%:*}
   month=${month#*:}
   day=${date##*:}

   msg "${target}/${year}"
   createDir "${target}/${year}"
   fTarget="${target}/${year}/${month}/"
   createDir "$fTarget"
   
   try cp "$file" "$fTarget"
done
}
doFilterImage "_INPUT" "test" "jpg"

