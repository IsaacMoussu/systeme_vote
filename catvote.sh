#!/usr/bin/env bash

echo "------------------------------"

numvote=$1

# numéro de ligne correspondant au vote choisit
ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' listevote)
numero=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $1}' listevote)
question=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $3}' listevote)
reponse=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote)
choix=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $5}' listevote)
libre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $10}' listevote)

num=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $1}' listevote)

if [ "$num" != "$numvote" ]; then
    echo "le vote numéro $numvote n'existe pas "
    echo "------------------------------"
    exit 1
fi

echo "vote numéro "$numero" :"

echo "question : "$question""

i=1
echo "$reponse" | tr + '\n' | while read -r j
do
    if [ -n "$j" ]; then
        echo "réponse "$i" : "$j""
        ((i++))
    fi
done

if [ "$choix" == 0 ]; then
    echo "choix multiple non autorisé"
elif [ "$choix" == 1 ]; then
    echo "choix multiple autorisé"
fi

if [ "$libre" == 0 ]; then
    echo "vote à réponse fixe"
elif [ "$libre" == 1 ]; then
    echo "vote à réponse libre"
fi

echo "------------------------------"