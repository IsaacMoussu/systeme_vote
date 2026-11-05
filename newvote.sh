#!/usr/bin/env bash

numvote=$(($(wc -l < liste)+1))
date=$(date +"%Y %m %d")

read -ep "auteur>" auteur 
read -ep "question>" question 
read -ep "reponse>" reponse
read -ep "choix multiple>" choix
read -ep "durée du vote en heure>" date

echo "$numvote" "$auteur" "$question" "$reponse" "$date" >> liste
