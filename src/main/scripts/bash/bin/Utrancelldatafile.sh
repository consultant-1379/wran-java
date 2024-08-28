#!/bin/sh

COUNT=$3
ENV=$2
SIM=$1

if [ "$#" -ne 3  ]
then
 echo "   !!!  FAILED: Incorrect or Insufficient Inputs   !!!"
 echo
 echo "Please make sure the inputs are given in the below order"
 echo
 echo "Usage: $0 <sim name> <env file> <rnc num>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4340x550-RNC13 15K.env 13"
 echo
 exit 1
fi
. ../dat/$ENV

UTRANCELLFILE=$SIM"_UtranCell.txt"
#Network="5k"
Simdir=$HOME/netsimdir/$SIM/
#echo "$Simdir"
cd $Simdir
SimRev=$Simdir/"SimNetRevision"
#cd ~/$SimNetRevision
echo "SIMREV: $SimRev"
if [ -d "$SimRev" ];
then 
echo "The directory $SimRev already exists. Removing the old one and creating a new one."
rm -rf "$SimRev"
#echo "$SimRev"
mkdir SimNetRevision
cd SimNetRevision
#touch UtranCell.txt
else
echo "The directory $SimRev does not exist. Creating the directory."
mkdir SimNetRevision
cd SimNetRevision
touch UtranCell.txt
fi
UTRANCELLPATH="$SimRev"
cd ~/simnet/wran/bin
if [ -f "$UTRANCELLFILE" ]
   then
   echo "Old Utran Cell data of the sim $SIM already exists. Removing it and creating a new one ..."
   rm -rf $UTRANCELLFILE
else
   echo "      ** Creating Utran Cell data of the sim $SIM **"
fi

if [ "$Network" == "5k" ];
then
./createUtranCell_DATA_For_WRAN5k.sh $3 $3 >> $UTRANCELLFILE
cp -r $UTRANCELLFILE "$UTRANCELLPATH"
elif [ "$Network" == "15k" ]
then
./createUtranCell_DATA_For_WRAN15k.sh $3 $3 >> $UTRANCELLFILE
cp -r $UTRANCELLFILE "$UTRANCELLPATH"
else
./createUtranCell_DATA_For_WRAN60k.sh $3 $3 >> $UTRANCELLFILE
cp -r $UTRANCELLFILE "$UTRANCELLPATH"
fi

if [ -s $UTRANCELLFILE ]
then
      echo "## Utrancell File is successfully created.. ##"
      echo
else
      echo "**** FAILED:The UtranCell File has not been created properly ...!!!! ****"
      exit 1
fi

cd $UTRANCELLPATH
mv $UTRANCELLFILE UtranCell.txt

cd ~/simnet/wran/bin
./rbslocal.sh $SIM $UTRANCELLFILE

echo

cd $UTRANCELLPATH

if [ -s "RbsLocalCellData.txt" ]
then
    echo "## RbsLocalCellData is successfully created .. ##"
else
    echo "**** FAILED:The RbsLocalCell File has not been created properly ...!!!! ****"
fi
