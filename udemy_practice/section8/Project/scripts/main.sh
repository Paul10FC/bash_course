#!/bin/bash
PS3="Hello! What would you like to do?: "  
select selection in files_organization files_clean exit
do
    if [[ $selection == files_organization ]]; then
        ./files_organization.sh
    elif [[ $selection == files_clean ]]; then
        ./remove_files.sh
    else
        echo "See you later!"
        break;
    fi
done