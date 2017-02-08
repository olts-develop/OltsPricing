#!/bin/sh

# converts xml-files into csv-files.
# Creation of tables and functions and import of data is done by other scripts.
# Theses scripts are called later below
# to start manually (with logfile):
# ./import_diff.sh | tee -a import_diff.log

echo "starting..."


# get time
STARTTIME=$(date +"%T")
NOW=$(date +"%T")

FILEAGE=10
echo "Fileage: $FILEAGE"

echo " "

# check if full import already running
if [ "$(pidof -x import.sh)" ]; then
  echo " "
  echo "*****************************************************************"
  echo "time: $NOW"
  echo 'Full import lauft!'
  echo "*****************************************************************"
  echo " "
  exit 1
fi

# check if other istance of diff import still running
PROCID=$(pidof -x import_diff.sh)
FOUND=$(echo $PROCID | grep -b -o " ")
if [ $FOUND ]; then
  echo " "
  echo "*****************************************************************"
  echo "time: $NOW"
  echo 'Eine andere Instanz lauft bereits!'
  echo "*****************************************************************"
  echo " "
  exit 1
fi

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

# delete all xml files
rm -rf export_diff
mkdir export_diff

# copy new files for all TOO
NOW=$(date +"%T")
echo "."
echo "#########################################################"
echo "start files copy"
echo "time: $NOW"
./copyfiles.sh $FILEAGE /home/too-knecht/upload
./copyfiles.sh $FILEAGE /home/too-stohler/upload
./copyfiles.sh $FILEAGE /home/too-tourasia/upload
NOW=$(date +"%T")
echo "finished files copy"
echo "time: $NOW"
echo "#########################################################"
echo "."

cd export_diff

# delete all csv files
rm -f *.csv
rm -f ../import_diff/*.csv

# process xml-files and create csv-files
START_CONV=$(date +"%T")
n=1;
for i in *.xml; do
	if [ -f $i ]
	then
		echo "#########################################################"
		echo "actual file nr.: $n"
		echo read : $i
		../../import $i TFS
		# let "n = n+1"
		n=`expr $n + 1`
	else
		echo "#########################################################"
		echo "no file found, exit"	
		NOW=$(date +"%T")
		echo "time: $NOW"
		echo "#########################################################"
		exit 0;  # Erfolgreich beenden ...
	fi
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
mv *.csv ../import_diff

cd ..

NOW=$(date +"%T")
echo "."
echo "conversion finished"
echo "starttime: $START_CONV"
echo "time: $NOW"
echo "#########################################################"
echo "."

# call scripts to import data from csv-files
NOW=$(date +"%T")
echo "."
echo "#########################################################"
echo "start data import"
echo "time: $NOW"
cd import-diff
./import-diff-linux.sh
cd ..
NOW=$(date +"%T")
echo "finished data import"
echo "time: $NOW"
echo "#########################################################"
echo "."

# call scripts to reorganize data and indexes
# NOW=$(date +"%T")
# echo "."
# echo "#########################################################"
# echo "start runstats"
# echo "time: $NOW"
# cd runstats
# ./runstats-linux.sh
# cd ..
# NOW=$(date +"%T")
# echo "finished runstats"
# echo "time: $NOW"
# echo "#########################################################"
# echo "."

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
