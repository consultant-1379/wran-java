#!/bin/bash
#
# Created by  : qfatonu
# Created in  : 02 Mar 10
##
### VERSION HISTORY
# Ver1        : Created for WRAN deployment o.10.2.4, req id:3425
# Purpose     :
# Description :
# Date        : 10.08.2012
# Who         : Fatih ONUR

if [ "$#" -ne 2  ]
then
cat<<HELP

Usage: $0 <go>

Example: $0 GO

DESC   :

CONFIG : Followring variables can be set within scripts


HELP
 exit 1
fi



#***********************************************************
#************************************************************
# START OF PARALLEL RUN FUNCTIONS
#************************************************************

## Function: set_parallel_variables ###
#
#   Sets parallel variables and arrays per parallel process for use in parallel_status and parallel_wait functions
#
# Arguments:
#       none
# Return Values:
#       none

set_parallel_variables()
{
    last_pid="$!"
    parallel_pids="$parallel_pids $last_pid"
    parallel_strings[$last_pid]="$PARALLEL_STATUS_STRING"
    parallel_logs[$last_pid]="$LOG_FILE"
}

### Function: reset_parallel_variables ###
#
#   Resets parallel variables and arrays for use in parallel_status and parallel_wait functions
#
# Arguments:
#       none
# Return Values:
#       none

reset_parallel_variables ()
{
    processes_remaining_last=999
    parallel_pids=""
    parallel_strings=()
    parallel_logs=()
    LOG_FILE=""
    PARALLEL_STATUS_STRING=""
    SHOW_STATUS_UPDATES="YES"
    SHOW_OUTPUT_BORDERS="YES"
    PARALLEL_STATUS_HEADER="YES"
}
### Function: parallel_status ###
#
#   Used in proceses to check status of parallel proceses
#
# Arguments:
#       none
# Return Values:
#       none
parallel_status() {
    set $parallel_pids

    for pid in "$@"; do
        shift
        if kill -0 "$pid" 2>/dev/null; then
            set -- "$@" "$pid"
        fi
    done
    processes_remaining_now="$#"

    if [[ $processes_remaining_last -ne $processes_remaining_now ]]
    then

        output=$(
        set $parallel_pids

        echo "                                                                                            |"
        echo "                  |================================================================|        |"
        echo "                  | Parallel Status: $PARALLEL_STATUS_HEADER"
        echo "                  |----------------------------------------------------------------|        |"
        echo "                  |                                                                |        |"
        echo "                __|                                                                |________|"
        echo "               |"

        for pid in "$@"; do
            shift
            if kill -0 "$pid" 2>/dev/null; then
                echo "               | INFO:  ${parallel_strings[$pid]}: Running (Temp logfile ${parallel_logs[$pid]} )"
                set -- "$@" "$pid"
            else
                wait "$pid"
                EXIT_CODE="$?"
                if [[ $EXIT_CODE -eq 0 ]]
                then
                    echo "               | INFO:  ${parallel_strings[$pid]}: Completed"
                else
                    echo "               | ERROR: ${parallel_strings[$pid]}: Completed with exit code $EXIT_CODE, please check"
                fi
            fi
        done
        echo "               |__                                                                  ________"
        echo "                  |                                                                |        |"
        echo "                  |                                                                |        |"
        echo "                  |----------------------------------------------------------------|        |"
        echo "                  | Parallel Summary: Processes Remaining: $processes_remaining_now                       |        |"
        echo "                  |================================================================|        |"
        echo "                                                                                            |"
        )
        echo "$output"
    fi
    processes_remaining_last="$#"
    
}
### Function: parallel_finish ###
#
#   Used in functions to finish off a paralle process, output its logfile, retrieve its return code etc
#
# Arguments:
#       none
# Return Values:
#       none

parallel_finish()
{
    PARALLEL_EXIT_CODE="$?"

    output=$(
    if [[ "$SHOW_OUTPUT_BORDERS" != "NO" ]]
    then
        echo "                                                                                            |"
        echo "    |==============================================================================|        |"
        echo "    | Start Of Output For: $PARALLEL_STATUS_STRING"
        echo "    |------------------------------------------------------------------------------|        |"
        echo "    |                                                                              |        |"
        echo "____|                                                                              |________|"
        echo ""
    fi
    cat "$LOG_FILE"
    if [[ "$SHOW_OUTPUT_BORDERS" != "NO" ]]
    then
        echo "____                                                                                ________"
        echo "    |                                                                              |        |"
        echo "    |                                                                              |        |"
        echo "    |------------------------------------------------------------------------------|        |"
        echo "    | End Of Output For: $PARALLEL_STATUS_STRING"
        echo "    |==============================================================================|        |"
        echo "                                                                                            |"
    fi
    )
    echo "$output"
    cat "$LOG_FILE" >> $LOGFILE
    #rm $LOG_FILE
    exit "$PARALLEL_EXIT_CODE"
}

### Function: parallel_wait ###
#
#   Used in functions to wait for parallel processes to finish
#
# Arguments:
#       none
# Return Values:
#       none

parallel_wait() {
    if [[ "$SHOW_STATUS_UPDATES" != "NO" ]]
    then
        output=$(
        echo ""
        echo "  |==============================================================================================|"
        echo "  | Starting Parallel Processes: $PARALLEL_STATUS_HEADER"
        echo "  |----------------------------------------------------------------------------------------------|"
        echo "  |                                                                                              |"
        echo "__|                                                                                          ____|"
        echo "                                                                                            |"
        )
        echo "$output"
        parallel_status
    fi
    set $parallel_pids
    while :; do
        #echo "Processes remaining: $#"
        for pid in "$@"; do
            #       echo "Checking on $pid"
            shift
            if kill -0 "$pid" 2>/dev/null; then
                #         echo "$pid is still running"
                set -- "$@" "$pid"
            else
                # A process just finished, print out the parallel status
                if [[ "$SHOW_STATUS_UPDATES" != "NO" ]]
                then
                    parallel_status
                fi
            fi
        done
        if [[ "$#" == 0 ]]
        then
            break
        fi
        sleep 1
    done

    if [[ "$SHOW_STATUS_UPDATES" != "NO" ]]
    then
        output=$(
        echo "__                                                                                          |____"
        echo "  |                                                                                              |"
        echo "  |                                                                                              |"
        echo "  |----------------------------------------------------------------------------------------------|"
        echo "  | Completed Parallel Processes: $PARALLEL_STATUS_HEADER"
        echo "  |==============================================================================================|"
        echo ""
        echo ""
        )
        echo "$output"
    fi

    # Exit script if one of the processes had a non 0 return code

    set $parallel_pids
    while :; do
        for pid in "$@"; do
            #       echo "Checking on $pid"
            shift
            if kill -0 "$pid" 2>/dev/null; then
                #         echo "$pid is still running"
                set -- "$@" "$pid"
            else
                # A process just finished, print out the parallel status
                wait "$pid"
                EXIT_CODE="$?"
                if [[ $EXIT_CODE -ne 0 ]]
                then
                    echo "INFO: At least one of the parallel processes ended with non 0 exit code, exiting script"
                    exit_routine $EXIT_CODE
                fi
            fi
        done
        if [[ "$#" == 0 ]]
        then
            break
        fi
        sleep 1
    done
    reset_parallel_variables


}
#************************************************************
#************************************************************
# END OF PARALLEL RUN FUNCTIONS
#************************************************************


PWD=`pwd`

# functions
debug() { # $?

rc=$1
if [[ $rc != 0 ]] ; then
    echo "Exiting due to Error..."
    exit $rc
fi
}

checkExist() { # FILE

FILE=$1

if [ ! -f $PWD/$FILE ]
then
  echo "ERROR!! Script doesnt exist!"
  exit 0
fi
}

LOGFILE=$0.log

if [ -f $PWD/$LOGFILE ]
then
 rm $PWD/$LOGFILE 
 echo ${LOGFILE}" log file deleted" 
 echo ""
fi


HOSTNAME=`hostname`
#***********************************************************************************
#  CONFIG FILE DETAILS							
#***********************************************************************************
#### NETSIM SERVERS ####!#
#LOC_SERVERS="netsimlin353 netsimlin354 netsimlin355 netsimlin305 netsimlin378 netsimlin306 netsimlin383 netsimlin384 netsimlin285 netsimlin503"
#LOC_SERVERS="netsimlin299"
#netsimlin353_list="RNC01 RNC02 RNC03 RNC04 RNC05 RNC06 RNC07 RNC08 RNC09 RNC10 RNC11 RNC12 RNC13 RNC14 RNC15 RNC16"
#netsimlin354_list="RNC17 RNC18 RNC19 RNC20 RNC21 RNC22 RNC23 RNC24 RNC25 RNC26 RNC27 RNC28 RNC29 RNC30 RNC31 RNC32"
#netsimlin355_list="RNC33 RNC34 RNC35 RNC36 RNC37 RNC39 RNC40 RNC41 RNC42 RNC43 RNC44 RNC45 RNC46 RNC47 RNC48"
#netsimlin305_list="RNC49 RNC50 RNC51 RNC52 RNC53 RNC54 RNC55 RNC56 RNC57 RNC58 RNC59 RNC60 RNC61 RNC62 RNC63 RNC64 RNC65 RNC66 RNC67 RNC68"
#netsimlin378_list="RNC69 RNC70 RNC71 RNC72 RNC73 RNC74 RNC75 RNC76 RNC77 RNC78 RNC79 RNC80 RNC81 RNC82 RNC83 RNC84 RNC85 RNC86 RNC87 RNC88"
#netsimlin306_list="RNC89 RNC90 RNC91 RNC92 RNC93 RNC94 RNC95 RNC96 RNC97 RNC98"
#netsimlin383_list="RNC99 RNC100 RNC101 RNC102 RNC103 RNC104"
#netsimlin384_list="RNC105 RNC106"
#netsimlin285_list="RNC107 RNC108"
#netsimlin503_list="RNC109"
#netsimlin299_list="RNC66"
#***********************************************************************************


LOC_SERVERS="netsimlin294 netsimlin295 netsimlin298 netsimlin299 netsimlin300 netsimlin350 netsimlin351 netsimlin352 netsimlin493"

#netsimlin294_list="RNC01 RNC02 RNC03 RNC04 RNC05 RNC06 RNC07 RNC08 RNC09 RNC10 RNC11 RNC12 RNC13 RNC14 RNC15 RNC16"
#netsimlin295_list="RNC17 RNC18 RNC19 RNC20 RNC21 RNC22 RNC23 RNC24 RNC25 RNC26 RNC27 RNC28 RNC29 RNC30 RNC31 RNC32"
#netsimlin298_list="RNC33 RNC34 RNC35 RNC36 RNC37 RNC38 RNC39 RNC40 RNC41 RNC42 RNC43 RNC44 RNC45 RNC46 RNC47 RNC48"
#netsimlin299_list="RNC49 RNC50 RNC51 RNC52 RNC53 RNC54 RNC55 RNC56 RNC57 RNC58 RNC59 RNC60 RNC61 RNC62 RNC63 RNC64 RNC65 RNC66 RNC67 RNC68"
#netsimlin300_list="RNC69 RNC70 RNC71 RNC72 RNC73 RNC74 RNC75 RNC76 RNC77 RNC78 RNC79 RNC80"
#netsimlin300_list="RNC69 RNC70 RNC71 RNC72 RNC73 RNC74 RNC75 RNC76 RNC77 RNC78 RNC79 RNC80 RNC81 RNC82 RNC83 RNC84 RNC85 RNC86 RNC87 RNC88"
netsimlin350_list="RNC89 RNC90 RNC91 RNC92 RNC93 RNC94 RNC95 RNC96 RNC97 RNC98"
netsimlin351_list="RNC99 RNC100 RNC101 RNC102 RNC103 RNC104"
netsimlin352_list="RNC105 RNC106 RNC107"
netsimlin493_list="RNC108 RNC109"


#EXECUTE=NO
EXECUTE=YES
### Add scripts as much as you can add, do not forget 
# to put ; between scripts and at the end "\  chracters for new lines except lastline
#
SCRIPTS="aOut1240createCabinet.sh;"
ENV=$2
UtilityFunctionScript="utilityFunctions.sh"
#SCRIPTS="setUtranCell_PatchFor13A.sh;"\
#"saveAndCompressSims.sh;"

IFS=";"
for SCRIPT in $SCRIPTS
do

  checkExist $SCRIPT

  echo "#################################################################" | tee -a $LOGFILE
  echo "# START SCRIPTS RUNNING ON.. >>"$SERVER | tee -a $LOGFILE
  echo "#################################################################" | tee -a $LOGFILE
  echo "Init Date: "`date` 2>&1 | tee -a $LOGFILE
  echo ""

  IFS=" "
  for SERVER in $LOC_SERVERS # get serevrs from CONFIG file
  do

    #echo "/usr/bin/rcp ./${SCRIPT} netsim@${SERVER}:/tmp/" | tee -a $LOGFILE
    echo "----------------------------"  | tee -a $LOGFILE
    echo "${HOSTNAME}> rcp ./${SCRIPT} netsim@${SERVER}:/tmp/"  | tee -a $LOGFILE
    echo "----------------------------"  | tee -a $LOGFILE
    /usr/bin/rcp ./${SCRIPT} netsim@${SERVER}:/tmp/ 2>&1 | tee -a $LOGFILE
    /usr/bin/rcp ./${ENV} netsim@${SERVER}:/tmp/ 2>&1 | tee -a $LOGFILE
    /usr/bin/rcp ./${UtilityFunctionScript} netsim@${SERVER}:/tmp/ 2>&1 | tee -a $LOGFILE
    debug $? 2>&1 | tee -a $LOGFILE
    echo "" | tee -a $LOGFILE


    #echo "----------------------------"  | tee -a $LOGFILE
    #echo "${HOSTNAME}> rcp ./GSM_Cell_info_40k_SystemTest_013_0.txt netsim@${SERVER}:/tmp/"  | tee -a $LOGFILE
    #echo "----------------------------"  | tee -a $LOGFILE
    #/usr/bin/rcp ./GSM_Cell_info_40k_SystemTest_013_0.txt netsim@${SERVER}:/tmp/ 2>&1 | tee -a $LOGFILE
    #debug $? 2>&1 | tee -a $LOGFILE
    #echo "" | tee -a $LOGFILE 

    #echo "/usr/bin/rsh -n -l netsim $SERVER "chmod +x /tmp/${SCRIPT}"" | tee -a $LOGFILE
    echo "----------------------------" | tee -a $LOGFILE
    echo "${HOSTNAME}> rsh -n -l netsim $SERVER chmod +x /tmp/${SCRIPT}/" | tee -a $LOGFILE
    echo "----------------------------" | tee -a $LOGFILE
    /usr/bin/rsh -n -l netsim $SERVER "chmod +x /tmp/${SCRIPT}" 2>&1 | tee -a $LOGFILE
    /usr/bin/rsh -n -l netsim $SERVER "chmod +x /tmp/${UtilityFunctionScript}" 2>&1 | tee -a $LOGFILE
    debug $? 2>&1 | tee -a $LOGFILE
    echo "" | tee -a $LOGFILE


    LIST=`eval echo '$'${SERVER}_list`
    echo "$SERVER is fetching simulations of $LIST"

    if [  "$EXECUTE" != "YES" ]
    then
      echo "No execution of script"
      echo ""
      COUNT=`expr $COUNT + 1`
      continue
    fi

   
    for RNC in $LIST
    do
   
      ###################################
      # Parallel variable initialization
      ###################################
      LOG_FILE=/tmp/$RNC"_"$SCRIPT".log"
      PARALLEL_STATUS_HEADER="Running Scripts"
      PARALLEL_STATUS_STRING="Running Scripts for $RNC on $SERVER"
      SHOW_STATUS_UPDATES="YES"
      SHOW_OUTPUT_BORDERS="YES"
      ###################################
      (
      (
   
        ZERO=`echo $RNC | cut -c4`  # e.g echo RNC04 | cut -c4 assign to ZERO=0
        if [ "$ZERO" -eq "0" ]
        then
          RNCCOUNT=`echo $RNC | cut -c5` # e.g echo RNC04 | cut -c5 assign to ZERO=4
        else
          RNCCOUNT=`echo $RNC | cut -c4-6` # e.g echo RNC14 | cut -c4-5 assign to ZERO=14
        fi
	
     
        #echo "RNCNAME="$RNC | tee -a $LOGFILE
        #echo "/usr/bin/rsh -n -l netsim $SERVER "/tmp/${SCRIPT}"" | tee -a $LOGFILE
        echo "----------------------------" | tee -a $LOGFILE
        echo "- ${SERVER}> /tmp/${SCRIPT} $RNCCOUNT " | tee -a $LOGFILE
        echo "----------------------------" | tee -a $LOGFILE
        /usr/bin/rsh -n -l netsim $SERVER "/tmp/${SCRIPT} temp ${ENV} ${RNCCOUNT}" 2>&1 | tee -a $LOGFILE
        debug $? 2>&1 | tee -a $LOGFILE
        echo "" | tee -a $LOGFILE
        # exit 0


       ) > $LOG_FILE 2>&1;parallel_finish
       ) & set_parallel_variables
    
     done

  echo ""
  echo "End Date: "`date` 2>&1 | tee -a $LOGFILE
  echo "END.. >>"$SERVER | tee -a $LOGFILE
  echo "#################################################################" | tee -a $LOGFILE
  echo "" | tee -a $LOGFILE
  echo "" | tee -a $LOGFILE

  done #END OF FOR LOOP(SERVERS)


  if [ "$EXECUTE" == "YES" ]
  then
    parallel_wait
  fi

done # END OF FOR LOOP (SCRIPTS)


echo "END OF SCRIPT..." | tee -a $LOGFILE
echo ""
echo "End Date: "`date` 2>&1 | tee -a $LOGFILE

