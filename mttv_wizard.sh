# modified docs imagemagick Usage/layers (Licensed under the ImageMagick License)
# Please send bugs and fixes to: azochniak@iredes.org

center=0   # Start position of the center of the first image.
# This can be ANYTHING, as only relative changes are important.

for image in ./img/*_*[0-9]*.*
do

    # Add 70 to the previous images relative offset to add to each image
    #
    center=`convert xc: -format "%[fx: $center +70 ]" info:`

    # read image, add fluff, and using centered padding/trim locate the
    # center of the image at the next location (relative to the last).
    #
    convert -size 800x800 "$image" -thumbnail 240x240 \
	    -set caption '%t' -bordercolor Lavender -background black \
	    -pointsize 12  -density 96x96  +polaroid  -resize 40% \
	    -gravity center -background None -extent 100x100 -trim \
	    -repage +${center}+0\!    MIFF:-

done |
    # read pipeline of positioned images, and merge together
    convert -background skyblue   MIFF:-  -layers merge +repage \
	                -bordercolor skyblue -border 3x3   overlapped_polaroids.jpg

echo Enter to create final slides in ./result/, Ctrl-d stop, RET or wait 5s to continue
echo "$*" | grep -v -- -q || read -t 5


POLAROID=overlapped_polaroids.jpg

mkdir -p ./result/
for image in ./img/*_*[0-9]*.*
do
    res=`echo $image | grep -oE '[^/]*$'`
    cp $image ./result/$res
    composite -geometry +35+30 -gravity South $POLAROID $image ./result/$res
done
