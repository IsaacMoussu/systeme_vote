#!/usr/bin/env bash

read -ep "durée du vote en jours :" duree
while [[ -z "$duree" || ! ("$duree" =~ ^[0-9[:space:]]$) ]]
do
    if [ -z "$duree" ]; then
        echo "veuillez saisir une durée :"
        read -ep "durée du vote en heure :" duree
    fi
    if [[ ! ("$duree" =~ ^[0-9[:space:]]$) ]]; then
        echo "veuillez saisir un nombre :"
        read -ep "durée du vote en heure :" duree
    fi
done

read days hours min <<< "$duree"

date_debut=$(date +"%Y-%m-%d %H:%M")
date_fin=$(date -d "$date_debut + $days days + $hours hours + $min minutes" +"%Y-%m-%d %H:%M")

echo "$date_fin"
