# shlog-rotate
Simple log rotator (shell/bash)

Rotates once per execution. Useful in something like crontab once weekly/daily.

Accepts # rotations to keep locally and an optional pre-deletion hook.

Detects nginx logs and resets file handler for smooth transition. Pull requests are welcome to handle other applications' idiosyncrasies.


### Install
```bash
installDir=/root/scripts
mkdir -p $installDir/node_modules
npm install --prefix $installDir shlog-rotate
```


### Rotate single log file
Saving 10 rotations locally before falling off
```bash
/root/scripts/node_modules/shlog-rotate/index.sh 10 /var/log/access.log
```


### Rotate multiple log files
Send output to its own log file
```bash
/root/scripts/node_modules/shlog-rotate/index.sh 10 \
/var/log/access.log /var/www/mysite/out/app.log \
>> /var/log/logrotate.log 2>&1
```
Send output to its own log file and rotate self. I often use this for a one-liner solution, but it would be preferable to cron a second that rotates the logrotate log.
```bash
/root/scripts/node_modules/shlog-rotate/index.sh 10 \
/var/log/access.log /var/www/mysite/out/app.log /var/log/logrotate.log \
>> /var/log/logrotate.log 2>&1
```


### Rotate and send files to s3 prior to deletion
You may pass a script through `-h`, which will be executed prior to log file deletion. Its first argument will be the path to the file about to be unlinked.

An example use case would be to send the log file to s3.
```bash
/root/scripts/node_modules/shlog-rotate/index.sh 10 \
-h /root/scripts/node_modules/util/s3_upload_instance_logfile.sh \
/var/log/access.log /var/www/mysite/out/app.log \
>> /var/log/logrotate.log 2>&1
```

The arguments are read in order; `-h` may be placed in the middle so that only files following it are passed to the hook. In the example below, `send_me_to_s3_first.log` is passed to `s3_upload_instance_logfile.sh`, while `just_delete_me.log` is only rotated.
```bash
/root/scripts/node_modules/shlog-rotate/index.sh 10 \
/var/log/just_delete_me.log \
-h /root/scripts/node_modules/util/s3_upload_instance_logfile.sh \
/var/log/send_me_to_s3_first.log \
>> /var/log/logrotate.log 2>&1
```


### Helper - util/kill_default_nginx_log_rotation.sh
By default, many module's default installation will automatically rotate their logs using unix' logrotate utility (e.g. nginx, mysql, php, etc). You can check what's configured via `ls /etc/logrotate.d`

If you use shlog-rotate on these files, you may want to disable the default rotation to avoid confusion and data loss. `kill_default_nginx_log_rotation.sh` provides an example that disables nginx's default log rotation.


### Helper - util/s3_upload_instance_logfile.sh
An example script that may be passed to shlog-rotate.sh. It will ship objects that are about to be rotated out of existance to s3. This example assumes the host is an Amazon EC2 instance and names the target directory after its instance id.

If you want to actually use this helper, create a file called `_config.s3.local.sh` inside `util/` and export your s3 bucket name. The script assumes s3cmd is installed and in the contextual PATH. An example s3cmd install script can be found here: [https://github.com/fluffybunnies/sire/blob/master/_common/s3.sh](https://github.com/fluffybunnies/sire/blob/master/_common/s3.sh)

