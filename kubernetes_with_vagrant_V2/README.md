-1- Lancer les VMs 
```
  vagrant up k8s-master
```
```
  vagrant up node-1
```
```
  vagrant up node-2
```

-2- Connectez-vous sur le machines et lancer le scripts kubectl-install_V2.sh sur toutes les machines (entrer votre adresse IP)  
   
-3- Lancer le script kubectl-install_V2_config_kube.sh sur le master  

-4- Joignez le nodes au cluster  
NB: si nécessaire générer un token pour joindre vos nodes :

```
  sudo kubeadm token create --print-join-command

```


=========== ***ENJOY IT*** ===============
