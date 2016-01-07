#!/bin/sh
#Author: Ronny Meißner

#36x36 (0.75x) for low-density
#48x48 (1.0x baseline) for medium-density
#72x72 (1.5x) for high-density
#96x96 (2.0x) for extra-high-density
#180x180 (3.0x) for extra-extra-high-density
#192x192 (4.0x) for extra-extra-extra-high-density (launcher icon only; see note above)
doConvertAndroid()
{
	clear
	if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ]; then
    	print_red "missing variable."
    	print_error "STOP"
    	exit 1
	fi

	EXPORT_DIR="$2"
	FILE="$1"

	createDir "$EXPORT_DIR"

	LDPI_DIR=${EXPORT_DIR}/drawable-ldpi

	MDPI_DIR=${EXPORT_DIR}/drawable-mdpi

	HDPI_DIR=${EXPORT_DIR}/drawable-hdpi

	XHDPI_DIR=${EXPORT_DIR}/drawable-xhdpi

	XXHDPI_DIR=${EXPORT_DIR}/drawable-xxhdpi

	XXXHDPI_DIR=${EXPORT_DIR}/drawable-xxxhdpi

	TVDPI_DIR=${EXPORT_DIR}/drawable-tvdpi

	NODPI_DIR=${EXPORT_DIR}/drawable-nodpi

	ORIGIN_WIDTH="$3"

	TARGET_WIDTH="$4"
	filename="${FILE##*/}"
	OUTFILE=$(awk -v t=$filename 'BEGIN {print tolower(t)}')

	SCALE=$(awk -v ow=$3 -v tw=$4 'BEGIN {
	OFMT = "%.2f"  # print numbers as integers (rounds)
	print ( tw / ow * 100) }')

	print_green  ${SCALE/,/.}

	createDir "$LDPI_DIR"

	VAL=$(awk -v scale=$SCALE 'BEGIN {
	OFMT = "%.2f" #
	print (0.75 * scale)}')

	PRE=$(awk -v scale=$TARGET_WIDTH 'BEGIN {
	OFMT = "%.2f" #
	print  (0.75 * scale) }')

	doConvert $FILE ${VAL/,/.}% $LDPI_DIR/$OUTFILE $PRE $5

	VAL=$(awk -v scale=$SCALE 'BEGIN {
	OFMT = "%.2f"
	print  (1 * scale) }')

	PRE=$(awk -v scale=$TARGET_WIDTH 'BEGIN {
	OFMT = "%.2f" #
	print  (1 * scale) }')

	createDir "$MDPI_DIR"
	doConvert $FILE ${VAL/,/.}% $MDPI_DIR/$OUTFILE $PRE $5

	VAL=$(awk -v scale=$SCALE 'BEGIN {
	OFMT = "%.2f"
	print  (1.5 * scale) }')

	PRE=$(awk -v scale=$TARGET_WIDTH 'BEGIN {
	OFMT = "%.2f" #
	print  (1.5 * scale) }')

	createDir "$HDPI_DIR"
	doConvert $FILE ${VAL/,/.}% $HDPI_DIR/$OUTFILE $PRE $5

	VAL=$(awk -v scale=$SCALE 'BEGIN {
	OFMT = "%.2f" #
	print  (2 * scale) }')

	PRE=$(awk -v scale=$TARGET_WIDTH 'BEGIN {
	OFMT = "%.2f" #
	print  (2 * scale) }')

	createDir "$XHDPI_DIR"
	doConvert $FILE ${VAL/,/.}% $XHDPI_DIR/$OUTFILE $PRE $5

	VAL=$(awk -v scale=$SCALE 'BEGIN {
	OFMT = "%.2f" #
	print  (3 * scale) }')

	PRE=$(awk -v scale=$TARGET_WIDTH 'BEGIN {
	OFMT = "%.2f" #
	print  (3 * scale) }')

	createDir "$XXHDPI_DIR"
	doConvert $FILE ${VAL/,/.}% $XXHDPI_DIR/$OUTFILE $PRE $5

	VAL=$(awk -v scale=$SCALE 'BEGIN {
	OFMT = "%.2f" #
	print  (4 * scale) }')

	PRE=$(awk -v scale=$TARGET_WIDTH 'BEGIN {
	OFMT = "%.2f" #
	print  (4 * scale) }')

	createDir "$XXXHDPI_DIR"
	doConvert $FILE ${VAL/,/.}% "$XXXHDPI_DIR/$OUTFILE" $PRE
}


doConvert(){
	if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ]; then
    	print_red "missing variable."
    	print_blink "STOP"
    	exit 1
	fi
	echo "doConvert with $3"

	# use commands depending on fileType
	case "$1" in
		*.png | *.PNG )
        convert $1 -resize $2 $3
        ;;
		*.svg)
		doInkRender $1 $2 $3 $4 $5
        ;;
	esac

}

doInkRender() {
	if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ]; then
    	print_red "missing variable." # print warning if any variable is missing
    	print_blink "STOP"
    	exit 1
	fi
	fullpath=$3
	filename="${fullpath##*/}"                        # Strip longest match of */ from start
    dir="${fullpath:0:${#fullpath} - ${#filename}}" # Substring from 0 thru pos of filename
    base="${filename%.[^.]*}"                       # Strip shortest match of . plus at least one non-dot char from end
    ext="${filename:${#base} + 1}"
    new="${dir}${base}.png"

  inkscape --without-gui --file=$1 --export-width=$4 --export-height=$4 --export-background-opacity=0 --export-png=$new
	 if [ -f "$new" ]; then
			echo "pngcrush $3"
			pngcrush -reduce -brute -s -ow $new
		fi
}
