# shlog-rotate
Log rotator (shell/bash)


### Install
```
installDir=/root/scripts
mkdir -p $installDir/node_modules
npm install --prefix $installDir shlog-rotate
```


### Rotate single log file
With backup limit of 10
```
/root/scripts/node_modules/shlog-rotate.sh /var/log/nginx/access.log
```


### Rotate multiple log files
Send output to log file and rotate self
```
/root/scripts/node_modules/shlog-rotate.sh 10 /var/log/nginx/access.log /var/www/mysite/out/app.log /var/log/logrotate.log 2>&1 >> /var/log/logrotate.log
```


### Rotate and send files to s3 prior to deletion
If the second argument ends in ".sh", instead of being rotated, it will be executed prior to log file deletion. 
```
/root/scripts/node_modules/shlog-rotate.sh 10 /root/scripts/node_modules/util/s3_upload_instance_logfile.sh /var/log/nginx/access.log /var/www/mysite/out/app.log /var/log/logrotate.log 2>&1 >> /var/log/logrotate.log
```


### Helper - util/kill_default_nginx_log_rotation.sh
By default, a normal many module's default installation will automatically rotate their access and error logs (e.g. nginx, mysql, php, etc). You can check via ```ls /etc/logrotate.d```.

If you use shlog-rotate on these files, you may want to disable the default rotation to avoid confusion and data loss. kill_default_nginx_log_rotation.sh shows how to do so by providing an example that stops nginx's default log rotation.


### Helper - util/s3_upload_instance_logfile.sh
An example script that may be passed to shlog-rotate.sh to upload log files that are about to be rotated out of existance to an s3 bucket. This example assumes the host is an Amazon EC2 instance and names the target directory after its instance id.


