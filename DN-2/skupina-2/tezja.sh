#!/bin/bash

datoteka="$1"

# Funkcija odstavki prešteje število odstavkov.
odstavki() {
    while read odstavek; do
        # Če gre za prazno vrstico to ni odstavek.
        if [ -n "$odstavek" ]; then
            echo "odstavek"
        fi
    done < "$1" | wc -l
}

# Tu grep -o po vrsticah izpiše vsa ločila in vsa števila.
# wc mora nato samo še prešteti, koliko je vrstic.
locil=$(grep -o "[.,:;!?]" "$datoteka" | wc -l)
stevil=$(grep -o "[[:digit:]]*" "$datoteka" | wc -l)

# Odstavke, namesto z wc -l "$datoteka", šteje posebna funkcija,
# ki zanemari prazne vrstice (robni primer).
odstavkov=$(odstavki "$datoteka")

echo "ločila: $locil, odstavki: $odstavkov, števila: $stevil"