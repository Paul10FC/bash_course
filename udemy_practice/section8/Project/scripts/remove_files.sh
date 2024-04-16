#!/bin/bash
echo "Welcome to remove files"
read -p "Input the deadline hour (24hrs) to remove files: " hour_to_remove
read -p "Input the deadline minute to remove files: " minute_to_remove

if [[ ! $hour_to_remove =~ ^[0-9]+$ ]]; then 
    echo "Your hour isn't a number, is $hour_to_remove"
    exit 1
fi 

time_to_delete_in_minutes=$(echo "($hour_to_remove * 60) + $minute_to_remove" | bc )

readarray files < <(find ./files_to_remove -type f -mmin -"$time_to_delete_in_minutes")

if [[ -n "$files" ]]; then
    rm -i ${files[@]}
else
    echo "We didn't find files to delete in that time"
fi

