#!/bin/sh

# Created by  : Fatih ONUR
# Created in  : 30/08/2012
##
### VERSION HISTORY
##############################################
# Ver1        : Created for WRAN deployment O13A
# Purpose     : Update missing External Utran Cells Relations for WRAN_2 network
# Description : 
# Date        : 30.08.2012
# Who         : Fatih ONUR
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

################################
# ENV VARIABLES
################################
# RNC Distribution
# [ TYPE=1, NUMOFRC=52, NUMOFRBS=75] ; [..] ; [..] ; [..]
RNCRBSARRAY="1,53,75;"\
"2,41,65;"\
"3,9,146;"\
"4,1,260;"\
"5,1,344;"\
"6,1,421;"

# RBS CELL Distribution
# TYPE1[ TOTALNUMOFCELLS,NUMOFRBS-CELLNUM,NUMOFRBS-CELLNUM,...] ; TYPE2[..] ; TYPE3[..] ; TYPE4[..]
RBSCELLARRAY="320,8-1,37-3,25-6,3-9,2-12;"\
"245,5-1,40-3,20-6,0-9,0-12;"\
"725,5-1,74-3,45-6,12-9,10-12;"\
"1450,10-1,110-3,80-6,30-9,30-12;"\
"2305,10-1,110-3,80-6,81-9,63-12;"\
"3021,21-1,100-3,100-6,100-9,100-12;"

#### IRATHOM ATTRIBUTES FOR WRAN TO WRAN
MCC=46
MNC=6
EXTMNC=7
MNCLENGTH=2


################################
# Functions
################################

# 
# calculates  group 
#   eg. COUNT=5 NUMOFELM=3; GROUP-1= 1,2,3  GROUP-2= 4,5,6... so 5 is under group-2
# 
getGroup() # COUNT NUMOFELM
{ 
COUNT=$1
NUMOFELM=$2
    
MOD=`expr $COUNT % $NUMOFELM`
DIV=`expr $COUNT / $NUMOFELM` 
    
if [ "$MOD" -eq 0 ]
then
  GROUP=$DIV
else
  GROUP=`expr $DIV + 1`
fi  
    
echo $GROUP
} 

#
## get total numb of cells for defined num of RBS
#
getNumOfRBS() # RNCCOUNT RNCRBSARRAY RBSCELLARRAY
{

RNCCOUNT=$1
RNCRBSARRAY=$2
RBSCELLARRAY=$3

NUMOFRNC=0
IFS=";"
for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    TOTALCELLS=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}' | awk -F"," '{print $1}'`
    NUMOFRBS=`echo $x | awk -F"," '{print $3}'`

    #echo "RNCCOUNT="$RNCCOUNT
    #echo "NUMOFRBS="$NUMOFRBS
    echo $NUMOFRBS
    #echo "NUMOFRNC="$NUMOFRNC
    #echo "TYPE="$TYPE
    #echo "TOTALCELLS="$TOTALCELLS
    #echo $TOTALCELLS
    break
  fi
done;
}

################################
# SETUP and PRECHECKS
################################

RNCID=$1
INPUTFILENAME="icon_ip_config_file.csv"
FILE=$INPUTFILENAME

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

max1=1000000
RANDOM1=$((`cat /dev/urandom|od -N1 -An -i` % $max1))

MOSCRIPT=$0${NOW}:$RNCNAME:${RANDOM1}:$$".mo"
MMLSCRIPT=$0${NOW}:$RNCNAME:${RANDOM1}:$$".mml"


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


################################
# MAIN
################################

echo "...$SIMNAME:$0 script started running at "`date`
echo ""

NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

## SEPARATORs for arguments (between excel columns)
SEP01=","



#########################################
# 
# Make MO Script
#
#########################################

echo ""
echo "MAKING MO SCRIPT"
echo ""

# read ICON config data from the ICONCONFIGFILE
#
LINE=`egrep "${RNCNAME}," /tmp/$FILE`
#LINE=`egrep "${RNCNAME}," ${PWD}/$FILE`
#echo "LINE="$LINE
#exit
IUBCOUNT=1
if [ "$RNCID" -eq 2 ]
then
IUBEND=`expr $NUMOFRBS + 12`
else
IUBEND=$NUMOFRBS
fi
if [ "$RNCID" -ge 49 ] && [ "$RNCID" -le 101 ]
then
  ATM=0
  IP=1
  OPERATIONALSTATE=0  # 0:DISABLED, 1:ENABLED
  ADMINISTRATIVESTATE=0  # 0:LOCKED, 1:UNLOCKED
else
  ATM=1
  IP=0
  OPERATIONALSTATE=1  # 0:DISABLED, 1:ENABLED
  ADMINISTRATIVESTATE=1  # 0:LOCKED, 1:UNLOCKED
fi
if [ "$RNCID" -ge 102 ]
then
ATM=1
IP=1
fi
while [ "$IUBCOUNT" -le "$IUBEND" ]
do
#echo "IubLink="$IUBCOUNT" ATM="$ATM" IP="$IP
echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,RncFunction=1"' >> $MOSCRIPT
echo ' identity '$IUBCOUNT >> $MOSCRIPT
echo ' moType IubLink' >> $MOSCRIPT
echo ' exception none' >> $MOSCRIPT
echo ' nrOfAttributes 4' >> $MOSCRIPT
echo '   rbsId Integer '$IUBCOUNT >> $MOSCRIPT
echo ' rncModuleRef Ref "ManagedElement=1,RncFunction=1,RncModule=1"' >> $MOSCRIPT
echo '   controlPlaneTransportOption Struct' >> $MOSCRIPT
echo '      nrOfElements 2' >> $MOSCRIPT
echo '        atm Integer '$ATM >> $MOSCRIPT
echo '        ipv4 Integer '$IP >> $MOSCRIPT
echo '   userPlaneTransportOption Struct' >> $MOSCRIPT
echo '      nrOfElements 2' >> $MOSCRIPT
echo '        atm Integer '$ATM >> $MOSCRIPT
echo '        ipv4 Integer '$IP >> $MOSCRIPT
     echo '   operationalState Integer '$OPERATIONALSTATE >> $MOSCRIPT
echo '   administrativeState Integer '$ADMINISTRATIVESTATE >> $MOSCRIPT
echo ')' >> $MOSCRIPT
IUBCOUNT=`expr $IUBCOUNT + 1`
done
cat >> $MOSCRIPT << MOSCT

CREATE
(
    parent "ManagedElement=1,Equipment=1"
    identity "MS"
    moType Subrack
    exception none
    nrOfAttributes 11
    "SubrackId" String "MS"
    "administrativeProductData" Struct
        nrOfElements 5
        "productNumber" String ""
        "productRevision" String ""
        "productName" String ""
        "productInfo" String ""
        "productionDate" String ""

    "cabinetPosition" String ""
    "numberOfSlots" Integer 28
    "operationalProductData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "productType" String ""
    "reservedBy" Array Ref 0
    "subrackPosition" String ""
    "subrackType" Integer 0
    "switchModule" Ref "null"
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "1"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "1"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 1
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "2"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "2"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 2
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "3"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "3"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 3
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "4"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "4"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 4
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "5"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "5"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 5
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "6"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "6"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 6
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "7"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "7"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 7
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "8"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "8"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 8
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "9"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "9"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 9
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "10"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "10"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 10
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "11"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "11"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 11
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "12"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "12"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 12
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "13"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "13"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 13
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "14"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "14"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 14
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "15"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "15"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 15
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "16"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "16"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 16
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "17"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "17"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 17
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "18"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "18"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 18
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "19"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "19"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 19
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "20"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "20"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 20
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "21"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "21"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 21
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "22"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "22"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 22
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "23"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "23"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 23
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "24"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "24"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 24
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "25"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "25"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 25
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "26"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "26"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 26
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "27"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "27"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 27
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=MS"
    identity "28"
    moType Slot
    exception none
    nrOfAttributes 8
    "SlotId" String "28"
    "productData" Struct
        nrOfElements 5
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "serialNumber" String ""
        "productionDate" String ""

    "reservedBy" Array Ref 0
    "slotNumber" Integer 28
    "slotState" Integer 0
    // "upgradeGroupId" Integer 0
    // "upgradeGroupTypeName" String ""
    "userLabel" String ""
)

MOSCT
VAR=1
while [ "$VAR" -le 28 ]
do


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$VAR'"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType PlugInUnit' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

VAR=`expr $VAR + 1`
done


NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

RBSCOUNT=1
VAR=1

while [ "$RBSCOUNT" -le "$NUMOFRBS" ]
do

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo ' parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$VAR'"' >> $MOSCRIPT
echo ' identity 1' >> $MOSCRIPT
echo ' moType PlugInUnit' >> $MOSCRIPT
echo ' exception none' >> $MOSCRIPT
echo ' nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$VAR',PlugInUnit=1"' >> $MOSCRIPT
echo '   identity ET-MFG' >> $MOSCRIPT
echo '   moType ExchangeTerminal' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$VAR',PlugInUnit=1,ExchangeTerminal=ET-MFG"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType Os155SpiTtp' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


REM=`expr $RBSCOUNT % 126`
if [ "$REM" -eq 0 ]
then
 VAR=`expr $VAR + 1`
fi

RBSCOUNT=`expr $RBSCOUNT + 1`

done


#echo 'CREATE' >> $MOSCRIPT
#echo '(' >> $MOSCRIPT
#echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=5,PlugInUnit=1"' >> $MOSCRIPT
#echo '   identity 1' >> $MOSCRIPT
#echo '   moType TuDeviceGroup' >> $MOSCRIPT
#echo '   exception none' >> $MOSCRIPT
#echo '   nrOfAttributes 0' >> $MOSCRIPT
#echo ')' >> $MOSCRIPT

#echo 'CREATE' >> $MOSCRIPT
#echo '(' >> $MOSCRIPT
#echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=5,PlugInUnit=1,TuDeviceGroup=1"' >> $MOSCRIPT
#echo '   identity 1' >> $MOSCRIPT
#echo '   moType TimDeviceSet' >> $MOSCRIPT
#echo '   exception none' >> $MOSCRIPT
#echo '   nrOfAttributes 0' >> $MOSCRIPT
#echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=5,PlugInUnit=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType TimDevice' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


# Creating extra mo for test analysis
echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,TransportNetwork=1' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType Mspg' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,TransportNetwork=1' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType MspgExtended' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT



#echo 'CREATE' >> $MOSCRIPT
#echo '(' >> $MOSCRIPT
#echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1' >> $MOSCRIPT
#echo '   identity ta1' >> $MOSCRIPT
#echo '   moType EtMfg' >> $MOSCRIPT
#echo '   exception none' >> $MOSCRIPT
#echo '   nrOfAttributes 0' >> $MOSCRIPT
#echo ')' >> $MOSCRIPT

#echo 'CREATE' >> $MOSCRIPT
#echo '(' >> $MOSCRIPT
#echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,EtMfg=ta1' >> $MOSCRIPT
#echo '   identity ta1' >> $MOSCRIPT
#echo '   moType GigaBitEthernet' >> $MOSCRIPT
#echo '   exception none' >> $MOSCRIPT
#echo '   nrOfAttributes 0' >> $MOSCRIPT
#echo ')' >> $MOSCRIPT




echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,ExchangeTerminal=ET-MFG' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType E3PhysPathTerm' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,ExchangeTerminal=ET-MFG' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType T3PhysPathTerm' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT



echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,ExchangeTerminal=ET-MFG' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType E1PhysPathTerm' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,ExchangeTerminal=ET-MFG,E1PhysPathTerm=ta1' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType Ds0Bundle' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,ExchangeTerminal=ET-MFG' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType J1PhysPathTerm' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,ExchangeTerminal=ET-MFG' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType T1PhysPathTerm' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType Cbu' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType GeneralProcessorUnit' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,GeneralProcessorUnit=ta1' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType FastEthernet' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,GeneralProcessorUnit=ta1' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType MediumAccessUnit' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

REM=`expr $NUMOFRBS / 126 + 1`
SLOTID=1

while [ "$SLOTID" -le "$REM" ]
do


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$SLOTID',PlugInUnit=1,ExchangeTerminal=ET-MFG' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType Os155SpiTtp' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$SLOTID',PlugInUnit=1,ExchangeTerminal=ET-MFG,Os155SpiTtp=ta1' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType Sts3CspeTtp' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

SLOTID=`expr $SLOTID + 1`
done


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType TimingUnit' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1,TimingUnit=1' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType TuSyncRef' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=2,PlugInUnit=1' >> $MOSCRIPT
echo '   identity ET-MFG' >> $MOSCRIPT
echo '   moType ExchangeTerminal' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=2,PlugInUnit=1,ExchangeTerminal=ET-MFG' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType Os155SpiTtp' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot=2,PlugInUnit=1,ExchangeTerminal=ET-MFG,Os155SpiTtp=ta1' >> $MOSCRIPT
echo '   identity ta1' >> $MOSCRIPT
echo '   moType Sts3CspeTtp' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT
MAXRBSPERSCTP=64

NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
NUMOFSCTP=`getGroup $NUMOFRBS $MAXRBSPERSCTP`


############################ CREATE
############################## Vlan

VLAN_vid=100;

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,EthernetSwitchFabric=1' >> $MOSCRIPT
echo ' identity 1' >> $MOSCRIPT
echo ' moType Vlan' >> $MOSCRIPT
echo ' exception none' >> $MOSCRIPT
echo ' nrOfAttributes 1' >> $MOSCRIPT
echo '   vid Integer '$VLAN_vid'' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


COUNT=1
STOP=2
while [ "$COUNT" -le "$STOP" ]
do

  ############################ CREATE
  ############################## IpAccessHostEt

  IPACCESSHOSTID=$COUNT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,IpSystem=1' >> $MOSCRIPT
  echo ' identity '$IPACCESSHOSTID >> $MOSCRIPT
  echo ' moType IpAccessHostEt' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 0' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  COUNT=`expr $COUNT + 1`
done




COUNT=1
STOP=$NUMOFSCTP
while [ "$COUNT" -le "$STOP" ]
do 

  ############################ CREATE
  ############################## Sctp

  SCTPID=$COUNT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,TransportNetwork=1"' >> $MOSCRIPT
  echo ' identity '$SCTPID >> $MOSCRIPT
  echo ' moType Sctp' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 0' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT


  ############################ MO 
  ############################## IpAccessSctp

  IPACCESSHOSTGPBID=$COUNT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,IpSystem=1' >> $MOSCRIPT
  echo ' identity '$IPACCESSHOSTGPBID >> $MOSCRIPT
  echo ' moType IpAccessSctp' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 0' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT


  ############################ SET
  ############################## Sctp

  echo 'SET' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  mo "ManagedElement=1,TransportNetwork=1,Sctp='$SCTPID'"' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 1' >> $MOSCRIPT
  echo '   ipAccessSctpRef Ref "ManagedElement=1,IpSystem=1,IpAccessSctp='$IPACCESSHOSTGPBID'"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT


  ############################ SET
  ############################## IpAccessSctp
  
  echo 'SET' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  mo "ManagedElement=1,IpSystem=1,IpAccessSctp='$IPACCESSHOSTGPBID'"' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 2' >> $MOSCRIPT
  echo '   ipAccessHostEtRef1 Ref "ManagedElement=1,IpSystem=1,IpAccessHostEt=1"' >> $MOSCRIPT
  echo '   ipAccessHostEtRef2 Ref "ManagedElement=1,IpSystem=1,IpAccessHostEt=2"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  COUNT=`expr $COUNT + 1`
done




############################ CREATE
############################## IpAccessHostPool

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,IpSystem=1' >> $MOSCRIPT
echo ' identity Iub' >> $MOSCRIPT
echo ' moType IpAccessHostPool' >> $MOSCRIPT
echo ' exception none' >> $MOSCRIPT
echo ' nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


############################ SET
############################## IpAccessHostPool

echo 'SET' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  mo "ManagedElement=1,IpSystem=1,IpAccessHostPool=Iub' >> $MOSCRIPT
echo ' exception none' >> $MOSCRIPT
echo ' nrOfAttributes 2' >> $MOSCRIPT
echo ' ipAccessHostRef Array Ref 2 ' >> $MOSCRIPT
echo '   "ManagedElement=1,IpSystem=1,IpAccessHostEt=1" ' >> $MOSCRIPT
echo '   "ManagedElement=1,IpSystem=1,IpAccessHostEt=2" ' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

IPACCESSHOSTCOUNT=1
RNC_COLUMN=2
COUNT=3
STOP=4
while [ "$COUNT" -le "$STOP" ]
do  

  ############################ CREATE
  ############################## ExchangeTerminalIp

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$COUNT',PlugInUnit=1"' >> $MOSCRIPT
  echo ' identity 1' >> $MOSCRIPT
  echo ' moType ExchangeTerminalIp' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 0' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

 
  ############################ CREATE
  ############################## GigaBitEthernet
 
  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$COUNT',PlugInUnit=1,ExchangeTerminalIp=1"' >> $MOSCRIPT
  echo ' identity 1' >> $MOSCRIPT
  echo ' moType GigaBitEthernet' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 0' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT


  ############################ CREATE
  ############################## IpInterface

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$COUNT',PlugInUnit=1,ExchangeTerminalIp=1,GigaBitEthernet=1"' >> $MOSCRIPT
  echo ' identity 1' >> $MOSCRIPT
  echo ' moType IpInterface' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 0' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT


  ############################ SET
  ############################## IpInterface


  IPINTERFACE_vid=0
  IPINTERFACE_vLan="False"
  IPINTERFACE_networkPrefixLength=25

  #IPINTERFACE_defaultRouter0=1
  #IPINTERFACE_defaultRouter1=1
  #IPINTERFACE_ownIpAddressActive=25
  #IPINTERFACE_subnet=100

  echo "RNC_COLUMN="$RNC_COLUMN

  IPINTERFACE_defaultRouter0=`echo $LINE | awk -F $SEP01 '{print $'\$RNC_COLUMN'}' | awk -F "&" '{print $1}' | awk -F"=" '{print $2}'`
  echo "IPINTERFACE_defaultRouter0="$IPINTERFACE_defaultRouter0

  IPINTERFACE_defaultRouter1=`echo $LINE | awk -F $SEP01 '{print $'\$RNC_COLUMN'}' | awk -F "&" '{print $2}' | awk -F"=" '{print $2}'`
  echo "IPINTERFACE_defaultRouter1="$IPINTERFACE_defaultRouter1

  IPINTERFACE_ownIpAddressActive=`echo $LINE | awk -F $SEP01 '{print $'\$RNC_COLUMN'}' | awk -F "&" '{print $3}' | awk -F"=" '{print $2}'`
  echo "IPINTERFACE_ownIpAddressActive="$IPINTERFACE_ownIpAddressActive

  IPINTERFACE_subnet=`echo $LINE | awk -F $SEP01 '{print $'\$RNC_COLUMN'}' | awk -F "&" '{print $4}' | awk -F"=" '{print $2}'`
  echo "IPINTERFACE_subnet="$IPINTERFACE_subnet

  IPINTERFACE_vlanRef="ManagedElement=1,EthernetSwitchFabric=1,Vlan=1"

  echo 'SET' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  mo "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$COUNT',PlugInUnit=1,ExchangeTerminalIp=1,GigaBitEthernet=1,IpInterface=1"' >> $MOSCRIPT
  echo ' nrOfAttributes 5' >> $MOSCRIPT
  echo '  vid Integer '$IPINTERFACE_vid'' >> $MOSCRIPT
  echo '  networkPrefixLength Integer '$IPINTERFACE_networkPrefixLength'' >> $MOSCRIPT
  echo '  vLan Boolean '$IPINTERFACE_vLan'' >> $MOSCRIPT
  echo '  vlanRef Ref '$IPINTERFACE_vlanRef'' >> $MOSCRIPT
  echo '   defaultRouter0 String '$IPINTERFACE_defaultRouter0'' >> $MOSCRIPT
  echo '   defaultRouter1 String '$IPINTERFACE_defaultRouter1'' >> $MOSCRIPT
  echo '   ownIpAddressActive String '$IPINTERFACE_ownIpAddressActive'' >> $MOSCRIPT
  echo '   subnet String '$IPINTERFACE_subnet'' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT



  ############################ SET
  ############################## IpAccessHostEt

  IPACCESSHOSTET_ipAddress=$IPINTERFACE_ownIpAddressActive
  echo "IPACCESSHOSTET_ipAddress="$IPACCESSHOSTET_ipAddress

  echo 'SET' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  mo "ManagedElement=1,IpSystem=1,IpAccessHostEt='$IPACCESSHOSTCOUNT'"' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 1' >> $MOSCRIPT
  echo ' ipInterfaceMoRef Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$COUNT',PlugInUnit=1,ExchangeTerminalIp=1,GigaBitEthernet=1,IpInterface=1"' >> $MOSCRIPT
  echo '   ipAddress String '$IPACCESSHOSTET_ipAddress'' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT


  echo ""
  IPACCESSHOSTCOUNT=`expr $IPACCESSHOSTCOUNT + 1`
  RNC_COLUMN=`expr $RNC_COLUMN + 1`
  COUNT=`expr $COUNT + 1`
done


COUNT=5
STOP=6
while [ "$COUNT" -le "$STOP" ]
do

  ############################ CREATE
  ############################## EthernetSwitchModule

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$COUNT',PlugInUnit=1"' >> $MOSCRIPT
  echo ' identity 1' >> $MOSCRIPT
  echo ' moType EthernetSwitchModule' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 0' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT


  COUNTX=1
  STOPX=7
  while [ "$COUNTX" -le "$STOPX" ]
  do

    ############################ CREATE
    ############################## EthernetSwitchModulePort

    echo 'CREATE' >> $MOSCRIPT
    echo '(' >> $MOSCRIPT
    echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$COUNT',PlugInUnit=1,EthernetSwitchModule=1"' >> $MOSCRIPT
    echo ' identity '$COUNTX >> $MOSCRIPT
    echo ' moType EthernetSwitchModulePort' >> $MOSCRIPT
    echo ' exception none' >> $MOSCRIPT
    echo ' nrOfAttributes 0' >> $MOSCRIPT
    echo ')' >> $MOSCRIPT

    ############################ SET
    ############################## EthernetSwitchModulePort

    echo 'SET' >> $MOSCRIPT
    echo '(' >> $MOSCRIPT
    echo '  mo "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$COUNT',PlugInUnit=1,EthernetSwitchModule=1,EthernetSwitchModulePort='$COUNTX'"' >> $MOSCRIPT
    echo ' nrOfAttributes 1' >> $MOSCRIPT
    echo '   vlanRef Array Ref 1 ' >> $MOSCRIPT
    echo '     ManagedElement=1,EthernetSwitchFabric=1,Vlan=1' >> $MOSCRIPT
    echo ')' >> $MOSCRIPT


    COUNTX=`expr $COUNTX + 1`
  done

  COUNT=`expr $COUNT + 1`
done


COUNT=1
STOP=$NUMOFRBS

while [ "$COUNT" -le "$STOP" ]
do
  ############################ SET
  ############################## IubLink

  SCTPCOUNT=`getGroup $COUNT $MAXRBSPERSCTP`

  echo 'SET' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo 'mo "ManagedElement=1,RncFunction=1,IubLink='$COUNT'"' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 2' >> $MOSCRIPT
  echo '  sctpRef Ref "ManagedElement=1,TransportNetwork=1,Sctp='$SCTPCOUNT'"' >> $MOSCRIPT
  echo '  userPlaneIpResourceRef Ref "ManagedElement=1,IpSystem=1,IpAccessHostPool=Iub"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  COUNT=`expr $COUNT + 1`
done


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
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT


/netsim/inst/netsim_shell < $MMLSCRIPT

rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT


echo "... script ended at "`date`
echo ""


