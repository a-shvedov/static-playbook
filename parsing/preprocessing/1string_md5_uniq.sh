input="."; output=$($(basename ../`pwd`)_md5); for file in $(find $input -type f -exec md5sum '{}' + | sort -S 90% | uniq -w 32 | awk '{print $2}'); do cp $file $output ; done
