#!/bin/sh

# Created by : Fatih ONUR
# Created in : unknown
##
### VERSION HISTORY
##################################################
# Ver1        : Created for R6.2 TERE
##################################################
# Ver2        : Moddified for WRAN TERE O.11.2
# Purpose     : To start nodes parallel
# Description :
# Date        : 18 APR 2011
# Who         : Fatih ONUR
##################################################


if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <env file> <rnc num>

Example: $0 RNCS1100-ST-RNC01 O13-ST-13A-40K.env 1

CREATE: RbsLocalCell, Iub

HELP

exit
fi


SIMNAME=$1
ENV=$2
RNCIDCOUNT=$3


if [ "$RNCIDCOUNT" -le 9 ]
then
  RNCNAME="RNC0"$RNCIDCOUNT
  RNCCOUNT="0"$RNCIDCOUNT
else
  RNCNAME="RNC"$RNCIDCOUNT
  RNCCOUNT=$RNCIDCOUNT
fi

if [ "$RNC_NODE_CREATION" != "YES" ]
then
  RNCNAME=""
fi


echo "//...$0:$SIMNAME rbs script started running at "`date`
echo "//"

. ../../dat/$ENV

. ../utilityFunctions.sh

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MOSCRIPT=$0:$NOW:$SIMNAME".mo"
MMLSCRIPT=$0:$NOW:$SIMNAME".mml"


if [ -f $PWD/$MOSCRIPT ]
then
rm -rf  $PWD/$MOSCRIPT
echo "old "$PWD/$MOSCRIPT " removed"
fi


if [ -f $PWD/$MMLSCRIPT ]
then
rm -rf  $PWD/$MMLSCRIPT
echo "old "$PWD/$MMLSCRIPT " removed"
fi

#########################################
# Make MML Script
#########################################

#echo "//.....$0:$SIMNAME MAKING MO SCRIPT RBS ended running at "`date`
#echo "//"

echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.selectregexp simne '$RBSNES >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT

echo "!!!!!!!!!!Entering into Create Cabinet"

./aOut1241createCabinet_multi.sh $SIMNAME $ENV $RNCIDCOUNT >> $MMLSCRIPT

echo "!!!!!!!!!ENd of CreateCabinet"

$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT

rm -rf  $PWD/$MOSCRIPT

###########################
. $DEL1
. $DEL2
. $DEL3
rm -rf $DEL1 $DEL2 $DEL3
###########################

rm -rf $PWD/$MMLSCRIPT

echo "//...$0:$SIMNAME rbs script ended running at "`date`
echo "//"
