#!/bin/sh

# Created by  : ereshre
# Created in  : 17 Apr 12
##
### VERSION HISTORY
# Ver1        : Created for Uncompress and start the simulation
# Purpose     :
# Description :
# Date        : 17.04.2012
# Who         : Reshma

if [ "$#" -ne 0  ]
then
cat<<HELP

Usage: $0 

Example: $0 

DESC   :

CONFIG FILE DETAILS has be configured as per the netsim and the nodes on that.
HELP
 exit 1
fi

#***************************************************************************************************************************
#									CONFIG FILE DETAILS							
#***************************************************************************************************************************
LOC_SERVERS="netsimlin299"

netsimlin299_list="RNC49"
#***************************************************************************************************************************


 
for SERVER in $LOC_SERVERS
do
	LIST=`eval echo '$'${SERVER}_list`
	if [ "$LIST" == "" ]
	then
		echo "  $SERVER doesn't have any list"
		continue
	else
		echo "LIST="$LIST
	fi
  echo "#############################"
  echo "Executing Script on "$SERVER
  echo "#############################"
	
	for RNC in $LIST
	do
		echo "$RNC= " $RNC
		
	    RNCSIMNAME=`/usr/bin/rsh -n -l netsim $SERVER "/bin/ls -d /netsim/netsimdir/*$RNC | cut -d'/' -f4"`
		echo "RNCSIMNAME:"$RNCSIMNAME
		
MMLSCRIPT=$0".mml"

#########################################
# 
# Make MML Script
#
#########################################
echo ""
echo "MAKING MML SCRIPT"
echo ""

echo '.open '$RNCSIMNAME >> $MMLSCRIPT
echo '.selectnocallback network ' >> $MMLSCRIPT
echo "setmoattribute:mo="ManagedElement=1,SystemFunctions=1,Security=1", attributes="operationalSecurityLevel=3";">> $MMLSCRIPT
echo "setmoattribute:mo="ManagedElement=1,SystemFunctions=1,Security=1", attributes="requestedSecurityLevel=3";" >> $MMLSCRIPT
#rm $PWD/$MMLSCRIPT
	
	done
done

