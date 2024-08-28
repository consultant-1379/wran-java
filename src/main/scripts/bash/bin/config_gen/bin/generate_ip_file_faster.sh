#!/bin/bash
##################################################################
# Ver1: Created for  to generate ICON config file
# Author: Gordon Morrow
# Description: To create the MO'd used by ICON configuration
# Date 17/07/2012
##################################################################

if [ "$#" -ne 0  ]
then
 echo
 echo "Usage: $0 <rbs/stn number> \n "
 echo
 echo "Example: $0 70 (to create file for 1 RNC and 70 RBS and 70 STN)"
 echo
 exit 1
fi

#Below I am loading the utility functions used and also configuration files

WDIR=`pwd`
OUTPUTDIR=$WDIR/../output
CONFIGDIR=$WDIR/../etc
. $CONFIGDIR/O13-ST-13A-40K.env
. $WDIR/utilityFunctions.sh
. $WDIR/config_gen_function.sh

RNCCOUNT=$RNCIPSTART
TOTAL_RBS_ON_RNC=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY` # This will give the number of RBS under each RNC
RBS_NUM=1
start_of_subnet1=0; end_of_subnet1=0; start_of_subnet2=0; end_of_subnet2=0; nodeIpAddress=0; defaultRouter0_1=0; IpAccessHostEt=0; defaultRouter0_2=0; subnet_1=0; subnet_2=0; rnc_default_router0_1=1; rnc_default_router0_2=2; rnc_subnet=0; rnc_own_ip_address_1=3; rnc_own_ip_address_2=4; rnc_quart2=0; IPROUTERNAME1=0; IPROUTERNAME2=0
SIUOVER=0
let end_of_subnet1=$start_of_subnet1+3; let start_of_subnet2=$start_of_subnet1+4; let end_of_subnet2=$start_of_subnet2+3; address_quart_2=0; address_quart_3=0
let IPROUTERNAME2=2; let IPROUTERNAME1=1

cat $CONFIGDIR/ip_header > iprouter_temp_1 # Placing the xml header at start of IPRouter config file to be used by testgen to import to OSS
cat $CONFIGDIR/ip_header > iprouter_temp_2


while [ $RNCCOUNT -le $RNCIPEND ] ; do # while loop to loop through RNC start and RNC end as specified in config file

# Below is an if statement to evenly distribute the IPRouters throughout the network
# once the IPRouters reaches 40 it will relate the next RNC back to IPRouter1

if [ $IPROUTERNAME2 -le 40 ]
then
echo "IPROUTER 1 and 2 are $IPROUTERNAME1 and $IPROUTERNAME2"
elif [ $IPROUTERNAME2 -ge 41 ]
then
    let IPROUTERNAME2=2
    let IPROUTERNAME1=1
echo "IPROUTER 1 and 2 are $IPROUTERNAME1 and $IPROUTERNAME2"
fi

STNINTERANLCOUNT=0
STNSTARTCLUSTER=`getStnStart $RNCCOUNT $STNCLUSTERARRAY`
STNENDCLUSTER=`getStnEnd $RNCCOUNT $STNCLUSTERARRAY` # The number of STN to be configured per RBS is taken from a config file
STNCURRENT=1
let STNINTERANLCOUNT=$STNSTARTCLUSTER
TOTAL_RBS_ON_RNC=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
echo "$TOTAL_RBS_ON_RNC is number of RBS nodes"

# if statement below to ensure 0 is added to RNC name to match OSS naming convention
    if [ "$RNCCOUNT" -le 9 ]
    then
            RNCNUMBER=0$RNCCOUNT
    elif [ "$RNCCOUNT" -ge 10 ]
    then
            RNCNUMBER=$RNCCOUNT
    fi
#Below is parsing the rnc_template file and populating the ipaddresses for these
setRNCconfig $RNCNUMBER $rnc_quart2 $rnc_default_router0_1 $rnc_default_router0_2 $rnc_own_ip_address_1 $rnc_subnet $rnc_own_ip_address_2

#Handling the iprouter part of the rnc outside of the box also will place in later
# need to insert logic here to work with 40k

if [ ! -e ./ip_router_$IPROUTERNAME1.xml ];then
createIPRouter $IPROUTERNAME1 iprouter_temp_1
fi

if [ ! -e ./ip_router_$IPROUTERNAME2.xml ];then
createIPRouter $IPROUTERNAME2 iprouter_temp_2
fi

#### Needs to be updated when moving to 40k Rollout
VLANID1=1; VLANID2=2; VLANID3=3; VLANID4=4
VLANINDEX0=0; VLANINDEX1=1;

##### End hardcoding
while [ $RBS_NUM -le $TOTAL_RBS_ON_RNC ];do # while loop to go up as far as user needs
#Below to just make sure the correct number of 0's are after the RBS
if [ $RBS_NUM -le 9 ];then
num=0$RBS_NUM
else
num=$RBS_NUM
fi

# Assigning the values of all variables here:
let IpAccessHostEt=$start_of_subnet2+2
let nodeIpAddress=$start_of_subnet1+2
let defaultRouter0_1=$start_of_subnet1+1
let defaultRouter0_2=$start_of_subnet2+1

#Special handling for SITE_LAN_8 may need to change this for larger network as these will always have ipaddress .57 .61 .65 .69 or .129 .133 .137 .141 or .201 .205 .209 .213
if [ $defaultRouter0_1 -le 71 ]
then
wan_oam_1=57; wan_oam_2=61; wan_iub_1=65; wan_iub_2=69; ip_wan_oam_1=58; ip_wan_oam_2=62; ip_wan_iub_1=66; ip_wan_iub_2=70
elif [ $defaultRouter0_1 -le 143 ]
then
wan_oam_1=129; wan_oam_2=133; wan_iub_1=137; wan_iub_2=141; ip_wan_oam_1=130; ip_wan_oam_2=134; ip_wan_iub_1=138; ip_wan_iub_2=142
else 
wan_oam_1=201; wan_oam_2=205; wan_iub_1=209; wan_iub_2=213; ip_wan_oam_1=202; ip_wan_oam_2=206; ip_wan_iub_1=210; ip_wan_iub_2=214
fi

sed "s/<<RBSNUM>>/$num/g" $CONFIGDIR/rbs_template > tempfile 


# Handling the STN differently as these must loop around as only a certain numbr of SIU's per RNC and group of RBS
# STN number is set at start of RNC loop
if [ $STNINTERANLCOUNT -le 9 ]; then
STNNAME=0$STNINTERANLCOUNT
else
STNNAME=$STNINTERANLCOUNT
fi

if [[ ($STNINTERANLCOUNT -lt $STNENDCLUSTER) && ($STNCURRENT -eq 1) ]]; then
echo "IF state 1"
setSTNNANE $STNNAME 
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stn_template_parsed$STNINTERANLCOUNT
setVLANconfig $VLANID1 $STNNAME $VLANID2 $VLANID3 $VLANID4
let STNINTERANLCOUNT=$STNINTERANLCOUNT+1

elif [[ ($STNINTERANLCOUNT -eq $STNENDCLUSTER) && ($STNCURRENT -eq 1) ]]; then
setSTNNANE $STNNAME
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stn_template_parsed$STNINTERANLCOUNT
setVLANconfig $VLANID1 $STNNAME $VLANID2 $VLANID3 $VLANID4

let STNCURRENT=2
let STNINTERANLCOUNT=$STNSTARTCLUSTER

elif [[ ($STNINTERANLCOUNT -lt $STNENDCLUSTER) && ($STNCURRENT -eq 2)  ]]; then
echo "IF state 2"
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNINTERANLCOUNT+1
elif [[ ($STNINTERANLCOUNT -eq $STNENDCLUSTER) && ($STNCURRENT -eq 2)  ]]; then
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNSTARTCLUSTER
let STNCURRENT=3

elif [[ ($STNINTERANLCOUNT -lt $STNENDCLUSTER) && ($STNCURRENT -eq 3)  ]]; then
echo "IF state 3"
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNINTERANLCOUNT+1
elif [[ ($STNINTERANLCOUNT -eq $STNENDCLUSTER) && ($STNCURRENT -eq 3)  ]]; then
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNSTARTCLUSTER
let STNCURRENT=4

elif [[ ($STNINTERANLCOUNT -lt $STNENDCLUSTER) && ($STNCURRENT -eq 4)  ]]; then
etSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
at stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNINTERANLCOUNT+1
elif [[ ($STNINTERANLCOUNT -eq $STNENDCLUSTER) && ($STNCURRENT -eq 4)  ]]; then
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNSTARTCLUSTER
let STNCURRENT=5

elif [[ ($STNINTERANLCOUNT -lt $STNENDCLUSTER) && ($STNCURRENT -eq 5)  ]]; then
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNINTERANLCOUNT+1
elif [[ ($STNINTERANLCOUNT -eq $STNENDCLUSTER) && ($STNCURRENT -eq 5)  ]]; then
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNSTARTCLUSTER
let STNCURRENT=6

elif [[ ($STNINTERANLCOUNT -lt $STNENDCLUSTER) && ($STNCURRENT -eq 6)  ]]; then
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNINTERANLCOUNT+1
elif [[ ($STNINTERANLCOUNT -eq $STNENDCLUSTER) && ($STNCURRENT -eq 6)  ]]; then
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNSTARTCLUSTER
let STNCURRENT=7

elif [[ ($STNINTERANLCOUNT -le $STNENDCLUSTER) && ($STNCURRENT -eq 7)  ]]; then
setSTNconfig $wan_oam_1 $STNINTERANLCOUNT $wan_oam_2 $wan_iub_1 $address_quart_3 $address_quart_2 $defaultRouter0_2 $defaultRouter0_1 $wan_iub_2 stntemporary
cat stntemporary > stn_template_parsed$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNINTERANLCOUNT+1
fi

#### Below is the IPRouter configuration which is slightly different to the other as this will generate an xml file to be imported by test gen on OSS.
# as in ELINE there are 2 IPRouters in we will configure thse below:

# number 1
sed "s/<<VLANID1>>/$VLANID1/g" $CONFIGDIR/ports_1.xml | sed "s/<<VLANID3>>/$VLANID3/g" | sed "s/<<IPADDRESSwan_oam_1_ip>>/$ip_wan_oam_1/g" | sed "s/<<IPADDRESSwan_iub_1_ip>>/$ip_wan_iub_1/g" | sed "s/<<VLANINDEX1>>/$VLANINDEX1/g" | sed "s/<<address_quart_3>>/$address_quart_3/g" | sed "s/<<address_quart_2>>/$address_quart_2/g" | sed "s/<<VLANINDEX0>>/$VLANINDEX0/g" | sed "s/<<RNCNAME>>/$RNCNUMBER/g" | sed "s/<<RBSNAME>>/$num/g" >> iprouter_temp_1

# number 2
sed "s/<<VLANID2>>/$VLANID2/g" $CONFIGDIR/ports_2.xml | sed "s/<<VLANID4>>/$VLANID4/g" | sed "s/<<IPADDRESSwan_oam_1_ip>>/$ip_wan_oam_2/g" | sed "s/<<IPADDRESSwan_iub_1_ip>>/$ip_wan_iub_2/g" | sed "s/<<VLANINDEX0>>/$VLANINDEX0/g" | sed "s/<<VLANINDEX1>>/$VLANINDEX1/g" | sed "s/<<address_quart_3>>/$address_quart_3/g" | sed "s/<<address_quart_2>>/$address_quart_2/g" | sed "s/<<RNCNAME>>/$RNCNUMBER/g" | sed "s/<<RBSNAME>>/$num/g" >> iprouter_temp_2

# Below is handling the RBS ips
sed "s/<<address_quart_2>>/$address_quart_2/g" tempfile |sed "s/<<address_quart_3>>/$address_quart_3/g" | sed "s/<<RNCNUM>>/$RNCNUMBER/g" | sed "s/<<nodeIPaddress>>/$nodeIpAddress/g" | sed "s/<<defaultrouter_no_1>>/$defaultRouter0_1/g" | sed "s/<<subnet_1>>/$start_of_subnet1/g" | sed "s/<<subnet_2>>/$start_of_subnet2/g" | sed "s/<<IP_Access_host_ET>>/$IpAccessHostEt/g" | sed "s/<<defaultrouter_no_2>>/$defaultRouter0_2/g" >> rbs_template_parsed
let RBS_NUM=$RBS_NUM+1
if [ $end_of_subnet2 -ge 130 ] ######### START IF
then
start_of_subnet1=0; end_of_subnet1=0; start_of_subnet2=0; end_of_subnet2=0
let end_of_subnet1=$start_of_subnet1+3; let start_of_subnet2=$start_of_subnet1+4; let end_of_subnet2=$start_of_subnet2+3
if [ $address_quart_2 -ge 254 ]
then
    address_quart_2=0
    let address_quart_3=$address_quart_3+1
else
let address_quart_2=$address_quart_2+1
fi
else #Incrementing by 72 as this is the number of IP addresses used by SITE_LAN's 1 to 8
let start_of_subnet2=$start_of_subnet2+72; let end_of_subnet2=$end_of_subnet2+72; let start_of_subnet1=$start_of_subnet1+72; let end_of_subnet1=$end_of_subnet1+72
fi #######END IF

#### missed the vlantag so inserting here

################### Hardcoded IPRouter
let VLANID1=$VLANID1+4; let VLANID2=$VLANID2+4; let VLANID3=$VLANID3+4; let VLANID4=$VLANID4+4; let VLANINDEX0=$VLANINDEX0+2; let VLANINDEX1=$VLANINDEX1+2

done

RBS_NUM=1


# Sorting all the files together now
cat rbs_template_parsed >> rnc_template_parsed 
STNINTERANLCOUNT=0
STNSTARTCLUSTER=`getStnStart $RNCCOUNT $STNCLUSTERARRAY`
STNENDCLUSTER=`getStnEnd $RNCCOUNT $STNCLUSTERARRAY`
let STNINTERANLCOUNT=$STNSTARTCLUSTER

while [ $STNINTERANLCOUNT -le $STNENDCLUSTER ]
do
cat stn_template_parsed$STNINTERANLCOUNT >> rnc_template_parsed
rm stn_template_parsed$STNINTERANLCOUNT
rm stn_tempfile$STNINTERANLCOUNT
let STNINTERANLCOUNT=$STNINTERANLCOUNT+1
done

cat rnc_template_parsed >> rnc_rbs_stn_templates_parsed
rm rnc_template_parsed rbs_template_parsed
RNCCOUNT=`expr $RNCCOUNT + 1`
sed "s/<<defaultrouter_no_1>>/$rnc_default_router0_1/g" $CONFIGDIR/ports_1_rncend.xml | sed "s/<<RNCNAME>>/$RNCNUMBER/g" |sed "s/<<rnc_quart2>>/$rnc_quart2/g"  >> ip_router_rnc_ends_$IPROUTERNAME1

cat iprouter_temp_1 >> ip_router_$IPROUTERNAME1.xml

cat iprouter_temp_2 >> ip_router_$IPROUTERNAME2.xml
sed "s/<<defaultrouter_no_2>>/$rnc_default_router0_2/g" $CONFIGDIR/ports_2_rncend.xml | sed "s/<<RNCNAME>>/$RNCNUMBER/g" | sed "s/<<rnc_quart2>>/$rnc_quart2/g" >> ip_router_rnc_ends_$IPROUTERNAME2
let IPROUTERNAME2=$IPROUTERNAME2+2
let IPROUTERNAME1=$IPROUTERNAME1+2
rm iprouter_temp_1 iprouter_temp_2
if [ $rnc_default_router0_1 -eq 1 ]
then
    let rnc_default_router0_1=129
    let rnc_default_router0_2=130
    let rnc_own_ip_address_1=131
    let rnc_own_ip_address_2=132
    let rnc_subnet=128
else 
    let rnc_default_router0_1=1
    let rnc_default_router0_2=2
    let rnc_own_ip_address_1=3
    let rnc_own_ip_address_2=4
    let rnc_subnet=0
    let rnc_quart2=$rnc_quart2+1
fi
done

cat $CONFIGDIR/rnc_template_header > ip_config_file.csv
cat $CONFIGDIR/rbs_header >> ip_config_file.csv
cat $CONFIGDIR/stn_header >> ip_config_file.csv
cat rnc_rbs_stn_templates_parsed >> ip_config_file.csv
mv ip_config_file.csv $OUTPUTDIR/ip_config_file.csv
var=1
while [ $var -le 40 ]
do
cat ip_router_rnc_ends_$var >> ip_router_$var.xml
rm ip_router_rnc_ends_$var
echo "</port>" >> ip_router_$var.xml
cat $CONFIGDIR/ip_footer >> ip_router_$var.xml
mv ip_router_$var.xml $OUTPUTDIR/ip_router_$var.xml
let var=$var+1
done

rm tempfile rnc_rbs_stn_templates_parsed stntemporary stn_template_parsed0 stn_tempfile0
