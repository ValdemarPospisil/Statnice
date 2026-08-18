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

Protože $|\psi| < 1$, druhý člen rychle mizí a **Fibonacciho čísla rostou exponenciálně jako $\varphi^n$**. Tenhle fakt použij dole u složitosti Euklidova algoritmu.

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

#### Příklad na papír

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

Jeden příklad, kterým se dá projít celá otázka — nacvič si ho tak, abys ho psal a mluvil zároveň:

1. Napiš $T(n) = 2T(n/2) + n$, $T(1) = 1$ a řekni, že to je merge sort.
2. Vyřeš **iterační metodou** → $\Theta(n\log n)$.
3. Ověř **substituční metodou** (odhad + indukce, včetně základního kroku).
4. Spočítej $\gcd(252, 198)$ Euklidem a dopočítej $\operatorname{lcm}$ ze vzorce.
5. Dodej, že nejhorší případ Euklida jsou Fibonacciho čísla, a napiš jejich charakteristickou rovnici $x^2 - x - 1 = 0$.

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

### Užitečné odkazy

- <https://www.bigocheatsheet.com/> (přehled složitostí)
- <https://visualgo.net/en> (vizualizace algoritmů a datových struktur)
- `/home/valdemar/Dokumenty/SZZ/01 - SZZTP - 15m ústní/11/` — zpracování od kamaráda; má navíc obrázky ke grafům mezí a k celým částem, ale iterační a substituční metodu nemá vyplněné
