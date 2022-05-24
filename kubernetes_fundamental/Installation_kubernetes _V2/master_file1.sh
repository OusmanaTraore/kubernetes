#!/bin/bash
###====================================================================
###                          FONCTIONS                              ###
reset_and_remove(){
     sudo kubeadm reset
     sudo rm -rf /etc/cni/net.d
     sudo apt purge kubeadm kubelet kubectl -y
     sudo apt autoremove
     sudo rm -R $HOME/.kube
     if [  "${IP_ETH1}" ] 
     then
	     sudo sed -i "s/^$IP_ETH1.*$//"  /etc/hosts
     else
	     sudo sed -i "s/^192.*$//"  /etc/hosts
     fi
    
     }


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

### Update y upgrade 
echo " Update y upgrade > "
apt-get update && apt-get upgrade -y


### Installation de Vim
echo " Installation de Vim > "
apt-get install -y vim

### Installation de Docker
echo " Installation de Docker >  "
sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
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

### INSTALLATION de Kubeadm kubelet et kucectl v1.23
echo " Installation de kubeadm kubelet et kucectl v1.23 > "
verSion="1.23.0-00"
apt-get install -y \
kubeadm=$verSion kubelet=$verSion kubectl=$verSion

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

#sed -i -e "4333 s/# //g" calico.yaml
#sed -i -e "4334 s/# //g" calico.yaml
#awk ' {print NR "-" , $0 }' calico.yaml | grep '4333\|4334\|4335\|4336'

Numero_ligneCALICO_IPV4POOL_CIDR_Name=`awk ' {print NR "-" , $0 }' calico.yaml  | grep  CALICO_IPV4POOL_CIDR | cut -d "-" -f 1`
Numero_ligneCALICO_IPV4POOL_CIDR_Value=`awk ' {print NR "-" , $0 }' calico.yaml  | grep  192.168.0.0/16 | cut -d "-" -f 1`

sed  -i "$Numero_ligneCALICO_IPV4POOL_CIDR_Name s/# //" calico.yaml
sed  -i "$Numero_ligneCALICO_IPV4POOL_CIDR_Value s/# //" calico.yaml

awk ' {print NR "-" , $0 }' calico.yaml | grep ^"$Numero_ligneCALICO_IPV4POOL_CIDR_Name\|$Numero_ligneCALICO_IPV4POOL_CIDR_Value"


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
sed -i  "1a  $IP_ETH1 k8smaster " /etc/hosts 
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
kubernetesVersion: 1.23.0
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
kubernetesVersion: 1.23.0
controlPlaneEndpoint: "k8smaster:6443"
networking:
  podSubnet: 192.168.0.0/16
EOF

cat kubeadm-config.yaml



### Initialisation de kubeadm
echo " Initialisation de kubeadm et sauvegarde dans kubeadm-init.out> "
kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out 

echo -e "
|> Installation de firewalld
"
sudo apt install firewalld
if [ $? == 0 ]
#then
#	firewall-cmd --add-port=179/tcp --permanent
	firewall-cmd --add-port=6443/tcp --permanent
	firewall-cmd --reload
fi


sleep 2
echo -e "
=================================================================================
||||                      Lancer le script master_file2.sh                   ||||
                              en tant que user standard
=================================================================================
"

fi
