#!/usr/bin/env bash

nbr_votants=$(awk -F/ 'BEGIN {i=0} !seen[$2]++{i++} END {print i}' listereponse)

echo "$nbr_votants"