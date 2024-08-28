#!/bin/sh

# Created by  : Harish Dunga
# Created in  : 02 05 2017
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : To add product data For Rnc Node
# Date        : 02 05 2017
# Who         : Harish Dunga
###########################################
SIM=$1
ENV=$2

. ../dat/$ENV
. utilityFunctions.sh

RncStr=(${SIM//RNC/ }) 
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM

#############################################################################
#Fetching the Product data of RNC node
#############################################################################

RNCMIM=$(echo $SIM | awk -F"RNC" '{print $2}' | awk -F"x" '{print $1}')"-lim"

IFS=";"

for x in $RNCPRODUCTARRAY
do

MIMVERSION=$(echo $x | awk -F"," '{print $1}')

if [ "$MIMVERSION" == "$RNCMIM" ]
then
RNCPRODNUMBER=$(echo $x | awk -F"," '{print $2}' | awk -F":" '{print $1}')
RNCPRODVERSION=$(echo $x | awk -F":" '{print $2}')
break

fi

done

if [ "$MIMVERSION" == "" ]
then
echo "No Mim found. Cannot load the product data"
echo "***********************The script ended erroneously !!!*************************************"
exit 1
fi

echo "Mim version of $RNCNAME node : $MIMVERSION"
echo  "RNC product number : $RNCPRODNUMBER"
echo "RNC product version : $RNCPRODVERSION"


#########################################
#
# Make M0 Script
#
#########################################

NOW=`date +"%Y_%m_%d_%T:%N"`
MOSCRIPT=$RNCNAME"_productData.mo"

if [ -s $MOSCRIPT ]
then
echo "Removing old moscripts"
rm -rf $MOSCRIPT
fi

cat > $MOSCRIPT <<EOF
SET
(
    mo "ManagedElement=1,SwManagement=1,UpgradePackage=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 5
        "productNumber" String "$RNCPRODNUMBER"
        "productRevision" String "$RNCPRODVERSION"
        "productName" String "SwVersion"
        "productionDate" String "$NOW"
        "productInfo" String ""	
)
EOF


#########################################
#
# Make MML Script
#
#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""

MMLSCRIPT=$RNCNAME"_productData.mml"

if [ -s $MMLSCRIPT ]
then
echo "Removing Old mmlscripts"
rm -rf $MMLSCRIPT
fi

echo '.open '$SIM >> $MMLSCRIPT
echo '.select RNC'$RNCNUM >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD/$MOSCRIPT'";' >> $MMLSCRIPT

~/inst/netsim_shell < $MMLSCRIPT
rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT

echo "***********************The script ended execution*************************************"
