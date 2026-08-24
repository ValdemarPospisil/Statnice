## 3 — Spojové datové struktury

> Spojové datové struktury (jednosměrný spojový seznam, binární strom) a základní operace nad nimi (vkládání, výmaz, vyhledávání) včetně časové složitosti

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. Společný princip — **uzel = data + odkaz**; prvky neleží vedle sebe, drží je pohromadě odkazy. Co tím získám a co ztratím oproti poli
2. Jednosměrný spojový seznam — hlava, uzly, `null` na konci; proč **nejde indexovat** v $O(1)$
3. Operace nad seznamem: vložení na začátek $O(1)$, na konec $O(n)$, vyhledání $O(n)$, výmaz — a past, že u jednosměrného potřebuju **předchůdce**
4. Varianty: obousměrný, kruhový, s ukazatelem na konec; paměťová režie odkazů
5. Binární strom — kořen, uzel, list, podstrom, hloubka uzlu, výška stromu, hladina
6. Klíčový vztah **$n$ vs. výška**: hladina $k$ má nejvýš $2^k$ uzlů $\Rightarrow$ $h \approx \log_2 n$ u vyváženého, $h = n-1$ u degenerovaného
7. Binární vyhledávací strom — **invariant** (vlevo menší, vpravo větší, a to rekurzivně)
8. Vyhledání, vložení, výmaz v BVS: **všechno je $O(h)$** — proto je celá otázka o tom, jak velké je $h$
9. Výmaz v BVS — tři případy: list / jeden potomek / dva potomci (náhrada **inorder následníkem**)
10. Průchody: preorder, **inorder** (dá setříděnou posloupnost!), postorder, BFS po hladinách
11. Degenerace na setříděném vstupu — strom se **zvrhne zpátky v seznam**; lék jsou vyvažované stromy (AVL, červeno-černý)
12. Souhrnná tabulka: pole vs. spojový seznam vs. BVS — tady výklad graduje

**Nit, na kterou to navlékni:** pole drží prvky **vedle sebe**, takže adresu spočítá, ale při každé změně musí přesouvat. Spojové struktury drží prvky **kdekoli v paměti a spojuje je odkazy** — přepojení je pak zadarmo, ale k prvku se musí **dojít krok po kroku**. Jednosměrný seznam dává každému uzlu **jeden** odkaz, takže se dojít dá jen jedinou cestou → $O(n)$. Binární strom dá uzlu **dva**, a tím vznikne **volba** — v každém uzlu zahodím půlku struktury, přesně jako u binárního vyhledávání → $O(\log n)$. Celá otázka je o tom, že za tuhle volbu se platí **vyvážeností**: když ji strom ztratí, spadne zpátky na seznam.

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tahák, který si vyrobíš zpaměti hned na začátku přípravy. Napsání zabere zhruba tři minuty, zbylých dvanáct pak máš na rozmyšlení příkladu.

```
UZEL = data + odkaz(y).  Prvky NEleží vedle sebe, drží je pohromadě ODKAZY.
       přepojení zadarmo, ale k prvku se musí DOJÍT

JEDNOSMĚRNÝ SEZNAM:  head -> [d|next] -> [d|next] -> [d|null]

  přístup na i-tý         n
  vyhledání               n
  vložení na začátek      1
  vložení na konec        n     (1, když si držím tail)
  vložení za daný uzel    1
  výmaz                   n     (musím najít PŘEDCHŮDCE!)

STROM: hladina k má nejvýš 2^k uzlů
       -> n = 1+2+4+...+2^h = 2^(h+1) - 1  ->  h = log n

BVS INVARIANT: levý podstrom < uzel < pravý podstrom, REKURZIVNĚ
BVS: vyhledání i vložení i výmaz = O(h)
     h = log n  vyvážený   |   h = n-1  degenerovaný

VÝMAZ v BVS - 3 případy:
  list        -> odpoj
  1 potomek   -> přepoj rodiče rovnou na potomka
  2 potomci   -> nahraď INORDER NÁSLEDNÍKEM (nejlevější v pravém
                 podstromu) a smaž ten uzel (ten má nejvýš 1 potomka)

PRŮCHODY (kde je Kořen):  preorder  K L P
                          inorder   L K P   -> SETŘÍDĚNÁ POSLOUPNOST
                          postorder L P K
                          BFS = po hladinách, přes FRONTU

PASTI: výmaz z JEDNOSMĚRNÉHO seznamu potřebuje předchůdce -> n
       binární vyhledávání v seznamu NEJDE (není skok na index)
       SETŘÍDĚNÝ vstup do BVS -> degeneruje na seznam -> AVL, červeno-černý
       režie: odkaz zabírá paměť a rozbíjí lokalitu cache

PŘÍKLAD: vlož 50 30 70 20 40 60 80 -> h=2, n=7 = 2^3-1, hledám 40 = 3 kroky
         smaž 30 (dva potomci) -> nahradí ho 40
         inorder: 20 30 40 50 60 70 80
         vlož 20 30 40 50 -> jen doprava, h=3 = SEZNAM
```

#### Jak si to zapamatovat, aniž bys to biflil

Celá otázka jsou **dva obrazy** a jeden mezi ně schovaný trik:

> **Seznam je řetěz. Strom je rozcestník. Rozcestník s jednou cestou je zase řetěz.**

- **řetěz** — z každého článku vede **jedna** cesta dál, takže se dá jen procházet; než někam dojdu, minu všechno před tím → $O(n)$
- **rozcestník** — z každého uzlu vedou **dvě** cesty a já si jednu vyberu, čímž **druhou celou zahodím**; půlení → $O(\log n)$
- **rozcestník s jednou cestou** — degenerovaný strom; není co zahazovat, takže je to zpátky řetěz → $O(n)$

Z těch tří vět vypadne celá tabulka:

| Obraz | Co je levné | Co je drahé | Proč |
|---|---|---|---|
| **řetěz** (seznam) | přepojit sousedy, $O(1)$ | dojít na místo, $O(n)$ | odkaz změním za konstantu, ale k němu musím doskákat |
| **rozcestník** (vyvážený BVS) | $O(\log n)$ na všechno | udržet vyváženost | dva potomci → v každém kroku zahodím půlku |
| **degenerovaný strom** | nic | $O(n)$ na všechno | jedna větev = žádná volba = žádné půlení |

**Názvy průchodů si taky neuč — přečti si je.** Předpona říká, **kde v pořadí je Kořen** vůči podstromům: *pre*order = kořen **před** (K L P), *in*order = kořen **mezi** nimi (L K P), *post*order = kořen **po** (L P K). Levý podstrom je vždycky před pravým.

A že **inorder dá setříděnou posloupnost**, je přímý důsledek invariantu: L K P znamená „nejdřív všechno menší, pak uzel, pak všechno větší" — a to platí v každém uzlu, tedy i pro celý strom.

Jediné, co si opravdu pamatuj jako fakt, je **inorder následník** u výmazu se dvěma potomky. I ten ale má důvod: je to **nejbližší větší hodnota**, takže když ji dám na uvolněné místo, zůstane všechno vlevo menší a všechno vpravo větší — invariant přežije.

---

### Společný základ: uzel a odkaz

- **spojová (dynamická) datová struktura** = struktura složená ze samostatně alokovaných **uzlů**, které se odkazují jeden na druhý; velikost není daná dopředu a mění se za běhu
- **uzel** = záznam obsahující **data** a **jeden nebo více odkazů (referencí, ukazatelů)** na další uzly
- odkaz na „nic" se značí `null` / `None` / `nullptr` — ukončuje strukturu

Rozdíl proti poli je jediný, ale všechno z něj plyne:

| | Pole | Spojová struktura |
|---|---|---|
| kde prvky leží | v **souvislém** bloku paměti | **kdekoli**, spojené odkazy |
| adresa $i$-tého prvku | **spočítá se**: `začátek + i·velikost` | nespočítá se, musí se **dojít** |
| vložení/výmaz uprostřed | posun všeho za tím, $O(n)$ | **přepojení odkazů**, $O(1)$ |
| velikost | pevná (nebo realokace) | roste a klesá po jednom uzlu |
| paměť navíc | žádná | **odkaz u každého uzlu** |

> **Věta, kterou to shrň:** „Pole platí za rychlý přístup pomalými změnami, spojová struktura platí za rychlé změny pomalým přístupem." Podrobněji to je [okruh 1](../01-abstraktni-kolekce/).

---

### Jednosměrný spojový seznam

- **jednosměrný spojový seznam** (singly linked list) = spojová struktura, v níž má každý uzel právě **jeden** odkaz — na svého **následníka**; poslední uzel odkazuje na `null`
- přístup do struktury je jen přes **hlavu** (`head`), ukazatel na první uzel
- prázdný seznam = `head` je `null`

```
head
 │
 ▼
┌────┬───┐   ┌────┬───┐   ┌────┬───┐
│ 5  │ ──┼──▶│ 8  │ ──┼──▶│ 3  │ ∅ │
└────┴───┘   └────┴───┘   └────┴───┘
```

```python
class Uzel:
    def __init__(self, data, next=None):
        self.data = data
        self.next = next
```

> Vztah `Uzel → Uzel` je **rekurzivní**: uzel obsahuje odkaz na strukturu téhož typu. Proto se seznamy i stromy tak přirozeně zpracovávají rekurzí.

#### Vyhledání — $O(n)$

Jediná možnost je jít od hlavy po odkazech a porovnávat. Nedá se nic přeskočit.

```python
def najdi(head, hodnota):
    p = head
    while p is not None:
        if p.data == hodnota:
            return p
        p = p.next
    return None
```

- nejlepší případ $O(1)$ (hned první), nejhorší $O(n)$ (poslední **nebo tam vůbec není**)
- **přístup na $i$-tý prvek je taky $O(n)$** — index se nedá spočítat, musí se odkrokovat

> **Past, kterou musíš umět vysvětlit:** v setříděném spojovém seznamu **nejde binární vyhledávání**, i když je setříděný. Binární vyhledávání potřebuje skok doprostřed v $O(1)$, ale ten by tady stál $O(n)$ — celý algoritmus by spadl na $O(n)$, a ještě s režií navíc. Setříděnost tedy u spojového seznamu **nic nezrychlí** (leda ukončení hledání dřív). Viz [okruh 2](../02-algoritmy-nad-seznamy/).

#### Vkládání

| Kam | Složitost | Jak |
|---|---|---|
| **na začátek** | $O(1)$ | nový uzel ukáže na starou hlavu, hlava se přesune na něj |
| **za daný uzel** (mám na něj referenci) | $O(1)$ | dvě přepojení, žádné hledání |
| **na konec** | $O(n)$ | musím dojít na poslední uzel — **ale $O(1)$, když si držím ukazatel `tail`** |
| **na $i$-tou pozici** | $O(n)$ | dojití na pozici; samotné vložení je pak $O(1)$ |

```python
def vloz_na_zacatek(head, data):
    return Uzel(data, head)      # nový uzel ukáže na starou hlavu
```

**Na pořadí přepojení záleží** a je to oblíbená doptávka. Při vkládání za uzel `p`:

```python
novy.next = p.next      # 1) nejdřív si nový uzel zapamatuje zbytek seznamu
p.next = novy           # 2) teprve pak ho p přebere
```

Kdyby se to udělalo obráceně, přepisem `p.next` **ztratím odkaz na zbytek seznamu** a ten se stane nedosažitelným.

#### Výmaz — a past, na které se padá

Aby šel uzel vyříznout, musí se **přepojit jeho předchůdce** na jeho následníka:

```
před:   ... ─▶ [ 8 ] ─▶ [ 3 ] ─▶ [ 7 ] ─▶ ...
                          ↑ mažu

po:     ... ─▶ [ 8 ] ─────────▶ [ 7 ] ─▶ ...
```

```python
def smaz(head, hodnota):
    if head is None:
        return None
    if head.data == hodnota:
        return head.next                 # mažu hlavu: hlavou se stane druhý uzel
    p = head
    while p.next is not None and p.next.data != hodnota:
        p = p.next                       # zastavím se PŘED mazaným uzlem
    if p.next is not None:
        p.next = p.next.next             # přeskočím ho
    return head
```

> **Past:** často se říká, že spojový seznam maže v $O(1)$. To platí, jen **když už mám referenci na předchůdce** (nebo je seznam obousměrný). U jednosměrného seznamu, kde mám referenci **jen na mazaný uzel**, musím předchůdce hledat od hlavy → **$O(n)$**. Tohle je nejčastější doptávka k téhle otázce.
>
> **Trik, kterým to obejdeš** (a kterým zaujmeš): zkopíruju data **následníka** do mazaného uzlu a smažu **následníka** — na toho referenci mám. Je to $O(1)$, ale **nefunguje na poslední uzel**, protože ten následníka nemá.

#### Varianty a jejich smysl

| Varianta | Co přidá | Za co |
|---|---|---|
| **s ukazatelem `tail`** | vložení na konec $O(1)$ | jeden ukazatel navíc |
| **obousměrný** (každý uzel má i `prev`) | výmaz daného uzlu $O(1)$, průchod oběma směry | odkaz navíc u každého uzlu, dvojnásobná režie |
| **kruhový** (poslední ukazuje na hlavu) | cyklický průchod bez konce | pozor na nekonečnou smyčku |

**Paměťová režie:** kromě dat platím **jeden odkaz na uzel** (na 64bitovém systému 8 B) plus režii samostatné alokace každého uzlu. U malých dat (např. jednotlivá čísla) může být režie **větší než data sama**. Navíc uzly leží roztroušené po paměti, takže se hůř využívá **cache procesoru** — pole je v praxi rychlejší i tam, kde má horší asymptotiku.

**Kde se s tím potkáš, i když ho nepíšeš:** zřetězení v hashovací tabulce, seznam volných bloků v alokátoru paměti, historie zpět/vpřed (obousměrný), implementace fronty a zásobníku, `LinkedList` v Javě a C#.

---

### Binární strom

- **strom** = hierarchická spojová struktura; **souvislý graf bez kružnic** s vyznačeným **kořenem**
- **binární strom** = strom, v němž má každý uzel **nejvýš dva** potomky, a **záleží na tom, který je který** — levý a pravý nejsou zaměnitelní
- definice je **rekurzivní**: binární strom je buď prázdný, nebo je to kořen s **levým** a **pravým podstromem**, které jsou samy binární stromy

```python
class Uzel:
    def __init__(self, klic, levy=None, pravy=None):
        self.klic = klic
        self.levy = levy
        self.pravy = pravy
```

#### Pojmy, které musíš umět ukázat na obrázku

```
                  50          ← kořen, hloubka 0
                /    \
              30      70      ← hladina 1
             /  \    /  \
           20   40  60   80   ← hladina 2, samé listy

  výška stromu = 2 (nejdelší cesta kořen → list má 2 hrany)
```

(Je to tentýž strom, na kterém bude [příklad níže](#příklad-2--binární-vyhledávací-strom) — ať se nemusíš učit dva.)

| Pojem | Význam |
|---|---|
| **kořen** | jediný uzel bez rodiče, vstupní bod struktury |
| **rodič / potomek** | uzly spojené jednou hranou, směrem od kořene |
| **sourozenci** | uzly se stejným rodičem |
| **list** | uzel bez potomků |
| **vnitřní uzel** | uzel s aspoň jedním potomkem |
| **podstrom** | uzel se všemi svými potomky — sám je zase strom |
| **hloubka uzlu** | počet hran od **kořene** k němu (kořen má 0) |
| **hladina (úroveň)** | množina uzlů téže hloubky |
| **výška stromu** | počet hran nejdelší cesty od kořene k listu |

> **Konvence, kterou si ohlídej:** výška se dá měřit v **hranách** i v **uzlech** a různé zdroje se liší o jedničku. Řekni, kterou používáš — „výška = počet hran, takže jednoprvkový strom má výšku 0" — a drž se jí. Zkoušející ocení, že si toho jsi vědom.

#### Vztah mezi počtem uzlů a výškou — tohle je jádro celé otázky

Kořen je jeden, každá hladina může mít **dvojnásobek** předchozí:

$$\text{hladina } 0: 1, \quad \text{hladina } 1: 2, \quad \text{hladina } 2: 4, \quad \dots, \quad \text{hladina } k: 2^k$$

Strom výšky $h$ má tedy **nejvýš**

$$n \le 1 + 2 + 4 + \cdots + 2^h = 2^{h+1} - 1 \quad\text{uzlů}$$

a z toho obráceně

$$h \ge \log_2(n+1) - 1, \qquad \text{tedy } h = \Omega(\log n)$$

**Slovy:** $n$ uzlů se do menší výšky než zhruba $\log_2 n$ nevejde, a **vyvážený strom té meze dosahuje**. Naopak nejhorší možná výška je $h = n-1$, když je z každého uzlu jen jeden potomek.

| Tvar stromu | Výška | Příklad pro $n = 7$ |
|---|---|---|
| **dokonale vyvážený** | $\lfloor \log_2 n \rfloor = 2$ | plné tři hladiny, $7 = 2^3 - 1$ |
| **degenerovaný** | $n - 1 = 6$ | řetěz sedmi uzlů = spojový seznam |

#### Speciální tvary

| Název | Podmínka |
|---|---|
| **plný (full)** | každý uzel má **0 nebo 2** potomky |
| **úplný (complete)** | všechny hladiny plné kromě poslední, ta zaplněná **zleva** |
| **dokonalý (perfect)** | všechny hladiny plné, $n = 2^{h+1}-1$ |
| **vyvážený** | v **každém** uzlu se výšky podstromů liší nejvýš o 1 |
| **degenerovaný** | každý uzel má nejvýš jednoho potomka |

#### Reprezentace

1. **Uzly s odkazy** (obvyklá) — každý uzel drží `levy` a `pravy`; paměť roste s počtem uzlů, tvar může být libovolný.
2. **Polem** — kořen na indexu 0, potomci uzlu $i$ na indexech $2i+1$ a $2i+2$, rodič na $\lfloor (i-1)/2 \rfloor$. Žádné odkazy, výborná lokalita cache — **ale jen pro úplný strom**; u řídkého stromu zůstávají v poli díry a spotřeba je až $2^{h+1}$. Přesně tak se implementuje **halda**.

---

### Binární vyhledávací strom (BVS)

- **binární vyhledávací strom** (BST) = binární strom, v němž pro **každý** uzel platí:
  - všechny klíče v **levém** podstromu jsou **menší** než klíč uzlu,
  - všechny klíče v **pravém** podstromu jsou **větší**,
  - a totéž platí **rekurzivně** uvnitř obou podstromů

> **Zdůrazni to slovo „rekurzivně".** Nestačí, aby platilo pro přímé potomky — musí to platit pro **celé podstromy**. To je nejčastější chyba v definici, kterou zkoušející slyší.

To je invariant, na kterém stojí všechno ostatní: **v každém uzlu jedno porovnání rozhodne, do které poloviny jít, a druhá se celá zahodí.** Je to binární vyhledávání z [okruhu 2](../02-algoritmy-nad-seznamy/), jen zapsané v odkazech místo v indexech.

#### Vyhledání — $O(h)$

```python
def najdi(uzel, klic):
    while uzel is not None:
        if klic == uzel.klic:
            return uzel
        uzel = uzel.levy if klic < uzel.klic else uzel.pravy
    return None          # došel jsem na null → klíč tam není
```

Jedno porovnání na hladinu, takže **počet kroků = délka cesty od kořene**, tedy nejvýš $h+1$.

Ze stejného invariantu plyne i to, že **minimum je nejlevější uzel** (jdi pořád doleva) a **maximum nejpravější** — obojí $O(h)$.

#### Vložení — $O(h)$

Hledej klíč, jako bys ho chtěl najít. Když dojdeš na `null`, je to **přesně to místo**, kde měl být — pověs tam nový **list**.

```python
def vloz(uzel, klic):
    if uzel is None:
        return Uzel(klic)                        # sem patří
    if klic < uzel.klic:
        uzel.levy = vloz(uzel.levy, klic)
    elif klic > uzel.klic:
        uzel.pravy = vloz(uzel.pravy, klic)
    return uzel                                  # rovnost = nic nedělám
```

Nový uzel vzniká **vždycky jako list**, takže se nic nepřepojuje uvnitř — jen se připojí na konec cesty.

#### Výmaz — tři případy

Tohle je jediné místo otázky, kde je potřeba pořádný postup. Vždycky ho vyjmenuj jako tři případy:

| Případ | Co udělám |
|---|---|
| **1. list** | prostě ho odpojím (odkaz rodiče na `null`) |
| **2. jeden potomek** | rodiče přepojím **rovnou na potomka** — podstrom se posune o patro výš a invariant platí dál |
| **3. dva potomci** | klíč uzlu **nahradím inorder následníkem** a pak smažu ten následník |

**Inorder následník** = nejmenší klíč **v pravém podstromu**, tedy jeho **nejlevější** uzel.

Dvě věci k tomu řekni nahlas:

- **Proč zrovna on:** je to **nejbližší větší** hodnota v celém stromu. Když ji dám na uvolněné místo, zůstane všechno v levém podstromu menší a všechno ve zbytku pravého větší — **invariant přežije**. Symetricky by fungoval i inorder předchůdce (největší v levém podstromu).
- **Proč to skončí:** nejlevější uzel **nemá levého potomka** (jinak by nebyl nejlevější), takže má nejvýš jednoho potomka — jeho smazání spadne do případu 1 nebo 2. **Rekurze se nikdy nezacyklí.**

Všechny tři případy jsou $O(h)$: dojití k uzlu, případně ještě sestup k následníkovi, a pak konstantní počet přepojení.

#### Proč je všechno $O(h)$ a co to znamená

| Operace | Složitost | Vyvážený strom | Degenerovaný strom |
|---|---|---|---|
| vyhledání | $O(h)$ | $O(\log n)$ | $O(n)$ |
| vložení | $O(h)$ | $O(\log n)$ | $O(n)$ |
| výmaz | $O(h)$ | $O(\log n)$ | $O(n)$ |
| minimum / maximum | $O(h)$ | $O(\log n)$ | $O(n)$ |
| průchod (všechny uzly) | $O(n)$ | $O(n)$ | $O(n)$ |

> **Past, která rozhoduje celou otázku:** BVS **sám o sobě nezaručuje $O(\log n)$**. Zaručuje $O(h)$ — a jak velké je $h$, závisí na **pořadí vkládání**. Když do prázdného stromu vložím **už setříděnou posloupnost**, každý další klíč je větší než všechny předchozí, takže se pověsí vpravo dolů a vznikne **řetěz**: $h = n-1$, všechny operace $O(n)$. Strom se doslova **zvrhne zpátky ve spojový seznam**, jen s dvojnásobnou paměťovou režií.
>
> **Řešení:** samovyvažující stromy, které po každé změně obnoví vyváženost **rotacemi** — **AVL strom** (přísně vyvážený, rychlé hledání) a **červeno-černý strom** (volnější, levnější vkládání; používá ho `TreeMap` v Javě a `std::map` v C++). Pro data na disku **B-strom** s vysokým větvením. Všechny drží $h = O(\log n)$ **zaručeně**.

---

### Průchody stromem

**Průchod (traverzace)** = navštívení každého uzlu **právě jednou**. Vždycky $O(n)$ času, protože každý uzel se navštíví jednou a každá hrana projde dvakrát.

Do hloubky (**DFS**, rekurzí nebo zásobníkem) se liší jen tím, **kdy se zpracuje kořen**:

| Průchod | Pořadí | Na stromu výše | K čemu je |
|---|---|---|---|
| **preorder** | **K** L P | 50, 30, 20, 40, 70, 60, 80 | **kopie / serializace** stromu (uzel musí vzniknout dřív než potomci), prefixový zápis výrazu |
| **inorder** | L **K** P | 20, 30, 40, 50, 60, 70, 80 | **setříděná posloupnost** klíčů, infixový zápis |
| **postorder** | L P **K** | 20, 40, 30, 60, 80, 70, 50 | **rušení / uvolnění** stromu (potomky dřív než rodiče), výpočet výšky nebo velikosti, postfixový (polský) zápis |

```python
def inorder(uzel):
    if uzel is None:
        return
    inorder(uzel.levy)       # L
    print(uzel.klic)         # K
    inorder(uzel.pravy)      # P
```

Do šířky (**BFS**, level-order) prochází **hladinu po hladině** a potřebuje k tomu **frontu**: vezmi uzel z fronty, zpracuj ho, jeho potomky zařaď na konec. Používá se, když se hledá **nejkratší cesta** nebo se strom kreslí po patrech. Podrobně v [okruhu 12](../12-grafy-stromy/).

**Paměťová složitost průchodů:** DFS potřebuje $O(h)$ na zásobník volání (u degenerovaného stromu tedy $O(n)$ — a hrozí přetečení zásobníku), BFS potřebuje $O(n)$ na frontu, protože poslední hladina může mít až polovinu všech uzlů.

> **Doptávka, která přijde skoro jistě:** „Kterým průchodem dostanu klíče setříděné?" **Inorder**, a důvod je invariant: L K P znamená „nejdřív všechno menší, pak uzel, pak všechno větší". Následek, kterým to korunuj: **procházení BVS inorder je řadicí algoritmus** — vložit $n$ prvků stojí $O(n \log n)$ a průchod $O(n)$, dohromady $O(n \log n)$, stejně jako merge sort z [okruhu 2](../02-algoritmy-nad-seznamy/).

---

### Souhrnná tabulka — tady výklad graduje

| Struktura | Přístup na $i$-tý | Vyhledání | Vložení | Výmaz | Paměť navíc | Drží pořadí? |
|---|---|---|---|---|---|---|
| pole | $O(1)$ | $O(n)$ | $O(n)$ | $O(n)$ | žádná | dle indexu |
| setříděné pole | $O(1)$ | $O(\log n)$ | $O(n)$ | $O(n)$ | žádná | setříděné |
| jednosměrný seznam | $O(n)$ | $O(n)$ | $O(1)$ na začátek | $O(n)$ | odkaz / uzel | dle vložení |
| obousměrný seznam | $O(n)$ | $O(n)$ | $O(1)$ na okraje | $O(1)$ s referencí | 2 odkazy / uzel | dle vložení |
| **BVS vyvážený** | — | $O(\log n)$ | $O(\log n)$ | $O(\log n)$ | 2 odkazy / uzel | **setříděné (inorder)** |
| **BVS degenerovaný** | — | $O(n)$ | $O(n)$ | $O(n)$ | 2 odkazy / uzel | setříděné |
| hashovací tabulka | — | $O(1)$ průměrně | $O(1)$ průměrně | $O(1)$ průměrně | řídké pole | **ne** |

> **Věta, kterou tabulku uzavři:** „Spojová struktura nekupuje rychlost tím, že by uměla líp počítat — kupuje ji **tvarem**. Řetěz nemá volbu, tak se musí projít celý. Strom volbu má, a proto půlí. Ale tu volbu si musí **udržovat**, a jakmile ji ztratí, je z něj zase řetěz."
>
> A když se ptají, proč tedy nepoužívat rovnou hashovací tabulku, když je $O(1)$: **hash nedrží pořadí.** Nedokáže odpovědět na dotaz „nejbližší menší", „všechny klíče mezi $a$ a $b$" ani „vypiš setříděně". Za tohle se u BVS platí tím logaritmem. Viz [okruh 1](../01-abstraktni-kolekce/).

---

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

- **Spojová datová struktura** — struktura tvořená samostatně alokovanými uzly, které jsou propojené odkazy; její velikost není určena předem a mění se za běhu.
- **Uzel** — základní prvek spojové struktury; obsahuje data a jeden nebo více odkazů na další uzly.
- **Jednosměrný spojový seznam** — spojový seznam, v němž každý uzel obsahuje právě jeden odkaz, a to na následující uzel; vzniká tak řetězec od počátečního uzlu (hlavy) k poslednímu, jehož odkaz je prázdný.
- **Binární strom** — buď prázdný strom, nebo kořen s uspořádanou dvojicí podstromů (levým a pravým), které jsou samy binárními stromy; každý uzel má tedy nejvýše dva potomky a záleží na jejich pořadí.
- **Binární vyhledávací strom** — binární strom, v němž pro každý uzel platí, že všechny klíče v jeho levém podstromu jsou menší a všechny klíče v jeho pravém podstromu větší než klíč tohoto uzlu.
- **Hloubka uzlu** — počet hran na cestě od kořene k danému uzlu.
- **Výška stromu** — počet hran na nejdelší cestě od kořene k listu.
- **List** — uzel, který nemá žádného potomka.
- **Podstrom** — uzel spolu se všemi svými potomky; je opět stromem.
- **Vyvážený strom** — strom, v němž se u každého uzlu liší výšky levého a pravého podstromu nejvýše o jedna.
- **Průchod stromem** — postup navštívení každého uzlu právě jednou.
- **Inorder následník uzlu** — nejmenší klíč v jeho pravém podstromu, tedy nejlevější uzel tohoto podstromu.

---

### Příklad na papír

U zkoušky ukážeš **jeden**. První je rychlý na nakreslení a pokrývá seznam; druhý je hlavní a navazuje na něj, takže když bude čas, jdou plynule za sebou.

---

#### Příklad 1 — přepojení ve spojovém seznamu

##### Co se má ukázat

Že **veškerá práce je v dojití, ne v samotné změně** — a že na **pořadí přepojení** záleží.

##### Vložení za uzel

Mám seznam a chci vložit `6` mezi `5` a `8`:

```
před:    head ─▶ [ 5 ] ─▶ [ 8 ] ─▶ [ 3 ] ─▶ ∅

krok 1:  novy.next = p.next        [ 6 ] ─┐
         (nový si zapamatuje              ▼
          zbytek seznamu)   [ 5 ] ─▶ [ 8 ] ─▶ [ 3 ] ─▶ ∅

krok 2:  p.next = novy      [ 5 ] ─▶ [ 6 ] ─▶ [ 8 ] ─▶ [ 3 ] ─▶ ∅
```

**Řekni k tomu, proč nesmí jít kroky obráceně:** kdybych nejdřív přepsal `p.next = novy`, ztratil bych jediný odkaz na uzel `8` a celý zbytek seznamu by se stal **nedosažitelným**. Tohle je klasická chyba a zkoušející se na ni rád zeptá.

##### Výmaz

Chci smazat uzel `8`:

```
před:    [ 5 ] ─▶ [ 8 ] ─▶ [ 3 ] ─▶ ∅
                    ↑ mažu

po:      [ 5 ] ────────────▶ [ 3 ] ─▶ ∅        p.next = p.next.next
```

**Pointa, kterou to uzavři:** samotné přepojení je **jediné přiřazení, tedy $O(1)$**. Ale abych se k uzlu `5` (předchůdci!) dostal, musím projít seznam od hlavy — a to je $O(n)$. **Proto se výmaz z jednosměrného seznamu počítá jako $O(n)$.** U obousměrného seznamu bych předchůdce dostal odkazem `prev` a byl by to $O(1)$.

##### Doptávka, která přijde

**„A kdybyste měl referenci přímo na mazaný uzel?"** U jednosměrného seznamu to nestačí — z uzlu se na předchůdce nedostanu. Buď hledám od hlavy ($O(n)$), nebo použiju trik: **zkopíruju data následníka do mazaného uzlu a smažu následníka**. To je $O(1)$, ale nefunguje na posledním uzlu.

---

#### Příklad 2 — binární vyhledávací strom

##### Stavba stromu

Vkládám do prázdného stromu v tomto pořadí: **50, 30, 70, 20, 40, 60, 80**.

Každý klíč se hledá od kořene, dokud se nenarazí na prázdno — tam se pověsí jako list:

```
              50              ← 50 je první, stane se kořenem
            /    \
          30      70          30 < 50 vlevo,  70 > 50 vpravo
         /  \    /  \
       20   40  60   80       20 < 30 vlevo, 40 > 30 vpravo, atd.
```

**Kontrola vztahu $n$ a $h$:** $n = 7$, $h = 2$, a opravdu $7 = 2^{2+1} - 1$. Strom je **dokonalý** — tři plné hladiny.

##### Vyhledání 40

```
50 → 40 < 50 → doleva
30 → 40 > 30 → doprava
40 → nalezeno            3 porovnání = h + 1
```

**Řekni nahlas, co se stalo:** první porovnání zahodilo `70, 60, 80` — **celou půlku stromu**, aniž bych se na ni podíval. To je přesně binární vyhledávání, jen místo indexu `mid` používám odkazy.

##### Výmaz 30 — případ se dvěma potomky

Uzel `30` má dva potomky, takže platí třetí případ: **najdi inorder následníka**, tedy nejmenší klíč v pravém podstromu uzlu `30`. Pravý podstrom je `{40}`, jeho nejlevější uzel je **40**.

```
1) klíč 30 nahradím čtyřicítkou
2) původní uzel 40 smažu — je to list, tedy případ 1

              50                            50
            /    \                        /    \
          30      70        →           40      70
         /  \    /  \                  /       /  \
       20   40  60   80              20      60   80
```

**Ověření invariantu:** vlevo od `40` je `20` (menší ✓), a `40` je pořád menší než `50` ✓. Strom je pořád BVS.

**Proč zrovna inorder následník:** je to **nejbližší větší** hodnota v celém stromu, takže mezi ní a vším ostatním nic neleží — invariant se tím nemůže porušit. A protože je to **nejlevější** uzel svého podstromu, nemá levého potomka, takže jeho vlastní smazání spadne do jednoduchého případu.

##### Inorder průchod (na stromu **po** výmazu)

```
20, 40, 50, 60, 70, 80
```

Setříděno. **To není náhoda** — L K P znamená „všechno menší, pak uzel, pak všechno větší", a to platí v každém uzlu.

##### A teď to hlavní: co se stane se setříděným vstupem

Vlož do **prázdného** stromu **20, 30, 40, 50** v tomto pořadí. Každý klíč je větší než všechny předchozí, takže se pořád jde jen doprava:

```
       20
         \
          30
            \
             40
               \
                50
```

$h = 3 = n - 1$. Hledání `50` teď trvá **4 kroky místo 2**, a obecně $O(n)$ místo $O(\log n)$.

> **Tohle je věta, kterou celou otázku uzavři:** „Degenerovaný binární vyhledávací strom **je** jednosměrný spojový seznam — jen s odkazem navíc, který nikam nevede. Obě poloviny téhle otázky jsou tedy dva krajní případy jedné a téže věci: strom je seznam, který se umí větvit, a **jakmile se přestane větvit, je z něj zase seznam**."

**A co s tím:** samovyvažující stromy (AVL, červeno-černý) po každém vložení zkontrolují vyváženost a případně provedou **rotaci** — lokální přepojení tří uzlů, které sníží výšku a zachová invariant. Tím drží $h = O(\log n)$ **zaručeně**, nezávisle na pořadí vkládání. Rotace samotné už jsou látka nad rámec otázky, ale zmínit je se vyplatí.

---

### Na co se doptají

- Nakresli, co se stane, když do prázdného BVS vkládáš už setříděnou posloupnost. Jaká je pak složitost hledání?
- Jak smažeš uzel se dvěma potomky? Proč zrovna následník v inorder pořadí a proč se tím rekurze zastaví?
- Jaká je paměťová režie spojového seznamu oproti poli?
- Kde v praxi narazíš na spojový seznam, i když ho přímo nepíšeš?
- Proč nejde ve spojovém seznamu binárně vyhledávat, i když je setříděný?
- Mám referenci přímo na uzel, který chci smazat. Je to v jednosměrném seznamu $O(1)$?
- Kterým průchodem dostanu klíče setříděné a proč?
- Odvoď, proč má vyvážený binární strom výšku zhruba $\log_2 n$.
- Jaký je rozdíl mezi hloubkou uzlu a výškou stromu?
- Proč platí, že operace v BVS jsou $O(h)$, a ne rovnou $O(\log n)$?
- Kdy použiješ BVS a kdy hashovací tabulku, když je hash rychlejší?
- Jak se liší úplný, plný a dokonalý binární strom?

### Užitečné odkazy

- <https://visualgo.net/en/bst> (krokovaná vizualizace BVS včetně výmazu a rotací)
- <https://visualgo.net/en/list> (vizualizace spojových seznamů)
- <https://www.cs.usfca.edu/~galles/visualization/BST.html>
- <https://runestone.academy/ns/books/published/pythonds/Trees/toc.html>
- <https://ki.ujep.cz/opory/Aplikovana_Informatika/Bc/Algoritmizace_a_programovani_II.html>
