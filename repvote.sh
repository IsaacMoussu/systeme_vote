#!/usr/bin/env bash

# récup les deux valeurs dans $args
read drapeau chiffre <<< "$1"
if [ -z "$chiffre" ]; then
    numvote="$drapeau"
    
elif [ "$drapeau" != "-m" ]; then
    echo "Commande inconnue : $drapeau"
    exit 1

else
    numvote="$chiffre"

fi

# récup le numéro de vote (dans le fichier et pas en argument)
num=$(awk -F/ -v nv="$numvote" 'nv == $1 {print $1}' listevote)
# récup la ligne du vote donné en argument
ligne=$(awk -F/ -v nv="$numvote" 'nv == $1 {print NR}' listevote)
# récup la valeur qui détermine le choix multiple du vote
choix=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $5}' listevote)
# récup la valeur qui détermine si le vote est à réponse libre
libre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $10}' listevote)
# récup la question du vote
question=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $3}' listevote)
# récup les réponses du vote
reponse=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote)
# récup le nbr de réponse du vote
nbr_reponse=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | tr + ' ' | wc -w)
# récup la valeur qui détermine si le vote est ouvert ou non
ouvert=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $8}' listevote)
# récup la date actuelle converti en seconde
today=$(date +%s)
# récup la date de fin du vote
date_fin=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $7}' listevote)
# converti la date de fin en seconde
timestamp=$(date -d "$date_fin" +%s)

echo "------------------------------"

# verifie que le vote existe
if [ "$num" != "$numvote" ]; then
    echo "le vote numéro $numvote n'existe pas"
    echo "------------------------------"
    exit 1
fi


# verifie que le vote est encore ouvert et ferme le vote si la date de fin est dépassée
if [ "$ouvert" != "ouvert" ]; then
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


# demande le nom/pseudo de l'utilisateur qui va répondre au vote
read -ep "saisir votre nom/pseudo :" pseudo
while [ -z "$pseudo" ]; do
    read -ep "vous devez saisir un nom/pseudo :" pseudo
done


if [[ -n "$chiffre" && "$drapeau" == "-m" ]]; then
    # PARTIE MODIFICATION DE REPONSE

    # vérifie si ce pseudo a déjà répondu a la question 
    ancienne_reponse=$(awk -F/ -v nv="$numvote" -v pseudo="$pseudo" 'nv == $1 && pseudo == $2 {print NR}' listereponse)
    if [ -z "$ancienne_reponse" ]; then
        echo "vous n'avez pas encore répondu à ce vote"
        exit 1
    fi

    echo "la question est : $question"

    case "$libre,$choix" in
        0,0)
            echo "choisissez un numéro de réponse parmi les suivantes :"
            i=1
            echo "$reponse" | tr + '\n' | while read -r j; do

                if [ -n "$j" ]; then
                    echo "réponse "$i" : "$j""
                    ((i++))
                fi

            done

            read -ep "votre nouvelle réponse : " rep
            while [[ -z "$rep" || ! ("$rep" =~ ^[1-"$nbr_reponse"]+$) ]]; do
                echo "aucune réponse ne correspond"
                read -ep "votre nouvelle réponse : " rep
            done

            reponse_enregistre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ -v rep="$rep" '{print $rep}')
            ;;
        0,1)
            echo "choisissez un ou plusieurs numéros de réponse parmi les suivantes :"

            i=1
            echo "$reponse" | tr + '\n' | while read -r j; do

                if [ -n "$j" ]; then
                    echo "réponse "$i" : "$j""
                    ((i++))
                fi

            done

            i=1
            read -ep "votre réponse $i : " rep
            while [[ -z "$rep" || ! ("$rep" =~ ^[1-"$nbr_reponse"]+$) ]]; do
                echo "aucune réponse ne correspond"
                read -ep "votre réponse $i : " rep
                
            done

            reponse_enregistre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ -v rep="$rep" '{print $rep}')
            ((i++))

            while [[ -n "$rep" && "$i" -le "$nbr_reponse" ]]; do

                read -ep "votre réponse $i : " rep
                while [[ -n "$rep" && ! ("$rep" =~ ^[1-"$nbr_reponse"]+$) ]]; do
                    echo "aucune réponse ne correspond"
                    read -ep "votre réponse $i : " rep

                done

                if [ -n "$rep" ]; then
                    autre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ -v rep="$rep" '{print $rep}')
                    reponse_enregistre="$reponse_enregistre+$autre"
                    ((i++))
                fi

            done
            ;;
        1,0)
            read -ep "votre nouvelle réponse : " reponse_enregistre
            while [ -z "$reponse_enregistre" ]; do
                echo "saisissez au moins une nouvelle réponse"
                read -ep "votre nouvelle réponse : " reponse_enregistre

            done
            ;;
        1,1)
            i=1
            read -ep "votre nouvelle réponse "$i" : " reponse_enregistre
            while [[ (-n "$rep" || "$i" -eq 1) && "$i" -lt 10 ]]; do

                while [[ -z "$reponse_enregistre" && "$i" -eq 1 ]]; do
                    echo "saisissez au moins une nouvelle réponse"
                    read -ep "votre nouvelle réponse "$i" : " reponse_enregistre

                done

                ((i++))
                read -ep "votre nouvelle réponse "$i" : " rep
                reponse_enregistre="$reponse_enregistre"+"$rep"

            done
            ;;
    esac

    newR=$(awk -F/ -v ligne="$ancienne_reponse" -v reponse="$reponse_enregistre" 'BEGIN {OFS="/"} NR == ligne {$3=reponse} {print $0}' listereponse)
    echo "$newR" > listereponse
    echo "votre réponse a bien été modifiée"
    echo "------------------------------"

else
    # PARTIE REPONSE A UNE QUESTION

    echo "la question est : $question"

    case "$libre,$choix" in
        0,0)
            echo "choisissez un numéro de réponse parmi les suivantes :"
            i=1
            echo "$reponse" | tr + '\n' | while read -r j; do

                if [ -n "$j" ]; then
                    echo "réponse "$i" : "$j""
                    ((i++))
                fi

            done

            read -ep "votre réponse : " rep
            while [[ -z "$rep" || ! ("$rep" =~ ^[1-"$nbr_reponse"]+$) ]]; do
                echo "aucune réponse ne correspond"
                read -ep "votre réponse : " rep

            done

            reponse_enregistre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ -v rep="$rep" '{print $rep}')
            ;;
        0,1)
            echo "choisissez un ou plusieurs numéros de réponse parmi les suivantes :"
            
            i=1
            echo "$reponse" | tr + '\n' | while read -r j; do

                if [ -n "$j" ]; then
                    echo "réponse "$i" : "$j""
                    ((i++))
                fi
                
            done

            i=1
            read -ep "votre réponse $i : " rep
            while [[ -z "$rep" || ! ("$rep" =~ ^[1-"$nbr_reponse"]+$) ]]; do
                echo "aucune réponse ne correspond"
                read -ep "votre réponse $i : " rep
                
            done

            reponse_enregistre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ -v rep="$rep" '{print $rep}')
            ((i++))
            while [[ -n "$rep" && "$i" -le "$nbr_reponse" ]]; do

                read -ep "votre réponse $i : " rep
                while [[ -n "$rep" && ! ("$rep" =~ ^[1-"$nbr_reponse"]+$) ]]; do
                    echo "aucune réponse ne correspond"
                    read -ep "votre réponse $i : " rep
                done

                if [ -n "$rep" ]; then
                    autre=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ -v rep="$rep" '{print $rep}')
                    reponse_enregistre="$reponse_enregistre+$autre"
                    ((i++))
                fi
                
            done
            ;;
        1,0)
            read -ep "votre réponse : " reponse_enregistre
            while [ -z "$reponse_enregistre" ]; do
                echo "saisissez au moins une réponse"
                read -ep "votre réponse : " reponse_enregistre

            done
            ;;
        1,1)
            i=1
            read -ep "votre réponse "$i" : " reponse_enregistre
            while [[ (-n "$rep" || "$i" -eq 1) && "$i" -lt 10 ]]; do

                while [[ -z "$reponse_enregistre" && "$i" -eq 1 ]]; do
                    echo "saisissez au moins une réponse"
                    read -ep "votre réponse "$i" : " reponse_enregistre

                done

                ((i++))
                read -ep "votre réponse "$i" : " rep
                reponse_enregistre="$reponse_enregistre"+"$rep"

            done
            ;;
    esac

    echo "$numvote/$pseudo/$reponse_enregistre" >> listereponse
    echo "votre réponse a bien été enregistrée"
    echo "------------------------------"

fi

verif=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $9}' listevote)
if [ "$verif" != "non modifiable" ]; then
    swap=$(awk -F/ -v ligne="$ligne" 'BEGIN {OFS="/"} NR == ligne {$9="non modifiable"} {print $0 }' listevote)
    echo "$swap" > listevote
fi