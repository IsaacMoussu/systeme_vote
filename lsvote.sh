#!/usr/bin/env bash

cat listevote | grep $args | awk '{print "auteur : " $1}'
cat listevote | grep $args | awk '{print "question : " $2}'
awk '{print "reponse : " $3}'
awk '{print "date denvoi : " $4}'
