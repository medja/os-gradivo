#!/bin/bash

WORD="[[:alpha:]]*"

min_count=1
word_length=0

# Primerjalni operator pri preverjanju dolžine besede.
# Privzeto se izpišejo samo besede, ki imajo enako dolžino.
omejitev="-eq"

while [ $# -gt 0 ]; do
    if [ "${1:0:1}" = "-" ]; then
        case "$1" in
            -n)
                min_count=$2
                ;;
            -l)
                if [ ${2: -1} = "-" ]; then
                    # Če ima število na koncu pomišljal,
                    # je potrebno tega odstraniti.
                    word_length=${2:0:-1}
                    # V primeru pomišljala so lahko besede tudi daljše.
                    omejitev="-ge"
                else
                    word_length=$2
                fi
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
    for word in $(grep -o "$WORD" "$1"); do
        echo ${word,,}
    done
}

prepare() {
    while read count word; do
        if [ $count -lt $min_count ]; then
            continue
        fi
        
        length=${#word}
        
        # Za preverjanje dolžine se operator poda kot argument, ta je lahko ali
        # -eq ali -ge. Odvisno od tega ali je zastavica za dolžino besede
        # vsebovala pomišljaj.
        if [ $word_length -eq 0 ] || [ $length $omejitev $word_length ]; then
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