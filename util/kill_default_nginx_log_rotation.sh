#!/bin/bash
# ./util/kill_default_nginx_log_rotation.sh

mkdir -p /root/baks
echo "moving auto-rotated files to /root/baks/"
mv /var/log/nginx/*.gz /root/baks/

# disable default log rotation
if [ -f /etc/logrotate.d/nginx ]; then
	contents=`cat /etc/logrotate.d/nginx | tr -d '\n'`
	if [ "$contents" != "" ]; then
		echo "disabling default nginx log rotation"
		bakFile=/root/baks/logrotate.d_nginx.$(date +"%Y%m%d_%H%M%S")
		echo "placing current config in $bakFile"
		cp /etc/logrotate.d/nginx $bakFile
		echo '' > /etc/logrotate.d/nginx
	fi
fi
