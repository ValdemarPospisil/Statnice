## 5 — Diferenciální a integrální počet, numerické derivování a integrace

> Diferenciální a integrální počet funkcí jedné proměnné (definice derivace funkce a její geometrický význam, primitivní funkce, určitý integrál a jeho geometrický význam), numerické derivování a integrace (obdélníkové, lichoběžníkové a Simpsonovo pravidlo), aplikace (určení lokálního extrému, navazování křivek, objem rotačního tělesa)

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. **Derivace** — definice jako limita diferenčního podílu; proč tam ta limita musí být
2. **Geometrický význam** — směrnice tečny; odtud rovnice tečny
3. Základní vzorce a pravidla (součin, podíl, složená funkce) — jen prolétnout
4. **Numerické derivování** — dopředná, zpětná, **centrální** diference; řády chyby a past s příliš malým $h$
5. **Primitivní funkce** — $F^{\prime} = f$, dvě se liší jen o konstantu, neurčitý integrál
6. Proč se integruje numericky: **ne každá funkce má elementární primitivní funkci** (a data často známe jen v bodech)
7. **Určitý integrál** — limita Riemannových součtů, geometrický význam jako **znaménkový** obsah
8. **Newtonova–Leibnizova formule** — most mezi derivací a integrálem
9. **Obdélníkové pravidlo** — nahradím schody; varianta se středem je výrazně lepší
10. **Lichoběžníkové pravidlo** — nahradím lomenou čarou
11. **Simpsonovo pravidlo** — nahradím parabolami; odkud se berou váhy 1 : 4 : 1 a proč je přesné až do 3. stupně
12. Srovnání řádů chyby $O(h)$, $O(h^2)$, $O(h^4)$ — co se stane, když zjemním dvakrát
13. **Aplikace:** lokální extrém, navazování křivek, objem rotačního tělesa — tady výklad graduje

**Nit, na kterou to navlékni:** obě poloviny téhle otázky dělají **jednu a tutéž věc — nahradí funkci na malém kousku něčím, co spočítat umím**. Derivace nahradí křivku **přímkou** (tečnou) a pošle délku toho kousku k nule. Integrál nakrájí plochu na **proužky** a pošle jejich šířku k nule. V obou případech je výsledek přesný právě díky té limitě. **A numerika není nic jiného než totéž, jen se před limitou zastavíš:** místo $h \to 0$ vezmeš konkrétní malé $h$, místo nekonečně mnoha proužků konečně mnoho. Jediné, čím se numerické metody mezi sebou liší, je **čím ten kousek nahradí** — obdélníkem, úsečkou, nebo parabolou — a čím lepší ta náhrada je, tím rychleji chyba klesá se zjemňováním.

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tahák, který si vyrobíš zpaměti hned na začátku přípravy. Napsání zabere zhruba tři minuty, zbylých dvanáct pak máš na rozmyšlení příkladu.

```
DERIVACE   f'(x) = lim h->0  [ f(x+h) - f(x) ] / h
  = SMĚRNICE TEČNY v bodě   ->  tečna:  y = f(x0) + f'(x0)*(x - x0)
  (x^n)' = n*x^(n-1) | (e^x)' = e^x | (ln x)' = 1/x
  (sin)' = cos | (cos)' = -sin
  součin (uv)' = u'v + uv'      podíl (u/v)' = (u'v - uv')/v^2
  složená [f(g(x))]' = f'(g(x)) * g'(x)

NUMERICKÉ DERIVOVÁNÍ  (nedělám limitu, beru konkrétní malé h)
  dopředná   [f(x+h) - f(x)] / h        chyba O(h)
  zpětná     [f(x) - f(x-h)] / h        chyba O(h)
  centrální  [f(x+h) - f(x-h)] / (2h)   chyba O(h^2)
  PAST: moc malé h = odčítám skoro stejná čísla = ztráta přesnosti

PRIMITIVNÍ FUNKCE  F'(x) = f(x);  dvě se liší jen o konstantu -> + C
  ne každá elementární funkce má elementární primitivní: e^(-x^2), sin(x)/x
  ^^^ PROTO vůbec existuje numerická integrace

URČITÝ INTEGRÁL = limita Riemannových součtů = ZNAMÉNKOVÝ obsah
  NEWTON-LEIBNIZ:   integral od a do b z f  =  F(b) - F(a)
  PAST: pod osou se počítá ZÁPORNĚ
        integral sin od 0 do 2pi = 0,  ale OBSAH = 4

NUMERICKÁ INTEGRACE   h = (b-a)/n,  uzly x0, x1, ..., xn
  obdélníkové     h * suma f(x_i)                       O(h),  střed O(h^2)
  lichoběžníkové  h/2 * [ f0 + 2*(f1+...+f_n-1) + fn ]  O(h^2)
  Simpsonovo      h/3 * [ f0 + 4*liché + 2*sudé + fn ]  O(h^4),  n SUDÉ
  přesné pro polynomy do stupně:  obdélník 0 (střed 1) | lichoběž. 1 | Simpson 3

APLIKACE
  lokální extrém: f'(x) = 0 -> stacionární bod
                  f'' > 0 minimum, f'' < 0 maximum
                  f' = 0 NESTAČÍ (x^3 v nule má f'=0 a extrém tam není)
  navazování:  C0 stejná hodnota | C1 stejná tečna | C2 stejná křivost
  objem rotačního tělesa:  V = pi * integral od a do b z f(x)^2 dx

PŘÍKLAD A (derivace)  f(x) = x^2 v bodě 3,  h = 0,1
  f(2,9) = 8,41   f(3) = 9   f(3,1) = 9,61
  dopředná 6,1 | zpětná 5,9 | centrální 6,0 | přesně f'(3) = 6

PŘÍKLAD B (integrace)  integral od 1 do 2 z dx/x  =  ln 2  =  0,6931
  f(1) = 1     f(1,5) = 0,6667     f(2) = 0,5
  obdélník(střed) 0,6667 | lichoběžník 0,75 | Simpson 0,6944

PŘÍKLAD C (aplikace)  koule z f(x) = odmocnina(r^2 - x^2) na <-r, r>
  V = pi * integral (r^2 - x^2) dx = 4/3 * pi * r^3
```

#### Jak si z toho odvodit zbytek

- **Centrální diferenci si nepamatuj.** Je to prostě **průměr dopředné a zpětné**: sečti je, vyděl dvěma, a $f(x)$ se vykrátí. Zůstane $\frac{f(x+h) - f(x-h)}{2h}$. A rovnou z toho vidíš, **proč je přesnější**: jedna se plete nahoru, druhá stejně dolů, a v průměru se to vyruší.
- **Simpsonovy váhy $1 : 4 : 1$ taky ne.** Simpsonovo pravidlo je vážený průměr obdélníkového (se středem) a lichoběžníkového v poměru $2 : 1$ — protože **jejich chyby mají opačné znaménko a lichoběžník se plete zhruba dvakrát víc**. Když si to napíšeš, váhy $1, 4, 1$ z toho vypadnou samy (viz [Příklad 2](#příklad-2--tři-pravidla-na-jednom-integrálu)).
- **Rovnice tečny je jen dosazení do směrnicového tvaru přímky.** Přímka procházející bodem $[x_0, y_0]$ se směrnicí $k$ je $y = y_0 + k(x - x_0)$; sem dosaď $y_0 = f(x_0)$ a $k = f^{\prime}(x_0)$.
- **Koeficient 2 v lichoběžníkovém pravidle** není magie: obsah jednoho lichoběžníku je $\frac{f_{i} + f_{i+1}}{2}\cdot h$, a když je sečteš, **každý vnitřní uzel se objeví ve dvou lichoběžnících** — jednou zprava, jednou zleva. Krajní jen v jednom, proto mají koeficient 1.
- **Vzorec pro objem rotačního tělesa** odvoď nahlas: těleso nakrájím kolmo na osu na tenké **disky**. Disk v místě $x$ má poloměr $f(x)$, tedy obsah $\pi f(x)^2$, a tloušťku $\mathrm{d}x$. Sečti je integrálem a máš $V = \pi\int_a^b f(x)^2\,\mathrm{d}x$.

#### Jak si to zapamatovat, aniž bys to biflil

> **Derivace nahradí křivku přímkou. Integrál ji nakrájí na proužky. Numerika obojí zastaví kousek před limitou.**

Celá tabulka metod je jen odpověď na otázku **„čím ten kousek nahradím"**:

| Nahradím kousek | Metoda | Přesné pro polynomy do stupně | Chyba |
|---|---|---|---|
| **vodorovnou úsečkou** (schod) | obdélníkové | $0$ (se středem $1$) | $O(h)$, se středem $O(h^2)$ |
| **šikmou úsečkou** | lichoběžníkové | $1$ | $O(h^2)$ |
| **parabolou** | Simpsonovo | **$3$** | $O(h^4)$ |

Zapamatuj si jen ten prostřední sloupec a **řády chyb z něj plynou**: čím vyšší stupeň polynomu metoda zvládne přesně, tím rychleji klesá chyba. A ten překvapivý řádek je Simpson — **prokládá parabolu, tedy stupeň 2, ale integruje přesně i kubiky**. To je otázka, kterou zkoušející rád položí (odpověď je v [Příkladu 2](#příklad-2--tři-pravidla-na-jednom-integrálu)).

##### Kde to navazuje na ostatní okruhy

| Co tady | Kde to už bylo | Jak to spolu souvisí |
|---|---|---|
| tečna a její směrnice | Newtonova metoda, [okruh 4](../04-funkce-polynomy-nelinearni-rovnice/) | Newton **je** aplikace derivace — nahradí funkci tečnou a hledá její kořen |
| „nahraď něčím jednoduchým" | půlení i Newton, [okruh 4](../04-funkce-polynomy-nelinearni-rovnice/) | tentýž princip celé numeriky |
| limita, spojitost | [okruh 4](../04-funkce-polynomy-nelinearni-rovnice/) | derivace i integrál jsou **definované limitou** |
| $O(h)$, $O(h^2)$, $O(h^4)$ | asymptotická notace, [okruh 11](../11-rekurence-asymptotika/) | tentýž zápis, jen se tu $h$ blíží k nule místo $n$ k nekonečnu |
| zjemním dvakrát → chyba $/16$ | mocniny a logaritmy, [okruh 11](../11-rekurence-asymptotika/) | $O(h^4)$ znamená, že půlení $h$ dělí chybu šestnácti |
| Riemannův součet | sumy, [okruh 2](../02-algoritmy-nad-seznamy/) | integrál je limita součtu — na papíře to je cyklus |
| navazování křivek | křivky a splajny, [MPG](../../SZZPP/11-multimedia-a-pocitacova-grafika/) | $C^1$ a $C^2$ spojitost je základ Bézierových křivek |

---

### Derivace

#### Definice

**Derivace funkce $f$ v bodě $x$** je limita **diferenčního podílu**:

$$f^{\prime}(x) = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$$

Funkce je v bodě **derivovatelná**, pokud tahle limita existuje a je vlastní (konečná).

> **Proč tam ta limita musí být:** samotný zlomek $\frac{f(x+h)-f(x)}{h}$ je **průměrná změna** na úseku délky $h$ — třeba průměrná rychlost. Kdybys chtěl změnu v jediném okamžiku, dosadil bys $h = 0$ a dostal $\frac{0}{0}$, což nedává smysl. **Limita je způsob, jak se k tomu okamžiku přiblížit, aniž bys do něj vstoupil** — přesně jako v [okruhu 4](../04-funkce-polynomy-nelinearni-rovnice/), kde v definici limity stojí $0 < \lvert x - a \rvert$.

#### Geometrický význam

Zlomek $\frac{f(x+h)-f(x)}{h}$ je **směrnice sečny** procházející body $[x, f(x)]$ a $[x+h, f(x+h)]$. Když $h$ pošlu k nule, druhý bod se přisune k prvnímu a **sečna přejde v tečnu**:

```
   f
   │                    ● [x+h, f(x+h)]
   │                 ╱
   │      sečna   ╱ │
   │           ╱    │  f(x+h) - f(x)
   │        ╱       │
   │     ●──────────┘
   │  [x, f(x)]  h
   └────────────────────────▶ x

   h -> 0:  druhý bod se přisune  ->  ze SEČNY se stane TEČNA
            ze směrnice sečny se stane f'(x)
```

$$f^{\prime}(x_0) = \text{směrnice tečny ke grafu v bodě } [x_0, f(x_0)]$$

A odtud rovnice tečny — je to jen přímka daným bodem s danou směrnicí:

$$y = f(x_0) + f^{\prime}(x_0)\,(x - x_0)$$

> **Fyzikální čtení, které se hodí zmínit:** derivace dráhy podle času je **rychlost**, derivace rychlosti je **zrychlení**. Derivace obecně odpovídá na otázku *„jak rychle se to mění"*.

#### Vzorce a pravidla, které musíš mít v ruce

| Funkce | Derivace |
|---|---|
| $c$ (konstanta) | $0$ |
| $x^n$ | $n\,x^{n-1}$ |
| $e^x$ | $e^x$ |
| $\ln x$ | $\frac{1}{x}$ |
| $\sin x$ | $\cos x$ |
| $\cos x$ | $-\sin x$ |

| Pravidlo | Vzorec |
|---|---|
| součet | $(u + v)^{\prime} = u^{\prime} + v^{\prime}$ |
| konstanta | $(c\,u)^{\prime} = c\,u^{\prime}$ |
| **součin** | $(uv)^{\prime} = u^{\prime}v + uv^{\prime}$ |
| **podíl** | $\left(\frac{u}{v}\right)^{\prime} = \frac{u^{\prime}v - uv^{\prime}}{v^2}$ |
| **složená funkce** | $\big[f(g(x))\big]^{\prime} = f^{\prime}(g(x)) \cdot g^{\prime}(x)$ |

> **Souvislost, na kterou se ptají:** má-li funkce v bodě derivaci, je tam **spojitá**. Obráceně to **neplatí** — $\lvert x \rvert$ je v nule spojitá, ale derivaci tam nemá, protože zleva vychází $-1$ a zprava $+1$. **Špička na grafu = spojitost bez derivace.**

---

### Numerické derivování

Když derivaci neumím spočítat vzorcem (funkce je zadaná jen naměřenými hodnotami, nebo je předpis příliš složitý), **zastavím se před limitou** a vezmu konkrétní malé $h$:

| Vzorec | Název | Chyba |
|---|---|---|
| $\dfrac{f(x+h) - f(x)}{h}$ | **dopředná** diference | $O(h)$ |
| $\dfrac{f(x) - f(x-h)}{h}$ | **zpětná** diference | $O(h)$ |
| $\dfrac{f(x+h) - f(x-h)}{2h}$ | **centrální** diference | $O(h^2)$ |

**Centrální diference je průměr těch dvou jednostranných** — sečti je a vyděl dvěma, $f(x)$ se vykrátí. A právě proto je přesnější: jednostranné se pletou na **opačné strany** a v průměru se ta chyba do značné míry vyruší.

```
        ╱● f(x+h)              dopředná: měřím sklon dopředu
   ●───╱      ← tečna          zpětná:   měřím sklon dozadu
  ╱ f(x)                       centrální: proložím oba krajní body
 ● f(x-h)                                 -> lépe kopíruje tečnu
```

> **Past, kterou musíš znát a která zkoušejícího potěší:** intuice říká „čím menší $h$, tím lépe" — a **u počítače to neplatí**. Celková chyba má dvě složky, které jdou proti sobě: chyba **z useknutí limity** klesá s $h$, ale chyba **ze zaokrouhlení** roste, protože v čitateli odčítám dvě téměř stejná čísla a ztrácím platné číslice. Existuje tedy **optimální $h$**, které je zhruba odmocnina ze strojové přesnosti — pro `double` řádově $10^{-8}$. Pod ním výsledek začne být **horší**, ne lepší.

---

### Primitivní funkce a neurčitý integrál

**Funkce $F$ je primitivní funkcí k $f$ na intervalu $I$**, pokud pro všechna $x \in I$ platí

$$F^{\prime}(x) = f(x)$$

Je to tedy **obrácená otázka k derivaci**: neptám se „jak rychle se to mění", ale „co se muselo měnit takhle".

Dvě primitivní funkce k téže funkci se liší **jen o konstantu** (protože derivace konstanty je nula), a proto se **neurčitý integrál** — množina všech primitivních funkcí — píše s $+\,C$:

$$\int f(x)\,\mathrm{d}x = F(x) + C$$

| Funkce | Primitivní funkce |
|---|---|
| $x^n$, $n \ne -1$ | $\frac{x^{n+1}}{n+1}$ |
| $\frac{1}{x}$ | $\ln \lvert x \rvert$ |
| $e^x$ | $e^x$ |
| $\sin x$ | $-\cos x$ |
| $\cos x$ | $\sin x$ |

Základní techniky jsou **substituce** (obrácené pravidlo o složené funkci) a **integrace per partes** (obrácené pravidlo o součinu) — stačí je umět pojmenovat a říct, z čeho vznikly.

> **Tohle je klíčová věta celé druhé poloviny otázky:** zatímco derivovat se dá **každá** elementární funkce mechanicky podle pravidel, **integrovat ne**. Existují docela nevinně vypadající funkce, jejichž primitivní funkce **není elementární** — třeba $e^{-x^2}$ (Gaussova křivka, [okruh 8](../08-nahodna-velicina/)!) nebo $\frac{\sin x}{x}$. Není to tak, že bychom je neuměli najít — ony **neexistují** v elementárním tvaru. **A přesně proto existuje numerická integrace.** Je to stejný typ argumentu jako Abelova–Ruffiniho věta u [okruhu 4](../04-funkce-polynomy-nelinearni-rovnice/): numerika není nouzovka, ale jediná cesta.

Druhý důvod je praktičtější: **často žádný předpis nemáš**, jen naměřené hodnoty v několika bodech. Vzorec se pak použít nedá, numerická metoda ano.

---

### Určitý integrál

#### Definice a geometrický význam

**Určitý integrál** vznikne tak, že interval $[a,b]$ rozdělím na dílky, v každém vezmu obdélník o výšce funkční hodnoty, obsahy sečtu (to je **Riemannův součet**) a nechám šířku dílků jít k nule:

$$\int_a^b f(x)\,\mathrm{d}x = \lim_{\Delta x \to 0} \sum_{i=1}^{n} f(\xi_i)\,\Delta x_i$$

**Geometrický význam: obsah plochy mezi grafem a osou $x$.**

```
   f
   │     ___
   │   ╱█|█|█╲___
   │  ╱█|█|█|█|█╲
   │ ╱█|█|█|█|█|█╲
   └─┴──┴─┴─┴─┴──┴────▶ x
     a              b

   sečti obdélníky, pošli jejich šířku k nule -> přesný obsah
```

> **Past, na které se padá nejčastěji:** integrál je **znaménkový** obsah — část grafu **pod osou** se počítá **záporně**. Proto $\int_0^{2\pi} \sin x\,\mathrm{d}x = 0$, ačkoli plocha mezi sinusovkou a osou je $4$. Když chceš skutečný obsah, musíš integrovat $\lvert f(x) \rvert$, tedy rozdělit integrál v průsečících s osou a záporné části otočit. **Tohle si nachystej — je to oblíbená doptávka.**

#### Newtonova–Leibnizova formule

Most mezi oběma polovinami otázky:

$$\int_a^b f(x)\,\mathrm{d}x = \big[F(x)\big]_a^b = F(b) - F(a), \qquad \text{kde } F^{\prime} = f$$

Říká, že **integrování a derivování jsou navzájem opačné operace** — a proto se určitý integrál dá počítat bez jakéhokoli sečítání obdélníků, stačí najít primitivní funkci a dosadit meze. Tomuhle se říká **základní věta integrálního počtu** a je to jedna z nejdůležitějších vět matematické analýzy.

#### Vlastnosti, které se hodí umět

- **linearita:** $\int (\alpha f + \beta g) = \alpha \int f + \beta \int g$
- **aditivita v mezích:** $\int_a^c = \int_a^b + \int_b^c$
- $\int_a^a f = 0$ a prohození mezí otočí znaménko: $\int_b^a f = -\int_a^b f$

---

### Numerická integrace

Společný rámec: interval $[a,b]$ rozdělím na $n$ stejných dílků

$$h = \frac{b-a}{n}, \qquad x_i = a + i\,h$$

a **v každém dílku nahradím funkci něčím, co zintegrovat umím**. Metody se liší jen tou náhradou.

#### Obdélníkové pravidlo

Každý dílek nahradím **obdélníkem** — funkci v něm považuji za konstantní:

$$\int_a^b f(x)\,\mathrm{d}x \approx h \sum_{i} f(x_i)$$

Podle toho, odkud beru výšku, jde o pravidlo **levé**, **pravé** nebo **se středem**:

```
  levé            se středem          pravé
   ┌──            ──┬──                 ──┐
   │  ╲╱           │   ╲╱               ╱ │
   │              │                    │
```

> **Varianta se středem je výrazně lepší** a stojí úplně stejně: obdélník sice funkci vlevo podstřelí, ale vpravo ji o zhruba tolik přestřelí, a chyby se vyruší. Proto je přesná i pro **lineární** funkce a její chyba je $O(h^2)$ místo $O(h)$. Když se ptají „která varianta a proč", tohle je odpověď.

#### Lichoběžníkové pravidlo

Sousední body spojím **úsečkou** — křivku nahradím lomenou čarou:

$$\int_a^b f(x)\,\mathrm{d}x \approx \frac{h}{2}\Big[ f(x_0) + 2\big(f(x_1) + \dots + f(x_{n-1})\big) + f(x_n) \Big]$$

**Ta dvojka u vnitřních uzlů není magie:** obsah jednoho lichoběžníku je $\frac{f_i + f_{i+1}}{2}h$, a při sečítání se **každý vnitřní uzel objeví ve dvou sousedních lichoběžnících** — jednou jako pravý, jednou jako levý okraj. Krajní uzly jen v jednom.

Chyba je $O(h^2)$ a pravidlo je přesné pro **lineární** funkce (úsečku nahradí úsečkou, tedy přesně).

#### Simpsonovo pravidlo

Vezmu **dva sousední dílky naráz** a proložím jejich třemi body **parabolu**:

$$\int_a^b f(x)\,\mathrm{d}x \approx \frac{h}{3}\Big[ f(x_0) + 4\!\!\sum_{i \text{ liché}}\!\! f(x_i) + 2\!\!\sum_{i \text{ sudé}}\!\! f(x_i) + f(x_n) \Big]$$

Proto **$n$ musí být sudé** — dílky se berou po dvojicích.

**Odkud se berou váhy $1 : 4 : 1$:** Simpson je **vážený průměr obdélníkového pravidla se středem a lichoběžníkového** v poměru $2 : 1$:

$$S = \frac{2M + T}{3}$$

Ty dvě metody se totiž pletou **na opačné strany** a lichoběžník se plete **zhruba dvakrát víc**, takže jejich vhodná kombinace chyby vyruší. Když si to rozepíšeš, váhy $1, 4, 1$ vypadnou samy — ukážu to v [Příkladu 2](#příklad-2--tři-pravidla-na-jednom-integrálu).

> **Otázka, která přijde skoro jistě:** *„Proč je Simpsonovo pravidlo přesné pro polynomy až do třetího stupně, když prokládá jen parabolu?"* Protože jeho **chybový člen obsahuje čtvrtou derivaci** — a ta je u polynomu do třetího stupně **identicky nulová**. Kubická odchylka od paraboly je na dvojici dílků **lichá vzhledem k jejich středu**, takže se na levé a pravé půlce vyruší. Je to pěkný důkaz „z rozboru symetrie" a stojí za to ho umět říct.

#### Srovnání — tady výklad graduje

| Pravidlo | Čím nahradí kousek | Přesné do stupně | Chyba |
|---|---|---|---|
| obdélníkové (levé/pravé) | vodorovnou úsečkou | $0$ | $O(h)$ |
| obdélníkové (se středem) | vodorovnou úsečkou uprostřed | $1$ | $O(h^2)$ |
| lichoběžníkové | šikmou úsečkou | $1$ | $O(h^2)$ |
| **Simpsonovo** | **parabolou** | **$3$** | $O(h^4)$ |

**Co ty řády prakticky znamenají** — zjemním-li dvakrát (tedy $h \to \frac{h}{2}$):

| Chyba | Zjemním dvakrát | Zjemním desetkrát |
|---|---|---|
| $O(h)$ | klesne **2×** | 10× |
| $O(h^2)$ | klesne **4×** | 100× |
| $O(h^4)$ | klesne **16×** | **10 000×** |

> **Věta, kterou to shrň:** „Všechna tři pravidla dělají totéž — rozkrájejí plochu a každý kousek nahradí něčím jednoduchým. Liší se jen tím, **jak dobrou náhradu zvolí**: obdélník ignoruje sklon, lichoběžník sklon zachytí, parabola zachytí i zakřivení. A protože každá lepší náhrada zvedne řád chyby, **vyplatí se spíš zvolit lepší pravidlo než počítat víc dílků**: Simpson s deseti uzly bývá přesnější než obdélníkové pravidlo s tisícem."

```python
def lichobeznik(f, a, b, n):
    h = (b - a) / n
    s = (f(a) + f(b)) / 2
    for i in range(1, n):
        s += f(a + i * h)
    return s * h


def simpson(f, a, b, n):
    if n % 2 != 0:
        raise ValueError("n musí být sudé")
    h = (b - a) / n
    s = f(a) + f(b)
    for i in range(1, n):
        s += (4 if i % 2 else 2) * f(a + i * h)
    return s * h / 3
```

---

### Aplikace

#### Určení lokálního extrému

1. Spočítám $f^{\prime}(x)$ a vyřeším $f^{\prime}(x) = 0$ — řešení jsou **stacionární body**
2. Rozhodnu, o co jde, jedním ze dvou způsobů:

| Test | Jak | Závěr |
|---|---|---|
| **druhou derivací** | dosadím stacionární bod do $f^{\prime\prime}$ | $f^{\prime\prime} > 0$ → **minimum**, $f^{\prime\prime} < 0$ → **maximum** |
| **znaménkem první derivace** | podívám se, jak $f^{\prime}$ mění znaménko | $+ \to -$ → maximum, $- \to +$ → minimum |

**Proč to funguje:** $f^{\prime} = 0$ znamená **vodorovnou tečnu**. A $f^{\prime\prime}$ je derivace derivace, tedy „jak se mění sklon" — kladná druhá derivace znamená, že sklon roste (z klesání do stoupání), a to je důlek.

> **Past:** $f^{\prime}(x) = 0$ je podmínka **nutná, ne postačující**. U $f(x) = x^3$ je $f^{\prime}(0) = 0$ **i** $f^{\prime\prime}(0) = 0$, ale extrém tam **není** — jde o **inflexní bod**, funkce jen na okamžik zvolní a pokračuje nahoru. Když druhá derivace vyjde nula, musíš rozhodnout znaménkem první derivace.
>
> A druhá past: **na uzavřeném intervalu se maximum může nacházet i v krajním bodě**, kde derivace nulová být nemusí. Globální extrém tedy hledáš mezi stacionárními body **a** krajními body.

#### Navazování křivek

Když skládám křivku z více kousků (splajn, dráha animace, obrys písmene, trasa silnice), musí na sebe kousky **hladce navazovat**. Míra hladkosti se značí $C^k$ a **je definovaná derivacemi**:

| Třída | Podmínka v bodě napojení | Jak to vypadá |
|---|---|---|
| $C^0$ | shodné **funkční hodnoty** | křivka je souvislá, ale může mít **zlom** |
| $C^1$ | shodné i **první derivace** | shodná **tečna** — žádný zlom, hladké |
| $C^2$ | shodné i **druhé derivace** | shodná **křivost** — plynulé i na pohled |

```
   C0                  C1                  C2
     ╱                    ╱                   ╱
   ╱                 ___╱                ___╱
  │                 ╱                 ╱
  zlom            hladké,         hladké i v křivosti
                  ale mění se
                  zakřivení
```

**Konkrétně:** chci na parabolu $f(x) = x^2$ navázat v bodě $x = 1$ přímku $g(x) = ax + b$ tak, aby napojení bylo $C^1$:

- $C^0$: $g(1) = f(1) = 1$
- $C^1$: $g^{\prime}(1) = f^{\prime}(1) = 2$, tedy $a = 2$
- z první podmínky pak $2 + b = 1$, tedy $b = -1$

$$g(x) = 2x - 1$$

**A to je přesně tečna paraboly v bodě $[1,1]$** — což je hezké uzavření kruhu: $C^1$ navázání přímkou **není nic jiného než tečna**.

> **Kde to potkáš v praxi:** Bézierovy křivky a splajny v grafice a v CADu ([MPG](../../SZZPP/11-multimedia-a-pocitacova-grafika/)), návrh silnic a železnic (skok v křivosti = ráz do cestujících), interpolace dat, animační křivky. Skoro všude se vyžaduje aspoň $C^1$, u dopravních staveb $C^2$.

#### Objem rotačního tělesa

Nechám graf funkce $f$ na intervalu $[a,b]$ **rotovat kolem osy $x$**. Vzniklé těleso nakrájím kolmo na osu na tenké **disky**:

- disk v místě $x$ má poloměr $f(x)$, tedy obsah $\pi f(x)^2$
- jeho tloušťka je $\mathrm{d}x$, objem tedy $\pi f(x)^2 \,\mathrm{d}x$
- sečtu je integrálem:

$$V = \pi \int_a^b \big[f(x)\big]^2 \,\mathrm{d}x$$

```
        f(x)
    ────────────╮        rotací kolem osy x
   │    ╭───╮   │        vznikne těleso;
   ├────┼───┼───┤ ← disk poloměru f(x)
   │    ╰───╯   │        a tloušťky dx
    ────────────╯
   a            b
```

**Kužel** ($f(x) = \frac{r}{h}x$ na $[0,h]$):

$$V = \pi \int_0^h \frac{r^2}{h^2}x^2\,\mathrm{d}x = \pi\frac{r^2}{h^2}\cdot\frac{h^3}{3} = \frac{1}{3}\pi r^2 h \quad \checkmark$$

Další aplikace určitého integrálu, které stačí vyjmenovat: **délka křivky**, **práce** vykonaná proměnnou silou, **těžiště**, střední hodnota funkce, a v [okruhu 8](../08-nahodna-velicina/) **pravděpodobnost jako integrál z hustoty**.

---

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

- **Derivace funkce v bodě** — limita diferenčního podílu $\lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$, pokud existuje a je konečná.
- **Geometrický význam derivace** — derivace v bodě je směrnice tečny ke grafu funkce v tomto bodě.
- **Tečna** — přímka procházející bodem $[x_0, f(x_0)]$ se směrnicí $f^{\prime}(x_0)$, tedy $y = f(x_0) + f^{\prime}(x_0)(x - x_0)$.
- **Primitivní funkce** — funkce $F$ je primitivní k funkci $f$ na intervalu $I$, jestliže pro každé $x \in I$ platí $F^{\prime}(x) = f(x)$.
- **Neurčitý integrál** — množina všech primitivních funkcí k dané funkci; dvě primitivní funkce se liší o konstantu.
- **Určitý integrál** — limita Riemannových součtů při zjemňování dělení intervalu k nule.
- **Geometrický význam určitého integrálu** — znaménkový obsah plochy mezi grafem funkce a osou $x$; části pod osou se počítají záporně.
- **Newtonova–Leibnizova formule** — je-li $F$ primitivní funkcí k $f$ na $[a,b]$, pak $\int_a^b f(x)\,\mathrm{d}x = F(b) - F(a)$.
- **Stacionární bod** — bod, v němž je první derivace nulová.
- **Lokální maximum (minimum)** — bod, v jehož okolí nenabývá funkce větší (menší) hodnoty.
- **Objem rotačního tělesa** — těleso vzniklé rotací grafu funkce kolem osy $x$ má objem $V = \pi \int_a^b [f(x)]^2\,\mathrm{d}x$.

---

### Příklad na papír

Tři krátké příklady, každý na jednu část zadání. **Druhý je hlavní** — je to přesně ta úloha, kterou zadání jmenuje („spočítej integrál všemi třemi pravidly"). První je půlminutová rozehrávka, třetí efektní tečka.

---

#### Příklad 1 — derivace z definice a numericky

##### Krok 1: derivace z definice

Vezmu $f(x) = x^2$ a spočítám ji **přímo z definice**, ne ze vzorce:

$$f^{\prime}(x) = \lim_{h \to 0} \frac{(x+h)^2 - x^2}{h} = \lim_{h \to 0} \frac{x^2 + 2xh + h^2 - x^2}{h} = \lim_{h \to 0} \frac{2xh + h^2}{h} = \lim_{h \to 0} (2x + h) = 2x$$

**Řekni k tomu tu podstatnou věc:** dokud je $h \ne 0$, smím krátit — a **po zkrácení už dosazení $h = 0$ smysl dává**. Před zkrácením by vyšlo $\frac{0}{0}$. Tohle je celý smysl limity v definici derivace.

##### Krok 2: tečna

V bodě $x_0 = 3$ je $f(3) = 9$ a $f^{\prime}(3) = 6$, takže tečna je

$$y = 9 + 6(x - 3) = 6x - 9$$

**Kontrola, která zabere pět vteřin:** dosaď do tečny $x = 3$ a musí vyjít $9$, tedy funkční hodnota — tečna se paraboly opravdu dotýká v bodě $T = [3,\ 9]$.

##### Krok 2b: sečna versus tečna — a jak to celé nakreslit

Tohle je obrázek, kterým se limita v definici derivace vysvětlí sama.

**Sečna** je přímka procházející **dvěma body na křivce**, $[x_0,\ f(x_0)]$ a $[x_0+h,\ f(x_0+h)]$. Její směrnice je přesně ten diferenční podíl z definice:

$$k_{\text{sečny}} = \frac{f(x_0+h) - f(x_0)}{h}$$

**Tečna** je přímka, která se křivky v bodě jen **dotýká**, a její směrnice je $f^{\prime}(x_0)$.

| | Sečna | Tečna |
|---|---|---|
| kolik bodů křivky | **dva** | **jeden** (dotykový) |
| jak dostanu směrnici | ze dvou funkčních hodnot, $\frac{\Delta y}{\Delta x}$ | z **derivace** |
| co popisuje | **průměrnou** změnu na úseku | **okamžitou** změnu v bodě |
| potřebuju k ní derivaci? | **ne** | **ano** |

> **Past, kterou si vyjasni hned:** sečna **nemá nic společného s počátkem** $[0,0]$. Nevychází z nuly — vychází z **bodu na křivce** a její poloha závisí jen na tom, jak si zvolíš $h$. Kdyby šla z počátku, byla by to jedna konkrétní přímka, a ne celá rodina přímek, která se s klesajícím $h$ sklápí k tečně.

**Jak se rovnice sečny dostane** — jsou to dva kroky a oba se dělají stejně jako u tečny.

**Krok A: směrnice.** Je to $\frac{\Delta y}{\Delta x}$, tedy **nahoře patří $y$, dole $x$**:

$$k = \frac{f(x_0+h) - f(x_0)}{h}$$

> **Přesně tady se chybuje:** v čitateli **nejsou $x$-ové souřadnice**, ale **funkční hodnoty**. Pro $x_0 = 3$ a $h = 1$ je to $\frac{f(4) - f(3)}{1} = \frac{16 - 9}{1} = 7$. Kdo tam napíše $4 - 3$, dostane $1$ — a to je jmenovatel, ne čitatel.

**Krok B: dosazení do směrnicového tvaru.** Přímka daným bodem s danou směrnicí, tentýž vzorec jako u tečny:

$$y = y_0 + k\,(x - x_0)$$

Pro naše tři přímky bodem $[3,\ 9]$:

| $h$ | druhý bod | směrnice $k$ | rovnice |
|---|---|---|---|
| $1$ | $[4,\ 16]$ | $\frac{16-9}{1} = 7$ | $y = 9 + 7(x-3) = 7x - 12$ |
| $0{,}5$ | $[3{,}5\ ;\ 12{,}25]$ | $\frac{12{,}25-9}{0{,}5} = 6{,}5$ | $y = 9 + 6{,}5(x-3) = 6{,}5x - 10{,}5$ |
| $\to 0$ | — (tečna) | $f^{\prime}(3) = 6$ | $y = 9 + 6(x-3) = 6x - 9$ |

**Kontrola, kterou dělej vždycky:** dosaď do každé rovnice $x = 3$ a musí vyjít $9$, protože všechny tři přímky procházejí bodem $[3,9]$. Tedy $21-12 = 9$ ✔, $19{,}5-10{,}5 = 9$ ✔, $18-9 = 9$ ✔. Když to nevyjde, spletl jsi znaménko při roznásobování závorky.

**Zkratka, která ušetří půlku práce:** u $f(x) = x^2$ se směrnice sečny dá zjednodušit obecně, a je to tentýž výpočet jako v Kroku 1, jen s dosazenou trojkou:

$$k = \frac{(3+h)^2 - 9}{h} = \frac{9 + 6h + h^2 - 9}{h} = \frac{6h + h^2}{h} = 6 + h$$

Takže $h = 1 \Rightarrow 7$, $h = 0{,}5 \Rightarrow 6{,}5$, $h = 0{,}1 \Rightarrow 6{,}1$, $h \to 0 \Rightarrow 6$. **Sečna se od tečny liší přesně o $h$** — a odtud je rovnou vidět, proč má dopředná diference v Kroku 3 chybu $O(h)$ a proč jí tam vyjde zrovna $6{,}1$.

Ty tři směrnice $7 \to 6{,}5 \to 6$ jsou **celá limita na jednom řádku**: jak $h$ klesá, druhý bod se přisouvá k prvnímu, sečna se sklápí a v limitě z ní je tečna. Sečny navíc parabolu **protínají ve dvou bodech**, tečna se jí dotýká v jediném.

Pro vykreslení tedy stačí parabola $y = x^2$ a ty tři přímky z tabulky — víc na jeden obrázek nedávej, slije se to.

##### Krok 2c: jak z rovnice poznám, že funkce v bodě roste

Podle **znaménka derivace** — a je to zároveň největší praktická věc, kterou derivace umí:

| Znaménko | Funkce | Tečna |
|---|---|---|
| $f^{\prime}(x) > 0$ | **roste** | stoupá zleva doprava |
| $f^{\prime}(x) < 0$ | **klesá** | klesá |
| $f^{\prime}(x) = 0$ | ani jedno — **stacionární bod** | vodorovná |

U nás $f^{\prime}(3) = 6 > 0$, takže parabola v trojce **roste** — a ta šestka říká i **jak rychle**: posun o kousek doprava zvedne $y$ zhruba o šestinásobek toho kousku.

Z jediného vzorce $f^{\prime}(x) = 2x$ se navíc odečte **celý průběh**: derivace je záporná pro $x < 0$, nulová v nule a kladná pro $x > 0$, tedy funkce **vlevo klesá, v nule má minimum a vpravo roste**. Přesně ten tvar, který kreslíš.

> **Věta, kterou tím plynule přejdeš k aplikacím:** „Znaménko derivace mi dá **monotonii**, nula v derivaci **kandidáta na extrém**, a znaménko druhé derivace pak rozhodne, jestli je to **minimum nebo maximum**."

##### Krok 3: totéž numericky, $h = 0{,}1$

Hodnoty: $f(2{,}9) = 8{,}41$, $f(3) = 9$, $f(3{,}1) = 9{,}61$.

| Metoda | Výpočet | Výsledek | Chyba |
|---|---|---|---|
| dopředná | $\frac{9{,}61 - 9}{0{,}1}$ | $6{,}1$ | $+0{,}1$ |
| zpětná | $\frac{9 - 8{,}41}{0{,}1}$ | $5{,}9$ | $-0{,}1$ |
| **centrální** | $\frac{9{,}61 - 8{,}41}{0{,}2}$ | $\mathbf{6{,}0}$ | $\mathbf{0}$ |

**Tohle je celý příklad v jednom obrázku:** jednostranné diference se pletou **o stejně a na opačnou stranu**, takže jejich průměr — což centrální diference je — vyjde **přesně**. (U paraboly se chyba vyruší úplně, u obecné funkce jen z velké části, proto $O(h^2)$ místo $O(h)$.)

##### Krok 4: lokální extrém

Vezmu $f(x) = x^3 - 3x$:

$$f^{\prime}(x) = 3x^2 - 3 = 0 \quad \Rightarrow \quad x = \pm 1$$

$$f^{\prime\prime}(x) = 6x: \qquad f^{\prime\prime}(1) = 6 > 0 \ \Rightarrow\ \textbf{minimum}, \qquad f^{\prime\prime}(-1) = -6 < 0 \ \Rightarrow\ \textbf{maximum}$$

Hodnoty: lokální minimum $f(1) = -2$, lokální maximum $f(-1) = 2$.

---

#### Příklad 2 — tři pravidla na jednom integrálu

##### Zadání a přesná hodnota

$$\int_1^2 \frac{\mathrm{d}x}{x} = \big[\ln x\big]_1^2 = \ln 2 - \ln 1 = \ln 2 \doteq 0{,}693147$$

> **Proč zrovna tenhle integrál:** přesnou hodnotu znám, takže **můžu spočítat chyby** — a přitom to není polynom, takže žádné pravidlo nevyjde „náhodou" přesně. Navíc je $\frac{1}{x}$ konvexní, což je vidět na tom, jak se která metoda plete.
>
> **A pozor na kalkulačku:** $\ln$ je logaritmus **přirozený**, o základu $e$, ne o základu 2. Tlačítko `log2` dá $1$ a `log` (základ 10) dá $0{,}301$ — správně je $\ln 2 \doteq 0{,}693$. Jiný logaritmus tam vyjít nemůže, protože primitivní funkce k $\frac{1}{x}$ je právě $\ln x$.

##### Krok 1: rozdělení intervalu

Všechna tři pravidla vycházejí ze stejného rámce — interval rozdělím na $n$ stejných dílků o šířce

$$h = \frac{b-a}{n}, \qquad x_i = a + i\,h$$

$n$ si **volím sám** a platí, že **čím větší, tím přesnější** (a tím víc počítání). Pravidlo je bez výjimek:

$$\textbf{kolik dílků } n \textbf{, tolik obdélníků (resp. lichoběžníků).}$$

Na intervalu $[1,2]$ o délce $1$ to vypadá takhle:

| $n$ | $h$ | dílky |
|---|---|---|
| $1$ | $1$ | $[1;\ 2]$ |
| $2$ | $0{,}5$ | $[1;\ 1{,}5]$, $[1{,}5;\ 2]$ |
| $3$ | $0{,}333$ | $[1;\ 1{,}33]$, $[1{,}33;\ 1{,}67]$, $[1{,}67;\ 2]$ |
| $4$ | $0{,}25$ | $[1;\ 1{,}25]$, $[1{,}25;\ 1{,}5]$, $[1{,}5;\ 1{,}75]$, $[1{,}75;\ 2]$ |

Pro dělení na dva dílky, tedy $h = \frac{2-1}{2} = 0{,}5$, dostanu tři uzly a v nich tři funkční hodnoty:

$$x_0 = 1, \quad x_1 = 1{,}5, \quad x_2 = 2$$

$$f(1) = \frac{1}{1} = 1, \qquad f(1{,}5) = \frac{1}{1{,}5} \doteq 0{,}666667, \qquad f(2) = \frac{1}{2} = 0{,}5$$

> **Přečti si tohle, než budeš číst dál, jinak ti čísla nebudou sedět.** Tyhle tři hodnoty jsou **společná zásoba**, ze které si v následujícím srovnání každé pravidlo vezme, co potřebuje — a **každé proto pracuje s jiným $n$**:
>
> | Pravidlo | $n$ | Co použije |
> |---|---|---|
> | obdélníkové | $\mathbf{1}$ | jeden dílek $[1;2]$, výška ve středu $1{,}5$ |
> | lichoběžníkové | $\mathbf{1}$ | jeden dílek $[1;2]$, kraje $1$ a $2$ |
> | Simpsonovo | $\mathbf{2}$ | dva dílky, parabola přes všechny tři body |
>
> **Proč to tak dělám:** aby všechna tři pravidla dostala **stejná tři čísla** a šla poctivě porovnat. Kdyby měl obdélník $n = 2$, potřeboval by středy $1{,}25$ a $1{,}75$, tedy dvě úplně nová vyhodnocení funkce — a tabulka by pak neporovnávala pravidla, ale to, kolikrát které funkci vyhodnotilo.
>
> **Pravidlo „$n$ dílků = $n$ obdélníků" se tím nijak neporušuje** — obdélník tu má prostě $n = 1$. V [Kroku 5](#krok-5-a-teď-n-jako-skutečné-dělení-na-víc-dílků) rozdělím interval doopravdy a uvidíš oba lichoběžníky zvlášť.
>
> A ještě jedna věc k Simpsonovi: u něj $n$ pořád znamená počet dílků, ale bere je **po dvojicích** — na každou dvojici položí jednu parabolu. Proto $n = 2$ dá jednu parabolu, $n = 4$ dvě, $n = 6$ tři… a proto **musí být $n$ sudé**: $n = 3$ by nechalo jeden dílek bez páru.

##### Krok 2: čím která metoda nahradí ten kousek

Tohle je celý rozdíl mezi pravidly — nad dílek se položí **něco jiného**:

**Obdélníkové se středem** — vodorovná čára ve výšce prostředního bodu:

```
   1 ┤●
     │ ╲___                       funkce 1/x
0,67 ┤▓▓▓▓|▓▓▓╲___
     │▓▓▓▓|▓▓▓▓▓▓▓●              obdélník výšky f(1,5)
     │▓▓▓▓|▓▓▓▓▓▓▓▓
   ──┼────┼───────┼──
     1   1,5      2

   vlevo PODstřelí, vpravo PŘEstřelí -> chyby se z velké části vyruší
```

**Lichoběžníkové** — úsečka mezi krajními body:

```
   1 ┤●
     │▓╲___                       úsečka leží CELÁ NAD funkcí,
     │▓▓▓▓▓▓▓╲___                 protože 1/x je prohnutá dolů
 0,5 ┤▓▓▓▓▓▓▓▓▓▓▓●
     │▓▓▓▓▓▓▓▓▓▓▓▓
   ──┼───────────┼──
     1           2                -> PŘEstřelí
```

**Simpsonovo** — parabola všemi třemi body:

```
   1 ┤●
     │▓╲__                        parabola se přes prostřední bod
0,67 ┤▓▓▓▓●___                    PROHNE stejně jako funkce
     │▓▓▓▓▓▓▓▓▓╲__
     │▓▓▓▓▓▓▓▓▓▓▓▓●
   ──┼────┼───────┼──
     1   1,5      2                -> sedne mnohem líp
```

| Pravidlo | Co položí nad dílek | Co z funkce zachytí |
|---|---|---|
| obdélníkové | **vodorovnou čáru** | jen výšku, sklon ignoruje |
| lichoběžníkové | **šikmou úsečku** | výšku **i sklon** |
| Simpsonovo | **parabolu** | výšku, sklon **i prohnutí** |

**A to je celá otázka v jedné větě: čím víc z chování funkce ta náhrada zachytí, tím menší chyba.**

##### Krok 3: všechna tři pravidla z týchž tří čísel

**Obdélníkové se středem** — je to prostě *šířka krát výška*, kde výška je hodnota uprostřed:

$$M = (b-a)\cdot f\!\left(\tfrac{a+b}{2}\right) = 1 \cdot 0{,}666667 = 0{,}666667$$

**Lichoběžníkové** — vzoreček ze základky, *průměr obou stran krát šířka*:

$$T = \frac{f(a) + f(b)}{2}\cdot(b-a) = \frac{1 + 0{,}5}{2}\cdot 1 = 0{,}75$$

**Simpsonovo** — prostřední hodnota se čtyřnásobnou vahou:

$$S = \frac{b-a}{6}\Big[f(a) + 4f(s) + f(b)\Big] = \frac{1}{6}\big[1 + 4\cdot 0{,}666667 + 0{,}5\big] = \frac{4{,}166667}{6} = 0{,}694444$$

| Pravidlo | Použije body | Výsledek | Chyba |
|---|---|---|---|
| **obdélníkové** (se středem) | jen $1{,}5$ | $0{,}666667$ | $-0{,}0265$ (**pod**) |
| **lichoběžníkové** | jen $1$ a $2$ | $0{,}75$ | $+0{,}0569$ (**nad**) |
| **Simpsonovo** | **všechny tři** | $\mathbf{0{,}694444}$ | $\mathbf{+0{,}0013}$ |
| přesně, $\ln 2$ | — | $0{,}693147$ | — |

Simpson je tady **zhruba čtyřicetkrát přesnější** než lichoběžníkové pravidlo — a použil **úplně stejné tři hodnoty funkce**. To je pointa, kterou vyslov: lepší pravidlo nestojí víc výpočtů, jen chytřejší váhy.

##### Krok 4: a teď odkud se ty váhy berou

Podívej se na znaménka chyb: obdélníkové pravidlo je **pod** správnou hodnotou, lichoběžníkové **nad** ní, a lichoběžník se plete **zhruba dvakrát víc** ($0{,}0569 \approx 2 \cdot 0{,}0265$). Nabízí se je tedy zprůměrovat v poměru $2 : 1$:

$$\frac{2M + T}{3} = \frac{2 \cdot 0{,}666667 + 0{,}75}{3} = \frac{2{,}083333}{3} = 0{,}694444$$

**A to je přesně Simpsonovo pravidlo.** Rozepsáno:

$$\frac{2M + T}{3} = \frac{1}{3}\left[2(b-a)f(s) + \frac{b-a}{2}\big(f(a)+f(b)\big)\right] = \frac{b-a}{6}\Big[f(a) + 4f(s) + f(b)\Big]$$

**Váhy $1 : 4 : 1$ tedy nejsou vzorec k memorování, ale výsledek toho, že se dvě chyby s opačným znaménkem vyruší.** Když tohle u zkoušky ukážeš, máš odpověď na „proč zrovna čtyřka" i na „proč je Simpson tak přesný" naráz.

> **Nepleť si tuhle čtyřku s dvojkou u lichoběžníkového pravidla** — vznikají úplně jinak:
>
> | Koeficient | Odkud se bere |
> |---|---|
> | **dvojka** u vnitřních uzlů lichoběžníku | vnitřní uzel je **sdílený dvěma sousedními lichoběžníky** — jednou jako pravý okraj, jednou jako levý |
> | **čtyřka** u Simpsona | **dvojnásobná váha obdélníku** ve váženém průměru $\frac{2M+T}{3}$ |
>
> Ve složeném Simpsonově pravidle se pak objeví **obojí naráz**: liché uzly jsou vždy středem dvojice, a mají tedy váhu $4$; sudé uzly jsou sdílené mezi dvěma dvojicemi, a mají váhu $2$.

##### Krok 5: a teď $n$ jako skutečné dělení na víc dílků

Až doteď byl obdélník i lichoběžník jeden jediný, přes celý interval. Teď to udělám doopravdy — **dva lichoběžníky** o šířce $h = 0{,}5$:

$$\underbrace{\frac{f(1) + f(1{,}5)}{2}\cdot 0{,}5}_{[1;\ 1{,}5]} + \underbrace{\frac{f(1{,}5) + f(2)}{2}\cdot 0{,}5}_{[1{,}5;\ 2]} = 0{,}416667 + 0{,}291667 = 0{,}708333$$

Chyba klesla z $0{,}0569$ na $0{,}0152$, tedy zhruba **čtyřikrát** — přesně jak slibuje řád $O(h^2)$: zdvojnásobím $n$, chyba klesne na čtvrtinu.

**A všimni si, že $f(1{,}5)$ se ve výpočtu objevilo dvakrát** — jednou jako pravá strana prvního lichoběžníku, jednou jako levá strana druhého. Přesně to je ta dvojka ze složeného vzorce, jen zapsaná úsporněji:

$$\frac{h}{2}\Big[f(x_0) + 2f(x_1) + f(x_2)\Big] = \frac{0{,}5}{2}\big[1 + 1{,}333333 + 0{,}5\big] = 0{,}708333$$

Obě čísla jsou stejná, protože je to **týž výpočet** — jednou rozepsaný po lichoběžnících, jednou vytknutý.

**A totéž s obdélníky.** Dva obdélníky šířky $0{,}5$, výška ve **středu každého z nich** — což jsou body $1{,}25$ a $1{,}75$, tedy dvě zcela nové funkční hodnoty:

$$f(1{,}25) = 0{,}8, \qquad f(1{,}75) \doteq 0{,}571429$$

$$0{,}5 \cdot 0{,}8 \ + \ 0{,}5 \cdot 0{,}571429 \ = \ 0{,}4 + 0{,}285714 \ = \ 0{,}685714$$

Chyba klesla z $-0{,}0265$ na $-0{,}0074$, tedy zhruba **čtyřikrát** — obdélník se středem má také řád $O(h^2)$.

Tady je rovnou vidět i to, proč měl obdélník v srovnávací tabulce $n = 1$: **s $n = 2$ potřebuje body, které ostatní pravidla vůbec nepoužívají.**

| $n$ | obdélník (střed) | lichoběžník | Simpson |
|---|---|---|---|
| $1$ | $0{,}666667$ | $0{,}75$ | — (potřebuje sudé $n$) |
| $2$ | $0{,}685714$ | $0{,}708333$ | $0{,}694444$ |
| přesně | $0{,}693147$ | $0{,}693147$ | $0{,}693147$ |

Ve druhém řádku už mají všechna tři pravidla **stejné $n$** — a pořadí přesnosti je přesně takové, jaké má být.

##### Kontrola na polynomu

Rychlá kontrola tvrzení, že Simpson je přesný do třetího stupně — vezmu $\int_0^2 x^3\,\mathrm{d}x$, jehož přesná hodnota je $\left[\frac{x^4}{4}\right]_0^2 = 4$. S $n = 2$, $h = 1$, uzly $0, 1, 2$:

$$\frac{h}{3}\big[f(0) + 4f(1) + f(2)\big] = \frac{1}{3}\big[0 + 4 + 8\big] = \frac{12}{3} = 4 \quad \checkmark$$

**Přesně**, ačkoli parabola kubiku „netrefí". Pro srovnání lichoběžníkové pravidlo dá $\frac{1}{2}[0 + 2\cdot1 + 8] = 5$, tedy chybu $25\ \%$.

---

#### Příklad 3 — objem koule

Kouli poloměru $r$ dostanu rotací horní půlkružnice

$$f(x) = \sqrt{r^2 - x^2} \qquad \text{na intervalu } [-r,\ r]$$

Dosadím do vzorce (a odmocnina se **na druhou hezky zruší**, proto je tenhle příklad tak krátký):

$$V = \pi \int_{-r}^{r} \big(r^2 - x^2\big)\,\mathrm{d}x = \pi \left[ r^2x - \frac{x^3}{3} \right]_{-r}^{r}$$

$$= \pi \left[ \left(r^3 - \frac{r^3}{3}\right) - \left(-r^3 + \frac{r^3}{3}\right) \right] = \pi \left[ \frac{2r^3}{3} + \frac{2r^3}{3} \right] = \boxed{\ \frac{4}{3}\pi r^3\ }$$

> **Tohle je věta, kterou celou otázku uzavři:** „Vzorec pro objem koule, který se na základní škole učí nazpaměť, **tady vypadne ze tří řádků integrálu**. A je to přesně ten princip, kterým jsem začal: kouli nakrájím na tenké disky, každý nahradím válečkem, jehož objem spočítat umím, a nechám jejich tloušťku jít k nule. **Celý diferenciální a integrální počet je jedna myšlenka — nahradit křivé něčím rovným na dost malém kousku.**"

---

### Na co se doptají

- Napiš definici derivace a vysvětli, proč tam musí být limita.
- Jaký je geometrický význam derivace? Napiš z něj rovnici tečny.
- Musí být derivovatelná funkce spojitá? A naopak?
- Proč je centrální diference přesnější než dopředná?
- Je pravda, že čím menší $h$, tím lepší numerická derivace?
- Co je primitivní funkce a proč se u neurčitého integrálu píše $+\,C$?
- Proč se určitý integrál vůbec počítá numericky, když máme Newtonovu–Leibnizovu formuli?
- Spočítej jeden integrál všemi třemi pravidly a porovnej s přesnou hodnotou.
- Jaký je geometrický rozdíl mezi obdélníkovým a lichoběžníkovým pravidlem?
- **Proč je Simpsonovo pravidlo přesné pro polynomy až do 3. stupně?**
- Odkud se v Simpsonově pravidle bere koeficient 4?
- Proč musí být u Simpsonova pravidla počet dílků sudý?
- Co se stane s chybou, když zjemním dělení dvakrát? Odpověz pro všechna tři pravidla.
- Vypočítej $\int_0^{2\pi} \sin x\,\mathrm{d}x$. A jaký je **obsah** plochy mezi grafem a osou?
- Jak najdeš lokální extrém? Stačí, že $f^{\prime}(x) = 0$?
- Co znamená $C^1$ a $C^2$ spojitost při navazování křivek a proč na ní záleží?
- Jak odvodíš vzorec pro objem rotačního tělesa z určitého integrálu?
- Odvoď objem koule nebo kužele.

### Skripty k vyzkoušení

V kořeni repozitáře jsou dva Python skripty k téhle otázce. Nic neinstalují, běží na čisté standardní knihovně:

```bash
python3 numericke_derivovani.py   # dopředná, zpětná, centrální diference
python3 numericka_integrace.py    # obdélníky, lichoběžníky, Simpson
```

Co na nich uvidíš a co se z toho dá u zkoušky říct:

- **řády chyby na číslech** — zmenši $h$ desetkrát a chyba dopředné diference klesne $10\times$, chyby centrální $100\times$. U integrace zdvojnásob $n$ a chyby klesnou $2\times$, $4\times$ a $16\times$ podle pravidla.
- **past s příliš malým $h$** — skript projede $h$ od $10^{-1}$ do $10^{-16}$ a je vidět, jak chyba nejdřív klesá, u $h \approx 10^{-5}$ dosáhne minima a pak zase **roste**. Tuhle tabulku je dobré si jednou prohlédnout — pak už na tu otázku nikdy neodpovíš špatně.
- **odkud se berou váhy $1 : 4 : 1$** — skript spočítá $\frac{2M + T}{3}$ a ukáže, že vyjde přesně Simpson.
- **$\int_0^1 e^{-x^2}\,\mathrm{d}x$** — funkce bez elementární primitivní funkce, tedy přesně ten důvod, proč numerická integrace vůbec existuje. Simpson ji s devíti vyhodnoceními trefí na $2 \cdot 10^{-6}$, obdélníkové pravidlo by na totéž potřebovalo statisíce dílků.

### Užitečné odkazy

- <https://www.geogebra.org/calculator> (tečna, plocha pod křivkou — jde si to naklikat)
- <https://www.desmos.com/calculator>
- <https://www.youtube.com/watch?v=ACU3tdGglmA> (definice derivace, česky)
- <https://www.youtube.com/watch?v=cMSCIG396A8> (graf derivace, česky)
- <https://www.youtube.com/watch?v=lXZmgv8xm18> (derivace, česky)
- <https://en.wikipedia.org/wiki/Simpson%27s_rule>
- <https://www.3blue1brown.com/topics/calculus> (vizuální výklad celé analýzy — nejlepší, co k tomuhle tématu je)
- `/home/valdemar/Dokumenty/SZZ/01 - SZZTP - 15m ústní/05/` — zpracování od kamaráda; má obrázky ke všem třem pravidlům a k lokálnímu extrému
