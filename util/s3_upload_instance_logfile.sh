#!/bin/bash

logFilePath=$1

dir=`dirname $0`
. "$dir/_config.s3.sh"

instanceId=`curl -s -m5 'http://169.254.169.254/latest/meta-data/instance-id'`
if [ "$instanceId" == "" ]; then
	instanceId=$(date +"%Y%m%d_%H%M%S")
	echo "failed to get instance id, defaulting to timestamp: $instanceId"
fi

logFileBasename=`basename "$logFilePath"`
remoteFile="$s3Bucket/$instanceId/$logFileBasename."$(date +"%Y%m%d_%H%M%S")
echo "s3cmd put \"$logFilePath\" s3://$remoteFile"
s3cmd put "$logFilePath" "s3://$remoteFile" && echo "logfile uploaded to s3!" || echo "logfile failed to upload to s3 :("

