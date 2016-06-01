# Načrtovanje rešitve

Prvi korak pri načrtovanju kateregakoli programa je načrtovanje.

Pri tej nalogi je bilo potrebno ugotoviti, da razdeli na dva glavna dela. Prvi
je procesiranje argumentov skripte. Saj je to potrebno storiti preden lahko
skripta začne procesirati samo besedilo.

Drgui del skripte pa je samo procesiranje besedila. Tu se je potrebno odločiti
za način strukture tega dela skripte. Celotno procesiranje je namreč mogoče
napisati že samo z dvema zankama. A tako ti dve zanki hitro postanete precej
kompleksni.

## Procesiranje besedila

Pri procesiranju besedila se lahko z nekaj truda upazi en vzorec. In sicer
se samo procesiranje lahko razdeli ne nekaj korakov:

 1. Iskanje besed
 2. Pretvorba besed v male črke
 3. Štetje ponovitev besed
 4. Izločanje neustreznih besed
 5. Sortiranje
 6. Razčuanje frekvence
 7. Izpis rezultata

Ker se tu vse operacije izvajajo na vrsticah je smiselno pomisliti na uporabo
cevovoda. Sortiranje in štetje besed je celo mogoče izvesti s pomočjo že
obstoječih ukazov. Zato je za ta pristop potrebno samo implementirati
manjkajoče ukaze v obliki funkcij.