#!/usr/bin/env bash

numvote=$1

echo "$numvote"

#awk -F="\t" ' $numvote = $1 {print $3 \n $5} liste'