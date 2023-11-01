#!/bin/bash
time=0

while :
do
  if [ $(cat ./timeadd.txt) != "0" ]; then
    time=$(($time-$(cat ./timeadd.txt)))
    echo "0" > ./timeadd.txt
  fi

  ps -e | grep -v "grep" | grep -q '/minecraft/runtime/java-runtime-gamma/' && IS_MINECRAFT_RUNNING=0 || IS_MINECRAFT_RUNNING=1
  if [ $IS_MINECRAFT_RUNNING -eq 0 ]; then
    ((time++))
    echo "time=${time}"
  else
    echo "MINECRAFT is not running."
  fi

  if [ $time -eq 25 ]; then
    say "ten minutes left"
  fi
 
  if [ $time -gt 34 ] && [ $IS_MINECRAFT_RUNNING -eq 0 ]; then
    say "I am going to kill minecraft!"
    kill -9 $(ps -e | grep -v "grep" | grep '/minecraft/runtime/java-runtime-gamma/' | cut -f1 -d" ")
  fi

  sleep 1
done
