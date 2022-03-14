#!/bin/bash
echo "================================================================================================>"
echo "Vérifier l'adresse IP ... "
#sleep 2
echo " Adresses IP disponibles"
for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
do
    echo "===> $i"
done

echo "================================================================================================>"
read -p "Entrez l'adresse IP de la machine: " IP_ETH1 
echo "================================================================================================>"

echo "|||========================  Début installation  ============================================|||"
echo "|||=================  ETAPE 1/9  Désactivation de la swap   =================================|||"
sleep 2
### Désactiver la swap  et la rendre persistente
echo " Désactivation de la swap  et la rendre persistente "

sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo ""
###Installation de docker
echo "|||=================   ETAPE 2/9  Installation de docker    =================================|||"
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
echo ""
sudo apt install -y docker-ce
if [ $? -ne 0 ];
then
    echo "ECHEC installation de docker "
    exit 1
else
    sleep 2
    echo " installation de docker OK" 
    echo "|||======   ETAPE 3/9  Configuration du fichier  /etc/docker/daemon.json  ==================|||"
    echo " Création et configuration du fichier /etc/docker/daemon.json"
    echo "==============================================================================================>"
    sleep 2
    echo ""
    echo ""
    echo "|||=========================================================================================|||"
    echo "|||=======   PLEASE  =======|=======   PLEASE  =======|======   PLEASE  =======|============|||"
    echo "|||   ATTENTION  AVANT DE LANCER LE SECOND SCRIPT VEUILLEZ EFFECTUER L'ETAPE CI-DESSOUS     |||"
    echo "|||                                                                                         |||"
    echo "|||                                                                                         |||"
    echo "|||======= Editer le fichier \"/etc/docker/daemon.json\"  et insérer le code suivant: ========|||"
    echo "|||             { \"exec-opts\": [\"native.cgroupdriver=systemd\"] }                            |||"
    echo "|||                                                                                         |||"
    echo "|||                                                                                         |||"
    echo "|||=======             ENSUITE LANCER LE SCRIPT kubectl-install_2-3.sh               =======|||"
    echo "|||=======   PLEASE  =======|=======   PLEASE  =======|======   PLEASE  =======|============|||"
    echo "|||=========================================================================================|||"
    echo "  "
    echo ""
    echo " Création et changement d'autorisation du fichier /etc/docker/daemon.json !? "
    echo "===>"
    sudo touch /etc/docker/daemon.json
    sudo ls -la /etc/docker/daemon.json
    sudo chmod 646 /etc/docker/daemon.json
    sudo echo { \"exec-opts\": [\"native.cgroupdriver=systemd\"] } > /etc/docker/daemon.json
    if [ $?  == 0 ]; then
    echo ""
    echo "Changement d'autorisation == OK "
    echo "===>"
    sudo ls -la /etc/docker/daemon.json
    echo  " Configuration /etc/docker/daemon.json == OK "
    echo "===>"
    echo ""
    sleep 2
    sudo cat /etc/docker/daemon.json
    sudo chmod 644 /etc/docker/daemon.json
    echo ""
    echo " Rétablissement des autorisations "
    echo "===>"
    echo ""
    sudo ls -la /etc/docker/daemon.json
    else
        echo ""
        echo " Changement d'autorisations non réalisé "
        echo ""
  

    fi


 
fi 




