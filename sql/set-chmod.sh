#!/bin/sh

SCRIPTNAME=set-chmod
LOGFILE="$(dirname "$0")/$SCRIPTNAME.log"

cd "$(dirname "$0")"

chmod 755 import.sh > $LOGFILE
chmod 755 load.sh >> $LOGFILE

cd functions >> $LOGFILE
chmod 755 createfunctions-linux.sh >> $LOGFILE

cd ..
cd tables >> $LOGFILE
chmod 755 createtables-linux.sh >> $LOGFILE
chmod 755 createindexes-linux.sh >> $LOGFILE

cd ..
cd import-all >> $LOGFILE
chmod 755 import-all-linux.sh >> $LOGFILE

cd ..
cd import-diff >> $LOGFILE
chmod 755 import-diff-linux.sh >> $LOGFILE

cd ..
cd load-all >> $LOGFILE
chmod 755 load-all-linux.sh >> $LOGFILE

cd ..
cd runstats >> $LOGFILE
chmod 755 runstats-linux.sh >> $LOGFILE
