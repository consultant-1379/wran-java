#!/bin/bash

# Created by  : Fatih ONUR
# Created in  : 30/08/2012
##
### VERSION HISTORY
##############################################
# Ver1        : CReate for WRAN deployment O13B
# Purpose     : Create missing Inter,Ext UC and Relations
# Description :
# Date        : 2013.03.16
# Who         : Fatih ONUR
##############################################

usage(){
  echo "Usage: $0 RNCID"
  echo "  e.g. $0 1"
  echo ""
  echo "HELP: This script create Inter,Ext relations and related ExttUCs"
  echo ""
  exit 1
}

[[ "$#" -ne 1 ]] && usage

################################
# ENV VARIABLES
################################

sourceServer="netsimlin313"

rncCount=$1
rncName=`printf "RNC%02d" $rncCount`

echo "`hostname`: ...$rncName:$0 script started running at "`date`

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`
MMLSCRIPT=$0_$rncName".mml"

################################
# SETUP and PRECHECKS
################################

if [ -f $PWD/$MMLSCRIPT ]
then
  rm -r  $PWD/$MMLSCRIPT
  echo "INFO:`hostname`: Old "$PWD/$MMLSCRIPT " removed"
fi


simName=`ls /netsim/netsimdir | egrep "$rncName$" | grep ST | grep -m1 -v zip`

if [ -z "$simName" ] || [ "$simName" == "" ]
then
  echo "INFO:`hostname`: No sim found with rncName=$rncName"
  echo "`hostname`: ...exiting"
  exit
fi
echo "INFO:`hostname`: simName=$simName"

################################
# MAIN
################################

rncName=`printf "RNC%02d" $rncCount`
moFileName="${rncName}-v11_createExtUCandR1.mo"
moFileTarget="/tmp/${moFileName}"
moFileSource="/netsim/simgen3/13B_ST50K/bin/RNCST/JAVAFILES/$moFileName"

exist=`/usr/bin/rsh -n -l netsim $sourceServer "ls $moFileSource" | xargs echo`
echo "INFO:`hostname`: exist=$exist"
[[ -z "$exist" ]] && echo -e "INFO: No mofile:$moFileSource found \n ...exiting" && exit
echo "INFO:`hostname`: moFile:$moFileName found!"

/usr/bin/rcp netsim@$sourceServer:$moFileSource $moFileTarget

echo "INFO:`hostname`: moFile=$moFileName file copied to $moFileTarget"

if [ ! -f "$moFileTarget" ] 
then
  echo "INFO:`hostname`: No file found with moFile=$moFile"
  echo "`hostname`: ...exiting"
  exit
fi


echo ".open $simName" >> $MMLSCRIPT
echo ".select $rncName" >> $MMLSCRIPT
echo ".start" >> $MMLSCRIPT
echo "kertayle:file=\"$moFileTarget\";" >> $MMLSCRIPT

echo "INFO:`hostname`: ...MML script is running now"
/netsim/inst/netsim_pipe < $MMLSCRIPT
echo "INFO:`hostname`: ...MML script completed"


echo "`hostname`: ...$rncName:$0 script ended running at "`date`
