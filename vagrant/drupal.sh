#!/usr/bin/env bash

block="
server {
  listen 80;
  server_name $1;
  root $2;

  charset utf-8;
  client_max_body_size 128M;

  index index.php;
  access_log /var/log/nginx/$1.access.log;
  error_log /var/log/nginx/$1.error.log;

  add_header X-Frame-Options \"DENY\";
  add_header X-Content-Type-Options nosniff;
  add_header X-XSS-Protection \"1; mode=block\";
  # add_header Content-Security-Policy \"default-src 'self'; script-src 'self; img-src 'self'; style-src 'self'; font-src 'self'; frame-src 'none'; object-src 'none'\";
  add_header Referrer-Policy no-referrer-when-downgrade;

  location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
  }

  location = /favicon.ico {
    log_not_found off;
    access_log off;
    expires 30d;
  }

  location ~* ^/.well-known/ {
    allow all;
  }

  location ~ \\..*/.*\\.php$ {
    return 403;
  }

  location ~ ^/sites/.*/private/ {
    return 403;
  }

  location ~ (^|/)\\. {
    return 403;
  }

  location / {
    try_files \$uri /index.php?\$query_string;
  }

  location @rewrite {
    rewrite ^/(.*)$ /index.php?q=$1;
  }

  location ~ '\\.php\$|^/update.php' {
    fastcgi_split_path_info ^(.+?\\.php)(|/.*)\$;
    include fastcgi_params;
    fastcgi_hide_header X-Powered-By;
    fastcgi_index index.php;
    fastcgi_param HTTP_PROXY \"\";
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    fastcgi_param PATH_INFO \$fastcgi_path_info;
    fastcgi_param QUERY_STRING \$query_string;
    fastcgi_intercept_errors on;
    fastcgi_read_timeout 600;
    fastcgi_buffers 8 128k;
    fastcgi_buffer_size 256k;
    fastcgi_pass unix:/var/run/php-fpm/$1.sock;
  }

  location ~ ^/sites/.*/files/styles/ {
    try_files \$uri @rewrite;
  }

  location ~ ^(/[a-z\\-]+)?/system/files/ {
    try_files \$uri /index.php?\$query_string;
  }

  location ~* \\.(js|css|png|jpe?g|gif|ico|svg|eot|otf|ttf|woff2?)$ {
    try_files \$uri @rewrite;
    expires max;
    access_log off;
    open_file_cache max=3000 inactive=120s;
    open_file_cache_valid 45s;
    open_file_cache_min_uses 2;
    open_file_cache_errors off;
    log_not_found off;
  }
}
"

echo "$block" > "/etc/nginx/sites-available/$1.conf"
sudo ln -s /etc/nginx/sites-available/$1.conf /etc/nginx/sites-enabled/$1.conf
sudo rm -rf /var/www/vhosts/$1/html/sites
sudo ln -s /var/www/vhosts/$1/sites /var/www/vhosts/$1/html/sites
sudo ln -s /var/www/vhosts/$1/sync /var/www/vhosts/$1/html/sync
sudo service nginx restart
