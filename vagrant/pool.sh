#!/usr/bin/env bash

pool="
[$1]
user = ib3client
group = nginx
listen = /var/run/php-fpm/$1.sock
listen.owner = ib3client
listen.group = nginx
listen.mode = 0660
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
pm.process_idle_timeout = 10s
pm.max_requests = 500

catch_workers_output = yes

env[HOSTNAME] = $1
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp

php_flag[display_errors] = on
php_admin_value[error_log] = /var/log/php-fpm/$1-error.log
php_admin_flag[log_errors] = on
php_admin_value[memory_limit] = 2048M
php_admin_value[open_basedir] = /usr/share:/tmp:/var/www/vhosts/$1

php_value[session.save_handler] = files
php_value[session.save_path]    = /var/lib/php/$1/session
php_value[opcache.file_cache]  = /var/lib/php/$1/opcache
"

echo "$pool" > "/etc/php-fpm.d/$1.conf"
sudo service php-fpm restart
