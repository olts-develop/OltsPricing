#!/bin/sh
#-------------------------------------------------------------- 20.01.2000
#	ttsenv.sh
#
#	Funktions-Beschreibung: Hier wird der TTS Backup server für DB2 eingetragen
#
# Bitte db2stop und db2start ausführen oder maschine neu booten
# wenn nach dem ausführn dieses Skripts nicht auf die Remote
# Datenbank connectiert werden kann. (Fehler 08001 )!!!!!!!!!!!!!!!!!!!!!!
#
# Der genaue Port:"server 50002" muss aus /etc/services der Remote maschine entnommen werden
#-----------------------------------------------------------------------

#./ccc1.sh &
#./ccc2.sh &
#./ccc3.sh &
#./ccc4.sh &
#./ccc5.sh &

prod="TOUWAL14604 TOUWAL24712 TOUWAL10584 TOUWAL18478 TOUWAL10006 TOUWAL26348 TOUWAL10008 TOUWAL12828 TOUWAL12870 TOUWAL12890 TOUWAL12896 TOUWAL12944 TOUWAL12992 TOUWAL13014 TOUWAL16768 TOUWAL21976 TOUWAL21978 TOUWAL14604 TOUWAL24712 TOUWAL10584 TOUWAL18478 TOUWAL10006 TOUWAL26348 TOUWAL10008 TOUWAL12828 TOUWAL12870 TOUWAL12890 TOUWAL12896 TOUWAL12944 TOUWAL12992 TOUWAL13014 TOUWAL16768 TOUWAL21976 TOUWAL21978";


for a in $prod
do
./ccc1.sh $a &
done
