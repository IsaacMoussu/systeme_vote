#!/usr/bin/env bash

echo "------------------------------"

if [ ! -s "listevote" ]; then 
    echo "aucun vote n'a encore été fait"
    echo "------------------------------"
    exit 1
fi

if [ -z "$1" ]; then 
    echo "vous devez donner un nom d'auteur ou un mot qsue vous recherchez"
    exit 1
fi 

rep=$(awk -F/ -v mot="$1" '$2 == mot || $3 ~ mot {print " id = "$1" | auteur = "$2" | question = "$3"  " }' listevote)

if [ -z "$rep" ]; then 
    echo "le mot ou l'auteur que vous chercher n'apparait pas dans la liste de vote"
else 
    echo "$rep"
    echo "------------------------------"
fi