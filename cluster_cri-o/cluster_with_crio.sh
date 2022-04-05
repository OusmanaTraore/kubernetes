#!/bin/bash

if [ "$EUID" -ne 0 ]
then 
  echo -e "Please run as root"
  echo -e "
          =============================================================
          ||||       Lancer le script en mode privilégié !!!       ||||
          =============================================================
          "
  exit
else

echo -e "================================================================================================>"
echo -e "Vérifier l'adresse IP ... "
#sleep 2
echo -e " Adresses IP disponibles"
for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
do
    echo -e "===> $i"
done

echo -e "================================================================================================>"
read -p "Entrez l'adresse IP de la machine: " IP_ETH1 
echo -e "================================================================================================>"

### Update y upgrade 
echo -e " 
====================
| Update y upgrade > 
====================
"
apt-get update && apt-get upgrade -y


### Installation de Vim
echo -e " 
=======================
| Installation de Vim >  
=======================
"
apt-get install -y vim

### Installation de 
echo -e " 
========================
| Installation de CRIO >  
========================
"
echo -e " 

| modprobe overlay >  
====================
"
modprobe overlay

echo -e " 

| modprobe br_netfilter >  
=========================
"
modprobe br_netfilter

echo -e " 

| sysctl config file to enable IP forwarding and netfilter settings persistently across reboots. >  
==================================================================================================
"

echo "
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
" > /etc/sysctl.d/99-kubernetes-cri.conf

cat /etc/sysctl.d/99-kubernetes-cri.conf

echo -e "

| sysctl command to apply the config file. >  
============================================
"
sysctl --system

echo -e "

| Installation of software package dependencies >  
=================================================
"
apt-get install -y software-properties-common


echo -e "

| Adding CRI-O software repository >  
====================================
"

echo -e "

| buster-backports apt list >  
=============================
"
echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/backports.list

echo -e "
==========
| Update > 
==========
"
apt update

echo -e "
================================================
| Installation of buster-backports libseccomp2 > 
================================================
"
apt install -y -t buster-backports libseccomp2 || apt update -y -t buster-backports libseccomp2
OS=xUbuntu_18.04
#VERSION=1.19:1.19.1-00
#VERSION=1.15
echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

mkdir -p /usr/share/keyrings
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

### Update 
echo -e "
==========
| Update > 
==========
"
apt-get update

echo -e " 

| Installation of CRI-O >  
=========================
"
apt-get install cri-o cri-o-runc

echo -e "
[crio.runtime.runtimes.runc]
runtime_path = ""
runtime_type = \"oci\"
runtime_root = \"/run/runc\"
" > /etc/crio/crio.conf.d/


### Ajout du repo pour kubernetes
echo -e " 
Ajout du repo pour kubernetes > "
echo -e "
deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
cat /etc/apt/sources.list.d/kubernetes.list

###  Ajout  de clé GPG pour le package
echo -e " 
Ajout  de clé GPG pour le package > "
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

### UPDATE DU REPO
echo -e " 
UPDATE du repo > "
apt-get update  -y

### INSTALLATION de Kubeadm kubelet et kucectl v1.19
echo -e " 
Installation de kubeadm kubelet et kucectl v1.19 > "
apt-get install -y \
kubeadm=1.19.1-00 kubelet=1.19.1-00 kubectl=1.19.1-00

### MARQUAGE de kubeadm kubelet et kucectl 
echo -e " 
Marquage de kubeadm kubelet et kucectl > "
apt-mark hold kubelet kubeadm kubectl

### TELECHARGEMENT du plugin  Calico pour les Network Policies
echo -e " 
TELECHARGEMENT du plugin Calico pour les Network Policies > "
wget https://docs.projectcalico.org/manifests/calico.yaml

### Edition du  fichier de configuration calico.yml
echo -e "
=================================================================
||||    Edition du fichier de configuration calico.yml >     ||||
=================================================================
# - name: CALICO_IPV4POOL_CIDR 
#   value: \"192.168.0.0/16\"
"
echo -e " < ======================================================= >"
sleep 2

sed -i -e "4222 s/# //g" calico.yaml
sed -i -e "4223 s/# //g" calico.yaml
awk ' {print NR "-" , $0 }' calico.yaml | grep '4222\|4223\|4224\|4225'

sleep 2
echo -e "
================================================================
||||            Edition du fichier /etc/hots  >             ||||
================================================================
Ajouter la ligne suivante au dessus de \"127.0.0.1 localhost \"
===>   
IP_de_votre_master k8smaster (ex: 192.168.58.25 k8smater)
===>
"
sleep 2
sed -i -e "1a  $IP_ETH1 k8smaster " /etc/hosts 
echo -e " < ======================================================= >"

cat /etc/hosts | grep k8smaster

echo -e "
================================================================
||||         Edition du  fichier kubeadm-config.yaml  >     ||||
================================================================
Insérer les lignes suivantes:
===>   
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: 1.19.1
controlPlaneEndpoint: \"k8smaster:6443\"
networking:
  podSubnet: 192.168.0.0/16
===>
"
echo -e " < ======================================================= >"

sleep 2
cat <<-EOF > kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: 1.19.1
controlPlaneEndpoint: "k8smaster:6443"
networking:
  podSubnet: 192.168.0.0/16
EOF

cat kubeadm-config.yaml

### Initialisation de kubeadm
echo -e " Initialisation de kubeadm et sauvegarde dans kubeadm-init.out> "
kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out 


sleep 2
echo -e "
=================================================================================
||||                      Lancer le script master_file2.sh                   ||||
                              en tant que user standard
=================================================================================
"

fi