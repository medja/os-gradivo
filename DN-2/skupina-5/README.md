## Lažja naloga

[lazja.sh](https://github.com/medja/os-gradivo/commit/d7df8f5b3ab887e58f10d35d5e5b8a15023d1444)

Stikalo –I naj pomeni, da razlikuje med malimi in velikimi črkami.

```
./ana.sh -I besedilo.txt
9 je 7.89%
5 v 4.38%
4 se 3.50%
3 in 2.63%
3 na 2.63%
3 z 2.63%
2 hodniku 1.75%
2 nad 1.75%
1 vztrepetala .87%
1 nadstropje .87%
1 Nasmehnila .87%
1 prekrižala .87%
1 steklenimi .87%
1 križanega .87%
1 materinem .87%
1 neveselim .87%
1 smehljajo .87%
1 steklenih .87%
1 vratarica .87%
1 vratarice .87%
1 jesensko .87%
1 kloštrih .87%
1 Kristusa .87%
1 nasmehom .87%
1 plamenom .87%
1 svetilko .87%
...
```

## Težja naloga

[tezja.sh](https://github.com/medja/os-gradivo/commit/848b9b7e0b2c4700c337b810642b32cc96374122)

Spremenite program, da v primeru, da mu ne podamo datoteke sprejema besedilo
iz standardnega vhoda.

```
echo a ba a | ./ana.sh
2 a 66.66%
1 ba 33.33%
```

```
cat besedilo.txt | ./ana.sh
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
1 nadstropje .87%
1 nasmehnila .87%
1 prekrižala .87%
1 steklenimi .87%
1 križanega .87%
1 materinem .87%
1 neveselim .87%
1 smehljajo .87%
1 steklenih .87%
...
```