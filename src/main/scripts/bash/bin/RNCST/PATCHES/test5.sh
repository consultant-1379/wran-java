#!/bin/bash


WORKER_I=5

PIDS[5]=0

[ ${PIDS[$WORKER_I]} == 0 ] && echo "test"



exit
N_WORKERS=10
WORK_COUNTER=15
C=$N_WORKERS
echo "C="$C
PIDS[1]=0
while [ $C != 0 ]; do
        echo $C &
        PIDS[$C]=$!
        echo "Sprawned PID: ${PIDS[$C]}"
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
done




#echo "WORKER_I="$WORKER_I
#echo "N_WORKERS="$N_WORKERS

#if [ ${PIDS[$WORKER_I]} == 0 ];then echo "tataa";fi


#if [ $WORKER_I ==  0 ];then echo hello;fi
#if [ $WORKER_I=N_WORKERS ];then echo "WORKER_I="$WORKER_I ;fi

