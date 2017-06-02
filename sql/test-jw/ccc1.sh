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

db2 connect to hotel user db2inst1 using ibmdb2

prod=$1;

echo "---------------------------------------------------- $prod -------------------------------------------------------------"


db2 "SELECT x.MISCKEY AS hotelkey, x.misccode AS hotelcode, INV.title AS hotelname, INV.detail AS address1, '' AS address2, subregion AS city, country, countryisocode AS countrycode, x.destinationcode AS code, '4.0' AS category, x.MISCKEY AS     roomkey, 'EX' AS roomtypede, ITIN.title AS descriptionde, x.TOURBOCODE AS mealdescriptionde, miscitemcode AS mealcode, maximumpersons AS maxadults, 0 AS extrabedchildren, minimumpersons AS normaloccupancy, minimumpersons AS minimaloccupancy, maximumpersons AS maximaloccupancy, cast(    x.TOTAL AS FLOAT) AS price, x.STATUS AS status FROM TABLE (func_miscpriceav_ch('TSOL', '2017-06-12', '2017-06-15', '', 2, '', '', '', '')) AS     x INNER JOIN TOOMISC ON TOOMISC.MISCKEY = x.MISCKEY AND TOOMISC.TOCODE = x.TOCODE LEFT OUTER JOIN TOOMISCTEXT AS INV ON TOOMISC.MISCKEY = INV.    MISCKEY AND TOOMISC.TOCODE = INV.TOCODE AND INV.TYPE = 'INV' AND INV.LANG = 'DE' LEFT OUTER JOIN TOOMISCTEXT AS ITIN ON TOOMISC.MISCKEY = ITIN    .MISCKEY AND TOOMISC.TOCODE = ITIN.TOCODE AND ITIN.TYPE = 'ITIN' AND ITIN.LANG = 'DE' WHERE x.status <> 'XX'and x.misckey = '$prod' AND     (coalesce(toomisc.passive, 0) = 0 OR (toomisc.passive = 1 AND coalesce(toomisc.passivefromdate, CURRENT DATE) > CURRENT DATE))"

db2 connect reset

