#!/bin/bash
#source installation_kubernetes_master1.sh
###====================================================================
###                          FONCTIONS                              ###
# reset_and_remove(){
#     kubeadm reset
#     rm -rf /etc/cni/net.d
#     apt purge kubeadm kubelet kubectl -y
#     apt autoremove
#     echo -e " failed to init kubeadm
#     retrying...
#     "
#     sleep 2
#     kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out \
#     }

###====================================================================

if [ "$EUID" -ne 1000 ];
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

### Listes des tocken 
echo " Listes des tocken > "
sudo kubeadm token list

### Création du tocken 
echo " Création du tocken > "
TOCKEN=$(sudo kubeadm token create) 2>/dev/null
$TOCKEN 2>/dev/null


### Création du Discovery Token CA Cert Hash 
echo -e " Création du Discovery Token CA Cert Hash 
(permettant la jointure des noeuds de manière sécurisée) >  "
export SHA256=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa \
-pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')  2>/dev/null
$SHA256 2>/dev/null

sleep 2

echo -e "
============================================================================
||||              Récupération du tocken et du  sha256                  ||||

"
echo -e "

||||                ....    Envoi des secrets  dans secret.sh           ||||
============================================================================

"
cat << EOF > secret.sh
#!/bin/bash
EOF

sed -i -e "2a TOCKEN=\"$TOCKEN\"" secret.sh
sed -i -e "3a SHA256=\"$SHA256\"" secret.sh

cat << EOF >> secret.sh

sed -i -e "2a TOCKEN=\"$TOCKEN\"" secret.sh
sed -i -e "3a SHA256=\"$SHA256\"" secret.sh

if [[ worker_file.sh ]] 
then
  sed -i -e "2a TOCKEN=\"$TOCKEN\"" worker_file.sh
  sed -i -e "3a SHA256=\"$SHA256\"" worker_file.sh
else 
  exit
fi
echo -e "
============================================================================
||||                  Exécuter le fichier                               ||||

||||                      worker_file.sh                                ||||
============================================================================
"
EOF

sleep 2
grep -e "^sed -i -e "2a"  secret.sh |  sed -i "d" 
grep -e "^sed -i -e "3a"  secret.sh |  sed -i "d" 
sleep 2
cat secret.sh

sleep 3
echo -e "
============================================================================
||||            Fin d'installation sur le master                        ||||
============================================================================
"
echo -e "
============================================================================
||||   Récupérer  le fichier secret.sh                                  ||||

||||  puis placer le dans le même répertoire contenant le  fichier      ||||
||||       worker_file.sh ,puis executer le!                            ||||
============================================================================
"
fi
