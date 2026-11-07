#!/usr/bin/env bash

numvote=$1

num=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $1}' liste)

echo "---------------"
echo $num

if [ "$num" != "$numvote" ]; then
    echo "le vote numéro $numvote n'existe pas "
    echo "---------------"
    exit 1
fi

read -ep "saisir le nom de l'auteur du vote :" auteur
auteurvote=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $2}' liste)

if [ "$auteur" != "$auteurvote" ]; then
    echo "le nom de l'auteur ne correspond pas"
    echo "---------------"
    exit 1
elif [ "$auteur" == "$auteurvote" ]; then #supprime la ligne
    ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' liste)
    ligne_total=$(awk 'END {print NR}' liste)
    ligne_avant=$(($ligne-1))
    ligne_apres=$(($ligne_total-$ligne))
    echo -e "$(head -n "$ligne_avant" liste)\n$(tail -n "$ligne_apres" liste)" > liste
    echo "le vote a bien été supprimé"
fi

echo "---------------"
