#!/bin/sh

# Created by  : unknown
# Created in  : unknown
##
### VERSION HISTORY
# Ver1        : Moddified for WRAN TERE R6.2
##################################################
# Ver2        : Created for updating Combined Cells
# Purpose     :
# Description :
# Date        : 25 04 2013
# Who         : RESHMA
###################################################


if [ "$#" -ne 1  ]
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
RNCRBSARRAY="1,53,69;"\
"2,41,66;"\
"3,9,144;"\
"4,1,186;"\
"5,2,344;"\
"6,2,326;"\
"7,1,436;"

#### RBS CELL Distribution
# TYPE1[ TOTALNUMOFCELLS,NUMOFRBS-CELLNUM,NUMOFRBS-CELLNUM,...] ; TYPE2[..] ; TYPE3[..] ; TYPE4[..]
RBSCELLARRAY="300,9-1,30-3,25-6,3-9,2-12;"\
"251,5-1,40-3,21-6,0-9,0-12;"\
"723,3-1,74-3,45-6,12-9,10-12;"\
"1200,6-1,54-3,65-6,30-9,31-12;"\
"2305,10-1,110-3,80-6,81-9,63-12;"\
"2521,16-1,60-3,70-6,85-9,95-12;"\
"4551,18-1,15-3,13-6,90-9,300-12;"\


#FUNCTIONS
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

getTotalCells() # RNCCOUNT RNCRBSARRAY RBSCELLARRAY 
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
    #echo "NUMOFRNC="$NUMOFRNC
    #echo "TYPE="$TYPE
    #echo "TOTALCELLS="$TOTALCELLS
    echo $TOTALCELLS
    break
  fi
done;
}

getNumOfRBSofCellType() # RNCCOUNT CELLTYPE RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
CELLTYPE=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

case "$CELLTYPE"
in
  1) CELLTYPE=2;; #POSITION in the RBSCELLARRAY
  3) CELLTYPE=3;;
  6) CELLTYPE=4;;
  9) CELLTYPE=5;;
  12) CELLTYPE=6;;
esac


NUMOFRNC=0
IFS=";"
for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    NUMOFRBS_FOR_CELLTYPE=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}' | awk -F"," '{print $'\$CELLTYPE'}' | awk -F"-" '{print $1}'`

    echo $NUMOFRBS_FOR_CELLTYPE
    break
  fi
done;
}

getNumOfCell() # RNCCOUNT RBSCOUNT RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
RBSCOUNT=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

NUMOFRNC=0
IFS=";"

for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    RBSCELLARRAYATR=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}'`
    #echo "RBSCELLARRAYATR="$RBSCELLARRAYATR

    IFS=","
    bar=( $RBSCELLARRAYATR )
    TOTALSUBNUMOFRBS=0
    #echo "bar="${bar[0]}

    for (( i=1; i<${#bar[@]}; i++ )); do
      SUBNUMOFRBS=`echo ${bar[$i]} | awk -F "-" '{print $1}'`
      TOTALSUBNUMOFRBS=`expr $SUBNUMOFRBS + $TOTALSUBNUMOFRBS`

      #echo "["$i"] "${bar[$i]};
      #echo "SUBNUMOFRBS="$SUBNUMOFRBS

      if [ "$RBSCOUNT" -le "$TOTALSUBNUMOFRBS" ]
      then
        NUMOFCELL=`echo ${bar[$i]} | awk -F "-" '{print $2}'`
        #echo "NUMOFCELL="$NUMOFCELL
        break
      fi
    done;
    #echo "TOTALSUBNUMOFRBS="$TOTALSUBNUMOFRBS

    #echo "RNCCOUNT="$RNCCOUNT
    #echo "RBSCOUNT="$RBSCOUNT
    #echo "NUMOFCELL="$NUMOFCELL
    echo $NUMOFCELL
    #echo "TYPE="$TYPE
    break
  fi
done;
}

getCumulativeTotalCells() # RNCCOUNT $COUNT RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
COUNT=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

NUMOFRNC=0
CUM=0
IFS=";"

for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`
  #echo "NUMOFRNC="$NUMOFRNC

  TYPE=$(echo $x | awk -F"," '{print $1}')
  TOTALCELLS=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}' | awk -F"," '{print $1}'`
  NUMOFRBS=`echo $x | awk -F"," '{print $3}'`
  CURRENT_NUMOFRNC=$(echo $x | awk -F"," '{print $2}')
  #echo "CURRENT_NUMOFRNC="$CURRENT_NUMOFRNC

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then

    PRE_NUMOFRNC=`expr $NUMOFRNC - $(echo $x | awk -F"," '{print $2}')`
    DIFF=`expr $RNCCOUNT - $PRE_NUMOFRNC`
    CUM=`expr $CUM + $DIFF \* $TOTALCELLS`
    CUM=`expr $CUM - \( $TOTALCELLS - $COUNT \)`

    #echo "PRE_NUMOFRNC="$PRE_NUMOFRNC
    #echo "DIFF="$DIFF
    #echo "RNCCOUNT="$RNCCOUNT
    #echo "NUMOFRBS="$NUMOFRBS
    #echo "NUMOFRNC="$NUMOFRNC
    #echo "TYPE="$TYPE
    #echo "TOTALCELLS="$TOTALCELLS
    echo $CUM
    break
  else
    CUM=`expr $CUM + $CURRENT_NUMOFRNC \* $TOTALCELLS`
  fi

done;

}



################################
# MAIN
################################
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

SCRIPTNAME=`basename "$0"`
DEL1="DELETE_ALL_MO_SCRIPTS"
DELETE_ALL_MO_SCRIPTS="DELETE_ALL_MO_SCRIPTS_${SIMNAME}_${SCRIPTNAME}"

if [ -f $PWD/$DEL1 ]
then
  rm -r  $PWD/$DEL1
  echo "//..old "$PWD/$DEL1" removed"
fi



#########################################
# 
# Make MO Script
#
#########################################

#echo ""
#echo "MAKING MO SCRIPT"
#echo ""


#    echo "************************************"
#    echo "* RNCCOUNT="$RNCCOUNT
#    echo "************************************"


NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

CIDSTART=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`

CELLID=$CIDSTART


COUNT=1
RBSCOUNT=1
MOFILECOUNT=1

while [ "$COUNT" -le "$NUMOFRBS" ]
do

  if [ "$COUNT" -le 9 ]
   then
    RBSNAME=RBS0
   else
    RBSNAME=RBS
  fi

  CELLCOUNT=1
  NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCRBSARRAY $RBSCELLARRAY`
  CELLSTOP=`expr $NUMOFCELL + 1`

  MOFILEEXTENSION="__"$MOFILECOUNT".mo"

###################################################################################################
#
# Added for Req id :2598 to match the User Plane Transport Option configuration in the RNC and RBS
#
####################################################################################################

  if [ "$RNCCOUNT" -ge 4 ] && [ "$RNCCOUNT" -le 42 ]
  then
    ATM=true
    IP=false
  else
    ATM=false
	IP=true
  fi

  if [ "$RNCCOUNT" -eq 106 ]
  then
    ATM=true
    IP=true
  fi

####################################################################################################


  while [ "$CELLCOUNT" -lt "$CELLSTOP" ]
  do

    #echo " :: RBSCOUNT="$RBSCOUNT" RbsLocalCell="$CELLCOUNT

cat >> $MOSCRIPT$MOFILEEXTENSION << MOSCT
CREATE
(
parent "ManagedElement=1,NodeBFunction=1"
identity $CELLCOUNT
moType RbsLocalCell
exception none
nrOfAttributes 2
localCellId Integer $CELLID
maxDlPowerCapability Integer 400
carrierRef Ref null
)
MOSCT

    CELLCOUNT=`expr $CELLCOUNT + 1`
    CELLID=`expr $CELLID + 1`
  done

cat >> $MOSCRIPT$MOFILEEXTENSION << MOSCT
CREATE
(
parent "ManagedElement=1,NodeBFunction=1"
identity 1
moType Iub
exception none
nrOfAttributes 2
rbsId Integer $COUNT
userPlaneTransportOption Struct
nrOfElements 2
atm Boolean $ATM
ipV4 Boolean $IP
controlPlaneTransportOption Struct
nrOfElements 2
atm Boolean $ATM
ipV4 Boolean $IP

)
MOSCT

  # RBSCOUNT increases after CELLCOUNT reaches to END
  RBSCOUNT=`expr $RBSCOUNT + 1`

  #echo ""
  #echo "MAKING MML SCRIPT"
 if [ $COUNT -gt 62 ]
then
  cat >> $MMLSCRIPT << MMLSCT
  .open $SIMNAME
  .select $RNCNAME$RBSNAME$COUNT
  .start
  kertayle:file="$MOSCRIPT$MOFILEEXTENSION";
fi

MMLSCT

echo "rm $PWD/$MOSCRIPT$MOFILEEXTENSION " >> $DELETE_ALL_MO_SCRIPTS # Script to clean up all the generated MO scripts

  MOFILECOUNT=`expr $MOFILECOUNT + 1`
  COUNT=`expr $COUNT + 1`
done


################################################
 /netsim/inst/netsim_pipe < $MMLSCRIPT

cat $PWD/$MMLSCRIPT
rm $PWD/$MMLSCRIPT
exit

#############################
rm $PWD/$MMLSCRIPT
. $DELETE_ALL_MO_SCRIPTS
rm $DELETE_ALL_MO_SCRIPTS

echo "#//...$0:$SIMNAME script ended running at "`date`
echo "#//"

