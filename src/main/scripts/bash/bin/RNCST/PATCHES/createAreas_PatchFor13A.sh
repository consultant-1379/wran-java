#!/bin/sh

# Created by  : unknown
# Created in  : unknown
##
### VERSION HISTORY
# Ver1        : Moddified for TERE 13A
# Purpose     : 
# Description : LA and SA share increased to 80
# Date        : 07 09 2012
# Who         : Reshma
##############################################

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
# Add leading zeros
zero() { # number, length
    # Need to remove leading 0, might cause the value to be
    # interpreted as octal
    case "$1" in
        0)
            N="$1"
            ;;
        0*)
            N=`echo "$1"| cut -c2-`
            ;;
        *)
            N="$1"
            ;;
    esac
    case "$2" in
        2)
         printf "%.2d" "$N"
         ;;
        3)
         printf "%.3d" "$N"
         ;;
        *)
         printf "%d" "$N"
         ;;
    esac
}

rbs_name() # rncnumber rbsnumber
{
    echo "`rnc_name $1`RBS`zero $2 2`"
}
rxi_name() # rncnumber rxinumber
{
    echo "`rnc_name $1`RXI`zero $2 2`"
}
rnc_name() # rncnumber
{
    echo "RNC`zero $1 2`"
}

#
## get total numb of cells for defined num of RBS
#
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

#
## get total cumulative num of cells up to specified cell count and rnc
#
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
# calculates LASTART
#   eg. 
#
getLAStart() # RNCCOUNT SHARE RNCRBSARRAY RBSCELLARRAY
{        
RNCCOUNT=$1  
SHARE=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

NUMOFLAS=0
TOTALNUMOFLAS=0

COUNT=1
while [ "$COUNT" -le $RNCCOUNT ]
do
  NUMOFCELLS=`getTotalCells $COUNT $RNCRBSARRAY $RBSCELLARRAY`
  #echo "NUMOFCELLS="$NUMOFCELLS
  NUMOFLAS=`getGroup $NUMOFCELLS $SHARE`
  #echo "NUMOFLAS="$NUMOFLAS
  TOTALNUMOFLAS=`expr $TOTALNUMOFLAS + $NUMOFLAS`
 
  COUNT=`expr $COUNT + 1`
done        

echo $(($TOTALNUMOFLAS + 1 - $NUMOFLAS))

}  

################################
# SETUP and PRECHECKS
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

#########################################
# 
# Make MO Script
#
#########################################

#echo "//"
#echo "//MAKING MO SCRIPT"
#echo "//"

# Num of cell has sharing same LA/RA
SHARE1=80
SHARE2=65


TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
echo "//TOTALCELLS="$TOTALCELLS

START_CUMTOTALCELLS=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`
echo "//START_CUMTOTALCELLS="$START_CUMTOTALCELLS

STOP_CUMTOTALCELLS=`getCumulativeTotalCells $RNCCOUNT $TOTALCELLS $RNCRBSARRAY $RBSCELLARRAY`
echo "//STOP_CUMTOTALCELLS="$STOP_CUMTOTALCELLS
echo "//*************"


LASTART=`getLAStart $RNCCOUNT $SHARE1 $RNCRBSARRAY $RBSCELLARRAY`

#### RNC106 is a special case: Max num of LAs 47
#
if [ $RNCCOUNT -eq 106 ]
then
  SHARE1=$SHARE2
fi


NUMOFLAS=`getGroup $TOTALCELLS $SHARE1`
LASTOP=`expr $LASTART + $NUMOFLAS - 1`


SACOUNT=$START_CUMTOTALCELLS

LACOUNT=$LASTART
while [ "$LACOUNT" -le "$LASTOP" ] 
do
  
  MOD=`expr $LACOUNT % 255`
  if [ $MOD -eq 0 ]
  then
    RAC=255
  else
    RAC=`expr $LACOUNT % 255 + 0`
  fi
  
  LAC=$LACOUNT
  RA=$RAC
  LA=$LACOUNT
  

  echo -n "RA="${LACOUNT}" LA="${LACOUNT}" RAC="${RAC}" LAC="${LAC}" URA="${LAC}" " 

  ######################
  # LocationArea
  ######################

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,RncFunction=1"' >> $MOSCRIPT
  echo ' identity '$LACOUNT >> $MOSCRIPT
  echo ' moType LocationArea' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 2' >> $MOSCRIPT
  echo ' lac Integer '$LAC >> $MOSCRIPT
  echo ' userLabel String LOCATIONAREA'$LACOUNT >> $MOSCRIPT
  echo ')' >> $MOSCRIPT



  ######################
  # URA
  ######################

  URAID=$LACOUNT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,RncFunction=1"' >> $MOSCRIPT
  echo '   identity '$URAID >> $MOSCRIPT
  echo '   moType Ura' >> $MOSCRIPT
  echo '   exception none' >> $MOSCRIPT
  echo '   nrOfAttributes 2' >> $MOSCRIPT
  echo '   uraIdentity Integer '$URAID >> $MOSCRIPT
  echo '   userLabel String "Ura'$URAID'"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT
  

  ######################
  # RoutingArea
  ######################

    echo 'CREATE' >> $MOSCRIPT
    echo '(' >> $MOSCRIPT
    echo '  parent "ManagedElement=1,RncFunction=1,LocationArea='$LACOUNT'"' >> $MOSCRIPT
    echo ' identity '$RAC >> $MOSCRIPT
    echo ' moType RoutingArea' >> $MOSCRIPT
    echo ' exception none' >> $MOSCRIPT
    echo ' nrOfAttributes 2' >> $MOSCRIPT
    echo ' rac Integer '$RAC >> $MOSCRIPT
    echo ' userLabel String ROUTINGAREA'$RAC >> $MOSCRIPT
    echo ')' >> $MOSCRIPT


  ######################
  # ServiceArea
  ######################


  echo -n "//SA="${SACOUNT}
  
  COUNT=1
  STOP=$SHARE1
  while [ "$COUNT" -le "$STOP" ]
  do

    if [ "$SACOUNT" -gt "$STOP_CUMTOTALCELLS" ]
    then
      break
    fi

    #echo  "SA="${SACOUNT}

    echo 'CREATE' >> $MOSCRIPT
    echo '(' >> $MOSCRIPT
    echo '  parent "ManagedElement=1,RncFunction=1,LocationArea='$LACOUNT'"' >> $MOSCRIPT
    echo ' identity '$SACOUNT >> $MOSCRIPT
    echo ' moType ServiceArea' >> $MOSCRIPT
    echo ' exception none' >> $MOSCRIPT
    echo ' nrOfAttributes 2' >> $MOSCRIPT
    echo ' sac Integer '$SACOUNT >> $MOSCRIPT
    echo ' userLabel String SERVICEAREA'$SACOUNT >> $MOSCRIPT
    echo ')' >> $MOSCRIPT
    
    SACOUNT=`expr $SACOUNT + 1`
    COUNT=`expr $COUNT + 1`
  done
  echo "-"$(($SACOUNT - 1))

  LACOUNT=`expr $LACOUNT + 1`
done
 

#cat $PWD/$MOSCRIPT
#rm $PWD/$MOSCRIPT
#exit

#########################################
#
# Make MML Script
#
#########################################

echo "//"
echo "//MAKING MML SCRIPT"
echo "//"


echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$RNCNAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
#echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",commit_freq=operation;' >> $MMLSCRIPT
echo 'kertayle:file="'$MOSCRIPT'",skip_verify=skip;' >> $MMLSCRIPT


 /netsim/inst/netsim_pipe < $MMLSCRIPT


rm $MOSCRIPT
rm $MMLSCRIPT

