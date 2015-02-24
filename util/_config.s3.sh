#!/bin/bash

# set these values in a sibling file _config.s3.local.sh
export s3Bucket='BUCKET NAME'

localConfig=./_config.s3.local.sh
if [ -f $localConfig ]; then
	. $localConfig
else
	echo "missing s3 config: $localConfig"
fi
