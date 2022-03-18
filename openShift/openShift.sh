#!/bin/bash
echo "=================================================================================>"
echo "Vérifier l'adresse IP ... "
#sleep 2
echo " Adresses IP disponibles"
for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
do
    echo "===> $i"
done

echo "=================================================================================>"
read -p "Entrez l'adresse IP de la machine: " IP_ETH1 
echo "=================================================================================>"

### Installation de  docker
sudo apt-get install docker.io -y

### Démarrage de docker
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker | grep Active

#### Installation d'openShift
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

#### Extraction du fichier
tar -xvzf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

### Copie des binaires
sudo cd openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit
sudo cp oc kubectl /usr/local/bin/

#### Vérification de la version d'openShift
oc version

echo " Création et configuration du fichier /etc/docker/daemon.json"
 sudo touch /etc/docker/daemon.json
    #sudo ls -la /etc/docker/daemon.json
    sudo chmod 646 /etc/docker/daemon.json
    sudo echo {"insecure-registries" : [ "172.30.0.0/16" ]} > /etc/docker/daemon.json
    if [ $?  == 0 ]; then
    echo ""
    echo "Changement d'autorisation == OK "
    echo "===>"
    #sudo ls -la /etc/docker/daemon.json
    echo  " Configuration /etc/docker/daemon.json == OK "
    echo "===>"
    echo ""
    echo  " Vérification fichier /etc/docker/daemon.json == OK "
    sleep 2
    sudo cat /etc/docker/daemon.json
    sudo chmod 644 /etc/docker/daemon.json
    # echo ""
    # echo " Rétablissement des autorisations "
    # echo "===>"
    # echo ""
    # sudo ls -la /etc/docker/daemon.json
    else
        echo ""
        echo " Changement d'autorisations non réalisé "
        echo ""
  

    fi
	
sudo systemctl restart docker
sudo systemctl status docker | grep Active

#### Démarrage du cluster openShift 

oc cluster up --public-hostname=$IP_ETH1

#if [ $?  == 0 ]; then
#
#echo "=================================================================================>"
#echo " Se connecter en tant que développeur ou admin? "
#read -p " Taper \"d\" pour développeur , \"a\" pour admin: "  choice
#echo "=================================================================================>"
#
#
#     case $choice in
#      d)   
#           echo "Vous avez choisi master."
#           echo "|||=======   ETAPE 9/9  Master (Initialisation du cluster)  ==============|||"
#           echo "|||=======   1/4     Initialisation du cluster   ====================|||"
#           sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$IP_ETH1 --ignore-preflight-errors=NumCPU
#           if [ $? -ne 0 ];
#           then
#           echo "ECHEC d'initialisation du cluster, nouvel essai..."
#           sleep 2
#           echo ""
#           echo " Reset de kubeadm "
#           echo ""
#           sudo systemctl stop kubelet
#           sudo kubeadm reset 
#           sudo systemctl daemon-reload
#           sudo systemctl restart kubelet
#           sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$IP_ETH1 --ignore-preflight-errors=all
#           else
#             echo "==== Configuration de \$HOME/.kube ==== "
#             echo ""
#             echo "|||======================================|||"
#             echo "|||=======                       ========|||"
#             echo "|||                                      |||"
#             echo "|||======= VEUILLEZ LANCER LE SCRIPT ====|||"
#             echo "|||  kubectl-install_V2_config_kube.sh   |||"
#             echo "|||=======                       ========|||"
#             echo "|||================|======|==============|||"
#             echo "  "
#           fi
    
#           ;;
#      a)
#	   echo "|||=======  Connection en tant qu'administrateur   ==============|||"
#		oc login -u system:admin
#           ;;
#      *)
#           echo "Sorry, invalid input"
#           ;;
#     esac


