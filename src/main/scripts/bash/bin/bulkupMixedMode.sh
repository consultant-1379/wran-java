#!/bin/sh

# Created by  : Harish Dunga
# Created in  : 26 02 2018
##
### VERSION HISTORY
#################################################
# Ver1        : Modified for ENM
# Purpose     : To add MO load on MixedMode Nodes
# Description :
# Date        : 26 02 2018
# Who         : Harish Dunga
#################################################

SIMNAME=$1
RNCNUM=$2
NUMOFNODES=$3

if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <rnc num> <num of mixed mode nodes>"
 echo
 echo "Example: $0 WegaC5LargeRNC14 SIM1.env 9 (to create RNC09)"
 echo
 exit 1
fi
Now=`date`
echo "Script started at $Now"
if [ "$RNCNUM" -le 9 ]
then
RNCNAME="RNC0"$RNCNUM
else
RNCNAME="RNC"$RNCNUM
fi
COUNT=1
while [ "$COUNT" -le "$NUMOFNODES" ]
do
if [ "$COUNT" -le "9" ]
then
NODENAME=$RNCNAME"MSRBS-V20"$COUNT
else
NODENAME=$RNCNAME"MSRBS-V2"$COUNT
fi
MMLSCRIPT=$NODENAME"_Bulked.mml"
if [ -f $PWD/$MMLSCRIPT ]
then
rm $PWD/$MMLSCRIPT
echo "old "$PWD/$MMLSCRIPT " removed"
fi
cat >> $MMLSCRIPT << MML
.open $SIMNAME
.select $NODENAME
.start
useattributecharacteristics:switch="off";
createmo:parentid="ManagedElement=$NODENAME,SystemFunctions=1,Lm=1",type="FeatureState",name="MO12", quantity=1400;
createmo:parentid="ManagedElement=$NODENAME,SystemFunctions=1,Lm=1",type="FeatureKey",name="MO12", quantity=1000;
createmo:parentid="ManagedElement=$NODENAME,SystemFunctions=1,Lm=1",type="CapacityState",name="MO12", quantity=500;
createmo:parentid="ManagedElement=$NODENAME,SystemFunctions=1,Lm=1",type="CapacityKey",name="MO12", quantity=250;
createmo:parentid="ManagedElement=$NODENAME,SystemFunctions=1,HwInventory=1",type="HwItem",name="MO12", quantity=500;
createmo:parentid="ManagedElement=$NODENAME,Equipment=1,FieldReplaceableUnit=1",type="EFuse",name="MO12", quantity=100;
createmo:parentid="ManagedElement=$NODENAME,Equipment=1,FieldReplaceableUnit=1",type="SfpModule",name="MO12", quantity=200;
MML
~/inst/netsim_shell < $MMLSCRIPT
rm $MMLSCRIPT
COUNT=`expr $COUNT + 1`
done
NOW=`date`
echo " Script ended at $NOW"
