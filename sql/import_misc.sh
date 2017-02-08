#!/bin/sh

# converts xml-files into csv-files.
# Creation of tables and functions and import of data is done by other scripts.
# Theses scripts are called later below
# to start manually (with logfile):
# ./import.sh | tee import.log

# get time
STARTTIME=$(date +"%T")
NOW=$(date +"%T")

echo "."
echo "."
echo "."
echo "."
echo "#########################################################"
echo "start"
echo "time: $NOW"
echo "#########################################################"
echo "."
echo "."

# process xml-files and create csv-files
n=1;
# for i in ./tui_test_xml--.xml ./tui_test_xml--.XML; do
# for i in ./tui_xml--.xml ./tui_xml--.XML; do
for i in ./export/*Misc*.xml ./export/*.XML; do
	echo "#########################################################"
	echo "actual file nr.: $n"
	echo read : $i
	../import $i TFS
	# let "n = n+1"
	n=`expr $n + 1`
	#if [ $n -eq 250 ]
	#	then break
	#fi
done
echo "."
# let "n = n-1" # for loop run too often
n=`expr $n - 1`
echo "#########################################################"
echo "total files count: $n"
echo "#########################################################"
echo "."

# convert from utf-8 to iso-8859-1
# iconv -f 'utf-8' -t 'iso-8859-1' -o tooRooms_c.csv tooRooms.csv

# move files to import folder
mv *.csv import

NOW=$(date +"%T")
echo "."
echo "conversion finished"
echo "time: $NOW"
echo "#########################################################"
echo "."



ENDTIME=$(date +"%T")
echo "starttime: $STARTTIME"
echo "endtime:   $ENDTIME"
