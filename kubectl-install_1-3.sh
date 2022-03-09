#!/bin/bash

IP_ETH1="192.168.50.20"
#read  "Entrez l'adresse IP de la machine" IP_ETH1

echo "Adresse machine : $IP_ETH1 "
echo "======Début installation======"
echo "======      ETAPE 1/9  ========="
sleep 2
### Désactiver la swap  et la rendre persistente
echo " Désactivation de la swap  et la rendre persistente "

sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo ""
###Installation de docker
echo "======      ETAPE 2/9   ========="
echo "  Début Installation de docker  "
sleep 2
echo " 1/4 - installation des certificats"
sudo apt install apt-transport-https ca-certificates curl software-properties-common
echo ""
echo " 2/4 - Récupération de l'image docker depuis le dépôt"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
bionic stable"
echo ""
echo " 3/4 - UPDATE  du package"
sudo apt update -y
echo ""
echo " 4/4 - installation de docker"
echo ""
echo "======      ETAPE 3/9   ========="
echo " Création et configuration du fichier /etc/docker/daemon.json"
sleep 2
sudo echo  -e  `{ "exec-opts": ["native.cgroupdriver=systemd"] } `  > "/etc/docker/daemon.json"
sudo cat "/etc/docker/daemon.json"

echo ""
echo "======      ETAPE 4/9   ========="
echo "Redémarrage du service"
sudo systemctl restart docker
