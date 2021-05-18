#!/usr/bin/bash

php-fpm
apachectl -k restart

tail -f /var/log/httpd24/access_log