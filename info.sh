## Jointure

### joindre le camps n3 du premier fichier avec le  champ n2 du second fichier 
->
join -1 3 -2 2 fichier1 fichier2
->
### Copier des champs ligne par ligne
->
paste fichier1 fichier2
->

##  Afficher les fichier en mode octal 
->
od fichier
->
## Sort , Uniq
###  Trier la colonne 2 d'un fichier
->
    sort -k 2 fichier
->
###  Supprimer des doublons
->
   sort fichier | uniq
->
## Split
###  Couper en deux parties  par nombre de lignes
-> 
    split -l 2 fichier nombre
->
## Translation
###  Translation de caratère individuel
-> 
    tr [options]  SET1 [SET2]  
->
-> 
    tr BCJ bc < fichier_text.txt
->
-> 
    tr [:upper:] [:lower:] [:digit:] 
->
##    Conversion des espaces en tabulation avec option
###  Expand (agrandir le nombre d'espaces de tabulation)
->
   expand  -t ou  expand --tabs=numero_despace
->
###  Unexpand (diminuer le nombre d'espaces de tabulation)
->
    unexpand -t ou --tabs=numero_despace
->
##    fmt ,nl , pr (print)
->
    fmt --width=longueur (-width ou -w)
->
->
    nl (number line)
    cat -b (--body-numbering=format_code) fichier 
    nl -b a fichier > number_fichier.txt
->
->
    pr fichier --colums=nombre_colonne

    cat -n /etc/profile | pr -d | lpr
    cat -n /etc/profile | pr -dfl 50 | lpr
->
##    head , tail
###  Afficher les n premières lignes , les n derières lignes , ou une portion de lignes
->
    head -n15 fichier_text.txt | tail -n 5
->
##    Sed
###  Modifier le contenu d'un fichier
->
    sed [ options ] -f script-file [ input-file]
->
->
    sed 's/2012/2013' cal-2012.txt > cal-2013.txt
->

##    Combined 
###  pipes
->
    ifconfig eth0 | grep HWaddr | cut -d " " -f 11
->
### grep 
