#!/bin/bash

while getopts "n:f:" param
do
  case "$param" in
    f) file="$OPTARG" ;;
    n) set -x ;;
    *) echo "Invalid flag";;
  esac
done

case "$file" in
  *.zip) unzip "$file" ;;
  *.tar.gz) tar xzf "$file" ;;
  *.gz) gzip -d "$file" ;;
  *) echo "Unknown filetype" ;;
esac

if [[ "$(uname)" == "Linux" ]]
then
  echo "Using Linux"
fi
