## Lažja naloga

[lazja.sh](https://github.com/medja/os-gradivo/commit/98e588e88f23130182daaa21b3ff5bdcee564985)

Spremenite, da stikalu –l lahko za številko dodate pomišlaj, kar pomeni, da
upošteva tudi besede, ki so večje od podanega števila.

```
./ana.sh -l 10- besedilo.txt
1 vztrepetala .87%
1 nadstropje .87%
1 nasmehnila .87%
1 prekrižala .87%
1 steklenimi .87%
```

## Težja naloga

[tezja.sh](https://github.com/medja/os-gradivo/commit/7e43722d0d2e44a6c7b26b58fc4aa063830c2bb9)

Stikalo –k naj določa koren besede. Število, ki ga podamo stikalu kot argument
pomeni koliko zadnjih črk ne upoštevamo. Režemo samo besede, ki so daljše od
podanega števila.

```
./ana.sh -k 2 besedilo.txt
9 je 7.89%
5 v 4.38%
4 se 3.50%
3 in 2.63%
3 na 2.63%
3 z 2.63%
2 vratari 1.75%
2 hodni 1.75%
2 so 1.75%
2 n 1.75%
2 za 1.75%
1 vztrepeta .87%
1 nadstrop .87%
1 nasmehni .87%
...
```