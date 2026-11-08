#!/usr/bin/env bash


ligne=12
nbr_reponse=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | tr + ' ' | wc -w)
rep=$(awk -F/ -v ligne="$ligne" 'NR == ligne {print $4}' listevote | awk -F+ '{print $1}')
echo "$nbr_reponse"
echo "$rep"
read -ep "votre réponse : " rep
if [[ -z "$rep" || ! ("$rep" =~ ^[1-"$nbr_reponse"[:space:]]+$) ]]; then
    echo "aucune réponse ne correspond"
else
    echo "rien"
fi