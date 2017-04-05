  center=0   # Start position of the center of the first image.
             # This can be ANYTHING, as only relative changes are important.

  for image in ./img/[a-m]*_orig.png
  do

    # Add 70 to the previous images relative offset to add to each image
    #
    center=`convert xc: -format "%[fx: $center +70 ]" info:`

    # read image, add fluff, and using centered padding/trim locate the
    # center of the image at the next location (relative to the last).
    #
    convert -size 500x500 "$image" -thumbnail 240x240 \
            -set caption '%t' -bordercolor Lavender -background black \
            -pointsize 12  -density 96x96  +polaroid  -resize 30% \
            -gravity center -background None -extent 100x100 -trim \
            -repage +${center}+0\!    MIFF:-

  done |
    # read pipeline of positioned images, and merge together
    convert -background skyblue   MIFF:-  -layers merge +repage \
            -bordercolor skyblue -border 3x3   overlapped_polaroids.jpg
