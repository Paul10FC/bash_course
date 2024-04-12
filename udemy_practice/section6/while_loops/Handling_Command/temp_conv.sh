#!/bin/bash

# This Script will receive 2 arguments -f for fareinheits and -c for celcius degrees
# This arguments will be saved in opt variable
while getopts "f:c:" opt; do
    # opt variable will be evaluated
    case "$opt" in
    
        # celcius to fereinheit 
        # OPTARG conatins the argument followed by -c or -f
        # the result will be calculated with the calculator bc with 2 decimal numbers (SCALE=2)
        c) result=$(echo "scale=2; ($OPTARG * (9 / 5)) + 32" | bc); echo $result;;
        f) result=$(echo "scale=2; ($OPTARG - 32) * (5 / 9)" | bc); echo $result;;
        \?) echo "Invalid Option";;
    esac
done