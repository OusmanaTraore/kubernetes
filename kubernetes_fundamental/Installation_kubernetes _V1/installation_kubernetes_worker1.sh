#!/bin/bash

if [ "$EUID" -ne 0 ]
then 
  echo "Please run as root"
  echo -e "
          =============================================================
          ||||       Lancer le script en mode privilégié !!!       ||||
          =============================================================
          "
  exit
else
echo "Vérifier l'adresse IP ... "
#sleep 2
echo " Adresses IP disponibles"
for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
do
    echo "===> $i"
done

echo "================================================================================================>"
read -p "Entrez l'adresse IP de la machine: k8smaster" IP_ETH1 
echo "================================================================================================>"
sleep 2
### Update y upgrade 
echo " Update y upgrade > "
apt-get update && apt-get upgrade -y

echo " Désactivation de la swap "
sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

### Installation de Vim
echo " Installation de Vim > "
apt-get install -y vim

### Installation de Docker
echo " Installation de Docker >  "
apt-get install -y docker.io

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
### Ajout du repo pour kubernetes
echo " Ajout du repo pour kubernetes > "
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
cat /etc/apt/sources.list.d/kubernetes.list

###  Ajout  de clé GPG pour le package
echo " Ajout  de clé GPG pour le package > "
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

### UPDATE DU REPO
echo " UPDATE du repo > "
apt-get update  -y

### INSTALLATION de Kubeadm kubelet et kucectl v1.19
echo " Installation de kubeadm kubelet et kucectl v1.19 > "
apt-get install -y \
kubeadm=1.19.1-00 kubelet=1.19.1-00 kubectl=1.19.1-00

### MARQUAGE de kubeadm kubelet et kucectl 
echo " Marquage de kubeadm kubelet et kucectl > "
apt-mark hold kubelet kubeadm kubectl

sleep 2
echo -e "
================================================================
||||            Edition du fichier /etc/hots  >             ||||
================================================================
Ajout de  la ligne suivante au dessus de \"127.0.0.1 localhost \"
===>   
IP_de_votre_master k8smaster (ex: 192.168.58.25 k8smater)
===>
"
sleep 2
sed -i -e "1a  $IP_ETH1 k8smaster " /etc/hosts 
echo " < ======================================================= >"

cat /etc/hosts | grep k8smaster

echo -e "
============================================================================
|||| Lancer le script installation_kubernetes_master3.sh  sur le master ||||
============================================================================
"

fi
