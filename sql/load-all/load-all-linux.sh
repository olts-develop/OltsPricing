#!/bin/sh

# ****************************************************************************
# This batch file creates all functions necessary for the pricing of hotels
# ****************************************************************************

# ----------------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------------
# get time
STARTTIME=$(date +"%T")
LINE=---------------------------------------------------------
SCRIPTNAME=/home/oltworker/projects/hotel_api/src/modules/tfs/tfsimporter/sql/load-all/load-all
LOGFILE=./$SCRIPTNAME-linux.log

echo "$SCRIPTNAME.sh" > $LOGFILE
echo $LINE >> $LOGFILE

echo "Start $SCRIPTNAME" >> $LOGFILE
echo "starttime: $STARTTIME" >> $LOGFILE
echo $LINE >> $LOGFILE

/opt/ibm/db2/V10.5/bin/db2 connect to HOTEL user db2inst1 using ibmdb2 >> $LOGFILE
echo $LINE >> $LOGFILE

echo . >> $LOGFILE
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P) 
echo cd "$dir" >> $LOGFILE
cd "$dir"  
echo . >> $LOGFILE

# $SCRIPTNAME-linux
echo $SCRIPTNAME-linux.sql >> $LOGFILE
/opt/ibm/db2/V10.5/bin/db2 -td@ -vf $SCRIPTNAME-linux.sql >> $LOGFILE
echo $LINE >> $LOGFILE

/opt/ibm/db2/V10.5/bin/db2 connect reset >> $LOGFILE
echo $LINE >> $LOGFILE

ENDTIME=$(date +"%T")
echo "endtime:   $ENDTIME" >> $LOGFILE

echo "End $SCRIPTNAME" >> $LOGFILE

