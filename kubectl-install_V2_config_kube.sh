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
      
          echo "|||=======   2/4     Configuration de \$HOME/.kube   ================|||"
          echo " mkdir -p \$HOME/.kube"
          echo " sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config"
          echo " sudo chown $(id -u):$(id -g) \$HOME/.kube/config"
          echo "...."
          sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$IP_ETH1 --ignore-preflight-errors=NumCPU
          sleep 2
          mkdir -p $HOME/.kube
          sudo cat $HOME/.kube
          sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
          sudo cat $HOME/.kube/config
          sudo chown $(id -u):$(id -g) $HOME/.kube/config
          echo ""
         
          echo "|||=======   3/4     Tester l'acces au cluster  ====================|||"
          kubectl cluster-info
          sleep 2
          kubectl get nodes 
          sleep 2
          kubectl get pods -n kube-system
          sleep 2
          echo "|||=======   4/4     Configuration  du réseau   =====================|||"
          kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
           echo ""
            echo "|||================================================|||"
            echo "|||=======                       ==================|||"
            echo "|||                                                |||"
            echo "|||======= Joignez vos nodes au cluster ===========|||"
            echo "||| via la commande kubeadm  fournie plus haut...  |||"
            echo "|||=======                       ==================|||"
            echo "|||================|======|========================|||"
            echo "  "
            sudo kubeadm token create --print-join-command
