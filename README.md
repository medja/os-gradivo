# Rešitve domačih nalog

V priloženih skriptah so prikazane čim bolj preproste rešitve osnovnih domačih
nalog in dodatnih nalog iz zagovorov. A nekatere rešitve uporabljajo koncepte,
ki verjetno niso znani vsem. Obrazlage teh in nekaj nasvetov iz Bash-a je v
naslednjih odstavkih.

## Bash

Bash je izredno močen ukazni jezik, ki se pogosto uporablja v lupinah na Linux-u
in podobnih sistemih. Njegova moč pride zlasti programov oziroma ukazov, ki jih
je v njem mogoče zagnati. Ti navadno opravljajo le eno nalogo in to nalogo
opravijo dobro. Sami po sebi sicer niso posebej zmogljivi, skupaj pa je njihova
moč neprimerljiva. In to združevanje in mnogo več omogoča Bash.

### Razširitve parametrov

V Bash-u nam shranjevanje in dostopanje do vrednosti omogočajo parametri.
Parametri niso nič posebnega. Znakovni parametri so spremenljivke, številski
predstavljajo argumente in posebni simboli predstavljajo posebne vrednosti,
kot je izhodni status zadnjega ukaza.

Razširitve parametrov omogočajo raznovrstne operacije nad nizi. Vse od
pridobivanja dolžine vrednosti parametra do brisanja dela niza s pomočjo
vzorca. Teh operacij sicer navadno ni mogoče združiti skupaj in jih je potrebno
izvesti eno za drugo, a kljub temu predstavljajo izredno preprost način za
obdelavo vrednosti brez uporabe dodatnih ukazov, ki so navadno počasnejši.
Prav tako te razširitve podpirajo delo z več-bitnimi znakovnimi nabori, kar je
predpogoj za podporo znakov, kot so šumniki.

Nekaj koristnih razširitev je:

 - Število znakov v nizu: `${#parameter}`
 - Posreden dostop do parametra*: `${!parameter}`
 - Spreminjanje velikosti črk: `${parameter,,}` in `${parameter^^}`

> *Dostop do parametra, katerega ime, je v podani spremenljivki.

Še več pa jih je opisanih na tej spletni strani:  
http://wiki.bash-hackers.org/syntax/pe

### Razširitve nizov

Razširitev niza je samodejno deljenje niza s presledki na več delov. To stori
Bash vsakič, ko neki parameter, katerega vrednost je mogoče razdeliti, podamo
kot argument nekega ukaza ali pa uporabimo na kakšnem drugem mestu, npr. v
zanki. Ta pojav je pogosto uporaben, a včasih nezaželen.

Če bi želeli preverjati enakost dveh nizov s presledki v if stavku s pomočjo
ukaza test, bi Bash niz s presledki upošteval kot več zaporednih argumentov
( `[ $niz = "enako" "besedilo" ]` ). To se lahko reši tako, da se okoli
spremenljivke navedejo dvojni narekovaji. Ti v primeru niza brez presledkov
ne naredijo nič in zato ne škodujejo, v nasprotnem primeru pa so pogosto
ključni za pravilno delovanje ukaza.

Pogosta napaka, do katere pride zaradi pomanjkanja narekovajev, je izpis niza
z ukazom `echo`. Če niz vsebuje podvojene presledke ali pa nove vrstice se bodo
brez narekovajev te izgubile, saj bo Bash niz najprej razširil na več delov in
potem vsakega posebej podal ukazu echo kot ločen argument. Echo nato preprosto
izpiše vse svoje argumente, a brez podvojenih presledkov in novih vrstic, saj
so bile te izgubljene pri razbijanju niza. Ta problem se lahko reši tako, da
se parameter, ki ga želimo izpisati ovije v dvojne narekovaje.

Morda kot zanimivost, to ne drži znotraj `case` stavka in pogojnega izraza
`[[ ... ]]`. Ta za razliko od test-a namreč ni implementiran kot ukaz, temveč
kot poseben konstrukt jezika:  
http://wiki.bash-hackers.org/syntax/ccmd/conditional_expression

### Case stavek

Case stavek omogoča primerjanje po vsebini. Z njim lahko nadomestimo več
zaporednih `if ... elif ... else` stavkov, ki primerjajo en parameter z
različnimi vrednostmi oziroma vzorci.

Ta se navadno uporablja zgolj zaradi boljše berljivosti kode, saj že sama
uporabe te strukture pove, da primerjamo le eno samo vrednost.

Nekaj več o case stavku je napisano tukaj:  
http://wiki.bash-hackers.org/syntax/ccmd/case

### For zanka

Bash vsebuje več različnih zank. Ena izmed teh je `for` zanka. Ta je izvrstna za
iteriranje čez sezname elementov, naj bo to preprosto besedilo z več besedami
ali pa tabela z elementi. Pri njej je potrebno navesti ime spremenljivke, v
kateri se bo v vsaki ponovitvi nahajala trenutna vrednost, in parameter čez
katerega iteriramo. V primeru, da ta parameter ni podan, se zanka pomika čez
argumente.

Nekaj več o zanki `for` je napisano tukaj:  
http://wiki.bash-hackers.org/syntax/ccmd/classic_for

### While zanka

Medtem ko navadno velja, da je `for` zanka močnejša različica `while` zanke, to
ni res v Bash-u. Ta namreč za razliko od zanke `for` nima točno določenega načina
pomikanja čez podatke, temveč se izvaja preprosto, dokler se pogojni ukaz
izvaja uspešno. Za pogojni ukaz pa se lahko uporabi prav katerikoli ukaz. Po
navadi je to ukaz test, s katerim lahko preverjamo neki pogoj, lahko pa je na
njegovem mestu poljuben ukaz.

Dva pogosta ukaza sta:

 - `read`: omogoča branje vrstic iz standardnega vhoda,
 - `grep` z zastavico `-q`: omogoča preverjane ali neka datoteka vsebuje
določeno vsebino.

Nekaj več o zanki `while` je napisano tukaj:  
http://wiki.bash-hackers.org/syntax/ccmd/while_loop

### Cevovod

Cevovod v Bash-u ni nič drugega kot serija med seboj povezanih ukazov. Te
verižimo enega za drugim s pomočjo navpičnice. Ukazi, zapisani v cevovodu,
se izvajajo v podlupini, a z eno posebnostjo. Standardni izhod vsakega
prejšnjega programa se namreč preusmeri v naslednjega, medtem ko se vse
poslano na izhod za napake brez dodatne preusmeritve normalno izpiše uporabniku.

Čeprav se sami ukazi izvedejo v podlupini, pa je izpis zadnjega ukaza še vedno
poslan na standardni izhod skripte. Za zajem izhoda v spremenljivko je treba
okoli cevovoda dodati še eno podlupino. Prvi ukaz pa, kot pri izvajanju v
navadni podlupini, dobi dostop do standardnega vhoda skripte, ki ga poganja.

### Funkcije

Funkcije v Bash-u omogočajo združevanje več zaporednih ukazov za doseg skupne
funkcionalnosti. Ker se uporabijo kot ukazi, jih je zato mogoče vstaviti tudi
v cevovod.

Funkcije imajo svoj standardni vhod, izhod in izhod za napake. Njihove
spremenljivke pa so privzeto definirane na ravni skripte. To pomeni, da
definicija spremenljivke znotraj funkcije to definira tudi izven nje, razen
če je ta narejena lokalno z `local` ali pa pognana v podlupini.

Uporaba funkcij je priporočen ne samo zaradi zmogljivosti ponovne uporabe
zaporedja ukazov na več mestih, temveč tudi zaradi berljivosti. V splošnem
se je v večini jezikov pogosto težko odločiti med berljivostjo in
dolžino kode. Navadno je daljša koda tudi nekoliko bolj berljiva, a to le
dokler je vsa koda, pomembna za razumevanje neke operacije vidna brez
pomikanja. Pri tem kompromisu pomagajo funkcije. Namreč z uporabo teh se
lahko sicer daljši del kode razbije na več krajših delov.

## Ukaz `read`

Ukaz `read` je namenjen branju vrstic. Navadno se uporablja za branje iz
standardnega vhoda ali pa podatkov, ki so vanj preusmerjeni preko zanke. Ta
si namreč pri več zaporednih klicih "zapomni" do katere vrstice je že prebral
vsebino. To pomeni, da bo pri branju iz standardnega vhoda bral zaporedne
vrstice, in znotraj zanke, v katero je preusmerjena vsebina, bral zaporedne
vrstice te vsebine. Če pri vsakem branju na novo preusmerimo notri neko
vsebino, pa bo vedno prebral le prvo vrstico.

Pri branju ta privzeto shrani celotno vrstico v podano spremenljivko, a
spremenljivk je mogoče navesti več. Če je podanih več spremenljivk bo vsak
naslednji del vrstice shranil v svojo spremenljivko. V zadnjo spremenljivko
pa bo shranil preostanek vrstice. Dele vrstice navadno loči s presledki
in tabulatorji, a je to mogoče spremeniti s spremenljivko `IFS`.

Nekaj več o ukazu `read` je napisano tukaj:  
http://wiki.bash-hackers.org/commands/builtin/read

## Ukaz `shift`

Ukaz `shift` omogoča odstranjevanje prvega oziroma prvih nekaj argumentov. To
pomeni, da `$2` postane `$1`, `$3` postane `$2` itd. Prav tako ta ukaz spremeni
število argumentov `$#`. Ukaz privzeto odstrani prvi argument, če pa mu podamo
kot argument neko število, bo odstranil toliko argumentov.

Uporaba ukaza je priporočena zlasti pri obdelavi podanih argumentov. Ob
pregledovanju argumentov od prvega do zadnjega je s tem ukazom mogoče
odstraniti že obdelane ukaze. Ta rešitev je nekoliko bolj pregledna kot uporaba
posrednega dostopa (`${!index}`, kjer je `$index` število med `1` in `$#`), saj
je hitreje razvidna uporaba več zaporednih argumentov, npr. stikalo in vrednost.

Nekaj več o ukazu `shift` je napisano tukaj:  
http://wiki.bash-hackers.org/commands/builtin/shift

## Ukaz `grep`

Ukaz `grep` je izredno močen ukaz za iskanje po vsebini neke datoteke ali
standardnega vhoda. Za iskanje ta uporablja regularne izraze in pozna več
enkodiranj, med drugim podpira tudi slovensko abecedo. Privzeto izpiše le
vrstice, ki se v nekem delu ujemajo s podanim vzorcem. Pri neposrednem izpisu
v konzolo bodo ujemajoči se deli vrstic tudi obarvani. Podobno kot `cat`, tudi
`grep` v primeru podane datoteke pregleda to, če datoteka ni podana pa bere iz
svojega standardnega vhoda.

Grep ima zelo veliko stikal, od teh kar nekaj izredno uporabnih:

 - `-i`: ignorira velikosti črk in vse obravnava enako
 - `-v`: izpiše le vrstice, ki ne usrezajo vzorcu (negira vzorec)
 - `-w`: zahteva, da vzorec ustreza celotni besedi in ne le delu besede
 - `-x`: zahteva, da vzorec ustreza celotni dolžini vrstice
 - `-o`: izpiše samo ujemajoče se dele, vsakega v svoji vrstici
 - `-q` brez izpisa, v primeru uporabe namesto ukaza test
 - `-n`: oštevilči izpisane vrstice

## Regularni izrazi

Regularni izrazi ali Regex-i nam omogočajo definiranje končnih avtomatov v
obliki znakovnega niza. Navadno se uporabljajo za definiranje vzorcev, s
katerimi potem lahko iščemo po besedilu.

Regex-e nam omogoča uporabljati tako Bash, kot tudi kar nekaj drugih programov.
V Bash-u lahko brez dodatnih nastavitev te uporabljamo znotaj pogojnih izrazov:

```bash
niz="abcčšž"
regex="^[[:alpha:]]+$"

if [[ $niz =~ $regex ]]; then
    echo "$niz je beseda"
else
    echo "$niz ni beseda"
fi

# Izpise: abcčšž je beseda
```

Pri takšni uporabi je Regex priporočeno najprej shraniti v spremenljivko.

Za iskanje z Regex-i se navadno uporablja `grep`, za izvajanje sprememb pa
`sed`. Oba ukaza med drugim omogočata branje iz datoteke, kar pomeni, da ju
ni treba kombinirati s preusmeritvami ali ukazom `cat`.