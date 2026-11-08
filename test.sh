#!/usr/bin/env bash

date_debut=$(awk -F/ 'NR == 10 {print $6 }' liste)
newdate=$(date -d "$date_debut + 2 minutes")
echo "$newdate"