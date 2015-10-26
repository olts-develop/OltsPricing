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
SCRIPTNAME=import-all
LOGFILE=$SCRIPTNAME-linux.log

echo $SCRIPTNAME.sh > $LOGFILE
echo $LINE >> $LOGFILE

echo Start $SCRIPTNAME >> $LOGFILE
echo "starttime: $STARTTIME" >> $LOGFILE
echo $LINE >> $LOGFILE

db2 connect to HOTEL user db2inst1 using ibmdb2 >> $LOGFILE
echo $LINE >> $LOGFILE

# $SCRIPTNAME-linux
echo $SCRIPTNAME-linux.sql >> $LOGFILE
db2 -td@ -vf $SCRIPTNAME-linux.sql >> $LOGFILE
echo $LINE >> $LOGFILE

db2 connect reset >> $LOGFILE
echo $LINE >> $LOGFILE

ENDTIME=$(date +"%T")
echo "endtime:   $ENDTIME" >> $LOGFILE

echo End $SCRIPTNAME >> $LOGFILE

