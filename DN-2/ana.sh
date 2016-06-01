#!/bin/bash

# Statusi:
# 0 - Vse je vredu
# 1 - Neveljavno stikalo
# 2 - Datoteka na obstaja


## Spremenljivke za pomoč

# Vzorec za besede uporabljen z grep-om. Regex ne potrebuje ^ in $ saj grep
# privzeto poskuša najti najdaljše ujemanje vzorca, torej celo besedo.
WORD="[[:alpha:]]*"

## Zastavice skripte

# Najmanjše število pojavitev besede, da je ta vključena v izpis. (stikalo -n)
# Nastavljeno na 1, saj se bo vsaka najdena beseda vedno ponovila vsaj enkrat.
min_count=1

# Potrebovana dolžina besede, da je ta vključena v izpis. (stikalo -n)
# Nastavljeno na 0, saj nobena beseda nima takšne dolžine.
# Ta nesmiselna nastavitev bo predstavljala izklop omejitve.
word_length=0


## Branje zastavic in imena datoteke

# Ta zanka se izvaja, dokler ne zmanjka argumentov.
# Število teh se namreč zmanjšuje, zaradi uporabe ukaza shift.
while [ $# -gt 0 ]; do
    # Če je prvi znak argumenta minus, pomeni, da gre za zastavico
    if [ "${1:0:1}" = "-" ]; then
        case "$1" in
            -n)
                # Če je podana zastavica -n se shrani omejitev na številu pojavitev.
                min_count=$2
                ;;
            -l)
                # Če je podana zastavica -l se shrani omejitev na dolžini besede.
                word_length=$2
                ;;
             *)
                # Če zastavica še ni bila obravnavana, to pomeni, da ni veljavna.
                # Skripta se v tem primeru zaključi z napako.
                echo "Napaka: neznano stikalo $1." >&2
                exit 1
                ;;
        esac
        
        # Ker je vsaka zastavica sestavljena iz dveh delov (ime in vrednost)
        # se je potrebno znebiti dveh argumentov.
        shift 2
    else
        # Če argument ni zastavica je datoteka.
        # Če obstaja se shrani njeno ime, drugače pa se izpiše napaka.
        if [ -f "$1" ]; then
            file=$1
        else
            echo "Napaka: datoteka $1 ne obstaja." >&2
            exit 2
        fi
        
        shift
    fi
done


## Funkcije za procesiranje

# parse(datoteka) -> beseda...
# Funkcija parse prejme ime datoteke in izpiše besede z majhnimi črkami
parse() {
    # Grep z stikalom -o izpiše vsako ujemanje v svoji vrstici.
    # Ker je podan vzorec za besede, torej izpiše vsako besedo v svoji vrstici
    for word in $(grep -o "$WORD" "$1"); do
        # ,, je razširitev, ko omogoča pretvorbo v majhne črke.
        echo ${word,,}
    done
}

# (ponovitve, beseda)... -> prepare() -> (ponovitve, beseda, dolzina)...
# Funkcija prepare prejme na svoj vhod vrstice z besedami in ponovitvami
# ter izpiše nove vrstice, ki imajo dodane dolžine besed.
# Funkcija prav tako izloči vse vrstice z besedami, ki nimajo dovolj
# ponovitev ali niso primerne dolžine.
# Izpis dolžine besede v tej funkciji je potrebno za sortiranje besed po dolžini.
prepare() {
    # Read z več argumenti shrani vsak del vrstice v svojo sprmenljivko.
    while read count word; do
        # Če beseda nima dovolj ponovitev se preskoči preostali del zanke.
        # Med drugim tudi ukaz echo, zato se bo ta vrstica preskočena.
        if [ $count -lt $min_count ]; then
            continue
        fi
        
        # Ker je v več nadaljnjih operacijah potrebovana dolžina besede
        # jo je pametno tu shranivi v spremenljivko.
        length=${#word}
        
        # Preveri se če je onemogočena omejitev na dolžini besede
        # oz. če beseda ustreza podani dolžini.
        if [ $word_length -eq 0 ] || [ $length -eq $word_length ]; then
            echo "$count $word $length"
        fi
    done
}

# (ponovitve, beseda, dolzina)... -> format(stevilo_besed) -> (ponovitve, beseda, frekvenca)...
#
format() {
    while read count word length; do
        # Namesto ukazov, ki omogočajo računanje z decimalnimi števili,
        # se lahko željeno število pomnoži tako, da je to dovolj veliko,
        # da ne pride do izgube natančnosti.
        # A to pomeni, da je pozneje potrebno ročno vstaviti deciamlno piko.
        # Torej * 100 zaradi procenta in * 100 za 2 decimalni mesti.
        relative=$(( 10000 * $count / $1 ))
        
        # Če število nima celega dela, je najlažje vse možna števila
        # decimalnih mest obravnavati posebaj.
        if [ $relative -eq 0 ]; then
            frequency="0"
        elif [ $relative -lt 10 ]; then
            frequency=".0$relative"
        elif [ $relative -lt 100 ]; then
            frequency=".$relative"
        else
            # Če ima število, celi del bo vedno ta predstavljal vse do
            # predzadnjih dveh znakov. A je za pridobitev tega potrebno
            # prej shraniti dolzino števila (število znakov v nizu).
            length=${#relative}
            integer=${relative:0:$length - 2}
            
            # Decimalni del tu vedno predstavlja zadnji 2 mesti.
            decimal=${relative: -2}
            
            # Oba dela je nato potrebno samo še združiti s piko.
            frequency="${integer}.${decimal}"
        fi
        
        # V izpisu se za pravilno delovanje nato doda samo še procent.
        echo "${count} ${word} ${frequency}%"
    done
}


## Obdelava datoteke

# Parse bo, ko omenjeno zgoraj, po vrsticah izpisal vse besede v besedilu.
# Te se tu shranijo, ker jih je tako mogoče in prešteti (število vrstic)
# in uporabiti za procesiranje samega besedila.
words=$(parse $file)

# Če besedilo ne vsebuje besed, ni potrebno nadalnjo procesiranje.
# Exit bo zaključil skripto preden bi naredili kakeršenkoli izpis.
if [ -z "$words" ]; then
    exit 0
fi

# Ker so vse besede po vrsticah, se lahko s štetjem vrstic dobi točno
# število besed, kot jih vidi skripta.
total_words=$(wc -l <<< "$words")

# Tu se zgodi glavni del procesiranja!

# Najprej se besede preusmeri v sort, ki jih uredi po abecedi.

# Uniq z zastavico -c nato lahko iz urejenih besed odstrani ponovitve in
# prešteje za vsako besedo, kolikokrat se je ponovila.

# Prepare bo vzel vrstice s številom ponovitev besede in samo besedo ter
# odstranil besede, ki ne smejo biti v izpisu. Hkrati pa bo vrsticam dodal
# še dolžino besede.

# Nato bo sort uredil prejete vrstice po stolpcih. Privzeto po številu padajoče.
# Najprej po številu ponovitev, nato po dolžini besede in nazadnje po sami
# besedi. Pri tem opcija b pove ukazu sort, naj ignorira presledke pred besedo.
# Ta opacija pri sortiranju po stolpcih nima vplica, a bo onemogočila naš
# privzeti način sortiranja in tako preklopila na urejanje po abecedi.

# Zanji ukaz je format, ki bo iz že urejenih vrstic odstranil dolžino besede,
# ki je bila potrebna za urejanje. In doda na konec vsake vrstice še relativno
# frekvenco ponovitve besede v obliki procenta.

# Ker cevocod ni zavit v $(...) bo zadnji ukaz naredil izpis na standardni
# izhod, kot rezultat skripte.
sort <<< "$words" | uniq -c | prepare | sort -rn -k1,1 -k3,3 -k2,2b | format $total_words