#!/usr/bin/env bash

numvote=$1

num=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $1}' listevote)
ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' listevote) # numéro de ligne correspondant au vote choisit

echo "------------------------------"

if [ "$num" != "$numvote" ]; then
    echo "le vote numéro $numvote n'existe pas"
    echo "------------------------------"
    exit 1
fi

autorise=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $8}' listevote)
if [ "$autorise" != "ouvert" ]; then
    echo "le vote numéro $numvote est fermé"
    echo "------------------------------"
    exit 1
fi

read -ep "saisir votre nom/pseudo :" pseudo
while [ -z "$pseudo" ]
do
    read -ep "vous devez saisir un nom/pseudo :" pseudo
done

question=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $3}' listevote)
echo "la question est : $question"
choix=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $5}' listevote)
if [ "$choix" == 0 ]; then
    echo "choisissez une réponse parmi les suivantes :"
else
    echo "choisissez une ou plusieurs réponses parmi les suivantes :"
fi

reponse=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote)
i=1
echo "$reponse" | tr + '\n' | while read -r j
do
    if [ -n "$j" ]; then
        echo "réponse "$i" : "$j""
        i=$(("$i"+1))
    fi
done

if [ "$choix" == 0 ]; then
    read -ep "votre réponse : " rep
    if [[ -z "$rep" || ! ("$rep" =~ ^[0-9[:space:]]+$) ]]; then
    
else
fi
else
fi

