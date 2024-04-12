#!/bin/bash

numbers=({1..10})

for number in "${numbers[@]}"; do
    echo "This is the number: $number"
done