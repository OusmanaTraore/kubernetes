#!/bin/bash

## Kubeadm reset

kube_rest(){
 echo " | DELETING config file...|"
 kubeadm reset
 rm /etc/containerd/config.toml
 echo " | RESTARTING containerd...|"
 systemctl restart containerd
 echo " | INITIALIZING kubeadm...|"
 kubeadm init
}
kube_reset
