#!/bin/bash

### Téléchargement du fichier compréssé

echo " Téléchargement du fichier compréssé
 > "
wget https://get.helm.sh/helm-v3.0.0-linux-amd64.tar.gz

## Décompréssion du fichier tar.gz
 
echo " Décompréssion du fichier tar.gz
 > "
tar -xvf helm-v3.0.0-linux-amd64.tar.gz

## Copie du fichier binaire dans /usr/local/bin
 
echo " Copie du fichier binaire dans /usr/local/bin
 > "
 sudo cp linux-amd64/helm /usr/local/bin/helm3


## Ajout du repo
 
echo " Ajout du repo
 > "
 helm3 repo add stable https://charts.helm.sh/stable

 ## Update du repo
 
echo "  Update du repo
 > "

 helm3 repo update

  ## Installation de mariadb
 
echo "  Installation de mariadb
 > "
 helm3 --debug install firstdb stable/mariadb --set master.persistence.enabled=false --set slave.persistence.enabled=false


  ## Recupération des secrets
 
echo "  Recupération des secrets
 > "

`kubectl get secret --namespace default firstdb-mariadb \
-o jsonpath="{.data.mariadb-root-password}" | base64 --decode ` > secret.txt


 ## Installation du client mariadb
 
echo "  Installation du client mariadb
 > "
 kubectl run firstdb-mariadb-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mariadb:10.3.22-debian-10-r27 --namespace default --command -- bash

  ## Installation du client mariadb
 
echo "  Connection au service master
 > "
  mysql -h firstdb-mariadb.default.svc.cluster.local -uroot -p my_database


