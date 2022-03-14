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

echo "|||========================  Début installation  =============================|||"
echo "|||=================  ETAPE 1/9  Désactivation de la swap   ==================|||"
sleep 2
### Désactiver la swap  et la rendre persistente
echo " Désactivation de la swap  et la rendre persistente "

sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo ""
###Installation de docker
echo "|||=================   ETAPE 2/9  Installation de docker    =====================|||"
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
    echo "|||======   ETAPE 3/9  Configuration du fichier  /etc/docker/daemon.json  ======|||"
    echo " Création et configuration du fichier /etc/docker/daemon.json"
    echo "===============================================================================>"
    sleep 2
    echo ""
    echo " Création et changement d'autorisation du fichier /etc/docker/daemon.json !? "
    echo "===>"
    sudo touch /etc/docker/daemon.json
    #sudo ls -la /etc/docker/daemon.json
    sudo chmod 646 /etc/docker/daemon.json
    sudo echo { \"exec-opts\": [\"native.cgroupdriver=systemd\"] } > /etc/docker/daemon.json
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


 
fi 
###
DAEMON_VAR="{ \"exec-opts\": [\"native.cgroupdriver=systemd\"] }"
echo "|||=======   ETAPE 4/9  Redémarrage du service docker  ====================|||"
sudo systemctl restart docker
if [ $? -ne 0 ]; 
    then
        echo " ERREUR DE DEMARRAGE DOCKER"
        exit
    else
        sudo systemctl status  docker | grep Active  
        echo "|||=======   ETAPE 5/9  Téléchargement des packages kubernetes  ========|||"
        sleep 2
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        bionic stabe"
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
        sudo mv ~/kubernetes.list /etc/apt/sources.list.d
        sudo apt update
        echo ""
        echo "|||====   ETAPE 6/9  Installation de kubelet kubeadm kubectl kubernetes-cni  ===|||"
        sleep 2
        sudo apt install -y kubelet 
        sudo apt install -y kubeadm 
        sudo apt install -y kubectl 
        sudo apt install -y kubernetes-cni
        if [ $? -ne 0 ]; 
        then
            echo " ECHEC  étape installation kubeadm kubectl kubernetes-cli "
            exit
        else
            sleep 2
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
            sleep 2
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
sleep 2
echo "|||====   ETAPE 7/9  Configuration kubernetes  \"/etc/default/kubelet\"  ===|||"
echo ""
echo " Vérification du dossier  /etc/default/kubelet  == ok"
sudo cat /etc/default/kubelet
echo ""
sleep 3

echo "|||=======   ETAPE 8/9  Redémarrage des services daemon  et kubelet  =====|||"
sleep 2

  echo " 1/2 - Redémarrage daemon"
  sudo systemctl  daemon-reload

  if [ $? -ne 0 ];
  then
    echo 
    exit
  else
    sleep 2
    echo " 2/2 - Redémarrage kubelet"
    sudo systemctl restart kubelet
    sudo systemctl status  kubelet | grep Active
    sleep 1
        if  [[ `sudo systemctl status kubelet | grep loaded` ]];
        then
            sleep 2
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
    echo ""
#     echo "|||=======   ETAPE 9/9  node ou master?  =================================|||"
#     echo ""
#             echo "|||======================================|||"
#             echo "|||=======                       ========|||"
#             echo "|||       Si votre machine est master,   |||"
#             echo "|||=======     taper \"m\"         ========|||"
#             echo "|||                                      |||"
#             echo "|||=======                       ========|||"
#             echo "|||       Si votre machine est node,     |||"
#             echo "|||=======      taper \"n\"        ========|||"
#             echo "|||================|======|==============|||"
#     echo "  "
#    fi

#     read -p " Machine \"master\" ou \"node\" ?: "  choice
 
#     case $choice in
#      m)   
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
#      n)
#           echo "node?"
#           echo "===> OK  "
#           sleep 2
#           echo "|||=======   ETAPE 9/9  FIN de l'installation sur le node   ==============|||"
#           echo "|||=======   ETAPE 9/9  FIN des opérations   =============================|||"
#           ;;
#      *)
#           echo "Sorry, invalid input"
#           ;;
#     esac
   
    
