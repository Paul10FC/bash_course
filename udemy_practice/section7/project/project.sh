#!/bin/bash
if [[ ! -d reports ]]; then mkdir reports; fi

readarray url_array < urls.txt

for url in "${url_array[@]}"; do
    file_name=$(echo "$url" | cut -d '.' -f 2).txt
    curl --head $url >> ./reports/$file_name
done