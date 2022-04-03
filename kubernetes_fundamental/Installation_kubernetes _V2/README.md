## Concernant le  "chapter1:Installation_kubernetes _V2" procéder de la manière suivante: 

-1- Lancer le script master_file1.sh en tant que ROOT

    ````
    $ sudo -i 
    
    # cat > master_file1.sh
     " copier-coller le fichier master_file1.sh"
    # bash master_file1.sh
    
    ````

-2- Lancer le script master_file2.sh en tant que USER STANDARD
    
    ````
        # exit
        $ cat > master_file2.sh 
        "  copier-coller le fichier master_file2.sh"
        $ bash master_file2.sh 
        $ ls
        
    ````

-3- Récupérer le fichier secret.sh généré par le script (master_file2.sh) et placer le dans le même répertoire que worker_file.sh                         (le script worker_file.sh devra être exécuter sur le worker)

-4- Lancer le script secret.sh en tant que ROOT
    
    ````
    
        $ sudo -i  
        # cat > secret.sh 
        "  copier-coller le fichier secret.sh" 
        # bash secret.sh
        
    ````

-5- Lancer le script worker_file.sh en tant que ROOT
    Vous devrez entrer l' adresse IP de votre master une fois demandé au niveau du termainal
    
    ````
        $ sudo -i  
        # cat > worker_file.sh 
        "  copier-coller le fichier worker_file.sh" 
        # bash worker_file.sh  
    
    ````

-6- Vérifier la jointure du node au master

      ````
        $ kubectl get nodes -w
    ````
  ==============================  ***ENJOY IT !***  ===============================
