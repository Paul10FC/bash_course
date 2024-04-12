#!/bin/bash

minutesToSeconds=0;
seconds=0;
resultInSeconds=0;

while getopts "m:s:" opt; do
    case "$opt" in
        m) minutesToSeconds=$(($OPTARG * 60));;
        s) seconds=($OPTARG);;
        \?) echo "Invalid input";;
    esac
done

resultInSeconds=$(echo "$minutesToSeconds + $seconds" | bc)

while [ $resultInSeconds -ne 0 ]; do
    minutes=$(echo "scale=0; $resultInSeconds / 60" | bc)
    seconds=$(echo "scale=0; $resultInSeconds % 60" | bc)

    if [ $seconds -gt 9 ]; then    
        echo "$minutes:$seconds of time remaining"
    else
        echo "$minutes:0$seconds of time remaining"
    fi    
    resultInSeconds=$(( $resultInSeconds - 1))
    sleep 1
done

echo "Timeout"
