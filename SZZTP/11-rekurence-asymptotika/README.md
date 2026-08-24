## 11 — Rekurence, speciální funkce, asymptotická notace, algoritmy

> Rekurence (vymezení, základní metody řešení [iterační a substituční metoda], řešení převodem na algebraické rovnice), speciální funkce (dolní a horní celá část, logaritmy), asymptotická notace (O-, Theta-, Omega- notace [vztahy a manipulace]), algoritmy (vymezení, Euklidův algoritmus [prvočísla, největší společný dělitel, nejmenší společný násobek])

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. Rekurentní vztah — vymezení, počáteční podmínky, kde v informatice vzniká
2. Iterační metoda — postupné rozvinutí a nalezení vzoru
3. Substituční metoda — odhad řešení a důkaz matematickou indukcí
4. Řešení převodem na algebraickou (charakteristickou) rovnici
5. Speciální funkce: dolní a horní celá část, logaritmy a pravidla pro práci s nimi
6. Asymptotická notace — definice $O$, $\Omega$, $\Theta$ přes konstanty $c$ a $n_0$; co přesně tvrdí
7. Vztahy a manipulace: $\Theta = O \cap \Omega$, hierarchie růstu
8. Algoritmus — vymezení a jeho vlastnosti
9. Euklidův algoritmus — NSD, varianta s odčítáním vs. se zbytkem, složitost
10. NSN přes NSD, souvislost s prvočísly a rozkladem na prvočinitele

**Nit, na kterou to navlékni:** rekurence je způsob, jak popsat algoritmus, asymptotická notace způsob, jak popsat jeho cenu, a Euklidův algoritmus je příklad, kde se obojí potká — jeho nejhorší případ jsou Fibonacciho čísla, což je rekurence řešená charakteristickou rovnicí.

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tahák, který si vyrobíš zpaměti hned na začátku přípravy. Je delší než u ostatních okruhů, protože otázka má čtyři samostatné části — o to důležitější je psát ho **v tomhle pořadí** a nezdržovat se u ničeho, co si dovodíš u tabule.

```
REKURENCE = vztah + POČÁTEČNÍ PODMÍNKY (bez nich není definice úplná)
  vyřešit = najít uzavřený tvar, kde vystupuje jen n

3 METODY: iterační      rozviň vztah do sebe, najdi vzor
          substituční   odhadni tvar, dokaž INDUKCÍ (i základní krok!)
          charakt. rov. lineární rekurence s konstantními koeficienty

ITERAČNÍ na T(n) = 2T(n/2) + n, T(1) = 1:
  1) rozviň 3 kroky  2) napiš k-tý krok  3) urči k  4) dosaď
  konec rekurze:  n/2^k = 1  ->  k = log n

CHARAKTERISTICKÁ ROVNICE: dosaď a_n = x^n a vyděl x^(n-2)
  a_n = c1·a(n-1) + c2·a(n-2)   ->   x² - c1·x - c2 = 0
    dva různé kořeny    a_n = A·x1^n + B·x2^n
    dvojnásobný kořen   a_n = (A + B·n)·x^n
  A, B dopočítej z počátečních podmínek

LOGARITMY: log_b a = c  <=>  b^c = a
  log(xy) = log x + log y
  změna základu: log_b x = log_c x / log_c b
  log_2 n = kolikrát můžu n půlit, než zbude jednička

CELÁ ČÁST: dolní = největší celé <= x   (-3,2 -> -4, NENÍ to useknutí!)
           dolní(n/2) + horní(n/2) = n

ASYMPTOTIKA - definici řekni doslova přes konstanty:
  f = O(g) <=> existují c>0 a n0 tak, že pro VŠECHNA n >= n0: f(n) <= c·g(n)
  Omega = otoč tu nerovnost      Theta = platí obě zároveň

HIERARCHIE: 1 < log n < √n < n < n log n < n² < n³ < 2^n < n!

ALGORITMUS: konečnost, determinovanost, hromadnost,
            rezultativnost, elementárnost

EUKLIDES: gcd(a, 0) = a,  gcd(a, b) = gcd(b, a mod b)
          gcd(a,b) · lcm(a,b) = a·b
          složitost log min(a,b), nejhorší případ = FIBONACCI (Lamé)

PASTI: "alespoň O(n)" je NESMYSL - O už samo znamená nejvýše
       O NENÍ nejhorší případ - nejdřív vyber případ, PAK ho popiš notací
       u logaritmu se základ nepíše (je to konstanta), u 2^n se psát MUSÍ
       substituční metoda bez ZÁKLADNÍHO KROKU není důkaz

PŘÍKLAD: 252 = 1·198 + 54   198 = 3·54 + 36
          54 = 1·36 + 18     36 = 2·18 + 0   ->  gcd = 18
         lcm = 252·198/18 = 2772
         a_n = 5a(n-1) - 6a(n-2)  ->  x² - 5x + 6  ->  kořeny 2 a 3
```

#### Jak si to zapamatovat, aniž bys to biflil

**Tři metody řešení jsou tři slovesa:**

> **Rozviň, hádej, nebo dosaď $x^n$.**

- **rozviň** = iterační metoda (dosazuj vztah sám do sebe, dokud neuvidíš vzor)
- **hádej** = substituční metoda (odhadni tvar a dokaž ho indukcí)
- **dosaď $x^n$** = charakteristická rovnice

A z těch sloves plyne i to, **kdy kterou použít**: *rozviň* na rekurence z rozděl a panuj (dělí se argument), *dosaď $x^n$* na ty, kde se argument snižuje o konstantu ($a_{n-1}$, $a_{n-2}$), *hádej* tehdy, když už tušíš výsledek a chceš ho jen potvrdit.

**Z asymptotiky se učí jediná definice — ta pro $O$.** Zbytek se z ní vyrobí:

| | Vznikne z $O$ takto | Čte se |
|---|---|---|
| $O$ | (základ, ten umět doslova) | „roste **nejvýš** tak rychle" — jako $\le$ |
| $\Omega$ | **otoč nerovnost** na $c\,g(n) \le f(n)$ | „roste **aspoň** tak rychle" — jako $\ge$ |
| $\Theta$ | **obě zároveň**, tedy $\Theta = O \cap \Omega$ | „roste **přesně** tak rychle" — jako $=$ |

Když si $O$, $\Omega$, $\Theta$ představíš jako $\le$, $\ge$, $=$, vyplynou z toho i všechny manipulace: dualita ($f = O(g) \iff g = \Omega(f)$) je totéž jako otočit nerovnost, tranzitivita platí stejně jako u nerovností, a „součet dá maximum" je jen tvrzení, že o výsledku rozhoduje ten větší z obou členů.

**A tři věci, které se opravdu neodvodí a je nutné je znát nazpaměť:** dva tvary řešení podle kořenů charakteristické rovnice, pět vlastností algoritmu a součin $\gcd \cdot \operatorname{lcm} = a \cdot b$ (z něj se $\operatorname{lcm}$ už jen vydělí).

#### Kde jsi tohle všechno použil v okruzích 1, 2 a 3

Tohle je nejcennější vlastnost jedenáctky: **nic z ní není nové.** V předchozích třech okruzích jsi celou dobu počítal přesně tyhle věci, jen bez jejich jmen. Když si tabulku projdeš, zjistíš, že se učíš pojmenovat, co už umíš.

| Pojem z jedenáctky | Kde už ho máš | Co jsi tam konkrétně dělal |
|---|---|---|
| **rekurence** $T(n) = 2T(n/2) + n$ | [okruh 2](../02-algoritmy-nad-seznamy/) — merge sort | „doslova přepsaný obrázek": dvě větve plus slévání |
| **iterační metoda** | [okruh 2](../02-algoritmy-nad-seznamy/) — merge sort | rozbalení $T(8) = 8\,T(1) + 8 + 8 + 8$; každé rozbalení = jedno kolo slévání |
| **$\log_2 n$ = kolikrát půlit** | [okruh 2](../02-algoritmy-nad-seznamy/) — binární vyhledávání | $n/2^k = 1 \Rightarrow k = \log_2 n$ |
| **totéž podruhé, obráceně** | [okruh 3](../03-spojove-struktury/) — výška stromu | $n \le 2^{h+1} - 1 \Rightarrow h = \log_2 n$ |
| **změna základu je konstanta** | [okruh 2](../02-algoritmy-nad-seznamy/) | proč se u $O(\log n)$ nepíše dvojka |
| **součet geometrické řady** | [okruh 1](../01-abstraktni-kolekce/) — amortizace | $1 + 2 + 4 + \cdots < 2n$, proto je `add` $O(1)$ |
| **$\Theta$ vs. $O$** | [okruh 2](../02-algoritmy-nad-seznamy/) — selection sort | $\Theta(n^2)$ **vždy**, protože nemá lepší nejlepší případ |
| **$O$ není nejhorší případ** | [okruh 2](../02-algoritmy-nad-seznamy/) — insertion sort | nejlepší $O(n)$, nejhorší $O(n^2)$ — případ a mez jsou dvě různé osy |
| **$\Omega$ jako dolní mez** | [okruh 2](../02-algoritmy-nad-seznamy/) — dolní mez řazení | rozhodovací strom, $n!$ listů, $\Omega(n \log n)$ |
| **dolní celá část** | [okruh 2](../02-algoritmy-nad-seznamy/) a [3](../03-spojove-struktury/) | `mid = (left + right) // 2`, výška $\lfloor \log_2 n \rfloor$ |
| **hierarchie růstu** | [okruh 1](../01-abstraktni-kolekce/) — souhrnná tabulka | proč je hash lepší než strom a strom než seznam |
| **paměť rekurze** | [okruh 3](../03-spojove-struktury/) — DFS | zásobník volání je $O(h)$, u degenerovaného stromu $O(n)$ |

> **Věta, kterou tuhle souvislost řekni u zkoušky:** „Rekurence popisuje, **jak** algoritmus pracuje, asymptotická notace **za kolik**. Merge sort z druhého okruhu je jedna a tatáž věc napsaná dvakrát: jednou jako obrázek stromu slévání, podruhé jako $T(n) = 2T(n/2) + n$."

Obráceně to platí taky, a hodí se to, když se ti u jiného okruhu zadrhne odvození: **kdykoli v jedničce, dvojce nebo trojce potřebuješ složitost, je to tenhle aparát.** Nemusíš si pamatovat čísla v tabulkách — stačí umět sestavit rekurenci nebo spočítat, kolikrát se něco půlí.

---

### Rekurence

- **rekurentní vztah** = předpis, který definuje hodnotu funkce (typicky posloupnosti) pomocí jejích **hodnot v menších argumentech**
- vždy se skládá ze **dvou částí** — bez druhé není definice úplná:
  1. rekurentní vztah (jak spočítat další hodnotu)
  2. **počáteční podmínky** (např. $a_0$, $a_1$)

$$a_n = f(a_{n-1}, a_{n-2}, \ldots, a_{n-k})$$

- kde na ni v informatice narazím:
  - přímo v rekurzivním kódu (faktoriál, Fibonacci, průchod stromem)
  - při **analýze složitosti** algoritmů typu rozděl a panuj — merge sort dá $T(n) = 2T(n/2) + n$
- **vyřešit rekurenci** znamená najít **uzavřený tvar** (explicitní vzorec), který závisí jen na $n$, ne na předchozích členech

#### Tři metody řešení

| Metoda | Princip | Kdy ji použít |
|---|---|---|
| iterační | rozvinu vztah do sebe, najdu vzor, sečtu | rekurence z rozděl a panuj |
| substituční | odhadnu výsledek, dokážu indukcí | když už tuším, co vyjde |
| charakteristická rovnice | převedu na algebraickou rovnici | lineární rekurence s konstantními koeficienty |

---

### Iterační metoda

Postupně dosazuji vztah sám do sebe, dokud neuvidím vzor. Pak dosadím za počet kroků takovou hodnotu, aby argument spadl na počáteční podmínku.

**Příklad:** $T(n) = 2T(n/2) + n$, $T(1) = 1$ (merge sort)

$$
\begin{aligned}
T(n) &= 2T(n/2) + n \\
     &= 2\left[2T(n/4) + \tfrac{n}{2}\right] + n = 4T(n/4) + 2n \\
     &= 4\left[2T(n/8) + \tfrac{n}{4}\right] + 2n = 8T(n/8) + 3n \\
     &\;\;\vdots \\
     &= 2^k\,T(n/2^k) + k\,n
\end{aligned}
$$

Rekurze skončí, když je argument roven $1$:

$$\frac{n}{2^k} = 1 \quad \Longrightarrow \quad k = \log_2 n$$

Dosadím zpět:

$$T(n) = n \cdot T(1) + n\log_2 n = n + n\log_2 n = \Theta(n \log n)$$

> **Postup, který u zkoušky zopakuj nahlas:** rozvinu tři kroky → napíšu obecný $k$-tý krok → určím $k$ z počáteční podmínky → dosadím.

---

### Substituční metoda

Odhadnu tvar řešení a **dokážu ho matematickou indukcí**. Nejde o „hádání výsledku“ — hádá se tvar, důkaz je regulérní.

**Příklad:** stejná rekurence $T(n) = 2T(n/2) + n$, odhad $T(n) \le c\,n\log_2 n$

*Indukční krok* — předpokládám, že tvrzení platí pro $n/2$:

$$
\begin{aligned}
T(n) &= 2T(n/2) + n \\
     &\le 2 \cdot c\,\tfrac{n}{2}\log_2\!\tfrac{n}{2} + n \\
     &= c\,n(\log_2 n - 1) + n \\
     &= c\,n\log_2 n - c\,n + n \\
     &\le c\,n\log_2 n \qquad \text{pro } c \ge 1
\end{aligned}
$$

*Základní krok* — pro $n = 2$ je $T(2) = 2T(1) + 2 = 4$ a potřebuji $4 \le c \cdot 2 \cdot \log_2 2 = 2c$, tedy $c \ge 2$.

Volbou $c = 2$ platí obojí, takže $T(n) = O(n\log n)$.

> Na základní krok se ptají — bez něj důkaz indukcí neplatí. Zároveň je běžné, že vyjde jiná podmínka na $c$ než z kroku indukčního; bere se ta silnější.

---

### Řešení převodem na algebraické rovnice

Funguje pro **lineární rekurence s konstantními koeficienty**:

$$a_n = c_1 a_{n-1} + c_2 a_{n-2}$$

Postup: dosadím $a_n = x^n$ a vydělím $x^{n-2}$. Vznikne **charakteristická rovnice**:

$$x^2 - c_1 x - c_2 = 0$$

Podle kořenů:

| Kořeny | Obecné řešení |
|---|---|
| dva různé $x_1 \ne x_2$ | $a_n = A x_1^n + B x_2^n$ |
| dvojnásobný kořen $x$ | $a_n = (A + Bn)\,x^n$ |

Konstanty $A$, $B$ dopočítám z počátečních podmínek.

#### Příklad — dva různé kořeny

$a_n = 5a_{n-1} - 6a_{n-2}$, $a_0 = 1$, $a_1 = 4$

$$x^2 - 5x + 6 = 0 \;\Longrightarrow\; (x-2)(x-3) = 0 \;\Longrightarrow\; x_1 = 2,\; x_2 = 3$$

$$a_n = A\cdot 2^n + B\cdot 3^n$$

$$
\begin{aligned}
a_0: &\quad A + B = 1 \\
a_1: &\quad 2A + 3B = 4
\end{aligned}
\quad\Longrightarrow\quad B = 2,\; A = -1
$$

$$\boxed{a_n = 2\cdot 3^n - 2^n}$$

*Kontrola:* $a_2 = 5\cdot4 - 6\cdot1 = 14$, ze vzorce $2\cdot 9 - 4 = 14$ ✓

#### Příklad — dvojnásobný kořen

$a_n = 4a_{n-1} - 4a_{n-2}$, $a_0 = 1$, $a_1 = 3$

$$x^2 - 4x + 4 = 0 \;\Longrightarrow\; (x-2)^2 = 0 \;\Longrightarrow\; x = 2 \text{ (dvojnásobný)}$$

$$a_n = (A + Bn)\,2^n, \qquad A = 1,\; B = \tfrac12 \;\Longrightarrow\; a_n = \left(1 + \tfrac{n}{2}\right)2^n$$

*Kontrola:* $a_2 = 4\cdot3 - 4\cdot1 = 8$, ze vzorce $(1+1)\cdot4 = 8$ ✓

#### Fibonacci — příklad, který stojí za to umět

$F_n = F_{n-1} + F_{n-2}$, $F_0 = 0$, $F_1 = 1$

$$x^2 - x - 1 = 0 \;\Longrightarrow\; x_{1,2} = \frac{1 \pm \sqrt5}{2}$$

Větší kořen je **zlatý řez** $\varphi = \frac{1+\sqrt5}{2} \approx 1{,}618$. Po dosazení počátečních podmínek vyjde **Binetův vzorec**:

$$F_n = \frac{\varphi^n - \psi^n}{\sqrt5}, \qquad \psi = \frac{1-\sqrt5}{2}$$

Protože $\lvert \psi \rvert < 1$, druhý člen rychle mizí a **Fibonacciho čísla rostou exponenciálně jako $\varphi^n$**. Tenhle fakt použij dole u složitosti Euklidova algoritmu.

---

### Dolní a horní celá část

$$\lfloor x \rfloor = \max\{m \in \mathbb{Z} \mid m \le x\} \qquad \lceil x \rceil = \min\{m \in \mathbb{Z} \mid m \ge x\}$$

- $\lfloor 3{,}7 \rfloor = 3$, $\lceil 3{,}2 \rceil = 4$, $\lfloor -3{,}2 \rfloor = -4$ ← pozor na záporná čísla, není to „useknutí“
- základní nerovnost: $x - 1 < \lfloor x \rfloor \le x \le \lceil x \rceil < x + 1$
- $\lfloor n/2 \rfloor + \lceil n/2 \rceil = n$ pro celé $n$
- **k čemu to je:** rozdělení seznamu na půl u merge sortu a binárního vyhledávání, výška binárního stromu, počet úrovní rekurze — všude tam, kde musí vyjít celé číslo

### Logaritmy

$$\log_b a = c \iff b^c = a$$

- $\log(xy) = \log x + \log y$
- $\log\frac{x}{y} = \log x - \log y$
- $\log(x^k) = k\log x$
- **změna základu:** $\log_b x = \dfrac{\log_c x}{\log_c b}$
- $b^{\log_b x} = x$, $\log_b 1 = 0$, $\log_b b = 1$

> **Klíčový důsledek pro asymptotiku:** změna základu je jen násobení konstantou $\frac{1}{\log_c b}$. Proto se v $O$-notaci **základ logaritmu nepíše** — $O(\log n)$ je jednoznačné. U exponenciál to ale **neplatí**: $2^n$ a $3^n$ nejsou asymptoticky totéž.

- $\lfloor \log_2 n \rfloor$ = kolikrát mohu $n$ půlit, než dojdu k jedničce → odtud logaritmy v binárním vyhledávání a ve vyvážených stromech

---

### Asymptotická notace

Nástroj na porovnávání **rychlosti růstu funkcí pro $n \to \infty$**. Zanedbává konstanty a členy nižšího řádu, protože o chování pro velké vstupy nerozhodují.

#### $O$ — horní mez

$$f(n) = O(g(n)) \iff \exists\, c > 0,\, n_0 > 0:\; \forall n \ge n_0:\; 0 \le f(n) \le c\cdot g(n)$$

Od jistého $n_0$ leží $f$ **pod** křivkou $c\cdot g$. „Neroste rychleji než.“

#### $\Omega$ — dolní mez

$$f(n) = \Omega(g(n)) \iff \exists\, c > 0,\, n_0 > 0:\; \forall n \ge n_0:\; 0 \le c\cdot g(n) \le f(n)$$

Od jistého $n_0$ leží $f$ **nad** křivkou $c\cdot g$. „Roste alespoň tak rychle jako.“

#### $\Theta$ — těsná mez

$$f(n) = \Theta(g(n)) \iff \exists\, c_1, c_2 > 0,\, n_0:\; \forall n \ge n_0:\; c_1 g(n) \le f(n) \le c_2 g(n)$$

$f$ je sevřená **mezi** dvěma násobky $g$. „Roste přesně tak rychle jako.“

$$\Theta(g) = O(g) \cap \Omega(g)$$

#### Důkaz z definice — tohle chtějí vidět

Tvrzení: $3n^2 + 5n + 2 = \Theta(n^2)$

*Horní mez:* pro $n \ge 1$ platí $n \le n^2$ a $1 \le n^2$, takže

$$3n^2 + 5n + 2 \le 3n^2 + 5n^2 + 2n^2 = 10n^2$$

volím $c_2 = 10$, $n_0 = 1$.

*Dolní mez:* pro $n \ge 1$ je $3n^2 + 5n + 2 \ge 3n^2$, volím $c_1 = 3$, $n_0 = 1$.

Obě meze platí od $n_0 = 1$, tedy $3n^2 + 5n + 2 = \Theta(n^2)$. ∎

---

### Vztahy a manipulace

- **analogie s nerovnostmi:** $O \sim {\le}$, $\Omega \sim {\ge}$, $\Theta \sim {=}$
- **dualita:** $f = O(g) \iff g = \Omega(f)$
- **konstanty se zahazují:** $O(c \cdot f) = O(f)$ pro konstantní $c > 0$
- **součet → maximum:** $O(f + g) = O(\max(f, g))$ — proto rozhoduje dominantní člen
- **součin:** $O(f)\cdot O(g) = O(f \cdot g)$ — vnořené cykly
- **tranzitivita:** $f = O(g) \wedge g = O(h) \Rightarrow f = O(h)$
- **reflexivita:** $f = \Theta(f)$

#### Hierarchie růstu

$$1 \;<\; \log n \;<\; \sqrt{n} \;<\; n \;<\; n\log n \;<\; n^2 \;<\; n^3 \;<\; 2^n \;<\; n!$$

#### Dvě pasti, na kterých se padá

1. **„Algoritmus má složitost alespoň $O(n)$.“** Nesmysl — $O$ už samo o sobě znamená „nejvýše“. „Alespoň“ vyžaduje $\Omega$.
2. **$O$ není totéž co nejhorší případ.** Notace popisuje růst funkce, ne to, o který případ jde. Nejdřív si vyberu případ (nejhorší / nejlepší / průměrný) a **teprve ten** popíšu notací. Klidně můžu říct „v nejlepším případě $\Theta(1)$“ nebo „v nejhorším případě $\Theta(n^2)$“. Časté zjednodušení „$O$ = worst case, $\Omega$ = best case“ je **nesprávné**.

---

### Algoritmus

- **vymezení:** konečný, přesně definovaný postup (posloupnost kroků), který pro zadaný vstup vede k požadovanému výstupu
- **vlastnosti** — na tyhle se ptají jmenovitě:

| Vlastnost | Význam |
|---|---|
| konečnost (finitnost) | skončí po konečném počtu kroků |
| determinovanost | každý krok je jednoznačně určen, nic není na náhodě |
| hromadnost (obecnost) | řeší celou třídu úloh, ne jeden konkrétní vstup |
| rezultativnost | vždy dá nějaký výsledek |
| elementárnost | kroky jsou dostatečně jednoduché a proveditelné |

### Euklidův algoritmus

Nalezení **největšího společného dělitele** dvou čísel.

**Varianta se zbytkem** (rychlá, ta se používá):

$$\gcd(a, 0) = a, \qquad \gcd(a, b) = \gcd(b,\; a \bmod b)$$

**Varianta s odčítáním** (názornější, ale pomalá — pro $\gcd(1000, 1)$ udělá tisíc kroků):

```
dokud a ≠ b:
    je-li a > b:  a ← a − b
    jinak:        b ← b − a
vrať a
```

**Proč to funguje:** každý společný dělitel čísel $a$ a $b$ dělí i jejich rozdíl $a - kb$, tedy i zbytek $a \bmod b$. Množina společných dělitelů se tím nemění — jen pracuji s menšími čísly.

#### Výpočet krok za krokem

$$
\begin{aligned}
252 &= 1 \cdot 198 + 54 \\
198 &= 3 \cdot 54 + 36 \\
 54 &= 1 \cdot 36 + 18 \\
 36 &= 2 \cdot 18 + 0 \quad \leftarrow \text{zbytek } 0, \text{ konec}
\end{aligned}
$$

$$\gcd(252, 198) = 18$$

*Kontrola rozkladem:* $252 = 2^2\cdot3^2\cdot7$, $198 = 2\cdot3^2\cdot11$ → společné $2\cdot3^2 = 18$ ✓

#### Složitost

$$O(\log \min(a,b))$$

**Nejhorší případ nastává pro dvě po sobě jdoucí Fibonacciho čísla** (Lamého věta) — tehdy je každý podíl roven jedné a čísla klesají nejpomaleji, jak můžou. Protože Fibonacciho čísla rostou jako $\varphi^n$ (viz charakteristická rovnice výše), je počet kroků logaritmický.

> Tohle je nejhezčí místo celé otázky — spojuje rekurence, charakteristickou rovnici i asymptotiku. Řekni to.

### Prvočísla, NSD a NSN

- **prvočíslo** = přirozené číslo $p > 1$ dělitelné pouze jedničkou a sebou samým
- **základní věta aritmetiky:** každé přirozené číslo větší než 1 lze **jednoznačně** (až na pořadí) rozložit na součin prvočísel
- hledání prvočísel: **Eratosthenovo síto**

Z rozkladu na prvočinitele:

- **NSD** = součin společných prvočinitelů s **nejmenším** exponentem
- **NSN** = součin všech prvočinitelů s **největším** exponentem

Klíčový vztah, přes který se NSN počítá:

$$\gcd(a,b) \cdot \operatorname{lcm}(a,b) = a \cdot b \qquad \Longrightarrow \qquad \operatorname{lcm}(a,b) = \frac{a \cdot b}{\gcd(a,b)}$$

$$\operatorname{lcm}(252, 198) = \frac{252 \cdot 198}{18} = \frac{49\,896}{18} = 2772$$

*Kontrola rozkladem:* $2^2\cdot3^2\cdot7\cdot11 = 2772$ ✓

> **Prakticky:** NSN se nikdy nepočítá hledáním násobků. Spočítá se NSD Euklidem a použije se vzorec. Dělit se má **před** násobením, aby nedošlo k přetečení.

---

### Příklad na papír

Tahle otázka má tu výhodu, že se **jedním příkladem dá projít celá**. Vejde se na jednu A4 ve dvou sloupcích: vlevo rekurence, vpravo Euklides.

```
┌──────────────────────────┬──────────────────────────┐
│  1) REKURENCE            │  2) EUKLIDES             │
│     T(n) = 2T(n/2) + n   │     gcd(252, 198)        │
│                          │                          │
│     iterační metoda      │     4 dělení se zbytkem  │
│     -> Θ(n log n)        │     -> 18                │
│                          │                          │
│     substituční ověření  │     lcm ze vzorce        │
│     (odhad + indukce)    │     -> 2772              │
│                          │                          │
│                          │     nejhorší případ =    │
│                          │     Fibonacci -> x²-x-1  │
└──────────────────────────┴──────────────────────────┘
```

---

#### Příklad 1 — rekurence merge sortu

##### Krok 1: napiš zadání a řekni, odkud je

$$T(n) = 2T(n/2) + n, \qquad T(1) = 1$$

Nahlas k tomu řekni: *„Seřadit $n$ prvků znamená seřadit dvě poloviny a slít je. `2T(n/2)` jsou ty dvě poloviny, `+n` je slévání. Je to merge sort z [druhého okruhu](../02-algoritmy-nad-seznamy/)."* Tím máš rovnou obhájené, proč ta rekurence vypadá takhle — a to je první věc, na kterou se ptají.

##### Krok 2: rozviň tři kroky a najdi vzor

Dosazuj vztah sám do sebe. **Nepočítej to v hlavě** — piš to pod sebe, vzor se ukáže sám:

$$
\begin{aligned}
T(n) &= 2T(n/2) + n \\
     &= 2\left[2T(n/4) + \tfrac{n}{2}\right] + n \;=\; 4T(n/4) + 2n \\
     &= 4\left[2T(n/8) + \tfrac{n}{4}\right] + 2n \;=\; 8T(n/8) + 3n
\end{aligned}
$$

Teď se podívej na to, **co se mění a jak**:

| Po $k$ krocích | Koeficient u $T$ | Argument uvnitř $T$ | Přičteno navíc |
|---|---|---|---|
| 0 | $1$ | $n$ | $0$ |
| 1 | $2$ | $n/2$ | $1n$ |
| 2 | $4$ | $n/4$ | $2n$ |
| 3 | $8$ | $n/8$ | $3n$ |
| **$k$** | $\mathbf{2^k}$ | $\mathbf{n/2^k}$ | $\mathbf{k\,n}$ |

Poslední řádek je celý smysl iterační metody:

$$T(n) = 2^k\,T(n/2^k) + k\,n$$

> **Co říct nahlas:** *„Koeficient se pokaždé zdvojnásobí, argument se pokaždé půlí, a pokaždé přibude jedno $n$. Po $k$ krocích je tedy koeficient $2^k$, argument $n/2^k$ a přičteno $k$-krát $n$."*

##### Krok 3: urči $k$ z počáteční podmínky

Rozvíjení nemůže jít donekonečna — skončí, až se argument dostane na $1$, protože pro $T(1)$ mám hodnotu zadanou:

$$\frac{n}{2^k} = 1 \quad\Longrightarrow\quad 2^k = n \quad\Longrightarrow\quad k = \log_2 n$$

**Tohle je ten samý výpočet jako u binárního vyhledávání** — „kolikrát můžu $n$ půlit, než zbude jednička".

##### Krok 4: dosaď zpátky

$$T(n) = \underbrace{2^{\log_2 n}}_{=\;n}\cdot\, T(1) + n\log_2 n = n \cdot 1 + n\log_2 n = n + n\log_2 n$$

To $2^{\log_2 n} = n$ plyne přímo z definice logaritmu — *„dvojka na to, kolikrát se dvojka vejde do $n$, je $n$."* Kdyby se doptali, tohle je odpověď.

A protože $n$ roste pomaleji než $n\log n$, člen nižšího řádu se zahodí:

$$\boxed{T(n) = \Theta(n\log n)}$$

##### Kontrola na číslech — a pozor na jednu věc

Pro $n = 8$ je $k = 3$, tedy $T(8) = 8 + 8\cdot3 = 8 + 24 = 32$.

V [okruhu 2](../02-algoritmy-nad-seznamy/) ti u merge sortu vyšlo **24**. Není to spor a stojí za to vědět, proč:

- **24** je práce **jen slévání** (3 kola × 8 prvků)
- **32** je $24$ **plus** $8$ za osm jednoprvkových polí, kde rekurze končí — to je ten člen $n\cdot T(1)$

Rozdíl je člen nižšího řádu, který $\Theta$ zahodí. **Obojí je $\Theta(n\log n)$.** Když se tě někdo zeptá, proč se ta osmička ztratila, řekneš přesně tohle — a je to hezká ukázka toho, co asymptotická notace dělá.

##### Krok 5: ověření substituční metodou

Iterační metoda vzor **našla**, substituční ho **dokáže**. Odhad tedy vezmi z výsledku: $T(n) \le c\,n\log_2 n$.

*Indukční krok* — předpokládám, že tvrzení platí pro $n/2$, a dosadím ho do rekurence:

$$
\begin{aligned}
T(n) &= 2T(n/2) + n \\
     &\le 2 \cdot c\,\tfrac{n}{2}\log_2\!\tfrac{n}{2} + n && \text{(sem jde indukční předpoklad)} \\
     &= c\,n(\log_2 n - 1) + n && \log_2\tfrac{n}{2} = \log_2 n - 1 \\
     &= c\,n\log_2 n - c\,n + n \\
     &\le c\,n\log_2 n && \text{platí, když } -cn + n \le 0, \text{ tedy } c \ge 1
\end{aligned}
$$

*Základní krok* — pro $n = 2$ je $T(2) = 2T(1) + 2 = 4$ a potřebuji $4 \le c\cdot2\cdot\log_2 2 = 2c$, tedy $c \ge 2$.

Obě podmínky splní **$c = 2$**, takže $T(n) = O(n\log n)$. ∎

> **Dvě věci, které tady zaznít musí:**
>
> 1. **Bez základního kroku to není důkaz indukcí.** Na to se ptají cíleně — indukční krok sám o sobě jen říká „když to platí pro menší, platí i pro větší", ale nikdo neřekl, že to vůbec někdy platí.
> 2. **Vyšly dvě různé podmínky na $c$** ($c \ge 1$ a $c \ge 2$) a bere se ta **silnější**. Tohle je nejčastější místo, kde se v substituční metodě chybuje.
>
> A ještě jedno rozlišení, kterým zaujmeš: iterační metoda dala $\Theta$, substituční jen $O$ — protože jsem dokazoval nerovnost jedním směrem. Pro $\Theta$ bych musel stejně dokázat i dolní odhad $T(n) \ge c\,n\log_2 n$.

---

#### Příklad 2 — Euklidův algoritmus

##### Výpočet

Opakovaně děl se zbytkem a **posouvej dvojici čísel doleva**, dokud nevyjde nula:

$$
\begin{aligned}
252 &= 1 \cdot 198 + \mathbf{54} \\
198 &= 3 \cdot 54 + \mathbf{36} \\
 54 &= 1 \cdot 36 + \mathbf{18} \\
 36 &= 2 \cdot 18 + \mathbf{0} \quad \leftarrow \text{zbytek } 0
\end{aligned}
$$

**Výsledek je poslední nenulový zbytek: $\gcd(252,198) = 18$.**

##### Proč to funguje — tohle je ta pointa

*„Každý společný dělitel čísel $a$ a $b$ dělí i jejich rozdíl, a tedy i zbytek $a \bmod b$. Množina společných dělitelů se tím **nemění** — jen pracuju s menšími čísly. A protože čísla klesají, jednou musím dojít k nule."*

To je zároveň důkaz správnosti **i** konečnosti, obojí ve dvou větách.

##### Nejmenší společný násobek

$$\operatorname{lcm}(252,198) = \frac{252 \cdot 198}{18} = \frac{49\,896}{18} = 2772$$

*Kontrola rozkladem:* $252 = 2^2\cdot3^2\cdot7$, $198 = 2\cdot3^2\cdot11$ → $\gcd = 2\cdot3^2 = 18$ ✓, $\operatorname{lcm} = 2^2\cdot3^2\cdot7\cdot11 = 2772$ ✓

> **Zmiň, že se má dělit před násobením** — $252 \cdot 198$ může u velkých čísel přetéct, kdežto $252/18 \cdot 198$ ne.

##### Složitost — a tady se otázka spojí dohromady

Tohle je nejhezčí místo celého okruhu, protože **použije všechny tři jeho části najednou**. Řekni to jako řetěz:

1. **Kdy je Euklides nejpomalejší?** Když čísla klesají co nejpomaleji, tedy když je každý podíl roven jedné. To nastane právě pro **dvě po sobě jdoucí Fibonacciho čísla** — to je **Lamého věta**.
2. **Jak rychle rostou Fibonacciho čísla?** To zjistím **charakteristickou rovnicí**: z $F_n = F_{n-1} + F_{n-2}$ dosazením $x^n$ vyjde $x^2 - x - 1 = 0$, jejíž větší kořen je **zlatý řez** $\varphi = \frac{1+\sqrt5}{2} \approx 1{,}618$. Fibonacciho čísla tedy rostou **exponenciálně** jako $\varphi^n$.
3. **Závěr:** když nejhorší vstup velikosti $n$ potřebuje zhruba $\log_\varphi n$ kroků, je složitost $O(\log \min(a,b))$ — **logaritmická, protože nejhorší případ roste exponenciálně**.

$$\text{Fibonacci roste jako } \varphi^n \;\Longrightarrow\; \text{počet kroků roste jako } \log n$$

> **Věta na závěr celé otázky:** *„Tady se to všechno potká — rekurence popsala Fibonacciho čísla, charakteristická rovnice je vyřešila, a asymptotická notace z toho udělala složitost algoritmu."*

##### Kdyby tlačil čas

Zkrať to na **tři řádky**: čtyři dělení → $\gcd = 18$ → $\operatorname{lcm}$ ze vzorce. Fibonacciho souvislost pak jen **řekni**, kreslit ji nemusíš.

---

### Na co se doptají

- Vyřeš $T(n) = 2T(n/2) + n$ iterační metodou.
- Zapiš definici $O$-notace přes $c$ a $n_0$ a ukaž na příkladu, že $3n^2 + 5n$ je $O(n^2)$.
- Proč je zápis „algoritmus má složitost alespoň $O(n)$“ nesmysl?
- Odvoď složitost Euklidova algoritmu — proč je logaritmická?
- Proč se v $O(\log n)$ neuvádí základ logaritmu? A proč se u $2^n$ základ uvést musí?
- Jaký je rozdíl mezi $O$ a $\Theta$? Kdy nemůžu použít $\Theta$?
- Co musí obsahovat úplná definice rekurence?
- Jak spočítáš NSN, když máš k dispozici jen Euklidův algoritmus?

### Značky a symboly

Průřez značkami, které potkáš **napříč celým SZZTP** — nejen v téhle otázce. Nemusíš je umět psát, ale musíš je umět **přečíst nahlas**, protože se objevují v zadáních a zkoušející je píše na tabuli.

#### Logika a důkazy

| Značka | Čte se | Znamená |
|---|---|---|
| $\forall$ | „pro každé" | platí pro všechny prvky |
| $\exists$ | „existuje" | aspoň jeden takový prvek je |
| $\exists!$ | „existuje právě jeden" | existuje a je jediný |
| $\Rightarrow$ | „implikuje", „pak" | když platí levá strana, platí i pravá |
| $\Leftrightarrow$ | „právě tehdy, když" | platí obě implikace naráz — **ekvivalence** |
| $\neg$, $\overline{A}$ | „non", „negace" | opak |
| $\wedge$ | „a zároveň" | konjunkce |
| $\vee$ | „nebo" | disjunkce (nevylučovací!) |
| $\oplus$ | „xor" | právě jedno z dvojice |
| $\blacksquare$, $\square$, ∎ | „což bylo dokázat" | konec důkazu (QED) |
| $:$ nebo $\mid$ v definici | „takové, že" | odděluje podmínku |

#### Množiny

| Značka | Čte se | Znamená |
|---|---|---|
| $\in$ / $\notin$ | „je prvkem" / „není prvkem" | příslušnost |
| $\subseteq$ / $\subset$ | „je podmnožinou" / „vlastní podmnožinou" | u $\subset$ nesmí být rovnost |
| $\cup$ / $\cap$ | „sjednocení" / „průnik" | |
| $\setminus$ | „mínus", „bez" | rozdíl množin |
| $\emptyset$ | „prázdná množina" | |
| $\lvert A \rvert$ | „mohutnost", „počet prvků" | u čísel absolutní hodnota |
| $\mathcal{P}(A)$, $2^A$ | „potenční množina" | množina všech podmnožin |
| $A \times B$ | „kartézský součin" | množina všech dvojic |
| $\mathbb{N}, \mathbb{Z}, \mathbb{Q}, \mathbb{R}$ | přirozená, celá, racionální, reálná čísla | |

#### Čísla a funkce

| Značka | Čte se | Znamená |
|---|---|---|
| $\lfloor x \rfloor$ | „dolní celá část" | největší celé $\le x$; $\lfloor -3{,}2 \rfloor = -4$ |
| $\lceil x \rceil$ | „horní celá část" | nejmenší celé $\ge x$ |
| $a \mid b$ | „$a$ dělí $b$" | $b$ je násobkem $a$ — **pozor, není to zlomek** |
| $a \bmod b$ | „a modulo b" | zbytek po dělení |
| $a \equiv b \pmod m$ | „kongruentní modulo $m$" | dávají stejný zbytek |
| $n!$ | „en faktoriál" | $1\cdot2\cdots n$; počet permutací |
| $\binom{n}{k}$ | „en nad ká" | kombinační číslo |
| $\sum$ / $\prod$ | „suma" / „součin" | sečti / vynásob přes rozsah |
| $\approx$ / $\ne$ / $\pm$ | „přibližně" / „nerovná se" / „plus minus" | |
| $\infty$ | „nekonečno" | |
| $\to$ | „jde k", „konverguje k" | $n \to \infty$ |

#### Asymptotická notace

| Značka | Čte se | Znamená | Analogie |
|---|---|---|---|
| $O(g)$ | „velké ó" | roste **nejvýš** tak rychle | $\le$ |
| $\Omega(g)$ | „omega" | roste **aspoň** tak rychle | $\ge$ |
| $\Theta(g)$ | „théta" | roste **přesně** tak rychle | $=$ |
| $o(g)$ | „malé ó" | roste **striktně pomaleji** | $<$ |
| $\omega(g)$ | „malá omega" | roste **striktně rychleji** | $>$ |

> Malé $o$ a $\omega$ se u zkoušky nechtějí, ale když je zmíníš jako ostré verze, ukážeš, že notaci opravdu rozumíš.

#### Řecká písmena, která u tebe padnou

| Písmeno | Čte se | Kde na něj narazíš |
|---|---|---|
| $\alpha$ | alfa | faktor zaplnění hashe ([okruh 1](../01-abstraktni-kolekce/)); hladina významnosti ([okruh 9](../09-intervaly-spolehlivosti/)) |
| $\varphi$ | fí | zlatý řez $\approx 1{,}618$ (Fibonacci, Euklides) |
| $\psi$ | psí | druhý kořen v Binetově vzorci |
| $\varepsilon$ | epsilon | „libovolně malé kladné číslo" — limity ([okruh 4](../04-funkce-polynomy-nelinearni-rovnice/)) |
| $\Delta$ | delta | rozdíl, přírůstek; diskriminant |
| $\mu$, $\sigma$, $\sigma^2$ | mí, sigma | střední hodnota, směrodatná odchylka, rozptyl ([okruh 8](../08-nahodna-velicina/)) |
| $\lambda$ | lambda | parametr Poissonova a exponenciálního rozdělení |
| $\chi^2$ | chí kvadrát | rozdělení pro interval spolehlivosti rozptylu ([okruh 9](../09-intervaly-spolehlivosti/)) |
| $\Sigma$ | velká sigma | suma |
| $\pi$ | pí | $3{,}14\ldots$; taky součin ($\prod$) |

### Užitečné odkazy

- <https://www.bigocheatsheet.com/> (přehled složitostí)
- <https://visualgo.net/en> (vizualizace algoritmů a datových struktur)
- `/home/valdemar/Dokumenty/SZZ/01 - SZZTP - 15m ústní/11/` — zpracování od kamaráda; má navíc obrázky ke grafům mezí a k celým částem, ale iterační a substituční metodu nemá vyplněné
