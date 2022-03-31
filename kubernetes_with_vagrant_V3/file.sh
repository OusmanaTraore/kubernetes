#!/bin/bash
### Fichier de configuration pour le master
IP_ETH1="192.168.56.35"

if [ $IP_ETH1 = "192.168.56.35" ];
then
    echo "Envoi de fichier de configuration pour le master"
    sleep 2 
    echo "scp ..."
    scp -r -p file.sh vagrant@$IP_ETH1:/home/vagrant | echo -e "vagrant \n"
    #echo < "scp -r -p file.sh vagrant@$IP_ETH1:/home/vagrant"
    #sleep 2
    #echo "sed ..."
    # if [ $? = "0" ];
    # then    
    #     echo "Envoi de fichier de configuration  => SUCCESS !!!"
    #     sleep 2
    #     echo "Connection ssh avec le master ..."
    #     vagrant ssh master
    #     bash config_kube.sh
    # else
    #     echo "Envoi de fichier de configuration => FAILED!!!"
    # fi
else
    echo "FIN DE L'INSTALLATION"
fi