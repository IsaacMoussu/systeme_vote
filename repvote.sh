#!/usr/bin/env bash

read drapeau chiffre <<< "$1"
if [ -z "$chiffre" ]; then
    numvote="$drapeau"
elif [ "$drapeau" != "-m" ]; then
    echo "Commande inconnue : $drapeau"
    exit 1
else
    # mode modifier reponse
    numvote="$chiffre"
fi

num=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $1}' listevote)
ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' listevote) # numéro de ligne correspondant au vote choisit

echo "------------------------------"

if [ "$num" != "$numvote" ]; then
    echo "le vote numéro $numvote n'existe pas"
    echo "------------------------------"
    exit 1
fi

autorise=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $8}' listevote)
today=$(date +%s) # converti en seconde
date_fin=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $7}' listevote)
timestamp=$(date -d "$date_fin" +%s) # converti en seconde
if [ "$autorise" != "ouvert" ]; then
    echo "le vote numéro $numvote est fermé"
    echo "------------------------------"
    exit 1
elif [ "$today" -ge "$timestamp"  ]; then
    ferme=$(awk -F/ -v ligne="$ligne" 'BEGIN {OFS="/"} NR == ligne {$8="fermé"} {print $0}' listevote)
    echo "$ferme" > listevote
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
    echo "choisissez un numéro de réponse parmi les suivantes :"
else
    echo "choisissez un ou plusieurs numéros de réponse parmi les suivantes :"
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

nbr_reponse=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | tr + ' ' | wc -w)
if [ "$choix" == 0 ]; then
    read -ep "votre réponse : " rep
    while [[ -z "$rep" || ! ("$rep" =~ ^[1-"$nbr_reponse"]+$) ]]; do
        echo "aucune réponse ne correspond"
        read -ep "votre réponse : " rep
    done
    # enregistre la reponse dans listereponse
    enregistre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ -v rep="$rep" '{print $rep}')
    echo "$numvote/$pseudo/$enregistre" >> listereponse
    echo "votre réponse a bien été enregistrée"
else
    i=1
    read -ep "votre réponse $i : " rep
    while [[ -z "$rep" || ! ("$rep" =~ ^[1-"$nbr_reponse"]+$) ]]; do
        echo "aucune réponse ne correspond"
        read -ep "votre réponse $i : " rep
        
    done
    enregistre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ -v rep="$rep" '{print $rep}')
    ((i++))
    while [[ -n "$rep" && "$i" -le "$nbr_reponse" ]]; do
        read -ep "votre réponse $i : " rep
        while [[ -n "$rep" && ! ("$rep" =~ ^[1-"$nbr_reponse"]+$) ]]; do
            echo "aucune réponse ne correspond"
            read -ep "votre réponse $i : " rep
        done
        if [ -n "$rep" ]; then
            autre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ -v rep="$rep" '{print $rep}')
            enregistre="$enregistre+$autre"
            ((i++))
        fi
    done
    echo "$numvote/$pseudo/$enregistre" >> listereponse
    echo "votre réponse a bien été enregistrée"
fi

verif=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $9}' listevote)
if [ "$verif" != "non modifiable" ]; then
    swap=$(awk -F/ -v ligne="$ligne" 'BEGIN {OFS="/"} NR == ligne {$9="non modifiable"} {print $0 }' listevote)
    echo "$swap" > listevote
fi

echo "------------------------------"
