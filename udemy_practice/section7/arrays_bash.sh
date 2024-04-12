#!/bin/bash

# We're going to create an array. Each space is the number separation
# Each number is an element!
numbers=(1 2 3 4 5)

# prints 1
echo $numbers

# prints 3
echo ${numbers[2]}

# prints the entire array
echo ${numbers[@]}

# prints 2 3
echo ${numbers[@]:1:2}

# prints 4 5
echo ${numbers[@]:3}

# Add number 6 to the array
numbers+=(6)
# prints 1 2 3 4 5 6
echo ${numbers[@]}

# Remove the number 3 from the array across his index
unset numbers[2]
# prints 1 2 4 5 6
echo ${numbers[@]}

# If we want to see the index elements of our array
echo ${!numbers[@]} # Prints 1 3 4 5 -> arrays remaining after unset

# Change the index 0 from 1 to a
numbers[0]=a
echo ${numbers[@]} # Prints -> a 2 4 5 6 
