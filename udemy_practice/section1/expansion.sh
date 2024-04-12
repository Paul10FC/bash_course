#!/bin/bash
numbers=0123456789
name=PaulFloress
# The expansion is ${parameter:offset:length}
echo ${numbers:0:7}
echo ${name:4:6}

