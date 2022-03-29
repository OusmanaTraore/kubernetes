#!/bin/bash

export TOCKEN="fq8dis.s0g6blttc8g04aen"
export SHA256="ba93ce6a38c6ef55ea28b3dbd884d005ef8d279e7d87c8fc4561d1cb52952945"

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
