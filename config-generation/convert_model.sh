#!/bin/bash

# Convertir la sortie de ono symbolic en grille de jeu de la vie.
# Usage: dune exec -- ono symbolic <file.wat> | ./convert_model.sh [WIDTH]

WIDTH=${1:-4}

# On lit l'entrée standard
input=$(cat)

# Extraction des index et des valeurs des symboles, triés par index
# Format attendu : "symbol symbol_<index> i32 <valeur>"
values=$(echo "$input" | sed -n 's/.*symbol symbol_\([0-9]\+\) i32 \([0-9]\+\).*/\1 \2/p' | sort -n -k1,1 | awk '{print $2}')

if [ -z "$values" ]; then
    echo "Erreur : Aucun symbole trouvé dans l'entrée."
    exit 1
fi

count=0
for v in $values; do
    if [ "$v" -eq 1 ]; then
        printf "@"
    else
        printf "."
    fi
    count=$((count + 1))
    if [ $((count % WIDTH)) -eq 0 ]; then
        printf "\n"
    fi
done
