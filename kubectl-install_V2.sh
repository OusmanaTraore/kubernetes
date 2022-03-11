#!/bin/bash
echo "===================================================================================>"
echo "Vérifier l'adresse IP ... "
#sleep 2
echo " Adresses IP disponibles"
for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
do
    echo "===> $i"
done

echo "===================================================================================>"
read -p "Entrez l'adresse IP de la machine: " IP_ETH1 
echo "===================================================================================>"

echo "||========================  Début installation  ==================================||"
echo "||=================  ETAPE 1/9  Désactivation de la swap   =======================||"
sleep 2
### Désactiver la swap  et la rendre persistente
echo " Désactivation de la swap  et la rendre persistente "

sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo ""
###Installation de docker
echo "||=================   ETAPE 2/9  Installation de docker    =======================||"
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
sudo apt install -y docker-ce
if [ $? -ne 0 ];
then
    echo "ECHEC installation de docker "
    exit 1
else
    sleep 2
    echo " installation de docker OK" 
    echo "||=======   ETAPE 3/9  Configuration du fichier  /etc/docker/daemon.json  ========||"
    # echo " Création et configuration du fichier /etc/docker/daemon.json"
    # echo "===================================================================================>"
    # sleep 2
    # echo ""
    # echo " Editer le fichier \"/etc/docker/daemon.json\"  et insérer le code suivant: "
    # echo " { \"exec-opts\": [\"native.cgroupdriver=systemd\"] } "
    # echo " Ensuite lancer le script kubectl-install_2-3.sh"
    # echo "..."
fi 

#####============================================================================

DAEMON_VAR="{ \"exec-opts\": [\"native.cgroupdriver=systemd\"] }"
sudu su -
sleep 3 
cat { \"exec-opts\": [\"native.cgroupdriver=systemd\"] } > /etc/docker/daemon.json
exit
sleep2 
echo "||====== Vérification  fichier /etc/docker/daemon.json ... =====>"

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
    echo "||=======   ETAPE 4/9  Redémarrage du service docker  ============================||"

    sudo systemctl restart docker
    if [ $? -ne 0 ]; 
    then
        echo " ERREUR DE DEMARRAGE DOCKER"
        exit
    else
        sudo systemctl status  docker | grep Active  
        echo "||=======   ETAPE 5/9  Téléchargement des packages kubernetes  ===================||"
        sleep 2
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        bionic stabe"
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
        sudo mv ~/kubernetes.list /etc/apt/sources.list.d
        sudo apt update
        echo ""

        echo "||=======   ETAPE 6/9  Installation de kubelet kubeadm kubectl kubernetes-cni  ===||"
        sleep 2
        sudo apt install -y kubelet 
        sudo apt install -y kubeadm 
        sudo apt install -y kubectl 
        sudo apt install -y kubernetes-cni
        fi
        # if [ $? -ne 0 ]; 
        # then
        #     echo " ECHEC  étape installation kubeadm kubectl kubernetes-cli "
        #     exit
        # else
        #     # echo "||=======   PLEASE  =======|=======   PLEASE  =======|======   PLEASE  =======||"
        #     # echo " Veuillez éditer le fichier  \"/etc/default/kubelet\" et insérer le code suivant: "
        #     # echo ""
        #     # echo KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\"
        #     # sleep 2
        #     # echo ""
        #     # echo "Ensuite lancez le script kubectl-install_3-3.sh"
        #     # echo "..."
        # fi
fi

#####============================================================================
KUBELET_VAR="KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\""
echo "||=======   ETAPE 7/9  Configuration kubernetes  \"/etc/default/kubelet\"  =======||"
echo "||====== Vérification  /etc/default/kubelet... =====>"
sleep 1
sudo su - 
sleep 3
cat KUBELET_VAR="KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\"" > /etc/default/kubelet
exit
sleep 2

if [ $( cat /etc/default/kubelet ) != "KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\"" ];
then
    echo "ERREUR de configuration du fichier /etc/default/kubelet"
    echo "Corrigez le  fichier puis relancer le script"
    echo "..."
    exit
else
  echo "<=== Configuration du fichier /etc/default/kubelet ===>"
  echo "===>...OK"
  echo ""
  echo "||=======   ETAPE 8/9  Redémarrage des services daemon  et kubelet  ==============||"
  sleep 2

  echo " 1/2 - Redémarrage daemon"
  sudo systemctl  daemon-reload
fi
  if [ $? -ne 0 ];
  then
    echo "ECHEC daemon-reload"
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
                echo "========//\\========="
                echo "installation réussie "
                echo "========\\//=========" 

        else

                echo "========//\\========//\\=======//\\==="
                echo "     echec du démarrage de kubelet"
                echo "========\\//========\\//=======\\//===" 
        fi
    echo ""
    sleep 2
    echo "||=======   ETAPE 9/9  node ou master   ==========================================||"
    echo " Si votre machine est master , taper \"m\" , si c'est un node alors taper \"n\": "
    read -p " Machine \"master\" ou \"node\" ?: "  choice
 
    case $choice in
     m)   
          echo "Vous avez choisi master. "
          echo "||=======   ETAPE 9/9  Master (Initialisation du cluster)  =================||"
          echo "||=======   1/4     Initialisation du cluster   =======================||"
          sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$IP_ETH1 --ignore-preflight-errors=NumCPU
          while [ $? -ne 0 ];
          do
          echo "ECHEC d'initialisation du cluster, nouvel essai..."
          sleep 2
          sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$IP_ETH1 --ignore-preflight-errors=NumCPU
          done
          echo "||=======   2/4     Configuration de \$HOME/.kube   ===================||"
          echo " mkdir -p \$HOME/.kube"
          echo " sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config"
          echo " sudo chown $(id -u):$(id -g) \$HOME/.kube/config"
          echo "...."
          sleep 2
          read -p " Taper entrez pour continuer: " entree
          mkdir -p $HOME/.kube
          sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
          sudo chown $(id -u):$(id -g) $HOME/.kube/config
          echo ""
          echo "Tester l\'acces au cluster"
          echo "||=======   3/4     Tester l\'acces au cluster  =======================||"
          kubectl cluster-info
          sleep 2
          kubectl get nodes 
          sleep 2
          kubectl get pods -n kube-system
          sleep 2
          echo "||=======   4/4     Configuration  du réseau   ========================||"
          kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
          echo ""
          echo " Copier la ligne de code ci-dessous et appliquer la aux nodes pour joindre le cluster"
          sudo kubeadm token create --print-join-command
          ;;
     n)
          echo "node?"
          echo "===> OK  "
          sleep 2
          echo "||=======   ETAPE 9/9  FIN de l'installation sur le node   =================||"
          ;;
     *)
          echo "Sorry, invalid input"
          ;;
    esac
    echo "||=======   ETAPE 9/9  FIN des opérations   ================================||"
    
   fi

