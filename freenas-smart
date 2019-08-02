#!/bin/bash
#
# SSH-based EXEXML sensor (SSH Advanced)
# Upload script to FreeNAS host to /var/prtg/scriptsxml
#
# Drives Array
array=( ada0 ada1 ada2 ada3 ada4 ada5 )

function smart_extract {
   MODEL=`smartctl -i /dev/$1 | sed -En 's/Device Model:[ \s]*//gp'`
   SERIAL=`smartctl -i /dev/$1 | sed -En 's/Serial Number:[ \s]*//gp'`
   SMARTRESULT=`smartctl -H /dev/$1 | sed -En 's/SMART overall-health self-assessment test result:[ \s]*//gp'`

if [ $SMARTRESULT == 'PASSED' ]
then
  HEALTH=TRUE
else
  HEALTH=FALSE
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
