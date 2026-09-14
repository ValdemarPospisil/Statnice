## Co se naučit nazpaměť — SZZTP

Zpět na [rozcestník SZZTP](../).

**Tohle je jediný soubor, ze kterého se biflí.** Všechno ostatní v poznámkách se dá odvodit, dovyprávět nebo ukázat na příkladu — tyhle věci ne. Když si zapamatuješ tuhle stránku, jsi u kterékoli z deseti otázek schopný napsat tahák a mít z čeho stavět.

> **Jak to používat:** projdi to odshora dolů a u každé položky si řekni *„odvodím, nebo musím znát?"*. Co je tady, to odvodit nejde. Co tady není, to **nedrť** — to se ukáže na papíře.

---

## 0. Nejdůležitější věta celé zkoušky

> **Řekni, jak přesně zněla tvoje otázka, a pak řekni, čemu se budeš věnovat.**

Platí u **všech** okruhů a je to první věta, kterou u tabule vyslovíš. U [okruhu 10](../10-logika-mnoziny-relace/) je z konzultace potvrzeno, že se zkoušející rovnou zeptá, o čem chceš mluvit.

---

## 1. Čísla, která znát nazpaměť

Je jich málo. Tohle je celý seznam:

| Číslo | Kde | Co to je |
|---|---|---|
| **1,96** | [09](../09-intervaly-spolehlivosti/) | $u_{0{,}975}$ — kvantil pro 95% interval |
| 1,645 | [09](../09-intervaly-spolehlivosti/) | $u_{0{,}95}$ — pro 90 % |
| 2,576 | [09](../09-intervaly-spolehlivosti/) | $u_{0{,}995}$ — pro 99 % |
| **68 – 95 – 99,7** | [08](../08-nahodna-velicina/) | % hodnot v 1σ, 2σ, 3σ u normálního rozdělení |
| **0,75** | [01](../01-abstraktni-kolekce/) | práh zaplnění hashe, pak zdvojnásobit |
| **3,5** a **35/12 ≈ 2,92** | [08](../08-nahodna-velicina/) | $E(X)$ a $D(X)$ hrací kostky |
| 16 | [10](../10-logika-mnoziny-relace/) | počet binárních spojek |

**Z nich 1,96 a 68-95-99,7 jsou povinné.** Ostatní se dají odvodit nebo obejít.

---

## 2. Definice, které musíš říct doslova

Tohle jsou věty, kde na formulaci záleží. Ostatní pojmy říkej vlastními slovy.

### Funkce a limita — [okruh 4](../04-funkce-polynomy-nelinearni-rovnice/)

- **Funkce** — zobrazení, které **každému** $x$ z definičního oboru přiřadí **právě jedno** $y$.
- **Limita** — $\lim_{x \to a} f(x) = L$, právě když ke každému $\varepsilon > 0$ existuje $\delta > 0$ tak, že pro $0 < \lvert x - a \rvert < \delta$ platí $\lvert f(x) - L \rvert < \varepsilon$.
  - **Existuje** $\iff$ limita zleva = limita zprava.
  - **V bodě $a$ funkce definovaná být nemusí** — to je celý smysl limity.
- **Spojitost v bodě $a$** — tři podmínky naráz: $f(a)$ existuje, limita existuje, a **rovnají se**.

### Derivace a integrál — [okruh 5](../05-derivace-integraly-numerika/)

- **Derivace** — $f^{\prime}(x) = \lim_{h \to 0} \dfrac{f(x+h) - f(x)}{h}$; geometricky **směrnice tečny**, fyzikálně okamžitá rychlost.
- **Primitivní funkce** — $F$ je primitivní k $f$, když $F^{\prime}(x) = f(x)$. Dvě primitivní se liší **jen o konstantu**.
- **Určitý integrál** — limita Riemannových součtů, geometricky **znaménkový obsah** pod křivkou.

### Pravděpodobnost — [okruhy 8](../08-nahodna-velicina/) a [9](../09-intervaly-spolehlivosti/)

- **Náhodná veličina** — zobrazení z prostoru elementárních jevů do $\mathbb{R}$ (pokusu přiřadí číslo).
- **Distribuční funkce** — $F(x) = P(X \leq x)$. Funguje pro diskrétní i spojité.
- **Interpretace intervalu spolehlivosti** ⚠️ — *„Opakoval-li bych výběr mnohokrát, 95 % takto sestrojených intervalů by pokrylo skutečný parametr."*
  - **NE**: „parametr tam leží s pravděpodobností 95 %" — parametr je **konstanta**, náhodné jsou **meze**.

### Logika a množiny — [okruh 10](../10-logika-mnoziny-relace/)

- **Výrok** — sdělení deklarativního typu, u kterého **má smysl uvažovat o pravdivostní hodnotě**.
- **Tautologie** — pravdivá při **každém** ohodnocení. **Kontradikce** — nepravdivá při každém. **Splnitelná** — pravdivá **alespoň při jednom**, tj. není kontradikce.
- **Úplný systém spojek** — množina spojek, kterou lze vyjádřit **každou** pravdivostní funkci.
- **Rozklad množiny** — systém **neprázdných**, **po dvou disjunktních** podmnožin, jejichž **sjednocením** je celá $A$. (Tři podmínky, vyjmenuj je.)
- **Binární relace** — **podmnožina kartézského součinu**, $R \subseteq A \times B$.
- **Ekvivalence** — reflexivní + symetrická + tranzitivní.
- **Uspořádání** — antisymetrická + tranzitivní; **neostré** navíc reflexivní, **ostré** antireflexivní.

### Grafy — [okruh 12](../12-grafy-stromy/)

- **Graf** — uspořádaná dvojice $G = (V, E)$, $V$ neprázdná množina vrcholů, $E$ množina hran.
- **Strom** — souvislý acyklický graf. (Ekvivalentně: souvislý s $n-1$ hranami; ekvivalentně: mezi každými dvěma vrcholy **právě jedna** cesta.)
- **Eulerovský tah** — tah obsahující **všechny hrany** grafu.
- **Hamiltonovská cesta** — cesta obsahující **všechny vrcholy**.

---

## 3. Vzorce, které se neodvodí

### Derivace — [okruh 5](../05-derivace-integraly-numerika/)

```
(x^n)'  = n·x^(n-1)         (e^x)' = e^x         (ln x)' = 1/x
(sin)'  = cos               (cos)' = -sin

součin   (uv)'    = u'v + uv'
podíl    (u/v)'   = (u'v - uv') / v²
složená  [f(g)]'  = f'(g) · g'

tečna:   y = f(x0) + f'(x0)·(x - x0)      ...jen přímka bodem se směrnicí
```

### Numerika — [okruhy 4](../04-funkce-polynomy-nelinearni-rovnice/) a [5](../05-derivace-integraly-numerika/)

```
NEWTON       x_(k+1) = x_k - f(x_k) / f'(x_k)        ...z rovnice tečny, y=0

DERIVOVÁNÍ   dopředná   [f(x+h) - f(x)]   / h        chyba O(h)
             centrální  [f(x+h) - f(x-h)] / 2h       chyba O(h²)

INTEGRACE    lichoběžník  h/2 · [f0 + 2(f1+...+f_n-1) + fn]     O(h²)
             Simpson      h/3 · [f0 + 4·liché + 2·sudé + fn]    O(h⁴), n SUDÉ

OBJEM ROTAČNÍHO TĚLESA    V = π · ∫ f(x)² dx
```

### Pravděpodobnost — [okruh 8](../08-nahodna-velicina/)

```
D(X) = E(X²) - [E(X)]²        <- výpočetní tvar, tenhle používej
E(aX + b) = a·E(X) + b
D(aX + b) = a²·D(X)           <- posun b rozptyl NEMĚNÍ

rozdělení          E(X)        D(X)
alternativní A(p)   p          p(1-p)
binomické Bi(n,p)   np         np(1-p)
Poissonovo Po(λ)    λ          λ           <- E = D, to je jeho poznávací znamení
rovnoměrné R(a,b)   (a+b)/2
normální N(μ,σ²)    μ          σ²
exponenciální E(λ)  1/λ
```

### Intervaly spolehlivosti — [okruh 9](../09-intervaly-spolehlivosti/)

**Jeden vzorec, ne čtyři:**

```
                odhad  ±  kvantil · střední chyba

1) μ, σ ZNÁM      x̄ ± u(1-α/2) · σ/√n
2) μ, σ NEZNÁM    x̄ ± t(n-1) · s/√n          <- t je ŠIRŠÍ než u
3) podíl          p̂ ± u(1-α/2) · √(p̂(1-p̂)/n)

s² = Σ(xi - x̄)² / (n-1)        <- POZOR na n-1
```

**Rozptyl (χ²) se nezkouší** — stačí říct, že interval je nesymetrický.

### Kombinatorika a počty — [okruhy 10](../10-logika-mnoziny-relace/) a [12](../12-grafy-stromy/)

```
k-árních spojek       2^(2^k)          k=2 -> 16
podmnožin             2^n              |Pot(A)| = 2^n
relací mezi A a B     2^(|A|·|B|)
úplný graf K_n        n(n-1)/2 hran
strom                 n-1 hran
```

---

## 4. Věty a podmínky

| Věta | Znění | Okruh |
|---|---|---|
| **Bolzano** | $f$ spojitá na $\langle a,b \rangle$ a $f(a) \cdot f(b) < 0$ $\Rightarrow$ **existuje kořen** v $(a,b)$ | [04](../04-funkce-polynomy-nelinearni-rovnice/) |
| **Newton–Leibniz** | $\int_a^b f = F(b) - F(a)$ | [05](../05-derivace-integraly-numerika/) |
| **Podání ruky** | $\sum \deg(v) = 2\lvert E \rvert$ $\Rightarrow$ **lichých vrcholů je vždy sudý počet** | [12](../12-grafy-stromy/) |
| **Euler — kružnice** | souvislý graf ji má **právě tehdy, když** jsou **všechny** stupně sudé | [12](../12-grafy-stromy/) |
| **Euler — tah** | souvislý graf ho má **právě tehdy, když** má **0 nebo 2** liché vrcholy | [12](../12-grafy-stromy/) |
| **Dirac** (Hamilton) | všechny stupně $\geq n/2$ (pro $n \geq 3$) $\Rightarrow$ kružnice existuje. **Jen postačující!** | [12](../12-grafy-stromy/) |

**`⇔` se čte „právě tehdy, když"** a znamená, že platí **oba směry** — proto u Eulera umíš rozhodnout i neexistenci. U Diraca to neplatí.

### Odvozovací pravidla — [okruh 10](../10-logika-mnoziny-relace/)

| Jméno | Z čeho | Plyne |
|---|---|---|
| **modus ponens** | $p \Rightarrow q$ a $p$ | $q$ |
| **modus tollens** | $p \Rightarrow q$ a $\neg q$ | $\neg p$ |
| **hypotetický sylogismus** | $p \Rightarrow q$ a $q \Rightarrow r$ | $p \Rightarrow r$ |
| ~~obrácení~~ | $p \Rightarrow q$ a $q$ | **nic!** (potvrzování konsekventu) |

### Vlastnosti relací — [okruh 10](../10-logika-mnoziny-relace/)

```
reflexivita     (x,x) ∈ R pro VŠECHNA x
antireflexivita (x,x) ∉ R pro ŽÁDNÉ x
symetrie        (x,y) => (y,x)
antisymetrie    (x,y) a (y,x)  =>  x = y
tranzitivita    (x,y) a (y,z)  =>  (x,z)
```

### Pět vlastností algoritmu — [okruh 11](../11-rekurence-asymptotika/)

**Konečnost, determinovanost, hromadnost, rezultativnost, elementárnost.** Tohle se odvodit nedá, je to výčet.

### Asymptotika — [okruh 11](../11-rekurence-asymptotika/)

```
f = O(g)  <=>  existují c>0 a n0 tak, že pro VŠECHNA n >= n0: f(n) <= c·g(n)

Omega = otoč nerovnost        Theta = obě zároveň
O ~ "<="        Omega ~ ">="        Theta ~ "="

HIERARCHIE: 1 < log n < √n < n < n log n < n² < n³ < 2^n < n!
```

**Definici $O$ umět doslova přes konstanty $c$ a $n_0$** — to chtějí slyšet. Zbytek se z ní odvodí.

### Charakteristická rovnice — [okruh 11](../11-rekurence-asymptotika/)

```
a_n = c1·a(n-1) + c2·a(n-2)   ->   x² - c1·x - c2 = 0

dva různé kořeny     a_n = A·x1^n + B·x2^n
dvojnásobný kořen    a_n = (A + B·n)·x^n
```

**Tyhle dva tvary se neodvodí, ty se musí znát.** $A$ a $B$ se dopočítají z počátečních podmínek.

### Euklides — [okruh 11](../11-rekurence-asymptotika/)

```
gcd(a, 0) = a          gcd(a, b) = gcd(b, a mod b)
gcd(a,b) · lcm(a,b) = a·b        <- odtud lcm vydělením
```

---

## 5. Složitosti

Většinu odvodíš z mechanismu, ale tyhle tabulky se vyplatí znát rovnou.

### Kolekce — [okruh 1](../01-abstraktni-kolekce/)

```
                  přístup   vložení      výmaz
statické pole        1         n           n
dynamické pole       1         1* konec    n
spojový seznam       n         1  začátek  1 s referencí
hash tabulka         1 prům    1 prům      1 prům
vyvážený strom     log n     log n       log n
zásobník / fronta    1         1           1
                               * amortizovaně
```

**Tři mechanismy, ze kterých to plyne:** souvislá paměť → adresa se **spočítá**; ukazatele → jen se **přepojí**; hash → index **z klíče**.

### Řazení a hledání — [okruh 2](../02-algoritmy-nad-seznamy/)

```
                    nejlepší  nejhorší  paměť  stabilní
lineární hledání        1        n        1      -
binární hledání         1      log n      1      -     SETŘÍDĚNO!
selection sort         n²       n²        1     ne     ...nemá lepší případ
insertion sort          n       n²        1     ano
merge sort          n log n  n log n      n     ano    ...vždy stejně
```

### Stromy a grafy — [okruhy 3](../03-spojove-struktury/) a [12](../12-grafy-stromy/)

```
BVS: vyhledání, vložení i výmaz = O(h)
     h = log n vyvážený    |    h = n-1 degenerovaný
     n = 2^(h+1) - 1       <- odtud h = log n

DFS i BFS:  O(V + E) seznam sousedů   |   O(V²) matice
```

---

## 6. Pasti — tady se padá

Tohle je nejcennější část. U ústní zkoušky rozhodují právě ty.

| Past | Správně |
|---|---|
| „parametr leží v intervalu s $p = 95\%$" | **interval pokryl parametr**; náhodné jsou meze, ne parametr |
| $O$ = nejhorší případ | **ne** — nejdřív vyber případ, **pak** ho popiš notací |
| „alespoň $O(n)$" | **nesmysl** — $O$ už samo znamená *nejvýš* |
| hustota = pravděpodobnost | hustota **může být větší než 1**; u spojité je $P(X=a) = 0$ |
| rozptyl a směrodatná odchylka | rozptyl je v **druhých mocninách** jednotky, proto se odmocňuje |
| $E(X^2)$ jako součet | je to **průměr** druhých mocnin — dělí se stejným $n$ jako $E(X)$ |
| výběrový rozptyl dělit $n$ | **$n-1$!** Jinak rozptyl podceňuješ |
| splnitelná = tautologie | **ne** — tautologie *vždy*, splnitelná *aspoň jednou* |
| z $p \Rightarrow q$ a $q$ plyne $p$ | **neplyne** — potvrzování konsekventu |
| antisymetrie zakazuje smyčky | **nezakazuje** — zakazuje jen dvě různé protisměrné šipky |
| antireflexivita = negace reflexivity | **ne** — relace může být ani jedno |
| Euler má 1 lichý vrchol | **nemůže** — z principu podání ruky je jich sudý počet |
| Euler = vrcholy | **hrany**. Hamilton = vrcholy |
| DFS najde nejkratší cestu | **ne**, jen BFS — a jen v **nevážený** grafu (jinak Dijkstra) |
| binární hledání ve spojovém seznamu | **nejde** — není skok na index |
| selection sort na setříděném poli je rychlý | **není** — $\Theta(n^2)$ vždy |
| setříděný vstup do BVS | **degeneruje na seznam**, $O(n)$ místo $O(\log n)$ |
| výmaz z jednosměrného seznamu | potřebuje **předchůdce** → $O(n)$ |
| `tail` v jednosměrném = $O(1)$ výmaz z konce | **ne** — vložení ano, výmaz $O(n)$ |
| $\int \sin$ od 0 do $2\pi$ = obsah | integrál je **0**, obsah je **4** — pod osou se počítá záporně |
| $f^{\prime} = 0$ znamená extrém | **nestačí** — $x^3$ v nule má $f^{\prime}=0$ a extrém tam není |
| substituční metoda bez základního kroku | **není důkaz** — indukce má **dva** kroky |
| moc malé $h$ u numerické derivace | **ztráta přesnosti** — odčítáš skoro stejná čísla |
| Simpson s lichým $n$ | **$n$ musí být sudé** |
| u $\log n$ psát základ | **nepíše se** (je to konstanta), ale u $2^n$ **psát musíš** |
| `O(1)` u hashe | je to **průměr**, ne nejhorší případ |

---

## 7. Nitě — jedna věta ke každému okruhu

Když zapomeneš všechno ostatní, tohle tě vrátí do hry.

| # | Okruh | Nit |
|---|---|---|
| [1](../01-abstraktni-kolekce/) | Kolekce | **ADT říká co, implementace za kolik.** Tři mechanismy: souvislá paměť, ukazatele, hash |
| [2](../02-algoritmy-nad-seznamy/) | Algoritmy | **Tři nápady:** půlení ($\log n$), rozděl a panuj ($n \log n$), dvojí cyklus ($n^2$) |
| [3](../03-spojove-struktury/) | Spojové struktury | **Přepojení zadarmo, ale musí se dojít.** Vše je $O(h)$, a $h$ závisí na tvaru |
| [4](../04-funkce-polynomy-nelinearni-rovnice/) | Funkce | **Když to nejde vyřešit vzorcem, obklíčím to numericky.** Bolzano je licence na půlení |
| [5](../05-derivace-integraly-numerika/) | Derivace, integrály | **Derivace a integrál jsou opačné operace.** Numerika nastupuje, kde primitivní funkce není |
| [8](../08-nahodna-velicina/) | Náhodná veličina | **Pokusu přiřadím číslo a pak popíšu, jak se chová.** $F$ funguje pro oba druhy |
| [9](../09-intervaly-spolehlivosti/) | Intervaly spolehlivosti | **Poctivé přiznání nejistoty.** Jeden vzorec, liší se jen kvantil |
| [10](../10-logika-mnoziny-relace/) | Logika, množiny | **Složité se poskládá z jednoduchého** — a všude vyjde mocnina dvojky |
| [11](../11-rekurence-asymptotika/) | Rekurence, asymptotika | **Rekurence popisuje jak, asymptotika za kolik.** Rozviň, hádej, nebo dosaď $x^n$ |
| [12](../12-grafy-stromy/) | Grafy | **Euler chodí po hranách, Hamilton po vrcholech.** DFS vs. BFS = zásobník vs. fronta |

---

## 8. Co se NEUČIT

Ať nemarníš čas — tyhle věci se u tabule **odvodí nebo odhadnou**:

- **Hodnoty $t$ a $\chi^2$ kvantilů** — čtou se z tabulek. Stačí říct *„bude větší než 1,96, takže interval bude širší"*.
- **Všech 16 binárních spojek vypsat** — stačí umět **odvodit, proč jich je 16**.
- **Interval spolehlivosti pro rozptyl** — z konzultace: **nezkouší se**.
- **Predikátový počet do hloubky** — z konzultace: **nikdo si ho nevybírá**.
- **Konkrétní čísla ve složitostních tabulkách** — odvodíš z mechanismu.
- **Hodnota $\log_2 5$ a podobné** — stačí odhad mezi mocninami dvojky.
- **Znění definice $\Omega$ a $\Theta$** — otočíš, resp. spojíš definici $O$.
