#!/bin/bash
#This is a bash script that sorts files in a directory by their extension, adds a timestamp to the file name before moving them to a new directory

dir_to_sort="./dir_to_sort"
dir_to_out="./dir_to_out"

extensions=($(find "$dir_to_sort" -type f | awk -F '.' '{print $NF}' | sort -u))
for ext in "${extensions[@]}"; do
  mkdir -p ${dir_to_out}/${ext}
  echo ${dir_to_out}/${ext}
  find "$dir_to_sort" -type f -name "*.${ext}" | while read filename; do
    base=$(basename "$filename" ".$ext")
    new_name="${base}-${EPOCHSECONDS}.${ext}"
    echo $new_name
    cp "$filename" "${dir_to_out}/${ext}/${new_name}"
done
done
