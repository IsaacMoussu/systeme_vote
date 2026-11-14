#!/usr/bin/env bash

numvote=$1

num=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $1}' listevote)
# numéro de ligne correspondant au vote choisit
ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' listevote)
auteurvote=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $2}' listevote)

echo "------------------------------"

if [ "$num" != "$numvote" ]; then
    echo "le vote numéro $numvote n'existe pas "
    echo "------------------------------"
    exit 1
fi

read -ep "saisir le nom de l'auteur du vote :" auteur

if [ "$auteur" != "$auteurvote" ]; then
    echo "le nom de l'auteur ne correspond pas"
    echo "------------------------------"
    exit 1

else # ferme le vote avant la date de fin

    ferme=$(awk -F/ -v ligne="$ligne" 'BEGIN {OFS="/"} NR == ligne {$8="fermé"} {print $0}' listevote)
    echo "$ferme" > listevote
    echo "le vote est maintenant fermé"
    echo "------------------------------"
fi
