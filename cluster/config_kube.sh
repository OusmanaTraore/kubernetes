#!/bin/bash
#echo "======================================================================================>"
#echo "Vérifier l'adresse IP ... "
#sleep 2
#echo " Adresses IP disponibles"
#for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
#do
#    echo "===> $i" 
#done

#echo "======================================================================================>"
#read -p "Entrez l'adresse IP de la machine: " IP_ETH1 
#echo "================================================================================================>"

IP_ETH1=$(ip a | cut -d " " -f 6 | grep ^192 | cut -d "/" -f 1)
echo "|||========================  Début installation  =============================|||"
echo "L'adresse IP est $IP_ETH1"     

          echo "|||=======   1/3     Configuration de \$HOME/.kube   ================|||"
          echo " mkdir -p \$HOME/.kube"
          echo " sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config"
          echo " sudo chown $(id -u):$(id -g) \$HOME/.kube/config"
          echo "...."
          sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$IP_ETH1 --ignore-preflight-errors=NumCPU
          sleep 2
          mkdir -p $HOME/.kube
          sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
          sudo chown $(id -u):$(id -g) $HOME/.kube/config
          echo ""
          echo "|||=======   2/3     Tester l'acces au cluster  ====================|||"
          kubectl cluster-info
          sleep 2
          kubectl get nodes 
          sleep 2
          kubectl get pods -n kube-system
          sleep 2
          echo "|||=======   3/3     Configuration  du réseau   =====================|||"
          kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
           echo ""
            echo "|||================================================|||"
            echo "|||=======                       ==================|||"
            echo "|||                                                |||"
            echo "|||======= Joignez vos nodes au cluster ===========|||"
            echo "|||                                                |||"
            echo "|||=======                       ==================|||"
            echo "|||================|======|========================|||"
            echo "  sudo kubeadm token create --print-join-command   "


        sudo kubeadm join 192.168.56.35:6443 --token brzyg4.zxnfa4zsijh9w6dg --discovery-token-ca-cert-hash sha256:06068af216232c1dea35c799ba1e3f2f919510ccee0ebd685b84fe6bca31a419