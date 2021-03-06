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

cd /home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql

#delete xml files
rm -rf export
mkdir export

# copy xml file for all TOOs
NOW=$(date +"%T")
echo "."
echo "#########################################################"
echo "start files copy"
echo "time: $NOW"
cd /home/too-knecht/upload/
cp -p *.xml ~/projects/hotel_api/src/modules/tfs/tfsimporter/sql/export/
cd /home/too-stohler/upload/
cp -p *.xml ~/projects/hotel_api/src/modules/tfs/tfsimporter/sql/export/
cd /home/too-tourasia/upload/
cp -p *.xml ~/projects/hotel_api/src/modules/tfs/tfsimporter/sql/export/
cd ~/projects/hotel_api/src/modules/tfs/tfsimporter/sql
NOW=$(date +"%T")
echo "finished files copy"
echo "time: $NOW"
echo "#########################################################"
echo "."

cd export

# delete all csv files
rm -f *.csv
rm -f ../import/*.csv

# process xml-files and create csv-files
START_CONV=$(date +"%T")
n=1;
for i in *.xml; do
	echo "#########################################################"
	echo "actual file nr.: $n"
	echo read : $i
	../../import $i TFS
	# let "n = n+1"
	n=`expr $n + 1`
done
echo "."
n=`expr $n - 1`# for loop run too often
echo "#########################################################"
echo "total files count: $n"
echo "#########################################################"
echo "."

# move files to import folder
mv *.csv ../import

cd ..

NOW=$(date +"%T")
echo "."
echo "conversion finished"
echo "starttime: $START_CONV"
echo "time: $NOW"
echo "#########################################################"
echo "."

# call scripts to create tables
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

# copy images to montreal
NOW=$(date +"%T")
echo "."
echo "#########################################################"
echo "start image copy"
echo "time: $NOW"
cd /home/too-tourasia/upload/details/hotel
rsync -a *.jpg oltworker@montreal.onlinetravel.ch:/srv/www/htdocs/hotel_api/tfs/TSOL010/hotel
cd /home/too-tourasia/upload/details/misc
rsync -a *.jpg oltworker@montreal.onlinetravel.ch:/srv/www/htdocs/hotel_api/tfs/TSOL010/misc
NOW=$(date +"%T")
echo "finished image copy"
echo "time: $NOW"
echo "#########################################################"
echo "."

ENDTIME=$(date +"%T")
echo "starttime: $STARTTIME"
echo "endtime:   $ENDTIME"
