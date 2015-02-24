#!/bin/bash

logFilePath=$1

dir=`dirname $0`
. "$dir/_config.s3.sh"

instanceId=`curl -s 'http://169.254.169.254/latest/meta-data/instance-id'`
if [ "$instanceId" == "" ]; then
	echo "failed to get instance id"
	exit 1
fi

logFileBasename=`basename "$logFilePath"`
remoteFile="$s3Bucket/$instanceId/$logFileBasename."$(date +"%Y%m%d_%H%M%S")
echo "s3cmd put \"$logFilePath\" s3://$remoteFile"
s3cmd put "$logFilePath" "s3://$remoteFile" && echo "logfile uploaded to s3!" || echo "logfile failed to upload to s3 :("

