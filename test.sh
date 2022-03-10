#!/bin/bash

echo test2  >>  fichier  
cat fichier

mot=find test2 . | wc 

if [ $mot = 2 ]
then echo " good";
elif echo "too much"
else echo " erreur"
fi