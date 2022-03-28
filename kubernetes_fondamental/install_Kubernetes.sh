#!/bin/bash

### Etape 1 
### Update y Upgrade
sudo -i 
apt-get update && apt-get upgrade -y
apt-get install -y vim

apt-get install -y docker.io

echo "1 deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

### Download package
curl -s \
https://packages.cloud.google.com/apt/doc/apt-key.gpg \
| apt-key add -

apt-get update


### Installation de kubelet

apt-get install -y \
kubeadm=1.19.1-00 kubelet=1.19.1-00 kubectl=1.19.1-00

apt-mark hold kubelet kubeadm kubectl

### Installation calico 
wget https://docs.projectcalico.org/manifests/calico.yaml


sed -e "s/#- name: CALICO_IPV4POOL_CIDR/- name: CALICO_IPV4POOL_CIDR/g" calico.yaml
sed -e "s/# value: \"192.168.0.0/16\"/ value: \"192.168.0.0/16\"/g" calico.yaml


# sed -n -e "/`echo $USER`/s/[^:]*:[^:]*:\([^:]*\):\([^:]*\):.*/UID=\1\nGID=\2/p" /etc/passwd