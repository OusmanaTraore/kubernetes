#!/bin/bash
kubeadm join 192.168.205.10:6443 --token fhdnzi.0xxcei4evfsdkxq5 --discovery-token-ca-cert-hash sha256:d41f1190f6356b5cd09fb277fa1d54e1f72656da4a6a780ff69de37a47584352 
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz) tar xzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar e $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xf $1 ;;
      *.tbz2) tar xjf $1 ;;
      *.tgz) tar xzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *)
        echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}



# echo "===================================================================================>"
# echo "Vérifier l'adresse IP ... "
# #sleep 2
# echo " Adresses IP disponibles"
# for i in $(ip a | cut -d " " -f 6 | grep ^1 | cut -d "/" -f 1)
# do
#     echo "===> $i"
# done
# sudo usermod -aG docker $USER

# echo "===================================================================================>"
# read -p "Entrez l'adresse IP de la machine: " IP_ETH1 
# echo "===================================================================================>"
sudo su  cat  KUBELET_EXTRA_ARGS=\"--node-ip=$IP_ETH1\" >  /etc/docker/daemon.json  
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
