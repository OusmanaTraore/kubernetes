#!/bin/bash
reset_and_remove(){
 
     sudo kubeadm reset
     sudo rm -rf /etc/cni/net.d
     sudo apt purge kubeadm kubelet kubectl -y
     sudo apt autoremove
     sudo sed -i  "1d" /etc/hosts 
     sudo rm -R $HOME/.kube
     }
reset_and_remove
e
