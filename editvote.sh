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

autorise=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $9}' listevote)
if [ "$autorise" != "modifiable" ]; then
    echo "le vote numéro $numvote n'est pas modifiable"
    echo "------------------------------"
    exit 1
fi

read -ep "saisir le nom de l'auteur du vote :" auteur
auteurvote=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $2}' listevote)

if [ "$auteur" != "$auteurvote" ]; then
    echo "le nom de l'auteur ne correspond pas"
    echo "------------------------------"
    exit 1
fi

# modifie le vote
while true; do
    echo "donner le numéro de ce que vous voulez vous modifier ?"
    echo -e "1 : question\n2 : réponses\n3 : choix multiple\n4 : durée du vote\n5 : sortir des modifications"
    read -e modif
    case "$modif" in
        1)
            read -ep "donner votre nouvelle question : " question
            if [ -z "$question" ]; then
                echo "modification impossible"
                echo "------------------------------"
            else # remplacer la question
                newQ=$(awk -F/ -v ligne="$ligne" -v question="$question" 'BEGIN {OFS="/"} NR == ligne {$3=question} {print $0}' listevote)
                echo "$newQ" > listevote
                echo "modification effectuée"
                echo "------------------------------"
            fi
            ;;
        2) 
            libre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $10}' listevote)
            if [ "$libre" == 0 ]; then
                i=1
                read -ep "nouvelle réponse "$i" :" reponse
                if [ -z "$reponse" ]; then
                    echo "modification impossible"
                    echo "------------------------------"
                else # remplacer réponses
                    ((i++))
                    read -ep "nouvelle réponse "$i" :" rep
                    while [ -z "$rep" ]
                    do
                        read -ep "nouvelle réponse "$i" :" rep
                    done
                    reponse="$reponse"+"$rep"
                    while [[ -n "$rep" ]]
                    do
                        ((i++))
                        read -ep "nouvelle réponse "$i" :" rep
                        reponse="$reponse"+"$rep"
                    done
                    newR=$(awk -F/ -v ligne="$ligne" -v reponse="$reponse" 'BEGIN {OFS="/"} NR == ligne {$4=reponse} {print $0}' listevote)
                    echo "$newR" > listevote
                    echo "modification effectuée"
                    echo "------------------------------"
                fi
            else
                echo "ce vote est à réponse libre"
                echo "------------------------------"
            fi
            ;;
        3) 
            read -ep "choix multiple (0 pour non, 1 pour oui) : " choix
            if [[ "$choix" != "0" && "$choix" != "1" ]]; then
                echo "modification impossible"
                echo "------------------------------"
            else # remplacer le choix
                newC=$(awk -F/ -v ligne="$ligne" -v choix="$choix" 'BEGIN {OFS="/"} NR == ligne {$5=choix} {print $0}' listevote)
                echo "$newC" > listevote
                echo "modification effectuée"
                echo "------------------------------"
            fi
            ;;
        4)
            read -ep "nouvelle durée du vote(days hours min) : " duree
            if [[ -z "$duree" || ! ("$duree" =~ ^[0-9[:space:]]+$) ]]; then
                echo "modification impossible"
                echo "------------------------------"
            else # remplacer la question
                read days hours min <<< "$duree"
                date_debut=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $6 }' listevote)

                if [[ "$OSTYPE" == "darwin"* ]]; then
                    date_fin=$(date -j -f "%Y-%m-%d %H:%M" "$date_debut" -v+${days}d -v+${hours}H -v+${min}M +"%Y-%m-%d %H:%M")
                else
                    date_fin=$(date -d "$date_debut + $days days + $hours hours + $min minutes" +"%Y-%m-%d %H:%M")
                fi

                newD=$(awk -F/ -v ligne="$ligne" -v date_fin="$date_fin" 'BEGIN {OFS="/"} NR == ligne {$7=date_fin} {print $0}' listevote)
                echo "$newD" > listevote
                echo "modification effectuée"
                echo "------------------------------"
            fi
            ;;
        5)
            echo "------------------------------"
            exit 1
            ;;
        *)
            echo "aucune modification choisit"
            echo "------------------------------"
            ;;
    esac
done

