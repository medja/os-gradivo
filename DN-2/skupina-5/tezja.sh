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

parse() {
    # Besedilo iz datoteke se shrani v spremenljivko. Če ime datoteke ni
    # podano, se z uporabo ukaza cat to prebere iz standardnega vhoda,
    # drugače pa iz podane datoteke.
    if [ -z "$1" ]; then
        besedilo=$(cat)
    else
        besedilo=$(cat "$1")
    fi
    
    # Grep sedaj ne bere več direktno iz datoteke, temveč dobi vsebino že podano.
    for word in $(grep -o "$WORD" <<< "$besedilo"); do
        echo ${word,,}
    done
}

prepare() {
    while read count word; do
        if [ $count -lt $min_count ]; then
            continue
        fi
        
        length=${#word}
        
        if [ $word_length -eq 0 ] || [ $length -eq $word_length ]; then
            echo "$count $word $length"
        fi
    done
}

format() {
    while read count word length; do
        relative=$(( 10000 * $count / $1 ))
        
        if [ $relative -eq 0 ]; then
            frequency="0"
        elif [ $relative -lt 10 ]; then
            frequency=".0$relative"
        elif [ $relative -lt 100 ]; then
            frequency=".$relative"
        else
            length=${#relative}
            integer=${relative:0:$length - 2}
            decimal=${relative: -2}
            frequency="${integer}.${decimal}"
        fi
        
        echo "${count} ${word} ${frequency}%"
    done
}

words=$(parse $file)

if [ -z "$words" ]; then
    exit 0
fi

total_words=$(wc -l <<< "$words")
sort <<< "$words" | uniq -c | prepare | sort -rn -k1,1 -k3,3 -k2,2b | format $total_words