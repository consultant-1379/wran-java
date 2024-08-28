#!/bin/bash

set_parallel_variables()
{
    last_pid="$!"
    parallel_pids="$parallel_pids $last_pid"
    parallel_strings[$last_pid]="$PARALLEL_STATUS_STRING"
    parallel_logs[$last_pid]="$LOG_FILE"
    echo "last_pid="$last_pid
    echo "parallel_pids="$parallel_pids
    echo "parallel_strings[$last_pid]="$parallel_strings[$last_pid]
}

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

parallel_status() {

  set $parallel_pids

    for pid in "$@"; do
        shift
        if kill -0 "$pid" 2>/dev/null; then
            set -- "$@" "$pid"
        fi
    done
    processes_remaining_now="$#"
    echo "processes_remaining_now="$processes_remaining_now

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


#PARALLEL_EXIT_CODE="$?"
#echo "PARALLEL_EXIT_CODE=$PARALLEL_EXIT_CODE"

parallel_finish()
{
    PARALLEL_EXIT_CODE="$?"
    echo "PARALLEL_EXIT_CODE=$PARALLEL_EXIT_CODE"

    output=$(
      cat "$LOG_FILE"
    )
    #echo "$output"
    #cat "$LOG_FILE" 
    #rm $LOG_FILE

    exit "$PARALLEL_EXIT_CODE"
}




parallel_wait() {

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

     ###################################
     # Parallel variable initialization
     ###################################
     LOG_FILE=tmp.txt
     PARALLEL_STATUS_HEADER="Running Scripts"
     PARALLEL_STATUS_STRING="Running Scripts for $0  "
     SHOW_STATUS_UPDATES="YES"
     SHOW_OUTPUT_BORDERS="YES"
     ###################################
      (
      (
        #echo "hello there"
        #ls -l relations/* 
        #ls -l *
        ./createGsmRelations_Patch13A.sh 1

       ) > $LOG_FILE 2>&1; parallel_finish 
       ) & set_parallel_variables


      parallel_wait

exit
LOC_SERVERS="netsimlin378 netsimlin306 netsimlin383 netsimlin384"
    set $LOC_SERVERS
    for pid in "$@"; do
        shift
            set -- "$@" "pid"
    done
    echo "$@"


exit
SCRIPTS="createExtlGsmCells_Patch13A.sh;"\
"createExtlGsmCells_Patch13A.sh;"\
"createGsmRelations_Patch13A.sh;"

LOC_SERVERS="netsimlin378 netsimlin306 netsimlin383 netsimlin384"


IFS=";"
for SCRIPT in $SCRIPTS
do
   echo $SCRIPT
   
   IFS=" "
   for SERVER in $LOC_SERVERS
   do
     set -- $LOC_SERVERS "hello"
     echo $SERVER
   done   

done
