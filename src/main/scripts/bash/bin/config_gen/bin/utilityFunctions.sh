#!/bin/sh

WDIR=`pwd`
. $WDIR/../etc/config_gen.env


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
#END

getStnStart() # RNCCOUNT RNCRBSARRAY RBSCELLARRAY
{

RNCCOUNT=$1
STNCLUSTERARRAY=$2

IFS=";"
for x in $STNCLUSTERARRAY
do

if [ $RNCCOUNT -eq `echo $x | awk -F- '{print $1}'` ]
then
var=`echo $x | awk -F- '{print $2}'`
echo $var

  fi
done;
}
getStnEnd() # RNCCOUNT RNCRBSARRAY RBSCELLARRAY
{

RNCCOUNT=$1
STNCLUSTERARRAY=$2

IFS=";"
for x in $STNCLUSTERARRAY
do

if [ $RNCCOUNT -eq `echo $x | awk -F- '{print $1}'` ]
then
var=`echo $x | awk -F- '{print $3}'`
echo $var

  fi
done;
}


function setRNCconfig # RNCNUMBER rnc_quart2 rnc_default_router0_1 rnc_default_router0_2 rnc_own_ip_address_1 rnc_subnet rnc_own_ip_address_2
{
RNCNUMBER=$1 
rnc_quart2=$2 
rnc_default_router0_1=$3 
rnc_default_router0_2=$4 
rnc_own_ip_address_1=$5 
rnc_subnet=$6 
rnc_own_ip_address_2=$7

sed "s/<<RNCNUM>>/$RNCNUMBER/g" $CONFIGDIR/rnc_template | sed "s/<<rnc_quart2>>/$rnc_quart2/g" | sed "s/<<rnc_default_router0_1>>/$rnc_default_router0_1/g" | sed "s/<<rnc_default_router0_2>>/$rnc_default_router0_2/g" | sed "s/<<rnc_IPaddress>>/$rnc_own_ip_address_1/g" | sed "s/<<rnc_subnet>>/$rnc_subnet/g" | sed "s/<<rnc_IPaddrerss_2>>/$rnc_own_ip_address_2/g" > rnc_template_parsed

}

function createIPRouter # $IPROUTERNAME1 iprouter_temp_1
{
IPROUTERNAME1=$1
sed "s/<<NAME1>>/$IPROUTERNAME1/g" $CONFIGDIR/iprouter1.xml >> $2;
}



function setSTNconfig 
{
wan_oam_1=$1  
STNINTERANLCOUNT=$2 
wan_oam_2=$3 
wan_iub_1=$4 
address_quart_3=$5 
address_quart_2=$6 
defaultRouter0_2=$7 
defaultRouter0_1=$8 
wan_iub_2=$9
filename=$10

echo "$filename is a here"
sed "s/<<wan_oam_1>>/$wan_oam_1/g" stn_tempfile$STNINTERANLCOUNT | sed "s/<<wan_oam_2>>/$wan_oam_2/g" | sed "s/<<wan_iub_1>>/$wan_iub_1/g" | sed "s/<<address_quart_3>>/$address_quart_3/g" | sed "s/<<address_quart_2>>/$address_quart_2/g" | sed "s/<<defaultrouter_no_2>>/$defaultRouter0_2/g" | sed "s/<<defaultrouter_no_1>>/$defaultRouter0_1/g" | sed "s/<<wan_iub_2>>/$wan_iub_2/g" >> stntemporary 
}

function setVLANconfig 
{
VLANID1=$1 
STNNAME=$2 
VLANID2=$3 
VLANID3=$4 
VLANID4=$5

sed "s/<<WAN_OAM_1_TAG>>/$VLANID1/g" $CONFIGDIR/stn_template_vlantag | sed "s/<<STN_SIU>>/$STNNAME/g" | sed "s/<<WAN_OAM_2_TAG>>/$VLANID2/g" | sed "s/<<WAN_IUB_1_TAG>>/$VLANID3/g" | sed "s/<<WAN_IUB_2_TAG>>/$VLANID4/g" >> output_for_vlan
}

function setSTNNANE
{
STNNAME=$1
STNINTERANLCOUNT=$2
sed "s/<<STN_SIU>>/$STNNAME/g" $CONFIGDIR/stn_template > stn_tempfile$STNINTERANLCOUNT
}


function setSTNCluster1
{
wan_oam_1=$1
STNINTERANLCOUNT=$2
wan_oam_2=$3
wan_iub_1=$4
address_quart_3=$5
address_quart_2=$6
defaultRouter0_2=$7
defaultRouter0_1=$8
wan_iub_2=$9

sed "s/<<wan_oam_1>>/$wan_oam_1/g" stn_tempfile$STNINTERANLCOUNT | sed "s/<<wan_oam_2>>/$wan_oam_2/g" | sed "s/<<wan_iub_1>>/$wan_iub_1/g" | sed "s/<<address_quart_3>>/$address_quart_3/g" | sed "s/<<address_quart_2>>/$address_quart_2/g" | sed "s/<<defaultrouter_no_2>>/$defaultRouter0_2/g" | sed "s/<<defaultrouter_no_1>>/$defaultRouter0_1/g" | sed "s/<<wan_iub_2>>/$wan_iub_2/g" >> stn_template_parsed$STNINTERANLCOUNT
}

function setSTNCluster2
{

address_quart_3=$1
STNINTERANLCOUNT=$2
address_quart_2=$3
defaultRouter0_2=$4
defaultRouter0_1=$5
sed "s/<<2address_quart_3>>/$address_quart_3/g" stn_template_parsed$STNINTERANLCOUNT | sed "s/<<2address_quart_2>>/$address_quart_2/g" | sed "s/<<2defaultrouter_no_2>>/$defaultRouter0_2/g" | sed "s/<<2defaultrouter_no_1>>/$defaultRouter0_1/g"  > stntemporary
}

function setSTNCluster3
{
address_quart_3=$1
STNINTERANLCOUNT=$2
address_quart_2=$3
defaultRouter0_2=$4
defaultRouter0_1=$5

sed "s/<<3address_quart_3>>/$address_quart_3/g" stn_template_parsed$STNINTERANLCOUNT | sed "s/<<3address_quart_2>>/$address_quart_2/g" | sed "s/<<3defaultrouter_no_2>>/$defaultRouter0_2/g" | sed "s/<<3defaultrouter_no_1>>/$defaultRouter0_1/g"  > stntemporary

}

function setSTNCluster4
{
address_quart_3=$1
STNINTERANLCOUNT=$2
address_quart_2=$3
defaultRouter0_2=$4
defaultRouter0_1=$5

sed "s/<<4address_quart_3>>/$address_quart_3/g" stn_template_parsed$STNINTERANLCOUNT | sed "s/<<4address_quart_2>>/$address_quart_2/g" | sed "s/<<4defaultrouter_no_2>>/$defaultRouter0_2/g" | sed "s/<<4defaultrouter_no_1>>/$defaultRouter0_1/g"  > stntemporary
}

function setSTNCluster5
{
address_quart_3=$1
STNINTERANLCOUNT=$2
address_quart_2=$3
defaultRouter0_2=$4
defaultRouter0_1=$5

sed "s/<<5address_quart_3>>/$address_quart_3/g" stn_template_parsed$STNINTERANLCOUNT | sed "s/<<5address_quart_2>>/$address_quart_2/g" | sed "s/<<5defaultrouter_no_2>>/$defaultRouter0_2/g" | sed "s/<<5defaultrouter_no_1>>/$defaultRouter0_1/g"  > stntemporary
}

function setSTNCluster6
{
address_quart_3=$1
STNINTERANLCOUNT=$2
address_quart_2=$3
defaultRouter0_2=$4
defaultRouter0_1=$5

sed "s/<<6address_quart_3>>/$address_quart_3/g" stn_template_parsed$STNINTERANLCOUNT | sed "s/<<6address_quart_2>>/$address_quart_2/g" | sed "s/<<6defaultrouter_no_2>>/$defaultRouter0_2/g" | sed "s/<<6defaultrouter_no_1>>/$defaultRouter0_1/g"  > stntemporary
}

function setSTNCluster7
{
address_quart_3=$1
STNINTERANLCOUNT=$2
address_quart_2=$3
defaultRouter0_2=$4
defaultRouter0_1=$5

sed "s/<<7address_quart_3>>/$address_quart_3/g" stn_template_parsed$STNINTERANLCOUNT | sed "s/<<7address_quart_2>>/$address_quart_2/g" | sed "s/<<7defaultrouter_no_2>>/$defaultRouter0_2/g" | sed "s/<<7defaultrouter_no_1>>/$defaultRouter0_1/g"  > stntemporary

}

















