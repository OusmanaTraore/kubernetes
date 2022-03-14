#!/bin/bash
#source kubectl-install_1-3.sh
DAEMON_VAR="{ \"exec-opts\": [\"native.cgroupdriver=systemd\"] }"
echo "================================================================================================>"
echo "Vérifier l'adresse IP ... "
#sleep 2
echo " Adresses IP disponibles"
for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
do
    echo "===> $i"
done

            echo "============================================================================================>"
read -p "Entrez  de nouveau l'adresse IP de la machine: " IP_ETH1 
            echo "============================================================================================>"
            echo "|||=======   ETAPE 3/9  Configuration du fichier  /etc/docker/daemon.json  =================|||"
            echo "|||====== Vérification ... =====>"
sleep 2
test_daemon=$(cat /etc/docker/daemon.json)
if [ $test_daemon -ne $DAEMON_VAR ];
then
    echo "ERREUR de configuration du fichier /etc/docker/daemon.json"
    echo "Corriger votre fichier puis relancer le script"
    echo "..."
    exit
else
    cat /etc/docker/daemon.json
    echo " Configuration du fichier /etc/docker/daemon.json ===> OK"
    sleep 2
            echo "|||=======   ETAPE 4/9  Redémarrage du service docker  =====================================|||"

    sudo systemctl restart docker
    if [ $? -ne 0 ]; 
    then
        echo " ERREUR DE DEMARRAGE DOCKER"
        exit
    else
        sudo systemctl status  docker | grep Active  
            echo "|||=======   ETAPE 5/9  Téléchargement des packages kubernetes  ============================|||"
        sleep 2
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        bionic stabe"
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
        sudo mv ~/kubernetes.list /etc/apt/sources.list.d
        sudo apt update
        echo ""

            echo "|||=======   ETAPE 6/9  Installation de kubelet kubeadm kubectl kubernetes-cni  ============|||"
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
            sleep 2
            echo ""
            echo "|||=========================================================================================|||"
            echo "|||=======   PLEASE  =======|=======   PLEASE  =======|======   PLEASE  =======|============|||"
            echo "|||   ATTENTION  AVANT DE LANCER LE SECOND SCRIPT VEUILLEZ EFFECTUER L'ETAPE CI-DESSOUS     |||"
            echo "|||                                                                                         |||"
            echo "|||                                                                                         |||"
            echo "|||======= Editer le fichier   \"/etc/default/kubelet\"   et insérer le code suivant: ========|||"
            echo "|||                     KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\"                               |||"
            echo "|||                                                                                         |||"
            echo "|||                                                                                         |||"
            echo "|||=======                  ENSUITE LANCER LE SCRIPT kubectl-install_3-3.sh                 |||"
            echo "|||=======   PLEASE  =======|=======   PLEASE  =======|======   PLEASE  =======|============|||"
            echo "|||=========================================================================================|||"
            echo "  "
        fi
fi
