## 4 — Reálná funkce, polynomy, numerické řešení nelineárních rovnic

> Reálná funkce jedné reálné proměnné (definice, definiční obor a obor hodnot, graf funkce, limita a spojitost funkce), polynomy (definice, vlastnosti, Hornerovo schéma), numerické řešení nelineárních rovnic (metoda půlení intervalu, Newtonova metoda)

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. Funkce jako **zobrazení** — každému $x$ **právě jedno** $y$; definiční obor, obor hodnot, graf
2. Jak se definiční obor prakticky hledá (jmenovatel, sudá odmocnina, logaritmus)
3. **Limita** v bodě — intuice „kam se funkce blíží", pak $\varepsilon$–$\delta$ definice; jednostranné limity a kdy limita existuje
4. Limita **nemusí** být rovna funkční hodnotě — funkce tam nemusí být vůbec definovaná
5. **Spojitost** v bodě = limita existuje **a rovná se** funkční hodnotě (tři podmínky naráz); spojitost na intervalu
6. Věty o spojitých funkcích, a hlavně **Bolzanova věta** — z ní plyne existence kořene
7. **Polynom** — definice, stupeň, kořeny; polynom je spojitý na celém $\mathbb{R}$
8. Vlastnosti: **kořenový činitel** ($c$ je kořen $\iff$ $P(x) = (x-c)Q(x)$), počet kořenů, rovnost polynomů
9. **Hornerovo schéma** — odvození vytýkáním, $O(n)$ místo $O(n^2)$, a že zbytek je rovnou $P(c)$ i dělení kořenovým činitelem
10. Proč se nelineární rovnice řeší **numericky** (od 5. stupně neexistuje obecný vzorec, transcendentní rovnice nemají vzorec vůbec)
11. **Metoda půlení intervalu** — předpoklad $f(a)\cdot f(b) < 0$, jistá konvergence, $\log_2$ kroků
12. **Newtonova metoda** — odvození z rovnice tečny, kvadratická konvergence, a **kdy selže**
13. Srovnání: jistota vs. rychlost — tady výklad graduje

**Nit, na kterou to navlékni:** celá tahle otázka je jediná úloha — **najdi $x$, kde $f(x) = 0$**. První třetina dodá **jazyk** (co smím dosadit, co vyleze, jak to vypadá). Druhá třetina dodá **záruku**: spojitost je slib, že graf nemá díru, a Bolzanova věta z toho slibu udělá tvrzení „mezi plusem a mínusem někde leží kořen". Třetí třetina ten kořen **najde** — a protože každá iterace numerické metody hlavně **vyhodnocuje funkci**, je Hornerovo schéma přesně to, co běží uvnitř té smyčky. Půlení intervalu tomu slibu věří doslova a jde na jistotu (je to binární vyhledávání na reálné ose), Newton místo toho hádá podle tečny — je mnohem rychlejší, ale záruku ztrácí.

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tahák, který si vyrobíš zpaměti hned na začátku přípravy. Napsání zabere zhruba tři minuty, zbylých dvanáct pak máš na rozmyšlení příkladu.

```
FUNKCE  f: D -> R,  D podmnožina R,  každému x PRÁVĚ JEDNO y
  D(f) = kde to jde:  jmenovatel != 0 | sudá odmocnina >= 0 | log > 0
  H(f) = co z toho vypadne        graf = množina bodů [x, f(x)]

LIMITA   lim x->a f(x) = L
  pro každé eps>0 existuje delta>0:  0 < |x-a| < delta  =>  |f(x)-L| < eps
  existuje <=> zleva = zprava      (v bodě a funkce definovaná BÝT NEMUSÍ)

SPOJITOST v bodě a:   lim x->a f(x) = f(a)      ...tři podmínky naráz

BOLZANO: f spojitá na [a,b] a f(a)*f(b) < 0 => existuje kořen v (a,b)
         ^^^ tohle je LICENCE na metodu půlení

POLYNOM  P(x) = a_n x^n + ... + a_1 x + a_0,  stupeň = nejvyšší n s a_n != 0
  spojitý na celém R, derivace všech řádů
  stupeň n -> přesně n kořenů v C (s násobností), reálných nejvýš n
  c je kořen  <=>  P(x) = (x - c) * Q(x)          [kořenový činitel]

HORNER   P(x) = ( ... ((a_n x + a_n-1) x + a_n-2) x + ... ) x + a_0

            a_n    a_n-1   a_n-2  ...   a_0
      c |          c*b_n   c*b_n-1      c*b_1
      ---------------------------------------
            b_n    b_n-1   b_n-2  ...   ZBYTEK = P(c)

  b-čka = koeficienty podílu Q(x);   zbytek 0  =>  c je kořen
  n násobení + n sčítání = 2n operací = O(n)   (naivně n(n+1)/2 = O(n^2))

PŮLENÍ   s = (a+b)/2;  když f(a)*f(s) < 0 -> b = s,  jinak a = s
  po k krocích je délka (b-a)/2^k   ->   k >= log2( (b-a)/eps )
  JISTÉ, ale pomalé: lineární, 1 bit za krok, ~3,3 kroku na desetinnou číslici

NEWTON   z rovnice tečny  y = f(x_k) + f'(x_k)*(x - x_k),  polož y = 0:
         x_k+1 = x_k - f(x_k) / f'(x_k)
  kvadratická konvergence = počet platných číslic se ZDVOJNÁSOBÍ
  selže:  f'(x_k) = 0  |  špatný start (diverguje nebo cykluje)  |  násobný kořen

PŘÍKLAD A (funkce)  f(x) = (x^2 - 1)/(x - 1) = x + 1  pro x != 1
  D(f) = R bez {1}    H(f) = R bez {2}    graf = přímka s DÍROU v [1,2]
  lim x->1 f(x) = 2,  ale f(1) NEEXISTUJE -> odstranitelná nespojitost
  (pól místo díry: 1/(x-2), limity -oo a +oo, limita NEEXISTUJE)

RACIONÁLNÍ KOŘENY: kandidát p/q,  p dělí ABSOLUTNÍ člen, q dělí VEDOUCÍ
  normovaný polynom -> q = 1 -> kandidáti jsou celí dělitelé abs. členu
  hádej jen dokud nezbude KVADRATICKÁ rovnice, pak už diskriminant

PŘÍKLAD B (Horner + rozklad)  x^4 - 4x^3 - 7x^2 + 22x + 24
  normovaný -> kandidáti = celí dělitelé 24
  Horner v -1 -> zbytek 0, podíl  x^3 - 5x^2 - 2x + 24
  Horner v -2 -> zbytek 0, podíl  x^2 - 7x + 12 -> diskriminant -> 3, 4
  => (x+1)(x+2)(x-3)(x-4);  kořeny -1,-2,3,4 = PRŮSEČÍKY S OSOU X
  pozor: sudá násobnost = graf se osy jen DOTKNE -> půlení tam selže

PŘÍKLAD C (numerika)  x^3 - 2x - 5 = 0
  kandidáti +-1, +-5 nevyjdou -> žádný racionální kořen -> MUSÍ numericky
  Horner v 2:   1  0  -2  -5  ->  1  2  2 | -1     P(2) = -1
  Horner v 3:                                      P(3) = +16
  -> znaménko se mění na [2,3], Bolzano dává kořen
  půlení:  2,5 -> +   2,25 -> +   2,125 -> +   -> kořen v [2 ; 2,125]
  Newton z 2:   x1 = 2 - (-1)/10 = 2,1
                x2 = 2,1 - 0,061/11,23 = 2,0946      (přesně 2,09455)
  na 4 desetinná místa: Newton 2 kroky, půlení 14 kroků
```

#### Jak si z toho odvodit zbytek

- **Newtonův vzorec se neuč, odvoď ho.** Napiš rovnici tečny v bodě $[x_k, f(x_k)]$, tedy $y = f(x_k) + f^{\prime}(x_k)(x - x_k)$, polož $y = 0$ a vyjádři $x$. Vypadne $x_{k+1} = x_k - \frac{f(x_k)}{f^{\prime}(x_k)}$. Trvá to deset vteřin a nikdy si nespleteš znaménko.
- **Počet kroků půlení taky ne.** Interval má na začátku délku $b-a$ a každý krok ji půlí, takže po $k$ krocích je $\frac{b-a}{2^k}$. Chci, aby to bylo menší než $\varepsilon$ — a odlogaritmováním vypadne $k \ge \log_2\frac{b-a}{\varepsilon}$.
- **Hornerovo schéma je jen vytýkání.** Z $a_3x^3 + a_2x^2 + a_1x + a_0$ vytkni $x$ z prvních tří členů, pak z prvních dvou uvnitř — a máš $((a_3x + a_2)x + a_1)x + a_0$. Odtud je vidět i ta složitost: každá závorka = jedno násobení a jedno sčítání, závorek je $n$.
- **Složitost naivního dosazení** dopočítáš: $a_kx^k$ potřebuje $k$ násobení, takže dohromady $1+2+\dots+n = \frac{n(n+1)}{2}$, což je $\Theta(n^2)$. (Aritmetickou řadu už máš z [okruhu 2](../02-algoritmy-nad-seznamy/).)
- **Definiční obor si nepamatuj jako seznam.** Ptej se „kde by ta operace spadla" — dělení nulou, sudá odmocnina ze záporného, logaritmus z nekladného. Nic jiného v příkladech u zkoušky nebývá.

#### Jak si to zapamatovat, aniž bys to biflil

> **Spojitost je slib, že graf nemá díru. Bolzano z toho slibu udělá kořen. Půlení ho najde jistě, Newton rychle.**

Ty tři věty drží celou druhou půlku otázky:

| | Půlení intervalu | Newtonova metoda |
|---|---|---|
| co potřebuje | jen **spojitost** a změnu znaménka | **derivaci** a dobrý start |
| co dělá | zahodí půlku intervalu | prostrčí **tečnu** a jde na její kořen |
| záruka | **vždy** dojde k cíli | **žádná** — může divergovat i cyklovat |
| rychlost | lineární, 1 bit za krok | **kvadratická**, číslice se zdvojnásobují |
| obraz | opatrný, ale jde krok za krokem | běží — ale může se rozběhnout špatným směrem |

A **půlení intervalu je binární vyhledávání**, jen přeložené z pole na reálnou osu. Místo setříděnosti pole ho opravňuje spojitost, místo porovnání s hledaným klíčem se testuje znaménko — ale invariant je identický: *„kořen je pořád uvnitř mého intervalu"*, a interval se každým krokem půlí.

##### Kde to navazuje na ostatní okruhy

| Co tady | Kde to už bylo | Jak to spolu souvisí |
|---|---|---|
| půlení intervalu | binární vyhledávání, [okruh 2](../02-algoritmy-nad-seznamy/) | tentýž algoritmus; „půlím a jednu půlku zahazuji" |
| $k \ge \log_2\frac{b-a}{\varepsilon}$ | logaritmy, [okruh 11](../11-rekurence-asymptotika/) | logaritmus = „kolikrát můžu půlit"; přesně jako výška stromu |
| Horner $O(n)$ vs. $O(n^2)$ | složitosti, [okruh 2](../02-algoritmy-nad-seznamy/) | stejný skok jako u naivního vs. chytrého třídění |
| $1+2+\dots+n = \frac{n(n+1)}{2}$ | aritmetická řada, [okruh 2](../02-algoritmy-nad-seznamy/) | proč je naivní dosazení kvadratické |
| $\varepsilon$, $\lfloor x \rfloor$, $\Theta$ | značky, [okruh 11](../11-rekurence-asymptotika/) | tam máš celý tahák na symboly |
| derivace a její geometrický význam | [okruh 5](../05-derivace-integraly-numerika/) | Newton **je** aplikace derivace; tečna je tam definovaná |
| iterace do konvergence | iterační metoda, [okruh 11](../11-rekurence-asymptotika/) | posloupnost $x_{k+1} = g(x_k)$ je rekurentní vztah |

---

### Reálná funkce jedné reálné proměnné

- **funkce** = zobrazení, které každému prvku definičního oboru přiřadí **právě jednu** hodnotu
- **reálná funkce jedné reálné proměnné** = funkce $f: D \to \mathbb{R}$, kde $D \subseteq \mathbb{R}$

$$f : D \to \mathbb{R}, \qquad D \subseteq \mathbb{R}$$

Tři pojmy, které musíš umět rozlišit:

| Pojem | Značení | Co to je |
|---|---|---|
| **definiční obor** | $D(f)$ | množina všech $x$, pro která je $f(x)$ definováno — „co smím dosadit" |
| **obor hodnot** | $H(f) = \{ f(x) : x \in D(f) \}$ | množina hodnot, kterých funkce **skutečně** nabývá — „co může vylézt" |
| **graf** | $G(f) = \{ [x, f(x)] : x \in D(f) \}$ | množina bodů v rovině |

> **Past, na které se dá zaškobrtnout:** obor hodnot není totéž co **cílová množina (kodoména)**. Když napíšu $f: \mathbb{R} \to \mathbb{R}$, $f(x) = x^2$, je kodoména celé $\mathbb{R}$, ale obor hodnot je jen $[0, \infty)$. Zkoušející se rád zeptá „a nabývá vaše funkce opravdu všech těch hodnot?".

**Definice funkce má jádro ve slově „právě jedno".** Kdyby jednomu $x$ příslušela dvě $y$, není to funkce — proto **kružnice není grafem funkce** a proto se $\sqrt{x}$ definuje jako **nezáporná** odmocnina. Test na obrázku: každá svislá přímka smí protnout graf **nejvýš jednou**.

#### Jak se prakticky hledá definiční obor

Neptej se „co tam patří", ale **„kde by ta operace spadla"**:

| Výraz ve funkci | Podmínka |
|---|---|
| zlomek $\frac{1}{g(x)}$ | $g(x) \ne 0$ |
| sudá odmocnina $\sqrt{g(x)}$ | $g(x) \ge 0$ |
| logaritmus $\log g(x)$ | $g(x) > 0$ |
| $\tan x$ | $x \ne \frac{\pi}{2} + k\pi$ |
| $\arcsin g(x)$, $\arccos g(x)$ | $-1 \le g(x) \le 1$ |

Podmínek může být víc naráz — pak je **všechny protneš**. Například u $f(x) = \frac{\sqrt{x-1}}{x-3}$ potřebuješ $x \ge 1$ **a zároveň** $x \ne 3$, tedy $D(f) = [1, 3) \cup (3, \infty)$.

#### Vlastnosti, které se hodí umět pojmenovat

| Vlastnost | Definice | Na grafu |
|---|---|---|
| **sudá** | $f(-x) = f(x)$ | souměrná podle osy $y$ (např. $x^2$, $\cos x$) |
| **lichá** | $f(-x) = -f(x)$ | souměrná podle počátku (např. $x^3$, $\sin x$) |
| **rostoucí** | $x_1 < x_2 \Rightarrow f(x_1) < f(x_2)$ | jde vzhůru |
| **prostá (injektivní)** | $x_1 \ne x_2 \Rightarrow f(x_1) \ne f(x_2)$ | vodorovná přímka protne nejvýš jednou |
| **omezená** | existuje $K$: $\lvert f(x) \rvert \le K$ | vejde se mezi dvě vodorovné přímky |
| **periodická** | $f(x + p) = f(x)$ | opakuje se |

> **Souvislost, kterou zmiň:** funkce má **inverzní funkci** právě tehdy, když je **prostá** — jinak by inverze přiřazovala jednomu $x$ dvě hodnoty, a to už není funkce. Proto se $\sin x$ musí zúžit na $[-\frac{\pi}{2}, \frac{\pi}{2}]$, než se dá invertovat na $\arcsin$.

---

### Limita funkce

**Intuice napřed, definice až po ní.** Limita odpovídá na otázku: *„k čemu se funkční hodnoty blíží, když se $x$ blíží k bodu $a$?"* — a to **bez ohledu na to, co se děje přímo v bodě $a$**. Funkce tam klidně nemusí být vůbec definovaná.

$$\lim_{x \to a} f(x) = L$$

Formálně (Cauchyho $\varepsilon$–$\delta$ definice):

$$\forall \varepsilon > 0 \ \ \exists \delta > 0 : \quad 0 < \lvert x - a \rvert < \delta \ \Rightarrow \ \lvert f(x) - L \rvert < \varepsilon$$

**Přečti to nahlas takhle:** „Ať mi zadáš jakkoli úzký pás kolem $L$ (to je $\varepsilon$), já najdu takové okolí bodu $a$ (to je $\delta$), že celý graf nad ním leží v tom pásu." Podstatné je pořadí kvantifikátorů — **$\varepsilon$ dává protivník, $\delta$ hledám já**.

> **Detail, který stojí za zmínku:** v podmínce je $0 < \lvert x - a \rvert$, tedy $x = a$ je **vyloučeno**. Tím je formálně zajištěno, že hodnota $f(a)$ do limity nemluví.

#### Jednostranné limity a existence

- **limita zleva** $\lim_{x \to a^-} f(x)$ — blížím se jen po hodnotách menších než $a$
- **limita zprava** $\lim_{x \to a^+} f(x)$ — jen po větších

$$\lim_{x \to a} f(x) = L \quad \iff \quad \lim_{x \to a^-} f(x) = \lim_{x \to a^+} f(x) = L$$

Když se obě strany liší, **limita neexistuje**. Typický příklad je $f(x) = \frac{\lvert x \rvert}{x}$ v nule: zleva $-1$, zprava $+1$.

#### Limity v nekonečnu a nevlastní limity

- $\lim_{x \to \infty} f(x)$ — chování „daleko vpravo"; třeba $\lim_{x\to\infty} \frac{1}{x} = 0$
- **nevlastní limita** $\lim_{x \to a} f(x) = \infty$ — funkce neroste k číslu, ale nade všechny meze; třeba $\frac{1}{x^2}$ v nule

> **Past:** zápis $= \infty$ neznamená, že limita „je rovna nějakému číslu". Znamená, že limita **neexistuje vlastní** a funkce roste nade všechny meze. Když se na to zeptají, řekni to takhle.

---

### Spojitost

Funkce $f$ je **spojitá v bodě $a$**, právě když

$$\lim_{x \to a} f(x) = f(a)$$

Vypadá to jako jedna rovnice, ale jsou v ní schované **tři podmínky naráz** — a přesně na tohle se ptají:

1. $f(a)$ **existuje**, tedy $a \in D(f)$
2. **limita v bodě $a$ existuje** (obě jednostranné se rovnají)
3. ty dvě věci se **rovnají**

Funkce je **spojitá na intervalu**, je-li spojitá v každém jeho vnitřním bodě a v krajních bodech aspoň jednostranně.

#### Druhy nespojitostí — hodí se jako obrázek

```
 odstranitelná        skoková            pól (nekonečná)
       │  ○                │   ●───           │    │
       │ ╱ ╲               │  ╱                │   │
   ────┼────────       ────┼────────       ────┼───┼────
       │                ───●                   │   │
    limita existuje,    limity zleva a      limita je
    ale != f(a)         zprava se liší      nekonečná
    (nebo f(a) chybí)
```

#### Věty o spojitých funkcích — a ta jedna, kvůli které tu jsou

Na uzavřeném omezeném intervalu $[a,b]$ platí:

- **Weierstrassova věta** — spojitá funkce tam nabývá svého **maxima i minima**
- **věta o mezihodnotě (Darbouxova)** — nabývá **všech hodnot** mezi $f(a)$ a $f(b)$
- **Bolzanova věta** (speciální případ té předchozí, kde ta mezihodnota je nula):

$$f \text{ spojitá na } [a,b] \ \wedge \ f(a) \cdot f(b) < 0 \quad \Rightarrow \quad \exists c \in (a,b): f(c) = 0$$

> **Tohle je pointa celé první poloviny otázky.** Bolzanova věta je **licence na metodu půlení intervalu**. Podmínka $f(a)\cdot f(b) < 0$ jen elegantně říká „na koncích má funkce **opačná znaménka**". A spojitost je nezbytná: bez ní se graf může přes osu **přeskočit** — třeba $f(x) = \frac{1}{x}$ má na $[-1, 1]$ opačná znaménka na koncích, ale žádný kořen. Když tuhle protipříkladovou větu řekneš, máš u zkoušejícího vyhráno.

---

### Polynomy

**Polynom** (mnohočlen) je funkce tvaru

$$P(x) = a_n x^n + a_{n-1}x^{n-1} + \dots + a_1 x + a_0 = \sum_{i=0}^{n} a_i x^i$$

kde $a_i \in \mathbb{R}$ jsou **koeficienty** a mocniny jsou **celočíselné nezáporné**. **Stupeň** $\deg P$ je nejvyšší exponent s nenulovým koeficientem.

> Proto $\frac{1}{x} = x^{-1}$ ani $\sqrt{x} = x^{1/2}$ polynomy nejsou — mocniny nejsou celá nezáporná čísla.

#### Vlastnosti

- $D(P) = \mathbb{R}$ — do polynomu se dá dosadit **cokoli**, není tam co rozbít
- polynom je **spojitý na celém $\mathbb{R}$** a má derivace všech řádů (proto se na něm dají použít obě numerické metody bez výhrad)
- **součet, rozdíl i součin** polynomů je zase polynom; **podíl obecně ne**
- **rovnost polynomů**: dva polynomy se rovnají, právě když mají stejné koeficienty u stejných mocnin
- pro velká $\lvert x \rvert$ rozhoduje o chování grafu **člen s nejvyšší mocninou**

#### Kořeny

**Kořen** polynomu je číslo $c$ s $P(c) = 0$. Tři tvrzení, která patří k sobě:

1. **Věta o kořenovém činiteli:** $c$ je kořen $P$ **právě tehdy**, když $P(x) = (x - c) \cdot Q(x)$, kde $\deg Q = \deg P - 1$
2. **Základní věta algebry:** každý nekonstantní polynom má aspoň jeden kořen v $\mathbb{C}$. Opakovaným vytýkáním kořenových činitelů z toho plyne, že polynom stupně $n$ má **přesně $n$ kořenů v $\mathbb{C}$** (počítáno s násobností)
3. Reálných kořenů má tedy **nejvýš $n$** — komplexní kořeny se u reálných koeficientů vyskytují v **komplexně sdružených dvojicích**

Na grafu je kořen **$x$-ová souřadnice průsečíku s osou $x$** — $P(c)$ je výška grafu nad bodem $c$, takže nulová hodnota znamená, že graf sedí na ose. **Ale pozor: protnout ji nemusí.** U kořene **sudé násobnosti** se jí graf jen **dotkne a odrazí se zpátky** (třeba $(x-2)^2$) a znaménko se v něm nemění — a přesně takový kořen **metoda půlení intervalu nikdy nenajde**.

A jak se první kořen prakticky uhodne? Pomůže **věta o racionálních kořenech**:

> Má-li polynom s **celočíselnými koeficienty** racionální kořen $\frac{p}{q}$ v základním tvaru, pak $p$ **dělí absolutní člen** $a_0$ a $q$ **dělí vedoucí koeficient** $a_n$.

Kandidátů je tedy konečně mnoho a testují se Hornerem. Speciální případ, který si pamatuj zvlášť, protože je nejčastější: **je-li polynom normovaný** (tedy $a_n = 1$), musí $q$ dělit jedničku, takže $q = 1$ a **každý racionální kořen je celé číslo dělící absolutní člen**.

> **Past, na kterou se dá naletět:** u **nenormovaného** polynomu ta zjednodušená verze **neplatí** a zlomkové kořeny ti utečou. Třeba $4x^4 + 8x^3 - 33x^2 - 2x + 8$ má kořeny $2$ a $-4$, ale taky $\frac{1}{2}$ a $-\frac{1}{2}$ — a ty na seznamu celých dělitelů osmičky nejsou. Musíš vzít i $q \in \{1, 2, 4\}$, tedy kandidáty $\pm\frac{1}{2}$ a $\pm\frac{1}{4}$. **Hornerovo schéma samo o sobě žádné omezení na celá čísla nemá** — otestuje ti klidně $0{,}5$; omezený je jen seznam čísel, která mu podstrčíš.

> **Hezký důsledek, kterým můžeš zaujmout:** polynom **lichého stupně** má vždy aspoň jeden **reálný** kořen. Důvod je Bolzano — pro $x \to -\infty$ a $x \to +\infty$ má lichá mocnina opačná znaménka, polynom je spojitý, takže osu musí někde protnout. Tady se první a druhá část otázky potkávají.

---

### Hornerovo schéma

#### Odvození — je to jen vytýkání

Vezmi $P(x) = a_3x^3 + a_2x^2 + a_1x + a_0$ a vytýkej $x$, dokud to jde:

$$a_3x^3 + a_2x^2 + a_1x + a_0 = \big( (a_3 x + a_2)\,x + a_1 \big)\,x + a_0$$

Obecně:

$$P(x) = \Big( \cdots \big( (a_n x + a_{n-1})x + a_{n-2} \big) x + \cdots \Big) x + a_0$$

Z toho je vidět postup: **začni nejvyšším koeficientem, opakuj „vynásob $c$ a přičti další koeficient"**.

#### Zápis schématu

|  | $a_n$ | $a_{n-1}$ | $a_{n-2}$ | $\dots$ | $a_0$ |
|---|---|---|---|---|---|
| $c$ | | $c \cdot b_n$ | $c \cdot b_{n-1}$ | $\dots$ | $c \cdot b_1$ |
| | $b_n$ | $b_{n-1}$ | $b_{n-2}$ | $\dots$ | $\mathbf{b_0} = P(c)$ |

Sloupec po sloupci: **spadni dolů, vynásob $c$, přičti nahoře, spadni dolů.**

#### Co všechno z jednoho schématu vypadne

1. **Hodnota $P(c)$** — je to poslední číslo řádku
2. **Koeficienty podílu** $Q(x)$ při dělení $(x - c)$ — jsou to všechna čísla **kromě** posledního
3. **Zbytek po dělení** $(x-c)$ — je to zase to poslední číslo. Tomu se říká **věta o zbytku**: zbytek po dělení polynomu výrazem $(x-c)$ je roven $P(c)$
4. A tedy i **test kořene**: zbytek $= 0$ $\iff$ $c$ je kořen $\iff$ $(x-c)$ dělí $P(x)$ beze zbytku

To poslední je důvod, proč se Horner používá k **rozkladu polynomu**: uhodneš jeden kořen, vydělíš, a zbude ti polynom o stupeň nižší.

#### Složitost — tady se to potkává s okruhy 2 a 11

| Postup | Násobení | Sčítání | Složitost |
|---|---|---|---|
| naivní dosazení (každou mocninu počítám znovu) | $1+2+\dots+n = \frac{n(n+1)}{2}$ | $n$ | $\Theta(n^2)$ |
| naivní s postupným umocňováním | $2n$ | $n$ | $\Theta(n)$ |
| **Hornerovo schéma** | $n$ | $n$ | $\Theta(n)$ |

Pro $n = 100$ je to **5050 násobení proti 100**. A i proti chytřejší naivní variantě Horner ušetří polovinu násobení — dá se dokonce dokázat, že **méně násobení už to obecně nejde**.

> **Druhý argument, který zmiň, protože ho zkoušející slyší málokdy:** Horner je i **numericky stabilnější**. Nikdy nespočítá velkou mocninu $x^n$ zvlášť, takže nehrozí přetečení ani ztráta přesnosti při sečítání obřího a malého čísla. Právě proto ho používají numerické knihovny.

```python
def horner(koeficienty: list[float], c: float) -> float:
    """koeficienty od nejvyšší mocniny; vrátí P(c)"""
    vysledek = koeficienty[0]
    for a in koeficienty[1:]:
        vysledek = vysledek * c + a
    return vysledek
```

Jeden cyklus, jedno násobení a jedno sčítání v těle — složitost se dá přečíst rovnou z kódu.

---

### Numerické řešení nelineárních rovnic

#### Proč vůbec numericky

Hledáme $x$ takové, že $f(x) = 0$. Analytický vzorec ale často **neexistuje**:

- pro polynomy **5. a vyššího stupně** obecný vzorec pomocí odmocnin **neexistuje** (Abelova–Ruffiniho věta) — není to tak, že by se ještě nenašel, ale že být nemůže
- **transcendentní rovnice** jako $x = \cos x$ nebo $e^x = 3x$ nemají vzorec vůbec
- i tam, kde vzorec je, může být numericky nepoužitelný

Numerická metoda místo vzorce vyrobí **posloupnost aproximací** $x_0, x_1, x_2, \dots$, která ke kořeni konverguje. Postup je vždy dvoufázový:

1. **separace kořene** — najdi interval, kde kořen leží (graf, tabulka hodnot, změna znaménka)
2. **zpřesnění** — iteruj, dokud nejsi dost blízko

#### Kdy iteraci zastavit

- $\lvert x_{k+1} - x_k \rvert < \varepsilon$ — aproximace se přestaly hýbat
- $\lvert f(x_k) \rvert < \delta$ — funkční hodnota je dost malá
- pojistka na **maximální počet iterací** — kdyby metoda divergovala

> **Past, kterou zdůrazni:** malá $\lvert f(x_k) \rvert$ **neznamená** blízko ke kořeni. U hodně ploché funkce může být $f(x)$ skoro nula daleko od kořene, a naopak u strmé funkce znamená i velká hodnota malou vzdálenost. Proto se v praxi testují **obě** podmínky.

---

#### Metoda půlení intervalu (bisekce)

**Předpoklad:** $f$ je spojitá na $[a,b]$ a $f(a) \cdot f(b) < 0$. Bolzanova věta pak zaručuje, že uvnitř leží kořen.

**Krok:**

$$s = \frac{a+b}{2}$$

- je-li $f(a) \cdot f(s) < 0$, leží kořen vlevo $\Rightarrow$ $b := s$
- jinak leží vpravo $\Rightarrow$ $a := s$

```
        f
        │                                    ● f(b) = +
        │                                ╱
        │                            ╱
   ─────┼──────────────────●─────╱───────────────▶ x
        │   a           kořen  ╱          b
        │                  ●╱
        │           f(a) = -

   krok: spočítej f ve středu s = (a+b)/2 a podívej se na jeho ZNAMÉNKO
         -> tu polovinu, kde ke změně znaménka nedochází, zahodíš
```

**Invariant:** *kořen je pořád uvnitř aktuálního intervalu.* Ten se každým krokem zkrátí na polovinu, takže po $k$ krocích je jeho délka

$$\frac{b-a}{2^k}$$

a z požadavku, aby byla menší než $\varepsilon$, plyne potřebný počet kroků

$$k \ge \log_2 \frac{b-a}{\varepsilon}$$

**Vlastnosti:**

- **konvergence je zaručená** — jediná metoda z těch dvou, u které se nemůže nic pokazit
- ale je **pomalá**: konverguje **lineárně**, získává **jeden bit přesnosti za krok**, tedy zhruba $3{,}3$ kroku na jednu desetinnou číslici (protože $\log_2 10 \approx 3{,}32$)
- **nenajde kořen bez změny znaménka** — třeba dvojnásobný kořen u $f(x) = x^2$, kde se graf osy jen dotkne
- najde **jeden** kořen; je-li jich v intervalu víc (lichý počet), nevíš který

> **Tohle řekni nahlas:** metoda půlení intervalu **je binární vyhledávání** z [okruhu 2](../02-algoritmy-nad-seznamy/), jen přeložené z pole na reálnou osu. Roli setříděnosti tam hraje **spojitost**, roli porovnání s klíčem hraje **znaménko funkční hodnoty**, a $\log_2$ v počtu kroků je přesně ten samý logaritmus jako v $O(\log n)$ — „kolikrát se dá $n$ vydělit dvěma".

---

#### Newtonova metoda (metoda tečen)

**Nápad:** místo abych interval opatrně půlil, **nahradím funkci v okolí odhadu její tečnou** a spočítám kořen té tečny. Přímku vyřešit umím, a když je funkce hladká, leží její kořen blízko kořene tečny.

**Odvození** — tečna ke grafu v bodě $[x_k, f(x_k)]$ má rovnici

$$y = f(x_k) + f^{\prime}(x_k)\,(x - x_k)$$

Hledám, kde protne osu $x$, tedy položím $y = 0$ a vyjádřím $x$:

$$0 = f(x_k) + f^{\prime}(x_k)(x - x_k) \quad \Longrightarrow \quad \boxed{\ x_{k+1} = x_k - \frac{f(x_k)}{f^{\prime}(x_k)}\ }$$

```
   f
   │              ● [x_k, f(x_k)]
   │             ╱│
   │   tečna   ╱  │
   │         ╱    │  f(x_k)
   │       ╱      │
───┼─────●────────┼──────────▶ x
   │   x_k+1     x_k
   │
   graf se v okolí x_k nahradí PŘÍMKOU a jde se na kořen té přímky
```

**Konvergence je kvadratická:** je-li kořen jednoduchý a start dost blízko, platí $\lvert e_{k+1} \rvert \approx C \cdot e_k^2$. Prakticky to znamená, že **počet platných číslic se každým krokem zdvojnásobí** — proto stačí tři čtyři iterace.

**Kdy Newton selže** — tohle je nejčastější doptávka:

| Situace | Co se stane |
|---|---|
| $f^{\prime}(x_k) = 0$ | tečna je vodorovná, osu neprotne — ve vzorci **dělení nulou** |
| špatná počáteční aproximace | metoda může **divergovat** nebo skočit ke **kořeni úplně jinde** |
| nešťastný start | může **cyklovat**: u $f(x) = x^3 - 2x + 2$ ze startu $x_0 = 0$ vyjde $x_1 = 1$, pak zase $x_0 = 0$, a tak pořád dokola |
| **násobný** kořen | konvergence spadne z kvadratické na **lineární** |
| derivace není k dispozici | musí se počítat numericky, nebo se sáhne po metodě sečen |

**Příbuzné metody**, které se hodí zmínit jednou větou:

- **metoda sečen** — Newton bez derivace; ta se nahradí směrnicí sečny přes dva poslední body
- **metoda regula falsi** — kombinace: půlí interval, ale dělicí bod bere z průsečíku sečny, ne ze středu
- **hybridní metody** (Brentova) — v praxi nejpoužívanější; půlením se kořen bezpečně sevře a pak se přepne na rychlou metodu

---

#### Srovnání — tady výklad graduje

| | Půlení intervalu | Newtonova metoda |
|---|---|---|
| **předpoklady** | spojitost, $f(a)f(b) < 0$ | derivace, dobrá počáteční aproximace |
| **konvergence** | vždy | jen lokálně, bez záruky |
| **rychlost** | lineární — 1 bit za krok | kvadratická — číslice se zdvojnásobují |
| **kroků na 4 desetinná místa** | $\approx 14$ | $2$ až $3$ |
| **náklady na krok** | 1 vyhodnocení $f$ | vyhodnocení $f$ **i** $f^{\prime}$ |
| **násobný kořen** | nenajde (není změna znaménka) | najde, ale pomalu |

> **Věta, kterou to uzavři:** „Obě metody dělají totéž — vyrábějí posloupnost odhadů — ale platí za to jinou měnou. Půlení intervalu si kupuje **jistotu** tím, že využívá jen spojitost, a proto se z funkce dozvídá jediný bit informace za krok: znaménko. Newton si kupuje **rychlost** tím, že si od funkce vyžádá navíc derivaci, tedy i **směr a strmost** — a s touhle informací se ke kořeni přiblíží kvadraticky. Jenže jakmile ta informace zavádí, například když je tečna skoro vodorovná, ztrácí Newton i tu jistotu. Proto se v praxi kombinují."

---

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

- **Reálná funkce jedné reálné proměnné** — zobrazení $f: D \to \mathbb{R}$, kde $D \subseteq \mathbb{R}$, které každému $x \in D$ přiřadí právě jedno reálné číslo $f(x)$.
- **Definiční obor** — množina všech $x$, pro která je funkce definována.
- **Obor hodnot** — množina všech hodnot, kterých funkce na svém definičním oboru nabývá, tedy $H(f) = \{ f(x) : x \in D(f) \}$.
- **Graf funkce** — množina všech bodů $[x, f(x)]$ pro $x \in D(f)$.
- **Limita funkce v bodě** — číslo $L$ takové, že ke každému $\varepsilon > 0$ existuje $\delta > 0$ tak, že pro všechna $x$ splňující $0 < \lvert x - a \rvert < \delta$ platí $\lvert f(x) - L \rvert < \varepsilon$.
- **Spojitost v bodě** — funkce je spojitá v bodě $a$, jestliže je v něm definována, má tam limitu a tato limita se rovná funkční hodnotě, tedy $\lim_{x \to a} f(x) = f(a)$.
- **Bolzanova věta** — je-li funkce spojitá na uzavřeném intervalu $[a,b]$ a mají-li $f(a)$ a $f(b)$ opačná znaménka, pak existuje bod $c \in (a,b)$, v němž je $f(c) = 0$.
- **Polynom** — funkce tvaru $P(x) = \sum_{i=0}^{n} a_i x^i$ s reálnými koeficienty a celočíselnými nezápornými mocninami proměnné.
- **Stupeň polynomu** — nejvyšší mocnina proměnné s nenulovým koeficientem.
- **Kořen polynomu** — číslo $c$, pro které platí $P(c) = 0$.
- **Věta o kořenovém činiteli** — $c$ je kořenem polynomu $P$ právě tehdy, když lze $P$ zapsat jako $P(x) = (x - c)\,Q(x)$, kde $Q$ je polynom o stupeň nižší.
- **Hornerovo schéma** — algoritmus pro vyhodnocení polynomu v bodě založený na postupném vytýkání proměnné; současně dává koeficienty podílu při dělení kořenovým činitelem a zbytek po tomto dělení.
- **Newtonova metoda** — iterační metoda hledání kořene, v níž se další aproximace určí jako průsečík tečny ke grafu v aktuální aproximaci s osou $x$, tedy $x_{k+1} = x_k - \frac{f(x_k)}{f^{\prime}(x_k)}$.

---

### Příklad na papír

Příklady jsou dva a **kopírují dvě poloviny zadání**:

- **Příklad 1** je na první polovinu — funkce, definiční obor, obor hodnot, limita, spojitost, graf. Nakreslíš ho za půl minuty a projdeš za dvě.
- **Příklady 2 a 3** jsou na druhou polovinu a tvoří dvojici: v prvním se polynom Hornerem **rozloží úplně**, ve druhém se ukáže polynom, u kterého to nejde — **a proto se musí sáhnout po numerice**. Vazbu mezi nimi dělá zase Horner.

Ukazuj podle toho, kam tě zkoušející tlačí. Když je čas, jdou všechny tři za sebou zhruba za pět minut.

> **Slovo, kterému se vyhni:** neříkej „ukážu **průběh funkce**". *Vyšetření průběhu funkce* je odborný termín, který zahrnuje monotonii, extrémy, konvexnost a inflexní body — a to všechno se dělá **přes derivace**, tedy [okruh 5](../05-derivace-integraly-numerika/). Komise by pak čekala derivace. Říkej **„rozbor funkce"**.

---

#### Příklad 1 — rozbor funkce

##### Co se má ukázat

Že **limita a funkční hodnota jsou dvě různé věci** — a že se ten rozdíl dá vidět na obrázku. Je to jediný příklad, kde se dá naráz předvést definiční obor, obor hodnot, limita, spojitost i graf.

$$f(x) = \frac{x^2 - 1}{x - 1}$$

##### Krok 1: definiční obor

Ptám se, kde by to spadlo — jediné riziko je **nulový jmenovatel**:

$$x - 1 \ne 0 \quad \Rightarrow \quad D(f) = \mathbb{R} \setminus \{1\}$$

##### Krok 2: úprava — a past, která je v ní schovaná

Čitatel je rozdíl čtverců, takže se dá rozložit:

$$f(x) = \frac{x^2-1}{x-1} = \frac{(x-1)(x+1)}{x-1} = x + 1 \qquad \textbf{pro } x \ne 1$$

> **Tu podmínku vyslov nahlas.** Krátit smím jen tam, kde není nula, takže rovnost platí **jen mimo jedničku**. A hlavně: **úprava definiční obor nemění.** Funkce $f$ a funkce $x+1$ jsou dvě různé funkce — liší se právě v jednom bodě. Tohle je nejčastější chyba, kterou u téhle úlohy komise slyší.

##### Krok 3: graf

Grafem je tedy přímka $y = x+1$, ze které je **vypíchnutý jeden bod**:

```
       y
       │              ╱
     4 ┤            ╱
     3 ┤          ╱
     2 ┤        ○           ← [1, 2]: bod CHYBÍ, f(1) není definováno
     1 ┤      ╱
       │    ╱
   ────┼──╱───┼────┼─────▶ x
      ╱│      1    2
    ╱  │
  -1   │
```

Kroužek (ne puntík) je tady celý vtip — nakresli ho výrazně, komise se dívá právě na něj.

##### Krok 4: obor hodnot

Přímka $y = x+1$ by nabývala všech reálných hodnot, ale hodnota $2$ se ztratila spolu s vypíchnutým bodem:

$$H(f) = \mathbb{R} \setminus \{2\}$$

##### Krok 5: limita v bodě 1

Blížím se k jedničce, ale **do ní nevstupuju** — a mimo ni se funkce rovná $x+1$:

$$\lim_{x \to 1} \frac{x^2-1}{x-1} = \lim_{x \to 1} (x+1) = 2$$

Zleva i zprava vyjde totéž, takže **limita existuje** a je rovna $2$.

> **Věta, kvůli které se celý příklad počítal:** „Funkce v bodě $1$ **není definovaná**, a přesto tam **má limitu**. To je přesně ten důvod, proč se v definici limity vyžaduje $0 < \lvert x - a \rvert$ — hodnota v samotném bodě do limity nemluví."

##### Krok 6: spojitost

Spojitost v bodě $1$ měla tři podmínky. První z nich, existence $f(1)$, **neplatí** — takže funkce v bodě $1$ **spojitá není**, ačkoli limita existuje. Jde o **odstranitelnou nespojitost**: kdybych dodefinoval $f(1) = 2$, byla by funkce spojitá na celém $\mathbb{R}$.

Na množině $\mathbb{R} \setminus \{1\}$, tedy **na celém svém definičním oboru, spojitá je**.

##### Doptávka, která přijde

**„A ukažte mi nespojitost, která se odstranit nedá."** Vezmi

$$g(x) = \frac{1}{x-2}$$

- $D(g) = \mathbb{R} \setminus \{2\}$, $H(g) = \mathbb{R} \setminus \{0\}$
- jednostranné limity ve dvojce se **liší a jsou nevlastní**: $\lim_{x \to 2^-} g(x) = -\infty$, $\lim_{x \to 2^+} g(x) = +\infty$ — limita tedy **neexistuje** a jde o **pól**
- $\lim_{x \to \pm\infty} g(x) = 0$, takže osa $x$ je vodorovná asymptota

**Nuance, kterou přidej na konec:** i tahle funkce je **spojitá na celém svém definičním oboru**. „Není spojitá" a „není spojitá v bodě, který do jejího definičního oboru nepatří" jsou dvě různá tvrzení — a tohle rozlišení dělá dobrý dojem.

---

Zbylé dva příklady spolu souvisí obráceně, než by se čekalo: druhý ukáže polynom, který se rozloží **úplně a ručně**, a třetí polynom, u kterého to nejde — a proto se musí sáhnout po numerice. Přechod mezi nimi obstará zase Hornerovo schéma.

---

#### Příklad 2 — Hornerovo schéma a rozklad polynomu

##### Co se má ukázat

Že jedno schéma dá naráz **hodnotu, podíl i test kořene** — a že jeho opakovaným použitím se polynom **rozloží na kořenové činitele**.

$$P(x) = x^4 - 4x^3 - 7x^2 + 22x + 24$$

##### Krok 1: jak vůbec uhodnout první kořen

Nehádá se naslepo. Tenhle polynom je **normovaný** (vedoucí koeficient $1$) a má **celočíselné koeficienty**, takže každý racionální kořen musí být **celé číslo dělící absolutní člen**. Kandidáti jsou tedy dělitelé čísla $24$:

$$\pm 1,\ \pm 2,\ \pm 3,\ \pm 4,\ \pm 6,\ \pm 8,\ \pm 12,\ \pm 24$$

Zkoušíš je od nejmenších — a zkoušet je znamená **pustit na ně Horner**, protože ten test kořene zvládne za $n$ násobení.

> **Kdyby polynom normovaný nebyl**, musíš vzít plnou verzi věty: kandidát je $\frac{p}{q}$, kde $p$ dělí absolutní člen a $q$ vedoucí koeficient. Jinak ti **zlomkové kořeny utečou**.

##### Krok 2: první průchod, $c = -1$

Koeficienty jsou $1,\ -4,\ -7,\ 22,\ 24$:

```
            1    -4    -7    22    24
     -1 |        -1     5     2   -24
     -----------------------------------
            1    -5    -2    24     0   <- ZBYTEK 0
```

Prostřední řádek je vždy $c$ krát číslo vlevo dole: $-1\cdot 1 = -1$; $-1 \cdot (-5) = 5$; $-1 \cdot (-2) = 2$; $-1 \cdot 24 = -24$.

**Zbytek je nula, takže $-1$ je kořen** a zbylá čísla jsou koeficienty podílu:

$$P(x) = (x+1)\,(x^3 - 5x^2 - 2x + 24)$$

##### Krok 3: druhý průchod, už jen na podílu, $c = -2$

Teď pracuju s kubickým polynomem $1,\ -5,\ -2,\ 24$ — **o stupeň nižším**, takže i práce je menší:

```
            1    -5    -2    24
     -2 |        -2    14   -24
     -------------------------------
            1    -7    12     0   <- ZBYTEK 0
```

Zase nula, takže $-2$ je kořen a zbývá **kvadratická rovnice**, kterou už umím doškolsky:

$$x^2 - 7x + 12 = 0 \quad \Rightarrow \quad D = 49 - 48 = 1 \quad \Rightarrow \quad x_{1,2} = \frac{7 \pm 1}{2} = 4,\ 3$$

> **Pravidlo, které si zapamatuj:** Hornerem se hádá **jen dokud nezbude kvadratická rovnice** — tu už řeš diskriminantem. U polynomu čtvrtého stupně tedy hádáš **nejvýš dvakrát**. Zbylé dva kořeny nepřijdou z hádání, ale ze vzorce, a to i tehdy, když nejsou celá čísla. Kdo hádá dál, zbytečně se trápí — a hlavně mu **utečou kořeny, které se uhodnout nedají**.

##### Krok 4: hotový rozklad

$$x^4 - 4x^3 - 7x^2 + 22x + 24 = (x+1)(x+2)(x-3)(x-4)$$

Kořeny jsou $-1,\ -2,\ 3,\ 4$ — **čtyři kořeny u polynomu čtvrtého stupně**, přesně jak slibuje základní věta algebry, a všechny náhodou reálné.

Kontrola, která zabere pět vteřin: součin kořenových činitelů má absolutní člen $1 \cdot 2 \cdot (-3) \cdot (-4) = 24$ ✔ a součet kořenů $-1-2+3+4 = 4$, což je opravdu $-\frac{a_3}{a_4} = 4$ ✔.

##### Krok 5: co kořeny znamenají na grafu

**Kořen je $x$-ová souřadnice bodu, ve kterém graf protíná osu $x$** — protože $P(c)$ je výška grafu nad místem $c$, a nulová výška znamená, že graf sedí na ose.

```
      y
      │        ╱‾╲                              ╱
      │       ╱   ╲                            ╱
   ───●──●───╱─────╲──────────────●───────────●──▶ x
     -2 -1 ╱        ╲            3           4
      │   ╱          ╲___________╱
      │  ╱
   čtyři kořeny = čtyři PRŮSEČÍKY s osou x
```

> **Výhrada, kterou musíš znát, protože se na ni doptají:** kořen osu protnout **nemusí**. U **sudé násobnosti** se jí graf jen **dotkne a odrazí se zpět** — třeba $(x-2)^2$ má kořen $2$, ale znaménko se v něm **nemění**. A přesně tehdy **selže metoda půlení intervalu**, protože ta se řídí jedině změnou znaménka. Tady se polynomy a numerika potkávají.

##### Úspora, kterou ukaž na číslech

Pro stupeň $n$ Horner potřebuje $n$ násobení, naivní dosazení $\frac{n(n+1)}{2}$:

| $n$ | Horner | naivní dosazení |
|---|---|---|
| 4 | 4 | 10 |
| 10 | 10 | 55 |
| 100 | 100 | **5050** |

Tedy $\Theta(n)$ proti $\Theta(n^2)$ — přesně ten typ rozdílu, který znáš z [okruhu 2](../02-algoritmy-nad-seznamy/).

---

#### Příklad 3 — když rozklad nevyjde: půlení intervalu a Newton

$$x^3 - 2x - 5 = 0$$

*(Je to historicky Wallisova rovnice, na které Newton svou metodu poprvé předvedl — to se hodí prohodit.)*

##### Krok 0: proč tenhle polynom nerozložím jako ten předchozí

Zkusím na něj tentýž postup. Polynom je normovaný s celočíselnými koeficienty, absolutní člen je $-5$, takže **jediní kandidáti na racionální kořen** jsou $\pm 1$ a $\pm 5$. Hornerem (nebo rovnou dosazením) vyjde

$$P(1) = -6, \qquad P(-1) = -4, \qquad P(5) = 110, \qquad P(-5) = -120$$

— **ani jeden není nula**. Tenhle polynom tedy **nemá žádný racionální kořen**, takže rozklad na kořenové činitele s pěknými čísly z principu neexistuje a musím na kořen numericky.

> **Tohle je ten správný okamžik, kdy nadhodit Abelovu–Ruffiniho větu:** u pátého a vyššího stupně obecný vzorec pomocí odmocnin **nemůže existovat**. Numerická metoda tedy není nouzové řešení, ale jediné, které v obecném případě máme.

##### Krok 1: separace kořene

Vyhodnotím Hornerem v celých číslech — koeficienty jsou $1,\ 0,\ -2,\ -5$ a **nulu u $x^2$ nesmíš vynechat**, to je nejčastější chyba:

```
          1     0    -2    -5              1     0    -2    -5
    2 |         2     4     4        3 |         3     9    21
    ---------------------------      ---------------------------
          1     2     2    -1              1     3     7    16
```

$$P(2) = -1, \qquad P(3) = 16$$

*(Kontrola dosazením: $8-4-5 = -1$ a $27-6-5 = 16$.)* Mimochodem první schéma říká i to, že $x^3 - 2x - 5 = (x-2)(x^2+2x+2) - 1$ — nenulový zbytek přesně odpovídá tomu, že $2$ kořen není.

Znaménka jsou **opačná** a polynom je spojitý na celém $\mathbb{R}$, takže podle **Bolzanovy věty** leží v intervalu $(2, 3)$ kořen. Tuhle větu u zkoušky vyslov — to je ten okamžik, kdy se první polovina otázky napojí na druhou.

##### Krok 2: tři kroky půlení

| krok | interval | střed $s$ | $P(s)$ | znaménko | nový interval |
|---|---|---|---|---|---|
| 1 | $[2;\ 3]$ | $2{,}5$ | $+5{,}625$ | shodné s $P(3)$ | $[2;\ 2{,}5]$ |
| 2 | $[2;\ 2{,}5]$ | $2{,}25$ | $+1{,}890625$ | shodné s $P(3)$ | $[2;\ 2{,}25]$ |
| 3 | $[2;\ 2{,}25]$ | $2{,}125$ | $+0{,}345703$ | shodné s $P(3)$ | $[2;\ 2{,}125]$ |

Rozhodovací pravidlo řekni nahlas: **kořen zůstává tam, kde se znaménko mění.** Protože $P(2) < 0$ a ve všech třech středech vyšlo plus, posouvá se pokaždé pravý konec.

Délka intervalu je teď $0{,}125 = \frac{1}{2^3}$ — přesně podle vzorce $\frac{b-a}{2^k}$ s $b - a = 1$.

**Kolik kroků bych potřeboval na čtyři desetinná místa?**

$$k \ge \log_2 \frac{1}{10^{-4}} = \log_2 10^4 \approx 13{,}3 \quad \Rightarrow \quad k = 14$$

##### Krok 3: dva kroky Newtonem

Derivace je $P^{\prime}(x) = 3x^2 - 2$, startuju ze stejného bodu $x_0 = 2$:

$$x_1 = 2 - \frac{P(2)}{P^{\prime}(2)} = 2 - \frac{-1}{10} = 2{,}1$$

$$P(2{,}1) = 9{,}261 - 4{,}2 - 5 = 0{,}061, \qquad P^{\prime}(2{,}1) = 3 \cdot 4{,}41 - 2 = 11{,}23$$

$$x_2 = 2{,}1 - \frac{0{,}061}{11{,}23} = 2{,}1 - 0{,}00543 = 2{,}09457$$

Skutečný kořen je $2{,}0945515\ldots$

##### Krok 4: porovnání, kvůli kterému se to počítalo

| | odhad | chyba |
|---|---|---|
| $x_0$ | $2$ | $9{,}5 \cdot 10^{-2}$ |
| $x_1$ | $2{,}1$ | $5{,}4 \cdot 10^{-3}$ |
| $x_2$ | $2{,}09457$ | $1{,}7 \cdot 10^{-5}$ |

**Podívej se na exponenty: $-2$, $-3$, $-5$.** Chyba se v každém kroku zhruba **umocní na druhou** — to je ta kvadratická konvergence, a je to vidět na dvou řádcích tabulky, kterou stihneš u zkoušky nakreslit.

A shrnutí obou metod na jedné rovnici:

| | půlení intervalu | Newton |
|---|---|---|
| po 3 krocích víš | kořen leží v $[2;\ 2{,}125]$ | $2{,}09457$ (a to už po 2 krocích) |
| na 4 desetinná místa | **14 kroků** | **2 kroky** |
| co k tomu potřebovalo | jen znaménka $P$ | navíc derivaci $P^{\prime}$ |
| záruka | ano | žádná |

##### Doptávka, která přijde

**„A co kdybyste Newton spustil z nuly?"** Pak $P^{\prime}(0) = -2$ a $P(0) = -5$, takže $x_1 = 0 - \frac{-5}{-2} = -2{,}5$ — metoda uteče **na opačnou stranu**, daleko od kořene. Ukazuje to, proč se v praxi kořen nejdřív **separuje** (třeba pár kroky půlení) a Newton se pouští až zblízka.

> **Věta, kterou celou otázku uzavři:** „Půlení intervalu se ptá funkce jen na **znaménko** — a dostane za to jeden bit za krok, zato vždycky. Newton si vyžádá i **derivaci**, tedy směr a strmost, a za tu informaci dostane zdvojnásobení počtu platných číslic. Numerická matematika je tady celá v jedné výměně: **kolik toho o funkci vím, tolik si můžu dovolit riskovat.**"

---

### Na co se doptají

- Spočítej Hornerovým schématem hodnotu polynomu v bodě — kolik násobení jsi ušetřil?
- Co znamenají zbývající čísla v řádku Hornerova schématu, kromě toho posledního?
- Jak Hornerovým schématem poznám, že je dané číslo kořenem?
- Rozlož polynom čtvrtého stupně na kořenové činitele. Jak uhodneš první kořen?
- A co když polynom **není normovaný**? Jak se změní seznam kandidátů?
- Umí Hornerovo schéma otestovat i neceločíselný kořen?
- Co znamenají kořeny na grafu? **Musí ho vždycky protnout?**
- Napiš iterační vzorec Newtonovy metody a **odvoď** ho z rovnice tečny.
- Kolik iterací půlení potřebuji na danou přesnost a proč zrovna tolik?
- Jak poznám, že mám iterační proces ukončit? Stačí, že je $\lvert f(x_k) \rvert$ malé?
- Kdy Newtonova metoda selže? Ukaž případ, kdy diverguje nebo cykluje.
- Proč musí být u metody půlení funkce **spojitá**? Ukaž protipříklad.
- Jaký je rozdíl mezi limitou funkce v bodě a funkční hodnotou v tom bodě?
- Kdy limita v bodě neexistuje?
- Ukaž funkci, která má v bodě limitu, ale **není v něm spojitá**.
- Jaký je rozdíl mezi odstranitelnou nespojitostí a pólem?
- Změní se definiční obor, když zlomek zkrátíš?
- Uveď funkci, která je spojitá na celém $\mathbb{R}$, a funkci, která spojitá není.
- Kolik kořenů má polynom $n$-tého stupně? A kolik z nich může být reálných?
- Proč má polynom lichého stupně vždy aspoň jeden reálný kořen?
- Najdi definiční obor funkce se zlomkem a odmocninou naráz.
- Jaký je rozdíl mezi oborem hodnot a cílovou množinou?
- Kdy má funkce inverzní funkci?

### Užitečné odkazy

- <https://www.geogebra.org/calculator> (rychlé nakreslení grafu a separace kořene)
- <https://www.desmos.com/calculator> (totéž, jednodušší ovládání)
- <https://www.youtube.com/watch?v=7_vYKrVLEg8> (definiční obor a obor hodnot)
- <https://www.youtube.com/watch?v=tVF_B5p9LPE> (spojitost funkce)
- <https://www.youtube.com/watch?v=Gnfs0STbxhY> (dělení polynomu polynomem)
- <https://en.wikipedia.org/wiki/Horner%27s_method>
- <https://en.wikipedia.org/wiki/Newton%27s_method>
- `/home/valdemar/Dokumenty/SZZ/01 - SZZTP - 15m ústní/04/` — zpracování od kamaráda; má obrázky ke grafům, limitám a Hornerovu schématu
