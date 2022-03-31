#!/bin/bash

TOCKEN="k92kqs.5dvbvtxq9dh9wb70"
SHA256="2dc46b381da9b528b8ede486e7cb2c31e8c57555b380e4d871d9a38cc37fa7cf"

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

### Joindre le noeud au master
echo " Joindre le noeud au master > "
kubeadm join --token $TOCKEN k8smaster:6443 --discovery-token-ca-cert-hash sha256:$SHA256
fi

echo -e "
================================================================
||||       Rebasculer  en mode standard !!!                 ||||
================================================================
"
