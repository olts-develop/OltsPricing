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
SCRIPTNAME=createfunctions
LOGFILE=$SCRIPTNAME-linux.log
VERBOSE=

echo $SCRIPTNAME.sh > $LOGFILE
echo $LINE >> $LOGFILE

echo Start $SCRIPTNAME >> $LOGFILE
echo "starttime: $STARTTIME" >> $LOGFILE
echo $LINE >> $LOGFILE

db2 connect to HOTEL user db2inst1 using ibmdb2 >> $LOGFILE
echo $LINE >> $LOGFILE

# elements2
echo elements2.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f elements2.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_getposdatedesc
echo func_getposdatedesc.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_getposdatedesc.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_roomvalid
echo func_roomvalid.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_roomvalid.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_miscvalid
echo func_roomvalid.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_miscvalid.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_all
echo func_all.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_all.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_spof3
echo func_spof3.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_spof3.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_pricing3
echo func_pricing3.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_pricing3.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_eb2
echo func_eb2.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_eb2.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_pricing2
echo func_pricing2.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_pricing2.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_test_price
echo func_test_price.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_test_price.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_pricing
echo func_pricing.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_pricing.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_miscpricing
echo func_pricing.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_miscpricing.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_roompricebydest
echo func_roompricebydest.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_roompricebydest.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_miscpricebydest
echo func_miscpricebydest.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_miscpricebydest.sql >> $LOGFILE
echo $LINE >> $LOGFILE

# func_get_allotment2
echo func_get_allotment2.sql >> $LOGFILE
db2 -td@ -${VERBOSE}f func_get_allotment2.sql >> $LOGFILE
echo $LINE >> $LOGFILE

db2 connect reset >> $LOGFILE
echo $LINE >> $LOGFILE

ENDTIME=$(date +"%T")
echo "endtime:   $ENDTIME" >> $LOGFILE

echo End $SCRIPTNAME >> $LOGFILE

cat $LOGFILE

