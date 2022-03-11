#!/bin/bash
#source kubectl-install_1-3.sh
KUBELET_VAR="KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\""
echo "===================================================================================>"
echo "Vérifier l'adresse IP ... "
#sleep 2
echo " Adresses IP disponibles"
for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
do
    echo "===> $i"
done

echo "===================================================================================>"
read -p "Entrez  de nouveau l'adresse IP de la machine: " IP_ETH1 
sleep 2
echo "||=======   ETAPE 7/9  Configuration kubernetes  \"/etc/default/kubelet\"  =======||"
echo "||====== Vérification ... =====>"
sleep 3
#sudo echo KUBELET_EXTRA_ARGS="--node-ip=$IP_ETH1" > "/etc/default/kubelet"
test_kubelet=`sudo cat /etc/default/kubelet`

if [ $test_kubelet != $KUBELET_VAR ];
then
    echo "ERREUR de configuration du fichier /etc/default/kubelet"
    echo "Corrigez le  fichier puis relancer le script"
    echo "..."
 #   exit
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
    echo " Si votre machine est master , taper \"m\" , si node taper \"n\": "
    read -p " Machine \"master\" ou \"node\" ?: "  choice
 
    case $choice in
     m)   
          echo "Vous avez choisi master."
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

