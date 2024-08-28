#!/bin/bash

N_WORKERS=10
WORK_COUNTER=15
C=$N_WORKERS
PIDS[1]=0
while [ $C != 0 ]; do
        #sleep $(($RANDOM / 1000)) &
        sleep 1 &
        PIDS[$C]=$!
        echo "$C:Sprawned PID: ${PIDS[$C]}"
        WORK_COUNTER=$(($WORK_COUNTER - 1))
        C=$(($C - 1))
done

WORKER_I=$N_WORKERS
WORKERS_RUNNING=$N_WORKERS
while [ $WORKERS_RUNNING != 0 ]; do
        WORKER_I=$(($WORKER_I - 1))
        [ $WORKER_I ==  0 ] && WORKER_I=$N_WORKERS # if [$WORKER_I ==  0 ];then WORKER_I=N_WORKERS; fi
        [ ${PIDS[$WORKER_I]} == 0 ] && continue # if [ ${PIDS[$WORKER_I]} == 0 ]; then continue; fi
        #sleep 1

        #if [ -z "`ps a | awk '{print $1}' | grep ${PIDS[$WORKER_I]}`" ]; then
        if ! kill -0 "${PIDS[$WORKER_I]}" 2>/dev/null; then   
                echo "$WORKER_I:Finished PID: ${PIDS[$WORKER_I]}"

                if [ $WORK_COUNTER != 0 ]; then
                        #sleep $(($RANDOM / 1000)) &
                        sleep 1 &
                        PIDS[$WORKER_I]=$!
                        echo "$WORKER_I:Sprawned PID: ${PIDS[$WORKER_I]}"
                        WORK_COUNTER=$(($WORK_COUNTER - 1))
                else
                        PIDS[$WORKER_I]=0
                        WORKERS_RUNNING=$((WORKERS_RUNNING - 1))
                fi
        fi
done
wait
echo "WORKER_I="$WORKER_I
