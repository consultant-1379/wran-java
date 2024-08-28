#!/bin/bash 
# Ver1        : Modified for ENM
# Purpose     : To Implement scanners for simulation
# Description :
# Date        : 06 07 2017
# Who         : ANUSHA CHITRAM
##########################################################
Sim=$1
if [[ $# -eq 0 ]] ; then
echo 'invalid'
exit 1
fi
cd ~/netsimdir
if [ -d "scanner" ];
then
echo "$Sim"
else
mkdir scanner
fi
cp $Sim".zip" scanner
cd  ~/simnet/wran/bin
./Scanner_operation.sh

