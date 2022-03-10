#!/bin/bash
IP_ETH1="192.168.50.20"
DAEMON_VAR="{ \"exec-opts\": [\"native.cgroupdriver=systemd\"] }"
sleep 2
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
    echo " Configuration du fichier /etc/docker/daemon.json === OK ==="
    cat /etc/docker/daemon.json
    sleep 2
    echo "======      ETAPE 4/9   ========="
    echo "Redémarrage du service docker"

    sudo systemctl restart docker
    if [ $? -ne 0 ]; 
    then
        echo " ERREUR DE DEMARRAGE DOCKER"
        exit
    else
        sudo systemctl status  docker
        echo "======      ETAPE 5/9  ========="
        echo " Téléchargement des packages kubernetes"
        sleep 2
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list

        sudo mv ~/kubernetes.list /etc/apt/sources.list.d
        sudo apt update
        echo ""

        echo "======      ETAPE 6/9   ========="
        echo "Installation de kubelet kubeadm kubectl kubernetes-cni"
        sleep 2
        sudo apt install -y kubelet kubeadm kubectl kubernetes-cni
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
