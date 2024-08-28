#!/bin/sh

#!/bin/sh

# Created by  : unknown
# Created in  : unknown
##
### VERSION HISTORY
# Ver1        : Moddified for TERE 13B EU
# Purpose     : 
# Description : Create IubLink And UtranCells
# Date        : 06 03 2013
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
RNCRBSARRAY="1,53,69;"\
"2,41,66;"\
"3,9,144;"\
"4,1,436;"\
"5,2,344;"\
"6,2,826;"\
"7,1,1186;"

#
#### RBS CELL Distribution
# TYPE1[ TOTALNUMOFCELLS,NUMOFRBS-CELLNUM,NUMOFRBS-CELLNUM,...] ; TYPE2[..] ; TYPE3[..] ; TYPE4[..]
#
RBSCELLARRAY="300,9-1,30-3,25-6,3-9,2-12;"\
"251,5-1,40-3,21-6,0-9,0-12;"\
"723,3-1,74-3,45-6,12-9,10-12;"\
"1450,6-1,54-3,65-6,30-9,31-12,250-1;"\
"2305,10-1,110-3,80-6,81-9,63-12;"\
"3021,16-1,60-3,70-6,85-9,95-12,500-1;"\
"5301,18-1,15-3,13-6,90-9,300-12,750-1;"


#### IRATHOM ATTRIBUTES FOR WRAN TO WRAN
MCC=46
MNC=6
EXTMNC=7
MNCLENGTH=2

SHARE1=95
SHARE2=111


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
    echo $NUMOFRBS
    break
  fi
done;
}

#
# get num of cell per each RBS
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

#
# get num of cell per each RBS
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


########################
#IUBLINK CREATION START
########################


NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

IUBEND=$NUMOFRBS
IUBCOUNT=1

  OPERATIONALSTATE=1     # 0-DISABLED, 1-ENABLED
  ADMINISTRATIVESTATE=1  # 0-LOCKED, 1-UNLOCKED

if [ "$RNCCOUNT" -ge 4 ] && [ "$RNCCOUNT" -le 48 ]
then
  ATM=1
  IP=0
else
  ATM=0
  IP=1
fi

if [ "$RNCCOUNT" -ge 102 ]
then
  ATM=1
  IP=1
fi

if [ "$RNCCOUNT" -ge 107 ] && [ "$RNCCOUNT" -le 108 ]
then
  ATM=0
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

########################
#IUBLINK CREATION END
########################

#########################################
# Create MbmsServiceArea START (1062createMbmsSA.sh)
#########################################

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '    parent "ManagedElement=1,RncFunction=1"' >> $MOSCRIPT
echo '   identity "1"' >> $MOSCRIPT
echo '    moType Mbms' >> $MOSCRIPT
echo '    exception none' >> $MOSCRIPT
echo '    nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

COUNT=1
while [ "$COUNT" -le "$NUMOFRBS" ]
do

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '    parent "ManagedElement=1,RncFunction=1,Mbms=1"' >> $MOSCRIPT
  echo '   identity "'$COUNT'"' >> $MOSCRIPT
  echo '    moType MbmsServiceArea' >> $MOSCRIPT
  echo '    exception none' >> $MOSCRIPT
  echo '    nrOfAttributes 1' >> $MOSCRIPT
  echo '    sac Integer '$COUNT >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  COUNT=`expr $COUNT + 1`
done
#########################################
# Create MbmsServiceArea END (1062createMbmsSA.sh)
#########################################



##########################
# UTRANCELL CREATION START
##########################
echo "//" >> $MOSCRIPT
echo "//$0:$RNCNAME MAKING MO SCRIPT started at "`date` >> $MOSCRIPT
echo "//" >> $MOSCRIPT

echo "//" 
echo "//$0:$RNCNAME MAKING MO SCRIPT started at "`date` 
echo "//" 


######################
# STAT EutraNetwork (tmp1500createExtEutranFreqRelation.sh)
######################

#echo ":: ManagedElement=1,RncFunction=1,EutraNetwork=1"

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,RncFunction=1"' >> $MOSCRIPT
echo ' identity 1'>> $MOSCRIPT
echo ' moType EutraNetwork' >> $MOSCRIPT
echo ' exception none' >> $MOSCRIPT
echo ')' >> $MOSCRIPT
echo""

######################
# END EutraNetwork (tmp1500createExtEutranFreqRelation.sh)
######################
######################
# START EutranFrequency (tmp1500createExtEutranFreqRelation.sh)
######################

NUMOF_EUTRANFREQ=8
START_EUTRANFREQ=1
STOP_EUTRANFREQ=$NUMOF_EUTRANFREQ

COUNT=$START_EUTRANFREQ
while [ "$COUNT" -le "$STOP_EUTRANFREQ" ]
do

  #echo ":: ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency="$COUNT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,RncFunction=1,EutraNetwork=1' >> $MOSCRIPT
  echo "    identity "$COUNT >> $MOSCRIPT
  echo '    moType EutranFrequency' >> $MOSCRIPT
  echo '    exception none' >> $MOSCRIPT
  echo "    earfcnDl Integer "$COUNT >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  COUNT=`expr $COUNT + 1`
done
#echo""
######################
# END EutranFrequency
######################


COUNT=1
RBSCOUNT=1
CELLCOUNT=1

#########################################
# Total num of cells per RNC
#########################################
TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
#echo "TOTALCELLS="$TOTALCELLS

#exit

# Num of cell has sharing same LA/RA
# values comes from env file
#SHARE1 
#SHARE2

START_CUMTOTALCELLS=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`

CID=$START_CUMTOTALCELLS

LASTART=`getLAStart $RNCCOUNT $SHARE1 $RNCRBSARRAY $RBSCELLARRAY`
LA=$LASTART

#### RNC109 is a special case: Max num of LAs exceeds for SHARE=56
#
if [ $RNCCOUNT -eq 109 ] 
then
  SHARE1=$SHARE2
fi

TCELLCOUNT=1

while [ "$COUNT" -le "$TOTALCELLS" ]
do

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

  ADMINISTRATIVESTATE=1 # 0-LOCKED, 1-UNLOCKED, 2-SHUTTING_DOWN
  OPERATIONALSTATE=1  # 0-DISABLED, 1-ENABLED
  

  #### tCell attribute max value is 9
  if [ "$TCELLCOUNT" -gt 9 ]
  then
    TCELLCOUNT=1
  fi

  #echo "UTRANCELLID="$UTRANCELLID

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,RncFunction=1"' >> $MOSCRIPT
  echo ' identity '$UTRANCELLID >> $MOSCRIPT
  echo ' moType UtranCell' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 17' >> $MOSCRIPT
  echo ' accessClassNBarred Array Integer 16' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo ' accessClassesBarredCs Array Integer 16' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo ' accessClassesBarredPs Array Integer 16' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo '   0' >> $MOSCRIPT
  echo '   1' >> $MOSCRIPT
  echo ' iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink='$RBSCOUNT >> $MOSCRIPT
  echo ' cId Integer '$CID >> $MOSCRIPT
  echo ' userLabel String '$UTRANCELLID >> $MOSCRIPT
  echo ' locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea='$LA >> $MOSCRIPT
  echo ' routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea='$LA',RoutingArea='$RA >> $MOSCRIPT
  echo ' serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea='$LA',ServiceArea='$SA >> $MOSCRIPT
  echo ' tCell Integer '$TCELLCOUNT >> $MOSCRIPT
  echo ' uarfcnDl Integer '$UARFCNDL >> $MOSCRIPT
  echo ' uarfcnUl Integer '$UARFCNUL >> $MOSCRIPT
  echo ' primaryScramblingCode Integer '$PRIMSCRCODE >> $MOSCRIPT
  echo ' primaryCpichPower Integer '$PRIMARYCPICHPOWER>> $MOSCRIPT
  echo ' qQualMin Integer '$QQUALMIN >> $MOSCRIPT
  echo ' qRxLevMin Integer '$QRXLEVMIN >> $MOSCRIPT
  echo ' maxTxPowerUl Integer '$MAXTXPOWERUL >> $MOSCRIPT
  echo ' maximumTransmissionPower Integer '$MAXIMUMTRANSMISSIONPOWER>> $MOSCRIPT
  echo ' localCellId Integer '$CID >> $MOSCRIPT
  echo ' usedFreqThresh2dRscp Integer '$USEDFREQTHRESH2DRSCP >> $MOSCRIPT
  echo ' usedFreqThresh2dEcno Integer '$USEDFREQTHRESH2DECNO>> $MOSCRIPT
  echo ' sRatSearch Integer '$SRATSEARCH >> $MOSCRIPT
  echo '   operationalState Integer '$OPERATIONALSTATE >> $MOSCRIPT
  echo '   administrativeState Integer '$ADMINISTRATIVESTATE >> $MOSCRIPT

  echo ')' >> $MOSCRIPT

 
  #echo "COUNT="$COUNT" : RA="${RA}" LA="${LA}" uarfcnDl="$UARFCNDL 
  #echo "  :: COUNT="$COUNT" : cId="$CID" : RA="${RA}" LA="${LA}" : SA="${SA}" : uarfcnDl="$UARFCNDL
  #echo "  :: COUNT="$COUNT"; cId="$CID"; UtranCellId="$UTRANCELLID"; userLabel="$UTRANCELLID"; uarfcnDl="$UARFCNDL"; uarfcnUl="12
  #echo "    :: primaryScramblingCode="$PRIMSCRCODE"; primaryCpichPower="$PRIMARYCPICHPOWER"; qQualMin="$QQUALMIN"; qRxLevMin="$QRXLEVMIN

  #echo " :: UTRANCELLID="$UTRANCELLID" CID="$CID" USERLABEL="$UTRANCELLID" UARFCNDL="$UARFCNDL" UARFCNUL="$UARFCNUL
  #echo -n "    PRIMSCRCODE="$PRIMSCRCODE" PRIMARYCPICHPOWER="$PRIMARYCPICHPOWER" QQUALMIN="$QQUALMIN" LAC="$LA" QRXLEVMIN="$QRXLEVMIN" RAC="$RA
  #echo    " MAXTXPOWERUL="$MAXTXPOWERUL
  #echo ""


   if [ $(($COUNT % $SHARE1)) -eq 0 ]; then
      LA=`expr $LA + 1`
   fi


  EXECUTE_BELOW=YES
  if [ "$EXECUTE_BELOW" == "YES" ]
  then
  #########################################
  # Create Fach,Rach... START (tmpaOut1060createChannels.sh)
  #########################################

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '    parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID'"' >> $MOSCRIPT
  echo '   identity "1"' >> $MOSCRIPT
  echo '    moType Fach' >> $MOSCRIPT
  echo '    exception none' >> $MOSCRIPT
  echo '    nrOfAttributes 10' >> $MOSCRIPT
  echo '    "FachId" String "1"' >> $MOSCRIPT
  echo '    "administrativeState" Integer 1' >> $MOSCRIPT
  echo '    "availabilityStatus" Integer 0' >> $MOSCRIPT
  echo '    "maxFach1Power" Integer 18' >> $MOSCRIPT
  echo '    "maxFach2Power" Integer 15' >> $MOSCRIPT
  echo '   operationalState Integer '$OPERATIONALSTATE >> $MOSCRIPT
  echo '    "pOffset1Fach" Integer 0' >> $MOSCRIPT
  echo '    "pOffset3Fach" Integer 0' >> $MOSCRIPT
  echo '    "sccpchOffset" Integer 0' >> $MOSCRIPT
  echo '    "userLabel" String "Fach-'$RBSCOUNT'-'$CELLCOUNT'"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '    parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID'"' >> $MOSCRIPT
  echo '    identity "1"' >> $MOSCRIPT
  echo '    moType Rach' >> $MOSCRIPT
  echo '    exception none' >> $MOSCRIPT
  echo '    nrOfAttributes 19' >> $MOSCRIPT
  echo '    "RachId" String "1"' >> $MOSCRIPT
  echo '    "administrativeState" Integer 1' >> $MOSCRIPT
  echo '    "aichPower" Integer -6' >> $MOSCRIPT
  echo '    "aichTransmissionTiming" Integer 4' >> $MOSCRIPT
  echo '    "availabilityStatus" Integer 0' >> $MOSCRIPT
  echo '    "constantValueCprach" Integer -27' >> $MOSCRIPT
  echo '    "maxPreambleCycle" Integer 4' >> $MOSCRIPT
  echo '   operationalState Integer '$OPERATIONALSTATE >> $MOSCRIPT
  echo '    "pmFaultyTransportBlocks" Integer 0' >> $MOSCRIPT
  echo '    "pmNoRecRandomAccSuccess" Integer 0' >> $MOSCRIPT
  echo '    "pmTransportBlocks" Integer 0' >> $MOSCRIPT
  echo '    "powerOffsetP0" Integer 3' >> $MOSCRIPT
  echo '    "powerOffsetPpm" Integer -4' >> $MOSCRIPT
  echo '    "preambleRetransMax" Integer 5' >> $MOSCRIPT
  echo '    "preambleSignatures" Integer 65535' >> $MOSCRIPT
  echo '    "scramblingCodeWordNo" Integer 0' >> $MOSCRIPT
  echo '    "spreadingFactor" Integer 64' >> $MOSCRIPT
  echo '    "subChannelNo" Integer 4095' >> $MOSCRIPT
  echo '    "userLabel" String "Rach-'$RBSCOUNT'-'$CELLCOUNT'"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '    parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID'"' >> $MOSCRIPT
  echo '    identity "1"' >> $MOSCRIPT
  echo '    moType Pch' >> $MOSCRIPT
  echo '    exception none' >> $MOSCRIPT
  echo '    nrOfAttributes 8' >> $MOSCRIPT
  echo '    "PchId" String "1"' >> $MOSCRIPT
  echo '    "administrativeState" Integer 1' >> $MOSCRIPT
  echo '    "availabilityStatus" Integer 0' >> $MOSCRIPT
  echo '   operationalState Integer '$OPERATIONALSTATE >> $MOSCRIPT
  echo '    "pchPower" Integer -4' >> $MOSCRIPT
  echo '    "pichPower" Integer -7' >> $MOSCRIPT
  echo '    "sccpchOffset" Integer 20' >> $MOSCRIPT
  echo '    "userLabel" String "Pch-'$RBSCOUNT'-'$CELLCOUNT'"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '    parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID'"' >> $MOSCRIPT
  echo '    identity "1"' >> $MOSCRIPT
  echo '    moType Hsdsch' >> $MOSCRIPT
  echo '    exception none' >> $MOSCRIPT
  echo '    nrOfAttributes 20' >> $MOSCRIPT
  echo '    "HsdschId" String "1"' >> $MOSCRIPT
  echo '    "administrativeState" Integer 0' >> $MOSCRIPT
  echo '    "availabilityStatus" Integer 0' >> $MOSCRIPT
  echo '    "codeThresholdPdu656" Integer 6' >> $MOSCRIPT
  echo '    "cqiFeedbackCycle" Integer 8' >> $MOSCRIPT
  echo '    "deltaAck1" Integer 4' >> $MOSCRIPT
  echo '    "deltaAck2" Integer 8' >> $MOSCRIPT
  echo '    "deltaCqi1" Integer 4' >> $MOSCRIPT
  echo '    "deltaCqi2" Integer 8' >> $MOSCRIPT
  echo '    "deltaNack1" Integer 4' >> $MOSCRIPT
  echo '    "deltaNack2" Integer 8' >> $MOSCRIPT
  echo '    "hsMeasurementPowerOffset" Integer 0' >> $MOSCRIPT
  echo '    "initialAckNackRepetitionFactor" Integer 1' >> $MOSCRIPT
  echo '    "initialCqiRepetitionFactor" Integer 1' >> $MOSCRIPT
  echo '    "numHsPdschCodes" Integer 5' >> $MOSCRIPT
  echo '    "numHsScchCodes" Integer 1' >> $MOSCRIPT
  echo '   operationalState Integer '$OPERATIONALSTATE >> $MOSCRIPT
  echo '    "pmHsDowntimeAuto" Integer 0' >> $MOSCRIPT
  echo '    "pmHsDowntimeMan" Integer 0' >> $MOSCRIPT
  echo '    "userLabel" String "Hsdsch-'$RBSCOUNT'-'$CELLCOUNT'"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '    parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID',Hsdsch=1"' >> $MOSCRIPT
  echo '    identity "1"' >> $MOSCRIPT
  echo '    moType Eul' >> $MOSCRIPT
  echo '    exception none' >> $MOSCRIPT
  echo '    nrOfAttributes 1' >> $MOSCRIPT
  echo '    userLabel String "Eul-'$RBSCOUNT'-'$CELLCOUNT'"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  #########################################
  # Create Fach,Rach... END (tmpaOut1060createChannels.sh)
  #########################################

  #########################################
  # Create MbmsCch START (tmp1065createMBMS.sh)
  #########################################

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '    parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID'"' >> $MOSCRIPT
  echo '   identity '$UTRANCELLID >> $MOSCRIPT
  echo '    moType MbmsCch' >> $MOSCRIPT
  echo '    exception none' >> $MOSCRIPT
  echo '    nrOfAttributes 1' >> $MOSCRIPT
  echo '    nonPlMbmsSaRef Array Ref 1' >> $MOSCRIPT
  echo '        "ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea='$RBSCOUNT'"' >> $MOSCRIPT
  #echo '    nonPlMbmsSaRef Array Ref 1' >> $MOSCRIPT
  #echo '        null' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT
  #########################################
  # Create MbmsCch END (tmp1065createMBMS.sh)
  #########################################


  fi

  CID=`expr $CID + 1`

  CELLCOUNT=`expr $CELLCOUNT + 1`
  TCELLCOUNT=`expr $TCELLCOUNT + 1`
  COUNT=`expr $COUNT + 1`
done


echo "//"
echo "//$0:$RNCNAME MAKING MO SCRIPT ended at "`date`

echo "//" >> $MOSCRIPT
echo "//$0:$RNCNAME MAKING MO SCRIPT ended at "`date` >> $MOSCRIPT

##########################
# UTRANCELL CREATION END
##########################

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
#echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",skip_verify=skip;' >> $MMLSCRIPT

 /netsim/inst/netsim_pipe < $MMLSCRIPT

#rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT

echo "...$0:$RNCNAME script ended at "`date`
echo ""
