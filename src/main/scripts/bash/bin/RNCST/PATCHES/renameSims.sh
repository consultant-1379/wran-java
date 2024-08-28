#!/bin/bash

# Created by  : Fatih ONUR
# Created in  : 06.02.2013
##
### VERSION HISTORY
# Ver1        : Created for WRAN TERE 13B
# Purpose     : Rename sims
# Description : 
# Date        : 06 March 2013
# Who         : Fatih ONUR

usage(){
  echo "Usage: $0 RNCSTART RNCEND"
  echo "  e.g. $0 1 3"
  echo ""
  echo "HELP: This script changes sript names as the following format"
  echo " RNC<MIM_VERSION>-ST-RNC<ID> .e.g RNCM120-ST-RNC01, RNCM120-ST-RNC02"
  echo ""
  exit 1
}

[[ "$#" -ne 2 ]] && usage

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`
MMLSCRIPT=$0_".mml"

if [ -f $PWD/$MMLSCRIPT ]
then
  rm -r  $PWD/$MMLSCRIPT
  echo "old "$PWD/$MMLSCRIPT " removed"
fi

rncStart=$1
rncEnd=$2

for (( count = $rncStart; count <= $rncEnd; count++ ))
do
  rncName=`printf "%s%03d" "RNC" "$count"`
  simName=`ls /netsim/netsimdir | egrep $rncName | grep ST | grep -m1 -v zip`

  if [ -z "$simName" ] || [ "$simName" == "" ]
  then
    echo "No sim found with rncName=$rncName" 
    continue;
  fi

  echo "simName=$simName"

  rncName=`echo $simName | awk -F"x" '{print $1}'` 
  echo "rncName="$rncName

  rncCount=`printf "%02d" "$count"`
  echo "rncCount="$rncCount

  newSimName="$rncName-ST-RNC$rncCount"
  echo "newSimName=$newSimName"

  echo ".open $simName" >> $MMLSCRIPT 
  echo ".select network" >> $MMLSCRIPT
  echo ".stop -parallel" >> $MMLSCRIPT
  echo ".saveandcompress force nopmdata" >> $MMLSCRIPT

  #[[ -f $MMLSCRIPT ]] && mmlContents=`cat $MMLSCRIPT`
  #echo "mmlContents="$mmlContents

  #if [ -z "$mmlContents" ] || [ "$mmlContents" == "" ]
  #then
  #  echo "No any modification done!!!"
  #else
    echo "...MML script is running now"
    /netsim/inst/netsim_pipe < $MMLSCRIPT
    echo "...MML script completed"

    if [ -f /netsim/netsimdir/$simName.zip ]
    then
      mv /netsim/netsimdir/$simName.zip /netsim/netsimdir/$newSimName.zip
    fi
   
    echo "...change name"
    if [ -f /netsim/netsimdir/$newSimName.zip ]
    then

       echo "...MML script is running now"
       echo ".uncompressandopen $newSimName.zip /netsim/netsimdir/$newSimName tryforce" | /netsim/inst/netsim_pipe
       echo -e ".select network \n .start -parallel" | /netsim/inst/netsim_pipe -sim $newSimName
       echo "...MML script completed"
 
       echo "oldSimName=$simName; newSimName=$newSimName"
       echo "...change name completed"
    else
       echo "...error occured while changing simName=$simName"
    fi
    #echo ".deletesimulation $simName force" >> $MMLSCRIPT
  #fi  

  
done
  

