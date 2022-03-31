#!/bin/bash


#sudo -i
read -p  " Passer en mode root , puis exécuter le script: sudo -i \n" var_root

`$var_root`

if [ "$EUID" -ne 0 ]
then 
  echo "Please run as root"
  echo -e "
          =============================================================
          ||||       Lancer le script en mode privilégié !!!       ||||
          =============================================================
          "
  exit
else
### Update y upgrade 
echo " Update y upgrade > "
apt-get update && apt-get upgrade -y


### Installation de Vim
echo " Installation de Vim > "
apt-get install -y vim

### Installation de Docker
echo " Installation de Docker >  "
apt-get install -y docker.io


### Ajout du repo pour kubernetes
echo " Ajout du repo pour kubernetes > "
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
cat /etc/apt/sources.list.d/kubernetes.list

###  Ajout  de clé GPG pour le package
echo " Ajout  de clé GPG pour le package > "
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

### UPDATE DU REPO
echo " UPDATE du repo > "
apt-get update  -y

### INSTALLATION de Kubeadm kubelet et kucectl v1.19
echo " Installation de kubeadm kubelet et kucectl v1.19 > "
apt-get install -y \
kubeadm=1.19.1-00 kubelet=1.19.1-00 kubectl=1.19.1-00

### MARQUAGE de kubeadm kubelet et kucectl 
echo " Marquage de kubeadm kubelet et kucectl > "
apt-mark hold kubelet kubeadm kubectl

### TELECHARGEMENT du plugin  Calico pour les Network Policies
echo " TELECHARGEMENT du plugin Calico pour les Network Policies > "
wget https://docs.projectcalico.org/manifests/calico.yaml

### Edition du  fichier de configuration calico.yml
echo -e "
=================================================================
||||    Edition du fichier de configuration calico.yml >     ||||
=================================================================
# - name: CALICO_IPV4POOL_CIDR 
#   value: \"192.168.0.0/16\"
"
echo " < ======================================================= >"
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
echo " < ======================================================= >"

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
echo " < ======================================================= >"

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
sleep 2
### Initialisation de kubeadm
echo " Initialisation de kubeadm et sauvegarde dans kubeadm-init.out> "
kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out 
echo -e "
=================================================================================
||||                      Lancer le script master_file2.sh                   ||||
                              en tant que user standard
=================================================================================
"

fi
