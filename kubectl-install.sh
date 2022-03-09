#!/bin/bash

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
sudo apt install -y docker-ce
## Fichier de configuration docker
echo ""
echo "======      ETAPE 3/9   ========="
echo " Création et configuration du fichier /etc/docker/daemon.json"
sleep 2
sudo echo  -e  `{ "exec-opts": ["native.cgroupdriver=systemd"] } `  > "/etc/docker/daemon.json"
sudo cat "/etc/docker/daemon.json"

echo ""
echo "======      ETAPE 4/9   ========="
echo "Redémarrage du service"
sudo systemctl enable docker.service
sudo systemctl restart docker

echo "======      ETAPE 5/9  ========="
echo " Téléchargement des packages kubernetes"
sleep 2
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
bionic stabe"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list

sudo mv ~/kubernetes.list /etc/apt/sources.list.d
sudo apt update
echo ""

echo "======      ETAPE 6/9   ========="
echo "Installation de kubelet kubeadm kubectl kubernetes-cni"
sleep 2
sudo apt install -y kubelet kubeadm kubectl kubernetes-cni

## Fichier de configuration kubernetes
echo ""
echo "======      ETAPE 7/9   ========="
echo " configuration kubernetes"
sleep 2
echo "SKIP"
sudo echo KUBELET_EXTRA_ARGS="--node-ip=$IP_ETH1" > "/etc/default/kubelet"
sudo cat "/etc/default/kubelet"

echo "======      ETAPE 8/9   ========="
echo "Redémarrage des services docker , daemon  et kubelet"
sleep 2
echo " 1/3 - Redémarrage docker"
sudo systemctl restart docker
sudo systemctl status docker
sleep 1
echo "q"
echo " 2/3 - Redémarrage daemon"
sudo systemctl  daemon-reload
sudo systemctl status daemon-reload
sleep 1
echo `q`

echo " 3/3 - Redémarrage kubelet"
sudo systemctl restart kubelet
sudo systemctl status  kubelet
sleep 1

echo ""
echo ""
echo "======      ETAPE 9/9   ========="
echo " Initialisation de Kubeadm "
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.205.10  --ignore-preflight-errors=NumCPU
