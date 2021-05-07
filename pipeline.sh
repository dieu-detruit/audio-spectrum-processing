#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ./pipeline.sh [letter date (example: 17710512)]"
    exit
else
    date_string=$1
    echo "Processing the thumbnail of letter on $1"
fi

processing-java --sketch=$(pwd)/line --run $date_string && \
    ffmpeg -i line/nosound.mp4 -i wav/$date_string.wav -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -aac_coder twoloop output/$date_string.mp4
