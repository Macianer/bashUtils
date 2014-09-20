#!/bin/sh
# exiv2_tools.sh
# Author: Ronny Meißner
# Required packages: exiv2 
# Required sub script


source sub_script/text_helper.sh
source sub_script/dir_helper.sh


#IMAGETYPES=("*.jpg" "*.jpeg" "*.png" "*.tif" "*.tiff" "*.gif" "*.xcf")
#MOVIETYPES=("*.mp4" "*.mov" "*.avi" "*.mkv" "*.mpg" "*.mv4")

exivSortTargetDirIntoSourceByYearMonth()
{
    if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
    	print_red "missing variable."
    	print_blink "STOP"
    	exit 1
	fi
source="$1"
target="$2"
type="$3"

find "${source}" -type f -iname "*.${type}"  | while read file ; do
   date=$(exiv2 "$file" 2> /dev/null | awk '/Image timestamp/ { print $4 }')
   [ -z "$date" ] && echo "$file" >> ${source}/error.txt && continue
   year=${date%%:*}
   month=${date%:*}
   month=${month#*:}
   day=${date##*:}
	
   msg "${target}/${year}"
   createDir "${target}/${year}"
   fTarget="${target}/${year}/${month}/"
   createDir "$fTarget"
   echo "$fTarget"
   b="$(basename "${file%.*}")"
   targetFile=$fTarget$b.${type}
   if [ -f $targetFile ];
	then
   echo "File $targetFile exists."
	else
	try cp "$file" "$fTarget"
	rm "$file"
   	#echo "File $targetFile does not exist."
	fi
   
	done
}