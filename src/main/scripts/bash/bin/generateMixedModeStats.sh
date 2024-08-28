#!/bin/sh
# Created by  : Harish Dunga
# Created in  : 09 03 2018
##
### VERSION HISTORY
########################################################
# Ver1        : Modified for ENM
# Purpose     : To check the number of network related
#               MOS generated in Mixed Mode nodes
# Description :
# Date        : 26 02 2018
# Who         : Harish Dunga
########################################################
if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <rnc num> <no. of mixedmode nodes>"
 echo
 echo "Example: $0 RNCV71659x1-FT-MSRBS17Bx10-RNC01 1 10"
 echo
 exit 1
fi

SIMNAME=$1
SIMNUM=$2
NUMOFNODES=$3
PWD=`pwd`
MMLSCRIPT="Dump.mml"
STATSFILE="Mixed_Mode_RNC_"$SIMNUM".csv"

if [ "$SIMNUM" -le 9 ]
then
RNCNAME="RNC0"$SIMNUM
else
RNCNAME="RNC"$SIMNUM
fi

if [ -f $PWD/$MMLSCRIPT ]
then
rm $PWD/$MMLSCRIPT
echo "old "$PWD/$MMLSCRIPT " removed"
fi

if [ -f $PWD/$STATSFILE ]
then
rm $PWD/$STATSFILE
echo "old "$PWD/$STATSFILE " removed"
fi

echo "NodeName,No_of_cells,ExtEnodeBCount,ExtEUtranCellCount,EUtranCellRelationCount,TermPointtoENBCount,ExtUtranCellCount,UtranCellRelationCount,ExtGeranCellCount,GeranCellRelationCount,ExtCdmaCellCount,Cdma2000CellRelationCount,ExtCdmaRtt20001xRttCellCount,Cdma2001xRttCellRelationCount,TotalMos" >> $STATSFILE


#####################################################
getStats()
{
MOFILE=$1
MOTYPE=$2
if [ "$MOTYPE" == "ALL" ]
then
   VALUE=`cat $MOFILE | grep "moType" |wc -l`
else
   VALUE=`cat $MOFILE | grep "moType Lrat:$MOTYPE" |wc -l`
fi
echo $VALUE
}
dumpStats()
{
 MOFILE=$1
 NodeName=$2
 No_of_cells=`getStats $MOFILE "EUtranCellFDD"`
 ExtEnodeBCount=`getStats $MOFILE "ExternalENodeBFunction"`
 ExtEUtranCellCount=`getStats $MOFILE "ExternalEUtranCellFDD"`
 EUtranCellRelationCount=`getStats $MOFILE "EUtranCellRelation"`
 TermPointtoENBCount=`getStats $MOFILE "TermPointToENB"`
 ExtUtranCellCount=`getStats $MOFILE "ExternalUtranCellFDD"`
 UtranCellRelationCount=`getStats $MOFILE "UtranCellRelation"`
 ExtGeranCellCount=`getStats $MOFILE "ExternalGeranCell"`
 GeranCellRelationCount=`getStats $MOFILE "GeranCellRelation"`
 ExtCdmaCellCount=`getStats $MOFILE "ExternalCdma2000Cell"`
 Cdma2000CellRelationCount=`getStats $MOFILE "Cdma2000CellRelation"`
 ExtCdmaRtt20001xRttCellCount=`getStats $MOFILE "ExternalCdma20001xRttCell"`
 Cdma2001xRttCellRelationCount=`getStats $MOFILE "Cdma20001xRttCellRelation"`
 TotalMos=`getStats $MOFILE "ALL"`
 echo "$NodeName,$No_of_cells,$ExtEnodeBCount,$ExtEUtranCellCount,$EUtranCellRelationCount,$TermPointtoENBCount,$ExtUtranCellCount,$UtranCellRelationCount,$ExtGeranCellCount,$GeranCellRelationCount,$ExtCdmaCellCount,$Cdma2000CellRelationCount,$ExtCdmaRtt20001xRttCellCount,$Cdma2001xRttCellRelationCount,$TotalMos" >> $STATSFILE
}
  
  
##############################################################################
COUNT=1
while [ "$COUNT" -le "$NUMOFNODES" ]
 do
 if [ "$COUNT" -le "9" ]
  then
     NODENAME=$RNCNAME"MSRBS-V20"$COUNT
  else
     NODENAME=$RNCNAME"MSRBS-V2"$COUNT
 fi
 MOSCRIPT=$NODENAME"_dump.mo"
 echo '.open '$SIMNAME >> $MMLSCRIPT
 echo '.select '$NODENAME >> $MMLSCRIPT
 echo '.start ' >> $MMLSCRIPT
 echo 'dumpmotree:moid=1,ker_out,outputfile="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
 ~/inst/netsim_shell < $MMLSCRIPT
 rm -rf $MMLSCRIPT
 
### read file data #######################################
 `dumpStats $MOSCRIPT $NODENAME`
 COUNT=`expr $COUNT + 1`
done
