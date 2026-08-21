## 2 — Komplexní algoritmy nad seznamy

> Komplexní algoritmy nad seznamy (filtrování, vyhledávání, třídění/řazení výběrem nebo vkládáním), efektivnější implementace vyhledávání a třídění (binární vyhledávání, merge sort), časová složitost algoritmů

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. Tři úlohy nad seznamem: **filtrování** (podmnožina dle predikátu), **vyhledávání** (najdi jeden prvek), **řazení** (přerovnej) — čím se liší výstup
2. Lineární vyhledávání — projdi vše, $O(n)$; jediná možnost nad nesetříděnými daty
3. Binární vyhledávání — **předpoklad setříděnosti**, invariant „prvek je uvnitř intervalu", půlení → $O(\log n)$
4. Řazení výběrem (selection sort) — najdi minimum, prohoď; **vždy** $O(n^2)$, ale jen $n$ výměn
5. Řazení vkládáním (insertion sort) — buduj setříděnou levou část; $O(n^2)$, ale $O(n)$ na skoro setříděném vstupu
6. Merge sort — rozděl a panuj, klíčová je operace **slévání**; $T(n) = 2T(n/2) + n \Rightarrow O(n \log n)$
7. Paměť a stabilita — merge sort potřebuje $O(n)$ navíc, kvadratické řadí in-place; stabilita a proč na ní záleží
8. Dolní mez: **porovnávacím řazením se pod $O(n \log n)$ nedá jít** — argument rozhodovacím stromem
9. Souhrnná tabulka a volba algoritmu — tady výklad graduje

**Nit, na kterou to navlékni:** naivní algoritmy prohledávají nebo přerovnávají **celý** seznam znovu a znovu — proto $O(n)$ a $O(n^2)$. Rychlé algoritmy si koupí zrychlení tím, že něco **předpokládají nebo vyrobí: uspořádání**. Binární vyhledávání ho vyžaduje na vstupu, merge sort si ho vyrábí po polovinách. Obojí vede na **půlení**, a půlení je $\log n$.

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tahák, který si vyrobíš zpaměti hned na začátku přípravy. Napsání zabere zhruba tři minuty, zbylých dvanáct pak máš na rozmyšlení příkladu.

```
FILTR:   podmnožina dle predikátu, prvky se nemění, výstup <= vstup
HLEDÁNÍ: identifikace + lokalizace JEDNOHO prvku (index / nenalezeno)
ŘAZENÍ:  permutace vstupu podle relace uspořádání, počet prvků se NEMĚNÍ

                       nejlepší  nejhorší   paměť  stabilní
  lineární hledání         1         n        1       -
  binární hledání          1       log n      1       -     SETŘÍDĚNO!
  selection sort          n²        n²        1      ne
  insertion sort           n        n²        1      ano
  merge sort            n log n   n log n     n      ano

3 NÁPADY (z nich se odvodí celá tabulka):
  půlení intervalu   -> n/2^k = 1 -> k = log n
  rozděl a panuj     -> log n hladin, na každé n práce -> n log n
  dvojí cyklus       -> n průchodů po n prvcích -> n²

MERGE SORT: T(n) = 2T(n/2) + n
  slévání: 2 setříděné -> 1, ukazatel na čelo obou, ber menší, O(n)

PASTI: binární hledání jen na SETŘÍDĚNÉM POLI (spojový seznam ne)
       selection sort nemá nejlepší případ - VŽDY n²
       insertion sort na skoro setříděném = n  -> proto v knihovnách
       stabilita = stejné klíče si udrží pořadí (řazení podle 2 kritérií)
       n log n neporazíš POROVNÁVÁNÍM (counting sort ano - neporovnává)
       O(n log n) je dolní mez: n! listů -> hloubka log n! = n log n

PŘÍKLAD: [1,3,5,7,9,11,13,15], hledám 13 -> 7, 11, 13 = 3 kroky = log 8
         slévání [1,5,7,9] + [2,3,6,8] -> 1,2,3,5,6,7,8,9
```

#### Jak si to zapamatovat, aniž bys to biflil

Tabulku **neuč nazpaměť**. Pět algoritmů se vejde do jedné věty, kde každé sloveso je jeden z nich:

> **Projdi, nebo půl. Vyber, zasuň, nebo rozděl.**

- **projdi** = lineární vyhledávání
- **půl** = binární vyhledávání
- **vyber** = selection sort (vyber nejmenší ze zbytku)
- **zasuň** = insertion sort (zasuň prvek na správné místo vlevo)
- **rozděl** = merge sort (rozděl a panuj)

A složitosti z těch sloves přímo vypadnou:

| Sloveso | Co dělá | Kolik to stojí | Proč |
|---|---|---|---|
| **projdi** | jeden průchod | $O(n)$ | koukne na každý prvek jednou |
| **půl** | zahodí půlku intervalu | $O(\log n)$ | kolikrát jde $n$ vydělit dvěma, než zbude 1 |
| **vyber** | pro každou pozici projde zbytek | $O(n^2)$ | průchod uvnitř průchodu |
| **zasuň** | pro každý prvek projde levou část | $O(n^2)$ | průchod uvnitř průchodu |
| **rozděl** | půlí, pak slévá | $O(n \log n)$ | $\log n$ hladin × $n$ práce na hladinu |

Dvě čísla, která se z ničeho neodvodí a je potřeba je znát: **insertion sort má nejlepší případ $O(n)$** (skoro setříděný vstup) a **merge sort potřebuje $O(n)$ paměti navíc**. Zbytek dopočítáš u tabule.

---

### Tři úlohy nad seznamem

Než se pustíš do algoritmů, oddělit tyhle tři věci — zkoušející je rád slyší rozlišené, protože se běžně pletou:

| Úloha | Vstup | Výstup | Změní vstup? |
|---|---|---|---|
| **filtrování** | seznam + predikát | **nový seznam** (podmnožina) | ne |
| **vyhledávání** | seznam + hledaná hodnota | **pozice** jednoho prvku (nebo „není") | ne |
| **řazení** | seznam + relace uspořádání | **tentýž seznam přerovnaný** | typicky ano |

---

### Filtrování

- **filtrování** = výběr prvků, které splňují **predikát** (podmínku vracející pravda/nepravda), do nové kolekce
- formálně $S^{\prime} = \\{\, x \in S \;;\; P(x) \,\\}$, přičemž $\lvert S^{\prime} \rvert \le \lvert S \rvert$ — počet prvků může jen klesnout
- prvky samotné se **nemění**, jen se vybírají
- složitost je **vždy $O(n)$**: predikát se musí vyhodnotit na každém prvku, protože se dopředu neví, kdo projde

```python
sudá = [x for x in [1, 5, 8, 12, 15] if x % 2 == 0]   # [8, 12]
```

> **Odlišení od vyhledávání:** filtrování vrací **kolekci** a **nikdy nemůže skončit dřív** — musí projít vše. Vyhledávání vrací **jednu pozici** a končí, jakmile prvek najde. Proto má lineární vyhledávání nejlepší případ $O(1)$, kdežto filtrování $O(n)$ vždycky.

Příbuzné operace se stejnou složitostí: **mapování** (na každý prvek aplikuj funkci) a **redukce** (sesyp seznam do jedné hodnoty, např. součet).

---

### Vyhledávání

- **vyhledávání** = **identifikace** prvku (rozhodnutí, který to je) a jeho **lokalizace** (určení pozice)
- výstup je typicky **index**, nebo příznak „nenalezeno"

#### Lineární vyhledávání

- projdi prvky od začátku, každý porovnej, při shodě vrať index
- **nevyžaduje nic** — funguje nad nesetříděnými daty i nad spojovým seznamem

| Případ | Složitost | Kdy nastane |
|---|---|---|
| nejlepší | $O(1)$ | prvek je hned první |
| průměrný | $O(n)$ | v průměru se projde polovina, $n/2$ je pořád $O(n)$ |
| nejhorší | $O(n)$ | prvek je poslední **nebo tam vůbec není** |

> **Past:** nejhorší případ nastává i tehdy, když prvek **není** v seznamu — to je ten nejčastěji zapomenutý případ, protože se musí projít všechno, aby se to dalo prohlásit.

#### Binární vyhledávání

- **předpoklad: seznam je setříděný** a umožňuje **přístup na index v $O(1)$** (tj. je to pole)
- drží se interval `left … right`, ve kterém prvek **musí být, pokud tam vůbec je** — to je **invariant**
- v každém kroku:
  1. `mid = (left + right) / 2` (celočíselně)
  2. `a[mid] == hledané` → **nalezeno**
  3. `a[mid] > hledané` → prvek může být jen vlevo → `right = mid - 1`
  4. `a[mid] < hledané` → prvek může být jen vpravo → `left = mid + 1`
- končí nalezením, nebo když interval zanikne (`left > right`) → prvek tam není

```python
def binarni_hledani(a, x):
    left, right = 0, len(a) - 1
    while left <= right:
        mid = (left + right) // 2
        if a[mid] == x:
            return mid
        elif a[mid] > x:
            right = mid - 1
        else:
            left = mid + 1
    return -1
```

**Složitost $O(\log n)$** — odvození je v [příkladu níže](#příklad-1--binární-vyhledávání). Paměťová složitost $O(1)$ (iterativně), $O(\log n)$ při rekurzivním zápisu kvůli zásobníku volání.

> **Tři pasti, na kterých se u téhle otázky padá:**
>
> 1. **Musí být setříděno.** Bez toho invariant neplatí a algoritmus vrátí nesmysl. Když se ptají „a co když není?", odpověď je: buď setřídit ($O(n \log n)$, vyplatí se až při mnoha dotazech), nebo hledat lineárně.
> 2. **Nefunguje nad spojovým seznamem.** Skok doprostřed by tam stál $O(n)$, takže by celý algoritmus spadl na $O(n)$ — a k tomu ještě s režií navíc. Binární vyhledávání potřebuje **náhodný přístup**, viz [okruh 1](../01-abstraktni-kolekce/).
> 3. **Jednorázový dotaz se nevyplatí setřiďovat.** Setřídit ($n \log n$) a pak hledat ($\log n$) je dražší než jednou projít ($n$). Vyplatí se to až při $k$ dotazech, kdy $n \log n + k \log n < k \cdot n$.

---

### Řazení

- **řazení (třídění)** = přerovnání prvků do **permutace** splňující **relaci uspořádání**, tedy $x_1 \le x_2 \le \cdots \le x_n$
- **počet prvků se nemění** — to je invariant řazení; nic nepřibude, nic nezmizí, jen se změní pořadí

Tři vlastnosti, kterými se řadicí algoritmy popisují — vyplatí se je zmínit, protože se na ně doptávají:

| Vlastnost | Co znamená |
|---|---|
| **stabilita** | prvky se **stejným klíčem** si zachovají vzájemné pořadí ze vstupu |
| **in-place** | pracuje v původním poli, potřebuje jen $O(1)$ paměti navíc |
| **porovnávací** | o prvcích zjišťuje jen to, který je menší — nesahá na jejich hodnoty jinak |

> **Proč záleží na stabilitě:** když chci seřadit lidi **podle příjmení a při shodě podle jména**, seřadím nejdřív podle jména a pak **stabilně** podle příjmení. Stabilita zaručí, že se první řazení uvnitř skupin nerozbije. S nestabilním algoritmem to takhle udělat nejde.

---

### Řazení výběrem (selection sort)

**Princip:** rozděl pole na **setříděnou levou část** a **zbytek**. V každém kroku najdi **minimum zbytku** a prohoď ho s prvním prvkem zbytku. Setříděná část se tím rozroste o jedna.

```
[ 5  3  8  1 ]   min ze zbytku = 1, prohoď s 5
[ 1 | 3  8  5 ]  min ze zbytku = 3, je na místě
[ 1  3 | 8  5 ]  min ze zbytku = 5, prohoď s 8
[ 1  3  5 | 8 ]  hotovo
```

**Složitost:** první průchod porovná $n-1$ prvků, druhý $n-2$, … dohromady

$$(n-1) + (n-2) + \cdots + 1 = \frac{n(n-1)}{2} = O(n^2)$$

| | Hodnota |
|---|---|
| porovnání | $\Theta(n^2)$ **vždy** |
| výměny | $O(n)$ — nejvýš jedna za průchod |
| paměť | $O(1)$, in-place |
| stabilní | **ne** (výměna vzdálených prvků přeskočí prvek se stejným klíčem) |

> **Past:** selection sort **nemá lepší nejlepší případ**. I na už setříděném poli musí projít všechny zbytky, aby ověřil, kde je minimum — proto je $\Theta(n^2)$, nejen $O(n^2)$. Tohle je nejčastější doptávka na rozdíl oproti insertion sortu.
>
> **Kdy se přesto hodí:** když je **zápis do paměti drahý** (třeba flash), protože dělá jen $O(n)$ výměn — nejméně ze všech jednoduchých algoritmů.

---

### Řazení vkládáním (insertion sort)

**Princip:** levá část pole je **průběžně setříděná**. Vezmi první prvek zprava, a **zasuň** ho na správné místo doleva — větší prvky se přitom posouvají o pozici doprava. Přesně tak, jak si člověk rovná karty v ruce.

```
[ 5 | 3  8  1 ]  ber 3, zasuň před 5
[ 3  5 | 8  1 ]  ber 8, je větší než 5, zůstane
[ 3  5  8 | 1 ]  ber 1, posuň 8, 5, 3 doprava, zasuň úplně vlevo
[ 1  3  5  8 ]   hotovo
```

```python
def insertion_sort(a):
    for i in range(1, len(a)):
        klic = a[i]
        j = i - 1
        while j >= 0 and a[j] > klic:   # posouvej větší doprava
            a[j + 1] = a[j]
            j -= 1
        a[j + 1] = klic                  # zasuň na uvolněné místo
```

| Případ | Složitost | Kdy |
|---|---|---|
| nejlepší | **$O(n)$** | vstup je **už setříděný** — vnitřní cyklus se ani jednou neprovede |
| průměrný | $O(n^2)$ | zasouvá se v průměru doprostřed |
| nejhorší | $O(n^2)$ | vstup je setříděný **obráceně** — každý prvek putuje až na začátek |

Paměť $O(1)$ (in-place), a je **stabilní** — podmínka `a[j] > klic` je ostrá, takže se prvek nezasune před sobě rovného.

> **Proč se to učí, když je to kvadratické:** insertion sort je na **malých a skoro setříděných** polích rychlejší než merge sort, protože nemá režii rekurze ani kopírování. Proto ho reálné knihovní algoritmy (Timsort v Pythonu, introsort v C++) používají **jako vnitřní krok** — velké pole rozdělí rychlým algoritmem a kousky pod ~16 prvků dorovnají insertion sortem. Tohle je skvělá odpověď na doptávku „k čemu to je".

---

### Merge sort

**Princip — rozděl a panuj (divide and conquer):**

1. **rozděl** pole na dvě poloviny
2. **panuj** — obě poloviny seřaď **rekurzivně** stejným postupem
3. **spoj** dvě setříděné poloviny **slitím** do jednoho setříděného pole

Rekurze končí u pole o **jednom prvku**, které je setříděné triviálně.

#### Slévání (merge) — tady je celá práce

Tohle je jádro algoritmu; dělení samotné nic nedělá, jen půlí indexy.

Mám **dvě setříděná** pole. Na čelo každého ukážu prstem. Opakovaně **porovnám oba prsty a menší prvek odeberu** do výstupu, prst posunu. Až jedno pole dojde, zbytek druhého jen dopíšu.

```
levá:  [1, 5, 7, 9]      pravá: [2, 3, 6, 8]      výstup: []
        ↑                        ↑                 1 < 2 → ber 1
levá:  [1, 5, 7, 9]      pravá: [2, 3, 6, 8]      výstup: [1]
           ↑                     ↑                 5 > 2 → ber 2
                                                   ... atd.
                                        výstup: [1,2,3,5,6,7,8,9]
```

**Proč je slévání $O(n)$:** každý krok **odebere právě jeden prvek** a žádný se nevrací. Celkem tedy tolik kroků, kolik je prvků dohromady. **Proč je správné:** menší z obou čel je nutně nejmenší ze všech zbývajících prvků, protože obě pole jsou setříděná — před čelem už nic menšího neleží.

#### Složitost

$$T(n) = \underbrace{2\,T(n/2)}_{\text{dvě poloviny}} + \underbrace{\Theta(n)}_{\text{slití}}, \qquad T(1) = \Theta(1)$$

Řešením je $T(n) = \Theta(n \log n)$ — podrobné odvození je v [příkladu níže](#příklad-2--merge-sort), obecná metoda pro řešení takových rekurencí patří k [okruhu 11](../11-rekurence-asymptotika/).

| | Hodnota |
|---|---|
| čas | $\Theta(n \log n)$ **ve všech případech** — i na setříděném vstupu |
| paměť | **$O(n)$ navíc** (pomocné pole při slévání) — není in-place |
| stabilní | **ano**, když se při rovnosti bere prvek z **levé** poloviny |

> **Past:** merge sort **nezrychlí na setříděném vstupu**. Stejně rozdělí až na jednotky a stejně sleje zpátky. To je rozdíl oproti insertion sortu a taky důvod, proč se merge sort nevyplatí na malých polích.
>
> **Druhá past:** ta $O(n)$ paměť navíc je jeho hlavní nevýhoda. Když se ptají „proč se v praxi častěji používá quicksort", odpověď je: quicksort řadí in-place a má lepší konstanty, i když má nejhorší případ $O(n^2)$. Merge sort se naopak volí tam, kde je potřeba **stabilita** nebo se řadí **externě** (data se nevejdou do paměti).

---

### Proč se pod $O(n \log n)$ nedá jít

Když se zeptají „a nejde to rychleji?", odpověď je: **porovnáváním ne**, a jde to dokázat.

- algoritmus, který o prvcích ví jen to, **který je menší**, si můžeme představit jako **rozhodovací strom**: každý vnitřní uzel je jedno porovnání, každá větev jedna ze dvou odpovědí
- aby algoritmus fungoval na libovolný vstup, musí mít strom **aspoň $n!$ listů** — tolik je permutací $n$ prvků a každá musí být dosažitelná
- binární strom s $n!$ listy má hloubku aspoň $\log_2(n!)$, a ze Stirlingovy aproximace $\log_2(n!) = \Theta(n \log n)$
- hloubka stromu = **počet porovnání v nejhorším případě** ⟹ každý porovnávací algoritmus potřebuje $\Omega(n \log n)$ porovnání

Merge sort tuhle mez **dosahuje**, je tedy asymptoticky optimální.

> **Doplněk, kterým to korunuj:** rychleji to jde jen tehdy, když se **přestane porovnávat** a využije se struktura dat — třeba **counting sort** ($O(n + k)$ pro celá čísla z malého rozsahu) nebo **radix sort**. Ty nejsou porovnávací, takže se jich dolní mez netýká. Za to platí předpoklady o vstupu.

---

### Souhrnná tabulka — tady výklad graduje

| Algoritmus | Nejlepší | Průměrný | Nejhorší | Paměť | Stabilní | Předpoklad |
|---|---|---|---|---|---|---|
| lineární vyhledávání | $O(1)$ | $O(n)$ | $O(n)$ | $O(1)$ | — | žádný |
| binární vyhledávání | $O(1)$ | $O(\log n)$ | $O(\log n)$ | $O(1)$ | — | **setříděné pole** |
| selection sort | $\Theta(n^2)$ | $\Theta(n^2)$ | $\Theta(n^2)$ | $O(1)$ | ne | žádný |
| insertion sort | **$O(n)$** | $O(n^2)$ | $O(n^2)$ | $O(1)$ | ano | žádný |
| merge sort | $\Theta(n \log n)$ | $\Theta(n \log n)$ | $\Theta(n \log n)$ | **$O(n)$** | ano | žádný |

> **Věta, kterou tabulku uzavři:** „Zrychlení se nekupuje chytřejším procházením, ale **strukturou**. Binární vyhledávání si uspořádání vynutí na vstupu, merge sort si ho vyrobí. Oboje vede na půlení, a půlení je $\log n$."

Definice $O$, $\Omega$, $\Theta$ a řešení rekurencí patří k [okruhu 11](../11-rekurence-asymptotika/), vlastnosti seznamů a polí k [okruhu 1](../01-abstraktni-kolekce/).

---

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

- **Filtrování** — výběr těch prvků vstupní kolekce, které splňují daný predikát, do nové kolekce; kardinalita výsledku je nejvýše kardinalita vstupu.
- **Predikát** — funkce vracející pravdivostní hodnotu, tedy podmínka, kterou prvek buď splňuje, nebo nesplňuje.
- **Vyhledávání** — identifikace a lokalizace konkrétního prvku v kolekci podle zadané hodnoty nebo predikátu.
- **Řazení** — transformace prvků do takové permutace vstupu, která splňuje zvolenou relaci uspořádání; počet prvků zůstává nezměněn.
- **Permutace** — přerovnání prvků, při kterém žádný prvek nechybí ani nepřebývá.
- **Invariant binárního vyhledávání** — hledaný prvek, pokud v poli je, leží vždy uvnitř aktuálního intervalu `left … right`.
- **Stabilní řazení** — řazení, které zachovává vzájemné pořadí prvků se stejným klíčem.
- **In-place algoritmus** — algoritmus vyžadující jen konstantní množství paměti nad rámec vstupu.
- **Rozděl a panuj** — postup, který úlohu rozdělí na menší podúlohy téhož typu, ty vyřeší rekurzivně a jejich řešení spojí.

---

### Příklad na papír

U zkoušky ukážeš **jeden** příklad. První je jednodušší a rychlejší nakreslit; druhý na něj **navazuje** a je působivější, takže když bude čas, jde plynule za sebou.

---

#### Příklad 1 — binární vyhledávání

##### Nejdřív: proč vůbec něco zrychlí

Mám setříděné pole a hledám v něm číslo. Naivně bych šel od začátku a koukal na každý prvek — u tisíce prvků až tisíc porovnání.

Jenže **setříděnost je informace, kterou lineární hledání vůbec nevyužívá.** Klíčové pozorování:

> Když se podívám na **prostřední** prvek a ten je **větší** než hledané číslo, pak je větší i **všechno napravo od něj** — protože pole je setříděné. Celou pravou půlku můžu zahodit, aniž bych se na ni podíval.

Jedno porovnání tedy vyřadí **polovinu** kandidátů. To je celý algoritmus.

##### Invariant — tohle řekni nahlas

Po celou dobu drží: **„pokud hledaný prvek v poli je, leží uvnitř intervalu `left … right`."** Na začátku je interval celé pole, takže to platí triviálně. Každý krok interval zmenší, ale nikdy nevyhodí prvek, který by tam mohl být — proto invariant platí i po kroku. Když interval zanikne, prvek tam být nemůže.

Tenhle způsob argumentace („co platí pořád") je přesně to, co se u zkoušky cení.

##### Konkrétní průchod

Pole o osmi prvcích, hledám **13**:

```
index:   0   1   2   3   4   5   6   7
       ┌───┬───┬───┬───┬───┬───┬───┬───┐
       │ 1 │ 3 │ 5 │ 7 │ 9 │11 │13 │15 │
       └───┴───┴───┴───┴───┴───┴───┴───┘
```

| Krok | `left` | `right` | `mid` | `a[mid]` | Porovnání | Co se stane |
|---|---|---|---|---|---|---|
| 1. | 0 | 7 | 3 | **7** | $7 < 13$ | zahodím levou půlku → `left = 4` |
| 2. | 4 | 7 | 5 | **11** | $11 < 13$ | zahodím levou půlku → `left = 6` |
| 3. | 6 | 7 | 6 | **13** | $13 = 13$ | **nalezeno na indexu 6** |

Nakresli k tomu, jak se interval smršťuje — to je ta nejnázornější část:

```
krok 1:  [ 1  3  5  7  9 11 13 15 ]   8 kandidátů, mid = 7
krok 2:  [             9 11 13 15 ]   4 kandidáti, mid = 11
krok 3:  [                  13 15 ]   2 kandidáti, mid = 13  ✓
```

**Tři kroky místo sedmi.** A `mid = (left + right) // 2`, tedy `(0+7)//2 = 3`, `(4+7)//2 = 5`, `(6+7)//2 = 6`.

##### Odvození $O(\log n)$ — tohle je pointa

Počet kandidátů po jednotlivých krocích: $n$, pak $n/2$, pak $n/4$, … po $k$ krocích zbývá $n/2^k$. Algoritmus končí, když zbude **jediný** kandidát:

$$\frac{n}{2^k} = 1 \quad\Longrightarrow\quad 2^k = n \quad\Longrightarrow\quad k = \log_2 n$$

Kontrola na příkladu: $n = 8$, $\log_2 8 = 3$ — přesně ty tři kroky.

> **Definice, kterou u toho použij:** $\log_2 n$ je odpověď na otázku **„kolikrát můžu $n$ vydělit dvěma, než dostanu jedničku?"**. Když si logaritmus vyložíš takhle, přestane být abstraktní — a stejná úvaha ti pak vysvětlí i merge sort.

##### Proč to je tak silné

| $n$ | Lineárně (nejhůř) | Binárně |
|---|---|---|
| 8 | 8 | 3 |
| 1 000 | 1 000 | 10 |
| 1 000 000 | 1 000 000 | 20 |

Milionkrát větší pole a jen dvojnásobek práce. **Tohle číslo řekni nahlas** — je to nejnázornější ilustrace toho, co znamená logaritmická složitost.

##### Doptávka, která přijde

**„A kdyby pole nebylo setříděné?"** Pak nefunguje invariant: z `a[mid] > x` neplyne nic o pravé půlce, takže bych mohl zahodit půlku, ve které prvek je. Musí se buď hledat lineárně ($O(n)$), nebo napřed setřídit ($O(n \log n)$) — a to se vyplatí až tehdy, když se v témže poli bude hledat mnohokrát.

---

#### Příklad 2 — merge sort

##### Odkud se ten nápad vzal

Kvadratické řazení dělá pořád dokola totéž: pro každý prvek projde celý zbytek. Nápad, jak z toho ven:

> **Slít dvě už setříděná pole do jednoho je levné — stačí jeden průchod.** Tak co kdybych místo řazení celku vyrobil dvě setříděné poloviny a slil je?

A jak seřadit ty poloviny? **Stejným postupem.** To je rekurze. Dělení pokračuje, dokud nezbudou pole o jednom prvku, a **jednoprvkové pole je setříděné samo od sebe** — tam se rekurze zastaví.

##### Krok, na kterém všechno stojí: slévání

Nejdřív ukaž **samotné slití**, protože bez něj zbytek nedává smysl. Mám dvě setříděná pole a prst na čele každého z nich. Vždy porovnám čela a **menší odeberu**:

| Krok | Levá (zbývá) | Pravá (zbývá) | Porovnání | Výstup |
|---|---|---|---|---|
| 1. | **1**, 5, 7, 9 | **2**, 3, 6, 8 | $1 < 2$ | 1 |
| 2. | **5**, 7, 9 | **2**, 3, 6, 8 | $5 > 2$ | 1, 2 |
| 3. | **5**, 7, 9 | **3**, 6, 8 | $5 > 3$ | 1, 2, 3 |
| 4. | **5**, 7, 9 | **6**, 8 | $5 < 6$ | 1, 2, 3, 5 |
| 5. | **7**, 9 | **6**, 8 | $7 > 6$ | 1, 2, 3, 5, 6 |
| 6. | **7**, 9 | **8** | $7 < 8$ | 1, 2, 3, 5, 6, 7 |
| 7. | **9** | **8** | $9 > 8$ | 1, 2, 3, 5, 6, 7, 8 |
| 8. | **9** | — | pravá došla | 1, 2, 3, 5, 6, 7, 8, **9** |

**Dvě věci k tomu řekni:**

- **Je to správné**, protože menší z obou čel je nutně nejmenší ze všech zbývajících — obě pole jsou setříděná, takže před čelem nic menšího neleží.
- **Je to $O(n)$**, protože každý krok odebere právě jeden prvek a žádný se nevrací. Osm prvků, nejvýš osm kroků.

##### Celý průběh na osmi prvcích

Vstup `[5, 2, 9, 1, 7, 6, 8, 3]`. Nejdřív dolů (dělení), pak nahoru (slévání):

```
                [ 5 2 9 1 7 6 8 3 ]              ← hladina 0
               /                   \
       [ 5 2 9 1 ]               [ 7 6 8 3 ]     ← hladina 1
        /       \                 /       \
    [ 5 2 ]   [ 9 1 ]         [ 7 6 ]   [ 8 3 ]  ← hladina 2
     /   \     /   \           /   \     /   \
    [5] [2]  [9]  [1]        [7]  [6]  [8]  [3]  ← hladina 3, konec rekurze

    [5] [2]  [9]  [1]        [7]  [6]  [8]  [3]
      \  /     \  /            \  /     \  /
    [ 2 5 ]   [ 1 9 ]         [ 6 7 ]   [ 3 8 ]  ← slévám po dvojicích
        \       /                 \       /
       [ 1 2 5 9 ]               [ 3 6 7 8 ]     ← slévám po čtveřicích
               \                   /
                [ 1 2 3 5 6 7 8 9 ]              ← poslední slití
```

##### Odvození $O(n \log n)$ — a tady se to spojí s prvním příkladem

Podívej se na ten obrázek jako na **tabulku hladin**:

| Hladina | Kolik částí | Velikost jedné | Práce na hladině |
|---|---|---|---|
| 0 | 1 | 8 | **8** |
| 1 | 2 | 4 | $2 \times 4 = $ **8** |
| 2 | 4 | 2 | $4 \times 2 = $ **8** |
| 3 | 8 | 1 | **8** |

**Na každé hladině se udělá práce $n$.** Není to náhoda: části se sice zmenšují, ale je jich úměrně víc, takže se to vyruší — slévání na hladině se dohromady dotkne každého prvku právě jednou.

A **kolik je hladin?** To je přesně ta otázka z prvního příkladu: kolikrát můžu $8$ vydělit dvěma, než zbude jednička? **Třikrát.** Obecně $\log_2 n$ hladin.

$$\text{celkem} = \underbrace{n}_{\text{práce na hladinu}} \times \underbrace{\log_2 n}_{\text{počet hladin}} = O(n \log n)$$

Kontrola: $8 \times 3 = 24$ kroků. Insertion sort by na osmi prvcích v nejhorším případě potřeboval $\frac{8 \cdot 7}{2} = 28$. Na osmi prvcích tedy skoro nic — ale při **tisíci prvcích** je to rozdíl mezi $10\,000$ a $500\,000$.

##### Totéž rekurentním vztahem

Když chtějí formálnější zápis, řekni to takhle: seřadit $n$ prvků znamená seřadit dvě poloviny a slít je, tedy

$$T(n) = 2\,T(n/2) + \Theta(n)$$

a jeho řešení je $T(n) = \Theta(n \log n)$. Ten vztah je **doslova přepsaný obrázek**: `2T(n/2)` jsou ty dvě větve, `Θ(n)` je slévání na dané hladině. Metody řešení rekurencí jsou v [okruhu 11](../11-rekurence-asymptotika/) — když se na ně doptají, odkaž se tam.

##### Past, na kterou se ptají

**„Zrychlí merge sort na setříděném vstupu?"** **Ne.** Rozdělí ho stejně až na jednotky a stejně sleje zpátky, takže je $\Theta(n \log n)$ vždycky. Insertion sort by ten samý vstup zvládl v $O(n)$. Právě proto reálné knihovní algoritmy oba kombinují.

---

#### Bonus: proč se insertion sort pořád používá

Až budou první dva sedět. Merge sort má lepší asymptotiku, ale na **malých polích prohrává** — má režii rekurze a kopírování do pomocného pole, kdežto insertion sort běží v jednom těsném cyklu nad souvislou pamětí.

Praktické řadicí algoritmy toho využívají: velké pole rozdělí rychlým postupem a **úseky pod zhruba 16 prvků dorovnají insertion sortem**. Timsort (Python, Java) navíc hledá v datech **už setříděné úseky (runs)** a jen je slévá — na skoro setříděném vstupu se tak dostane až na $O(n)$.

**Věta k zapamatování:** asymptotika říká, co vyhraje **pro velká $n$**. Pro malá $n$ rozhodují konstanty — a proto se algoritmy kombinují.

---

### Na co se doptají

- Odvoď složitost merge sortu z rekurentního vztahu $T(n) = 2T(n/2) + n$ (vazba na [okruh 11](../11-rekurence-asymptotika/)).
- Proč nejde binárně vyhledávat ve spojovém seznamu?
- Co znamená, že je řazení stabilní, a kdy mi to vadí?
- Insertion sort je $O(n^2)$ — proč se přesto používá uvnitř rychlých knihovních řadicích algoritmů?
- Jaký je rozdíl mezi selection a insertion sortem v nejlepším případě a proč?
- Kdy se vyplatí data setřídit, abych v nich mohl vyhledávat binárně?
- Proč se porovnávacím řazením nedá jít pod $O(n \log n)$? A jak to obchází counting sort?
- Jaká je paměťová složitost merge sortu a proč se kvůli ní v praxi často volí quicksort?
- Jaký je rozdíl mezi filtrováním a vyhledáváním? Může filtrování skončit dřív?
- Formuluj invariant binárního vyhledávání a ukaž, že se každým krokem zachová.
- Co se stane, když binární vyhledávání pustím na nesetříděné pole?

### Užitečné odkazy

- <https://visualgo.net/en/sorting> (krokovaná vizualizace všech řadicích algoritmů)
- <https://www.bigocheatsheet.com/> (přehledová tabulka složitostí)
- <https://runestone.academy/ns/books/published/pythonds/SortSearch/toc.html>
- <https://ki.ujep.cz/opory/Aplikovana_Informatika/Bc/Algoritmizace_a_programovani_I.html>
