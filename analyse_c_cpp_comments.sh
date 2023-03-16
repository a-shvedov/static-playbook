target="/path/to/target"
projname=$(basename $target)
lexems_func_out_path="message_func.txt"
report_html_file="${projname}_report.html"

blobs_c="-iname '*.c' -o -iname '*.cpp' -o -iname '*.s' -o -iname '*.h' -o -iname '*.hpp'"
blobs_java="-iname '*.java' -o -iname '*.java'"

target_blob="$blobs_c"

message_func() {
cat <<EOF
abuse
access
admin
ambig
anonym
antivir
attack
backdoor
bad
chaos
cipher
conflict
cve
damage
danger
dead
decode
decrypt
detect
disass
encode
encrypt
error
evil
execut
expire
exploit
fail
hack
hardcode
hijack
inconsist
incorrect
infect
inject
insecure
invalid
issue
key
large
magic
malicious
malware
manipul
mechanism
mitre
obfuscat
overflow
passw
permiss
phrase
potential
privileg
problem
pswd
risk
root
salt
secret
secur
shit
taint
technique
threat
todo
token
traversal
undocument
unreachable
unrestrict
unsafe
unused
virus
vuln
wrong
\\bbug
\\bfault
\\bfix
\\bunfix
\\bminer\\b
\\bmining\\b
\\bnsa\\b
EOF
}
message_func > "$lexems_func_out_path"

func_file() {
echo "Searching in" $projname "at `date '+%H:%M:%S %d-%m-%Y'`" 
echo -E '<html><body><table border="1">' > "$report_html_file";
echo -E '<tr><td>File Name</td><td>Line</td><td>Comments</td><td>Word</td></tr>' >> "$report_html_file";
for fl in $(cat "$target");do IFS=$'\n';
	res=($(pcregrep -Mne '((/\*([^*]|(\*+[^*/]))*\*+/)|(^.*?[^:]//.*$))' "$fl"));
	unset IFS; len=${#res[@]}; for ((i =0 ; i != len; i++ ));
do
	ln=$(echo -E "${res[$i]}"| sed -Ee 's/</\&lt;/g'| sed -Ee 's/>/\&gt;/g'|sed -Ee 's/\"/\&quot;/g' );
	if [ "$(echo -E "$ln"|grep -oP "^\d+:")" ];
	then num=$(echo -E "$ln" |grep -oP "^\d+:");
		com=$(echo -E "$ln" |sed s/$num//);
	else com+="<br>$ln"; fi; ind=$((i + 1)); if ((  i + 1 == len )) |  [ "$(echo -E "${res[$ind]}"|grep -oP "^\d+:")" ] ;
	then for lex in $(cat "$LEXEMS");
	do
		if [ "$(echo -E "$com"|grep -oP "$lex")" ];
		then num=$(echo $num|sed s/://);
			com_mark=$(echo -E "$com"|sed s/$lex/\<b\>$lex\<\\/b\>/);
			echo -E '<tr><td>'"$fl"'</td><td>'"$num"'</td><td>'"$com_mark"'</td><td>'"$lex"'</td></tr>' >> "$report_html_file";
		fi;
	done;
fi ;
done;
done;
}

func_dir() {
echo "Searching in" $projname "at `date '+%H:%M:%S %d-%m-%Y'`" 
echo -E '<html><body><table border="1">' > "$report_html_file";
echo -E '<tr><td>File Name</td><td>Line</td><td>Comments</td><td>Word</td></tr>' >> "$report_html_file";
for fl in $(find "$target" -type f -iname '*.c' -o -iname '*.cpp' -o -iname '*.s' -o -iname '*.h' -o -iname '*.hpp'); do IFS=$'\n';
	res=($(pcregrep -Mne '((/\*([^*]|(\*+[^*/]))*\*+/)|(^.*?[^:]//.*$))' "$fl"));
	unset IFS; len=${#res[@]}; for ((i =0 ; i != len; i++ ));
do
	ln=$(echo -E "${res[$i]}"| sed -Ee 's/</\&lt;/g'| sed -Ee 's/>/\&gt;/g'|sed -Ee 's/\"/\&quot;/g' );
	if [ "$(echo -E "$ln"|grep -oP "^\d+:")" ];
	then num=$(echo -E "$ln" |grep -oP "^\d+:");
		com=$(echo -E "$ln" |sed s/$num//);
	else com+="<br>$ln"; fi; ind=$((i + 1)); if ((  i + 1 == len )) | [ "$(echo -E "${res[$ind]}"|grep -oP "^\d+:")" ] ;
	then for lex in $(cat "$lexems_func_out_path");
	do
		if [ "$(echo -E "$com"|grep -oP "$lex")" ];
		then num=$(echo $num|sed s/://);
			com_mark=$(echo -E "$com"|sed s/$lex/\<b\>$lex\<\\/b\>/);
			echo "found in" $fl
			echo -E '<tr><td>'"$fl"'</td><td>'"$num"'</td><td>'"$com_mark"'</td><td>'"$lex"'</td></tr>' >> "$report_html_file";
		fi;
	done;
fi ;
done;
done;
}


#func_file
#func_dir
