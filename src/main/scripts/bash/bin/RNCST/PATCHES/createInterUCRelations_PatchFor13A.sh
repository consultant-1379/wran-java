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

#########################################
# 
# Make MO Script
#
#########################################

echo ""
echo "MAKING MO SCRIPT"
echo ""


##############################################################
# Getting NUMOFRBS and NUMOFCELL for each RNC
##############################################################

# deleted

#################################################################################
#
# (1)  Create UtranRelation to UtranCells in same RBS ( Intra-Relation )
#
##################################################################################

#################################################################
#
# (2)  UtranRelations to Cells in other RBS ( Intra-Relation )
#
#################################################################

# deleted

######################################################################################################
# END OF INTRA RELATIONS
######################################################################################################

#########################################################################
#
# (3) INTER_RELATION: UtranRelations to Cells in ExternalUtranCells, DiffRBS, DiffRNC, SameNETWORK
#
#########################################################################

######################################################################################################
# START OF INTER RELATIONS
######################################################################################################

TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
CIDSTART=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`
CID=$CIDSTART

#######################################################################
#
# Loop through all the UtranCells
#
#######################################################################

#
## Relations Types
#
INTRA_REL_TYPE=0
INTER_REL_TYPE=1


RUN="YES" # YES to enable run | NO to disable run
INTER_RELATION=$RUN

if [ "$INTER_RELATION" == "YES" ]
then

echo "//.......$0:RNCNAME [INTER_RELATION] script started running at "`date` >> $MOSCRIPT
echo "//" >> $MOSCRIPT

#########################################################################
#
# (3) INTER_RELATION: UtranRelations to Cells in ExternalUtranCells, DiffRBS, DiffRNC, SameNETWORK
#
#########################################################################

#  Note: There is no Inter Relations for Type-F

if [ "$RNCCOUNT" -le 106 ]
then

#echo "//"
#echo "//##############################################"
#echo "//# INTER_RELATION: DiffRBS, DiffRNC, SameNETWORK"
#echo "//##############################################"

###########################
# CONDITIONS
###########################

  CREATE_RELATION=YES

  NUMOFCELL_SEVEN_PROXY=12
  NUMOFCELL_THREE_PROXY=27
  NUMOFCELL_TWO_PROXY=77
  NUMOFCELL_ONE_PROXY=129
  NUMOFCELL_ZERO_PROXY=`expr $TOTALCELLS - \( $NUMOFCELL_SEVEN_PROXY + $NUMOFCELL_THREE_PROXY + $NUMOFCELL_TWO_PROXY + $NUMOFCELL_ONE_PROXY \)`
 
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

  #echo "ZERO_PROXY_START="$ZERO_PROXY_START
  #echo "ZERO_PROXY_END="$ZERO_PROXY_END
  #echo "ONE_PROXY_START="$ONE_PROXY_START
  #echo "ONE_PROXY_END="$ONE_PROXY_END
  #echo "TWO_PROXY_START="$TWO_PROXY_START
  #echo "TWO_PROXY_END="$TWO_PROXY_END
  #echo "THREE_PROXY_START="$THREE_PROXY_START
  #echo "THREE_PROXY_END="$THREE_PROXY_END
  #echo "SEVEN_PROXY_START="$SEVEN_PROXY_START
  #echo "SEVEN_PROXY_END="$SEVEN_PROXY_END

  

	COUNT=1
	CELLCOUNT=1
	RBSCOUNT=1

	while [ "$COUNT" -le "$TOTALCELLS" ]
	do

          VAR=32 # inter relations start from 32


	  NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCRBSARRAY $RBSCELLARRAY`
	  CELLNUM=$NUMOFCELL
	  CELLSTOP=`expr $NUMOFCELL + 1`


	  if [ "$CELLCOUNT" -eq "$CELLSTOP" ]
	  then
		CELLCOUNT=1
		RBSCOUNT=`expr $RBSCOUNT + 1`
	  fi


	  UTRANCELLID=`cell_name $RNCCOUNT $RBSCOUNT $CELLCOUNT`
	  #echo "UTRANCELLID="$UTRANCELLID
	 
	  #echo ""
	  #echo "##############################################"
	  #echo "# INTER_RELATION: DiffRBS, DiffRNC, SameNETWORK"
	  #echo "##############################################"

	  
	  ##############################################################################################################################
	  #
	  # 0 Relations * 0 Cells = 0 Relations Per Cell, start from to end of cell-count of RNC
	  #
	  #############################################################################################################################

	  if [ "$COUNT" -ge "$ZERO_PROXY_START" ] 
	  then
		#echo "******************************"
		#echo "*****  Think about it"
		#echo "******************************"
	        echo "// DO NOT CREATE ANY INTER-RELATION FOR CELLRANGE=$COUNT-$TOTALCELLS"
		CREATE_RELATION=NO
		break # exit from the loop
	  fi


	  ##############################################################################################################################
	  #
	  # 1 Relations * 10 Cells = 10 Relations Per Cell, start from  to  cell of RNC
	  #
	  #############################################################################################################################

	  if [ "$COUNT" -ge "$ONE_PROXY_START" ] && [ "$COUNT" -le "$ONE_PROXY_END" ]
	  then
		NUMOFELMOF_RNCGROUP=2
	  
		#TEMPEXCESS=`expr $ONE_PROXY_START - 1`
		#OTHER_RELATION_START=`expr $ONE_PROXY_END - 63 + 1 `

		#NUMOFELMOF_CELLGROUP=11
		#if [ "$COUNT" -ge "$OTHER_RELATION_START" ] && [ "$COUNT" -le "$ONE_PROXY_END" ]
		#then
		#  NUMOFELMOF_CELLGROUP=12
		#  TEMPEXCESS=` expr $OTHER_RELATION_START - 1`
		#fi

                if [ "$COUNT" -ge 1 ] && [ "$COUNT" -le 66 ]
		then
		  NUMOFELMOF_CELLGROUP=11
		  TEMPEXCESS=0
                else if [ $COUNT -ge 67 ] && [ "$COUNT" -le 126 ]
                then
		  NUMOFELMOF_CELLGROUP=15
	          TEMPEXCESS=66
                else if [ $COUNT -ge 127 ] && [ "$COUNT" -le 129 ]
                then
                   NUMOFELMOF_CELLGROUP=3
                   TEMPEXCESS=126
                fi
		fi	
		fi	
                
		PRE_START_TARGETCID=`getStartTargetCID $COUNT $TEMPEXCESS $NUMOFELMOF_CELLGROUP`
	  fi


	  ##############################################################################################################################
	  #
	  # 2 Relations * 12 Cells = 24 Relations Per Cell, start from  to  cell of RNC
	  #
	  #############################################################################################################################

	  if ([ "$RNCCOUNT" -ge 1 ] && [ "$RNCCOUNT" -le 105 ]) 
	  then
	 
		if [ "$COUNT" -ge "$TWO_PROXY_START" ] && [ "$COUNT" -le "$TWO_PROXY_END" ]
		then
		  NUMOFELMOF_RNCGROUP=3

		  #TEMPEXCESS=`expr $TWO_PROXY_START - 1`
		  #OTHER_RELATION_START=`expr $TWO_PROXY_END - 3 + 1 `  

		  #NUMOFELMOF_CELLGROUP=9
		  #if [ "$COUNT" -ge "$OTHER_RELATION_START" ] && [ "$COUNT" -le "$TWO_PROXY_END" ]
		  #then
			#NUMOFELMOF_CELLGROUP=3 
			#TEMPEXCESS=` expr $OTHER_RELATION_START - 1`
		  #fi

                  if [ "$COUNT" -ge 130 ] && [ "$COUNT" -le 139 ]
                  then
                    NUMOFELMOF_CELLGROUP=10
                    TEMPEXCESS=129
                  else if [ $COUNT -ge 140 ] && [ "$COUNT" -le 202 ]
                  then
                    NUMOFELMOF_CELLGROUP=9
                    TEMPEXCESS=139
                  else if [ $COUNT -ge 203 ] && [ "$COUNT" -le 206 ]
                  then
                     NUMOFELMOF_CELLGROUP=4
                     TEMPEXCESS=202
                  fi
                  fi
                  fi

		  PRE_START_TARGETCID=`getStartTargetCID $COUNT $TEMPEXCESS $NUMOFELMOF_CELLGROUP`
		fi
	  fi

	  if ([ "$RNCCOUNT" -ge 106 ])
	  then
		if [ "$COUNT" -ge "$TWO_PROXY_START" ] && [ "$COUNT" -le "$TWO_PROXY_END" ]
		then
			CREATE_RELATION=NO
		fi
	  fi

	  ##############################################################################################################################
	  #
	  # 3 Relations * 9 Cells = 27 Relations Per Cell, start from 30 to 74 cell of RNC
	  #
	  #############################################################################################################################

	  if [ "$RNCCOUNT" -ge 1 ] && [ "$RNCCOUNT" -le 104 ] 
	  then

		if [ "$COUNT" -ge "$THREE_PROXY_START" ] && [ "$COUNT" -le "$THREE_PROXY_END" ]
		then
		  NUMOFELMOF_RNCGROUP=4
	  
		  #TEMPEXCESS=`expr $THREE_PROXY_START - 1`
		  #OTHER_RELATION_START=`expr $THREE_PROXY_END - 2 + 1`

		  #NUMOFELMOF_CELLGROUP=6
		  #if [ "$COUNT" -ge "$OTHER_RELATION_START" ] && [ "$COUNT" -le "$THREE_PROXY_END" ]
		  #then
			#NUMOFELMOF_CELLGROUP=2 
			#TEMPEXCESS=` expr $OTHER_RELATION_START - 1`
		  #fi

                  if [ "$COUNT" -ge 207 ] && [ "$COUNT" -le 230 ]
                  then
                    NUMOFELMOF_CELLGROUP=6
                    TEMPEXCESS=206
                  else if [ $COUNT -ge 231 ] && [ "$COUNT" -le 233 ]
                  then
                    NUMOFELMOF_CELLGROUP=3
                    TEMPEXCESS=230
                  fi
                  fi

		  PRE_START_TARGETCID=`getStartTargetCID $COUNT $TEMPEXCESS $NUMOFELMOF_CELLGROUP`
		fi
	  fi

	   if [ "$RNCCOUNT" -ge 105 ]
	   then
		  if [ "$COUNT" -ge "$THREE_PROXY_START" ] && [ "$COUNT" -le "$THREE_PROXY_END" ]
		  then
			 CREATE_RELATION=NO
		  fi
	   fi


	  ##############################################################################################################################
	  # 
	  # 4 Relations * 7 Cells = 28 Relations Per Cell, start from 1 to 28 cell of RNC
	  # 1 Relation * 7 Cells = 7 Relations Per Cell, start from 29 to 29 cell of RNC
	  #  Within first 29 cells, each cell has total 7 proxies, distributed to 7 RNC. i
	  #  And, each cell makes relation among those RNC.
	  #  NUMOFELMOF_RNCGROUP defines a group to have bi-directional inter relation for each RNC.
	  #   Ex: if NUMOFELMOF_RNCGROUP=8, it means RNC01, RNC02, RNC03, RNC04, RNC05, RNC06, RNC07 and RNC08 is a group.
	  #       And, they will have relations between each other according to NUMOFELMOF_CELLGROUP
	  #  NUMOFELMOF_CELLGROUP defines for the current cell how many relations will be pointed out for proxies
	  #   Ex: if NUMOFELMOF_CELLGROUP=4, it means Cell-X will make Relation to Cell-Y+4 where X is a number in a range of Y+4
	  #	  Cell-1 -> Cell-1; Cell-1 -> Cell-2; Cell-1 -> Cell-3; Cell-1 -> Cell-4
	  #
	  #############################################################################################################################

	  if [ "$RNCCOUNT" -ge 1 ] && [ "$RNCCOUNT" -le 104 ] 
	  then

		if [ "$COUNT" -ge "$SEVEN_PROXY_START" ] && [ "$COUNT" -le "$SEVEN_PROXY_END" ]
		then
		  NUMOFELMOF_RNCGROUP=8
	  
		  TEMPEXCESS=`expr $SEVEN_PROXY_START - 1`
		  NUMOFELMOF_CELLGROUP=2 

		  PRE_START_TARGETCID=`getStartTargetCID $COUNT $TEMPEXCESS $NUMOFELMOF_CELLGROUP`
		fi
	  fi


	  if [ "$RNCCOUNT" -ge 105 ] 
	  then
		  if [ "$COUNT" -ge "$SEVEN_PROXY_START" ] && [ "$COUNT" -le "$SEVEN_PROXY_END" ]
		  then
			 CREATE_RELATION=NO
		  fi
	  fi


	#############################################################
	#
	# IMPLEMANTATION OF INTER RELATIONS
	#
	#############################################################


	  if [ "$CREATE_RELATION" == "YES" ]
	  then

		MOD=`expr $RNCCOUNT % $NUMOFELMOF_RNCGROUP`
		DIV=`expr $RNCCOUNT / $NUMOFELMOF_RNCGROUP` 

		if [ "$MOD" -eq 0 ]
		then
		  RNCGROUP=$DIV
		else
		  RNCGROUP=`expr $DIV + 1`
		fi

		##############################################################
		#
		# Start of each Target RNC Group
		#  Ex: Say each group conist of 8 RNC (NUMOFELMOF_RNCGROUP), you look for 2nd group (RNCGROUP) start target rncId
		#          START_TARGETRNCCOUNT = 8 * 2 (8 -1) = 9
		#          STOP_TARGETRNCCOUNT = 9 + 8 - 1 = 16
		#
		##############################################################
		START_TARGETRNCCOUNT=`expr $NUMOFELMOF_RNCGROUP \* $RNCGROUP - \( $NUMOFELMOF_RNCGROUP - 1 \)`
		STOP_TARGETRNCCOUNT=`expr $START_TARGETRNCCOUNT + $NUMOFELMOF_RNCGROUP - 1`

		TARGETRNCCOUNT=$START_TARGETRNCCOUNT

                LOC_COUNT=1
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

		  START_TARGETCID=`getCumulativeTotalCells $TARGETRNCCOUNT $PRE_START_TARGETCID $RNCRBSARRAY $RBSCELLARRAY`
		  STOP_TARGETCID=`expr $START_TARGETCID + \( $NUMOFELMOF_CELLGROUP - 1 \)`
	 

		  ######################################################################
		  #
		  # Visit each TargetCell according to necessary number of relations for the current Cell
		  #  NUMOFELMOF_CELLGROUP defines number of relations for each current cell
		  #
		  #######################################################################


		  START=1
		  STOP=$NUMOFELMOF_CELLGROUP
	   
		  PRETARGETCELLCOUNT=$PRE_START_TARGETCID  
		  TARGETCELLCOUNT=$START_TARGETCID 
		  TCOUNT=$START 
		  while [ "$TCOUNT" -le "$STOP" ]
		  do
			 IURLINK=$TARGETRNCCOUNT
			 #LOC_COUNT=$TCOUNT 
			 EXT_UTRANCELLID=$TARGETCELLCOUNT

			 # read WRAN network data
			 #
			 LINE=`grep "CID=${EXT_UTRANCELLID};" ${PWD}/$UTRANDATAFILE`

			 EXT_UTRANCELL=`echo $LINE| awk -F";" '{print $2}' |  awk -F"=" '{print $2}'`
			 UCELLREF='ManagedElement=1,RncFunction=1,IurLink='$IURLINK',ExternalUtranCell='$EXT_UTRANCELLID
			 
	  
			 # Optional another output style
			 # echo $TCOUNT": "$COUNT" -> "$TARGETRNCCOUNT" - "$PRETARGETCELLCOUNT"   or   CID= "$TARGETCELLCOUNT" -> iurLink="$TARGETRNCCOUNT

			 # Output of relation for testing
			 # echo -n "TOT-CELL-"$COUNT" LOC-CELL-"$CELLCOUNT" TOT-RELATION-"$VAR": LOC-RELATION-"$LOC_COUNT": "$UTRANCELLID" -> "$UCELLREF
			 #echo " ("$EXT_UTRANCELL")"
			 #" (Put $EXT_UTRANCELL after $UCELREFF userlabel eg;RNC01-1-1)"

		     echo 'CREATE' >> $MOSCRIPT
		     echo '(' >> $MOSCRIPT
		     echo '  parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID'"' >> $MOSCRIPT
		     echo ' identity '$VAR >> $MOSCRIPT
		     echo ' moType UtranRelation' >> $MOSCRIPT
		     echo ' exception none' >> $MOSCRIPT
		     echo ' nrOfAttributes 1' >> $MOSCRIPT
		     echo ' utranCellRef Ref '$UCELLREF >> $MOSCRIPT
			 echo ' nodeRelationType Integer '$INTER_REL_TYPE >> $MOSCRIPT
			 echo ' frequencyRelationType Integer '$INTER_REL_TYPE >> $MOSCRIPT
		     echo ')' >> $MOSCRIPT

			 VAR=`expr $VAR + 1`
			 TARGETCELLCOUNT=`expr $TARGETCELLCOUNT + 1`
			 PRETARGETCELLCOUNT=`expr $PRETARGETCELLCOUNT + 1`
			 TCOUNT=`expr $TCOUNT + 1`
			 LOC_COUNT=`expr + $LOC_COUNT + 1`
		  done

		  TARGETRNCCOUNT=`expr $TARGETRNCCOUNT + 1`
		done

	  else
		 echo "// DO NOT CREATE ANY INTER-RELATION FOR CELLRANGE=$COUNT-$TOTALCELLS"
		 #echo "// DO NOT CREATE ANY INTER-RELATION FOR CELL "$UTRANCELLID
		 break
	  fi



	  CID=`expr $CID + 1`
	  CELLCOUNT=`expr $CELLCOUNT + 1`
	  COUNT=`expr $COUNT + 1`

	  # For testing. To quit ar required amount
	  #if [ "$COUNT" -eq 2 ]
	  #if [ "$COUNT" -eq 594 ]
	  #if [ "$COUNT" -eq 6 ]
	  #then
	  #  break
	  #    echo "bye"
		  #exit 1
	  #fi

	done

  echo "Inter Cell Relations MML"
  echo '.open '$SIMNAME >> $MMLSCRIPT
  echo '.select '$RNCNAME >> $MMLSCRIPT
  echo '.start ' >> $MMLSCRIPT
  echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
  echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",commit_freq=operation;' >> $MMLSCRIPT

  /netsim/inst/netsim_shell < $MMLSCRIPT

  rm $PWD/$MOSCRIPT
  rm $PWD/$MMLSCRIPT

else
  echo "// DO NOT CREATE ANY INTER-RELATION FOR "$RNCNAME
fi

echo "//.....$0:RNCNAME [INTER_RELATION] script ended at "`date` >> $MOSCRIPT
echo "//" >> $MOSCRIPT

fi #RUN MODE IF/ELSE

######################################################################################################
# END OF INTER RELATIONS
######################################################################################################

echo "...$SIMNAME:$0 script ended at "`date`
echo ""
exit
######################################################################################################
#
# (4) External Relation: DiffRBS,DiffRNC,DiffNETWORK
#
######################################################################################################


RUN="YE" # YES to enable run | NO to disable run

if [ "$RUN" == "YES" ]
then

#  Note: There is no Inter Relations after RNC65

if [ "$RNCCOUNT" -le 65 ] 
then

echo ""
#echo "##############################################"
echo "# EXTERNAL_RELATION: DiffRBS,DiffRNC,DiffNETWORK"
#echo "##############################################"

  ###########################
  # CONDITIONS
  ###########################

  CREATE_RELATION=YES

    NUMOF_BIDIRECTIONAL_RELATION_GROUP_A=21
    NUMOF_BIDIRECTIONAL_RELATION_GROUP_B=16
    NUMOF_BIDIRECTIONAL_RELATION_GROUP_C=5
    #NUMOF_BIDIRECTIONAL_RELATION_GROUP_D=3

    NUMOFCELL_HAS_RELATION_TYPE_GROUP_A=63
    NUMOFCELL_HAS_RELATION_TYPE_GROUP_B=112
    NUMOFCELL_HAS_RELATION_TYPE_GROUP_C=25
    #NUMOFCELL_HAS_RELATION_TYPE_GROUP_D=30

    NUMOFCELL_ONE_PROXY=`expr $NUMOFCELL_HAS_RELATION_TYPE_GROUP_A + $NUMOFCELL_HAS_RELATION_TYPE_GROUP_B`
    NUMOFCELL_ONE_PROXY=`expr $NUMOFCELL_ONE_PROXY + $NUMOFCELL_HAS_RELATION_TYPE_GROUP_C`
    #echo "NUMOFCELL_ONE_PROXY="$NUMOFCELL_ONE_PROXY
 
    #NUMOFCELL_ONE_PROXY=`expr $NUMOFCELL_ONE_PROXY + $NUMOFCELL_HAS_RELATION_TYPE_GROUP_C + $NUMOFCELL_HAS_RELATION_TYPE_GROUP_D`

    NUMOFCELL_ZERO_PROXY=`expr $TOTALCELLS - \( $NUMOFCELL_ONE_PROXY \)`

    ONE_PROXY_START=1
    ONE_PROXY_END=$NUMOFCELL_ONE_PROXY

    ZERO_PROXY_START=`expr $ONE_PROXY_END + 1`
    ZERO_PROXY_END=$TOTALCELLS


	
	CID=$CIDSTART
	COUNT=1
	CELLCOUNT=1
	RBSCOUNT=1
             
        echo "TOTALCELLS="$TOTALCELLS

	while [ "$COUNT" -le "$TOTALCELLS" ]
	do

          VAR=61  # Start id of External Relations under each UtranCel

	  NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCRBSARRAY $RBSCELLARRAY`
	  CELLNUM=$NUMOFCELL
	  CELLSTOP=`expr $NUMOFCELL + 1`
	 
	  if [ "$CELLCOUNT" -eq "$CELLSTOP" ]
	  then
		CELLCOUNT=1
		RBSCOUNT=`expr $RBSCOUNT + 1`
	  fi	 

	  UTRANCELLID=`cell_name $RNCCOUNT $RBSCOUNT $CELLCOUNT`
	  #echo "UTRANCELLID="$UTRANCELLID

	  #echo ""
	  #echo "##############################################"
	  #echo "# EXTERNAL_RELATION: DiffRBS,DiffRNC,DiffNETWORK"
	  #echo "##############################################"
  
	  TOTALCELLS_OF_W2=200 # WRAN2 Network TotalCells
	  
	  ##############################################################################################################################
	  #
	  # 0 Relations * 0 Cells = 0 Relations Per Cell, start from 480 to end of cell-count of RNC
	  #
	  #############################################################################################################################

	  if [ "$COUNT" -ge "$ZERO_PROXY_START" ] 
	  then
		#echo "******************************"
		#echo "*****  Think about it"
		#echo "******************************"
		CREATE_RELATION=NO
		break
	  fi

	  ##############################################################################################################################
	  # 
	  # 1 Relation(s) * 5 Cells = 5 Relations Per Cell, start from 1st cell last cell of RNC
	  #  Each RNC is represented by 15 ExternalUtranCells.
	  #  And, each local cell makes relation among those ExternalUtranCells(Proxies).
	  #  NUMOFELMOF_RNCGROUP defines a group to have bi-directional inter relation for each RNC.
	  #   Ex: if NUMOFELMOF_RNCGROUP=6, it means RNC01, RNC02, RNC03, RNC04, RNC05, and RNC06 is a group.
	  #       And, they will have relations between each other according to NUMOFELMOF_CELLGROUP
	  #  NUMOFELMOF_CELLGROUP defines for the current cell how many relations will be pointed out for proxies
	  #   Ex: if NUMOFELMOF_CELLGROUP=4, it means Cell-X will make Relation to Cell-Y+3 where X is a number in a range of Y+3
	  #	  XCell-1 -> YCell-1; XCell-1 -> YCell-2; XCell-1 -> YCell-3; XCell-1 -> YCell-4
	  #
	  #############################################################################################################################

  if [ "$COUNT" -ge "$ONE_PROXY_START" ] && [ "$COUNT" -le "$ONE_PROXY_END" ]
  then
    NUMOFELMOF_RNCGROUP=1
 
    if [ "$COUNT" -le "$NUMOFCELL_HAS_RELATION_TYPE_GROUP_A" ] 
    then
      TEMPEXCESS=`expr $ONE_PROXY_START - 1`
      NUMOFELMOF_CELLGROUP=$NUMOF_BIDIRECTIONAL_RELATION_GROUP_A
    fi

    if [ "$COUNT" -gt "$NUMOFCELL_HAS_RELATION_TYPE_GROUP_A" ] 
    then
      TEMPEXCESS=$NUMOFCELL_HAS_RELATION_TYPE_GROUP_A
      NUMOFELMOF_CELLGROUP=$NUMOF_BIDIRECTIONAL_RELATION_GROUP_B
    fi

    TEMP_LIMIT_1=`expr $NUMOFCELL_HAS_RELATION_TYPE_GROUP_A + $NUMOFCELL_HAS_RELATION_TYPE_GROUP_B`
    if [ "$COUNT" -gt "$TEMP_LIMIT_1" ]
    then
      TEMPEXCESS=$TEMP_LIMIT_1
      NUMOFELMOF_CELLGROUP=$NUMOF_BIDIRECTIONAL_RELATION_GROUP_C
    fi

    #TEMP_LIMIT_2=`expr $TEMP_LIMIT_1 + $NUMOFCELL_HAS_RELATION_TYPE_GROUP_C`
    #if [ "$COUNT" -gt "$TEMP_LIMIT_2" ]
    #then
    #  TEMPEXCESS=$TEMP_LIMIT_2
    #  NUMOFELMOF_CELLGROUP=$NUMOF_BIDIRECTIONAL_RELATION_GROUP_D
    #fi

    PRE_START_TARGETCID=`getStartTargetCID $COUNT $TEMPEXCESS $NUMOFELMOF_CELLGROUP` 
  fi

#############################################################
#
# IMPLEMANTATION OF EXTERNAL RELATIONS
#
#############################################################


  if [ "$CREATE_RELATION" == "YES" ]
  then

    MOD=`expr $RNCCOUNT % $NUMOFELMOF_RNCGROUP`
    DIV=`expr $RNCCOUNT / $NUMOFELMOF_RNCGROUP` 

    if [ "$MOD" -eq 0 ]
    then
      RNCGROUP=$DIV
    else
      RNCGROUP=`expr $DIV + 1`
    fi

    ##############################################################
    #
    # Start of each Target RNC Group
    #  Ex: Say each group conist of 8 RNC (NUMOFELMOF_RNCGROUP), you look for 2nd group (RNCGROUP) start target rncId
    #          START_TARGETRNCCOUNT = 8 * 2 (8 -1) = 9
    #          STOP_TARGETRNCCOUNT = 9 + 8 - 1 = 16
    #
    ##############################################################
    START_TARGETRNCCOUNT=`expr $NUMOFELMOF_RNCGROUP \* $RNCGROUP - \( $NUMOFELMOF_RNCGROUP - 1 \)`
    STOP_TARGETRNCCOUNT=`expr $START_TARGETRNCCOUNT + $NUMOFELMOF_RNCGROUP - 1`

      #echo "START_TARGETRNCCOUNT="$START_TARGETRNCCOUNT
      #echo "STOP_TARGETRNCCOUNT="$STOP_TARGETRNCCOUNT    

    TARGETRNCCOUNT=$START_TARGETRNCCOUNT
    LOC_COUNT=1

    while [ "$TARGETRNCCOUNT" -le "$STOP_TARGETRNCCOUNT" ]
    do

      START_TARGETCID=`expr $PRE_START_TARGETCID + \( \( $TARGETRNCCOUNT - 1 \)  \* $TOTALCELLS_OF_W2 \)`
      STOP_TARGETCID=`expr $START_TARGETCID + \( $NUMOFELMOF_CELLGROUP - 1 \)`
 

      ######################################################################
      #
      # Visit each TargetCell according to necessary number of relations for the current Cell
      #  NUMOFELMOF_CELLGROUP defines number of relations for each current cell
      #
      #######################################################################


      START=1
      STOP=$NUMOFELMOF_CELLGROUP
   
      PRETARGETCELLCOUNT=$PRE_START_TARGETCID
      TARGETCELLCOUNT=$START_TARGETCID 
      TCOUNT=$START 
      while [ "$TCOUNT" -le "$STOP" ]
      do

         RNCIDEXT="RNC-"$EXTMNC"-"
         if [ "$TARGETRNCCOUNT" -ge 10 ]
         then
           IURLINK_IDENTITY=${RNCIDEXT}$TARGETRNCCOUNT
         else
           IURLINK_IDENTITY=${RNCIDEXT}"0"$TARGETRNCCOUNT
         fi

         IURLINK=$TARGETRNCCOUNT
         EXT_UTRANCELLID=$TARGETCELLCOUNT
         EXT_UTRANCELL_IDENTITY=`getUtranCellIdForOtherWRAN $EXT_UTRANCELLID $IURLINK_IDENTITY $NUMOFRBS`
         UCELLREF='ManagedElement=1,RncFunction=1,IurLink='$IURLINK_IDENTITY',ExternalUtranCell='$EXT_UTRANCELL_IDENTITY
         UCELLREF_FOR_PRINT='ME=1,RncFunction=1,IurLink='$IURLINK_IDENTITY',EUC='$EXT_UTRANCELL_IDENTITY

  
         # Optional another output style
         #echo $TCOUNT": "$COUNT" -> "$TARGETRNCCOUNT" - "$PRETARGETCELLCOUNT"   or   CID= "$TARGETCELLCOUNT" -> iurLink="$TARGETRNCCOUNT

         # Output of relation for testing
         ## echo -n "TOT-CELL-"$COUNT" LOC-CELL-"$CELLCOUNT" TOT-RELATION-"$VAR": LOC-RELATION-"$LOC_COUNT": "$UTRANCELLID"("$CID
	 ##     echo ") -> "$UCELLREF_FOR_PRINT"("$EXT_UTRANCELLID")"
         # echo " ("$EXT_UTRANCELL")"
         #" (Put $EXT_UTRANCELL after $UCELREFF userlabel eg;RNC01-1-1)"

		 echo 'CREATE' >> $MOSCRIPT
		 echo '(' >> $MOSCRIPT
		 echo '  parent "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID'"' >> $MOSCRIPT
		 echo ' identity '$VAR >> $MOSCRIPT
		 echo ' moType UtranRelation' >> $MOSCRIPT
		 echo ' exception none' >> $MOSCRIPT
		 echo ' nrOfAttributes 1' >> $MOSCRIPT
		 echo ' utranCellRef Ref '$UCELLREF >> $MOSCRIPT
		 echo ' nodeRelationType Integer '$INTER_REL_TYPE >> $MOSCRIPT
         	 echo ' frequencyRelationType Integer '$INTER_REL_TYPE >> $MOSCRIPT
		 echo ')' >> $MOSCRIPT

         VAR=`expr $VAR + 1`
	 LOC_COUNT=`expr $LOC_COUNT + 1`
         TARGETCELLCOUNT=`expr $TARGETCELLCOUNT + 1`
         PRETARGETCELLCOUNT=`expr $PRETARGETCELLCOUNT + 1`

        TCOUNT=`expr $TCOUNT + 1`
      done

      TARGETRNCCOUNT=`expr $TARGETRNCCOUNT + 1`
    done

  else
    echo "...DO NOT CREATE ANY EXTERAL-RELATION FOR THIS CELL="$UTRANCELLID" ("$CID ")"
    echo " "
    echo "$SIMNAME:$0: MAKING MO SCRIPT ended at "`date`
    exit
  fi

	CID=`expr $CID + 1`
	CELLCOUNT=`expr $CELLCOUNT + 1`
	COUNT=`expr $COUNT + 1`

	# For testing. To quit ar required amount
	#if [ "$COUNT" -eq 2 ]
	#if [ "$COUNT" -eq 594 ]
	#if [ "$COUNT" -eq 6 ]
	#then
	#  break
	#    echo "bye"
	  #exit 1
	#fi

  done

echo ""
echo "$SIMNAME:$0: MAKING MO SCRIPT ended at "`date`


  #########################################
  #
  # Make MML Script
  #
  #########################################

  echo ""
  echo "MAKING MML SCRIPT"
  echo ""

  echo " External Cell Relations MML"
  echo '.open '$SIMNAME >> $MMLSCRIPT
  echo '.select '$RNCNAME >> $MMLSCRIPT
  echo '.start ' >> $MMLSCRIPT
  echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
  echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",commit_freq=operation;' >> $MMLSCRIPT

  /netsim/inst/netsim_shell < $MMLSCRIPT 

  rm $PWD/$MOSCRIPT
  rm $PWD/$MMLSCRIPT


else
  echo " DO NOT CREATE ANY EXTERAL-RELATION FOR "$RNCNAME

fi

fi #RUN MODE IF/ELSE

######################################################################################################
# END OF EXTERNAL RELATIONS
######################################################################################################

echo "...$SIMNAME:$0 script ended at "`date`
echo ""

