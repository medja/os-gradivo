#!/bin/bash

WORD="[[:alpha:]]*"

min_count=1
word_length=0

while [ $# -gt 0 ]; do
    if [ "${1:0:1}" = "-" ]; then
        case "$1" in
            -n)
                min_count=$2
                ;;
            -l)
                word_length=$2
                ;;
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

# Parse metoda bo sedaj namesto besed izpisala za vsako besedo velikost zacetnice.
parse() {
    for word in $(grep -o "$WORD" "$1"); do
        # Shrani se zacetnica besede, ce bo ta po povecanju se vedno enaka,
        # to pomeni, da gre za veliko zacetnico.
        zacetnica=${word:0:1}
    
        if [ $zacetnica = ${zacetnica^^} ]; then
            echo "velika"
        else
            echo "mala"
        fi
    done
}

# Metoda prepare je odstranjena, saj za to nadgradnjo ni potrebna.

# Metoda format sedaj prejme dve vrstici, najprej vrstico za majhne začetnice
# in nato vrstico za velike začetnice.
format() {
    # S tem, ko se prebereta oba podatka, bo read sam ločil oba dela vrstice.
    read malih mala_zacetnica
    read velikih velika_zacetnica
    
    # Robni primer: če ni malih začetnic tudi njena vrstica ne obstaja.
    if [ "$mala_zacetnica" != "mala" ]; then
        # V tem primeru je število velikih začetnic enako številu malih,
        # malih pa je v tem primeru ni.
        velikih=$malih
        malih=0
    fi
    
    echo "Velika začetnica: ${velikih:-0}, mala začetnica: ${malih:-0}"
}


# Najprej prebere vse velik in majhne začetnice, preštejo koliko je katerih
# in naredi izpis obeh vrstic.
parse $file | sort | uniq -c | format