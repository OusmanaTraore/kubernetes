#!/bin/bash

### Installation de la seconde base de données mariadb

echo " Installation de la seconde base de données mariadb
 > "
helm3 install -f custom.yaml seconddb stable/mariadb


kubectl run seconddb-mariadb-client \
--rm --tty -i --restart='Never' \
--image docker.io/bitnami/mariadb:10.3.22-debian-10-r27 \
--namespace default --command -- bash

mysql -h seconddb-mariadb.default.svc.cluster.local \
-uroot -p my_database