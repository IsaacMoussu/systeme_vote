#!/usr/bin/env bash

numvote=$1

num=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $1}' liste)

echo "------------------------------"

if [ "$num" != "$numvote" ]; then
    echo "le vote numéro $numvote n'existe pas "
    echo "------------------------------"
    exit 1
fi

read -ep "saisir le nom de l'auteur du vote :" auteur
auteurvote=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $2}' liste)

if [ "$auteur" != "$auteurvote" ]; then
    echo "le nom de l'auteur ne correspond pas"
    echo "------------------------------"
    exit 1
else # ferme le vote avant la date de fin
    ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' liste) # numéro de ligne correspondant au vote choisit
    ferme=$(awk -F/ -v ligne="$ligne" 'NR == ligne {$8="fermé"} {OFS="/"; print $0 }' liste)
    echo "$ferme" > liste
    echo "le vote est maintenant fermé"
    echo "------------------------------"
fi
