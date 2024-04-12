#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "You didn't put 2 parameters"
  echo "$0 <file1> <file2>"
  exit 1
fi

echo "$@"
