#!/bin/zsh

#if [ $# -ne 2 ]; then
    #echo "Usage: ./merge.sh [letter date]" >2
    #exit
#fi

ffmpeg -i nosound.mp4 -i ../wav/17710512.wav -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -aac_coder twoloop output.mp4
