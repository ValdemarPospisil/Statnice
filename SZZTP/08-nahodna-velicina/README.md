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

- je to **vážený průměr** možných hodnot, kde vahami jsou pravděpodobnosti
- fyzikálně **těžiště** rozdělení — kdybys graf vyřízl z papíru, vyvážil by se přesně tam
- **nemusí být mezi možnými hodnotami**: střední počet ok na kostce je $3{,}5$, což na kostce nepadne nikdy

Vlastnosti: $E(aX + b) = a\,E(X) + b$ a $E(X+Y) = E(X) + E(Y)$ (to platí **vždy**, i pro závislé veličiny).

#### Rozptyl a směrodatná odchylka

$$D(X) = E\big[(X - E(X))^2\big] = \underbrace{E(X^2) - \big[E(X)\big]^2}_{\text{výpočetní tvar}}$$

$$\sigma = \sqrt{D(X)}$$

- měří, **jak jsou hodnoty rozptýlené** kolem střední hodnoty
- umocnění na druhou je tam proto, aby se **kladné a záporné odchylky nevyrušily** (a aby se velké odchylky trestaly víc)
- $D(aX+b) = a^2 D(X)$ — **posun rozptyl nemění**, roztažení ho mění kvadraticky

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

**Medián vs. střední hodnota:** u symetrického rozdělení splývají. U zešikmeného ne — a **medián je odolnější vůči odlehlým hodnotám**. Proto se u platů uvádí medián: pár miliardářů zvedne průměr, ale mediánem nehnou.

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
