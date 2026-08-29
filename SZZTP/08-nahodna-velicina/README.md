## 8 — Náhodná veličina a její charakteristiky

> Náhodná veličina a její charakteristiky (distribuční funkce, druhy, pravděpodobnostní funkce vs. hustota pravděpodobnosti, číselné charakteristiky [střední hodnota, rozptyl, kvantily], vybraná diskrétní a spojitá rozdělení pravděpodobnosti)

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. **Náhodná veličina** — zobrazení z prostoru elementárních jevů do reálných čísel; „přiřadím pokusu číslo"
2. **Dva druhy** podle oboru hodnot: **diskrétní** (spočetně mnoho hodnot) vs. **spojitá** (celý interval)
3. **Pravděpodobnostní funkce** $P(X = x)$ u diskrétní — výška sloupce **je** pravděpodobnost
4. **Hustota** $f(x)$ u spojité — **hustota není pravděpodobnost**, pravděpodobnost je až **plocha pod ní**
5. Proto $P(X = a) = 0$ u spojité veličiny — plocha nad jedním bodem je nulová
6. **Distribuční funkce** $F(x) = P(X \le x)$ — jediný popis, který funguje pro **oba** druhy
7. Vlastnosti $F$: neklesající, $0$ v $-\infty$, $1$ v $+\infty$, spojitá zprava; **schody** vs. **hladká sigmoida**
8. Vztah $f$ a $F$: **integrací nahoru, derivací dolů** — tady se napojuje [okruh 5](../05-derivace-integraly-numerika/)
9. **Střední hodnota** $E(X)$ — vážený průměr, „těžiště" rozdělení
10. **Rozptyl** $D(X)$ a směrodatná odchylka — míra rozptýlení; výpočetní vzorec $E(X^2) - [E(X)]^2$
11. **Kvantily** a medián — „hodnota, pod kterou padne $p$ procent"
12. **Vybraná rozdělení:** alternativní, binomické, Poissonovo / rovnoměrné, normální, exponenciální
13. Vztahy mezi nimi a **normální rozdělení jako limita** — tady výklad graduje

**Nit, na kterou to navlékni:** náhodná veličina je **překlad náhody do čísel** — místo „padl orel" napíšu $1$, a od té chvíle můžu počítat. Celá otázka pak stojí na jediném rozdělení: **diskrétní veličina se dá vyjmenovat, spojitá ne** — a všechno ostatní z toho plyne. U diskrétní sečtu pravděpodobnosti jednotlivých hodnot, u spojité **žádná jednotlivá hodnota pravděpodobnost nemá** a musím integrovat přes interval. Proto má diskrétní pravděpodobnostní funkci a spojitá hustotu; proto má první schodovitou a druhá hladkou distribuční funkci; proto se ve vzorcích pro střední hodnotu jednou sčítá a podruhé integruje. **Distribuční funkce je pak ten jediný popis, který zvládne obojí** — a proto se definuje jako první.

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tahák, který si vyrobíš zpaměti hned na začátku přípravy. Napsání zabere zhruba tři minuty, zbylých dvanáct pak máš na rozmyšlení příkladu.

```
NÁHODNÁ VELIČINA X: prostor elementárních jevů -> R   (pokusu přiřadím číslo)

           DISKRÉTNÍ                  |  SPOJITÁ
  ---------------------------------------------------------------------
  hodnoty  dají se vyjmenovat         |  celý interval
  popis    pravděpodobnostní funkce   |  HUSTOTA f(x)
           P(X = x)                   |
  P(X = a) může být kladná            |  VŽDY NULA
  P(a<X<b) sečtu sloupce              |  integral od a do b z f(x) dx
  F(x)     SCHODY (skáče o P(X=x))    |  hladká rostoucí křivka
  norma    suma P(x_i) = 1            |  integral přes celé R z f = 1
  E(X)     suma x_i * P(x_i)          |  integral x * f(x) dx

DISTRIBUČNÍ FUNKCE  F(x) = P(X <= x)     ...funguje pro OBA druhy
  neklesající | F(-oo) = 0 | F(+oo) = 1 | spojitá zprava
  P(a < X <= b) = F(b) - F(a)
  f(x) = F'(x)      F(x) = integral od -oo do x z f(t) dt

STŘEDNÍ HODNOTA  E(X) = vážený průměr = TĚŽIŠTĚ rozdělení
  E(aX + b) = a*E(X) + b

ROZPTYL  D(X) = E[ (X - E(X))^2 ]  = E(X^2) - [E(X)]^2   <- výpočetní tvar
  směrodatná odchylka  sigma = odmocnina z D(X)   (má stejnou JEDNOTKU jako X)
  D(aX + b) = a^2 * D(X)      <- posun b rozptyl NEMĚNÍ

KVANTIL x_p:  F(x_p) = p    "pod x_p padne 100p procent hodnot"
  medián = x_0,5    kvartily x_0,25  x_0,75

ROZDĚLENÍ
  alternativní A(p)   1 pokus, úspěch/neúspěch   E = p       D = p(1-p)
  binomické Bi(n,p)   n nezávislých pokusů       E = np      D = np(1-p)
  Poissonovo Po(l)    počet událostí za čas      E = l       D = l
  rovnoměrné R(a,b)   všude stejně               E = (a+b)/2
  normální N(mu,s^2)  zvon, symetrický           E = mu      D = s^2
  exponenciální E(l)  čekání na událost          E = 1/l

NORMÁLNÍ: pravidlo 68 - 95 - 99,7 procent pro 1, 2 a 3 sigma
  U = (X - mu)/sigma   ...standardizace na N(0,1), odtud tabulky

PASTI: hustota NENÍ pravděpodobnost, může být i větší než 1
       u spojité P(X = a) = 0, takže < a <= je jedno
       rozptyl je v DRUHÝCH mocninách jednotky, proto sigma
```

#### Jak si z toho odvodit zbytek

- **Vzorce pro $E$ a $D$ si nepamatuj dvakrát.** Je to pořád „posčítej hodnoty vážené jejich pravděpodobností" — u diskrétní je to $\sum$, u spojité $\int$ a místo $P(x_i)$ je $f(x)\,\mathrm{d}x$. **Suma a integrál jsou tady totéž**, jen pro spočetně a nespočetně mnoho hodnot.
- **Výpočetní tvar rozptylu se odvodí roznásobením.** $E[(X-\mu)^2] = E[X^2 - 2\mu X + \mu^2] = E(X^2) - 2\mu E(X) + \mu^2 = E(X^2) - \mu^2$. Používej ho — je na počítání mnohem rychlejší než definiční.
- **$D(aX+b) = a^2 D(X)$ nemusíš znát nazpaměť**, plyne z významu: posun $b$ přesune celé rozdělení, ale **nezmění, jak je roztažené**; násobení $a$ ho roztáhne $a$-krát, a protože rozptyl je ve druhých mocninách, roste $a^2$-krát.
- **Střední hodnoty rozdělení se dají uhodnout.** $Bi(n,p)$ je $n$ nezávislých alternativních pokusů, takže $E = n \cdot p$ — prostě $n$-krát to, co dá jeden pokus. U $R(a,b)$ je střed intervalu, u $E(\lambda)$ je $\frac{1}{\lambda}$, protože $\lambda$ je „kolik událostí za jednotku času" a čekání je jeho převrácená hodnota.
- **Pravidlo 68–95–99,7 stačí v hrubých číslech.** Řekni „zhruba dvě třetiny, devadesát pět procent a skoro všechno" — přesné hodnoty po tobě nikdo nechce.

#### Jak si to zapamatovat, aniž bys to biflil

> **Diskrétní se dá vyjmenovat, spojitá ne. Všechno ostatní je jen důsledek.**

Celá tabulka v taháku je odpověď na jednu otázku — *„jde ty hodnoty spočítat po jedné?"*:

| Když jde vyjmenovat… | Když nejde… |
|---|---|
| každá hodnota má svou pravděpodobnost | jednotlivá hodnota má pravděpodobnost **nula** |
| pravděpodobnosti **sečtu** | musím **integrovat přes interval** |
| $F$ dělá **skok** v každé hodnotě | $F$ roste **plynule** |
| popisuje ji pravděpodobnostní funkce | popisuje ji **hustota** |

**Proč $P(X = a) = 0$ u spojité veličiny** je nejlepší si představit takhle: možných hodnot je nespočetně mnoho a jejich pravděpodobnosti musí dát dohromady $1$. Kdyby jediná z nich měla kladnou pravděpodobnost, mělo by ji i nekonečně mnoho dalších a součet by přerostl jedničku. **Pravděpodobnost je tedy „rozmazaná" po intervalu, ne uložená v bodech** — a proto se jmenuje *hustota*, přesně jako u hmoty: bod hmotnost nemá, teprve objem ano.

##### Kde to navazuje na ostatní okruhy

| Co tady | Kde to už bylo | Jak to spolu souvisí |
|---|---|---|
| $F(x) = \int_{-\infty}^{x} f(t)\,\mathrm{d}t$ | určitý integrál, [okruh 5](../05-derivace-integraly-numerika/) | distribuční funkce **je** plocha pod hustotou |
| $f(x) = F^{\prime}(x)$ | derivace, [okruh 5](../05-derivace-integraly-numerika/) | zpátky dolů se jde derivováním |
| $e^{-x^2}$ nemá elementární primitivní funkci | [okruh 5](../05-derivace-integraly-numerika/) | **proto se u normálního rozdělení používají tabulky** |
| kvantil | [okruh 9](../09-intervaly-spolehlivosti/) | intervaly spolehlivosti stojí na kvantilech $u_{1-\alpha/2}$ |
| $\mu$, $\sigma$, $\sigma^2$, $\lambda$ | značky, [okruh 11](../11-rekurence-asymptotika/) | tam máš celý tahák na řecká písmena |
| střední hodnota jako těžiště | vážený průměr | tentýž vzorec jako Simpsonovy váhy v [okruhu 5](../05-derivace-integraly-numerika/) |

---

### Náhodná veličina

#### Co to je

- **náhodný pokus** — děj, jehož výsledek není předem jistý (hod kostkou, měření, čekání na autobus)
- **elementární jev** $\omega$ — jeden konkrétní možný výsledek
- **prostor elementárních jevů** $\Omega$ — množina všech možných výsledků

**Náhodná veličina** $X$ je **zobrazení** $X : \Omega \to \mathbb{R}$, které každému elementárnímu jevu přiřadí reálné číslo.

$$X : \Omega \to \mathbb{R}$$

> **Řekni to takhle:** „Náhodná veličina je **překlad náhody do čísel**. Výsledek pokusu je ‚padl orel', a to se nedá sčítat ani průměrovat. Přiřadím-li mu číslo $1$, můžu s ním od té chvíle počítat." To je celý smysl toho pojmu a je to lepší úvod než formální definice.

**Příklad:** hodím dvěma kostkami. $\Omega$ jsou dvojice $[1,1], [1,2], \dots, [6,6]$, tedy 36 elementárních jevů. Náhodná veličina $X = $ „součet ok" každé dvojici přiřadí číslo od $2$ do $12$.

> **Formální detail, který zmiň jen když se ptají:** aby zobrazení bylo náhodnou veličinou, musí být **měřitelné** — pro každé $x$ musí být $\{\omega : X(\omega) \le x\}$ jev, kterému umíme přiřadit pravděpodobnost. Bez toho by nešlo definovat $F(x)$.

#### Dva druhy

| | **Diskrétní** | **Spojitá** |
|---|---|---|
| obor hodnot | konečně nebo **spočetně** mnoho hodnot | celý **interval** |
| dají se hodnoty vyjmenovat? | **ano** | **ne** |
| příklad | počet ok, počet vadných kusů, počet příchodů | výška, hmotnost, doba čekání, chyba měření |
| popis rozdělení | **pravděpodobnostní funkce** | **hustota pravděpodobnosti** |

> **Praktické rozlišení:** diskrétní veličina většinou vzniká **počítáním**, spojitá **měřením**. Když se ptám „kolik", je to diskrétní; když „jak moc", spojitá.

---

### Pravděpodobnostní funkce vs. hustota

#### Diskrétní: pravděpodobnostní funkce

$$P(X = x_i) = p_i, \qquad \sum_i p_i = 1$$

- graf je sada **izolovaných sloupců**, mezi nimiž není nic
- **výška sloupce přímo je pravděpodobnost** té hodnoty
- proto musí platit $0 \le p_i \le 1$

**Na kostce:** $X$ = počet ok, $P(X = k) = \frac{1}{6}$ pro každé $k$ od $1$ do $6$. Kontrola normalizace: $6 \cdot \frac{1}{6} = 1$ ✔. A $P(X \le 3) = \frac{1}{6}+\frac{1}{6}+\frac{1}{6} = 0{,}5$ — prostě sečtu tři sloupce.

```
 P
0,3┤              ▌
   │        ▌     ▌     ▌
0,1┤  ▌     ▌     ▌     ▌     ▌
   └──┴─────┴─────┴─────┴─────┴───▶ x
      1     2     3     4     5

   výška sloupce = pravděpodobnost, součet výšek = 1
```

#### Spojitá: hustota pravděpodobnosti

$$P(a \le X \le b) = \int_a^b f(x)\,\mathrm{d}x, \qquad \int_{-\infty}^{\infty} f(x)\,\mathrm{d}x = 1$$

- graf je **spojitá křivka**
- **pravděpodobnost je plocha pod křivkou** na daném intervalu, ne výška v bodě
- platí jen $f(x) \ge 0$ a celková plocha $1$

**Na výšce dospělých mužů:** $X$ = výška v centimetrech, zvon s vrcholem kolem $180$ cm. Otázka *„jaká je pravděpodobnost, že měří přesně $180$ cm?"* nedává smysl — odpověď je $0$. Ptát se jde jen na interval: *„kolik jich měří mezi $175$ a $185$ cm?"*, a to je plocha pod křivkou mezi těmi mezemi.

```
 f
   │      ___
   │    ╱█████╲
   │   ╱███████╲
   │  ╱█████████╲___
   └──┴────┴──────────▶ x
      a    b

   P(a <= X <= b) = VYŠRAFOVANÁ PLOCHA
```

> **Past, která rozhoduje celou otázku:** **hustota není pravděpodobnost.** Může nabývat hodnot **větších než 1** — třeba rovnoměrné rozdělení na $[0;\ 0{,}5]$ má hustotu $f(x) = 2$, protože plocha $2 \cdot 0{,}5 = 1$ musí sedět. Pravděpodobností se hustota stane teprve **vynásobením šířkou**, tedy integrací. Jednotka hustoty je „pravděpodobnost na jednotku $x$" — proto ta analogie s hustotou hmoty.

> **Druhá past, plynoucí z první:** u spojité veličiny je $P(X = a) = 0$ pro **každé** $a$, protože plocha nad jediným bodem je nulová. Neznamená to, že je ten jev nemožný — jen že má nulovou pravděpodobnost. **Praktický důsledek: u spojité veličiny je jedno, jestli napíšu $<$ nebo $\le$.** U diskrétní to jedno rozhodně není.

---

### Distribuční funkce

Jediný popis, který funguje **stejně pro oba druhy** — proto se zavádí jako první a proto ji zadání jmenuje hned na začátku.

$$F(x) = P(X \le x)$$

„Jaká je pravděpodobnost, že veličina nepřesáhne $x$."

#### Vlastnosti

1. **neklesající** — pravděpodobnost se cestou doprava jen přičítá
2. $\lim_{x \to -\infty} F(x) = 0$ a $\lim_{x \to \infty} F(x) = 1$
3. **spojitá zprava**
4. $P(a < X \le b) = F(b) - F(a)$

**Na kostce:** $F(3) = P(X \le 3) = 0{,}5$ a $F(5) = \frac{5}{6} \doteq 0{,}833$. Pravděpodobnost, že padne čtyřka nebo pětka, tedy spočítám odečtením:

$$P(3 < X \le 5) = F(5) - F(3) = 0{,}833 - 0{,}5 = 0{,}333 = \tfrac{2}{6} \ ✔$$

To je ta vlastnost 4 v akci — **rozdíl dvou hodnot $F$ dá pravděpodobnost intervalu**, a proto je distribuční funkce tak užitečná.

```
  DISKRÉTNÍ: schody              SPOJITÁ: hladká sigmoida
 F                              F
 1┤        ┌───                1┤        ______
  │     ┌──┘                    │      ╱
  │  ┌──┘                       │    ╱
 0┤──┘                         0┤__╱
  └──┴──┴──┴───▶ x              └──────────────▶ x

 skok v každé hodnotě,          roste plynule,
 výška skoku = P(X = x)         žádné skoky
```

> **Doptávka, která přijde:** *„Jak z grafu distribuční funkce poznám, jestli je veličina diskrétní, nebo spojitá?"* **Podle skoků.** Skoky = diskrétní, a výška každého skoku je přesně pravděpodobnost té hodnoty. Hladký průběh = spojitá.

#### Vztah k hustotě — tady se napojuje okruh 5

$$F(x) = \int_{-\infty}^{x} f(t)\,\mathrm{d}t \qquad \text{a zpět} \qquad f(x) = F^{\prime}(x)$$

**Nahoru integrací, dolů derivací.** Je to přesně ta dvojice operací z [okruhu 5](../05-derivace-integraly-numerika/) — distribuční funkce je „nasčítaná" hustota, hustota je „rychlost růstu" distribuční funkce.

---

### Číselné charakteristiky

#### Střední hodnota

$$E(X) = \sum_i x_i\,p_i \qquad \qquad E(X) = \int_{-\infty}^{\infty} x\,f(x)\,\mathrm{d}x$$

##### Co znamená $x_i$ a $p_i$

Jsou to očíslované seznamy, kde $i$ je pořadové číslo možnosti:

| $i$ | $1$ | $2$ | $3$ | $4$ | $5$ | $6$ |
|---|---|---|---|---|---|---|
| $x_i$ — **hodnota** | $1$ | $2$ | $3$ | $4$ | $5$ | $6$ |
| $p_i$ — **její pravděpodobnost** | $\frac{1}{6}$ | $\frac{1}{6}$ | $\frac{1}{6}$ | $\frac{1}{6}$ | $\frac{1}{6}$ | $\frac{1}{6}$ |

Suma $\sum_i x_i p_i$ tedy říká: **projdi všechny možnosti, každou hodnotu vynásob její pravděpodobností a sečti to.**

> **Pozor, ta šestka je počet možností, ne počet hodů.** Kostkou házím **jednou** a ona má šest stěn, takže sčítám šest sčítanců. U mince by byly dva: $E(X) = 0 \cdot 0{,}5 + 1 \cdot 0{,}5 = 0{,}5$.

**Proč se tomu říká *vážený* průměr** je vidět, teprve když nejsou pravděpodobnosti stejné. Loterie s hlavní výhrou:

$$E(X) = \underbrace{1\,000\,000 \cdot 0{,}000001}_{\text{výhra}} + \underbrace{0 \cdot 0{,}999999}_{\text{prohra}} = 1 \text{ Kč}$$

Obyčejný průměr těch dvou hodnot by byl $500\,000$ Kč, což je zjevný nesmysl. **Pravděpodobnost jako váha je to podstatné.**

##### Co střední hodnota je a co není

- je to **vážený průměr** možných hodnot, kde vahami jsou pravděpodobnosti
- fyzikálně **těžiště** rozdělení — kdybys graf vyřízl z papíru, vyvážil by se přesně tam
- **nemusí být mezi možnými hodnotami**

> **Nejčastější nedorozumění:** střední hodnota **není nejčastější hodnota**. Kdyby ano, byl by to **modus**. U kostky padá každé číslo stejně často, takže žádná hodnota není častější — a přesto je $E(X) = 3{,}5$.
>
> Když hodíš kostkou $1200$krát, **graf četností bude plochý**, ne s kopcem u trojky a čtyřky:
>
> ```
>  četnost po 1200 hodech
>
>  200┤ ▌   ▌   ▌   ▌   ▌   ▌     všech šest zhruba stejně vysoko
>     │ ▌   ▌   ▌   ▌   ▌   ▌     (každé číslo asi 200x)
>    0└─┴───┴───┴───┴───┴───┴──
>      1   2   3   4   5   6
> ```
>
> **A právě proto vyjde průměr 3,5:**
>
> $$\frac{200(1+2+3+4+5+6)}{1200} = \frac{4200}{1200} = 3{,}5$$
>
> Trojka a čtyřka v tom nemají zvláštní roli — hodnota $3{,}5$ vzniká tím, že se **jedničky vyváží se šestkami, dvojky s pětkami a trojky se čtyřkami**. Kostka nemá paměť, každý hod je pořád $\frac{1}{6}$ na každé číslo. K $3{,}5$ se blíží **průměr**, ne jednotlivé hody.

##### Těžiště — obrázek, který to celé vysvětlí

Rozděl si čísla $1$ až $6$ po tyči a na každé pověs stejné závaží. **Kde tyč podepřít, aby se nepřevážila?**

```
   ●     ●     ●     ●     ●     ●        stejná závaží = stejné pravděpodobnosti
   1     2     3     4     5     6
               ▲
              3,5      <- podpěra tady, i když v tom místě NIC NELEŽÍ
```

Bod rovnováhy leží uprostřed mezi trojkou a čtyřkou — na místě, kde žádné závaží není. **To je přesně důvod, proč střední hodnota nemusí být mezi možnými hodnotami.**

A když se váhy změní, těžiště se posune k těžší straně:

```
   ●     ●     ●     ●     ●    ●●●       šestka je 3x pravděpodobnější
   1     2     3     4     5     6
                       ▲
                     4,12          <- těžiště se posunulo doprava
```

*(Spočítáno: $\frac{1+2+3+4+5+3\cdot 6}{8} = \frac{33}{8} = 4{,}125$ — váhy jsou $1,1,1,1,1,3$, dohromady $8$.)*

**V reálu tuhle vlastnost vidíš pořád:** *„průměrná domácnost má 1,4 dítěte"* — žádná domácnost nemá 1,4 dítěte. *„Průměrně 4,7 nehody denně"* — nikdy jich není 4,7. A ruleta níže dá $E(X) = -2{,}70$ Kč, přestože v jediné hře buď prohraješ stovku, nebo vyhraješ $3500$.

**Na kostce:**

$$E(X) = 1\cdot\tfrac{1}{6} + 2\cdot\tfrac{1}{6} + \dots + 6\cdot\tfrac{1}{6} = \frac{1+2+3+4+5+6}{6} = \frac{21}{6} = 3{,}5$$

**Trojka a půl na kostce nepadne nikdy** — a přesto je to správná střední hodnota. Znamená „při mnoha hodech vyjde průměr $3{,}5$", ne „tohle číslo padne".

**Na hazardu — ukázka, proč se to počítá:** ruleta má 37 čísel. Vsadím $100$ Kč na jedno číslo; při výhře dostanu $3600$ Kč, jinak nic. Náhodná veličina $X$ = můj zisk:

$$E(X) = \underbrace{3500 \cdot \tfrac{1}{37}}_{\text{výhra}} + \underbrace{(-100) \cdot \tfrac{36}{37}}_{\text{prohra}} = \frac{3500 - 3600}{37} = -\frac{100}{37} \doteq -2{,}70 \text{ Kč}$$

Na každé stovce prodělám v průměru $2{,}70$ Kč. **Tohle je typická úloha, kde střední hodnota rozhoduje** — a odpověď zní „nehrát".

Vlastnosti: $E(aX + b) = a\,E(X) + b$ a $E(X+Y) = E(X) + E(Y)$ (to platí **vždy**, i pro závislé veličiny).

**Dosazení:** dostanu-li za každé oko $10$ Kč plus $5$ Kč za účast, je můj průměrný výdělek $E(10X + 5) = 10 \cdot 3{,}5 + 5 = 40$ Kč. A součet ok na **dvou** kostkách má střední hodnotu $3{,}5 + 3{,}5 = 7$ — proto je sedmička na dvou kostkách ta nejčastější.

#### Rozptyl a směrodatná odchylka

$$D(X) = E\big[(X - E(X))^2\big] = \underbrace{E(X^2) - \big[E(X)\big]^2}_{\text{výpočetní tvar}}$$

$$\sigma = \sqrt{D(X)}$$

- měří, **jak jsou hodnoty rozptýlené** kolem střední hodnoty
- umocnění na druhou je tam proto, aby se **kladné a záporné odchylky nevyrušily** (a aby se velké odchylky trestaly víc)
- $D(aX+b) = a^2 D(X)$ — **posun rozptyl nemění**, roztažení ho mění kvadraticky

**Rozptyl je šířka, střední hodnota poloha.** Dvě rozdělení se stejným $E(X)$ můžou vypadat úplně jinak:

```
  MALÝ ROZPTYL                    VELKÝ ROZPTYL

 P│        ▌                     P│  ▌              ▌
  │        ▌                      │  ▌     ▌     ▌  ▌
  │     ▌  ▌  ▌                   │  ▌  ▌  ▌  ▌  ▌  ▌
  └──┴──┴──┴──┴──┴──▶             └──┴──┴──┴──┴──┴──▶
           ▲                                ▲
        E(X) = 50                       E(X) = 50

  hodnoty se tlačí u středu       hodnoty jsou rozházené
```

Střední hodnota ti řekne **kam** ukázat, rozptyl **jak moc si tím být jistý**. Bez rozptylu je průměr sám o sobě málo — tohle je věta, kterou u zkoušky vyslov.

**Proč se odchylky umocňují — ukázka na dvou třídách.** Obě mají průměr $50$ bodů:

| | známky | průměr | průměrná odchylka | rozptyl |
|---|---|---|---|---|
| třída A | $49, 50, 51$ | $50$ | $(-1 + 0 + 1)/3 = 0$ | $\frac{1+0+1}{3} = 0{,}67$ |
| třída B | $0, 50, 100$ | $50$ | $(-50 + 0 + 50)/3 = 0$ | $\frac{2500+0+2500}{3} = 1667$ |

**Obyčejný průměr odchylek vyjde v obou případech nula** — plusy a minusy se vyruší, takže nerozliší třídu, kde jsou všichni stejní, od třídy, kde je půlka propadlíků a půlka jedničkářů. Po umocnění je rozdíl obrovský: $0{,}67$ proti $1667$.

**Dosazení do vlastností:** přidám-li všem $10$ bodů zdarma, průměr stoupne na $60$, ale **rozptyl se nezmění** — všichni se posunuli stejně, vzájemné rozdíly zůstaly. Když ale body zdvojnásobím, rozptyl vzroste $2^2 = 4$krát.

> **Proč se kromě rozptylu zavádí ještě směrodatná odchylka:** rozptyl je ve **druhých mocninách jednotky**. Měříš-li výšku v centimetrech, vyjde rozptyl v $\text{cm}^2$, což nedává smysl interpretovat. Odmocněním se vrátíš k centimetrům, a proto se v praxi mluví o $\sigma$. **Tohle je oblíbená doptávka.**

#### Kvantily

**Kvantil $x_p$** je hodnota, pro kterou platí

$$F(x_p) = p$$

tedy „pod $x_p$ padne $100p$ procent hodnot". Speciální případy:

| Kvantil | Název |
|---|---|
| $x_{0{,}5}$ | **medián** — půlí rozdělení |
| $x_{0{,}25}$, $x_{0{,}75}$ | dolní a horní **kvartil** |
| $x_{0{,}1}, \dots, x_{0{,}9}$ | decily |

> **Kvantil je inverzní funkce k distribuční funkci.** $F$ jde z hodnoty na pravděpodobnost, kvantil z pravděpodobnosti zpátky na hodnotu. Odtud se to napojuje na [okruh 9](../09-intervaly-spolehlivosti/), kde se kvantily hledají v tabulkách.

**Na grafu** se kvantil čte takhle — jdi na svislé ose do výšky $p$, dojeď vodorovně ke křivce a spusť se dolů:

```
  F
 1,0┤                    ______
    │                  ╱
0,75┤- - - - - - - -╱ |          <- horní kvartil
    │             ╱   |
 0,5┤- - - - -  ╱     |          <- MEDIÁN
    │         ╱ |     |
0,25┤- - -  ╱   |     |          <- dolní kvartil
    │    ╱  |   |     |
   0┤__╱    |   |     |
    └───────┴───┴─────┴────────▶ x
          x0,25 x0,5  x0,75

  F:      z hodnoty  ->  pravděpodobnost   (doprava nahoru)
  kvantil: z pravděpodobnosti -> hodnotu   (zleva doprava dolů)
```

A na hustotě je kvantil místo, které **odkrojí plochu $p$ zleva**:

```
  f
   │      ___
   │    ╱███|  ╲
   │   ╱████|    ╲
   │  ╱█████|      ╲___
   └──┴─────┴───────────▶ x
           x0,25

   vyšrafovaná plocha = 0,25
```

**Ukázka z praxe, kde kvantil poráží průměr:** u serveru nikoho nezajímá průměrná doba odpovědi, ale $x_{0{,}99}$ — *„99 % požadavků se stihne do 200 ms"*. Průměr by mohl vypadat skvěle, i kdyby každý stý uživatel čekal deset vteřin. Tomuhle se v praxi říká **p99 latence**.

**Medián vs. střední hodnota:** u symetrického rozdělení splývají. U zešikmeného ne — a **medián je odolnější vůči odlehlým hodnotám**.

**Ukázka na platech**, protože právě tohle je důvod, proč se u nich uvádí medián. Devět lidí ve firmě bere (v tisících):

$$20,\ 22,\ 25,\ 25,\ \mathbf{28},\ 30,\ 32,\ 35,\ 40$$

- **medián** je prostřední hodnota, tedy $28$
- **průměr** je $\frac{257}{9} \doteq 28{,}6$ — skoro totéž

Teď přijde majitel s platem $1\,000$:

$$20,\ 22,\ 25,\ 25,\ \mathbf{28},\ 30,\ 32,\ 35,\ 40,\ 1000$$

- **medián** vyskočí jen na $29$ (průměr dvou prostředních, $28$ a $30$)
- **průměr** vyletí na $\frac{1257}{10} \doteq 125{,}7$

**Průměrný plat je najednou vyšší než plat devíti lidí z deseti.** Jedna odlehlá hodnota průměr rozhodila, mediánem sotva pohnula — a proto statistiky platů uvádějí medián.

---

### Vybraná rozdělení

#### Diskrétní

| Rozdělení | Kdy ho použiju | $E(X)$ | $D(X)$ |
|---|---|---|---|
| **alternativní** $A(p)$ | **jeden** pokus, úspěch/neúspěch | $p$ | $p(1-p)$ |
| **binomické** $Bi(n,p)$ | **$n$ nezávislých** pokusů, počítám úspěchy | $np$ | $np(1-p)$ |
| **Poissonovo** $Po(\lambda)$ | počet **vzácných událostí** za čas/plochu | $\lambda$ | $\lambda$ |
| **hypergeometrické** | výběr **bez vracení** | | |

$$P(X = k) = \binom{n}{k} p^k (1-p)^{n-k} \qquad \text{(binomické)}$$

Vzorec si přečti zleva doprava: $p^k$ je pravděpodobnost $k$ úspěchů, $(1-p)^{n-k}$ pravděpodobnost zbylých neúspěchů, a $\binom{n}{k}$ říká, **kolika způsoby můžou být ty úspěchy rozmístěné**.

**Dosazení — pětkrát hodím kostkou, jaká je šance na právě dvě šestky?** Úspěch je „padla šestka", tedy $p = \frac{1}{6}$, $n = 5$, $k = 2$:

$$P(X = 2) = \binom{5}{2}\left(\tfrac{1}{6}\right)^2\left(\tfrac{5}{6}\right)^3 = 10 \cdot \frac{1}{36} \cdot \frac{125}{216} \doteq 0{,}161$$

Tedy asi $16\ \%$. Ta desítka je $\binom{5}{2}$ — počet způsobů, jak vybrat, **které dva** z pěti hodů byly šestky. A střední počet šestek je $E(X) = np = 5 \cdot \frac{1}{6} \doteq 0{,}83$.

**A Poissonovo na tomtéž principu:** na centrálu přijde průměrně $\lambda = 5$ hovorů za hodinu; jaká je šance, že příští hodinu nepřijde ani jeden?

$$P(X = 0) = \frac{\lambda^k e^{-\lambda}}{k!} = \frac{5^0 e^{-5}}{0!} = e^{-5} \doteq 0{,}0067$$

Necelé $0{,}7\ \%$. **Všimni si, že nikde nevystupuje počet pokusů** — nevím, kolik lidí mohlo teoreticky zavolat, jen kolik jich průměrně volá. Přesně podle toho Poissonovo rozdělení poznáš.

> **Rozdíl, na který se ptají:** binomické je výběr **s vracením** (pravděpodobnost se mezi pokusy nemění), hypergeometrické **bez vracení**. Poissonovo je limitou binomického pro velké $n$ a malé $p$ — a poznáš ho podle toho, že **není dané, kolik bylo pokusů**, jen kolik událostí průměrně nastane („do centrály přijde průměrně 5 hovorů za hodinu").
>
> Že u Poissonova rozdělení vyjde $E(X) = D(X) = \lambda$, je jeho charakteristická vlastnost — stojí za to ji zmínit.

#### Spojitá

| Rozdělení | Kdy ho použiju | $E(X)$ |
|---|---|---|
| **rovnoměrné** $R(a,b)$ | všechny hodnoty stejně pravděpodobné | $\frac{a+b}{2}$ |
| **normální** $N(\mu, \sigma^2)$ | součet mnoha malých vlivů (výška, chyba měření) | $\mu$ |
| **exponenciální** $E(\lambda)$ | **doba čekání** na událost, životnost | $\frac{1}{\lambda}$ |

**Normální (Gaussovo) rozdělení** je nejdůležitější:

- hustota je symetrický **zvon** s vrcholem v $\mu$
- $\sigma$ určuje **šířku** — velká $\sigma$ dá nízký široký zvon, malá vysoký úzký
- **pravidlo 68–95–99,7:** v pásu $\mu \pm \sigma$ leží zhruba $68\ \%$ hodnot, v $\mu \pm 2\sigma$ asi $95\ \%$ a v $\mu \pm 3\sigma$ asi $99{,}7\ \%$

```
   f
   │        ___
   │      ╱  |  ╲
   │    ╱    |    ╲
   │  ╱      |      ╲
   └─┴───┴───┴───┴───┴──▶ x
   mu-2s  mu-s  mu  mu+s  mu+2s
       └── 68 % ──┘
   └────── 95 % ──────┘
```

**Standardizace** převede libovolné normální rozdělení na $N(0,1)$:

$$U = \frac{X - \mu}{\sigma}$$

Odečtu střed a vydělím šířkou — tím se zvon posune do nuly a roztáhne na jednotkovou šířku. **Proto stačí jediná tabulka** pro všechna normální rozdělení.

**Dosazení — výška mužů má $\mu = 180$ cm a $\sigma = 7$ cm. Kolik jich měří přes $194$ cm?**

$$U = \frac{194 - 180}{7} = \frac{14}{7} = 2$$

Sto devadesát čtyři centimetrů jsou tedy **dvě sigma nad průměrem**. Z pravidla $68$–$95$–$99{,}7$ víš, že v pásu $\mu \pm 2\sigma$ leží $95\ \%$ hodnot, takže mimo něj zbývá $5\ \%$ — a to je symetricky rozděleno na obě strany:

$$P(X > 194) \doteq \frac{5\ \%}{2} = 2{,}5\ \%$$

**Celý výpočet bez tabulek, jen z pravidla tří sigma.** Standardizace je to, co ho umožnila: převedla konkrétní centimetry na „kolik sigma od průměru", a v té řeči už odpověď znáš zpaměti.

Kontrolní intuice: $\mu \pm \sigma$ je $173$ až $187$ cm, kam spadnou zhruba dvě třetiny mužů. To sedí s realitou, takže jsi nepočítal nesmysl.

> **A tady se hezky vrací [okruh 5](../05-derivace-integraly-numerika/):** hustota normálního rozdělení obsahuje $e^{-x^2}$, jejíž **primitivní funkce v elementárním tvaru neexistuje**. Distribuční funkce se tedy nedá vyjádřit vzorcem a **musí se počítat numericky** — právě proto existují statistické tabulky. Když tohle řekneš, propojíš dva okruhy jednou větou.

#### Jak spolu souvisí — tady výklad graduje

```
       ALTERNATIVNÍ A(p)          jeden pokus
              │
              │  n nezávislých opakování
              ▼
        BINOMICKÉ Bi(n,p)
           ╱        ╲
 n velké, ╱          ╲  n velké, p prostřední
 p malé  ╱            ╲
        ▼              ▼
  POISSONOVO      NORMÁLNÍ N(mu, s^2)
    Po(np)          (centrální limitní věta)
```

> **Věta, kterou to uzavři:** „Ta rozdělení nejsou seznam k memorování, ale **jedna rodina**. Základem je jediný pokus s dvěma výsledky; jeho opakováním vznikne binomické, a to podle toho, kam se pošle limita, přejde buď v **Poissonovo** (hodně pokusů, ale úspěch vzácný), nebo v **normální**. A že se právě k normálnímu rozdělení sbíhá skoro všechno, říká **centrální limitní věta** — proto je normální rozdělení všude tam, kde se sčítá mnoho malých nezávislých vlivů."

---

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

- **Náhodná veličina** — zobrazení, které každému elementárnímu jevu z prostoru elementárních jevů přiřadí reálné číslo.
- **Diskrétní náhodná veličina** — náhodná veličina, která nabývá konečně nebo spočetně mnoha hodnot.
- **Spojitá náhodná veličina** — náhodná veličina, jejíž obor hodnot tvoří interval a jejíž distribuční funkce je spojitá.
- **Pravděpodobnostní funkce** — funkce přiřazující každé hodnotě diskrétní náhodné veličiny pravděpodobnost, že jí veličina nabude.
- **Hustota pravděpodobnosti** — nezáporná funkce, jejíž integrál přes daný interval udává pravděpodobnost, že veličina padne do tohoto intervalu; integrál přes celou reálnou osu je roven jedné.
- **Distribuční funkce** — funkce $F(x) = P(X \le x)$, tedy pravděpodobnost, že náhodná veličina nabude hodnoty nejvýše $x$.
- **Střední hodnota** — vážený průměr hodnot náhodné veličiny, kde vahami jsou příslušné pravděpodobnosti.
- **Rozptyl** — střední hodnota kvadrátu odchylky náhodné veličiny od její střední hodnoty, tedy $D(X) = E[(X - E(X))^2]$.
- **Směrodatná odchylka** — odmocnina z rozptylu; má stejnou jednotku jako náhodná veličina.
- **Kvantil $x_p$** — hodnota, pro kterou je $F(x_p) = p$, tedy hodnota, pod níž leží podíl $p$ všech hodnot.
- **Medián** — kvantil pro $p = 0{,}5$; hodnota půlící rozdělení.

---

### Příklad na papír

Dva příklady, jeden na každý druh veličiny. **První je hlavní** — je krátký, počítá se v hlavě a projde v něm celá otázka.

---

#### Příklad 1 — diskrétní veličina od začátku do konce

##### Zadání

Hodím **dvěma mincemi**. Náhodná veličina $X$ = počet orlů.

##### Krok 1: prostor jevů a rozdělení

Čtyři stejně pravděpodobné elementární jevy, každý s pravděpodobností $\frac{1}{4}$:

```
  RR -> X = 0        R = rub, O = orel
  RO -> X = 1
  OR -> X = 1
  OO -> X = 2
```

Dvojka padne jen jednou, jednička **dvakrát** — proto:

| $x$ | $0$ | $1$ | $2$ |
|---|---|---|---|
| $P(X=x)$ | $\frac{1}{4}$ | $\frac{2}{4}$ | $\frac{1}{4}$ |

Kontrola normalizace: $\frac{1}{4} + \frac{2}{4} + \frac{1}{4} = 1$ ✔

##### Krok 2: distribuční funkce — schody

$$F(x) = \begin{cases}
0 & x < 0\\
0{,}25 & 0 \le x < 1\\
0{,}75 & 1 \le x < 2\\
1 & x \ge 2
\end{cases}$$

```
  F
1,00┤              ┌────────
    │              │
0,75┤       ┌──────┘
    │       │
0,25┤ ┌─────┘
    │ │
   0┤─┘
    └─┴──────┴──────┴──────▶ x
      0      1      2

  výška skoku v bodě 1 je 0,5 = P(X = 1)
```

**Řekni k tomu:** výška každého skoku je přesně pravděpodobnost té hodnoty, a funkce je **spojitá zprava** — v bodě $1$ už má hodnotu $0{,}75$, ne $0{,}25$. Proto se v definici píše $P(X \le x)$ a ne $P(X < x)$.

##### Krok 3: střední hodnota

$$E(X) = 0\cdot\tfrac{1}{4} + 1\cdot\tfrac{2}{4} + 2\cdot\tfrac{1}{4} = 0 + 0{,}5 + 0{,}5 = 1$$

Sedí s intuicí: ze dvou mincí padne v průměru jeden orel. A sedí i s binomickým vzorcem, protože $X \sim Bi(2;\ 0{,}5)$, tedy $E = np = 2 \cdot 0{,}5 = 1$ ✔

##### Krok 4: rozptyl **výpočetním** tvarem

$$E(X^2) = 0^2\cdot\tfrac{1}{4} + 1^2\cdot\tfrac{2}{4} + 2^2\cdot\tfrac{1}{4} = 0 + 0{,}5 + 1 = 1{,}5$$

$$D(X) = E(X^2) - \big[E(X)\big]^2 = 1{,}5 - 1^2 = 0{,}5$$

$$\sigma = \sqrt{0{,}5} \doteq 0{,}707$$

Kontrola vzorcem pro binomické rozdělení: $np(1-p) = 2 \cdot 0{,}5 \cdot 0{,}5 = 0{,}5$ ✔

> **Ukaž, že to umíš i z definice**, když se zeptají: $D(X) = \sum (x_i - 1)^2 p_i = 1\cdot\frac{1}{4} + 0\cdot\frac{2}{4} + 1\cdot\frac{1}{4} = 0{,}5$. Stejný výsledek, ale u větších příkladů je výpočetní tvar rychlejší.

##### Krok 5: medián

Hledám nejmenší $x$ s $F(x) \ge 0{,}5$. Z tabulky: $F(0) = 0{,}25 < 0{,}5$, ale $F(1) = 0{,}75 \ge 0{,}5$, takže **medián je $1$**.

Tady splývá se střední hodnotou, protože rozdělení je **symetrické**.

---

#### Příklad 2 — spojitá veličina a past s hustotou

##### Zadání

Autobus jezdí přesně po $10$ minutách, přijdu na zastávku v náhodný okamžik. $X$ = doba čekání, tedy **rovnoměrné rozdělení** na $[0, 10]$.

##### Krok 1: hustota

Žádný okamžik není zvýhodněný, takže hustota je **konstantní** — a její výšku určí podmínka, že celková plocha musí být $1$:

$$f(x)\cdot 10 = 1 \quad \Rightarrow \quad f(x) = \frac{1}{10} = 0{,}1 \quad \text{pro } x \in [0,10]$$

```
  f
0,1┤ ┌──────────────┐
   │ │██████████████│      obdélník 10 x 0,1 = plocha 1
   │ │██████████████│
  0┤─┘              └───▶ x
     0             10
```

##### Krok 2: pravděpodobnost jako plocha

$$P(2 \le X \le 5) = \int_2^5 0{,}1\,\mathrm{d}x = 0{,}1 \cdot 3 = 0{,}3$$

Tady se **integrál smrskl na obsah obdélníku**, protože hustota je konstantní — a to je nejnázornější ukázka toho, že *pravděpodobnost = plocha pod hustotou*.

##### Krok 3: distribuční funkce

$$F(x) = \int_0^x 0{,}1\,\mathrm{d}t = 0{,}1x \quad \text{pro } x \in [0,10]$$

Tedy $0$ nalevo od nuly, **rostoucí přímka** mezi $0$ a $10$, a $1$ napravo. Kontrola derivací: $F^{\prime}(x) = 0{,}1 = f(x)$ ✔

##### Krok 4: charakteristiky

$$E(X) = \frac{a+b}{2} = \frac{0+10}{2} = 5 \text{ minut}$$

Medián: $F(x_{0{,}5}) = 0{,}5$, tedy $0{,}1x = 0{,}5$ a $x_{0{,}5} = 5$ — u symetrického rozdělení opět splývá se střední hodnotou.

##### Krok 5: past, kvůli které tenhle příklad je

**Kdyby autobus jezdil po půl minutě**, byl by interval $[0;\ 0{,}5]$ a hustota

$$f(x) = \frac{1}{0{,}5} = 2$$

**Hustota má hodnotu 2, tedy víc než 1** — a přesto je všechno v pořádku, protože plocha $2 \cdot 0{,}5 = 1$ sedí. **Hustota není pravděpodobnost**; pravděpodobností se stane teprve vynásobením šířkou.

A druhá past na téže úloze: $P(X = 5) = \int_5^5 f = 0$. Pravděpodobnost, že budu čekat **přesně** pět minut, je nulová — proto je u spojité veličiny jedno, jestli píšu $P(X < 5)$ nebo $P(X \le 5)$.

> **Věta, kterou celou otázku uzavři:** „Obě poloviny téhle otázky jsou tatáž úvaha, jen pro spočetně a nespočetně mnoho hodnot. U diskrétní veličiny má každá hodnota svou pravděpodobnost a já je **sčítám**; u spojité žádná jednotlivá hodnota pravděpodobnost nemá, a proto **integruji přes interval**. Distribuční funkce je pak ten jediný popis, který zvládne obojí — u jedné dělá schody, u druhé roste plynule, ale definice $P(X \le x)$ je stejná."

---

### Na co se doptají

- Co je to náhodná veličina? Uveď příklad diskrétní a spojité.
- **Proč může hustota pravděpodobnosti nabývat hodnot větších než 1?**
- Jaká je pravděpodobnost, že spojitá náhodná veličina nabude konkrétní hodnoty? A proč?
- Nakresli distribuční funkci diskrétní náhodné veličiny — jak vypadá?
- Jak z grafu distribuční funkce poznám, jestli je veličina diskrétní, nebo spojitá?
- Jaké vlastnosti má distribuční funkce?
- Jak spolu souvisí hustota a distribuční funkce?
- Proč se kromě rozptylu zavádí ještě směrodatná odchylka?
- Odvoď výpočetní tvar rozptylu $E(X^2) - [E(X)]^2$.
- Co se stane s rozptylem, když ke všem hodnotám přičtu konstantu? A když je vynásobím?
- Musí být střední hodnota jednou z možných hodnot veličiny?
- Kdy se liší medián a střední hodnota a proč se u platů uvádí medián?
- Kdy binomické rozdělení přechází v Poissonovo a kdy v normální?
- Jaký je rozdíl mezi binomickým a hypergeometrickým rozdělením?
- Co říká pravidlo 68–95–99,7?
- K čemu je standardizace $U = \frac{X-\mu}{\sigma}$?
- Proč se u normálního rozdělení používají tabulky a nepočítá se integrál?

### Užitečné odkazy

- <https://seeing-theory.brown.edu/> (interaktivní vizualizace celé pravděpodobnosti — nejlepší, co k tomuhle tématu je)
- <https://www.geogebra.org/probability> (kalkulátor rozdělení s grafem)
- <https://en.wikipedia.org/wiki/Probability_density_function>
- `/home/valdemar/Dokumenty/SZZ/01 - SZZTP - 15m ústní/08/` — zpracování od kamaráda; má obrázky k pravděpodobnostní funkci, hustotě a příklad s kostkou
