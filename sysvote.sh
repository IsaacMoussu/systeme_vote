#!/usr/bin/env bash

read -ep "donné le nom du document : " nom_fichier
read -ep "auteur du document : " auteur_fichier

# INFO A METTRE POTENTIELLEMENT
# nbr de votes
# nbr de votants
# nbr de votes a choix multiples ou non
# nbr de votes créés par personnes (en moyenne)
# nbr de réponses par personnes (en moyenne)

nbr_votes=$(awk 'END {print NR}' listevote)
nbr_votants=$(awk -F/ 'BEGIN {i=0} !seen[$2]++{i++} END {print i}' listereponse)

noms_auteurs=$(awk -F/ '!seen[$2]++ {printf "%s, ", $2}' listevote)
noms_votants=$(awk -F/ '!seen[$2]++ {printf "%s, ", $2}' listereponse)

coords_auteurs=$(awk -F/ '{seen[$2]++} END {for (val in seen) printf "(%s,%s) ", val, seen[val]}' listevote)
coords_votants=$(awk -F/ '{seen[$2]++} END {for (val in seen) printf "(%s,%s) ", val, seen[val]}' listereponse)

# création du fichier .tex
cat << EOF > ${nom_fichier}.tex
\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage[french]{babel}
\usepackage{pgfplots}

\title{Statistique du Système de Vote}
\author{$auteur_fichier}
\date{\today}

\begin{document}

\maketitle

\section{Introduction}

Depuis le lancement de ce système de vote, $nbr_votes votes ont déjà été créés.
Aussi, le nombre de votants aujourd'hui est de $nbr_votants personnes.

\section{Statistiques}

Voici un graphe qui représente le nombre de votes créés par personne :

% GRAPHE EN COLONNE POUR NBR DE VOTE CREE PAR PERSONNE
\begin{tikzpicture}
\begin{axis}[
    ybar,
    symbolic x coords={$noms_auteurs},
    xtick=data,
    x tick label style={rotate=45, anchor=east},
    ymin=0,
    ylabel={Nombre de votes}
]
\addplot coordinates {$coords_auteurs};
\end{axis}
\end{tikzpicture}

Voici un graphe qui représente le nombre de votes auxquels chaque personne à répondu :

% GRAPHE EN COLONNE POUR NBR DE VOTE CREE PAR PERSONNE
\begin{tikzpicture}
\begin{axis}[
    ybar,
    symbolic x coords={$noms_votants},
    xtick=data,
    x tick label style={rotate=45, anchor=east},
    ymin=0,
    ylabel={Nombre de réponses}
]
\addplot coordinates {$coords_votants};
\end{axis}
\end{tikzpicture}

\end{document}
EOF

# compilation en PDF
pdflatex -interaction=nonstopmode ${nom_fichier}.tex

# nettoyage des fichiers temporaires
rm ${nom_fichier}.aux ${nom_fichier}.log ${nom_fichier}.out ${nom_fichier}.tex

echo "------------------------------"
echo "Le PDF a été généré : ${nom_fichier}.pdf"
echo "------------------------------"