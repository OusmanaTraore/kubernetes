#!/bin/bash



# echo "===================================================================================>"
# echo "Vérifier l'adresse IP ... "
# #sleep 2
# echo " Adresses IP disponibles"
# for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
# do
#     echo "===> $i"
# done

# echo "===================================================================================>"
# read -p "Entrez l'adresse IP de la machine: " IP_ETH1 
# echo "===================================================================================>"
sudo su -
# echo " Tapez C pour confirmer , M pour modifier "
# read $choix
# if [ $choix = "C" ] || [ $choix = "c" ]; then
#     $IP_ETH1
# elif [ $choix = "N" ] || [ $choix = "n" ]; then
#     read -p "Entrez l'adresse IP de la machine: " IP_ETH1
#     sleep 2
#     echo "Adresse machine : $IP_ETH1 "
#     echo "==> ok"
# else
# fi