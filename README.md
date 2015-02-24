# shlog-rotate
Simple log rotator (shell/bash)

Rotates once per execution. Useful in something like crontab once weekly/daily.

Detects nginx logs and resets file handler for smooth transition. Pull requests are welcome to handle other applications' idiosyncrasies.


### Install
```
installDir=/root/scripts
mkdir -p $installDir/node_modules
npm install --prefix $installDir shlog-rotate
```


### Rotate single log file
Saving 10 rotations locally before falling off
```
/root/scripts/node_modules/shlog-rotate/index.sh 10 /var/log/nginx/access.log
```


### Rotate multiple log files
Send output to its own log file
```
/root/scripts/node_modules/shlog-rotate/index.sh 10 /var/log/nginx/access.log /var/www/mysite/out/app.log 2>&1 >> /var/log/logrotate.log
```
Send output to its own log file and rotate self. I often use this for a one-liner solution, but it would be preferable to cron a second that rotates the logrotate log.
```
/root/scripts/node_modules/shlog-rotate/index.sh 10 /var/log/nginx/access.log /var/www/mysite/out/app.log /var/log/logrotate.log 2>&1 >> /var/log/logrotate.log
```


### Rotate and send files to s3 prior to deletion
If the second argument ends in ".sh", instead of being rotated, it will be executed prior to log file deletion.

An example use case would be to send the log file to s3.
```
/root/scripts/node_modules/shlog-rotate/index.sh 10 /root/scripts/node_modules/util/s3_upload_instance_logfile.sh /var/log/nginx/access.log /var/www/mysite/out/app.log 2>&1 >> /var/log/logrotate.log
```


### Helper - util/kill_default_nginx_log_rotation.sh
By default, many module's default installation will automatically rotate their logs using unix' logrotate utility (e.g. nginx, mysql, php, etc). You can check what's configured via ```ls /etc/logrotate.d```

If you use shlog-rotate on these files, you may want to disable the default rotation to avoid confusion and data loss. ```kill_default_nginx_log_rotation.sh``` provides an example that disables nginx's default log rotation.


### Helper - util/s3_upload_instance_logfile.sh
An example script that may be passed to shlog-rotate.sh to upload to s3 objects that are about to be rotated out of existance. This example assumes the host is an Amazon EC2 instance and names the target directory after its instance id.

If you want to actually use this helper, create a file called ```_config.s3.local.sh``` inside ```util``` and export your s3 bucket name. The script assumes s3cmd is installed and in the contextual PATH. An example s3cmd install script can be found here: https://github.com/fluffybunnies/sire/blob/master/_common/s3.sh

