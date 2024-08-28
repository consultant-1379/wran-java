#!/bin/sh

# Created by  : unknown
# Created in  : unknown
##
### VERSION HISTORY
##################################################
# Ver1        : Created for WRAN deployment O13A
# Purpose     : Updated to delete LA/SA/RA ref
# Description : 
# Date        : 06 09 2012
# Who         : RESHMA
##################################################


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
"7,1,436;"\


getNumOfRBS() # RNCCOUNT
{

RNCCOUNT=$1

NUMOFRNC=0
IFS=";"
for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    NUMOFRBS=`echo $x | awk -F"," '{print $3}'`

    echo $NUMOFRBS
    break
  fi
done;
}


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

MOSCRIPT=$0:$RNCNAME".mo"
MMLSCRIPT=$0:$RNCNAME".mml"


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

echo "RNCCOUNT:$RNCCOUNT"
echo " "

#########################################
# 
# Make MO Script
#
#########################################

echo "//"
echo "//$0:$RNCNAME MAKING MO SCRIPT started at "`date`
echo "//"




NUMOFRBS=`getNumOfRBS $RNCID` 

RBSEND=$((NUMOFRBS/2)) 

#echo $RBSEND

for (( COUNT=$NUMOFRBS; COUNT>=$((NUMOFRBS-RBSEND)); COUNT-- )); 
do

  if [ "$COUNT" -le 9 ]
   then
    RBSNAME=RBS0
   else
    RBSNAME=RBS
  fi

	echo '.select '$RNCNAME$RBSNAME$COUNT >> $MOSCRIPT
	echo '.start' >> $MOSCRIPT
	echo 'setmoattribute:mo="Subrack", attributes="operationalProductData (struct, OperProductData)=[RBS 6501,,,,]";' >> $MOSCRIPT
	echo '.stop' >> $MOSCRIPT
	echo '.start' >> $MOSCRIPT

done

#
echo "//"
echo "//$0:$RNCNAME MAKING MO SCRIPT ended at "`date`


#cat $PWD/$MOSCRIPT
#rm $PWD/$MOSCRIPT
#exit

#########################################
#
# Make MML Script
#
#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""


echo '.open '$SIMNAME >> $MMLSCRIPT
cat $MOSCRIPT >> $MMLSCRIPT

 /netsim/inst/netsim_pipe < $MMLSCRIPT

rm $MOSCRIPT
rm $MMLSCRIPT

echo "...$0:$RNCNAME script ended at "`date`
echo ""
