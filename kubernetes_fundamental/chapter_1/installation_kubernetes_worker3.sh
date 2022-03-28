#!/bin/bash
source variables.sh

echo -e "
=============================================================
||||       Lancer le script en mode privilégié !!!       ||||
=============================================================
"
sudo -i

### Joindre le noeud au master
echo " Joindre le noeud au master > "
kubeadm join --token $token k8smaster:6443 --discovery-token-ca-cert-hash sha256:$sha256


