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
            # Portebno je dodati stikalo -I, ki določi ali se razlikuje velikost črk.
            -I)
                # V primeru stikala se $razlikuj nastavi na 1, drugače nima vrednosti.
                razlikuj=1
                # Ker imajo stikala privzeto 2 dela se spodaj izvede shift 2,
                # ki se znebi dveh argumentov. A tu se je potrebno znebiti le
                # enega, zato se shift izvede ročno, continue pa prepreči, da
                # bi se izvedel spodnji shift 2.
                shift
                continue
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
        # Če se ne razlikuje med velikostjo črt se izpiše beseda
        # z malimi črkami, drugače pa v originalu.
        if [ -z $razlikuj ]; then
            echo ${word,,}
        else
            echo ${word}
        fi
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

# Pri sortiranju je potrebno sortirati neodvisno od velikosti črk, za to
# poskrbi opcija f na drugem stolpcu (-k2,2).
sort <<< "$words" | uniq -c | prepare | sort -rn -k1,1 -k3,3 -k2,2bf | format $total_words