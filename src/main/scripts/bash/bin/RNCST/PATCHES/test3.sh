#!/bin/bash


par=10
offset=$(ps|wc -l)
max=$(( par + offset ))

for i in $(seq 1 20)
do
  # echo starting new process
  echo "thread="$i
  #( echo "thread="$i ; sleep $i ) 2>&1 &
  ( sleep $i ) 2>&1 &
  while [ $(ps|wc -l) -ge $max ]
  do
     # echo "Throttling..."
     sleep 1
  done
done

echo "loop finished"

wait

