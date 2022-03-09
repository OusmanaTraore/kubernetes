#!/bin/bash
echo "======      ETAPE 3/9   ========="
echo " Création et configuration du fichier /etc/docker/daemon.json"
sleep 2

echo ""
echo "======      ETAPE 4/9   ========="
echo "Redémarrage du service"

sudo systemctl restart docker
sudo systemctl status  docker

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

echo "======PLEASE ====="
echo " Veuillez éditer le fichier /etc/default/kubelet et insérer le code "
echo " suivant en remplacant l'adresse IP_ETH1 par celle de votre machine"

echo ""
echo "KUBELET_EXTRA_ARGS="--node-ip=$IP_ETH1"
