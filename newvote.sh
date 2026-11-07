#!/usr/bin/env bash

echo "---------------"

read -ep "auteur :" auteur 
while [ -z "$auteur" ]
do
    echo "veuillez saisir un auteur :"
    read -ep "auteur :" auteur
done

read -ep "question :" question 
while [ -z "$question" ]
do
    echo "veuillez saisir une question :"
    read -ep "question :" question 
done

read -ep "choix multiple (0 pour non, 1 pour oui) :" choix
while [[ "$choix" != "0" && "$choix" != "1" ]]
do
    echo "veuillez saisir un choix :"
    read -ep "choix multiple (0 pour non, 1 pour oui) :" choix 
done

i=1
read -ep "reponse "$i" :" reponse
while [[ -n "$rep" || "$i" -eq 1 ]]
do
    while [[ -z "$reponse" && "$i" -eq 1 ]]
    do
        echo "veuillez saisir une reponse :"
        read -ep "reponse "$i" :" reponse
    done
    i=$(("$i"+1))
    echo $i
    read -ep "reponse "$i" :" rep
    reponse="$reponse"+"$rep"
done

read -ep "durée du vote en heure :" duree
while [ -z "$duree" ]
do
    echo "veuillez saisir une durée :"
    read -ep "durée du vote en heure :" duree 
done

echo "---------------"

numvote=$(($(wc -l < liste)+1))
date=$(date +"%Y %m %d")

echo "$numvote"/"$auteur"/"$question"/"$reponse"/"$choix"/"$date"/"$duree" >> liste
