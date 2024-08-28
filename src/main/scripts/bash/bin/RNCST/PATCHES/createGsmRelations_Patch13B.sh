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
RNCRBSARRAY="1,53,69;"\
"2,41,66;"\
"3,9,144;"\
"4,1,186;"\
"5,2,344;"\
"6,2,326;"\
"7,1,436;"\

# RBS CELL Distribution
# TYPE1[ TOTALNUMOFCELLS,NUMOFRBS-CELLNUM,NUMOFRBS-CELLNUM,...] ; TYPE2[..] ; TYPE3[..] ; TYPE4[..]
RBSCELLARRAY="300,9-1,30-3,25-6,3-9,2-12;"\
"251,5-1,40-3,21-6,0-9,0-12;"\
"723,3-1,74-3,45-6,12-9,10-12;"\
"1200,6-1,54-3,65-6,30-9,31-12;"\
"2305,10-1,110-3,80-6,81-9,63-12;"\
"2521,16-1,60-3,70-6,85-9,95-12;"\
"4551,18-1,15-3,13-6,90-9,300-12;"\

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

#  IRATHOM VERSION
## Gettig UtranCellId in the format of <RNCNO>-<RBSNO>-<CELLNO>
##  for ExternalUtranCells for better readability of cell
#
getUtranCellIdForOtherWRAN() # CID
{
CID=$1

#
# Num of cells per RBS for each band 
# 
BAND_A=5
DEFAULT=5

# 
## Num of rbs per band
#
NUMOFRBS_TYPE_C_BAND_A=50   # 5 cells per RBS
    
#   
## Total num of cells per type
#   
TOTALCELLS_TYPE_C_BAND_A=`expr \( $NUMOFRBS_TYPE_C_BAND_A \* $BAND_A \)`

TOTALCELLS_TYPE_C=200

RNCCOUNT=`getGroup $CID $TOTALCELLS_TYPE_C`

MOD=`expr $CID % $TOTALCELLS_TYPE_C`
if [ "$MOD" -eq 0 ]; then  MOD=$TOTALCELLS_TYPE_C ; fi

COUNT=$MOD


if [ "$COUNT" -le "$TOTALCELLS_TYPE_C_BAND_A" ]
then
    RBSCOUNT=`getGroup $COUNT $BAND_A`
    CELLCOUNT=`expr $COUNT % $BAND_A`
    if [ "$CELLCOUNT" -eq 0 ]; then  CELLCOUNT=$BAND_A ; fi
fi

UTRANCELLID=`cell_name $RNCCOUNT $RBSCOUNT $CELLCOUNT`

echo $UTRANCELLID
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

#####################################################################################################
# finds the start Target Cell ID which current cell make bi-directional inter relation. Ex. below
#####################################################################################################
#
# CURRENTCID=1 CURRENTRNC=1 TARGETRNC=2
# 1: 1 -> 2 - 1   or   CID= 1 -> iurLink=2 - CID=796
# 2: 1 -> 2 - 2   or   CID= 1 -> iurLink=2 - CID=797
# 3: 1 -> 2 - 3   or   CID= 1 -> iurLink=2 - CID=798
# 4: 1 -> 2 - 4   or   CID= 1 -> iurLink=2 - CID=799
getStartTargetCID() # CID, TEMPEXCESS, NUMOFELMOF_CELLGROUP
{
CID=$1
TEMPEXCESS=$2
NUMOFELMOF_CELLGROUP=$3


TEMP_CID=`expr $CID - $TEMPEXCESS`

MOD=`expr $TEMP_CID % $NUMOFELMOF_CELLGROUP`
DIV=`expr $TEMP_CID / $NUMOFELMOF_CELLGROUP`

if [ "$MOD" -eq 0 ]
then
  CELLGROUP=$DIV
else
  CELLGROUP=`expr $DIV + 1`
fi

TEMP_STARTTARGETCID=`expr $CELLGROUP \* $NUMOFELMOF_CELLGROUP - \( $NUMOFELMOF_CELLGROUP - 1 \)`
PRE_STARTTARGETCID=`expr $TEMP_STARTTARGETCID + $TEMPEXCESS`

echo $PRE_STARTTARGETCID
}

# 
## get RNC type either 1,2,3 or 4
# 
getRncType() # RNCCOUNT RNCRBSARRAY RBSCELLARRAY
{ 
RNCCOUNT=$1
RNCRBSARRAY=$2
RBSCELLARRAY=$3

IFS=";"       
for x in $RNCRBSARRAY 
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then        
    TYPE=$(echo $x | awk -F"," '{print $1}')
    #echo "TYPE="$TYPE
    echo $TYPE
    break
  fi
done;
}



################################
# SETUP and PRECHECKS
################################

RNCID=$1
GSMMCC=46
GSMMNC=4
GSMMNCLENGTH=2
INPUTFILENAME="GSM_Cell_info_50k_SystemTest_013_2_7.csv"

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


# *** Note ***
# Assuming ExternalGsmCell input file exist
if [ ! -f "/tmp/$FILE" ]
then
  echo "File: "/tmp/$FILE" does not exist"
  echo "Check the file and run again"
  exit
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

#########################################
# 
# Make MO Script
#
#########################################

echo "//...$0:$RNCNAME MAKING MO SCRIPT started running at "`date` >> $MOSCRIPT
echo "//" >> $MOSCRIPT


#echo ""
#echo "MAKING MO SCRIPT"
#echo ""

# Total Numof UtranCell for Each RNC
TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

# CellId for Each Cell within Utran Network
CIDSTART=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`
CID=$CIDSTART

######################################################################################################
# START OF EXTGSMCELL RELATIONS FOR IRATHOM
######################################################################################################

if [ "$RNCCOUNT" -le 41 ]
then

# Total Numof ExtGsmCell for Each RNC
TARGET_TOTALCELLS=300

# NumOf UtranCell will have relation against ExtGsmCell
#END_COUNT=`expr $TOTALCELLS - 9`
END_COUNT=`expr $TOTALCELLS - 1`

 # IRATHOM cell range ends at 12039
 if [ "$RNCCOUNT" -eq "41" ] 
 then
    END_COUNT=39
 fi

# NumOf ExtGsmCell Relation per each UtranCell
GSMRELATIONNUM=13

COUNT=1
CELLCOUNT=1
RBSCOUNT=1
VAR=1

while [ "$COUNT" -le "$END_COUNT" ]
do

  NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCRBSARRAY $RBSCELLARRAY` # NUMOFCELL for each RBS
  CELLNUM=$NUMOFCELL
  CELLSTOP=`expr $NUMOFCELL + 1`

  if [ "$CELLCOUNT" -eq "$CELLSTOP" ]
  then
    CELLCOUNT=1
    RBSCOUNT=`expr $RBSCOUNT + 1`
  fi

  CREATE_RELATION=YES

  UTRANCELLID=`cell_name $RNCCOUNT $RBSCOUNT $CELLCOUNT`

  ######################################################
  #
  # (1)  Create GsmRelation to ExternalGsmCells 
  #
  ######################################################

  #echo "##############################################"
  #echo "# GSMRELATION: From UtranCell to ExternalGsmCell"
  #echo "##############################################"
  #echo "COUNT="$COUNT



  if [ "$CREATE_RELATION" == "YES" ]
  then

      ######################################################################
      #
      # Visit each TargetCell according to necessary number of relations for the current Cell
      #  NUMOFELMOF_CELLGROUP defines number of relations for each current cell
      #
      #######################################################################
      NUMOFELMOF_CELLGROUP=$GSMRELATIONNUM
      SWITCH_TO_NEW_EXTGSMCELL_ID_FOR_NEW_SIM=4993

      CELLGROUP=`getGroup $COUNT $NUMOFELMOF_CELLGROUP`

      START_EXTGSMIDCOUNT=`expr $NUMOFELMOF_CELLGROUP \* $CELLGROUP - \( $NUMOFELMOF_CELLGROUP - 1 \) + \( $RNCCOUNT - 1 \) \* $TARGET_TOTALCELLS` 
      STOP_EXTGSMIDCOUNT=`expr $START_EXTGSMIDCOUNT + $NUMOFELMOF_CELLGROUP - 1`
      EXTGSMIDCOUNT=$START_EXTGSMIDCOUNT

      START=1
      STOP=$NUMOFELMOF_CELLGROUP

      TARGETCELLCOUNT=$EXTGSMIDCOUNT


      LOC_COUNT=1
      while [ "$LOC_COUNT" -le "$STOP" ]
      do
         UCELLREF='ManagedElement=1,RncFunction=1,ExternalGsmNetwork='$GSMMNC',ExternalGsmCell='$TARGETCELLCOUNT

         # Output of relation for testing(original)
         ## echo -n "TOT-CELL-"$COUNT" LOC-CELL-"$CELLCOUNT" TOT-RELATION-"$VAR": LOC-RELATION-"$LOC_COUNT": "$UTRANCELLID" UCID="$CID
         ## echo "-> EXTGSMCID:"$TARGETCELLCOUNT" (ExtGsmNetwork="$GSMMNC")"

         #IRATHOM only
         # echo -n "$UTRANCELLID UCID=$CID (wran sim=$RNCCOUNT) has gsm relation($LOC_COUNT) to " 
         # echo "-> EXTGSMCID:"$TARGETCELLCOUNT" (ExtGsmNetwork="$GSMMNC") "

         echo 'CREATE' >> $MOSCRIPT
         echo '(' >> $MOSCRIPT
         echo '  parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID'"' >> $MOSCRIPT
         echo ' identity '$LOC_COUNT >> $MOSCRIPT
         echo ' moType GsmRelation' >> $MOSCRIPT
         echo ' exception none' >> $MOSCRIPT
         echo ' nrOfAttributes 1' >> $MOSCRIPT
         echo ' externalGsmCellRef Ref '$UCELLREF >> $MOSCRIPT
         echo ')' >> $MOSCRIPT

         VAR=`expr $VAR + 1`
	 LOC_COUNT=`expr $LOC_COUNT + 1`
         TARGETCELLCOUNT=`expr $TARGETCELLCOUNT + 1`
      done


  else
    echo "// DO NOT CREATE ANY GSM-RELATION FOR THIS CELL: "$UTRANCELLID
  fi

  CID=`expr $CID + 1`
  CELLCOUNT=`expr $CELLCOUNT + 1`
  COUNT=`expr $COUNT + 1`

  # For testing. To quit ar required amount
  #if [ "$COUNT" -eq 1112 ]
  #then
  #  break
  #    exit 1
  #fi

done

fi
######################################################################################################
# END OF EXTGSMCELL RELATIONS FOR IRATHOM
######################################################################################################

#exit

######################################################################################################
# START OF EXTGSMCELL RELATIONS FOR OTHER NETWORKS GSMNETWOK: 5, 6, 7
######################################################################################################

if [ "$RNCCOUNT" -ge 42 ] && [ "$RNCCOUNT" -le 109 ] 
then


#echo "EXTGSMCELL RELATIONS FOR OTHER NETWORKS GSMNETWOK: 5, 6, 7"
#echo "-"

  GSMMNC=4
 # NUMOF_GSM_REL=27

  if [ "$RNCCOUNT" -ge 42 ] && [ "$RNCCOUNT" -le 53 ]
  then
    EXTGSMCELL_RANGE=1050
    NW_RANGE=`expr $EXTGSMCELL_RANGE / 1`
    PLUS=`expr $EXTGSMCELL_RANGE - 1`
    INITIAL=20000
    DISCARDED_NUM_OF_RNC=41
    NUMOF_GSM_REL=23

    # Start from RNC40 to 94 see more detail in workingOnWRAN.xml
    NUM_OF_RNC_GROUP=12

    BELONGS_TO_GROUP=`getGroup $(( $RNCCOUNT - $DISCARDED_NUM_OF_RNC )) $NUM_OF_RNC_GROUP`
  fi

  if [ "$RNCCOUNT" -ge 54 ] && [ "$RNCCOUNT" -le 71 ]
  then
    EXTGSMCELL_RANGE=2285
    NW_RANGE=`expr $EXTGSMCELL_RANGE / 1`
    PLUS=`expr $EXTGSMCELL_RANGE - 1`
    INITIAL=23000
    DISCARDED_NUM_OF_RNC=53
    NUMOF_GSM_REL=25

    # Start from RNC40 to 94 see more detail in workingOnWRAN.xml
    NUM_OF_RNC_GROUP=18

    BELONGS_TO_GROUP=`getGroup $(( $RNCCOUNT - $DISCARDED_NUM_OF_RNC )) $NUM_OF_RNC_GROUP`
  fi

  if [ "$RNCCOUNT" -ge 72 ] && [ "$RNCCOUNT" -le 89 ]
  then
    EXTGSMCELL_RANGE=2450
    NW_RANGE=`expr $EXTGSMCELL_RANGE / 1`
    PLUS=`expr $EXTGSMCELL_RANGE - 1`
    INITIAL=26000
    DISCARDED_NUM_OF_RNC=71
    NUMOF_GSM_REL=26

    # Start from RNC40 to 94 see more detail in workingOnWRAN.xml
    NUM_OF_RNC_GROUP=18

    BELONGS_TO_GROUP=`getGroup $(( $RNCCOUNT - $DISCARDED_NUM_OF_RNC )) $NUM_OF_RNC_GROUP`
  fi

  if [ "$RNCCOUNT" -ge 90 ] && [ "$RNCCOUNT" -le 106 ]
  then
    EXTGSMCELL_RANGE=3050
    NW_RANGE=`expr $EXTGSMCELL_RANGE / 1`
    PLUS=`expr $EXTGSMCELL_RANGE - 1`
    INITIAL=29000
    DISCARDED_NUM_OF_RNC=89

    #Start from RNC104 to 106 see more detail in workingOnWRAN.xml
    NUM_OF_RNC_GROUP=17

    BELONGS_TO_GROUP=`getGroup $(( $RNCCOUNT - $DISCARDED_NUM_OF_RNC )) $NUM_OF_RNC_GROUP`
    NUMOF_GSM_REL=26

  fi

  if [ "$RNCCOUNT" -ge 107 ] && [ "$RNCCOUNT" -le 109 ]
  then
    EXTGSMCELL_RANGE=1666
    NW_RANGE=`expr $EXTGSMCELL_RANGE / 1`
    PLUS=`expr $EXTGSMCELL_RANGE - 1`
    INITIAL=35000
    DISCARDED_NUM_OF_RNC=106

    #Start from RNC107 to 109 see more detail in workingOnWRAN.xml
    NUM_OF_RNC_GROUP=3

    BELONGS_TO_GROUP=`getGroup $(( $RNCCOUNT - $DISCARDED_NUM_OF_RNC )) $NUM_OF_RNC_GROUP`
    NUMOF_GSM_REL=29

  fi

   
 
  START_EXTGSMCELL_COUNT=`expr $INITIAL + \( $BELONGS_TO_GROUP \) \* $EXTGSMCELL_RANGE - \( $EXTGSMCELL_RANGE - 1 \)`
  STOP_EXTGSMCELL_COUNT=`expr $START_EXTGSMCELL_COUNT + $PLUS`

  #echo "STOP_EXTGSMCELL_COUNT:$STOP_EXTGSMCELL_COUNT"

  TARGETCELLCOUNT=$START_EXTGSMCELL_COUNT
  END_COUNT=$TOTALCELLS

  COUNT=1
  CELLCOUNT=1
  RBSCOUNT=1
  VAR=1

  while [ "$COUNT" -le "$END_COUNT" ]
  do

    NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCRBSARRAY $RBSCELLARRAY` # NUMOFCELL for each RBS
    CELLNUM=$NUMOFCELL
    CELLSTOP=`expr $NUMOFCELL + 1`

    if [ "$CELLCOUNT" -eq "$CELLSTOP" ]
    then
      CELLCOUNT=1
      RBSCOUNT=`expr $RBSCOUNT + 1`
    fi
  
    UTRANCELLID=`cell_name $RNCCOUNT $RBSCOUNT $CELLCOUNT`


    if [ "$TARGETCELLCOUNT" -ge "$STOP_EXTGSMCELL_COUNT" ]
    then
      TARGETCELLCOUNT=$START_EXTGSMCELL_COUNT
    fi

    #echo "##############################################"
    #echo "# GSMRELATION: From UtranCell to ExternalGsmCell"
    #echo "##############################################"

      SWITCH_TO_NETWORK_C=`expr $START_EXTGSMCELL_COUNT + $NW_RANGE`
      SWITCH_TO_NETWORK_D=`expr $SWITCH_TO_NETWORK_C + $NW_RANGE`
      SWITCH_TO_NETWORK_B=`expr $SWITCH_TO_NETWORK_D + $NW_RANGE`

      START=1
      STOP=$NUMOF_GSM_REL

      LOC_COUNT=$START
      while [ "$LOC_COUNT" -le "$STOP" ]
      do
       

         if [ "$TARGETCELLCOUNT" -gt "$STOP_EXTGSMCELL_COUNT" ]
         then
           TARGETCELLCOUNT=$START_EXTGSMCELL_COUNT
         fi

#        if [ "$TARGETCELLCOUNT" -eq "$SWITCH_TO_NETWORK_C" ]
#        then
#          GSMMNC=2
#        fi

#        if [ "$TARGETCELLCOUNT" -eq "$SWITCH_TO_NETWORK_D" ]
#        then
#          GSMMNC=1
#        fi

#        if [ "$TARGETCELLCOUNT" -eq "$SWITCH_TO_NETWORK_B" ]
#        then
#          GSMMNC=3
#          TARGETCELLCOUNT=$START_EXTGSMCELL_COUNT
#        fi

         EXTGSMCELLREF='ManagedElement=1,RncFunction=1,ExternalGsmNetwork='$GSMMNC',ExternalGsmCell='$TARGETCELLCOUNT

         # Output of relation for testing
         # echo -n "TOT-CELL-"$COUNT" LOC-CELL-"$CELLCOUNT" TOT-RELATION-"$VAR": LOC-RELATION-"$LOC_COUNT": "$UTRANCELLID" UCID="$CID
         # echo "-> EXTGSMCID:"$TARGETCELLCOUNT" (ExtGsmNetwork="$GSMMNC")"

          echo 'CREATE' >> $MOSCRIPT
          echo '(' >> $MOSCRIPT
          echo '  parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID'"' >> $MOSCRIPT
          echo ' identity '$LOC_COUNT >> $MOSCRIPT
          echo ' moType GsmRelation' >> $MOSCRIPT
          echo ' exception none' >> $MOSCRIPT
          echo ' nrOfAttributes 1' >> $MOSCRIPT
          echo ' externalGsmCellRef Ref '$EXTGSMCELLREF >> $MOSCRIPT
          echo ')' >> $MOSCRIPT

         VAR=`expr $VAR + 1`
	 LOC_COUNT=`expr $LOC_COUNT + 1`
         TARGETCELLCOUNT=`expr $TARGETCELLCOUNT + 1`
      done

    CID=`expr $CID + 1`
    CELLCOUNT=`expr $CELLCOUNT + 1`
    COUNT=`expr $COUNT + 1`

    # For testing. To quit ar required amount
    #if [ "$COUNT" -eq 12 ]
    #then
    #  break
    #    exit 1
    #fi
  done

fi

######################################################################################################
# END OF EXTGSMCELL RELATIONS FOR OTHER NETWORKS GSMNETWOK: 5, 6, 7
######################################################################################################

echo "//...$0:$RNCNAME MAKING MO SCRIPT ended at "`date` 
echo "//...$0:$RNCNAME MAKING MO SCRIPT ended at "`date` >> $MOSCRIPT
echo "//" >> $MOSCRIPT

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
echo '.select '$RNCNAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",commit_freq=operation;' >> $MMLSCRIPT


/netsim/inst/netsim_pipe < $MMLSCRIPT

rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT

echo "...$0:RNCNAME script ended at "`date`
echo ""
