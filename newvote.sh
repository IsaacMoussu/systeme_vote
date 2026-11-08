#!/usr/bin/env bash

echo "------------------------------"

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
read -ep "réponse "$i" :" reponse
while [[ -n "$rep" || "$i" -eq 1 ]]
do
    while [[ -z "$reponse" && "$i" -eq 1 ]]
    do
        echo "veuillez saisir une réponse :"
        read -ep "réponse "$i" :" reponse
    done
    ((i++))
    read -ep "réponse "$i" :" rep
    reponse="$reponse"+"$rep"
done

read -ep "durée du vote(days hours min):" duree
while [[ -z "$duree" || ! ("$duree" =~ ^[0-9[:space:]]+$) ]]
do
    if [ -z "$duree" ]; then
        echo "veuillez saisir une durée :"
        read -ep "durée du vote en heure :" duree
    fi
    if [[ ! ("$duree" =~ ^[0-9[:space:]]+$) ]]; then
        echo "veuillez saisir un nombre :"
        read -ep "durée du vote en heure :" duree
    fi
done

echo "------------------------------"

numvote=$(($(awk -F/ 'END {print $1}' liste)+1))

read days hours min <<< "$duree"
date_debut=$(date +"%Y-%m-%d %H:%M")
date_fin=$(date -d "$date_debut + $days days + $hours hours + $min minutes" +"%Y-%m-%d %H:%M")


echo "$numvote"/"$auteur"/"$question"/"$reponse"/"$choix"/"$date_debut"/"$date_fin"/"ouvert" >> liste
