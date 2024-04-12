#!/bin/bash

while read line; do
    echo "$line"
done < <(ls $HOME)
# We also can write the file name as done < "file.txt" or a param as done < "$1"
# done < <(ls $HOME) This is process sustitution and the ls $HOME will be the file! "EACH LINE OF THE LS COMMAND"