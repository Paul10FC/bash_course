#!/bin/bash

# Make an array that contains all the files in days.txt
readarray days < days.txt

# Prints all the days of the week
echo ${days[@]}

# Delate the directory if exists
if [ -d filesToArray ]; then rm -r filesToArray; echo "Directory exists"; fi

# Creation of an array with files
mkdir filesToArray; touch filesToArray/file{1..10}.txt

# Create the array with all files name and ignorate the \t and \n
readarray -t files < <(ls ~/Github_Repositories/bash_course/udemy/section7/filesToArray)

# prints all the files
echo ${files[@]}