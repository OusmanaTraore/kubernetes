#!/bin/bash
IP_ETH1=$(ip a | cut -d " " -f 6 | grep ^192 | cut -d "/" -f 1)
echo "|||========================  Début installation  =============================|||"
echo "L'adresse IP est $IP_ETH1"
echo "|||=================  ETAPE 1/8  Désactivation de la swap   ==================|||"
### Désactiver la swap  et la rendre persistente
echo " Désactivation de la swap  et la rendre persistente "
sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo ""
###Installation de docker
echo "|||=================   ETAPE 2/8  Installation de docker    =====================|||"
echo "  Début Installation de docker  "
echo " 1/4 - installation des certificats"
sudo apt install apt-transport-https ca-certificates curl software-properties-common 2>/dev/null
echo ""
echo " 2/4 - Récupération de l'image docker depuis le dépôt"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 2>/dev/null
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
bionic stable" -y  2>/dev/null
echo ""
echo " 3/4 - UPDATE  du package"
sudo apt update -y 2>/dev/null
echo ""
echo " 4/4 - installation de docker"
echo ""
sudo apt install -y docker-ce 2>/dev/null
if [ $? -ne 0 ];
then
    echo "ECHEC installation de docker "
    exit 1
else
    echo " installation de docker OK" 
    echo "|||======   ETAPE 3/8 Configuration du fichier  /etc/docker/daemon.json  ======|||"
    echo " Création et configuration du fichier /etc/docker/daemon.json"
    echo "===============================================================================>"
    echo ""
    echo " Création et changement d'autorisation du fichier /etc/docker/daemon.json !? "
    echo "===>"
    sudo touch /etc/docker/daemon.json
    sudo chmod 646 /etc/docker/daemon.json
    sudo echo { \"exec-opts\": [\"native.cgroupdriver=systemd\"] } > /etc/docker/daemon.json
    if [ $?  == 0 ]; then
    echo ""
    echo "Changement d'autorisation == OK "
    echo "===>"
    echo  " Configuration /etc/docker/daemon.json == OK "
    echo "===>"
    echo  " Vérification fichier /etc/docker/daemon.json == OK "
    sudo cat /etc/docker/daemon.json
    sudo chmod 644 /etc/docker/daemon.json
    else
        echo ""
        echo " Changement d'autorisations non réalisé "
        echo ""
    fi
fi 
###
DAEMON_VAR="{ \"exec-opts\": [\"native.cgroupdriver=systemd\"] }"
echo "|||=======   ETAPE 4/8  Redémarrage du service docker  ====================|||"
sudo systemctl restart docker
if [ $? -ne 0 ]; 
    then
        echo " ERREUR DE DEMARRAGE DOCKER"
        exit
    else
        sudo systemctl status  docker | grep Active  
        echo "|||=======   ETAPE 5/8  Téléchargement des packages kubernetes  ========|||"
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 2>/dev/null
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        bionic stabe" 2>/dev/null
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - 2>/dev/null
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
        sudo mv ~/kubernetes.list /etc/apt/sources.list.d
        sudo apt update 2>/dev/null
        echo ""
        echo "|||====   ETAPE 6/8  Installation de kubelet kubeadm kubectl kubernetes-cni  ===|||"
        sudo apt install -y kubelet 2>/dev/null 
        sudo apt install -y kubeadm 2>/dev/null
        sudo apt install -y kubectl 2>/dev/null
        sudo apt install -y kubernetes-cni 2>/dev/null
        if [ $? -ne 0 ]; 
        then
            echo " ECHEC  étape installation kubeadm kubectl kubernetes-cli "
            exit
        else
            echo ""
            echo "|||===========================================================================|||"
            echo "|||=======   CONFIG  =======|=======   CONFIG  =======|======   CONFIG   =====|||"
            echo "||| Création et changement d'autorisation du fichier /etc/default/kubelet !? |||"
            echo "|||                                                                          |||"
            sudo touch /etc/default/kubelet
            sudo ls -la /etc/default/kubelet
            sudo chmod 646 /etc/default/kubelet
            sudo echo  KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\" > /etc/default/kubelet
            if [ $?  == 0 ]; then
            echo ""
            echo "Changement d'autorisation == OK "
            echo "===>"
            sudo ls -la /etc/default/kubelet
            echo  " Configuration /etc/default/kubelet == OK "
            echo "===>"
            echo ""
            sudo cat /etc/default/kubelet
            sudo chmod 644 /etc/default/kubelet
            echo ""
            echo " Rétablissement des autorisations "
            echo "===>"
            echo ""
            sudo ls -la /etc/default/kubelet
            else
            echo ""
            echo " Changement d'autorisations non réalisé "
            echo ""
            fi
        fi
   fi
###
echo "|||====   ETAPE 7/8  Configuration kubernetes  \"/etc/default/kubelet\"  ===|||"
echo ""
echo " Vérification du dossier  /etc/default/kubelet  == ok"
sudo cat /etc/default/kubelet
echo ""
echo "|||======   ETAPE 8/8  Redémarrage des services daemon  et kubelet  =====|||"
  echo " 1/2 - Redémarrage daemon"
  sudo systemctl  daemon-reload
  if [ $? -ne 0 ];
  then
    echo 
    exit
  else
    echo " 2/2 - Redémarrage kubelet"
    sudo systemctl restart kubelet
    sudo systemctl status  kubelet | grep Active
        if  [[ `sudo systemctl status kubelet | grep loaded` ]];
        then
            echo ""
            echo "|||======================================|||"
            echo "|||=======                       ========|||"
            echo "|||                                      |||"
            echo "|||======= installation réussie  ========|||"
            echo "|||                                      |||"
            echo "|||=======                       ========|||"
            echo "|||================|======|==============|||"
            echo "  "

        else
            echo ""
            echo "|||======================================|||"
            echo "|||=======                       ========|||"
            echo "|||                                      |||"
            echo "|||======= echec du démarrage de ========|||"
            echo "|||               kubelet                |||"
            echo "|||=======                       ========|||"
            echo "|||================|======|==============|||"
            echo "  "
        fi
fi

