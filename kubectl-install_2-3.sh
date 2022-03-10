#!/bin/bash

DAEMON_VAR="{ \"exec-opts\": [\"native.cgroupdriver=systemd\"] }"
sleep 2
read -p "Entrez à nouveau l'adresse IP de la machine : " IP_ETH1
echo "======      ETAPE 3/9   ========="
echo " Vérification de la configuration du fichier /etc/docker/daemon.json"
test_daemon=$(cat /etc/docker/daemon.json)
if [ $test_daemon -ne $DAEMON_VAR ];
then
    echo "ERREUR de configuration du fichier /etc/docker/daemon.json"
    echo "Corriger votre fichier puis relancer le script"
    echo "..."
    exit
else
    cat /etc/docker/daemon.json
    echo " Configuration du fichier /etc/docker/daemon.json "
    echo "===> ok"
    sleep 2
    echo "======      ETAPE 4/9   ========="
    echo "Redémarrage du service docker"

    sudo systemctl restart docker
    if [ $? -ne 0 ]; 
    then
        echo " ERREUR DE DEMARRAGE DOCKER"
        exit
    else
        sudo systemctl status  docker | grep Active  
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
        sudo apt install -y kubelet 
        sudo apt install -y kubeadm 
        sudo apt install -y kubectl 
        sudo apt install -y kubernetes-cni
        fi
        if [ $? -ne 0 ]; 
        then
            echo " ECHEC  étape installation kubeadm kubectl kubernetes-cli "
            exit
        else
            echo "======PLEASE ====="
            echo " Veuillez éditer le fichier /etc/default/kubelet et insérer le code "
            echo " suivant en remplacant l'adresse IP_ETH1 par celle de votre machine"
            echo ""
            echo KUBELET_EXTRA_ARGS="--node-ip=$IP_ETH1"
            sleep 2
            echo ""
            echo "Ensuite lancez le script kubectl-install_3-3.sh"
            echo "..."
        fi
fi
