##   Dossier kubernetes_with_vagrant V3 : 
#### Lien vers la video ==> (https://www.youtube.com/watch?v=eVbTUfZcGbI)

Les fichiers d'installation se trouvent dans le répertoire "cluster" 

-1- Ouvrir trois terminaux pour lancer les machines virtuelles

terminal-1 :
    ```
     vagrant up control-plane
    ```

terminal-2 :
    ```
     vagrant up node01
    ```

terminal-3 :
    ```
     vagrant up node02
    ```

-2- Se connecter en ssh sur les  trois terminaux puis copier-coller le fichier install.sh , puis executer-le 

terminal-1 :
    ```
     $ vagrant ssh control-plane
     $ sudo cat > install.sh
      #copier-coller le contenu de install.sh
     $ bash install.sh
    ```

terminal-2 :
    ```
     $ vagrant ssh node01
     $ sudo cat > install.sh
      #copier-coller le contenu de install.sh
     $ bash install.sh
    ```

terminal-3 :
    ```
     $ vagrant ssh node02
     $ sudo cat > install.sh
      #copier-coller le contenu de install.sh
     $ bash install.sh
    ```

Suivre ensuite les instructions  et attendez-vous à avoir le message suivant:

 ```master:  1/2 - Redémarrage daemon
    master:  2/2 - Redémarrage kubelet
    master:      Active: active (running) since Sun 2022-03-13 23:32:31 UTC; 53ms ago
    master: 
    master: |||======================================|||
    master: |||=======                       ========|||
    master: |||                                      |||
    master: |||======= installation réussie  ========|||
    master: |||                                      |||
    master: |||=======                       ========|||
    master: |||================|======|==============|||
    master:   


 ```
  ```
    worker1: |||======================================|||
    worker1: |||=======                       ========|||
    worker1: |||                                      |||
    worker1: |||======= installation réussie  ========|||
    worker1: |||                                      |||
    worker1: |||=======                       ========|||
    worker1: |||================|======|==============|||
    worker1:   

 ```
 ```
    worker2: |||======================================|||
    worker2: |||=======                       ========|||
    worker2: |||                                      |||
    worker2: |||======= installation réussie  ========|||
    worker2: |||                                      |||
    worker2: |||=======                       ========|||
    worker2: |||================|======|==============|||
    worker2:   

 ```
 -4- Se connecter au master puis  faire un "copier-coller" du contenu de config_kube.sh dans un fichier bash puis exécuter-le.
 terminal-1 :
    ```
     $ sudo cat > config_kube.sh
      #copier-coller le contenu de config_kube.sh
     $ bash config_kube.sh
    ```

 - [X] Entrez l'adresse ip du master 

 - [X] Attendez-vous à avoir à la fin du script le message suivant:

```
            echo "|||================================================|||"
            echo "|||=======                       ==================|||"
            echo "|||                                                |||"
            echo "|||======= Joignez vos nodes au cluster ===========|||"
            echo "||| via la commande kubeadm  fournie plus haut...  |||"
            echo "|||=======                       ==================|||"
            echo "|||================|======|========================|||"

```
-5- Remonter plus haut dans le terminal et trouver la commande qui vous permettra de joindre vos
workers au master en ajoutant sudo.

```
sudo kubeadm join adresse_IP:6443 --token fhdnzi.xxxxxxxxx--discovery-token-ca-cert-hash sha256:d41f1xxxxxxxx56b5cd09fb277fa1d54a47584352xxxxxx
```

-6- Une fois vos workers ajoutés au cluster, vérifier cela au niveau du master 

```
vagrant@master:~$ kubectl get nodes
NAME      STATUS   ROLES                  AGE     VERSION
master    Ready    control-plane,master   61m     v1.23.4
worker1   Ready    <none>                 8m47s   v1.23.4
worker2   Ready    <none>                 2m3s    v1.23.4

```


==========  ***ENJOY IT !***  ===========
