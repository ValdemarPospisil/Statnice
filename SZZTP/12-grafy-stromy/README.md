## 12 — Grafy, stromy, eulerovské a hamiltonovské grafy, prohledávání

> Grafy (definice orientovaného a neorientovaného grafu, jejich vlastnosti a reprezentace, význačné typy grafů), stromy (vymezení a základní charakteristiky, binární stromy a jejich reprezentace), eulerovské a hamiltonovské grafy (eulerovský tah, hamiltonovská kružnice a cesta), prohledávání do hloubky a do šířky

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. **Definice grafu** $G = (V, E)$ — neorientovaný (hrana je **množina** $\\{u,v\\}$) vs. orientovaný (hrana je **dvojice** $(u,v)$)
2. **Stupeň vrcholu** a princip podání ruky: $\sum \deg(v) = 2\lvert E \rvert$ — z něj plyne skoro celý Euler
3. **Sled, tah, cesta** — co se smí opakovat; uzavřený vs. otevřený, kružnice
4. **Souvislost** a komponenty
5. **Reprezentace:** matice sousednosti vs. seznam sousedů — paměť $O(V^2)$ vs. $O(V+E)$, kdy co
6. **Význačné typy:** úplný, bipartitní, regulární, acyklický, strom, les
7. **Stromy** — tři ekvivalentní charakterizace, $n-1$ hran, mezi dvěma vrcholy **právě jedna** cesta
8. **Binární strom** a jeho reprezentace (odkazy vs. pole) — podrobně v [okruhu 3](../03-spojove-struktury/)
9. **Eulerovský tah a kružnice** — podmínka přes **počet lichých vrcholů** (0 nebo 2), sedm mostů královeckých
10. **Hamiltonovská cesta a kružnice** — vypadá podobně, ale je **NP-úplná**; žádná jednoduchá podmínka neexistuje
11. **DFS** — zásobník/rekurze, jde do hloubky, použití na cykly a komponenty
12. **BFS** — fronta, po vrstvách, **najde nejkratší cestu** v nevážený grafu
13. **Složitost obou:** $O(V + E)$ se seznamem sousedů, $O(V^2)$ s maticí

**Nit, na kterou to navlékni:** graf je **nejobecnější struktura ze všech, co jsi v předchozích okruzích viděl** — seznam je graf, strom je graf, a i binární relace z [okruhu 10](../10-logika-mnoziny-relace/) **je** orientovaný graf. Pak jsou v otázce **dvě dvojice, které vypadají stejně a chovají se úplně jinak**, a v tom kontrastu je celá její pointa. **Euler versus Hamilton**: hrany versus vrcholy — a přitom jeden se rozhodne pohledem na stupně, druhý je NP-úplný. **DFS versus BFS**: tentýž kód, jen zásobník místo fronty — a přitom jen jeden z nich najde nejkratší cestu.

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tahák, který si vyrobíš zpaměti hned na začátku přípravy. Napsání zabere zhruba tři minuty, zbylých dvanáct pak máš na rozmyšlení příkladu — u téhle otázky hlavně na **nakreslení grafu**, protože bez obrázku se tahle látka nedá vykládat.

```
GRAF G = (V, E)     V = vrcholy (neprázdná),  E = hrany
  NEORIENTOVANY  hrana = mnozina {u,v}   {u,v} = {v,u}
  ORIENTOVANY    hrana = dvojice (u,v)   (u,v) != (v,u)

PODANI RUKY:  suma stupnu = 2 * pocet hran
  -> lichych vrcholu je VZDY sudy pocet

SLED  -> muze se opakovat vse
TAH   -> neopakuje HRANU
CESTA -> neopakuje VRCHOL  (tim padem ani hranu)
uzavreny = zacatek == konec.   KRUZNICE = uzavrena cesta

REPREZENTACE          pamet        je hrana?   sousedi v
  matice sousednosti  V^2          O(1)        O(V)
  seznam sousedu      V + E        O(stupen)   O(stupen)
  -> RIDKY graf: seznam.   HUSTY nebo casty dotaz na hranu: matice

STROM = souvisly + acyklicky   <=>  n-1 hran + souvisly
                               <=>  mezi kazdymi 2 vrcholy PRAVE JEDNA cesta
  les = graf, jehoz komponenty jsou stromy

EULER (HRANY, projit kazdou prave jednou)
  tah      <=> souvisly a lichych vrcholu je 0 nebo 2 (start/konec v nich)
  kruznice <=> souvisly a VSECHNY stupne sude
  Konigsberg: stupne 5,3,3,3 -> 4 liche -> NEJDE
HAMILTON (VRCHOLY, projit kazdy prave jednou)
  NP-uplny, jednoducha podminka NEEXISTUJE
  jen postacujici: Dirac - kazdy stupen >= n/2 (n >= 3) -> kruznice existuje

DFS zasobnik/rekurze  jde do hloubky, vraci se       cykly, komponenty, topolog.
BFS fronta            po vrstvach                    NEJKRATSI CESTA (nevazeny)
  oba: O(V + E) seznam sousedu,  O(V^2) matice
  pamet: DFS O(h) hloubka,  BFS O(sirka) nejsirsi vrstva

PASTI: liche vrcholy 0 nebo 2, NIKDY 1 (plyne z podani ruky)
       Euler = hrany, Hamilton = vrcholy
       DFS nejkratsi cestu NENAJDE
       BFS jen v NEVAZENEM grafu (jinak Dijkstra)
```

#### Jak si z toho odvodit zbytek

- **Sled – tah – cesta si nepamatuj jako tři definice, ale jako zpřísňování.** Sled nezakazuje nic, tah zakáže opakovat hranu, cesta zakáže i vrchol. **Každá cesta je tah a každý tah je sled** — ne naopak.
- **Princip podání ruky si odvoď za dvě vteřiny:** každá hrana má dva konce a každý konec přidá 1 k něčímu stupni. Tedy $\sum \deg(v) = 2\lvert E \rvert$. **Odtud plyne, že lichých vrcholů je vždy sudý počet** — a proto u Eulera nikdy nemůže vyjít „1 lichý vrchol".
- **Eulerovu podmínku si neber jako fakt, ale odvoď ji:** procházíš-li vrcholem, jednou hranou přijdeš a jinou odejdeš — spotřebuješ **dvě** hrany. Takže každý *průchozí* vrchol musí mít sudý stupeň. Lichý smí být jen **start a cíl**. Odtud rovnou: 0 lichých = uzavřený tah (kružnice), 2 liché = otevřený tah, cokoli jiného = nejde.
- **Kterou reprezentaci zvolit, si rozmysli přes paměť, ne přes rychlost.** Matice zabere $V^2$ **bez ohledu na počet hran** — u milionu vrcholů je to $125$ GB i pro graf o pěti hranách. Seznam zabere $V + E$.
- **DFS a BFS je jeden kód.** Vážně: rozdíl je **jediný řádek** — jestli odebíráš ze zásobníku, nebo z fronty. Když si to zapamatuješ takhle, nemusíš si pamatovat dva algoritmy.
- **Proč BFS najde nejkratší cestu, si odvoď z toho slova „vrstva":** BFS zpracuje **napřed všechny vrcholy ve vzdálenosti 1, pak všechny ve vzdálenosti 2** atd. Když na vrchol narazí poprvé, kratší cesta k němu už existovat nemůže — jinak by ho našel v dřívější vrstvě.

#### Jak si to zapamatovat, aniž bys to biflil

> **Euler chodí po hranách, Hamilton po vrcholech. Jeden je snadný, druhý NP-úplný.**

Celá otázka jsou **dvě dvojice postavené proti sobě** a stačí umět ten kontrast:

| | Euler | Hamilton |
|---|---|---|
| co se navštíví právě jednou | **hrana** | **vrchol** |
| jak poznám, že existuje | podívám se na **stupně** | **nijak** — musím zkoušet |
| složitost rozhodnutí | $O(V + E)$ | **NP-úplné** |

| | DFS | BFS |
|---|---|---|
| struktura | **zásobník** (nebo rekurze) | **fronta** |
| jak postupuje | do hloubky, pak se vrací | po vrstvách |
| nejkratší cesta | **ne** | **ano** (v nevážený grafu) |
| paměť | $O(h)$ — hloubka | $O(\text{šířka})$ — nejširší vrstva |

**Ten druhý řádek paměti je pěkná doptávka:** u velmi širokého mělkého grafu je úspornější DFS, u hlubokého úzkého BFS. Není to tak, že by jeden byl vždycky lepší.

##### Kde to navazuje na ostatní okruhy

Tohle je poslední okruh a **skoro nic v něm není nové** — je to zastřešení všeho předchozího:

| Co tady | Kde to už bylo | Jak to spolu souvisí |
|---|---|---|
| **relace = orientovaný graf** | binární relace, [okruh 10](../10-logika-mnoziny-relace/) | uzlový graf relace **je** orientovaný graf; reflexivita = smyčky u všech |
| binární strom, průchody | [okruh 3](../03-spojove-struktury/) | strom je speciální graf; inorder/preorder jsou varianty DFS |
| DFS zásobníkem | zásobník, [okruh 1](../01-abstraktni-kolekce/) | LIFO je přesně to, co dělá „jdi do hloubky" |
| BFS frontou | fronta, [okruh 1](../01-abstraktni-kolekce/) | FIFO je přesně to, co dělá „po vrstvách" |
| spojový seznam | [okruh 3](../03-spojove-struktury/) | seznam **je** cesta — graf, kde má každý stupeň nejvýš 2 |
| $O(V + E)$, $O(V^2)$ | asymptotika, [okruh 11](../11-rekurence-asymptotika/) | proč se u složitosti průchodu píšou **dva** parametry |
| výška stromu $\log n$ | [okruh 3](../03-spojove-struktury/) a [11](../11-rekurence-asymptotika/) | paměť DFS je $O(h)$, tedy u vyváženého stromu $O(\log n)$ |
| NP-úplnost Hamiltona | prohledání podmnožin $O(2^n)$, [okruh 11](../11-rekurence-asymptotika/) | proč se to nedá projít hrubou silou |

> **Věta, kterou tuhle souvislost řekni u zkoušky:** „Graf je nejobecnější z těch struktur — spojový seznam i strom jsou speciální případy grafu. Proto se DFS a BFS chovají na stromu přesně jako průchody z třetího okruhu."

---

### Graf a základní pojmy

#### Definice

**Graf** je uspořádaná dvojice

$$G = (V, E)$$

kde $V$ je **neprázdná** množina **vrcholů** (vertices) a $E$ množina **hran** (edges).

**Celý rozdíl mezi orientovaným a neorientovaným grafem je v tom, co je hrana:**

| | Hrana je | Platí | Příklad z praxe |
|---|---|---|---|
| **neorientovaný** | **množina** $\\{u, v\\}$ | $\\{u,v\\} = \\{v,u\\}$ | silnice, přátelství na Facebooku |
| **orientovaný** | **uspořádaná dvojice** $(u, v)$ | $(u,v) \neq (v,u)$ | jednosměrky, odkazy mezi weby, sledování na X |

**Konkrétně:** *„Petr je kamarád s Janou"* automaticky znamená, že *„Jana je kamarádka s Petrem"* — to je neorientovaný graf. Ale *„Petr sleduje Janu"* neznamená, že to platí obráceně — a to je orientovaný.

**A pozor**, že tenhle rozdíl už znáš: $E \subseteq V \times V$ je přesně **binární relace** z [okruhu 10](../10-logika-mnoziny-relace/). Orientovaný graf a relace na množině **jsou totéž**, jen se to kreslí jinak.

#### Stupeň vrcholu a princip podání ruky

**Stupeň** $\deg(v)$ je počet hran incidentních s vrcholem $v$ (tedy hran, které se ho dotýkají).

**Konkrétně** na tomhle grafu, se kterým budeme pracovat celou otázku:

```
        A ─── B
        │  ╲  │╲
        │   ╲ │ ╲
        │    ╲│  D
        │     ╳  │
        C ────╱──┘
         ╲       │
          ╲      │
           E ────┘
```

Přehledněji jako seznam hran:

$$E = \\{ AB,\ AC,\ BC,\ BD,\ CD,\ CE,\ DE \\}$$

| Vrchol | Sousedé | Stupeň |
|---|---|---|
| $A$ | $B, C$ | $2$ |
| $B$ | $A, C, D$ | $3$ |
| $C$ | $A, B, D, E$ | $4$ |
| $D$ | $B, C, E$ | $3$ |
| $E$ | $C, D$ | $2$ |

**Princip podání ruky** (handshaking lemma):

$$\sum_{v \in V} \deg(v) = 2\lvert E \rvert$$

**Ověření na našem grafu:** $2 + 3 + 4 + 3 + 2 = 14$, a hran je $7$. A opravdu $14 = 2 \cdot 7$ ✔

**Proč to platí** — a řekni to u zkoušky přesně takhle: *„Každá hrana má dva konce a každý konec přidá jedničku ke stupni jednoho vrcholu. Tak každá hrana přispěje do součtu přesně dvojkou."*

**Důsledek, který budeš za chvíli potřebovat u Eulera:**

> **Lichých vrcholů je vždy sudý počet.**

Kdyby jich byl lichý počet, byl by součet stupňů lichý — ale ten musí být sudý, protože je to $2\lvert E \rvert$. **U našeho grafu jsou liché dva** ($B$ a $D$), což sedí.

#### Sled, tah, cesta

Tři pojmy, které se liší **jen tím, co se smí opakovat**. Je to zpřísňování:

| Pojem | Smí se opakovat vrchol? | Smí se opakovat hrana? |
|---|---|---|
| **sled** | ano | ano |
| **tah** | ano | **ne** |
| **cesta** | **ne** | ne (plyne z toho) |

**Konkrétně na našem grafu:**

| Posloupnost | Co to je | Proč |
|---|---|---|
| $A \to B \to A \to C$ | jen **sled** | hrana $AB$ použita dvakrát |
| $A \to B \to D \to C \to A$ | **tah** i cesta… | ne — vrchol $A$ se opakuje, tedy jen **uzavřený tah** |
| $A \to B \to D \to E$ | **cesta** | nic se neopakuje |
| $B \to A \to C \to B \to D$ | **tah** (ne cesta) | vrchol $B$ dvakrát, ale žádná hrana |

**Délka** je vždy **počet hran**, ne vrcholů. Cesta $A \to B \to D \to E$ má délku $3$.

- **uzavřený** = začíná a končí ve stejném vrcholu, **otevřený** = v různých
- **kružnice** (cyklus) = uzavřená cesta, tedy neopakuje vrcholy kromě prvního a posledního. Například $A \to B \to D \to C \to A$.

**Past:** *„cesta"* v běžné řeči znamená cokoli, kudy se dá jít. **V teorii grafů je to nejpřísnější z těch tří pojmů.** Když se tě zeptají na cestu, nesmí se opakovat vrchol.

#### Souvislost

**Souvislý graf** je takový, ve kterém mezi **každými dvěma vrcholy existuje cesta**. Když ne, rozpadá se na **komponenty souvislosti** — maximální souvislé části.

**Náš graf je souvislý** — z $A$ se dostaneš kamkoli.

**Souvislost se ověří jedním průchodem:** spustíš DFS nebo BFS z libovolného vrcholu, a když navštívíš všech $\lvert V \rvert$ vrcholů, je graf souvislý. Jinak jsi našel jednu komponentu a musíš začít znovu z nenavštíveného vrcholu. **To je celý algoritmus na počítání komponent.**

---

### Reprezentace grafu

Tohle je **nejpraktičtější část otázky** a zkoušející ji mají rádi, protože se u ní pozná, jestli chápeš složitost.

#### Matice sousednosti

Čtvercová matice $\lvert V \rvert \times \lvert V \rvert$, kde na pozici $(i,j)$ je $1$, pokud vede hrana z $i$ do $j$.

**Náš graf:**

```
      A  B  C  D  E
  A [ 0  1  1  0  0 ]
  B [ 1  0  1  1  0 ]
  C [ 1  1  0  1  1 ]
  D [ 0  1  1  0  1 ]
  E [ 0  0  1  1  0 ]
```

**Dvě věci, které se z matice poznají na první pohled** — a řekni je nahlas, dělá to dojem:

- **U neorientovaného grafu je matice symetrická podle hlavní diagonály.** U orientovaného obecně není. (A to je totéž jako symetrie relace z [okruhu 10](../10-logika-mnoziny-relace/)!)
- **Součet řádku = stupeň vrcholu.** Řádek $C$ má $1+1+0+1+1 = 4$ ✔ — sedí s tabulkou výše.

#### Seznam sousedů

Ke každému vrcholu seznam jeho sousedů:

```python
graf = {
    "A": ["B", "C"],
    "B": ["A", "C", "D"],
    "C": ["A", "B", "D", "E"],
    "D": ["B", "C", "E"],
    "E": ["C", "D"],
}
```

**Všimni si, že každá hrana je uložená dvakrát** (jednou u každého konce) — proto je paměť $O(V + 2E)$, což se zapisuje $O(V + E)$.

#### Srovnání — a tady je ta pointa

| | Matice sousednosti | Seznam sousedů |
|---|---|---|
| **paměť** | $O(V^2)$ | $O(V + E)$ |
| **je hrana $(u,v)$?** | $O(1)$ | $O(\deg u)$ |
| **projdi sousedy $u$** | $O(V)$ | $O(\deg u)$ |
| **přidej hranu** | $O(1)$ | $O(1)$ |
| **projdi celý graf** | $O(V^2)$ | $O(V + E)$ |

**Rozhoduje hustota grafu.** Řídký graf má $E \approx V$, hustý má $E \approx V^2$.

**Spočítej si to na tom milionu vrcholů z doptávky** — sociální síť s milionem lidí a pěti miliony přátelství:

```
matice:   10^6 · 10^6 = 10^12 políček
          i kdyby stačil 1 bit na políčko:  10^12 / 8 = 125 GB
          při 1 bajtu na políčko:           1 TB

seznam:   2 · 5·10^6 = 10^7 položek
          při 8 bajtech na položku:         80 MB
```

**125 GB versus 80 MB.** A ta matice by byla skoro celá z nul — hran je $5 \cdot 10^6$ z možných $5 \cdot 10^{11}$, tedy **vyplněné promile procenta**.

> **Závěr, který řekni:** „Pro řídké grafy — a to je většina reálných — se používá seznam sousedů. Matice se vyplatí jen u hustých grafů nebo když se často ptám, jestli konkrétní hrana existuje."

---

### Význačné typy grafů

| Typ | Definice | Příklad |
|---|---|---|
| **úplný** $K_n$ | každé dva vrcholy spojeny hranou | $K_5$ má $\frac{5 \cdot 4}{2} = 10$ hran |
| **regulární** | všechny vrcholy mají **stejný stupeň** | cyklus $C_5$ je 2-regulární |
| **bipartitní** | $V$ jde rozdělit na dvě části, hrany vedou **jen mezi nimi** | studenti–předměty, herci–filmy |
| **souvislý** | mezi každými dvěma vrcholy vede cesta | náš graf ✔ |
| **acyklický** | neobsahuje kružnici | strom, DAG |
| **strom** | souvislý **a** acyklický | ↓ vlastní sekce |
| **les** | acyklický (komponenty jsou stromy) | strom bez jedné hrany |

**Počet hran úplného grafu** $K_n$ si odvoď, nepamatuj:

$$\lvert E \rvert = \binom{n}{2} = \frac{n(n-1)}{2}$$

**Proč:** každý z $n$ vrcholů je spojen s $n-1$ ostatními, což dá $n(n-1)$ — ale **každou hranu jsem započítal dvakrát** (jednou z každého konce), tak vydělím dvěma. **Pro $n=5$:** $\frac{5 \cdot 4}{2} = 10$ ✔

**Bipartitní graf poznáš podle toho, že neobsahuje kružnici liché délky** — to je hezká doptávka. Intuice: obarvuj vrcholy střídavě dvěma barvami; když se ti při obcházení kružnice barvy nesejdou, kružnice byla lichá a graf bipartitní není.

---

### Stromy

#### Tři ekvivalentní charakterizace

**Strom** je souvislý acyklický graf. Ale existují **tři pohledy, které říkají totéž** — a zkoušející rád slyší víc než jeden:

Nechť $G$ má $n$ vrcholů. Následující je ekvivalentní:

1. $G$ je **souvislý a acyklický**
2. $G$ je **souvislý a má právě $n-1$ hran**
3. mezi každými dvěma vrcholy vede **právě jedna** cesta

**Konkrétně** na stromu o 5 vrcholech:

```
        A
       / \
      B   C
     / \
    D   E
```

Hran je $4 = 5 - 1$ ✔. Z $D$ do $C$ vede jediná cesta $D \to B \to A \to C$ ✔.

**Proč jsou ty tři pohledy totéž, řekni takhle:**

- **Souvislý potřebuje aspoň $n-1$ hran** (každá nová hrana připojí nejvýš jeden nový vrchol).
- **Acyklický má nejvýš $n-1$ hran** (každá hrana navíc uzavře kružnici).
- **Splnit obojí najednou znamená mít přesně $n-1$.**

A ta „právě jedna cesta": kdyby vedly dvě různé, jejich složením bys dostal **kružnici** — takže by graf nebyl acyklický.

**Užitečný důsledek, na který se ptají:** *strom je „na hraně"* — **přidáš-li libovolnou hranu, vznikne kružnice; ubereš-li libovolnou, rozpadne se na dvě komponenty.** Je to minimální souvislý graf.

#### Kořenový a binární strom

Obyčejný strom nemá „vršek". **Zakořeněním** (zvolením kořene) vznikne hierarchie — rodič, potomek, list, hloubka, výška.

**Binární strom** má každý uzel nejvýš dva potomky (levý a pravý).

**Tohle už máš vypracované v [okruhu 3](../03-spojove-struktury/)** — reprezentace odkazy vs. polem, vztah $n \le 2^{h+1} - 1$, binární vyhledávací strom, průchody. Tady stačí:

| Reprezentace | Jak | Kdy |
|---|---|---|
| **odkazy** | uzel drží `left`, `right` | obecný, řídký strom |
| **polem** | uzel $i$ má potomky $2i+1$ a $2i+2$ | jen **úplný** strom (jinak díry) — halda |

> **U zkoušky to propoj:** „Průchody binárním stromem z třetího okruhu jsou vlastně DFS — preorder, inorder a postorder se liší jen tím, kdy uzel zpracuji vzhledem k rekurzivnímu sestupu. Průchod po hladinách je BFS."

---

### Eulerovské grafy

**Úloha:** projít **každou hranu právě jednou**.

| Pojem | Co to je |
|---|---|
| **eulerovský tah** | tah obsahující **všechny hrany** grafu (otevřený) |
| **eulerovská kružnice** | **uzavřený** eulerovský tah (skončím tam, kde jsem začal) |
| **eulerovský graf** | graf, který má eulerovskou kružnici |

#### Podmínka — a hlavně proč platí

> **Souvislý graf má eulerovskou kružnici** $\iff$ **všechny vrcholy mají sudý stupeň.**
>
> **Souvislý graf má eulerovský tah** $\iff$ **má právě 0 nebo 2 vrcholy lichého stupně.**

**Neuč se to nazpaměť, odvoď to.** Řekni u zkoušky tohle:

*„Když tahem procházím nějakým vrcholem, jednou hranou do něj přijdu a jinou z něj odejdu — spotřebuji dvě hrany naráz. Takže každý průchozí vrchol musí mít sudý stupeň. Lichý stupeň smí mít jen vrchol, ve kterém tah začíná (odejdu, ale nepřišel jsem) nebo končí. A ty jsou nejvýš dva."*

Z toho plyne celá tabulka:

| Lichých vrcholů | Existuje? | Kde začít |
|---|---|---|
| **0** | **eulerovská kružnice** | kdekoli |
| **2** | **eulerovský tah** (otevřený) | v jednom lichém, skončím v druhém |
| 4 a víc | **ne** | — |
| **1 nebo 3** | **nemůže nastat** | princip podání ruky! |

**Ten poslední řádek je past, na kterou se chytají lidi.** Lichých vrcholů je **vždy sudý počet**, takže „právě jeden lichý vrchol" je nemožné zadání.

#### Sedm mostů královeckých

Historicky první úloha teorie grafů — Euler, 1736. Město se čtyřmi břehy a sedmi mosty; otázka zněla, **jestli jde projít každý most právě jednou**.

```
stupně:   A = 5,  B = 3,  C = 3,  D = 3
součet 14 = 2 · 7 hran ✔
```

**Lichých vrcholů: čtyři.** Podmínka žádá 0 nebo 2 $\Rightarrow$ **nejde to.**

**A to je celá Eulerova odpověď** — nemusel zkoušet cesty, stačilo spočítat stupně. Tenhle příběh u zkoušky vyprávěj, je krátký a ukazuje pointu: **z lokální vlastnosti (stupně) plyne globální (existence tahu).**

#### Náš graf

$$\deg: A=2,\ B=3,\ C=4,\ D=3,\ E=2$$

**Liché jsou $B$ a $D$ — právě dva** $\Rightarrow$ existuje **eulerovský tah**, ale ne kružnice. Musí začít v jednom lichém a skončit v druhém.

**Konkrétní tah** (ověř si, že má všech 7 hran a žádná se neopakuje):

$$B \to A \to C \to B \to D \to C \to E \to D$$

Hrany po řadě: $BA, AC, CB, BD, DC, CE, ED$ — **sedm hran, každá právě jednou** ✔, začátek $B$ a konec $D$, oba liché ✔

---

### Hamiltonovské grafy

**Úloha:** projít **každý vrchol právě jednou**.

| Pojem | Co to je |
|---|---|
| **hamiltonovská cesta** | cesta obsahující **všechny vrcholy** |
| **hamiltonovská kružnice** | uzavřená, vrátí se do startu |
| **hamiltonovský graf** | má hamiltonovskou kružnici |

**Náš graf** hamiltonovskou kružnici má:

$$A \to B \to D \to E \to C \to A$$

Ověř: pět vrcholů, každý právě jednou, a $CA$ je hrana ✔

#### Proč je Hamilton úplně jiná liga než Euler

**Tohle je nejcennější věta celé otázky** a ptají se na ni skoro vždycky:

| | Euler | Hamilton |
|---|---|---|
| navštěvuje právě jednou | **hrany** | **vrcholy** |
| kritérium | **lokální** — stupeň vrcholu | **žádné jednoduché neexistuje** |
| rozhodnutí | $O(V + E)$ | **NP-úplné** |

**Proč ten obrovský rozdíl, když ty úlohy znějí skoro stejně?**

*„U Eulera se stačí dívat na každý vrchol zvlášť — kolik má hran. Je to lokální vlastnost a spočítám ji jedním průchodem. U Hamiltona žádná taková lokální podmínka není: to, jestli existuje hamiltonovská kružnice, závisí na struktuře grafu jako celku. Nedá se to poznat pohledem na okolí jednoho vrcholu."*

Hrubá síla znamená zkoušet pořadí vrcholů, tedy až $n!$ možností — a to je ještě hůř než $2^n$ z [okruhu 11](../11-rekurence-asymptotika/).

**Existují jen postačující podmínky** (ne nutné a postačující). Nejznámější je **Diracova věta**:

> Má-li graf $n \geq 3$ vrcholů a **každý** vrchol má stupeň aspoň $\frac{n}{2}$, pak **hamiltonovská kružnice existuje**.

**Pozor na směr implikace!** Když podmínka neplatí, **neznamená to, že kružnice neexistuje**. Náš graf má $n = 5$, tedy by potřeboval všechny stupně $\geq 2{,}5$ — ale $A$ a $E$ mají jen $2$. **Diracova podmínka tedy neplatí, a přesto kružnice existuje** ($A \to B \to D \to E \to C \to A$). To je přesně ten rozdíl mezi *postačující* a *nutnou a postačující* podmínkou.

**Praktický význam:** problém obchodního cestujícího (TSP) je hamiltonovská kružnice s minimální cenou. Proto se logistika řeší **heuristikami**, ne přesným algoritmem.

---

### Prohledávání grafu

#### Jeden kód, dvě struktury

**Nejdůležitější věc, kterou o DFS a BFS řekni:** je to **tentýž algoritmus**, liší se **jedinou věcí** — jestli si nezpracované vrcholy odkládám do **zásobníku** (LIFO), nebo do **fronty** (FIFO).

```python
def prohledej(graf, start, do_hloubky):
    otevrene = [start]
    navstivene = set()
    poradi = []
    while otevrene:
        v = otevrene.pop() if do_hloubky else otevrene.pop(0)   # <- JEDINÝ ROZDÍL
        if v in navstivene:
            continue
        navstivene.add(v)
        poradi.append(v)
        for soused in graf[v]:
            if soused not in navstivene:
                otevrene.append(soused)
    return poradi
```

**Zásobník** vrací naposledy přidaný vrchol $\Rightarrow$ jdu hned dál od místa, kde jsem $\Rightarrow$ **do hloubky**.
**Fronta** vrací nejdřív přidaný $\Rightarrow$ doberu všechny sousedy startu, než jdu dál $\Rightarrow$ **po vrstvách**.

#### Ukázka na našem grafu — start v $E$

```
      A ─ B
      │ ╲ │╲
      C ──┼─D
       ╲  │╱
         E
```

Seznam sousedů: $A: BC$, $B: ACD$, $C: ABDE$, $D: BCE$, $E: CD$

| | Pořadí návštěv |
|---|---|
| **DFS z $E$** | $E, C, A, B, D$ |
| **BFS z $E$** | $E, C, D, A, B$ |

**Rozdíl je vidět hned na druhém kroku.** Oba jdou nejdřív na $C$. Pak:

- **DFS** se z $C$ **propadne dál** na $A$, z $A$ na $B$, z $B$ na $D$ — jde pořád do hloubky a $D$ najde až úplně nakonec, přestože je hned vedle $E$.
- **BFS** doobslouží nejdřív **celé okolí $E$** — tedy $C$ i $D$ — a teprve pak jde o vrstvu dál na $A$ a $B$.

**Vzdálenosti od $E$**, které BFS spočítá zadarmo:

| Vrchol | $E$ | $C$ | $D$ | $A$ | $B$ |
|---|---|---|---|---|---|
| vzdálenost | $0$ | $1$ | $1$ | $2$ | $2$ |

**Přesně v tomhle pořadí je BFS navštívilo** — a to není náhoda, to je celý důvod, proč BFS funguje na nejkratší cesty.

#### Proč BFS najde nejkratší cestu a DFS ne

**Odpověď na tu doptávku ze stubu, řekni ji takhle:**

*„BFS zpracovává vrcholy po vrstvách podle vzdálenosti od startu — napřed všechny ve vzdálenosti 1, pak všechny ve vzdálenosti 2. Když na vrchol narazí poprvé, je to nutně po nejkratší cestě, protože kdyby existovala kratší, našel by ho už v dřívější vrstvě."*

*„DFS naopak jde po první hraně, co vidí, jak nejdál to jde. Vrchol tak může najít oklikou — v našem příkladu najde $D$ až po čtyřech krocích, přestože sousedí se startem."*

**Zásadní omezení:** BFS hledá nejkratší cestu jen v **nevážený** grafu (nebo když mají všechny hrany stejnou váhu). Když mají hrany různé délky, je potřeba **Dijkstrův algoritmus**. Tohle si ohlídej — je to častá doplňující otázka.

#### Složitost a použití

| | Se seznamem sousedů | S maticí |
|---|---|---|
| **DFS i BFS** | $O(V + E)$ | $O(V^2)$ |

**Proč $O(V + E)$:** každý vrchol zpracuji jednou ($V$) a u každého projdu jeho seznam sousedů. Součet všech stupňů je $2E$, takže dohromady $O(V + E)$. **S maticí musím u každého vrcholu projít celý řádek délky $V$**, i když má jen dva sousedy — proto $O(V^2)$.

| | DFS | BFS |
|---|---|---|
| **paměť** | $O(h)$ — hloubka zásobníku | $O(\text{šířka})$ — nejširší vrstva |
| **typické použití** | detekce cyklů, komponenty, topologické řazení, backtracking | **nejkratší cesta**, vrstvy, nejbližší řešení |

**Past u DFS psaného rekurzivně:** hloubka rekurze může být až $O(V)$ (u „hada" — cesty), a to znamená **přetečení zásobníku** u velkých grafů. Tohle je totéž, co u degenerovaného stromu v [okruhu 3](../03-spojove-struktury/).

---

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

- **Graf** — uspořádaná dvojice $G = (V, E)$, kde $V$ je neprázdná množina vrcholů a $E$ množina hran.
- **Neorientovaný graf** — hrana je dvouprvková **množina** $\\{u,v\\}$; **orientovaný** — hrana je **uspořádaná dvojice** $(u,v)$.
- **Stupeň vrcholu** — počet hran s ním incidentních. **Princip podání ruky:** $\sum_{v} \deg(v) = 2\lvert E \rvert$.
- **Sled** — posloupnost vrcholů a hran, kde každá hrana spojuje dva po sobě jdoucí vrcholy. **Tah** — sled bez opakování hrany. **Cesta** — tah bez opakování vrcholu. **Kružnice** — uzavřená cesta.
- **Souvislý graf** — mezi každými dvěma vrcholy existuje cesta.
- **Strom** — souvislý acyklický graf; ekvivalentně souvislý graf s $n-1$ hranami; ekvivalentně graf, v němž mezi každými dvěma vrcholy vede právě jedna cesta.
- **Eulerovský tah** — tah obsahující všechny hrany grafu. Existuje v souvislém grafu **právě tehdy, když má 0 nebo 2 vrcholy lichého stupně**; při 0 lichých je uzavřený (**eulerovská kružnice**).
- **Hamiltonovská cesta** — cesta obsahující všechny vrcholy grafu; **hamiltonovská kružnice** je její uzavřená obdoba. Rozhodnutí o existenci je **NP-úplné**.
- **DFS** — prohledávání do hloubky, používá zásobník (nebo rekurzi). **BFS** — do šířky, používá frontu; v nevážený grafu nachází nejkratší cesty. Obojí $O(V+E)$ se seznamem sousedů.

---

### Příklad na papír

<!-- Jeden příklad, který během výkladu spočítám nebo nakreslím. -->

**Jeden graf, na kterém předvedeš celou otázku.** Tohle je velká výhoda dvanáctky — nakreslíš jeden obrázek a všechno ostatní na něm ukážeš.

#### Zadání, které si nakresli

$$V = \\{A, B, C, D, E\\} \qquad E = \\{AB,\ AC,\ BC,\ BD,\ CD,\ CE,\ DE\\}$$

```
        A ────── B
        │ ╲      │ ╲
        │   ╲    │   ╲
        │     ╲  │     D
        │       ╲│   ╱ │
        C ───────┼──╱  │
          ╲      │     │
            ╲    │     │
              ╲  │     │
                E ─────┘
```

**Kresli to raději takhle přehledně** — pětiúhelník s dvěma úhlopříčkami:

```
              A
            ╱   ╲
          B ───── C
          │ ╲   ╱ │
          │   ╳   │
          D ───── E
```

Hrany: $AB$, $AC$, $BC$, $BD$, $CD$, $CE$, $DE$ — sedm hran, pět vrcholů.

##### Krok 1: stupně a princip podání ruky

| Vrchol | $A$ | $B$ | $C$ | $D$ | $E$ |
|---|---|---|---|---|---|
| **stupeň** | $2$ | $3$ | $4$ | $3$ | $2$ |

$$\sum \deg(v) = 2 + 3 + 4 + 3 + 2 = 14 = 2 \cdot 7 = 2\lvert E \rvert \quad ✔$$

**Tohle si vždycky ověř jako první** — je to kontrola, že jsi neudělal chybu při čtení obrázku. A rovnou z toho plyne: **liché vrcholy jsou $B$ a $D$, tedy dva.**

##### Krok 2: reprezentace

**Matice sousednosti** (symetrická, součet řádku = stupeň):

```
      A  B  C  D  E     součet
  A [ 0  1  1  0  0 ]     2
  B [ 1  0  1  1  0 ]     3
  C [ 1  1  0  1  1 ]     4
  D [ 0  1  1  0  1 ]     3
  E [ 0  0  1  1  0 ]     2
```

**Seznam sousedů:**

```
A: B, C
B: A, C, D
C: A, B, D, E
D: B, C, E
E: C, D
```

**Řekni k tomu:** *„Matice má 25 políček, z toho 14 jedniček. Seznam má 14 položek. U tak malého grafu je to jedno, ale u milionu vrcholů je rozdíl 125 GB proti 80 MB."*

##### Krok 3: eulerovský tah

**Rozhodnutí:** graf je souvislý a má **právě dva liché vrcholy** ($B$, $D$) $\Rightarrow$ **eulerovský tah existuje**, eulerovská kružnice ne.

**Tah musí začínat v jednom lichém a končit v druhém:**

$$B \to A \to C \to B \to D \to C \to E \to D$$

**Odškrtej si hrany, jak je používáš** — to je způsob, jak tah u tabule najít:

| Krok | Hrana | Zbývá |
|---|---|---|
| 1 | $BA$ | $AC, BC, BD, CD, CE, DE$ |
| 2 | $AC$ | $BC, BD, CD, CE, DE$ |
| 3 | $CB$ | $BD, CD, CE, DE$ |
| 4 | $BD$ | $CD, CE, DE$ |
| 5 | $DC$ | $CE, DE$ |
| 6 | $CE$ | $DE$ |
| 7 | $ED$ | — ✔ |

**Sedm hran, každá právě jednou, konec v $D$** — přesně jak podmínka slibovala.

##### Krok 4: hamiltonovská kružnice

$$A \to B \to D \to E \to C \to A$$

**Ověř:** pět vrcholů, každý právě jednou, a poslední hrana $CA$ v grafu je ✔

**A tady řekni tu nejdůležitější větu:** *„Zatímco u Eulera jsem existenci poznal okamžitě z tabulky stupňů, tady jsem musel kružnici zkusmo najít. Žádná jednoduchá podmínka pro Hamiltona neexistuje — problém je NP-úplný. Ověřit hotové řešení je snadné, najít ho těžké."*

**Ještě lepší:** ukaž, že **Diracova podmínka tady neplatí** (potřebovala by stupně $\geq 2{,}5$, ale $A$ a $E$ mají $2$) — **a kružnice přesto existuje**. To ukazuje, že je jen postačující, ne nutná.

##### Krok 5: DFS a BFS ze stejného vrcholu

**Start v $E$** — schválně, protože odtud se ty dva průchody nejvíc rozejdou. Sousedy ber v abecedním pořadí.

**DFS (zásobník):**

| Krok | Beru | Zásobník po kroku | Pořadí |
|---|---|---|---|
| 1 | $E$ | $C, D$ | $E$ |
| 2 | $D$?, ne — beru vrchol zásobníku | | |

Přehledněji **rekurzivně**, jak to u tabule řekneš:

```
E -> první nenavštívený soused C
  C -> první nenavštívený soused A
    A -> první nenavštívený soused B
      B -> první nenavštívený soused D
        D -> všichni sousedé navštíveni, vracím se
```

$$\text{DFS: } E,\ C,\ A,\ B,\ D$$

**BFS (fronta):**

| Vrstva | Vrcholy | Vzdálenost od $E$ |
|---|---|---|
| 0 | $E$ | $0$ |
| 1 | $C, D$ | $1$ |
| 2 | $A, B$ | $2$ |

$$\text{BFS: } E,\ C,\ D,\ A,\ B$$

##### Krok 6: co na tom ukázat

**Porovnej ta dvě pořadí vedle sebe** — to je nejnázornější věc celého příkladu:

```
DFS:  E  C  A  B  D
BFS:  E  C  D  A  B
            ↑
      tady se rozejdou
```

- **$D$ sousedí se startem $E$**, ale **DFS ho najde jako poslední** — propadlo se přes $C, A, B$ a k $D$ se dostalo oklikou.
- **BFS ho najde hned ve druhém kroku**, protože nejdřív dobere celou první vrstvu.
- **Proto BFS zná nejkratší cesty a DFS ne.** Vzdálenost $E \to D$ je $1$, ale DFS k němu došel po čtyřech hranách.

**Složitost obou:** $O(V + E) = O(5 + 7)$ — každý vrchol jednou, každá hrana dvakrát (z každého konce).

##### Kdyby tlačil čas

Nestíháš-li všechno, **vynech Kroky 2 a 5** a udělej **stupně → Euler → Hamilton**. Tam je totiž ten kontrast, na kterém otázka stojí, a dá se odvyprávět za tři minuty.

---

### Na co se doptají

1. **Kdy má graf eulerovský tah a kdy eulerovskou kružnici? Odůvodni přes stupně.** → Tah: 0 nebo 2 liché vrcholy. Kružnice: 0 lichých. Důvod: průchozím vrcholem přijdu a odejdu, spotřebuji 2 hrany — tedy sudý stupeň; lichý smí být jen start a cíl.
2. **Může mít graf právě jeden vrchol lichého stupně?** → **Ne.** Z principu podání ruky je součet stupňů sudý, takže lichých vrcholů je vždy sudý počet.
3. **V čem je zásadní rozdíl mezi Eulerem a Hamiltonem z hlediska složitosti?** → Euler má **lokální** kritérium (stupně) rozhodnutelné v $O(V+E)$; Hamilton žádné jednoduché nemá a je **NP-úplný**.
4. **Proč BFS najde nejkratší cestu a DFS ne?** → BFS jde po vrstvách vzdálenosti; první nalezení vrcholu je nutně nejkratší. DFS se propadne po první hraně a může vrchol najít oklikou.
5. **Funguje BFS na nejkratší cestu vždy?** → Jen v **nevážený** grafu (nebo při stejných vahách). S různými vahami je potřeba **Dijkstra**.
6. **Kolik paměti zabere matice sousednosti u řídkého grafu s milionem vrcholů?** → $10^{12}$ políček; i při 1 bitu na políčko je to **125 GB**, při bajtu **1 TB**. Seznam sousedů při 5 milionech hran zabere ~**80 MB**.
7. **Jaký je rozdíl mezi sledem, tahem a cestou?** → Sled nezakazuje nic, tah nesmí opakovat **hranu**, cesta ani **vrchol**.
8. **Kolik hran má strom o $n$ vrcholech?** → Přesně $n-1$.
9. **Co se stane, když ke stromu přidám hranu? A když jednu uberu?** → Přidáním vznikne **kružnice**, ubráním se rozpadne na **dvě komponenty**. Strom je minimální souvislý graf.
10. **Kolik hran má úplný graf $K_n$?** → $\frac{n(n-1)}{2}$ — každý s každým, ale hrany počítané dvakrát.
11. **Jak poznám z matice sousednosti, že graf je neorientovaný?** → Je **symetrická** podle hlavní diagonály.
12. **Jak poznám z matice stupeň vrcholu?** → Součet příslušného **řádku**.
13. **Jak zjistím, jestli je graf souvislý?** → Spustím DFS/BFS z libovolného vrcholu; navštívím-li všech $\lvert V \rvert$, je souvislý. Jinak jsem našel jednu komponentu.
14. **Jaká je složitost DFS a BFS?** → $O(V+E)$ se seznamem sousedů, $O(V^2)$ s maticí — u matice musím u každého vrcholu projít celý řádek.
15. **Který z průchodů je paměťově úspornější?** → Záleží na tvaru. DFS potřebuje $O(h)$ (hloubka), BFS $O(\text{šířka})$ nejširší vrstvy. U širokého mělkého grafu vyhraje DFS, u hlubokého úzkého BFS.
16. **Jaký je vztah mezi grafem a binární relací?** → Orientovaný graf **je** binární relace na množině ([okruh 10](../10-logika-mnoziny-relace/)). Reflexivita = smyčky u všech vrcholů, symetrie = neorientovaný graf.
17. **Co je Diracova věta a proč nestačí?** → Stupeň každého vrcholu $\geq n/2$ (pro $n \geq 3$) zaručí hamiltonovskou kružnici. Je jen **postačující** — neplatí-li, kružnice může přesto existovat.
18. **K čemu je bipartitní graf a jak ho poznám?** → Modeluje vztahy dvou různých typů (studenti–předměty). Graf je bipartitní **právě tehdy, když neobsahuje kružnici liché délky**.
19. **Jak souvisí průchody binárním stromem s DFS a BFS?** → Preorder/inorder/postorder jsou varianty **DFS** (liší se okamžikem zpracování uzlu), průchod po hladinách je **BFS**.
20. **Proč je u rekurzivního DFS riziko přetečení zásobníku?** → Hloubka rekurze je až $O(V)$ — u grafu tvaru cesty. Totéž jako degenerovaný strom v [okruhu 3](../03-spojove-struktury/).

### Užitečné odkazy

- <https://cs.wikipedia.org/wiki/Teorie_graf%C5%AF>
- <https://cs.wikipedia.org/wiki/Sedm_most%C5%AF_m%C4%9Bsta_Kr%C3%A1lovce>
- <https://cs.wikipedia.org/wiki/Prohled%C3%A1v%C3%A1n%C3%AD_do_%C5%A1%C3%AD%C5%99ky>
- <https://www.umimeinformatiku.cz/cviceni-teorie-grafu-pojmy-zakladni>
