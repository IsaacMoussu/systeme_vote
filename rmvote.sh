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
elif [ "$auteur" == "$auteurvote" ]; then #supprime la ligne
    ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' liste)
    modif=$(awk -F/ -v ligne="$ligne" 'NR != ligne {OFS="/"; print $0 }' liste)
    echo "$modif" > liste
    echo "le vote a bien été supprimé"
fi

echo "------------------------------"
