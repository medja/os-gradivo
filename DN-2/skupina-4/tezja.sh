#!/bin/bash

# Spremeni se vzorec za besedo, ta sedaj vzame le po eno črko.
# Torej postane vzorec za črke.
WORD="[[:alpha:]]"

min_count=1

while [ $# -gt 0 ]; do
    if [ "${1:0:1}" = "-" ]; then
        case "$1" in
            -n)
                min_count=$2
                ;;
            # Stikalo za omejitev na dolžini besede tu ni uporabno.
             *)
                echo "Napaka: neznano stikalo $1." >&2
                exit 1
                ;;
        esac
        
        shift 2
    else
        if [ -f "$1" ]; then
            file=$1
        else
            echo "Napaka: datoteka $1 ne obstaja." >&2
            exit 2
        fi
        
        shift
    fi
done

parse() {
    for word in $(grep -o "$WORD" "$1"); do
        echo ${word,,}
    done
}

prepare() {
    while read count word; do
        if [ $count -lt $min_count ]; then
            continue
        fi
        
        # Omejitev na dolžini besede tu ni uporabna.
        
        echo "$count $word"
    done
}

# Funkcija format za to nadgradnjo ni potrebna.

words=$(parse $file)

if [ -z "$words" ]; then
    exit 0
fi

# Pri procesiranju je sedaj dovolj da se prešteje število ponovitev
# črk in nato uredi izpis vrstice ter uredi izpis po številu ponovitev.
sort <<< "$words" | uniq -c | prepare | sort -rn -k1,1