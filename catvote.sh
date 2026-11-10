#!/usr/bin/env bash

echo "------------------------------"

numvote=$1
ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' listevote) # numéro de ligne correspondant au vote choisit

numero=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $1}' listevote)
echo "vote numéro "$numero" :"

question=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $3}' listevote)
echo "question : "$question""

reponse=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote)
i=1
echo "$reponse" | tr + '\n' | while read -r j
do
    if [ -n "$j" ]; then
        echo "réponse "$i" : "$j""
        ((i++))
    fi
done

choix=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $5}' listevote)
if [ "$choix" == 0 ]; then
    echo "choix multiple non autorisé"
elif [ "$choix" == 1 ]; then
    echo "choix multiple autorisé"
else 
    echo "erreur"
fi

echo "------------------------------"