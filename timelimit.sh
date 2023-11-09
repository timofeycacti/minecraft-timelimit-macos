#!/bin/bash
time=0
script_dir=$(dirname "$0")
timeadd_file="${script_dir}/timeadd.txt"

while :
do
  if [ $(cat ${timeadd_file}) != "0" ]; then
    time=$(($time-$(cat ${timeadd_file})))
    echo "0" > ${timeadd_file}
  fi

  ps -e | grep -v "grep" | grep -q '/minecraft/runtime/java-runtime-gamma/' && IS_MINECRAFT_RUNNING=0 || IS_MINECRAFT_RUNNING=1
  if [ $IS_MINECRAFT_RUNNING -eq 0 ]; then
    ((time++))
    echo "$(date) time=${time}" | tee -a ${script_dir}/log.log
  else
    echo "$(date) MINECRAFT is not running." | tee -a ${script_dir}/log.log
  fi

  if [ $time -eq 25 ]; then
    say "ten minutes left"
    echo "$(date) ten minutes left" | tee -a ${script_dir}/log.log
  fi
 
  if [ $time -gt 34 ] && [ $IS_MINECRAFT_RUNNING -eq 0 ]; then
    say "I am going to kill minecraft!"
    echo "$(date) I am going to kill minecraft!" | tee -a ${script_dir}/log.log
    kill -9 $(ps -e | grep -v "grep" | grep '/minecraft/runtime/java-runtime-gamma/' | xargs | cut -f1 -d" ")
  fi

  if [ $(date | cut -f5 -d" " | cut -f1,2 -d":") = "00:00" ]; then
    echo "$(date) TIME RESET" | tee -a ${script_dir}/log.log
    time=0
  fi
  
  sleep 60
done
