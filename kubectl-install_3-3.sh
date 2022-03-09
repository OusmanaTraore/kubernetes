#!/bin/bash
echo "======      ETAPE 7/9   ========="
echo " configuration kubernetes"
sleep 2
echo "SKIP"
sudo echo KUBELET_EXTRA_ARGS="--node-ip=$IP_ETH1" > "/etc/default/kubelet"
sudo cat "/etc/default/kubelet"

echo "======      ETAPE 8/9   ========="
echo "Redémarrage des services docker , daemon  et kubelet"
sleep 2
echo " 1/3 - Redémarrage docker"
sudo systemctl restart docker
sudo systemctl status docker
sleep 1
echo "q"
echo " 2/3 - Redémarrage daemon"
sudo systemctl  daemon-reload
sudo systemctl status daemon-reload
sleep 1
echo `q`

echo " 3/3 - Redémarrage kubelet"
sudo systemctl restart kubelet
sudo systemctl status  kubelet
sleep 1

echo ""
echo ""
echo "======      ETAPE 9/9   ========="
echo " Initialisation de Kubeadm "
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.205.10  --ignore-preflight-errors=NumCPU
