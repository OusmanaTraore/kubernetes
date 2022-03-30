#!/bin/bash

### Listes des tocken 
echo " Listes des tocken > "
sudo kubeadm token list

### Création du tocken 
echo " Création du tocken > "
sudo kubeadm token create

### Création du Discovery Token CA Cert Hash 
echo -e " Création du Discovery Token CA Cert Hash 
(permettant la jointure des noeuds de manière sécurisée) >  "
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa \
-pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //' 

echo -e "
============================================================================
|||| Lancer le script installation_kubernetes_worker2.sh  sur le worker ||||
============================================================================
"