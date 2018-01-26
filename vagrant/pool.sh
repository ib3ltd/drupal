#!/usr/bin/env bash

pool="
[$1]
user = ib3client
group = nginx
listen = /var/run/php-fpm/$1.sock
listen.owner = ib3client
listen.group = nginx
listen.mode = 0660
listen.allowed_clients = 127.0.0.1
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.process_idle_timeout = 10s
pm.max_requests = 5000
slowlog = /var/log/php-fpm/$1-slow.log

request_slowlog_timeout = 1200
request_terminate_timeout = 1200

catch_workers_output = yes
;clear_env = no

env[HOSTNAME] = $1
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp

php_flag[display_errors] = off
php_admin_value[error_log] = /var/log/php-fpm/$1-error.log
php_admin_flag[log_errors] = on
php_admin_value[memory_limit] = 2048M
php_admin_value[open_basedir] = /usr/share/:/tmp/:$2/../

php_value[session.save_handler] = files
php_value[session.save_path]    = /var/lib/php/$1/session
php_value[soap.wsdl_cache_dir]  = /var/lib/php/$1/wsdlcache
php_value[opcache.file_cache]  = /var/lib/php/$1/opcache

echo "$pool" > "/etc/php-fpm.d/$1.conf"
sudo service php-fpm restart
