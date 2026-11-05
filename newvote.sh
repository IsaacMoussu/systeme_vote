#!/usr/bin/env bash

numvote=$(($(wc -l < liste)+1))
date=$(date +"%Y %m %d")

read -ep "auteur>" auteur 
while [ -z "$auteur" ]
do
    echo "veuillez saisir un auteur :"
    read -ep "auteur>" auteur
done

read -ep "question>" question 
while [ -z "$question" ]
do
    echo "veuillez saisir une question :"
    read -ep "question>" question 
done

read -ep "reponse>" reponse
while [ -z "$reponse" ]
do
    echo "veuillez saisir une reponse :"
    read -ep "reponse>" reponse 
done

read -ep "choix multiple (oui ou non)>" choix
while [ -z "$choix" ]
do
    echo "veuillez saisir un choix :"
    read -ep "choix multiple (oui ou non)>" choix 
done

read -ep "durée du vote en heure>" duree
while [ -z "$duree" ]
do
    echo "veuillez saisir une durée :"
    read -ep "durée du vote en heure>" duree 
done

echo "$numvote" \t "$auteur" \t "$question" \t "$choix" \t "$reponse" \t "$date" \t "$duree" >> liste
