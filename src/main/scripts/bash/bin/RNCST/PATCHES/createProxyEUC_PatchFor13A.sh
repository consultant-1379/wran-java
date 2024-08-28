#!/bin/sh

# Created by  : Fatih ONUR
# Created in  : 30/08/2012
##
### VERSION HISTORY
##############################################
# Ver1        : CReate for WRAN deployment O13A
# Purpose     : Update missing External Utran Cells for WRAN_2 network
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

#
# gets max value of given group. ex num=17 and group consist of 8 units. max value for group is 24
#
getMinValue()
{
NUM=$1
DIVISOR=$2
REM=`expr $NUM % $DIVISOR`
NEEDED=`expr $DIVISOR - $REM`

if [ "$REM" -ne 0 ]
then
  MIN=`expr $NUM - $REM + 1`
else
  MIN=`expr $NUM - $DIVISOR + 1`
fi

echo $MIN
}

#
# gets min value of given group. ex num=19 and group consist of 8 units. min value for group is 17
#
getMaxValue()
{
NUM=$1
DIVISOR=$2
REM=`expr $NUM % $DIVISOR`
NEEDED=`expr $DIVISOR - $REM`

if [ "$REM" -ne 0 ]
then
  MAX=`expr $NUM + $NEEDED`
else
  MAX=`expr $NUM + $REM`
fi

echo $MAX
}



#
## get the Target Iurlink for each RNC
#
#
# RNCGROUP: =1 for RNC01,2,3,4,5,6,7,8: =2 for RNC09,10,11,12,13,14,15,16 ........
#

getIurLink() # RNCCOUNT "MIN|MAX"
{
RNCCOUNT=$1
KEY=$2

  MAXIMUM=0
  MINIMUM=999

  NUMOF_PROXY_TYPE=4
  START=1
  STOP=$NUMOF_PROXY_TYPE

  PCOUNT=$START
  while [ "$PCOUNT" -le "$STOP" ]
  do
    case "$PCOUNT"
    in
      1) NUMOFELMOF_RNCGROUP=2 ;;
      2) NUMOFELMOF_RNCGROUP=3 ;;
      3) NUMOFELMOF_RNCGROUP=4 ;;
      4) NUMOFELMOF_RNCGROUP=8 ;;
    esac

    MIN=`getMinValue $RNCCOUNT $NUMOFELMOF_RNCGROUP`
    MAX=`getMaxValue $RNCCOUNT $NUMOFELMOF_RNCGROUP`

    if [ "$MIN" -lt "$MINIMUM" ]
    then
      MINIMUM=$MIN
    fi

    if [ "$MAX" -gt "$MAXIMUM" ]
    then
      MAXIMUM=$MAX
    fi

    # special case: we don't want iurLinks after 
    if [ "$RNCCOUNT" -eq 105 ] 
    then
      if [ "$MAX" -ge 107 ]
      then
        MAXIMUM=106
      fi
    fi
     # special case: we don't want iurLinks after RNC82 upto RNC99
    if [ "$RNCCOUNT" -eq 106 ] 
    then
      if [ "$MAX" -ge 106 ]
      then
        MAXIMUM=105
      fi
    fi

    # special case: we don't want iurLinks
    if [ "$RNCCOUNT" -ge 107 ] 
    then
        MINIMUM=10000
    fi

    PCOUNT=`expr $PCOUNT + 1`
  done

if [ "$KEY" == "MIN" ]
then
  echo $MINIMUM
else
  echo $MAXIMUM
fi
}

#
# get RBS id for the specified cell on certain RNC
#
getRbsId() # RNCCOUNT COUNT RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
COUNT=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

RBSCOUNT=0
NUMOFRNC=0
COUNTX=0

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
      SUBNUMOFCELL=`echo ${bar[$i]} | awk -F "-" '{print $2}'`

      #echo "["$i"] "${bar[$i]};
      #echo "SUBNUMOFRBS="$SUBNUMOFRBS
      #echo "SUBNUMOFCELL="$SUBNUMOFCELL

      COUNTZ=1
      while [ "$COUNTZ" -le "$SUBNUMOFRBS" ]
      do
        COUNTX=`expr $COUNTX + $SUBNUMOFCELL`
        #echo "COUNTX="$COUNTX
        RBSCOUNT=`expr $RBSCOUNT + 1`
        if [ "$COUNTX" -ge "$COUNT" ]
        then
          break
        fi
        COUNTZ=`expr $COUNTZ + 1`
      done;

      # exit from loop when totalcellcount reached to targetcellcount
      if [ "$(($COUNTX + 0 ))" -ge "$COUNT" ]
      then
         break
      fi
    done;
    #echo "RNCCOUNT="$RNCCOUNT
    #echo "RBSCOUNT="$RBSCOUNT
    echo $RBSCOUNT
    #echo "NUMOFCELL="$NUMOFCELL
    #echo "COUNTX="$COUNTX
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

#GETLA

getLA() # CELLCOUNT SHARE LASTART START_CUMTOTALCELLS RNCCOUNT
{
CELLCOUNT=$1
SHARE=$2
LASTART=$3
START_CUMTOTALCELLS=$4
RNCCOUNT=$5

COUNT=`expr $CELLCOUNT - $START_CUMTOTALCELLS + 1`

INC=`getGroup $COUNT $SHARE`
LACOUNT=`expr $LASTART + $INC - 1`
echo $LACOUNT

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
#echo "SUCCESS="$SUCCESS

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

echo ""
echo "MAKING MO SCRIPT"
echo ""

##############################################################
#
# UtranNetwork :046 Internal:06 (mnc), External:07 (mnc)
#
##############################################################

# deleted 

##############################################################
#
# IurLink mcc =046 , mnc =06 (internal)
#
##############################################################

#
# RNCGROUP: =1 for RNC01,2,3,4,5,6,7,8 etc.
#

START_TARGETRNCCOUNT=`getIurLink $RNCCOUNT MIN`
STOP_TARGETRNCCOUNT=`getIurLink $RNCCOUNT MAX`

IURCOUNT=$START_TARGETRNCCOUNT
IURSTOP=$STOP_TARGETRNCCOUNT

echo "//"
echo "//"$RNCNAME" has the following internal iurLinks"

if [ "$RNCCOUNT" -le 106 ] 
then

  while [ "$IURCOUNT" -le "$IURSTOP" ]
  do

    if [ "$IURCOUNT" -ne "$RNCCOUNT" ]
    then
      
      echo -n "// :: iurLink=$IURCOUNT" 
      
      echo 'CREATE' >> $MOSCRIPT
      echo '(' >> $MOSCRIPT
      echo '  parent "ManagedElement=1,RncFunction=1"' >> $MOSCRIPT
      echo '   identity '$IURCOUNT >> $MOSCRIPT
      echo '   moType IurLink' >> $MOSCRIPT
      echo '   exception none' >> $MOSCRIPT
      echo '   nrOfAttributes 2' >> $MOSCRIPT
      echo '   rncId Integer' $IURCOUNT >> $MOSCRIPT
      echo "   utranNetworkRef Ref \"ManagedElement=1,RncFunction=1,UtranNetwork="$MNC"\"" >> $MOSCRIPT 
      echo ')' >> $MOSCRIPT
    fi
    
    IURCOUNT=`expr $IURCOUNT + 1`
  done
  echo " "
      echo  "//   >> has utranNetworkRef=ManagedElement=1,RncFunction=1,UtranNetwork="$MNC
fi




##############################################################
#
# IurLink mcc = 046, mnc = 07 (external)
#
##############################################################

#deleted

##############################################################
#
# ExternalUtranCell (UtranCells managed by same OSS)
#
##############################################################

echo "//"
echo "//"$RNCNAME" has the following ExternalUtranCells (UtranCells managed by same OSS)"

TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
echo "//TOTALCELLS="$TOTALCELLS


# Num of cell has sharing same LA/RA
SHARE1=80
SHARE2=65


########################
# ExternalUtranCells exist only for cells within same network up to RNC106
########################

if [ "$RNCCOUNT" -le 106 ] 
then

  ####################
  # COUNTERS
  ###################

  COUNT=1
  #COUNT=244
  RBSCOUNT=1
  CELLCOUNT=1

  while [ "$COUNT" -le "$TOTALCELLS" ]
  do

    NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCRBSARRAY $RBSCELLARRAY`
    CELLSTOP=`expr $NUMOFCELL + 1`

    if [ "$CELLCOUNT" -eq "$CELLSTOP" ]
    then
      CELLCOUNT=1
      RBSCOUNT=`expr $RBSCOUNT + 1`
    fi



###########################
# CONDITIONS
###########################

    NUMOFCELL_SEVEN_PROXY=12
    NUMOFCELL_THREE_PROXY=27
    NUMOFCELL_TWO_PROXY=77
    NUMOFCELL_ONE_PROXY=129
    #NUMOFCELL_ZERO_PROXY=`expr $TOTALCELLS - \( $NUMOFCELL_SEVEN_PROXY + $NUMOFCELL_THREE_PROXY + $NUMOFCELL_TWO_PROXY + $NUMOFCELL_ONE_PROXY \)`
    PROXY_RANGE=245 #come from excel (ExUC_13A) num of cell has proxy
    
    
    SEVEN_PROXY_START=`expr $PROXY_RANGE - $NUMOFCELL_SEVEN_PROXY + 1`
    SEVEN_PROXY_END=$PROXY_RANGE

    THREE_PROXY_START=`expr $SEVEN_PROXY_START - $NUMOFCELL_THREE_PROXY`
    THREE_PROXY_END=`expr $SEVEN_PROXY_START - 1`

    TWO_PROXY_START=`expr $THREE_PROXY_START - $NUMOFCELL_TWO_PROXY`
    TWO_PROXY_END=`expr $THREE_PROXY_START - 1`

    ONE_PROXY_START=`expr $TWO_PROXY_START - $NUMOFCELL_ONE_PROXY`
    ONE_PROXY_END=`expr $TWO_PROXY_START - 1`

    ZERO_PROXY_START=`expr $PROXY_RANGE + 1`
    ZERO_PROXY_END=$TOTALCELLS


    ##############################################################################################################################
    #
    # Zero proxy up to the specified cell
    #
    #############################################################################################################################

    if [ "$COUNT" -ge "$ZERO_PROXY_START" ]
    then
      echo "// :: Cell COUNTER from $COUNT to $TOTALCELLS Zero proxy"
      break
    else


      ##############################################################################################################################
      #
      #  Creates proxies under (NUMOFELMOF_RNCGROUP-1) total number of iurLinks within network between RNC01 to RNC106
      #
      #############################################################################################################################

      if [ "$RNCCOUNT" -ge 1 ] && [ "$RNCCOUNT" -le 106 ]
      then
        if [ "$COUNT" -ge "$ONE_PROXY_START" ] && [ "$COUNT" -le "$ONE_PROXY_END" ]
        then
          NUMOFELMOF_RNCGROUP=2
        fi
      fi

      ##############################################################################################################################
      #
      #  Creates proxies under (NUMOFELMOF_RNCGROUP-1) total number of iurLinks within network between RNC01 to RNC105
      #
      #############################################################################################################################

      if [ "$RNCCOUNT" -ge 1 ] && [ "$RNCCOUNT" -le 105 ] 
      then
        if [ "$COUNT" -ge "$TWO_PROXY_START" ] && [ "$COUNT" -le "$TWO_PROXY_END" ]
        then
          #echo "TWO_PROXY_START="$TWO_PROXY_START
          NUMOFELMOF_RNCGROUP=3
        fi
      fi

      if ([ "$RNCCOUNT" -ge 106 ]) 
      then
        if [ "$COUNT" -ge "$TWO_PROXY_START" ] && [ "$COUNT" -le "$TWO_PROXY_END" ]
        then
         NUMOFELMOF_RNCGROUP=1 # means do not create any externalUtancells 
        fi
      fi


      ##############################################################################################################################
      #
      #  Creates proxies under total (NUMOFELMOF_RNCGROUP-1) number of iurLinks within network between RNC01 to RNC104
      #
      #############################################################################################################################

      if [ "$RNCCOUNT" -ge 1 ] && [ "$RNCCOUNT" -le 104 ]
      then
        if [ "$COUNT" -ge "$THREE_PROXY_START" ] && [ "$COUNT" -le "$THREE_PROXY_END" ]
        then
          NUMOFELMOF_RNCGROUP=4
        fi
      fi

      if [ "$RNCCOUNT" -ge 105 ]
      then
        if [ "$COUNT" -ge "$THREE_PROXY_START" ] && [ "$COUNT" -le "$THREE_PROXY_END" ]
        then
          NUMOFELMOF_RNCGROUP=1
        fi
      fi


      ##############################################################################################################################
      #
      # Creates proxies under total (NUMOFELMOF_RNCGROUP-1) number of iurLinks within network between RNC01 to RNC104
      #
      #############################################################################################################################

      if [ "$RNCCOUNT" -ge 1 ] && [ "$RNCCOUNT" -le 104 ] 
      then
        if [ "$COUNT" -ge "$SEVEN_PROXY_START" ] && [ "$COUNT" -le "$SEVEN_PROXY_END" ]
        then
          NUMOFELMOF_RNCGROUP=8
        fi
      fi

      if [ "$RNCCOUNT" -ge 105 ] 
      then
        if [ "$COUNT" -ge "$SEVEN_PROXY_START" ] && [ "$COUNT" -le "$SEVEN_PROXY_END" ]
        then
          NUMOFELMOF_RNCGROUP=1
        fi
      fi

      #echo "NUMOFELMOF_RNCGROUP="$NUMOFELMOF_RNCGROUP

#############################################################
# IMPLEMANTATION OF PROXIES
#############################################################

      MOD=`expr $RNCCOUNT % $NUMOFELMOF_RNCGROUP`
      DIV=`expr $RNCCOUNT / $NUMOFELMOF_RNCGROUP`

      if [ "$MOD" -eq 0 ]
      then
        RNCGROUP=$DIV
      else
        RNCGROUP=`expr $DIV + 1`
      fi

      ##################################################################################################################
      #
      # Start of each Target RNC Group
      #  Ex: Say each group conist of 8 RNC (NUMOFELMOF_RNCGROUP), you look for 2nd group (RNCGROUP) start target rncId
      #          START_TARGETRNCCOUNT = 8 * 2 (8 -1) = 9
      #          STOP_TARGETRNCCOUNT = 9 + 8 - 1 = 16
      #
      ##################################################################################################################

        START_TARGETRNCCOUNT=`expr $NUMOFELMOF_RNCGROUP \* $RNCGROUP - \( $NUMOFELMOF_RNCGROUP - 1 \)`
        STOP_TARGETRNCCOUNT=`expr $START_TARGETRNCCOUNT + $NUMOFELMOF_RNCGROUP - 1`
        
        #echo "START_TARGETRNCCOUNT="$START_TARGETRNCCOUNT
        #echo "STOP_TARGETRNCCOUNT="$STOP_TARGETRNCCOUNT

      TARGETRNCCOUNT=$START_TARGETRNCCOUNT

      while [ "$TARGETRNCCOUNT" -le "$STOP_TARGETRNCCOUNT" ]
      do
        if [ "$TARGETRNCCOUNT" -eq "$RNCCOUNT" ]
        then
          TARGETRNCCOUNT=`expr $TARGETRNCCOUNT + 1`

          if [ "$TARGETRNCCOUNT" -gt "$STOP_TARGETRNCCOUNT" ]
          then
            break # Prevents creation of overlap iurlik. Ex: RNC01 can not have iurlink=1 or RNC08 can not have iurlink=8
          fi
        fi


        ######################################################################
        #
        # Creates External UtranCells according to portion stated on conditions above.
        #
        #######################################################################
  
        TARGETCELLCOUNT=`getCumulativeTotalCells $TARGETRNCCOUNT $COUNT $RNCRBSARRAY $RBSCELLARRAY`
        TARGETRBSCOUNT=`getRbsId $TARGETRNCCOUNT $COUNT $RNCRBSARRAY $RBSCELLARRAY`

        TARGET_START_CUMTOTALCELLS=`getCumulativeTotalCells $TARGETRNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`

        UTRANCELLID=`cell_name $TARGETRNCCOUNT $TARGETRBSCOUNT $CELLCOUNT`
        UARFCNDL=`expr \( \( $TARGETRNCCOUNT \* 1 \) + 0 \) % 16384`
        UARFCNUL=12
        PRIMSCRCODE=`expr $COUNT % 512` 
        QQUALMIN=-24
        MAXTXPOWERUL=30
        QRXLEVMIN=-115
        PRIMARYCPICHPOWER=300

        #LA=`getGroup $TARGETCELLCOUNT $SHARE1`
        LASTART=`getLAStart $TARGETRNCCOUNT $SHARE1 $RNCRBSARRAY $RBSCELLARRAY`

        
        #### RNC106 is a special case: Max num of LAs exceeds for SHARE=56
        #
        if [ $RNCCOUNT -eq 106 ] 
        then
          SHARE1=$SHARE2
        fi
        
        LA=`getLA $TARGETCELLCOUNT $SHARE1 $LASTART $TARGET_START_CUMTOTALCELLS $RNCCOUNT`
        LACOUNT=$LA

        MOD=`expr $LACOUNT % 255`
        if [ $MOD -eq 0 ]
        then
          RAC=255
        else
          RAC=`expr $LACOUNT % 255 + 0`
        fi

         LA=$LACOUNT      
         RA=$RAC

        #echo "// $COUNT:: UTRANCELLID="$UTRANCELLID" ; ExternalUtranCell="$TARGETCELLCOUNT" ->  iurLink="$TARGETRNCCOUNT" ; RA="${RA}" LA="${LA}" UARFCNDL="$UARFCNDL" PRIMSCRCODE="$PRIMSCRCODE

        echo 'CREATE' >> $MOSCRIPT
        echo '(' >> $MOSCRIPT
        echo '  parent "ManagedElement=1,RncFunction=1,IurLink='$TARGETRNCCOUNT'"' >> $MOSCRIPT
        echo ' identity '$TARGETCELLCOUNT >> $MOSCRIPT
        echo ' moType ExternalUtranCell' >> $MOSCRIPT
        echo ' exception none' >> $MOSCRIPT
        echo ' nrOfAttributes 8' >> $MOSCRIPT
        echo ' lac Integer '$LA >> $MOSCRIPT
        echo ' rac Integer '$RA >> $MOSCRIPT
        echo ' userLabel String '$UTRANCELLID >> $MOSCRIPT
        echo ' cId Integer '$TARGETCELLCOUNT >> $MOSCRIPT
        echo ' uarfcnDl Integer '$UARFCNDL >> $MOSCRIPT
        echo ' uarfcnUl Integer '$UARFCNUL >> $MOSCRIPT
        echo ' primaryScramblingCode Integer '$PRIMSCRCODE >> $MOSCRIPT
        echo ' qQualMin Integer '$QQUALMIN >> $MOSCRIPT

	echo ' maxTxPowerUl Integer '$MAXTXPOWERUL >> $MOSCRIPT
	echo ' qRxLevMin Integer '$QRXLEVMIN >> $MOSCRIPT
        echo ' primaryCpichPower Integer '$PRIMARYCPICHPOWER>> $MOSCRIPT
        
        echo ')' >> $MOSCRIPT

        TARGETRNCCOUNT=`expr $TARGETRNCCOUNT + 1`
      done
    fi


    CELLCOUNT=`expr $CELLCOUNT + 1` 
    COUNT=`expr $COUNT + 1`
  done
fi



#########################################################################################################
#
# ExternalUtranCells for External UtranRelations ( Master ExternalUtrancells in Region ) (WRAN_2)
#
##########################################################################################################

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

echo "...$SIMNAME:$0 script ended at "`date`
echo ""

