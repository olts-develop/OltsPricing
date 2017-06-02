key=$1
dateval=$2

START=$(date +%s.%N)
ISOSTART=$(date +"%Y-%m-%d %H:%M:%S:%N")
command='curl -s -o $key.txt -w @curl-format.txt "http://10.10.10.17:8080/OltDb2WebServicesOltDb2WebService/rest/OltDb2WebService/SP_PRICING_AV_MISC?IN_TOCODE=&IN_LANGCODE=DE&IN_DESTINATIONCODE=&IN_PRICEDATEFROM=${dateval}&IN_PRICEDATETO=${dateval}&IN_NRADULTS=2&IN_MISCCODE=&IN_MISCITEMCODE=&IN_CHDDOB1=&IN_CHDDOB2=&IN_CHDDOB3=&IN_CHDDOB4=&IN_IGNORE_XX=0&IN_IGNORE_RQ=0&IN_IGNORE_PRICE0=0&IN_CURRENTDATE=&IN_MISCKEY=${key}"'
eval $command
END=$(date +%s.%N)
ISOEND=$(date +"%Y-%m-%d %H:%M:%S:%N")
DIFF=$( echo "scale=3; (${END} - ${START})*1000/1" | bc )

echo -e "\n\ncommand:\n${command}\n\nkey: ${key}\ndate: ${dateval}\n\nstart: ${ISOSTART}\nend:   ${ISOEND}\ndiff:  ${DIFF} milliseconds" >> ${key}.txt