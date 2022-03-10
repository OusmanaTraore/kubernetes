#!/bin/bash
IP_ETH1="192.168.50.20"
echo "======      ETAPE 7/9   ========="
echo " configuration kubernetes"
sleep 2

#sudo echo KUBELET_EXTRA_ARGS="--node-ip=$IP_ETH1" > "/etc/default/kubelet"
sudo cat "/etc/default/kubelet"

if [ $? -ne  KUBELET_EXTRA_ARGS="--node-ip=$IP_ETH1"  ] ;
then
  echo "Défaut de configuration du fichier /etc/default/kubelet"
  exit 
else
  echo "======      ETAPE 8/9   ========="
  echo "Redémarrage des services daemon  et kubelet"
  sleep 2

  echo " 1/2 - Redémarrage daemon"
  systemctl  daemon-reload
  if [ $? -ne 0 ];
  then
    echo "ECHEC daemon-reload"
    exit
  else
    sudo systemctl status daemon-reload
    sleep 2
    echo " 2/2 - Redémarrage kubelet"
    sudo systemctl restart kubelet
    sudo systemctl status  kubelet
    sleep 1

    echo ""
    echo ""
    echo "======      ETAPE 9/9   ========="
    echo " Initialisation de Kubeadm "
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$IP_ETH1  --ignore-preflight-errors=NumCPU
   fi

fi
