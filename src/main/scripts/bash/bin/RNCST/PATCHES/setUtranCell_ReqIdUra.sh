#!/bin/sh

# Created by  : Fatih ONUR
# Created in  : 25.06.2011
##
### VERSION HISTORY
##############################################
# Ver1        : Created by for reqId:7565
# Purpose     :
# Description : RAC is set to range 1-255
# Date        : 26.06.2011
# Who         : Fatih ONUR
##############################################

if [ "$#" -ne 1  ]
then
cat<<HELP

Usage: $0 <rnc num>

Example: $0 9

HELP
 exit 1
fi

################################
# ENV VARIABLES
################################
# RNC Distribution
# [ TYPE=1, NUMOFRC=52, NUMOFRBS=75] ; [..] ; [..] ; [..]
RNCRBSARRAY="1,52,75;2,25,65;3,5,130;4,1,260;3,5,130"

# RBS CELL Distribution
# TYPE1[ TOTALNUMOFCELLS,NUMOFRBS-CELLNUM,NUMOFRBS-CELLNUM,...] ; TYPE2[..] ; TYPE3[..] ; TYPE4[..]
RBSCELLARRAY="365,8-1,27-3,32-6,4-9,4-12;245,5-1,40-3,20-6,0-9,0-12;725,5-1,55-3,40-6,15-9,15-12;1450,10-1,110-3,80-6,30-9,30-12"

################################
# FUNCTIONS
################################o

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

cell_name() # rncnumber rbsnumber cellnumber
{
    case  "$CELLNAME" in
        gsm)
           echo "`zero $1 2``zero $2 3`_$3"
           ;;

        *)
           echo "`rnc_name $1`-$2-$3"
           ;;
    esac
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


#
# get total num of cell per each RBS
#
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


################################
# MAIN
################################

echo "...script started running at "`date`
echo ""

SIMNAME=$1

if [ "$1" -le 9 ]
then
  RNCNAME="RNC0"$1
  RNCCOUNT="0"$1
else
  RNCNAME="RNC"$1
  RNCCOUNT=$1
fi

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

# to get rid of extra prefix when we run the command on remote server
if [ ! -f $PWD/$0 ]
  then
  PWD=""
fi


NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
SIMNAME=`ls /netsim/netsimdir | egrep ${RNCNAME} | grep ST | grep -m1 -v zip`
#SUCCESS=$?
#echo "SUCCESS="$SUCCESS

if [ $SUCCESS -eq 1 ]
then
  echo "no simulation found!"
  echo "exiting..."
  echo ""
  exit
fi

echo "SIMNAME="$SIMNAME

MOSCRIPT=$0${NOW}".mo"
MMLSCRIPT=$0${NOW}".mml"

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


######################
# PATCH INFO
######################

REQID="Ura"

cat >> $MOSCRIPT << MOSCT

SET
(
  mo "ManagedElement=1"
   exception none
   nrOfAttributes 1
     userLabel String "Following patches applied to sim= reqId:$REQID"
)

MOSCT

#########################################
# 
# Make MO Script
#
#########################################

echo ""
echo "MAKING MO SCRIPT"
echo ""


COUNT=1
RBSCOUNT=1
CELLCOUNT=1

#########################################
#
# Total num of cells per RNC
#########################################
TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

# Num of cell has sharing same LA/RA
SHARE=56

START_CUMTOTALCELLS=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`

CID=$START_CUMTOTALCELLS

LA=`getGroup $START_CUMTOTALCELLS $SHARE`

while [ "$COUNT" -le "$TOTALCELLS" ]
do

  ########################
  # LA, RA, SA
  ########################
  #LA=`getGroup $(getCumulativeTotalCells $RNCCOUNT $COUNT $RNCRBSARRAY $RBSCELLARRAY) $SHARE` # deprecated due to bad performance

  #RA=$LA # to empty
  MOD=`expr $LA % 255`
  if [ $MOD -eq 0 ]
  then
    RA=255
  else
    RA=`expr $LA % 255`
  fi

  SA=$CID

  NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCRBSARRAY $RBSCELLARRAY`
  CELLSTOP=`expr $NUMOFCELL + 1`

  if [ "$CELLCOUNT" -eq "$CELLSTOP" ]
  then
    CELLCOUNT=1
    RBSCOUNT=`expr $RBSCOUNT + 1`
  fi

  UTRANCELLID=`cell_name $RNCCOUNT $RBSCOUNT $CELLCOUNT`

  # Utrancell attribute set
  #URAREF="ManagedElement=1,RncFunction=1,Ura="$URAID
  UARFCNDL=`expr \( \( $RNCCOUNT \* 1 \) + 0 \) % 16384`
  #echo "TARGETRNCCOUNT="$RNCCOUNT" NUMOFRBS="$NUMOFRBS" RBSCOUNT="$RBSCOUNT

  UARFCNUL=12
  PRIMSCRCODE=`expr $COUNT % 512`
  PRIMARYCPICHPOWER=300
  QRXLEVMIN=-115
  QQUALMIN=-24
  MAXIMUMTRANSMISSIONPOWER=398
  MAXTXPOWERUL=30

  USEDFREQTHRESH2DRSCP=-100
  USEDFREQTHRESH2DECNO=-12
  SRATSEARCH=4

  ADMINSTATE=1 # 0-LOCKED, 1-UNLOCKED, 2-SHUTTING_DOWN

  #RAREF=null
  #RAREF="ManagedElement=1,RncFunction=1,LocationArea=$LA,RoutingArea=$RA"
  URAREF="ManagedElement=1,RncFunction=1,Ura=$LA"
  echo "URAREF="$URAREF

  #echo "UTRANCELLID="$UTRANCELLID

  #if [ $RA -ge 256 ]
  #then
    #echo "setting UtranCell=$UTRANCELLID to set RA to empty"
    echo "setting UtranCell=$UTRANCELLID to set URA=$LA"
    
    echo 'SET' >> $MOSCRIPT
    echo '(' >> $MOSCRIPT
    echo "  mo "ManagedElement=1,RncFunction=1,UtranCell=$UTRANCELLID"" >> $MOSCRIPT
    #echo " routingAreaRef Ref $LA" >> $MOSCRIPT
    echo " uraRef Array Ref 1" >> $MOSCRIPT
    echo "     $URAREF" >> $MOSCRIPT
    echo ')' >> $MOSCRIPT

  #fi

 
 # echo "COUNT="$COUNT" : RA="${RA}" LA="${LA}" uarfcnDl="$UARFCNDL 
 # echo "  :: COUNT="$COUNT" : cId="$CID" : RA="${RA}" LA="${LA}" : SA="${SA}" : uarfcnDl="$UARFCNDL
 # echo "  :: COUNT="$COUNT"; cId="$CID"; UtranCellId="$UTRANCELLID"; userLabel="$UTRANCELLID"; uarfcnDl="$UARFCNDL"; uarfcnUl="12
 # echo "    :: primaryScramblingCode="$PRIMSCRCODE"; primaryCpichPower="$PRIMARYCPICHPOWER"; qQualMin="$QQUALMIN"; qRxLevMin="$QRXLEVMIN

 # echo " :: UTRANCELLID="$UTRANCELLID" CID="$CID" USERLABEL="$UTRANCELLID" UARFCNDL="$UARFCNDL" UARFCNUL="$UARFCNUL
 # echo -n "    PRIMSCRCODE="$PRIMSCRCODE" PRIMARYCPICHPOWER="$PRIMARYCPICHPOWER" QQUALMIN="$QQUALMIN" LAC="$LA" QRXLEVMIN="$QRXLEVMIN" RAC="$RA
 # echo    " MAXTXPOWERUL="$MAXTXPOWERUL
 # echo ""


   if [ $(($CID % $SHARE)) -eq 0 ]; then
      LA=`expr $LA + 1`
   fi

  CID=`expr $CID + 1`

  # For testing. To quit at required amount
  #if [ "$COUNT" -eq 3 ]
  #then
  #  break
  #  exit 1
  #fi

  CELLCOUNT=`expr $CELLCOUNT + 1`
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
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",commit_freq=operation;' >> $MMLSCRIPT

/netsim/inst/netsim_shell < $MMLSCRIPT

rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT

echo "...script ended at "`date`
echo ""
