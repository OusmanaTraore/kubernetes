#!/bin/bash

###  Connect to seconddb 
echo " Connect to seconddb >"
mysql -h seconddb-mariadb.default.svc.cluster.local \
-uroot -p my_database

