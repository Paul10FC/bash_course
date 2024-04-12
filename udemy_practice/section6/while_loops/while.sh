#!/bin/bash

num=0

while [ $num -lt 10 ]; do

    if [ $num -ne 0 ]; then
        echo "Wrong! the number $num is less than 10"
    fi

    read -p "Enter your number: " num
done;
echo "Great! Your number is Grather than 10"
