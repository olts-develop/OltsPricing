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
for i in ./export/*.xml ./export/*.XML; do
	echo "#########################################################"
	echo "actual file nr.: $n"
	echo read : $i
	../import $i TFS
	# let "n = n+1"
	n=`expr $n + 1`
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

# call scripts to create DB
NOW=$(date +"%T")
echo "."
echo "#########################################################"
echo "start DB creation"
echo "time: $NOW"
cd tables
./createtables-linux.sh
./createtables-linux.sh
cd ..
NOW=$(date +"%T")
echo "finished DB creation"
echo "time: $NOW"
echo "#########################################################"
echo "."

# call scripts to create functions
NOW=$(date +"%T")
echo "."
echo "#########################################################"
echo "start functions creation"
echo "time: $NOW"
cd functions
./createfunctions-linux.sh
./createfunctions-linux.sh
cat createfunctions-linux.log
cd ..
NOW=$(date +"%T")
echo "finished functions creation"
echo "time: $NOW"
echo "#########################################################"
echo "."

# call scripts to import data from csv-files
NOW=$(date +"%T")
echo "."
echo "#########################################################"
echo "start data import"
echo "time: $NOW"
cd import-all
./import-all-linux.sh
cd ..
NOW=$(date +"%T")
echo "finished data import"
echo "time: $NOW"
echo "#########################################################"
echo "."

# call scripts to create DB indexes
NOW=$(date +"%T")
echo "."
echo "#########################################################"
echo "start DB indexes creation"
echo "time: $NOW"
cd tables
./createindexes-linux.sh
cd ..
NOW=$(date +"%T")
echo "finished DB index creation"
echo "time: $NOW"
echo "#########################################################"
echo "."

# call scripts to reorganize data and indexes
NOW=$(date +"%T")
echo "."
echo "#########################################################"
echo "start runstats"
echo "time: $NOW"
cd runstats
./runstats-linux.sh
cd ..
NOW=$(date +"%T")
echo "finished runstats"
echo "time: $NOW"
echo "#########################################################"
echo "."


ENDTIME=$(date +"%T")
echo "starttime: $STARTTIME"
echo "endtime:   $ENDTIME"
