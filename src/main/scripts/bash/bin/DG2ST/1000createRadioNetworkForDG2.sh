#!/bin/sh

# Created by : XRANDYA 
##
### VERSION HISTORY
##################################################
# Ver1        : Created for O16B 
# Purpose     : DG2 data population 
# Description :
# Date        : 2015-06-01
# Who         : XRANDYA 
##################################################


if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <env file> <rnc num> 

Example: $0 RNCS1100-ST-RNC01 O13-ST-13A-40K.env 1

CREATE: WratLocalCell, Iub

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



echo "//...$0:$SIMNAME rbs script started running at "`date`
echo "//"


. ../../dat/$ENV

. ../utilityFunctions.sh
echo "switch value is $ENMSWITCH"
PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MOSCRIPT=$0:$SIMNAME".mo"
MMLSCRIPT=$0:$NOW:$SIMNAME".mml"


if [ -f $PWD/$MOSCRIPT ]
then
rm -r  $PWD/$MOSCRIPT
echo "old "$PWD/$MOSCRIPT " removed"
fi


if [ -f $PWD/$MMLSCRIPT ]
then
rm -r  $PWD/$MMLSCRIPT
echo "old "$PWD/$MMLSCRIPT " removed"
fi




echo "//.....$0:$SIMNAME MAKING MO SCRIPT DG2 started running at "`date`
echo "//"

cat >> $MMLSCRIPT << MMLSCT
.open $SIMNAME
.select $RNCNAME
  .start
MMLSCT

NUMOFDG2=`getNumOfDG2 $RNCCOUNT $RNCDG2ARRAY`
NUMOFPRBS=`getNumOfPICO $RNCCOUNT $RNCPICOARRAY`

COUNT=1
MOFILECOUNT=1

while [ "$COUNT" -le "$NUMOFDG2" ]
do

  if [ "$COUNT" -le 9 ]
   then
    RBSNAME=MSRBS-V20
	else
    RBSNAME=MSRBS-V2
  fi
rbsID=$((COUNT+NUMOFPRBS))


  MOFILEEXTENSION="__"$MOFILECOUNT".mo"

 NODENAME=$RNCNAME$RBSNAME$COUNT.mo

echo "$JARPATH/$RNCNAME/$NODENAME:JAR path"

 if [ -f  $JARPATH/$RNCNAME/$NODENAME ];
        then echo "File exist"
        cat $JARPATH/$RNCNAME/$NODENAME >> $MOSCRIPT$MOFILEEXTENSION
 else
        echo "File not exist"
       # java -jar -Xss50m $JARPATH/wran.jar $JARPATH/config.xml $RNCIDCOUNT $RNCIDCOUNT
 fi


##The condition to check whether the SIM is ENM or OSS to populate BrmBackupManager attributes -----xramjag

if [ "$ENMSWITCH" -eq 1 ];

then cat >> $MMLSCRIPT << MMLSCT

  .select $RNCNAME$RBSNAME$COUNT
  .start
  pmdata:disable;
  useattributecharacteristics:switch="off";
setmoattribute:mo="ManagedElement=$RNCNAME$RBSNAME$COUNT,SystemFunctions=1,BrM=1,BrmBackupManager=1",attributes="backupType (string)=Systemdata|| backupDomain (string)=System"; 


####Change for the Pm FileLocation attribute--xramjag

setmoattribute:mo="ManagedElement=$RNCNAME$RBSNAME$COUNT,SystemFunctions=1,Pm=1,PmMeasurementCapabilities=1",attributes="fileLocation (string)=/c/pm_data/";
MMLSCT
cat >> $PWD/$MOSCRIPT$MOFILEEXTENSION << MOSCT

SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ComTop:SystemFunctions=1,RcsPMEventM:PmEventM=1,RcsPMEventM:EventProducer=Lrat,RcsPMEventM:FilePullCapabilities=2"
    exception none
    nrOfAttributes 1
    "outputDirectory" String "/c/pm_data"
)


SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT"
    exception none
    nrOfAttributes 1
    "dnPrefix" String "$RNCNAME$RBSNAME$COUNT"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqFieldReplaceableUnit:FieldReplaceableUnit
    exception none
    nrOfAttributes 1
    "fieldReplaceableUnitId" String "1"
)

SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1,ReqSfpModule:SfpModule=1"
    exception none
    nrOfAttributes 1
    "sfpModuleId" String "1"
)

SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1,ReqPlugInModule:PlugInModule=1"
    exception none
    nrOfAttributes 1
    "plugInModuleId" String "1"
)

SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1,ReqEnergyMeter:EnergyMeter=1"
    exception none
    nrOfAttributes 1
    "energyMeterId" String "1"
)

SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1,ReqEFuse:EFuse=1"
    exception none
    nrOfAttributes 1
    "eFuseId" String "1"
)


CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)

MOSCT



  kertayle:file="$PWD/$MOSCRIPT$MOFILEEXTENSION";

else
cat >> $MMLSCRIPT << MMLSCT

  .select $RNCNAME$RBSNAME$COUNT
  .start
  pmdata:disable;
  useattributecharacteristics:switch="off";
setmoattribute:mo="ManagedElement=$RNCNAME$RBSNAME$COUNT,SystemFunctions=1,BrM=1,BrmBackupManager=1",attributes="backupType (string)=Type|| backupDomain (string)=Domain";


####Change for the Pm FileLocation attribute--xramjag

setmoattribute:mo="ManagedElement=$RNCNAME$RBSNAME$COUNT,SystemFunctions=1,Pm=1,PmMeasurementCapabilities=1",attributes="fileLocation (string)=/c/pm_data/";
MMLSCT
cat >> $PWD/$MOSCRIPT$MOFILEEXTENSION << MOSCT


SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT"
    exception none
    nrOfAttributes 1
    "dnPrefix" String "$RNCNAME$RBSNAME$COUNT"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqFieldReplaceableUnit:FieldReplaceableUnit
    exception none
    nrOfAttributes 1
    "fieldReplaceableUnitId" String "1"
)

SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1,ReqSfpModule:SfpModule=1"
    exception none
    nrOfAttributes 1
    "sfpModuleId" String "1"
)

SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1,ReqPlugInModule:PlugInModule=1"
    exception none
    nrOfAttributes 1
    "plugInModuleId" String "1"
)

SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1,ReqEnergyMeter:EnergyMeter=1"
    exception none
    nrOfAttributes 1
    "energyMeterId" String "1"
)

SET
(
    mo "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1,ReqEFuse:EFuse=1"
    exception none
    nrOfAttributes 1
    "eFuseId" String "1"
)


CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$RBSNAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)


MOSCT

  kertayle:file="$PWD/$MOSCRIPT$MOFILEEXTENSION";


fi

  COUNT=`expr $COUNT + 1`

  MOFILECOUNT=`expr $MOFILECOUNT + 1`
done





$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT

rm $PWD/$MOSCRIPT
rm $MMLSCRIPT

echo "//...$0:$SIMNAME DG2 MO FILES ended running at "`date`
echo "//"

echo "//.....$0:$SIMNAME MAKING MO SCRIPT FOR RBS6k Feature ON DG2 started running at "`date`
echo "//"

./aOut1241_Rbs6k_createCabinet_Mix.sh $SIMNAME $ENV $RNCIDCOUNT | tee -a $LOGFILE

#echo "//.....$0:$SIMNAME aOut1241_Rbs6k_createCabinet_Mix.sh  SCRIPT DG2 ended running at "`date`
#echo "//"

