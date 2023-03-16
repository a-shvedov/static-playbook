#!/bin/bash
#This is a bash script remove spaces in dirs and files

path="$1"

preproc() {
rm_in_dir(){
printf "\ncall:<rm_in_dir>\n"
find ${path} -type d -name "* *" -print -exec bash -c 'mv "$0" "${0// /_}"' {} \; 2> /dev/null
}
rm_in_file(){
printf "\ncall:<rm_in_file>\n"
find ${path} -depth -type f -name "*[()]*" -print -exec bash -c 'mv "$0" "${0//[()]/_}"' {} \;
sleep 1
find ${path} -depth -type f -name "* *" -print -exec bash -c 'mv "$0" "${0// /_}"' {} \;
}
time rm_in_dir
time rm_in_file
}

preproc
