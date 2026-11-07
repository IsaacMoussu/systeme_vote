#!/usr/bin/env bash

ligne=5
ligne_total=$(awk 'END {print NR}' liste)
ligne_avant=$(($ligne-1))
ligne_apres=$(($ligne_total-$ligne))
echo -e "$(head -n "$ligne_avant" liste)\n$(tail -n "$ligne_apres" liste)" > liste
echo "le vote a bien été supprimé"