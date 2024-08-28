#!/bin/bash

tjc=0
tj=4
ij=2
results=''
RESULTS=''
FINISHED=''
pids=''


onExit(){
  tpids=$1

 if [ -z $tpids ]
 then 
   kill -9 $tpids
 fi
  #echo "function tpids="$tpids
}

runThis(){ #COUNT
  local i=$1
  sleep $(($RANDOM / 10000)); 
  echo `date` > log$i.txt
  if [ $i -eq 2 -o $i -eq 3 ];then ls relations/* ; fi
}

cmd="(sleep $(($RANDOM / 1000)); echo `date` > log$i.txt)"
#echo "cmd=$cmd"

#exit

#for i in {1..16}; do
for i in $(seq 1 $ij); do
    #(sleep $(($RANDOM / 1000)); echo `date` > log$i.txt) &
    #$cmd &
    runThis $i &
    pid=$!
    echo "$i=PID=$pid"
    pids="$pids $pid"
done 
#exit

echo "NumofBGP is runing="$i
 
#for pid in $pids
#do
#    wait $pid
#    result=$?
#    i=$(($i - 1))
#    echo "NumofBGP left="$i
#    results="$results $result"
#done


while true
do

  set $pids
  #FINISHEDx=$1
  #echo "testFINISHEDx="$FINISHEDx
  #for pid in $pids
  for pid in "$@"; do
     shift
     if kill -0 "$pid" 2>/dev/null; then
       echo "$pid is still running"
       set -- "$@" "$pid"
       #continue
     else
        # A process just finished, print out the parallel status
       wait "$pid"
       EXIT_CODE="$?"
       #echo "Finished="$pid
       FINISHED="$FINISHED $pid"
       RESULTS="$RESULTS $EXIT_CODE"
        if [[ $EXIT_CODE -ne 0 ]]
        then
           echo "INFO: At least one of the parallel processes ended with non 0 exit code, exiting script"
           onExit "$@"
           echo "pids=$@"
           #script[$pid]="eval runThis"

           #FINISHED=$FINISHED" $@"
           echo "FINISHED="$FINISHED
           #exit $EXIT_CODE
       fi
       
       i=$(($i - 1))
       tjc=$(($tjc + 1))
       echo "NumofBGP completed="$tjc
       echo "NumofBGP is runing="$i

       max=`expr $tjc + $i`   
       if [ $i -le $ij ] && [ $max -lt $tj ]
       then
         #sleep $(($RANDOM / 1000)) &
         x=`expr $i + $tjc + 1`
         #$cmd &
         runThis $x &
         pid=$!
         i=$(($i + 1))
         echo "$i=PID=$pid"
         echo "NumofBGP is runing="$i
         set -- "$@" "$pid"
       fi
    fi

    #if [ $i -eq 0 ]
    if [ $tjc -eq $tj ]
    then
       break 2
    fi
    sleep 1
   done
   pids=`echo "$@"`
done

#exit 
#echo $results

for RESULT in $RESULTS
do
  echo -n "$RESULT "
done
echo " "
echo "FINISHED="$FINISHED

exit 
i=0
my_array=( $my_list )
for ret_val in $results; do
    echo ${my_array[$i]} returned $ret_val
    ((i++))
done
