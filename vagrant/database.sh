#!/usr/bin/env bash

mysql -u root -p$1 -e "CREATE DATABASE IF NOT EXISTS $2"
mysql -u root -p$1 -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX ON $2.* TO $3@localhost IDENTIFIED BY '$4'"