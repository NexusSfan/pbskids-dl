#!/usr/bin/bash
#
# Bash Script for downloading PBS Kids videos.
#
# Requirements for this script: curl, awk, sed, and ffmpeg
#
# Usage:
# ./pbskids-dl.sh [url]
# where url is the page you land on when 
# a video is playing. 
#
# Made by NexusSfan

if (( $# != 1 )); then
    echo "Illegal number of parameters."
    exit
fi

rawurl=($1)
echo "Extracting URL:" $rawurl

vid_name=() # Name of the video
realvid=() # Link to the raw video
title=() # Name of the show

# Fetch the titles and captions,
# and URLs that youtube-dl can use.
# Store them in lists in memory!
echo "Getting WebPage"
curl -s $rawurl
echo "Extracting Metadata"
curl -s $rawurl | grep DEEPLINK
echo "Getting Title"
curl -s $rawurl | grep DEEPLINK | awk -F "," '{print $9}'
echo "Decoding Title"
curl -s $rawurl | grep DEEPLINK | awk -F "," '{print $9}' | awk -F "\"" '{print $4}'
curl -s $rawurl | grep DEEPLINK | awk -F "," '{print $9}' | awk -F "\"" '{print $4}' | sed "s/[\]//g"
curl -s $rawurl | grep DEEPLINK | awk -F "," '{print $9}' | awk -F "\"" '{print $4}' | sed "s/[\]//g" | sed "s/[/]//g"
curl -s $rawurl | grep DEEPLINK | awk -F "," '{print $9}' | awk -F "\"" '{print $4}' | sed "s/[\]//g" | sed "s+/+\ -\ +g" |  sed "s/[\]//g"
curl -s $rawurl | grep DEEPLINK | awk -F "," '{print $24}' | awk -F "\"" '{print $4}' | sed "s/[\]//g" | sed "s+/+-+g" |  sed "s/[\]//g"
sleep 3
vid_name=`curl -s $rawurl | grep DEEPLINK | awk -F "," '{print $9}' | awk -F "\"" '{print $4}' | sed "s/[\]//g" | sed "s+/+\ -\ +g" |  sed "s/[\]//g"`
echo $vid_name
realvid=`curl -s $rawurl | grep DEEPLINK | awk -F "," '{print $10}' | awk -F "\"" '{print $4}' | sed "s/[\]//g"`
echo $captions
title=`curl -s $rawurl | grep DEEPLINK | awk -F "," '{print $24}' | awk -F "\"" '{print $4}' | sed "s/[\]//g" | sed "s+/+-+g" |  sed "s/[\]//g"`
echo $title
vid_title=`echo $title":"$vid_name | sed "s+\ +_+g"`
echo $vid_title
echo "Downloading Video..."
ffmpeg -i "$realvid" $vid_title.mp4