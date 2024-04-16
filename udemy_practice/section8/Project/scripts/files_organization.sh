#!/bin/bash

regular_files=$(find ./files_to_organizate/ -maxdepth 1 -type f)

if [[ -n "$regular_files" ]]; then

    for file in $regular_files; do

        filename=$(basename "$file")

        case "$filename" in 
            *.[jp][pn]*)
                folder_to_move=./files_to_organizate/photo_files
                ;;
            *.[pdt][dox][dct]*)
                folder_to_move=./files_to_organizate/document_files
                ;;
            *.[xc][ls][sv]*)
                folder_to_move=./files_to_organizate/spreadsheet_files
                ;;
            *.sh)
                folder_to_move=./files_to_organizate/scripts
                ;;
            *.[zt][ia][rp]*)
                folder_to_move=./files_to_organizate/archives
                ;;
            *.ppt?)
                folder_to_move=./files_to_organizate/presentations
                ;;
            *.mp3)
                folder_to_move=./files_to_organizate/audio
                ;;  
            *.mp4)
                folder_to_move=./files_to_organizate/video
                ;;
            .*)
                folder_to_move=./files_to_organizate/anything_else
                ;;
        esac

        mkdir -p $folder_to_move
        mv "$file" $folder_to_move  

        echo "$folder_to_move/$filename"
    done 
else
    echo "There is any regular file in files_to_organizate directory"
fi