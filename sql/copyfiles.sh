#!/bin/bash

# commandline: copyfiles.sh <fileage> <sourcefolder>
# commandline: copyfiles.sh 10 /home/too-tourasia/upload

# PERIODE=60
PERIODE=$1 # first command line parameter
SOURCE=$2 # second command line parameter
DEST=/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/export_diff 

# find files that are newer than xx minutes
COPYFILES=$(find $SOURCE -mmin -$PERIODE)
COPYFILESC=( $(find $SOURCE -mmin -$PERIODE) )

# if files exist, copy this files
if [ -n "$COPYFILES" ]
then
	cp -p $COPYFILES $DEST &>/dev/null
	COPYTIME=$(date +"%Y-%m-%d %T")
	echo "$COPYTIME copied ${#COPYFILESC[*]} files from $SOURCE to $DEST" >> copyfiles.log
fi



