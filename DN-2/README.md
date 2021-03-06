Napišite skripto z imenom ana.sh, ki izpiše statistiko besed v podanem besedilu,
kolikokrat se beseda v besedilu pojavi ter kolikšen del besedila pokrije (v
odstotkih) - glej primere klicev skripte spodaj. Omejite se samo na črke, med
malimi in velikimi črkami ne razlikujte. Besedilo podajte skripti kot argument.
Izpisan seznam naj bo urejen po velikosti: od besede z največ pojavitvami
naprej, besede z istim številom pojavitev pa so urejene po dolžini, daljše
najprej, drugače pa po abecedi.

Če ima skripta ob klicu podano stikalo -l, potem izpis omejite samo na besede,
ki so dolge natanko št_znakov (sintaksa: -l št_znakov).

```
Primer: ana.sh –l 3 besedilo.txt 
# bo izpisalo analizo besed dolžine 3 znakov.
```

Če skripti podamo stikalo -n št_pojavitev pomeni, da omejimo izpis na besede,
ki se pojavijo vsaj št_pojavitev (sintaksa: -n št_pojavitev).

```
Primer: ana.sh -n 3 besedilo.txt 
# izpiše samo analizo tistih besed, ki se pojavijo 3-krat ali več.
```

Kot zadnji argument je vedno padana datoteka z besedilom. Vrstni red stikal je
poljuben:

```
ana.sh besedilo.txt
ana.sh -l 2 besedilo.txt
ana.sh -n 5 besedilo.txt
ana.sh -n 5 -l 2 besedilo.txt 
ana.sh -l 2 -n 5 besedilo.txt 
```

V primeru napačnega stikala skripta izpiše napako na standardni izhod za napake:
"Napaka: neznano stikalo ime_stikala." in se zaključi z ustreznim statusom, kjer
ime_stikala nadomestimo s stikalom, ki ste ga podali. 

```
ana.sh -t text.txt 
Napaka: neznano stikalo –t.
```

V primeru, da datoteka ne obstaja, skripta izpiše napako na standardni izhod za
napake: "Napaka: datoteka ime_datoteke ne obstaja." in se zaključi z ustreznim
statusom, kjer ime_datoteke nadomestite z imenom, ki ste ga podali.

```
ana.sh text.txt 
Napaka: datoteka text.txt ne obstaja.
```

_Uporabljajte lahko le **bash in ne drugih programskih jezikov** (odpadeta tudi
awk in sed)! Za računanje z decimalnimi števili uporabite ukaz **bc** ali
**dc**. Ne spreminjati datotek z besedilom in ne ustvarjajte novih datotek.
Svoj program optimizirajte. Za najhitrejši program dobite dodatne točke._

---

Primeri delovanja skripte so prikazani spodaj. Primeri ilustrirajo delovanje nad
tekstovno datoteko besedilo.txt

Vsebina datoteke besedilo.txt:

> Tiho so se zaprla velika železna vrata; v mračnem hodniku, na mrzlih stenah
> je zasijalo za hip jesensko sonce. Za steklenimi durmi, v sobi vratarice, je
> gorela rdeča luč z dolgim, mirnim plamenom; nad svetilko je bilo pribito na
> steni razpelo z golim, vse krvavim telesom križanega Kristusa, ki še ni bil
> nagnil glave in je gledal z velikimi mirnimi očmi. Malči je vztrepetala v
> materinem naročju in se je prekrižala.  
> Izza steklenih duri je stopila vratarica, mlada, šepava ženska. Nasmehnila
> se je, kakor se smehljajo v kloštrih, s hladnim, neveselim nasmehom.  
> »Hvaljen bodi Jezus Kristus! Pojdite gor, zmerom na levo, v drugo nadstropje
> in po hodniku; nad vratmi je zapisano: soba sv. Neže.«  

```
./ana.sh -n 1 besedilo.txt | head
9 je 7.89%
5 v 4.38%
4 se 3.50%
3 in 2.63%
3 na 2.63%
3 z 2.63%
2 hodniku 1.75%
2 nad 1.75%
2 za 1.75%
1 vztrepetala .87%
```
  
```
./ana.sh -n 2 -l 3 besedilo.txt
2 nad 1.75%
```

```
./ana.sh -n 2 -l 2 besedilo.txt
9 je 7.89%
4 se 3.50%
3 in 2.63%
3 na 2.63%
2 za 1.75%
```

```
./ana.sh neznanoBesedilo.txt
Napaka: datoteka neznanoBesedilo.txt ne obstaja.
```
 
 ```
./ana.sh -x
Napaka: neznano stikalo -x.
```