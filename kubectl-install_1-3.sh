#!/bin/bash


read -p "Entrez l'adresse IP de la machine: " IP_ETH1

echo "Adresse machine : $IP_ETH1 "
echo "==> ok"
echo "======Début installation======"
echo "======      ETAPE 1/9  Désactivation de la swap ========="
sleep 2
### Désactiver la swap  et la rendre persistente
echo " Désactivation de la swap  et la rendre persistente "

sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo ""
###Installation de docker
echo "======      ETAPE 2/9  Installation de docker ========="
echo "  Début Installation de docker  "
sleep 2
echo "======      ETAPE 2/9  Installation de docker  ========="
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
sudo apt install -y docker-ce
if [ $? -ne 0 ];
then
    echo "ECHEC installation de docker "
    exit 1
else
    sleep 2
    echo " installation de docker OK" 
    echo "======      ETAPE 3/9   ========="
    echo " Création et configuration du fichier /etc/docker/daemon.json"
    sleep 2
    echo ""
    echo " Editer le fichier /etc/docker/daemon.json et insérer le code { \"exec-opts\": [\"native.cgroupdriver=systemd\"] } "
    echo " Ensuite lancer le script kubectl-install_2-3.sh"
    echo "..."
fi 




