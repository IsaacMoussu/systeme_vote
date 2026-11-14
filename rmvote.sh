#!/usr/bin/env bash

numvote=$1

num=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $1}' listevote)

echo "------------------------------"

if [ "$num" != "$numvote" ]; then
    echo "le vote numéro $numvote n'existe pas "
    echo "------------------------------"
    exit 1
fi

read -ep "saisir le nom de l'auteur du vote :" auteur
auteurvote=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $2}' listevote)

if [ "$auteur" != "$auteurvote" ]; then
    echo "le nom de l'auteur ne correspond pas"
    echo "------------------------------"
    exit 1

else #supprime la ligne

    ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' listevote)
    modif=$(awk -F/ -v ligne="$ligne" 'NR != ligne {OFS="/"; print $0 }' listevote)
    echo "$modif" > listevote
    echo "le vote a bien été supprimé"
fi

echo "------------------------------"
