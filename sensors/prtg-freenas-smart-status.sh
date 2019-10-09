#! /usr/bin/env bash

#title           : prtg-freenas-smart-status.sh
#description     : PRTG SSH custom sensor to check S.M.A.R.T. status for FreeNAS physical drives
#author          : Jan Werner
#date            : 2019-08-02
#version         : 0.1
#usage           : Upload to /var/prtg/scriptsxml on FreeNAS host and create 'SSH Advanced' sensor in PRTG
#notes           : Modify 'array' to suit your needs
#==============================================================================
#
#
#
# Drives Array
array=( ada0 ada1 ada2 ada3 ada4 ada5 )

function smart_extract {
   MODEL=`smartctl -i /dev/$1 | sed -En 's/Device Model:[ \s]*//gp'`
   SERIAL=`smartctl -i /dev/$1 | sed -En 's/Serial Number:[ \s]*//gp'`
   SMARTRESULT=`smartctl -H /dev/$1 | sed -En 's/SMART overall-health self-assessment test result:[ \s]*//gp'`

if [ $SMARTRESULT == 'PASSED' ]
then
  HEALTH=1
else
  HEALTH=0
fi

}

echo "<prtg>"

# <-- Start
for i in "${array[@]}"
do

smart_extract $i

echo -n "   <result>
       <channel>$MODEL ($SERIAL) ($i)</channel>
       <value>$HEALTH</value>
       <ValueLookup>prtg.standardlookups.boolean.statetrueok</ValueLookup>
   </result>
"
done
# End -->
echo "</prtg>"
exit
