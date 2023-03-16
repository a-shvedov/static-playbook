diss_via_javap(){
#disassemble bytecode
path="/path/to/the/unpacked/binaries"

IFS=$'\n';
for fl in $(find "$path" -type f -name "*.class")
do 
	echo "$fl";dr=$(dirname "$fl"); 
	mkdir -p "report/$dr" ;
	javap -c "$fl" > "report/$fl" ;
done
}

diff_results(){
#make diff-reports
etalon="/path/to/the/decompiled/binaries/of/the/etalon"; 
rebuild="/path/to/the/decompiled/binaries/of/the/rebuild";
mkdir -p report_cmp;  

IFS=$'\n';
for fl in $(find "$etalon" -type f -name ".class");
do
	echo "Line 1:$fl" ;
	echo "Line 2:${fl/$etalon/$rebuild}" ; 
	mkdir -p "report_cmp/$(dirname $fl)" ;
	diff -sTl "$fl" "${fl/$etalon/$rebuild}" > report_cmp/$fl.diff.txt ;
done

find "$rebuild" -type f -name "*.class" > report_cmp/list_file_rebuild.txt ; 
find "$etalon" -type f -name "*.class" > report_cmp/list_file_etalon.txt ;
}

#diss_via_javap
#diff_results
