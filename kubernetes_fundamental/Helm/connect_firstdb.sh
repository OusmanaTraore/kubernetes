#!/bin/bash

### Helm list

echo " Helm list
 > "

helm3 list

### helm3 uninstall firstdb

echo " helm3 uninstall firstdb
 > "

helm3 uninstall firstdb

### Trouver les charts téléchargées

echo " Trouver les charts téléchargées
 > "
find $HOME -name *mariadb*

### Extraction du tarball

echo " Extraction du tarball
 > "
cd $HOME/.cache/helm/repository ; tar -xvf mariadb-*

### Customisation du tarball

echo " Customisation du tarball
 > "
 cp mariadb/values.yaml $HOME/custom.yaml ;


echo -e "
=====================================================================
edit le fichier custom.yml  eyt ajouter le password et la persistence
....
 rootUser:
 ## MariaDB admin password
 ## ref: https://github.com/bitnami/bitnami-docker-mariadb#setting-the-root-password-on-first-run
 ##
 password: LFTr@1n #<-- Add a password, such as LFTr@1n
 ##
 ....
 persistence:
 ## If true, use a Persistent Volume Claim, If false, use emptyDir
 ##
 enabled: false #<--- Change this to false
 # Enable persistence using an existing PVC
 # existingClaim:
 ....
========================================================================
"

