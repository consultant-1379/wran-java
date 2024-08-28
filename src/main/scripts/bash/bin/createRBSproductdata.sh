#!/bin/sh

# Created by  : Harish Dunga
# Created in  : 02 05 2017
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : To add product data For Rbs Nodes
# Date        : 02 05 2017
# Who         : Harish Dunga
###########################################
SIM=$1
ENV=$2

if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0 <sim name> <envfile>"
 echo
 echo "Example: $0 RNCV81349x1-FT-MSRBS-17Bx466-RNC10 NRM3_60KG1.env"
 echo
 exit 1
fi

. ../dat/$ENV
. utilityFunctions.sh
#############################################################################
#Fetching the Product data of RBS node
#############################################################################

RbsStr=$(echo $SIM | awk -F"RBS" '{print $2}'| awk -F"x" '{print $2}')
RBSNUM=(${RbsStr//-/ })
RncStr=(${SIM//RNC/ }) 
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM
RBSMIM=$(echo $SIM | awk -F"RBS" '{print $2}' | awk -F"x" '{print $1}')"-lim"

IFS=";"

for x in $RBSPRODUCTARRAY
do

MIMVERSION=$(echo $x | awk -F"," '{print $1}')

if [ "$MIMVERSION" == "$RBSMIM" ]
then
RBSPRODNUMBER=$(echo $x | awk -F"," '{print $2}' | awk -F":" '{print $1}')
RBSPRODVERSION=$(echo $x | awk -F":" '{print $2}')
break

fi

done

if [ "$MIMVERSION" == "" ]
then
echo "No Mim found. Cannot load the product data"
echo "***********************The script ended erroneously !!!*************************************"
exit 1
fi

echo "Mim version of RBS nodes in $SIM : $MIMVERSION"
echo "RBS product number : $RBSPRODNUMBER"
echo "RBS product version : $RBSPRODVERSION"

NOW=`date +"%Y_%m_%d_%T:%N"`
MOSCRIPT=$RNCNAME"RBS_productData.mo"

if [ -s $MOSCRIPT ]
then
echo "Removing old moscripts"
rm -rf $MOSCRIPT
fi
########################################
#Making MOSCRIPT
########################################
cat > $MOSCRIPT <<EOF
CREATE
(
    parent "ManagedElement=1,Equipment=1"
    identity "CABID_7"
    moType Cabinet
    exception none
    nrOfAttributes 11
    "productData" Struct
        nrOfElements 5
        "productionDate" String "$NOW"
        "productName" String ""
        "productNumber" String "$RBSPRODNUMBER"
        "productRevision" String "$RBSPRODVERSION"
        "serialNumber" String ""

    "climateSystem" Integer 0
    "reservedBy" Array Ref 0
    "smokeDetector" Boolean false
    "climateControlMode" Integer 0
    "climateRegulationSystem" Integer 0
    "positionRef" Ref "null"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,UpgradePackage=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 5
        "productNumber" String "$RBSPRODNUMBER"
        "productRevision" String "$RBSPRODVERSION"
        "productName" String "SwVersion"
        "productionDate" String "$NOW"
        "productInfo" String ""	
)
EOF

#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""
MMLSCRIPT=$RNCNAME"RBS_productData.mml"

if [ -s $MMLSCRIPT ]
then
echo "Removing Old mmlscripts"
rm -rf $MMLSCRIPT
fi

COUNT=1
while [ $COUNT -le $RBSNUM  ]
do
echo '.open '$SIM >> $MMLSCRIPT
if [ $COUNT -le 9 ]
then
echo '.select '$RNCNAME'RBS0'$COUNT >> $MMLSCRIPT
else
echo '.select '$RNCNAME'RBS'$COUNT >> $MMLSCRIPT
fi
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD/$MOSCRIPT'";' >> $MMLSCRIPT
COUNT=`expr $COUNT + 1`
done

~/inst/netsim_shell < $MMLSCRIPT

rm -rf $MOSCRIPT
rm -rf $MMLSCRIPT

echo "************************The script ended execution*****************************************"
