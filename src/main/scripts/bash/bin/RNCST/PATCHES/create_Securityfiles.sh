#!/bin/sh

# Created by  : ereshre
# Created in  : 17 Apr 12
##
### VERSION HISTORY
# Ver1        : Created for Uncompress and start the simulation
# Purpose     :
# Description :
# Date        : 17.04.2012
# Who         : Reshma

if [ "$#" -ne 0  ]
then
cat<<HELP

Usage: $0 

Example: $0 

DESC   :

CONFIG FILE DETAILS has be configured as per the netsim and the nodes on that.
HELP
 exit 1
fi

#***************************************************************************************************************************
#									CONFIG FILE DETAILS							
#***************************************************************************************************************************
#LOC_SERVERS="netsimlin353"
#LOC_SERVERS="netsimlin353 netsimlin354 netsimlin355 netsimlin305 netsimlin378 netsimlin306 netsimlin383 netsimlin384 netsimlin285 netsimlin503"
LOC_SERVERS="netsimlin354 netsimlin355 netsimlin378"
netsimlin353_list="RNC01 RNC02 RNC03 RNC04 RNC05 RNC06 RNC07 RNC08 RNC09 RNC10 RNC11 RNC12 RNC13 RNC14 RNC15 RNC16"
netsimlin354_list="RNC17 RNC18 RNC19 RNC20 RNC21 RNC22 RNC23 RNC24 RNC25 RNC26 RNC27 RNC28 RNC29 RNC30 RNC31 RNC32"
netsimlin355_list="RNC33 RNC34 RNC35 RNC36 RNC37 RNC38 RNC39 RNC40 RNC41 RNC42 RNC43 RNC44 RNC45 RNC46 RNC47 RNC48"
netsimlin305_list="RNC49 RNC50 RNC51 RNC52 RNC53 RNC54 RNC55 RNC56 RNC57 RNC58 RNC59 RNC60 RNC61 RNC62 RNC63 RNC64 RNC65 RNC66 RNC67 RNC68"
netsimlin378_list="RNC69 RNC70 RNC71 RNC72 RNC73 RNC74 RNC75 RNC76 RNC77 RNC78 RNC79 RNC80 RNC81 RNC82 RNC83 RNC84 RNC85 RNC86 RNC87 RNC88"
netsimlin306_list="RNC89 RNC90 RNC91 RNC92 RNC93 RNC94 RNC95 RNC96 RNC97 RNC98"
netsimlin383_list="RNC99 RNC100 RNC101 RNC102 RNC103 RNC104 RNC151 RNC201 RNC203"
netsimlin384_list="RNC105 RNC106"
netsimlin285_list="RNC107 RNC108"
netsimlin503_list="RNC109"


#***************************************************************************************************************************


 
for SERVER in $LOC_SERVERS
do
  LIST=`eval echo '$'${SERVER}_list`
  if [ "$LIST" == "" ]
  then
    echo "  $SERVER doesn't have any list"
    continue
  else
    echo "LIST="$LIST
  fi
  echo "#############################"
  echo "Executing Script on "$SERVER
  echo "#############################"
	
  for RNC in $LIST
  do
    echo "RNC= " $RNC
		
    RNCSIMNAME=`/usr/bin/rsh -n -l netsim $SERVER "/bin/ls -d /netsim/netsimdir/*$RNC | cut -d'/' -f4"`
    echo "RNCSIMNAME:"$RNCSIMNAME
    ssl_file="atrcxb2651"$RNC"IEdef"
		
    MMLSCRIPT=$0".mml"

    #########################################
    # 
    # Make MML Script
    #
    #########################################
    echo ""
    echo "MAKING MML SCRIPT"
    echo ""

    echo '.open '$RNCSIMNAME >> $MMLSCRIPT
    echo '.select configuration ' >> $MMLSCRIPT
    echo ".setssliop createormodify atrcxb1311"$RNC"IEdef" >> $MMLSCRIPT
    echo ".setssliop description Security Files" >> $MMLSCRIPT
    echo ".setssliop clientverify 0" >> $MMLSCRIPT
    echo ".setssliop clientdepth 1" >> $MMLSCRIPT
    echo ".setssliop serververify 0" >> $MMLSCRIPT
    echo ".setssliop serverdepth 1" >> $MMLSCRIPT
    echo ".setssliop protocol_version sslv2|sslv3|tlsv1" >> $MMLSCRIPT
    echo ".setssliop clientcertfile /netsim/netsim_security/atrcxb1311-1312ossfs_IEpems/certs.pem" >> $MMLSCRIPT
    echo ".setssliop clientcacertfile /netsim/netsim_security/atrcxb1311-1312ossfs_IEpems/cacerts.pem" >> $MMLSCRIPT
    echo ".setssliop clientkeyfile /netsim/netsim_security/atrcxb1311-1312ossfs_IEpems/key.pem" >> $MMLSCRIPT
    echo ".setssliop clientpassword netsim" >> $MMLSCRIPT
    echo ".setssliop servercertfile /netsim/netsim_security/atrcxb1311-1312ossfs_IEpems/certs.pem" >> $MMLSCRIPT
    echo ".setssliop servercacertfile /netsim/netsim_security/atrcxb1311-1312ossfs_IEpems/cacerts.pem" >> $MMLSCRIPT
    echo ".setssliop serverkeyfile /netsim/netsim_security/atrcxb1311-1312ossfs_IEpems/key.pem" >> $MMLSCRIPT
    echo ".setssliop serverpassword netsim" >> $MMLSCRIPT
    echo ".setssliop save force" >> $MMLSCRIPT
    echo '.selectnocallback network ' >> $MMLSCRIPT
    echo '.stop -parallel ' >> $MMLSCRIPT
    echo " .set ssliop yes atrcxb1311"$RNC"IEdef " >> $MMLSCRIPT
    echo '.set save ' >> $MMLSCRIPT
    echo '.start -parallel' >> $MMLSCRIPT

    /netsim/inst/netsim_pipe < $MMLSCRIPT
    rm $PWD/$MMLSCRIPT
	
  done
done

