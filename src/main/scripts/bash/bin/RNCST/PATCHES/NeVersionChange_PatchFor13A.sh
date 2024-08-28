#!/bin/sh

# Created by  : Reshma
# Created in  : 17/10/2012
##
### VERSION HISTORY
##############################################
# Ver1        : Created for WRAN deployment O13A
# Purpose     : Update the NEType to S1100-V7lim
# Description : 
# Date        : 17.10.2012
# Who         : Reshma
##############################################

if [ "$#" -ne 1 ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <rnc num>

Example: $0 RNCL130-ST-RNC01 1

HELP

exit 1
fi

RNCID=$1

if [ "$RNCID" -le 9 ]
then
  RNCNAME="RNC0"$RNCID
  RNCCOUNT="0"$RNCID
else
  RNCNAME="RNC"$RNCID
  RNCCOUNT=$RNCID
fi

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

# to get rid of extra prefix when we run the command on remote server
if [ ! -f $PWD/$0 ]
  then
  PWD=""
fi

MMLSCRIPT=$0${NOW}:$RNCNAME:${RANDOM1}:$$".mml"

if [ -f $PWD/$MMLSCRIPT ]
then
  rm -r  $PWD/$MMLSCRIPT
  echo "old "$PWD/$MMLSCRIPT " removed"
fi

SIMNAME=`ls /netsim/netsimdir | egrep ${RNCNAME} | grep ST | grep -m1 -v zip`
SUCCESS=$?
echo "SUCCESS="$SUCCESS

if [ $SUCCESS -eq 1 ]
then
  echo "no simulation found!"
  echo "exiting..."
  echo ""
  exit
fi

#########################################
#
# Make MML Script
#
#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""


echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$RNCNAME >> $MMLSCRIPT
echo '.switchmim WCDMA RNC S1100-V7lim -verbose -nowarn -force_attr_reset -force_struct_reset' >> $MMLSCRIPT

/netsim/inst/netsim_shell < $MMLSCRIPT

rm $PWD/$MMLSCRIPT

echo "...script ended at "`date`
echo ""
