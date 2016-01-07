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

doConvertDir(){
  SEARCHPATH="$1"
  EXPORT="${SEARCHPATH}/$2"

  createDir "${EXPORT}"

  createDir "Temp"

  GRA="Temp/Gradient$5.png"

  GRAV=`echo "$5 * 2" | bc`
  GCOLOR="rgb(155,155,155)"
  convert -size "$GRAV"x"$GRAV" radial-gradient:none-$GCOLOR $GRA

  for file in $(find $SEARCHPATH -mindepth 1 -maxdepth 1 -type f -name '*.png' ); do
    b="$(basename "${file%.*}")"

    crop=1200

    SCALE=$(awk -v ow=$4 -v tw=$5 -v cr=$crop 'BEGIN {
      OFMT = "%.2f"  # print numbers as integers (rounds)
      print ( tw / ow * 100) * ow/cr }')

      shifter=$(awk -v ow=$4 -v tw=$5 -v cr=$crop 'BEGIN {
        OFMT = "%.2f"  # print numbers as integers (rounds)
        print ( (ow - cr)/2) }')


        #BG="$3"
        #BG=$3 -background "$BG"
        # convert "$file" -color-matrix '6x3: -1  0  0 0 0 1 0 -1  0 0 0 1 0  0 -1 0 0 1' "${EXPORT}/$b.png"
        #convert  \( "$file" -alpha extract \) \( -clone 0 -background gray -shadow 80x3+10+10 \) \ -background none -layers merge +repage  -background 'rgb(75,75,75)' -alpha shape  "${EXPORT}/$b.png"
        #convert  \( "$file" -alpha extract \) -crop "$crop"x"$crop"+"$shifter"+"$shifter"  -resize ${SCALE/,/.}% -background "$3" -alpha shape  "${EXPORT}/$b.png"
        #convert  \( "$file" -alpha extract \)  -resize ${SCALE/,/.}%  -size $5x$5   tile:"$GRA" -compose Multiply  -composite  -background "$3" -alpha shape   "${EXPORT}/$b$6.png"
        #convert  \( "$file" -alpha extract \) -crop "$crop"x"$crop"+"$shifter"+"$shifter"  -resize ${SCALE/,/.}%  -size $5x$5   tile:"$GRA" -compose Multiply  -composite  -background "$3" -alpha shape   "${EXPORT}/$b$6.png"
        #convert  \( "$file" -alpha extract \)  -crop "$crop"x"$crop"+"$shifter"+"$shifter"  -resize ${SCALE/,/.}%   -background "$3" -alpha shape "${EXPORT}/$b$6.png"
        convert  \( "$file" -alpha extract \)  -crop "$crop"x"$crop"+"$shifter"+"$shifter"  -resize ${SCALE/,/.}%   -background "$3" -alpha shape "${EXPORT}/$b$6.png"
        convert -size "$5"x"$5" xc:none \
        "${EXPORT}/$b$6.png"   -geometry +1+1   -composite \
        "${EXPORT}/$b$6.png"   -geometry +2+2   -composite \
        "${EXPORT}/$b$6.png"   -geometry +3+3   -composite \
        "${EXPORT}/$b$6.png"   -geometry +4+4   -composite \
        "${EXPORT}/$b$6.png"   -geometry +5+5   -composite \
        "${EXPORT}/$b$6.png"   -geometry +6+6   -composite \
        "${EXPORT}/$b$6.png"   -geometry +7+7   -composite \
        "${EXPORT}/$b$6.png"   -geometry +8+8   -composite \
        "${EXPORT}/$b$6.png"   -geometry +9+9   -composite \
        "${EXPORT}/$b$6.png"   -geometry +10+10   -composite \
        "${EXPORT}/$b$6.png"   -geometry +11+11   -composite \
        "${EXPORT}/$b$6.png"   -geometry +12+12   -composite \
        "${EXPORT}/$b$6.png"   -geometry +13+13   -composite \
        "${EXPORT}/$b$6.png"   -geometry +14+14   -composite \
        "${EXPORT}/$b$6.png"   -geometry +15+15   -composite \
        "${EXPORT}/$b$6.png"   -geometry +16+16   -composite \
        "${EXPORT}/$b$6.png"   -geometry +17+17   -composite \
        "${EXPORT}/$b$6.png"   -geometry +18+18   -composite \
        "${EXPORT}/$b$6.png"   -geometry +19+19   -composite \
        "${EXPORT}/$b$6.png"   -geometry +20+20   -composite \
        "${EXPORT}/$b$6_shadow.png"
        convert  \( "${EXPORT}/$b$6_shadow.png" -alpha extract \) -size $5x$5 tile:"$GRA" -compose Multiply  -composite  -background "$GCOLOR" -alpha shape "${EXPORT}/$b$6_shadow.png"
        convert "${EXPORT}/$b$6_shadow.png" \
        "${EXPORT}/$b$6.png"  -composite \
        "${EXPORT}/$b$6.png"
        rm  "${EXPORT}/$b$6_shadow.png"
      done;
    }
    DIR="test"
    COLOR="rgb(80,80,80)"
    doConvertDir "$DIR" "60_test" "$COLOR" "1024" "60" ""
