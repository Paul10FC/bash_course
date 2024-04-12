#!/bin/bash

# if we run ./very_special_script "Good war" "Run it"

# And it is the same that $*
touch $@ # we are going to get 'Good' 'war' 'Run' 'it' files

# Isn't the same that $*
touch "$@" # We are going to get 'Good war' 'Run it' files

