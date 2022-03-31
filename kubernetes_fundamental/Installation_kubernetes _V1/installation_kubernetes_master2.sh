#!/bin/bash

if [ "$EUID" -ne 1000 ]
then 
  echo "Please run as standard user"
  echo -e "
          =============================================================
          ||||       basculer en mode standard !!!   !!!           ||||
          =============================================================
          "
  exit
else

### Configuration du répertoire de kube
echo " Configuration du répertoire de kube > "
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

### Application du plugin de configuration réseaux
echo " Application du plugin de configuration réseaux >  "
sudo cp /root/calico.yaml .


### Application de la configmap de calico
echo " Application de la configmap de calico > "
kubectl apply -f calico.yaml


###  Installation de bash completion
echo " Installation de bash completion > "
sudo apt-get install bash-completion -y
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> $HOME/.bashrc

### View kubeadm-config file
echo " View kubeadm-config file > "
sudo kubeadm config print init-defaults


echo -e "
=================================================================================
|||| Lancer le script installation_kubernetes_worker1.sh  sur le worker      ||||
=================================================================================
"
fi
