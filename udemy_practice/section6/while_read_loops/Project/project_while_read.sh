#!/bin/bash

creation_direction=$3

while getopts "c:r:" opt; do
    if [ -e $OPTARG ] && [ -s $OPTARG ]; then
        case "$opt" in
            c)
                while read folder; do
                    mkdir "$creation_direction$folder"
                done < $OPTARG
                echo -e "\n\tDirectories created at $creation_direction"
                ;;
            r)  while read folder; do
                    echo "$creation_direction$folder"
                done < $OPTARG
                echo -e "\n\tDirectories read"
                ;;
            \?) echo "Invalid option";;
        esac
    elif [ ! -e $OPTARG ]; then
        echo "You file isn't exists"
        break;
    else 
        echo "Your file has empty values"
        break;
    fi    
done