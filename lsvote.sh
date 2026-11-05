#!/usr/bin/env bash

cat liste | grep $args | awk '{print "auteur : " $1}'
cat liste | grep $args | awk '{print "question : " $2}'
awk '{print "reponse : " $3}'
awk '{print "date denvoi : " $4}'
