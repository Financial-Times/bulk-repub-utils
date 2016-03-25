#!/bin/bash

# Useful for cross-cluster republishing
# The output of this script can be used as input for the up-restutil 

printHelp() {
        echo "Incorrect number of parameters!"
        echo "Usage: readData.sh batchSize secondsToWait environment auth app collection"
        echo "Example: readData.sh 5 1 xp user:pwd nativerw v1-metadata"
}

if [ "$#" -ne 6 ]; then 
	printHelp
	exit 1
fi

batchSize=$1
secondsToWait=$2
env=$3
auth=$4
app=$5
collection=$6
currentBatch=0

for uuid in `curl -su $auth https://$env-up.ft.com/__$app/$collection/__ids | cut -d"\"" -f4`; do 
	if [ "$currentBatch" -eq "$batchSize" ]; then
		currentBatch=0
		sleep $secondsToWait	
	fi 
	echo `curl -su $auth https://$env-up.ft.com/__$app/$collection/$uuid`
	echo ""
	((currentBatch++))
done

