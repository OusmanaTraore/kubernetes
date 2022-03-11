#!/bin/bash
source kubectl-install_1-3.sh

KUBELET_VAR="KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\""

echo "======      ETAPE 7/9   ========="
echo " configuration kubernetes"

echo " Vérification de la configuration du fichier /etc/default/kubelet"
sleep 3
#sudo echo KUBELET_EXTRA_ARGS="--node-ip=$IP_ETH1" > "/etc/default/kubelet"
test_kubelet=`sudo cat /etc/default/kubelet`

if [ $test_kubelet != $KUBELET_VAR ];
then
    echo "ERREUR de configuration du fichier /etc/default/kubelet"
    echo "Corrigez le  fichier puis relancer le script"
    echo "..."
    exit
else
  echo "<=== Configuration du fichier /etc/default/kubelet ===>"
  echo "===>...OK"
  echo ""
  echo "======      ETAPE 8/9   ========="
  echo "Redémarrage des services daemon  et kubelet"
  sleep 2

  echo " 1/2 - Redémarrage daemon"
  sudo systemctl  daemon-reload
fi
  if [ $? -ne 0 ];
  then
    echo "ECHEC daemon-reload"
    exit
  else
    sleep 2
    echo " 2/2 - Redémarrage kubelet"
    sudo systemctl restart kubelet
    sudo systemctl status  kubelet | grep Active
    sleep 1
        if  [[ `sudo systemctl status kubelet | grep loaded` ]];
        then
                sleep 2
                echo ""
                echo "========//\\========="
                echo "installation réussie "
                echo "========\\//=========" 

        else

                echo "========//\\=================="
                echo " echec du démarrage de kubelet"
                echo "========\\//==================" 
        fi
    echo ""
    sleep 2
    echo "============================================"
    echo "===== FIN de l'installation sur le node ===="
    echo "============================================"
    
   fi

