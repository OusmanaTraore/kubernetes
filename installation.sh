#!/bin/bash
read -p "Entrez une derniere fois l'adresse IP de la machine: " IP_ETH1
KUBELET_VAR="KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\""

echo "======      ETAPE 7/9   ========="
echo " configuration kubernetes"

echo " Vérification de la configuration du fichier /etc/default/kubelet"
sleep 3
#sudo echo KUBELET_EXTRA_ARGS="--node-ip=$IP_ETH1" > "/etc/default/kubelet"
test_kubelet=`sudo cat /etc/default/kubelet`

if [ $test_kubelet != $KUBELET_VAR ];
then
    echo "ERREUR de configuration du fichier /etc/default/kubelet"
    echo "Corrigez le  fichier puis relancer le script"
    echo "..."
    exit
else
  echo "<=== Configuration du fichier /etc/default/kubelet ===>"
  echo "===>...OK"
  echo ""
  echo "======      ETAPE 8/9   ========="
  echo "Redémarrage des services daemon  et kubelet"
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

                echo "========//\\=================="
                echo " echec du démarrage de kubelet"
                echo "========\\//==================" 
        fi
    echo ""
    sleep 2
    
    echo ""
    read -p " Machine \"master\" ou \"node\" ? "  choice
 
    case $choice in
     master)
          echo sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$IP_ETH1 --ignore-preflight-errors=NumCPU
          echo "===wait a bit please ===
          sleep 2
          mkdir -p $HOME/.kube
          sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
          sudo chown $(id -u):$(id -g) $HOME/.kube/config
          echo ""
          echo "=========================="
          echo "Tester l\'acces au cluster"
          echo "=========================="
          kubectl cluster-info
          sleep 2
          kubectl get nodes 
          sleep 2
          kubectl get pods -n kube-system
          sleep 2
          echo "========================="
          echo "Configuration du réseau  "
          echo "========================="
          kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
          echo " Copier la ligne de code ci-dessous et appliquer la aux nodes pour joindre le cluster
          sudo kubeadm token create --print-join-command
          ;;
     node)
          echo "node?"
          echo "===> OK  "
          sleep 2
          echo "============================================"
          echo "===== Fin de l'opération                ===="
          echo "============================================"
          ;;
     *)
          echo "Sorry, invalid input"
          ;;
    esac
      sleep 2
          echo "============================================"
          echo "===== Fin de toutes les  opérations     ===="
          echo "============================================"
    
   fi
