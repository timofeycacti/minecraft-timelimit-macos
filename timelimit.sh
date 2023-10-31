#!/bin/bash
time=0

while :
do
	if [ $(cat ./timeadd.txt) != "0" ]; then
		time=$(($time-$(cat ./timeadd.txt)))
		echo "0" > ./timeadd.txt
	fi

	ps -e | grep -v "grep" |  grep -q '/minecraft/runtime/java-runtime-gamma/'
	if [ $? -eq 0 ]; then
		((time++))
     	echo "time=${time}"
    else
		echo "MINECRAFT is not running."
	fi

	if [ $time -eq 25 ]; then
		say ten minutes left
	fi
 
	if [ $time -gt 34 ]; then
        kill -9 $(ps -e | grep -v "grep" | grep '/minecraft/runtime/java-runtime-gamma/' | cut -f1 -d" ")
    fi

	sleep 1
done
