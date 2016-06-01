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
            # Portebno je dodati stikalo -N, kjer je N omejitev na številu besed.
            # Ker to stikalo ni iz dveh delov je pogoj zanj nekoliko bolj zahteven.
            # Stikalo se mora začeti s pomišljajem in nadaljevati s številom.
            -[[:digit:]]*)
                # Iz števila se odstrani pomišljal.
                stevilo_besed=${1:1}
                # Ker imajo stikala privzeto 2 dela se spodaj izvede shift 2,
                # ki se znebi dveh argumentov. A tu se je potrebno znebiti le
                # enega, zato se shift izvede ročno, continue pa prepreči, da
                # bi se izvedel spodnji shift 2.
                shift 1
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

# Ker je izpis lahko omejen z številom besed se tu shrani v spremenljivko.
izpis=$(sort <<< "$words" | uniq -c | prepare | sort -rn -k1,1 -k3,3 -k2,2b | format $total_words)

# Če ni podana omejitev besed se prikaže celoten izpis,
# drugače je ta omejen z ukazom head.
if [ -z $stevilo_besed ]; then
    cat <<< "$izpis"
else
    head -n "$stevilo_besed" <<< "$izpis"
fi