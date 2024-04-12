#!/bin/bash
EMPLOYEE="sarah"

# Echo with normal variable
echo "$EMPLOYEE"
# Capital letter variable
echo "${EMPLOYEE^}"
# Uppercase variable
echo "${EMPLOYEE^^}"

NAME=PaUl

# Echo with lowecase at first character
echo "${NAME,}"
# With lowercase at all characters
echo "${NAME,,}"

# Characters number
echo "$EMPLOYEE HAS ${#EMPLOYEE} CHARACTERS"
echo "$NAME HAS ${#NAME} CHARACTERS"


