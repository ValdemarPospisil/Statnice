## 1 — Základní a specializované abstraktní kolekce

> Základní abstraktní kolekce (jejich klasická implementace [seznamy, slovníky], iterátory nad nimi, typické elementární operace a jejich časová složitost) a specializované abstraktní kolekce (fronta, zásobník)

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. Abstraktní datový typ vs. datová struktura — rozhraní odděleno od implementace, proč to je užitečné
2. Přehled základních kolekcí: seznam, množina, slovník — čím se liší v tom, **co garantují**
3. Seznam — typické operace a jejich složitost
4. Implementace seznamu: statické pole vs. dynamické pole vs. spojový seznam
5. Amortizovaná složitost — proč je `add` na konec dynamického pole $O(1)$, když realokace stojí $O(n)$
6. Množina a slovník — hashovací tabulka, kolize a jejich řešení, průměrně $O(1)$ vs. nejhůře $O(n)$
7. Iterátor — protokol průchodu, oddělení iterace od struktury
8. Zásobník (LIFO) — push / pop / peek, typické použití
9. Fronta (FIFO) — enqueue / dequeue, kruhové pole, typické použití
10. Souhrnná tabulka časových složitostí — tady graduje celý výklad

**Nit, na kterou to navlékni:** ADT říká, **co** kolekce umí; implementace určuje, **za kolik**. Celá otázka je jedna tabulka — pro každou kolekci vyber implementaci a obhaj složitosti. Když si nebudeš jistý, vrať se k téhle větě, protože je to zároveň odpověď na většinu doptávek.

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tohle je celý „tahák", který si vyrobíš zpaměti hned na začátku přípravy. Psaní zabere zhruba tři minuty a zbylých dvanáct pak máš na promyšlení příkladu, ne na vzpomínání.

```
ADT = CO umí   |   implementace = ZA KOLIK

3 MECHANISMY (z nich se odvodí celá tabulka):
  souvislá paměť -> adresa se SPOČÍTÁ -> index O(1), ale posun O(n)
  ukazatele      -> jen se PŘEPOJÍ    -> vložení O(1), ale hledání O(n)
  hash           -> index Z KLÍČE     -> O(1) průměrně, O(n) nejhůř

                  přístup   vložení      výmaz
  statické pole      1         n           n
  dynamické pole     1         1* konec    n
  spojový seznam     n         1  začátek  1 s referencí
  hash tabulka       1 prům    1 prům      1 prům
  vyvážený strom   log n     log n       log n
  zásobník LIFO      1         1           1
  fronta FIFO        1         1           1
                               * amortizovaně

AMORTIZACE:  1+2+4+...+n < 2n  ->  (n+2n)/n = 3  ->  O(1)
             růst o konstantu c -> n²/2c -> O(n) NA JEDNO vložení

HASH: alfa = n/m, práh 0,75 -> zdvojnásobit + přehashovat
      kolize: zřetězení / otevřené adresování (náhrobky!)

PASTI: O(1) u hashe = průměr, ne nejhorší případ
       změna klíče po vložení -> prvek se nenajde
       spojový seznam O(1) jen když UŽ mám referenci
       změna kolekce během iterace
       uspořádaný (má pořadí) != setříděný

PŘÍKLAD: kapacita 1->2->4->8, kopií 1+2+4 = 7 < 2·8
         m=7:  15->1, 11->4, 27->6, 8->1, 22->1   (8,15,22 = 1+7k)
         fronta ze 2 zásobníků: in -> out, ≤2 push + ≤2 pop na prvek
```

#### Jak si to zapamatovat, aniž bys to biflil

Tu tabulku **neuč nazpaměť**. Je v ní 21 čísel, ale generují ji jen **tři mechanismy** — a ty si zapamatuješ jako tři slovesa:

> **Pole skočí. Seznam přepojí. Hash spočítá.**

Z každého slovesa plyne jak silná stránka, tak slabina, a ta dvojice ti vygeneruje celý řádek:

| Mechanismus | Co umí levně | Co ho stojí draho | Proč |
|---|---|---|---|
| **pole skočí** | přístup na index | vkládání a mazání uprostřed | adresu spočítá, ale prvky musí zůstat vedle sebe → posun |
| **seznam přepojí** | vložení a výmaz | přístup na $i$-tou pozici | ukazatel změní za konstantu, ale k pozici musí dojít |
| **hash spočítá** | vše průměrně $O(1)$ | nejhorší případ $O(n)$, žádné pořadí | index vypočte z klíče, ale kolize dělají řetěz |

Zbylé tři řádky tabulky jsou jen důsledky:

- **strom** — $\log n$ všude, protože se v každém kroku půlí; platí se tím za to, že drží uspořádání
- **zásobník a fronta** — samé jedničky, protože sahají **jen na okraje**, a na okraj je levné sáhnout u pole i u spojového seznamu; právě proto mají tak omezené rozhraní

A dvě čísla, která si pamatuj jako čísla, protože se z ničeho neodvodí: **práh zaplnění 0,75** a **růst na dvojnásobek**.

---

### Abstraktní datový typ

- **ADT** (Abstract Data Type) = formální specifikace typu daná **množinou hodnot** a **množinou operací** nad nimi včetně jejich sémantiky — **bez určení implementace**
- říká *co* se dá dělat a *jak se to má chovat*, neříká *jak je to uvnitř udělané*
- dvojice pojmů, o kterou se opírá celá otázka:

| | Odpovídá na otázku | Příklad |
|---|---|---|
| **ADT** (specifikace) | co to umí, jaké platí garance | seznam, množina, slovník, fronta, zásobník |
| **datová struktura** (implementace) | jak je to uložené a za kolik | pole, spojový seznam, hashovací tabulka, strom |

**Proč to oddělovat:**

- můžu vyměnit implementaci, aniž bych sáhl na kód, který kolekci používá
- můžu vybírat implementaci **podle profilu operací**, které opravdu dělám
- složitost není vlastnost ADT, ale **až implementace** — „seznam má vyhledání $O(n)$" je nepřesné, protože záleží na tom, čím je realizovaný

> Tohle je nejdůležitější myšlenka celé otázky. Když ji řekneš hned na začátku, zbytek výkladu z ní přirozeně vypadne.

#### Kolekce

- **kolekce** = ADT, který uchovává **více prvků** a poskytuje operace pro jejich vkládání, rušení, vyhledávání a průchod
- dělení podle typu prvků:
  - **homogenní** — všechny prvky téhož typu (typické v jazycích se statickou typovou kontrolou)
  - **heterogenní** — prvky různých typů (Python)
- čím se kolekce od sebe liší (tohle jsou ty „garance"):

| Vlastnost | Seznam | Množina | Slovník |
|---|---|---|---|
| zachovává pořadí | ano | ne | ne (typicky) |
| povoluje duplicity | ano | ne | klíče ne, hodnoty ano |
| přístup přes index | ano | ne | přes klíč |
| hlavní operace | přístup na pozici | test příslušnosti | vyhledání podle klíče |

---

### Seznam

- **seznam (list)** = uspořádaná posloupnost prvků; každý prvek má **pozici (index)**, každý kromě posledního má **následníka**
- zachovává pořadí vložení, **připouští duplicity**, nevynucuje setříděnost

#### Typické elementární operace

| Operace | Význam |
|---|---|
| `size()` | počet prvků |
| `get(i)` / `set(i, x)` | přístup a změna na pozici |
| `insert(i, x)` | vložení na pozici |
| `remove(i)` | odstranění z pozice |
| `contains(x)` / `indexOf(x)` | vyhledání hodnoty |

#### Statické pole

- souvislý blok paměti **pevné velikosti**, určené při vytvoření
- adresa prvku se **spočítá**: `adresa = základ + i · velikost_prvku` → proto přístup v konstantním čase

| Operace | Nejlepší | Nejhorší | Proč |
|---|---|---|---|
| přístup `a[i]` | $O(1)$ | $O(1)$ | adresa se přímo vypočítá |
| změna `a[i] = x` | $O(1)$ | $O(1)$ | zápis na existující pozici |
| vyhledání hodnoty | $O(1)$ | $O(n)$ | prvek je hned první / až poslední / vůbec tam není |
| vložení, odstranění | $O(n)$ | $O(n)$ | velikost je pevná → nové pole a kopie všeho |

#### Dynamické pole

- uvnitř je pořád **statické pole**, navíc se drží `count` (počet prvků) a `capacity` (velikost pole)
- při zaplnění se alokuje **větší pole** (typicky **dvojnásobek**) a vše se zkopíruje — **realokace**
- růst musí být **geometrický** (×2), ne o konstantu — viz odvození níže

| Operace | Nejlepší | Nejhorší | Amortizovaně | Proč |
|---|---|---|---|---|
| `count` | $O(1)$ | $O(1)$ | $O(1)$ | drží se jako atribut |
| přístup `a[i]` | $O(1)$ | $O(1)$ | $O(1)$ | souvislá paměť |
| přidání na konec | $O(1)$ | $O(n)$ | **$O(1)$** | $O(n)$ jen když se realokuje |
| vložení, odstranění uprostřed | $O(n)$ | $O(n)$ | $O(n)$ | musí se posunout prvky za pozicí |
| vyhledání hodnoty | $O(1)$ | $O(n)$ | $O(n)$ | lineární průchod |

#### Amortizovaná složitost — tohle chtějí slyšet

**Amortizovaná složitost** = průměrná cena jedné operace v **nejhorší možné posloupnosti** $n$ operací. Není to průměrný případ přes náhodná data — je to worst case rozpočítaný přes celou sérii.

Vložím $n$ prvků do prázdného dynamického pole se zdvojnásobováním. Realokace nastanou při velikostech $1, 2, 4, 8, \ldots$ a celkový počet zkopírovaných prvků je

$$1 + 2 + 4 + \cdots + 2^k \;=\; 2^{k+1} - 1 \;<\; 2n$$

K tomu $n$ samotných zápisů, dohromady méně než $3n$ operací. Na jedno vložení tedy

$$\frac{3n}{n} = 3 = O(1)$$

**Proti tomu růst o konstantu $c$:** realokace nastanou při $c, 2c, 3c, \ldots, n$ a kopíruje se

$$c + 2c + \cdots + n \;\approx\; \frac{n^2}{2c} \;=\; O(n^2)$$

což je $O(n)$ **na jedno vložení**. Rozdíl mezi geometrickým a lineárním růstem je tedy rozdíl mezi $O(1)$ a $O(n)$ — to je celé jádro té otázky.

> **Formulace, kterou u zkoušky použij:** „Jednotlivá operace může stát $O(n)$, ale drahé operace jsou tak vzácné, že se jejich cena rozpustí mezi levné. Amortizovaně proto $O(1)$."

#### Spojový seznam

- řetěz **uzlů**; každý uzel drží hodnotu a **referenci na následníka** (u obousměrného i na předchůdce)
- prvky **nejsou** v souvislé paměti → **není náhodný přístup**, musí se procházet od hlavy

| Operace | Složitost | Proč |
|---|---|---|
| přístup na $i$-tou pozici | $O(n)$ | nutno projít $i$ uzlů |
| vložení / výmaz **na začátek** | $O(1)$ | jen přepojení ukazatelů |
| vložení / výmaz **na konec** | $O(1)$ s ukazatelem na konec, jinak $O(n)$ | |
| vložení / výmaz, když **už mám referenci na uzel** | $O(1)$ | u jednosměrného potřebuju předchůdce → $O(n)$; u obousměrného $O(1)$ |
| vyhledání hodnoty | $O(n)$ | lineární průchod |

Detaily operací a binární strom patří k [okruhu 3 — Spojové datové struktury](../03-spojove-struktury/).

#### Pole vs. spojový seznam — jak to porovnat

| | Dynamické pole | Spojový seznam |
|---|---|---|
| přístup na index | $O(1)$ | $O(n)$ |
| vložení na začátek | $O(n)$ | $O(1)$ |
| paměťová režie | jen nevyužitá kapacita | ukazatel u **každého** prvku |
| lokalita v cache | výborná (souvislá paměť) | špatná (uzly rozházené po haldě) |

> **Past:** „Spojový seznam má vkládání $O(1)$, takže je rychlejší." Platí to jen tehdy, když **už referenci na místo vložení mám**. Když ho musím najít podle indexu nebo hodnoty, zaplatím $O(n)$ za hledání a celková cena je stejná jako u pole. V praxi navíc dynamické pole často vyhraje i tam, kde má horší asymptotiku — kvůli cache.

---

### Množina

- **množina (set)** = kolekce **unikátních** prvků **bez definovaného pořadí** a bez indexu
- dvě množiny jsou si rovné, obsahují-li tytéž prvky — na pořadí nezáleží
- prvky musí umět odpovědět na **rovnost** (a u hashovací implementace i vrátit **hash**)
- operace: vložení, odstranění, **test příslušnosti**, velikost, sjednocení / průnik / rozdíl

```
A = {1, 2, 3, 4}          B = {3, 4, 5, 6}

A ∪ B = {1, 2, 3, 4, 5, 6}    A ∩ B = {3, 4}
A \ B = {1, 2}                B \ A = {5, 6}
```

### Slovník

- **slovník (dictionary, mapa, asociativní pole)** = kolekce dvojic **klíč → hodnota**
- **klíče jsou unikátní**, hodnoty se opakovat mohou
- operace: vložení/aktualizace podle klíče, získání hodnoty, odstranění, test existence klíče, počet, iterace přes klíče / hodnoty / dvojice

Množina i slovník mají **stejné dvě klasické implementace** — proto se dají odbýt společně:

| Implementace | Vyhledání | Vložení | Výmaz | Navíc |
|---|---|---|---|---|
| hashovací tabulka | $O(1)$ prům., $O(n)$ nejhůře | $O(1)$ prům. | $O(1)$ prům. | neuspořádané |
| vyvážený strom | $O(\log n)$ | $O(\log n)$ | $O(\log n)$ | **udržuje uspořádání**, umí intervalové dotazy a průchod v pořadí |

### Hashovací tabulka

Princip ve čtyřech krocích — takhle ho odříkej:

1. vezmu **klíč**
2. **hashovací funkce** $h$ z něj spočítá celé číslo
3. `index = h(klíč) mod m`, kde $m$ je velikost tabulky
4. na tento index se uloží dvojice

**Kolize** = dva různé klíče dostanou stejný index, tedy $h(k_1) \equiv h(k_2) \pmod m$ pro $k_1 \ne k_2$. Kolize jsou **nevyhnutelné**: klíčů je typicky víc než přihrádek, takže podle Dirichletova (přihrádkového) principu musí aspoň dva spadnout na stejné místo.

**Dvě řešení kolizí:**

| Způsob | Jak funguje | Nevýhoda |
|---|---|---|
| **zřetězení** (chaining) | v každé přihrádce je spojový seznam všech prvků, co sem spadly | režie ukazatelů, špatná lokalita |
| **otevřené adresování** | hledá se další volná pozice (lineární / kvadratické zkoušení, dvojí hashování) | shlukování; výmaz vyžaduje **náhrobky** (tombstones), jinak se přeruší hledací řetěz |

**Faktor zaplnění** $\alpha = n/m$ (počet prvků na přihrádku). Průměrná délka hledání při zřetězení je $O(1 + \alpha)$ — tedy **konstantní, dokud se $\alpha$ drží omezený**. Proto se při překročení prahu (typicky $0{,}75$) tabulka **zvětší na dvojnásobek a všechno se přehashuje** — jedno přehashování stojí $O(n)$, ale amortizovaně je to zase $O(1)$, úplně stejnou úvahou jako u dynamického pole.

**Nejhorší případ $O(n)$** nastane, když všechny klíče spadnou do jedné přihrádky — tabulka pak zdegeneruje na spojový seznam. Proto se od hashovací funkce chce, aby **rovnoměrně rozprostřela** klíče a byla **rychle spočitatelná**.

> **Dvě pasti, na kterých se padá:**
>
> 1. **$O(1)$ u hashovací tabulky je průměrný případ, ne nejhorší.** Nejhorší je $O(n)$. Když řekneš jen „hashmapa má $O(1)$", doptají se přesně na tohle.
> 2. **Rovnost a hash musí být konzistentní:** jsou-li si dva objekty rovné, musí mít **stejný hash**. A když se klíč po vložení **změní**, jeho hash se změní taky a prvek se v tabulce už nenajde — přestože tam pořád je.

---

### Iterátor

- **iterátor** = objekt, který poskytuje **jednotné rozhraní pro průchod kolekcí** bez znalosti její vnitřní implementace
- odděluje **algoritmus průchodu** od **struktury dat** — proto lze stejný cyklus napsat nad polem, spojovým seznamem i stromem
- drží si **vlastní stav** průchodu (kde právě je), je typicky **jednorázový**
- je to zároveň **návrhový vzor** Iterator

**Protokol** (jména se liší, podstata je stejná):

| Jazyk | Operace |
|---|---|
| obecně | `hasNext()` + `next()` |
| Python | `__iter__()` + `__next__()`, konec signalizuje výjimka `StopIteration` |
| C# | `MoveNext()` + `Current` |

```python
it = iter([3, 1, 4])
next(it)   # 3
next(it)   # 1
```

**K čemu je to dobré:**

- kolekce může být procházená **líně** — prvky se generují až ve chvíli, kdy si o ně řeknu (Python `yield`), takže nemusí existovat všechny naráz v paměti
- jeden a týž kód (`for x in kolekce`) funguje nad libovolnou kolekcí

> **Past:** **měnit kolekci během iterace** je chyba — iterátor si drží pozici, kterou úprava zneplatní. Většina jazyků to hlídá a spadne (`ConcurrentModificationException`, `RuntimeError: dictionary changed size during iteration`). Správně se buď sbírá do nové kolekce, nebo se prochází přes kopii.

---

### Zásobník

- **zásobník (stack)** = specializovaná kolekce s přístupem **LIFO** (Last In, First Out) — poslední vložený odchází první
- **omezené rozhraní je záměr:** povolím jen tři operace a tím vynutím disciplínu přístupu

| Operace | Význam | Složitost |
|---|---|---|
| `push(x)` | vlož na vrchol | $O(1)$, u dynamického pole amortizovaně |
| `pop()` | odeber z vrcholu a vrať | $O(1)$ |
| `peek()` / `top()` | přečti vrchol bez odebrání | $O(1)$ |

**Implementace:** dynamické pole (push/pop na konci — právě tam je pole rychlé) nebo spojový seznam (vkládání a rušení na hlavě).

**Typické použití:**

- **zásobník volání** — návratové adresy a lokální proměnné při rekurzi
- vyhodnocování výrazů, převod do **postfixové** notace, kontrola párovosti závorek
- prohledávání do hloubky (DFS) — viz [okruh 12](../12-grafy-stromy/)
- funkce zpět (undo)

### Fronta

- **fronta (queue)** = specializovaná kolekce s přístupem **FIFO** (First In, First Out) — kdo přijde první, odchází první
- operace: `enqueue(x)` (vlož na konec), `dequeue()` (odeber ze začátku), `front()`/`peek()`

| Implementace | enqueue | dequeue | Poznámka |
|---|---|---|---|
| **kruhové pole** | $O(1)$ | $O(1)$ | indexy se posouvají modulo kapacita, nic se nepřesouvá |
| spojový seznam s ukazatelem na hlavu i na konec | $O(1)$ | $O(1)$ | jen přepojení ukazatelů |
| obyčejné dynamické pole | $O(1)$ | $O(n)$ | odebrání ze začátku posune všechny prvky |

**Kruhové pole** drží indexy `head` a `tail` a posouvá je `index = (index + 1) mod kapacita`. Prázdná a plná fronta pak vyjdou na `head == tail`, což se rozliší buď **uchováváním počtu prvků**, nebo tím, že se **jedna pozice nechá vždy volná**.

**Typické použití:** prohledávání do šířky (BFS), buffery, plánování úloh, producent–konzument.

**Příbuzné varianty:**

- **oboustranná fronta (deque)** — vkládání i odebírání na obou koncích
- **prioritní fronta** — neodchází nejstarší, ale **nejdůležitější** prvek; implementuje se haldou, operace $O(\log n)$

---

### Souhrnná tabulka — tady výklad graduje

| ADT | Implementace | Přístup / hledání | Vložení | Výmaz |
|---|---|---|---|---|
| seznam | statické pole | $O(1)$ / $O(n)$ | $O(n)$ | $O(n)$ |
| seznam | dynamické pole | $O(1)$ / $O(n)$ | $O(1)$ amort. na konec, jinak $O(n)$ | $O(n)$ |
| seznam | spojový seznam | $O(n)$ / $O(n)$ | $O(1)$ na začátek | $O(1)$ s referencí |
| množina, slovník | hashovací tabulka | $O(1)$ prům., $O(n)$ nejhůře | $O(1)$ prům. | $O(1)$ prům. |
| množina, slovník | vyvážený strom | $O(\log n)$ | $O(\log n)$ | $O(\log n)$ |
| zásobník | pole / spojový seznam | $O(1)$ na vrchol | $O(1)$ | $O(1)$ |
| fronta | kruhové pole / spojový seznam | $O(1)$ na okraje | $O(1)$ | $O(1)$ |

> **Věta, kterou tabulku uzavři:** „Žádná implementace nevyhrává ve všem. Vybírá se podle toho, které operace budu dělat nejčastěji — a přesně proto se odděluje ADT od implementace."

Definice $O$-notace a práce s ní patří k [okruhu 11 — Rekurence a asymptotická notace](../11-rekurence-asymptotika/), algoritmy nad seznamy (vyhledávání, řazení) k [okruhu 2](../02-algoritmy-nad-seznamy/).

---

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

- **Abstraktní datový typ** — formální specifikace typu daná množinou hodnot a množinou operací nad nimi včetně jejich sémantiky, bez určení konkrétní implementace.
- **Kolekce** — abstraktní datový typ uchovávající více prvků a poskytující operace pro jejich vkládání, rušení, vyhledávání a průchod.
- **Amortizovaná složitost** — průměrná cena jedné operace v nejhorší možné posloupnosti $n$ operací.
- **Hashovací funkce** — zobrazení klíče na celé číslo, z něhož se modulem velikosti tabulky získá index přihrádky.
- **Kolize** — situace, kdy dva různé klíče připadnou na tentýž index; kvůli většímu počtu klíčů než přihrádek jsou nevyhnutelné.
- **Faktor zaplnění** $\alpha = n/m$ — počet prvků připadající na jednu přihrádku.
- **Iterátor** — objekt poskytující jednotné rozhraní pro průchod kolekcí bez znalosti její vnitřní implementace, udržující si vlastní stav průchodu.
- **LIFO / FIFO** — pořadí odebírání: poslední vložený první / první vložený první.

---

### Příklad na papír

Tři malé příklady, které dohromady projdou celou otázku. Všechny tři se **kreslí**, ne počítají — proto jsou na tabuli vděčné a proto se dají zapamatovat jako obrázky, ne jako text.

---

#### 1. Růst dynamického pole

**Co nakreslit:** tabulku o čtyřech sloupcích. Vkládáš osm prvků do pole s počáteční kapacitou 1 a vedeš si u toho **účet zkopírovaných prvků**.

| Vkládám | Kapacita před | Realokace? | Zkopírováno |
|---|---|---|---|
| 1. | 1 | — | 0 |
| 2. | 1 | 1 → 2 | 1 |
| 3. | 2 | 2 → 4 | 2 |
| 4. | 4 | — | 0 |
| 5. | 4 | 4 → 8 | 4 |
| 6.–8. | 8 | — | 0 |

**Jak to číst.** Realokace nastane vždy jen ve chvíli, kdy je pole **právě plné** — tedy při vkládání 2., 3. a 5. prvku. Všechna ostatní vložení jsou obyčejný zápis do volné pozice za $O(1)$. Drahé kroky jsou tedy **tři z osmi**, a čím dál je jich řidčeji: mezery mezi nimi se zdvojnásobují.

**Součet:**

$$\underbrace{8}_{\text{zápisy}} + \underbrace{1 + 2 + 4}_{\text{kopie} \;=\; 7} = 15 \quad\text{kroků na 8 vložení}$$

To je necelé dva kroky na vložení, tedy **konstanta** → $O(1)$ amortizovaně. Obecně platí $1 + 2 + 4 + \cdots + n < 2n$, takže celkem méně než $3n$ kroků a na jedno vložení $3n/n = 3$.

**Co u toho říkat:** *„Jednotlivé vložení může stát $O(n)$, ale drahá vložení jsou tak vzácná, že se jejich cena rozpustí mezi levná. Amortizovaně proto $O(1)$."*

**Kontrast, kterým to dorazit** (ptají se na něj skoro vždy): kdyby pole rostlo **o konstantu $c$** místo na dvojnásobek, realokovalo by se při velikostech $c, 2c, 3c, \ldots, n$ a zkopírovalo by se

$$c + 2c + \cdots + n \approx \frac{n^2}{2c} = O(n^2)$$

tedy $O(n)$ na **jedno** vložení. Rozdíl mezi zdvojnásobováním a přičítáním je rozdíl mezi $O(1)$ a $O(n)$ — a to je celá pointa amortizované analýzy.

**Proč právě tenhle příklad:** je to jediné místo v otázce, kde se něco doopravdy **počítá**, a stejná úvaha se pak vrátí ještě dvakrát (u přehashování a u fronty ze dvou zásobníků). Když ji vyložíš tady pořádně, podruhé a potřetí už na ni jen odkážeš.

---

#### 2. Hashovací tabulka se zřetězením

**Co nakreslit:** sloupec sedmi přihrádek očíslovaných 0–6 a do nich řetízky.

Tabulka velikosti $m = 7$, hashovací funkce $h(k) = k$ (tedy index $= k \bmod 7$), vkládej klíče $15, 11, 27, 8, 22$:

$$15 \bmod 7 = 1, \quad 11 \bmod 7 = 4, \quad 27 \bmod 7 = 6, \quad 8 \bmod 7 = 1, \quad 22 \bmod 7 = 1$$

```
0: —
1: 15 → 8 → 22        ← tři klíče v jedné přihrádce, je to spojový seznam
2: —
3: —
4: 11
5: —
6: 27
```

**Proč zrovna tyhle klíče — a jak si je zapamatovat.** Kolidují právě ty tři, které se liší o sedmičku:

$$8 = 1 + 7, \qquad 15 = 1 + 14, \qquad 22 = 1 + 21$$

Všechny jsou tvaru $1 + 7k$, takže dávají **stejný zbytek po dělení sedmi**. Kolize tedy nevznikla náhodou — vznikla proto, že jsou si ta čísla **kongruentní modulo $m$**. Zapamatuj si to jako řadu 8, 15, 22 s krokem 7 a dopočítáš zbytek na místě.

**Co u toho říkat:**

1. *„Vyhledání klíče 22 musí projít celý řetěz — nejdřív 15, pak 8, teprve pak 22. To jsou tři porovnání místo jednoho."*
2. *„Faktor zaplnění je $\alpha = 5/7 \approx 0{,}71$, tedy zhruba 0,7 prvku na přihrádku, a průměrná složitost $O(1 + \alpha)$ je pořád konstanta."*
3. *„Ale kdyby všechny klíče byly kongruentní modulo 7, spadnou do jedné přihrádky, tabulka zdegeneruje na spojový seznam a jsme na $O(n)$. Proto je nejhorší případ $O(n)$, ne $O(1)$."*
4. *„Až $\alpha$ překročí práh 0,75, tabulka se zvětší na dvojnásobek a všechno se přehashuje — jedno přehashování stojí $O(n)$, ale amortizovaně je to zase $O(1)$, stejnou úvahou jako u dynamického pole."*

**Proč právě tenhle příklad:** obsahuje kolizi, řetěz, faktor zaplnění, degeneraci na $O(n)$ i odkaz zpět na amortizaci. Jsou to čtyři doptávky v jednom obrázku o sedmi řádcích.

---

#### 3. Fronta ze dvou zásobníků

Klasická doptávka. **Zdánlivý problém:** zásobník je LIFO, fronta FIFO — jak z obráceného pořadí udělat správné? **Trik:** obrátit ho dvakrát. Dvojí obrácení je původní pořadí.

Drž si dva zásobníky, `in` a `out`:

- **`enqueue(x)`** → push do `in`
- **`dequeue()`** → je-li `out` prázdný, **přelej celý** `in` do `out` (postupným pop/push, čímž se pořadí obrátí), pak pop z `out`

**Co nakreslit:** dva sloupečky vedle sebe a průběh `enqueue(1), enqueue(2), enqueue(3)` a pak tří `dequeue`. Zásobníky piš zdola nahoru, vrchol je nahoře:

```
enqueue 1,2,3                 první dequeue: out je prázdný -> přelít

   in     out                    in     out            in     out
  ┌───┐                         ┌───┐  ┌───┐                 ┌───┐
  │ 3 │← vrchol                 │   │  │ 1 │← vrchol         │ 1 │← vrátí se 1
  │ 2 │                         │   │  │ 2 │                 │ 2 │
  │ 1 │                         │   │  │ 3 │                 │ 3 │
  └───┘  └───┘                  └───┘  └───┘                 └───┘
```

Přelévání jde takhle: z `in` popneš 3, 2, 1 (v tomhle pořadí, protože je to LIFO) a v tomhle pořadí je pushneš do `out`. Na dně `out` tedy skončí trojka a **na vrcholu jednička** — přesně ta, která přišla první.

**Průběh do slov:**

| Operace | `in` (dole→nahoře) | `out` (dole→nahoře) | Vrátí |
|---|---|---|---|
| `enqueue(1)` | 1 | — | |
| `enqueue(2)` | 1, 2 | — | |
| `enqueue(3)` | 1, 2, 3 | — | |
| `dequeue()` | — | 3, 2 | **1** |
| `dequeue()` | — | 3 | **2** |
| `dequeue()` | — | — | **3** |

Vyšlo 1, 2, 3 — tedy FIFO ✓

**Složitost.** Každý prvek projde přesně čtyřmi operacemi za celý svůj život: push do `in`, pop z `in`, push do `out`, pop z `out`. Je tedy **pushnutý nejvýše dvakrát a popnutý nejvýše dvakrát**, což je konstanta na prvek — obě operace jsou **amortizovaně $O(1)$**, přestože jedno konkrétní `dequeue` může stát $O(n)$, když zrovna spustí přelití.

> **Řekni nahlas, že je to tatáž úvaha jako u dynamického pole:** drahá operace nastane zřídka a její cena se rozpočítá mezi levné. Tohle propojení dělá největší dojem z celé otázky, protože ukazuje, že amortizovaná analýza není trik na jeden příklad, ale způsob uvažování.

**Past, na kterou se ptají:** proč se `in` přelévá **celý** a jen tehdy, když je `out` **prázdný**? Kdyby ses přeléval po jednom prvku nebo pokaždé, každý prvek by putoval tam a zpět vícekrát a amortizace by přestala platit. Právě podmínka „jen když je `out` prázdný" zaručuje, že prvek přejde z `in` do `out` **nejvýše jednou**.

---

### Na co se doptají

- Jaký je rozdíl mezi abstraktním datovým typem a datovou strukturou? Uveď příklad, kdy má tentýž ADT dvě implementace s různou složitostí.
- Proč má vložení na konec dynamického pole amortizovaně $O(1)$, když realokace stojí $O(n)$? Odvoď to.
- Proč se kapacita zdvojnásobuje, a ne zvětšuje o konstantu?
- Kdy je hashovací tabulka horší než vyvážený strom? Co umí strom navíc?
- Co se stane při špatné hashovací funkci? A když se klíč po vložení změní?
- Jak se řeší kolize? Proč potřebuje otevřené adresování náhrobky?
- Čím se liší množina od seznamu z pohledu ADT, ne z pohledu implementace?
- Jak implementuješ frontu pomocí dvou zásobníků? A jakou to má složitost?
- Proč nemůžu frontu rozumně postavit na obyčejném dynamickém poli?
- K čemu je iterátor, když můžu procházet indexem? Co se stane, když kolekci během iterace změním?
- Kdy je spojový seznam opravdu lepší než pole a kdy je to jen zdání?

### Užitečné odkazy

- <https://www.bigocheatsheet.com/> (přehled složitostí kolekcí)
- <https://visualgo.net/en> (vizualizace datových struktur — hashovací tabulka i fronta)
- <https://ki.ujep.cz/opory/Aplikovana_Informatika/Bc/Algoritmizace_a_programovani_I.html>
- <https://github.com/pavelberanek91/UJEP/blob/main/APR2/2_sekvencni_struktury.ipynb>
