#!/usr/bin/env bash

echo "------------------------------"

numvote=$1

numero=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $1}' liste)
echo "vote numéro "$numero" :"

question=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $3}' liste)
echo "question : "$question""

reponse=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $4}' liste)
i=1
echo "$reponse" | tr + '\n' | while read -r j
do
    if [ -n "$j" ]; then
        echo "réponse "$i" : "$j""
        i=$(("$i"+1))
    fi
done

choix=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $5}' liste)
if [ "$choix" == 0 ]; then
    echo "choix multiple non autorisé"
elif [ "$choix" == 1 ]; then
    echo "choix multiple autorisé"
else 
    echo "erreur"
fi

echo "------------------------------"