#!/usr/bin/env bash

block="<VirtualHost *:80>
    DocumentRoot $2
    ServerName $1

#    <Directory /var/www/vhosts/example.com/httpdocs>
#        php_admin_value open_basedir \"/var/www/vhosts/example.com/httpdocs:/var/www/vhosts/example.com/private:/var/www/vhosts/example.com/error_docs:/usr/share/php:/tmp\"
#        RewriteEngine On
#        RewriteCond %{REQUEST_FILENAME} !backsoon.php
#        RewriteRule ^(.*)$ /backsoon.php [L]
#        AllowOverride None
#    </Directory>
#    <Directory ~ /httpdocs/(cache|userfiles)/>
#        php_admin_flag engine off
#        <Files *.php>
#            Order Deny,Allow
#            Deny from all
#        </Files>
#    </Directory>
#    Alias \"/error_docs\" \"/var/www/vhosts/example.com/error_docs\"
#    ErrorDocument 400 /error_docs/bad_request.html
#    ErrorDocument 401 /error_docs/unauthorized.html
#    ErrorDocument 403 /error_docs/forbidden.html
#    ErrorDocument 404 /error_docs/not_found.html
#    ErrorDocument 500 /error_docs/internal_server_error.html
#    ErrorDocument 405 /error_docs/method_not_allowed.html
#    ErrorDocument 406 /error_docs/not_acceptable.html
#    ErrorDocument 407 /error_docs/proxy_authentication_required.html
#    ErrorDocument 412 /error_docs/precondition_failed.html
#    ErrorDocument 415 /error_docs/unsupported_media_type.html
#    ErrorDocument 501 /error_docs/not_implemented.html
#    ErrorDocument 502 /error_docs/bad_gateway.html

    SetEnv SERVER_ENV development
    EnableSendfile Off
</VirtualHost>"

echo "$block" > "/etc/httpd/conf.d/zz_$1.conf"
service httpd restart