## 10 — Výrokový a predikátový počet, množiny, binární relace

> Výrokový počet (logické spojky, jejich úplný systém, odvozovací pravidla, splnitelnost, aplikace v logických obvodech), predikátový počet (abeceda a konstrukce jazyka), naivní teorie množin (potenční množina, systém množin, operace na množinách, relace mezi množinami), binární relace (vlastnosti a speciální typy [ekvivalence, uspořádání, zobrazení])

- [Poznámky z konzultace](./poznamky-z-konzultace.md) — mimo jiné rozdělení důrazu (výrokový počet 40 %, množiny 40 %, relace 20 %) a to, že predikátový počet si nikdo nevybírá

> **Nejdůležitější věta z konzultace:** zkoušející se zeptá, **o čem chceš mluvit**. Nemusíš umět všechno — stačí dvě až tři podtémata pořádně. Podle vah to jsou **množiny a výrokový počet**, relace jako doplněk.

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. **Zopakovat, jak zněla otázka**, a rovnou říct, čemu se budeš věnovat — *„vezmu výrokový počet a množiny, relace zmíním na konci"*
2. **Výrok** — sdělení, u kterého má smysl ptát se na pravdivost; **atomární** (jedno sloveso, dál nedělitelné) vs. **složený**
3. **Výroková formule/forma** — obsahuje neznámou, výrokem se stane až po dosazení ($x > 3$)
4. **Logické spojky** a pravdivostní tabulky; **arita** spojky
5. **Proč je binárních spojek právě 16** — $2^{2^k}$, a odkud se to vezme (4 řádky tabulky, každý 0/1)
6. **Úplný systém spojek** — $\\{\neg, \wedge\\}$, $\\{\neg, \vee\\}$, a hlavně **$\\{\text{NAND}\\}$ sám o sobě**; odtud vazba na logické obvody
7. **Tautologie, kontradikce, splnitelnost**; odvozovací pravidla (modus ponens, modus tollens)
8. **Predikátový počet** přehledově — abeceda, kvantifikátory, konstrukce jazyka (slova a funktory)
9. **Naivní teorie množin** — množina, univerzum, operace, **relace mezi množinami** ($=$, $\subseteq$, disjunktnost)
10. **Systém množin** — potenční množina ($2^n$ prvků) a **rozklad množiny** (tři podmínky)
11. **Binární relace** — $R \subseteq A \times B$, obory relace, počet relací $2^{\lvert A \times B \rvert}$, kartézský a uzlový graf
12. **Vlastnosti relací** — reflexivita, antireflexivita, symetrie, antisymetrie (slabá/silná), tranzitivita
13. **Speciální typy** — **ekvivalence** a její vztah k rozkladu, **uspořádání** (ostré/neostré) a Hasseův diagram, **zobrazení**

**Nit, na kterou to navlékni:** celá otázka je o **jednom triku — složité se poskládá z jednoduchého a pak se spočítá, kolik toho jednoduchého je**. Ze dvou pravdivostních hodnot se poskládá 16 binárních spojek a z nich úplný systém, ve kterém stačí **jediné hradlo NAND** na jakýkoli obvod. Z prvků se poskládají množiny, z množin systémy množin a potenční množina o $2^n$ prvcích. Z kartézského součinu se poskládají relace, kterých je $2^{\lvert A \times B \rvert}$ — a když jim přidáš tři vlastnosti, dostaneš **ekvivalenci** (a ta je totéž co rozklad množiny) nebo **uspořádání** (a to se kreslí Hasseovým diagramem). **Všude je to mocnina dvojky, protože všude se u každé možnosti ptáš „ano, nebo ne?"**

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tahák, který si vyrobíš zpaměti hned na začátku přípravy. Napsání zabere zhruba tři minuty, zbylých dvanáct pak máš na rozmyšlení příkladu.

```
VÝROK: má smysl ptát se na pravdivost.  Atomární = jedno sloveso.
FORMULE/FORMA: má neznámou (x > 3) -> výrok až po dosazení

POČET k-árních SPOJEK = 2^(2^k)      k=1 -> 4    k=2 -> 16    k=3 -> 256

    p q | AND OR IMPL EKV NAND NOR XOR
    1 1 |  1   1   1   1    0    0   0
    1 0 |  0   1   0   0    1    0   1
    0 1 |  0   1   1   0    1    0   1
    0 0 |  0   0   1   1    1    1   0

ÚPLNÝ SYSTÉM: {NOT,AND}  {NOT,OR}  {NAND}  {NOR}
    NOT p       = p NAND p
    p AND q     = NOT(p NAND q)
    p OR q      = (NOT p) NAND (NOT q)

tautologie = vždy 1 | kontradikce = vždy 0 | splnitelná = není kontradikce
de Morgan:  NOT(p AND q) = NOT p OR NOT q
implikace:  p => q  =  NOT p OR q        (p => q) = (NOT q => NOT p)

MNOŽINY:  sjednocení, průnik, rozdíl, doplněk
    Pot(A) = systém všech podmnožin,   |Pot(A)| = 2^n
    ROZKLAD A na A1..Ak:  1) žádná není prázdná
                          2) po dvou disjunktní
                          3) sjednocení dá celé A

RELACE  R podmnožina A x B      |A x B| = |A| * |B|
    počet relací = 2^(|A| * |B|)
    obory: prvni = {a; (a,b) v R}   druhy = {b; (a,b) v R}

VLASTNOSTI (na množině, R podmnožina A x A)
    reflexivita     (x,x) v R pro všechna x
    antireflexivita (x,x) není v R pro žádné x
    symetrie        (x,y) => (y,x)
    antisymetrie    (x,y) a (y,x)  =>  x = y
    tranzitivita    (x,y) a (y,z)  =>  (x,z)

EKVIVALENCE  = reflexivní + symetrická + tranzitivní  -> ROZKLAD
USPOŘÁDÁNÍ   = antisymetrická + tranzitivní + reflexivní (neostré)
                                             / antireflexivní (ostré)
HASSE: 1) vynech reflexivní šipky 2) vynech tranzitivní 3) kresli zdola nahoru
ZOBRAZENÍ: každému a z A právě jedno b z B. injekce / surjekce / bijekce
```

#### Jak si z toho odvodit zbytek

- **Tabulku spojek nepiš celou** — piš jen ty čtyři řádky vstupů `11 / 10 / 01 / 00` a k nim sloupce dopisuj podle potřeby. Z těch čtyř řádků totiž **rovnou vidíš, proč je spojek 16**: každý ze 4 řádků má výstup 0 nebo 1, takže $2^4 = 16$. A obecně $2^{2^k}$, protože řádků je $2^k$.
- **NAND a NOR si nepamatuj jako tabulku**, ale jako *„AND s negací na výstupu"* a *„OR s negací na výstupu"* — sloupec prostě otočíš. Odtud i název: **N**ot-**AND**.
- **De Morgan je jediný zákon, který opravdu musíš umět** — z něj si dopočítáš převody mezi $\wedge$ a $\vee$, a tím i to, že $\\{\neg, \wedge\\}$ je úplný systém (protože $\vee$ z nich vyrobíš).
- **Implikaci si vždy přepiš na $\neg p \vee q$.** Většina záludností s implikací („z nepravdy plyne cokoli") zmizí, jakmile ji vidíš takhle.
- **Antisymetrii si nepleť s antireflexivitou.** Antisymetrie nezakazuje $(x,x)$ — zakazuje jen **dvě různé** protisměrné šipky. Proto může být relace zároveň reflexivní i antisymetrická (a to je právě neostré uspořádání).
- **Rozklad a ekvivalenci si pamatuj jako jednu věc, ne dvě.** Třídy ekvivalence *jsou* ty podmnožiny rozkladu — dvě strany téže mince.

#### Jak si to zapamatovat, aniž bys to biflil

> **Všechno je mocnina dvojky, protože se všude u každé možnosti ptáš „ano, nebo ne?"**

| Kolik je… | Vzorec | Pro malé číslo | Proč |
|---|---|---|---|
| $k$-árních spojek | $2^{2^k}$ | $k=2 \Rightarrow 16$ | řádků tabulky je $2^k$, každý má 2 možné výstupy |
| podmnožin množiny | $2^n$ | $n=3 \Rightarrow 8$ | u každého prvku: je uvnitř, nebo ne |
| prvků $A \times B$ | $\lvert A \rvert \cdot \lvert B \rvert$ | $3 \cdot 5 = 15$ | ke každému $a$ všechna $b$ |
| relací mezi $A$ a $B$ | $2^{\lvert A \rvert \cdot \lvert B \rvert}$ | $2^{15} = 32\,768$ | relace **je** podmnožina $A \times B$ |

**Poslední řádek je jádro celé druhé půlky otázky:** relace není nic víc než **podmnožina kartézského součinu**. Jakmile to řekneš, počet relací už jen dosadíš do vzorce pro počet podmnožin.

##### Kde to navazuje na ostatní okruhy

| Co tady | Kde to už bylo | Jak to spolu souvisí |
|---|---|---|
| zobrazení jako relace | funkce, [okruh 4](../04-funkce-polynomy-nelinearni-rovnice/) | funkce **je** speciální binární relace |
| uzlový graf relace | grafy, [okruh 12](../12-grafy-stromy/) | orientovaný graf a relace na množině je totéž |
| $2^n$ podmnožin | složitost, [okruh 11](../11-rekurence-asymptotika/) | proto je prohledání všech podmnožin $O(2^n)$ |
| logické spojky | podmínky v kódu, [okruh 2](../02-algoritmy-nad-seznamy/) | `&&`, `\|\|`, `!` jsou tytéž spojky |

---

### Výrokový počet

#### Výrok

**Výrok** je sdělení deklarativního typu, u kterého **má smysl uvažovat o pravdivostní hodnotě**. Nemusí být pravdivé — musí být *rozhodnutelné*.

| Věta | Výrok? | Proč |
|---|---|---|
| „Praha je hlavní město ČR." | **ano** (1) | dá se ověřit, je pravdivá |
| „$3 + 5 = 7$" | **ano** (0) | dá se ověřit, je nepravdivá |
| „Kolik je hodin?" | **ne** | otázka, nemá pravdivostní hodnotu |
| „Zavři okno!" | **ne** | rozkaz |
| „$x > 3$" | **ne** | výroková **forma** — obsahuje neznámou |

**Pozor na poslední řádek** — to je oblíbená otázka. `x > 3` samo o sobě výrok **není**, protože nevím, co je $x$. Výrokem se stane až dosazením:

- $x = 5$: „$5 > 3$" — pravda (1)
- $x = 0$: „$0 > 3$" — nepravda (0)

**Atomární výrok** je dál nedělitelný, neobsahuje spojku. Praktická pomůcka z konzultace: **obsahuje jedno sloveso**.

- „$3 + 5 = 7$" — atomární (jedno sloveso *„se rovná"*), i když je nepravdivý
- „Prší a je zima." — **složený**, dá se rozdělit na dva výroky

#### Logické spojky a pravdivostní tabulky

**Spojka** je pravdivostní funkce — z pravdivostních hodnot vstupů udělá pravdivostní hodnotu výstupu. **Arita** $k$ je počet vstupů.

| $p$ | $q$ | $p \wedge q$ | $p \vee q$ | $p \Rightarrow q$ | $p \Leftrightarrow q$ | NAND | NOR | XOR |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |
| 1 | 0 | 0 | 1 | **0** | 0 | 1 | 0 | 1 |
| 0 | 1 | 0 | 1 | **1** | 0 | 1 | 0 | 1 |
| 0 | 0 | 0 | 0 | **1** | 1 | 1 | 1 | 0 |

**Implikace je jediná, která studenty zaskočí.** Ty tři zvýrazněné řádky říkají: implikace je nepravdivá **jen když ze splněného předpokladu vyjde nesplněný závěr**.

**Konkrétně:** *„Když bude pršet, vezmu si deštník."*

| Prší? | Vzal deštník? | Lhal jsem? |
|---|---|---|
| ano | ano | ne — slib splněn (1) |
| ano | ne | **ano — jedině tady jsem lhal** (0) |
| ne | ano | ne — nic jsem neslíbil pro případ sucha (1) |
| ne | ne | ne — také jsem neslíbil nic (1) |

Poslední dva řádky jsou to slavné *„z nepravdy plyne cokoli"*: **když nepršelo, slib mě nezavazuje**, ať udělám cokoli.

#### Proč je binárních spojek právě 16

Tohle je nejčastější doplňující otázka celého okruhu a odvození je krátké:

1. Binární spojka má **2 vstupy**, každý nabývá 2 hodnot $\Rightarrow$ tabulka má $2^2 = 4$ **řádky**.
2. Spojka je určená **výstupním sloupcem** — čtyřmi čísly.
3. Do každého ze čtyř řádků můžu napsat 0 nebo 1 $\Rightarrow$ $2^4 = 16$ různých sloupců.

$$\text{počet } k\text{-árních spojek} = 2^{2^k}$$

**Dosazení pro všechny arity:**

| Arita $k$ | Řádků tabulky $2^k$ | Spojek $2^{2^k}$ |
|---|---|---|
| $1$ (unární) | $2$ | $2^2 = 4$ |
| $2$ (binární) | $4$ | $2^4 = \mathbf{16}$ |
| $3$ (ternární) | $8$ | $2^8 = 256$ |

**Ty čtyři unární spojky si vyjmenuj** — je to hezká pojistka, že vzorec chápeš: identita, **negace**, konstanta 1, konstanta 0. Jediná zajímavá je negace, ostatní tři jsou k ničemu — a přesně proto se z 16 binárních spojek běžně používá jen pár.

**Spojky arity vyšší než 2 se dají nahradit binárními a unárními**, takže se jimi nikdo nezabývá. Příklad z programování — ternární operátor `A ? B : C`:

$$f(A,B,C) = (A \wedge B) \vee (\neg A \wedge C)$$

#### Úplný systém spojek

**Úplný systém** je taková množina spojek, kterou dokážu vyjádřit **každou** pravdivostní funkci. Standardní úplné systémy:

$$\{\neg, \wedge\} \qquad \{\neg, \vee\} \qquad \{\neg, \wedge, \vee\} \qquad \{\text{NAND}\} \qquad \{\text{NOR}\}$$

**Že $\\{\neg, \wedge\\}$ stačí**, ukážeš de Morganem — disjunkci z nich vyrobíš:

$$p \vee q = \neg(\neg p \wedge \neg q)$$

**Kontrola na číslech** pro $p = 1$, $q = 0$: vpravo $\neg(\neg 1 \wedge \neg 0) = \neg(0 \wedge 1) = \neg 0 = 1$. A vlevo $1 \vee 0 = 1$. Sedí.

##### NAND jako univerzální hradlo

**Tohle je ta otázka, na kterou se ptají** — *„dokaž, že $\\{\text{NAND}\\}$ je úplný systém"*. Stačí vyrobit $\neg$, $\wedge$ a $\vee$, protože o $\\{\neg, \wedge, \vee\\}$ už víme, že úplný je.

**1) Negace** — do NAND pošlu tentýž vstup dvakrát:

$$\neg p = p \uparrow p$$

*Ověření:* $p = 1$: $1 \uparrow 1 = \neg(1 \wedge 1) = \neg 1 = 0$. $p = 0$: $0 \uparrow 0 = \neg(0 \wedge 0) = \neg 0 = 1$. **Sedí — je to negace.**

**2) Konjunkce** — NAND je AND s negací, tak tu negaci zruším další negací:

$$p \wedge q = \neg(p \uparrow q) = (p \uparrow q) \uparrow (p \uparrow q)$$

*Ověření pro $p = q = 1$:* $1 \uparrow 1 = 0$, pak $0 \uparrow 0 = 1$. A $1 \wedge 1 = 1$. **Sedí.**

**3) Disjunkce** — de Morganem, znegované vstupy:

$$p \vee q = (p \uparrow p) \uparrow (q \uparrow q)$$

*Ověření pro $p = 1$, $q = 0$:* $1 \uparrow 1 = 0$, $0 \uparrow 0 = 1$, pak $0 \uparrow 1 = \neg(0 \wedge 1) = 1$. A $1 \vee 0 = 1$. **Sedí.**

> **Proč to zajímá elektrotechniky:** v křemíku stačí vyrábět **jediný typ hradla**. Celý procesor se dá postavit jen z NAND hradel — nemusí se řešit výroba pěti různých součástek. Tohle je celá „aplikace v logických obvodech" z názvu okruhu, a stojí za to ji u zkoušky vyslovit.

#### Tautologie, kontradikce, splnitelnost

| Pojem | Definice | Příklad |
|---|---|---|
| **tautologie** | pravdivá při **každém** ohodnocení | $p \vee \neg p$ (zákon vyloučeného třetího) |
| **kontradikce** | nepravdivá při **každém** ohodnocení | $p \wedge \neg p$ |
| **splnitelná** | pravdivá **alespoň při jednom** ohodnocení | $p \wedge q$ (splněna pro $p=q=1$) |

**Pozor na past:** splnitelná **není** totéž co tautologie. Každá tautologie je splnitelná, ale ne naopak — $p \wedge q$ je splnitelná a tautologie není. Formálně: **splnitelná = není kontradikce**.

**Ověření na $p \vee \neg p$:** pro $p = 1$ je $1 \vee 0 = 1$; pro $p = 0$ je $0 \vee 1 = 1$. Obě možnosti vyšly 1, jiná není $\Rightarrow$ **tautologie**.

#### Odvozovací pravidla

Pravidla, kterými se z pravdivých formulí dostávám k dalším pravdivým formulím.

| Pravidlo | Tvar | Příklad |
|---|---|---|
| **modus ponens** | z $p \Rightarrow q$ a $p$ plyne $q$ | „Prší $\Rightarrow$ je mokro." + „Prší." $\Rightarrow$ **„Je mokro."** |
| **modus tollens** | z $p \Rightarrow q$ a $\neg q$ plyne $\neg p$ | „Prší $\Rightarrow$ je mokro." + „**Není** mokro." $\Rightarrow$ **„Neprší."** |
| **hypotetický sylogismus** | z $p \Rightarrow q$ a $q \Rightarrow r$ plyne $p \Rightarrow r$ | tranzitivita implikace |

**A hlavně past, kterou zkoušející rád nastraží:** z $p \Rightarrow q$ a $q$ **neplyne** $p$.

*„Prší $\Rightarrow$ je mokro."* Je mokro. **Prší?** Nemusí — někdo mohl mýt auto. Tomuhle se říká **potvrzování konsekventu** a je to logická chyba.

Souvisí s tím **obměna implikace** (a ta *platí*):

$$(p \Rightarrow q) \Leftrightarrow (\neg q \Rightarrow \neg p)$$

Naproti tomu **obrácení** $(q \Rightarrow p)$ ekvivalentní **není** — a to je přesně ta chyba výše.

---

### Predikátový počet

> **Podle konzultace si tohle podtéma nikdo nevybírá**, takže to ber jako přehled pro případ, že se doptají. Nemusíš umět víc než ideu, abecedu a kvantifikátory.

**Proč vůbec:** výrokový počet neumí říct *„každé přirozené číslo má následníka"* — vidí jen celé výroky, nedohlédne dovnitř. Predikátový počet přidá **proměnné, predikáty a kvantifikátory**.

**Predikát** je výraz s proměnnou, který se **po dosazení stane výrokem** — přesně ta výroková forma z úvodu, teď pojmenovaná.

- $P(x)$: „$x$ je sudé" — $P(4)$ je pravda, $P(7)$ nepravda
- $x \in A$, $x = y$

**Kvantifikátory:**

| Symbol | Čte se | Příklad | Platí? |
|---|---|---|---|
| $\forall$ | pro každé | $\forall x \in \mathbb{N}: x \geq 0$ | ano |
| $\exists$ | existuje | $\exists x \in \mathbb{N}: x > 5$ | ano (třeba $x=6$) |

**Negace kvantifikátoru** — často se ptají:

$$\neg(\forall x: P(x)) \Leftrightarrow \exists x: \neg P(x)$$

*Slovy:* neplatí-li, že **všichni** studenti složili zkoušku, znamená to, že **existuje** student, který ji nesložil. **Negace obrací kvantifikátor** — to je celé.

#### Abeceda a konstrukce jazyka

Zkušební okruh chce „abecedu a konstrukci jazyka", a konzultace to bere na příkladu **jazyka pro množiny**:

| Složka abecedy | Symboly |
|---|---|
| výrokové proměnné | $p$, $q$, $a$, $b$ |
| výrokové konstanty | $0$, $1$ |
| logické spojky | $\neg$, $\wedge$, $\vee$, $\Rightarrow$, $\Leftrightarrow$ |
| predikátové proměnné | $A$, $B$, $C$ (množiny) |
| predikátové konstanty | $\emptyset$ |
| **predikáty** | $=$, $\in$, $\notin$, $\subseteq$ |
| **funktory** (operace) | $\cup$, $\cap$, $\setminus$ |
| kvantifikátory | $\forall$, $\exists$ |

**Gramatika** pak řekne, co je správně utvořené *slovo* (formule): každý výrok; je-li $\varphi$ a $\psi$ slovo, je slovem i $\varphi \wedge \psi$; jsou-li $A$, $B$ množinové proměnné, je slovem $A = B$ i $A \subseteq B$; atd.

**Funktory se definují predikátovým zápisem** — a tohle je hezké místo, kde se predikátový počet a množiny potkají:

$$A \cap B = \{x;\ x \in A \wedge x \in B\}$$

**Přečti to nahlas:** *„průnik je množina těch $x$, pro která platí, že $x$ je v $A$ **a zároveň** $x$ je v $B$"*. Množinová operace $\cap$ je tedy jen **přepis logické spojky $\wedge$** do jazyka množin — a $\cup$ totéž pro $\vee$.

---

### Naivní teorie množin

**„Naivní"** znamená, že množinu bereme intuitivně — jako soubor prvků daný nějakou vlastností — a neřešíme axiomatickou výstavbu. (Za to se platí paradoxy, viz [Na co se doptají](#na-co-se-doptají).)

**Množina** je soubor navzájem odlišitelných prvků. Základní vlastnost, ze které plyne všechno ostatní:

$$x \in A \quad \vee \quad x \notin A$$

**Prvek buď do množiny patří, nebo nepatří — třetí možnost není.** Z toho plyne:

- **prvek se v množině vyskytuje nejvýše jednou** — $\\{1, 1, 2\\} = \\{1, 2\\}$
- **na pořadí nezáleží** — $\\{1, 2\\} = \\{2, 1\\}$

**Univerzum $U$** je množina všech prvků, o kterých v dané úloze uvažujeme. Musí být zadané nebo aspoň zřejmé, jinak nemá smysl mluvit o doplňku.

#### Operace na množinách

Vezmi si $U = \\{1,2,3,4,5,6\\}$, $A = \\{1,2,3\\}$, $B = \\{3,4\\}$ a počítej se mnou:

| Operace | Zápis | Definice | Výsledek |
|---|---|---|---|
| **sjednocení** | $A \cup B$ | $\\{x;\ x \in A \vee x \in B\\}$ | $\\{1,2,3,4\\}$ |
| **průnik** | $A \cap B$ | $\\{x;\ x \in A \wedge x \in B\\}$ | $\\{3\\}$ |
| **rozdíl** | $A \setminus B$ | $\\{x;\ x \in A \wedge x \notin B\\}$ | $\\{1,2\\}$ |
| **doplněk** | $A^{c}$ | $\\{x;\ x \in U \wedge x \notin A\\}$ | $\\{4,5,6\\}$ |

**Všimni si prostředního sloupce** — každá operace je logická spojka aplikovaná na „patří do". Proto platí **de Morganovy zákony i pro množiny**, ve stejném tvaru:

$$(A \cup B)^{c} = A^{c} \cap B^{c}$$

**Ověření na číslech:** vlevo $(\\{1,2,3,4\\})^{c} = \\{5,6\\}$. Vpravo $A^{c} \cap B^{c} = \\{4,5,6\\} \cap \\{1,2,5,6\\} = \\{5,6\\}$. **Sedí.**

#### Relace mezi množinami

Nejde o binární relace (ty přijdou dál) — jde o **vztahy dvou množin jako celků**. Pořád $A = \\{1,2,3\\}$, $B = \\{3,4\\}$, navíc $C = \\{1,2\\}$, $D = \\{5\\}$.

| Vztah | Zápis | Definice | Příklad |
|---|---|---|---|
| **rovnost** | $A = B$ | $\forall x (x \in A \Leftrightarrow x \in B)$ | $\\{1,2\\} = C$ |
| **podmnožina** | $C \subseteq A$ | $\forall x (x \in C \Rightarrow x \in A)$ | $\\{1,2\\} \subseteq \\{1,2,3\\}$ ✔ |
| **vlastní podmnožina** | $C \subset A$ | $C \subseteq A \wedge C \neq A$ | $\\{1,2\\} \subset \\{1,2,3\\}$ ✔ |
| **nadmnožina** | $A \supseteq C$ | obráceně | |
| **disjunktnost** | $C \cap D = \emptyset$ | nemají společný prvek | $\\{1,2\\}$ a $\\{5\\}$ ✔ |

**Dvě pasti, na které se ptají:**

1. **$\emptyset$ je podmnožinou každé množiny.** Proč? Definice říká *„každý prvek prázdné množiny leží v $A$"* — a protože prázdná množina žádný prvek nemá, **není co porušit**. Podmínka platí prázdně.
2. **$\subseteq$ není $\in$.** Platí $\\{1\\} \subseteq \\{1,2\\}$, ale $\\{1\\} \in \\{1,2\\}$ **neplatí** — prvky jsou tam čísla, ne množiny. Naproti tomu $1 \in \\{1,2\\}$ platí.

#### Systém množin

**Systém množin** je množina, jejímiž prvky jsou zase množiny. Tady se ta předchozí past stane užitečnou: v systému množin $\\{\\{1\\},\\{2\\}\\}$ už opravdu platí $\\{1\\} \in \\{\\{1\\},\\{2\\}\\}$.

##### Potenční množina

$\mathrm{Pot}(A)$ je **systém všech podmnožin** množiny $A$.

**Pro $A = \\{1, 2, 3\\}$** vypíšu všech osm — po velikostech, ať na nic nezapomenu:

$$\mathrm{Pot}(A) = \{\ \emptyset,\ \{1\},\{2\},\{3\},\ \{1,2\},\{1,3\},\{2,3\},\ \{1,2,3\}\ \}$$

$$\lvert \mathrm{Pot}(A) \rvert = 2^{n} = 2^{3} = 8$$

**Proč $2^n$:** u každého ze tří prvků se nezávisle rozhodnu *„vezmu ho, nebo ne?"* — dvě možnosti, třikrát, tedy $2 \cdot 2 \cdot 2 = 8$. **Nezapomeň na oba okraje** — $\emptyset$ (nevzal jsem nic) i celé $A$ (vzal jsem vše) jsou plnohodnotné podmnožiny.

##### Rozklad množiny

**Rozklad** (systém $A_1, \ldots, A_k$) rozseká množinu $A$ na kusy, které se nepřekrývají a dohromady ji vyplní. Tři podmínky:

1. $A_i \neq \emptyset$ — **žádný kus není prázdný**
2. $i \neq j \Rightarrow A_i \cap A_j = \emptyset$ — **kusy jsou po dvou disjunktní**
3. $\bigcup_i A_i = A$ — **dohromady dají celou $A$**

**Konkrétně na $A = \\{1,2,3,4,5\\}$:**

| Systém | Rozklad? | Proč |
|---|---|---|
| $\\{1,2\\},\\{3\\},\\{4,5\\}$ | **ano** ✔ | nic prázdného, nepřekrývá se, dohromady vše |
| $\\{1,2\\},\\{2,3\\},\\{4,5\\}$ | **ne** ✘ | dvojka je ve dvou kusech — porušená podmínka 2 |
| $\\{1,2\\},\\{3\\}$ | **ne** ✘ | chybí 4 a 5 — porušená podmínka 3 |
| $\\{1,2,3\\},\emptyset,\\{4,5\\}$ | **ne** ✘ | prázdný kus — porušená podmínka 1 |

**Nekonečný příklad z konzultace** — rozklad $\mathbb{N}_0$ podle **zbytku po dělení třemi**:

$$A_0 = \{0,3,6,9,\ldots\} \qquad A_1 = \{1,4,7,10,\ldots\} \qquad A_2 = \{2,5,8,11,\ldots\}$$

Ověř si tři podmínky: žádná není prázdná ✔; číslo má **právě jeden** zbytek po dělení třemi, takže se nepřekrývají ✔; každé přirozené číslo nějaký zbytek má, takže dohromady dají $\mathbb{N}_0$ ✔.

**Tenhle příklad si zapamatuj** — za chvíli ho použiješ znovu u ekvivalence, protože **rozklad a ekvivalence jsou totéž**.

---

### Binární relace

#### Zavedení

**Kartézský součin** $A \times B$ je množina **všech uspořádaných dvojic**:

$$A \times B = \{(a,b);\ a \in A \wedge b \in B\} \qquad \lvert A \times B \rvert = \lvert A \rvert \cdot \lvert B \rvert$$

**Binární relace** $R$ **je podmnožina** kartézského součinu:

$$R \subseteq A \times B$$

**Tahle jediná věta je klíč k celé druhé půlce otázky.** Relace není nová věc — je to podmnožina. Proto se počet relací počítá jako počet podmnožin.

**Konkrétně** (příklad z konzultace): $\lvert A \rvert = 3$, $\lvert B \rvert = 5$.

$$\lvert A \times B \rvert = 3 \cdot 5 = 15 \qquad \text{počet relací} = 2^{15} = 32\,768$$

**A pro relaci na množině** $A$ o třech prvcích (tedy $R \subseteq A \times A$): $\lvert A \times A \rvert = 3 \cdot 3 = 9$, relací je $2^{9} = 512$. **Tohle je přesně ta doptávka „kolik je relací na tříprvkové množině".**

#### Obory relace

Vezmi $A = \\{a,b,c\\}$, $B = \\{b,c,d,e\\}$ a relaci

$$R = \{(a,b),\ (a,d),\ (a,e),\ (b,b),\ (b,d)\}$$

| Obor | Definice | Slovy | Výsledek |
|---|---|---|---|
| **první obor** ${}^{\square}R$ | $\\{a;\ (a,b) \in R\\}$ | co všechno je vlevo | $\\{a, b\\} \subseteq A$ |
| **druhý obor** $R^{\square}$ | $\\{b;\ (a,b) \in R\\}$ | co všechno je vpravo | $\\{b, d, e\\} \subseteq B$ |

**Všimni si**, že $c$ není v prvním oboru (nikdy nevystupuje vlevo) a ani ve druhém, přestože je v $A$ i v $B$. **Obor je jen to, co se v relaci opravdu objeví** — proto je podmnožinou, ne celou množinou.

#### Znázornění relací

**1) Kartézský graf** — mřížka, kde zakřížkuješ dvojice, které v relaci jsou:

```
        b   c   d   e
    a   X       X   X
    b   X       X
    c
```

**2) Uzlový graf** (orientovaný) — prvky jsou uzly, dvojice $(a,b) \in R$ je **šipka z $a$ do $b$**:

```
    a ──→ b        a ──→ d        b ──→ b (smyčka)
    a ──→ e        b ──→ d
```

**Kdy který:** kartézský graf je lepší, když $A \neq B$ (dvě různé osy). Uzlový graf je lepší **pro relace na jedné množině** — vlastnosti jako reflexivita a symetrie se v něm poznají na první pohled, viz níže.

#### Vlastnosti relací na množině

Od téhle chvíle $R \subseteq A \times A$ — relace **na** množině. Tady je tabulka, kterou musíš umět zpaměti; poslední sloupec je nejcennější, protože ti dovolí vlastnost **poznat z obrázku**.

| Vlastnost | Formálně | V uzlovém grafu |
|---|---|---|
| **reflexivita** | $\forall x \in A: (x,x) \in R$ | u **každého** uzlu smyčka |
| **antireflexivita** | $\forall x \in A: (x,x) \notin R$ | **žádná** smyčka |
| **symetrie** | $(x,y) \in R \Rightarrow (y,x) \in R$ | každá šipka je obousměrná |
| **antisymetrie** | $(x,y) \in R \wedge (y,x) \in R \Rightarrow x = y$ | žádná obousměrná šipka mezi **různými** uzly |
| **tranzitivita** | $(x,y) \in R \wedge (y,z) \in R \Rightarrow (x,z) \in R$ | vede-li cesta na dva kroky, je i zkratka |

**Konkrétně na $A = \\{1,2,3\\}$ a relaci $\leq$:**

$$R = \{(1,1),(2,2),(3,3),(1,2),(1,3),(2,3)\}$$

- **reflexivní?** ✔ — $(1,1),(2,2),(3,3)$ tam všechny jsou
- **symetrická?** ✘ — $(1,2) \in R$, ale $(2,1) \notin R$
- **antisymetrická?** ✔ — jediné protisměrné dvojice jsou smyčky, a u těch je $x = y$
- **tranzitivní?** ✔ — $(1,2)$ a $(2,3)$ je tam, a $(1,3)$ **taky** ✔
- $\Rightarrow$ **je to neostré uspořádání**

##### Past: antireflexivita není negace reflexivity

**Tohle si zkoušející rádi ověřují.** Relace může být **ani reflexivní, ani antireflexivní** — stačí, aby smyčku měl někdo, ale ne všichni:

$$R = \{(1,1),\ (2,3)\} \text{ na } A=\{1,2,3\}$$

Reflexivní není (chybí $(2,2)$), antireflexivní není (je tam $(1,1)$). **Není to protiklad, jsou to dva krajní póly** — a mezi nimi je spousta relací, které nejsou ani jedno.

**Totéž platí pro symetrii a antisymetrii.** Vedle sebe:

| Relace na $\\{1,2\\}$ | Symetrická? | Antisymetrická? |
|---|---|---|
| $\\{(1,2),(2,1)\\}$ | ✔ | ✘ (dvě různá čísla protisměrně) |
| $\\{(1,2)\\}$ | ✘ | ✔ |
| $\\{(1,1)\\}$ | ✔ | ✔ — **obojí zároveň!** |
| $\\{(1,2),(2,1),(1,1)\\}$ | ✔ | ✘ |

**Třetí řádek je pointa:** samé smyčky jsou symetrické i antisymetrické. Proto **antisymetrie nezakazuje reflexivitu** — a proto může existovat neostré uspořádání.

##### Slabá a silná antisymetrie

Konzultace to rozlišuje:

- **slabá antisymetrie** — $(x,y) \in R \wedge (y,x) \in R \Rightarrow x = y$; **připouští reflexivní prvky** (smyčky). To je ta běžná, u $\leq$.
- **silná antisymetrie** — $(x,y) \in R \Rightarrow (y,x) \notin R$ **pro libovolná** $x, y$; tím pádem **zakazuje i smyčky**, protože pro $x = y$ by musela $(x,x)$ zároveň být i nebýt. To je varianta u ostrého $<$.

#### Ekvivalence

**Ekvivalence** je relace, která je **reflexivní, symetrická a tranzitivní**. Pomůcka: **R-S-T**.

Intuitivně je to *„být stejný z nějakého hlediska"* — a proto musí splňovat právě tyhle tři věci:

| Vlastnost | Proč u „být stejný" musí platit |
|---|---|
| reflexivita | každý je stejný sám se sebou |
| symetrie | je-li $x$ stejné jako $y$, je i $y$ stejné jako $x$ |
| tranzitivita | je-li $x$ jako $y$ a $y$ jako $z$, je $x$ jako $z$ |

**Konkrétně:** na $\mathbb{N}_0$ relace *„$x$ a $y$ dávají stejný zbytek po dělení třemi"* (kongruence modulo 3).

- reflexivní ✔ — $x$ má stejný zbytek jako $x$
- symetrická ✔ — má-li $x$ zbytek jako $y$, pak i naopak
- tranzitivní ✔ — $4$ a $7$ mají zbytek 1, $7$ a $10$ taky $\Rightarrow$ $4$ a $10$ mají zbytek 1 ✔

##### Ekvivalence a rozklad jsou totéž

**Tohle je nejdůležitější věta o relacích a ptají se na ni skoro vždycky:**

> **Každá ekvivalence na $A$ určuje rozklad $A$ na třídy ekvivalence — a naopak každý rozklad $A$ určuje ekvivalenci.** Je to vzájemně jednoznačná odpovídost.

**Třída ekvivalence** prvku $x$ je množina všech, co jsou s ním v relaci:

$$[x] = \{y \in A;\ (x,y) \in R\}$$

**A ten rozklad už znáš** — je to přesně ten z konzultace o pár odstavců výš:

$$[0] = \{0,3,6,\ldots\} \qquad [1] = \{1,4,7,\ldots\} \qquad [2] = \{2,5,8,\ldots\}$$

**Proč to vychází, řekni nahlas takhle:** *reflexivita* zaručí, že každý prvek v nějaké třídě je (tedy sjednocení dá celé $A$ — podmínka 3 rozkladu a zároveň neprázdnost, podmínka 1); *symetrie a tranzitivita* spolu zaručí, že se **dvě různé třídy nemůžou částečně překrývat** — mají-li jeden společný prvek, jsou celé stejné (podmínka 2). **Tři vlastnosti ekvivalence $\rightarrow$ tři podmínky rozkladu.**

**Kontrola pro tříprvkovou množinu:** rozkladů $\\{1,2,3\\}$ je pět — $\\{123\\}$, $\\{12\\}\\{3\\}$, $\\{13\\}\\{2\\}$, $\\{23\\}\\{1\\}$, $\\{1\\}\\{2\\}\\{3\\}$. Takže i **ekvivalencí je na tříprvkové množině přesně 5** (z 512 relací celkem).

#### Uspořádání

**Uspořádání** je relace **antisymetrická a tranzitivní**, a podle reflexivity ve dvou variantách:

| Typ | Vlastnosti | Příklad |
|---|---|---|
| **neostré** ($\leq$) | **reflexivní** + antisymetrická + tranzitivní | $\leq$ na číslech, $\subseteq$ na množinách, dělitelnost |
| **ostré** ($<$) | **antireflexivní** + antisymetrická + tranzitivní | $<$ na číslech, $\subset$ |

**Ekvivalence vs. uspořádání se liší jedinou vlastností** — symetrie versus antisymetrie. Dává to smysl: *„být stejný"* funguje oběma směry, *„být menší"* jen jedním.

**Dále se rozlišuje:**

- **částečné (částečné) uspořádání** — některé dvojice **nejsou porovnatelné**. Příklad: dělitelnost na $\\{2,3\\}$ — $2$ nedělí $3$ ani $3$ nedělí $2$.
- **lineární (úplné, totální)** — **každé dva prvky jsou porovnatelné**. Příklad: $\leq$ na číslech.

##### Hasseův diagram

Kreslení uspořádání bez zbytečných šipek. **Tři pravidla:**

1. **vynech reflexivní šipky** (smyčky) — víme, že tam jsou u všech
2. **vynech tranzitivní šipky** — vede-li cesta přes prostředníka, přímou hranu nekreslíme
3. **kresli zdola nahoru** — směr šipek nahrazuje výška, šipky se pak nekreslí vůbec

**Konkrétně — dělitelnost na dělitelích dvanácti** $A = \\{1,2,3,4,6,12\\}$ (to je přímo ta doptávka níže):

```
            12
           /  \
          4    6
          |   / \
          2  /   3
           \/   /
            1 ─┘
```

**Čti to takhle:** $1$ dělí všechno (je dole), $12$ je dělitelné vším (je nahoře). Hrana $2 \to 4$ tam je, hrana $1 \to 4$ **není** — plyne z $1 \to 2 \to 4$ tranzitivitou. Stejně tak není hrana $1 \to 12$.

**$4$ a $6$ nejsou spojené** — $4$ nedělí $6$ ani naopak. **Proto je dělitelnost jen částečné uspořádání**, a je to na diagramu vidět: rozvětvuje se.

#### Zobrazení

**Zobrazení** (funkce) je **speciální binární relace** $f \subseteq A \times B$, která každému $a \in A$ přiřadí **právě jeden** $b \in B$. Značí se $f: A \to B$.

**Ta podmínka „právě jeden" je celý rozdíl mezi relací a zobrazením.** Vedle sebe na $A = \\{1,2\\}$, $B = \\{x,y\\}$:

| Relace | Zobrazení? | Proč |
|---|---|---|
| $\\{(1,x),(2,y)\\}$ | **ano** ✔ | každý z $A$ má právě jeden obraz |
| $\\{(1,x),(1,y),(2,x)\\}$ | **ne** ✘ | jednička má **dva** obrazy |
| $\\{(1,x)\\}$ | **ne** ✘ | dvojka nemá **žádný** obraz |

**Vlastnosti zobrazení** — na $A = \\{1,2,3\\}$, $B = \\{a,b,c\\}$:

| Vlastnost | Formálně | Slovy | Příklad |
|---|---|---|---|
| **injektivní** (prosté) | $f(x) = f(y) \Rightarrow x = y$ | různé jde na různé | $1 \to a$, $2 \to b$, $3 \to c$ ✔ |
| **surjektivní** (na) | $\forall b \in B\ \exists a \in A: f(a) = b$ | pokryje celé $B$ | tentýž příklad ✔ |
| **bijektivní** | injektivní **i** surjektivní | dokonalé párování | tentýž příklad ✔ |

**Protipříklad vedle toho:** $1 \to a$, $2 \to a$, $3 \to b$ **není injektivní** (jednička i dvojka jdou na $a$) ani **surjektivní** ($c$ nikdo netrefí).

**Bijekce je důležitá proto**, že jedině k ní existuje **inverzní zobrazení** $f^{-1}$ — a to je vazba na inverzní funkce z [okruhu 4](../04-funkce-polynomy-nelinearni-rovnice/).

---

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

- **Výrok** — sdělení deklarativního typu, u kterého má smysl uvažovat o pravdivostní hodnotě.
- **Atomární výrok** — výrok neobsahující žádnou logickou spojku.
- **Výroková formule (forma)** — výraz s neznámou, který se výrokem stane až po dosazení.
- **Tautologie** — formule pravdivá při každém ohodnocení proměnných. **Kontradikce** — nepravdivá při každém. **Splnitelná** — pravdivá alespoň při jednom, tj. není kontradikce.
- **Úplný systém spojek** — množina spojek, pomocí které lze vyjádřit každou pravdivostní funkci.
- **Potenční množina $\mathrm{Pot}(A)$** — systém všech podmnožin množiny $A$; má $2^{n}$ prvků.
- **Rozklad množiny $A$** — systém neprázdných, po dvou disjunktních podmnožin, jejichž sjednocením je $A$.
- **Kartézský součin** — $A \times B = \\{(a,b);\ a \in A \wedge b \in B\\}$.
- **Binární relace** — libovolná podmnožina kartézského součinu, $R \subseteq A \times B$.
- **Ekvivalence** — relace reflexivní, symetrická a tranzitivní.
- **Uspořádání** — relace antisymetrická a tranzitivní; **neostré** je navíc reflexivní, **ostré** antireflexivní.
- **Zobrazení** — relace $f \subseteq A \times B$, která každému $a \in A$ přiřadí právě jeden prvek $b \in B$.

---

### Příklad na papír

<!-- Jeden příklad, který během výkladu spočítám nebo nakreslím. -->

#### Příklad 1 — NAND jako úplný systém

**Zadání:** Ukažte, že $\\{\text{NAND}\\}$ je úplný systém logických spojek.

##### Krok 0: co vlastně mám dokázat

**Úplný systém** = umím jím vyjádřit **každou** pravdivostní funkci. Nemusím ale procházet všech 16 binárních spojek — stačí ukázat, že vyrobím $\\{\neg, \wedge, \vee\\}$, **o kterém už víme, že úplný je**. Tomuhle triku se říká *převedení na známý případ* a u zkoušky ho vyslov, ať je vidět, že chápeš strukturu důkazu.

##### Krok 1: tabulka NAND

$p \uparrow q = \neg(p \wedge q)$ — vezmi AND a otoč výstupní sloupec:

| $p$ | $q$ | $p \wedge q$ | $p \uparrow q$ |
|:-:|:-:|:-:|:-:|
| 1 | 1 | 1 | **0** |
| 1 | 0 | 0 | **1** |
| 0 | 1 | 0 | **1** |
| 0 | 0 | 0 | **1** |

##### Krok 2: negace

Do obou vstupů pošlu totéž — tím používám jen **první a poslední** řádek tabulky:

$$\neg p = p \uparrow p$$

| $p$ | $p \uparrow p$ | má vyjít $\neg p$ |
|:-:|:-:|:-:|
| 1 | 0 | 0 ✔ |
| 0 | 1 | 1 ✔ |

##### Krok 3: konjunkce

NAND je „AND s negací na výstupu", takže tu negaci **zruším další negací** — a negaci už umím z kroku 2:

$$p \wedge q = \neg(p \uparrow q) = (p \uparrow q) \uparrow (p \uparrow q)$$

| $p$ | $q$ | $p \uparrow q$ | výsledek | má být $p \wedge q$ |
|:-:|:-:|:-:|:-:|:-:|
| 1 | 1 | 0 | 1 | 1 ✔ |
| 1 | 0 | 1 | 0 | 0 ✔ |
| 0 | 1 | 1 | 0 | 0 ✔ |
| 0 | 0 | 1 | 0 | 0 ✔ |

##### Krok 4: disjunkce

De Morganem $p \vee q = \neg(\neg p \wedge \neg q)$, což je **přesně NAND znegovaných vstupů**:

$$p \vee q = (p \uparrow p) \uparrow (q \uparrow q)$$

| $p$ | $q$ | $\neg p$ | $\neg q$ | $\neg p \uparrow \neg q$ | má být $p \vee q$ |
|:-:|:-:|:-:|:-:|:-:|:-:|
| 1 | 1 | 0 | 0 | 1 | 1 ✔ |
| 1 | 0 | 0 | 1 | 1 | 1 ✔ |
| 0 | 1 | 1 | 0 | 1 | 1 ✔ |
| 0 | 0 | 1 | 1 | 0 | 0 ✔ |

##### Krok 5: závěr, který řekneš nahlas

*„Vyjádřil jsem negaci, konjunkci i disjunkci pomocí samotného NAND. Protože $\\{\neg, \wedge, \vee\\}$ je úplný systém, je úplný i $\\{\text{NAND}\\}$. Prakticky to znamená, že libovolný logický obvod se dá postavit z jediného typu hradla — a proto se NAND v elektronice tak používá."*

---

#### Příklad 2 — relace dělitelnosti a Hasseův diagram

**Zadání:** Na množině $A = \\{1,2,3,4,6,12\\}$ (dělitelé dvanácti) uvažujte relaci $R$: *„$x$ dělí $y$"*. Ověřte její vlastnosti, rozhodněte, o jaký typ relace jde, a nakreslete Hasseův diagram.

##### Krok 0: co je co

| Symbol | Význam | Konkrétně |
|---|---|---|
| $A$ | množina, na které relace je | $\\{1,2,3,4,6,12\\}$, tedy $\lvert A \rvert = 6$ |
| $R$ | relace $\subseteq A \times A$ | dvojice $(x,y)$, kde $x$ dělí $y$ |
| $(x,y) \in R$ | „$x$ dělí $y$" | $(2,6) \in R$, protože $6 = 2 \cdot 3$ |

**Kolik je vůbec relací na téhle množině?** $\lvert A \times A \rvert = 6 \cdot 6 = 36$, tedy $2^{36}$ relací. **My z nich zkoumáme jednu konkrétní** — to je dobré na začátku říct, ukazuje to, že rozumíš pojmu.

##### Krok 1: vypsat relaci

Ke každému $x$ najdi všechna $y$ z $A$, která jsou jeho násobkem:

| $x$ | dělí (z $A$) |
|---|---|
| 1 | 1, 2, 3, 4, 6, 12 |
| 2 | 2, 4, 6, 12 |
| 3 | 3, 6, 12 |
| 4 | 4, 12 |
| 6 | 6, 12 |
| 12 | 12 |

Dohromady $6 + 4 + 3 + 2 + 2 + 1 = 18$ dvojic.

##### Krok 2: ověřit vlastnosti

| Vlastnost | Platí? | Zdůvodnění |
|---|---|---|
| **reflexivita** | ✔ | každé číslo dělí samo sebe — $(1,1)$ až $(12,12)$ jsou v tabulce všechny |
| **antireflexivita** | ✘ | smyčky tam naopak jsou všechny |
| **symetrie** | ✘ | $(2,4) \in R$, ale $(4,2) \notin R$ — čtyřka není dělitel dvojky |
| **antisymetrie** | ✔ | dělí-li $x$ číslo $y$ a zároveň $y$ dělí $x$, musí být $x = y$ |
| **tranzitivita** | ✔ | $2$ dělí $4$ a $4$ dělí $12$ $\Rightarrow$ $2$ dělí $12$ ✔ |

**Závěr:** reflexivní + antisymetrická + tranzitivní $\Rightarrow$ **neostré uspořádání**.

A protože **$4$ a $6$ nejsou porovnatelné** ($4 \nmid 6$ a $6 \nmid 4$), jde jen o **částečné uspořádání**, ne lineární.

##### Krok 3: Hasseův diagram

**Nejdřív vyškrtej, co se nekreslí:**

- **6 reflexivních smyček** — pryč (pravidlo 1); zbývá 12 hran
- **tranzitivní hrany** — pryč (pravidlo 2): $(1,4)$ plyne z $1 \to 2 \to 4$; $(1,6)$ z $1 \to 2 \to 6$; $(1,12)$, $(2,12)$ z $2 \to 4 \to 12$; $(3,12)$ z $3 \to 6 \to 12$

**Zbydou jen bezprostřední hrany:** $1 \to 2$, $1 \to 3$, $2 \to 4$, $2 \to 6$, $3 \to 6$, $4 \to 12$, $6 \to 12$ — sedm hran.

```
              12          <- největší prvek (vše ho dělí)
             /  \
            4    6
            |   / \
            |  /   3
            | /   /
            2    /
             \  /
              1           <- nejmenší prvek (dělí vše)
```

##### Krok 4: co k tomu říct nahlas

- **„Dole je $1$, protože dělí všechno; nahoře $12$, protože je dělitelné vším."** — to jsou nejmenší a největší prvek uspořádání.
- **„Hrana $1 \to 4$ tam chybí schválně"** — plyne tranzitivitou přes dvojku. Tohle zkoušející kontroluje.
- **„Diagram se rozvětvuje, a to je grafický důkaz, že uspořádání je jen částečné"** — kdyby bylo lineární, byl by z toho jeden svislý řetěz.

**Rychlá kontrola pro sebe:** kdybys místo dělitelů dvanácti vzal $\leq$ na $\\{1,2,3\\}$, vyjde diagram jako **rovná svislá čára** $1 \to 2 \to 3$ — protože $\leq$ je uspořádání **lineární**. Rozvětvení versus řetěz je ten rozdíl.

---

### Na co se doptají

1. **Dokaž, že $\\{\text{NAND}\\}$ je úplný systém spojek — vyjádři NOT, AND a OR.** → Příklad 1 výše.
2. **Kolik je binárních spojek a proč?** → $2^{2^2} = 16$; tabulka má 4 řádky, každý může mít výstup 0 nebo 1.
3. **Kolik je relací na tříprvkové množině a proč?** → $\lvert A \times A \rvert = 9$, relace je podmnožina, takže $2^{9} = 512$.
4. **Jaký je vztah mezi ekvivalencí a rozkladem množiny?** → Vzájemně jednoznačný: každá ekvivalence dá rozklad na třídy a naopak.
5. **Nakresli Hasseův diagram pro dělitelnost na dělitelích dvanácti.** → Příklad 2 výše.
6. **Je `x > 3` výrok?** → Ne, je to výroková **forma**; výrokem se stane až po dosazení za $x$.
7. **Může být relace zároveň symetrická i antisymetrická?** → Ano — třeba $\\{(1,1)\\}$ nebo obecně jakákoli podmnožina samých smyček (a to je identita).
8. **Může být relace ani reflexivní, ani antireflexivní?** → Ano, $\\{(1,1),(2,3)\\}$ na $\\{1,2,3\\}$ — smyčku má někdo, ne všichni.
9. **Proč je $\emptyset$ podmnožinou každé množiny?** → Podmínka „každý prvek $\emptyset$ leží v $A$" platí prázdně, není co porušit.
10. **Kolik prvků má potenční množina pětiprvkové množiny?** → $2^{5} = 32$; u každého prvku se rozhoduji „vzít, nebo ne".
11. **Jaký je rozdíl mezi $\in$ a $\subseteq$?** → $\in$ je vztah prvku k množině, $\subseteq$ vztah dvou množin. $1 \in \\{1,2\\}$ ✔, $\\{1\\} \subseteq \\{1,2\\}$ ✔, ale $\\{1\\} \in \\{1,2\\}$ ✘.
12. **Kdy je implikace nepravdivá?** → Jedině pro $p = 1$, $q = 0$ — z pravdy nesmí plynout nepravda.
13. **Plyne z $p \Rightarrow q$ a $q$ také $p$?** → **Ne**, to je potvrzování konsekventu. Platí jen obměna $\neg q \Rightarrow \neg p$.
14. **Je splnitelná formule totéž co tautologie?** → Ne. Tautologie je vždy pravdivá, splnitelná stačí aspoň jednou. $p \wedge q$ je splnitelná, ne tautologie.
15. **Uveď rozklad nekonečné množiny.** → $\mathbb{N}_0$ podle zbytku po dělení třemi na $A_0, A_1, A_2$.
16. **Čím se liší ekvivalence od uspořádání?** → Jedinou vlastností: symetrie versus antisymetrie (reflexivitu i tranzitivitu mají obě).
17. **Kdy je uspořádání jen částečné?** → Když existují neporovnatelné prvky, jako $4$ a $6$ u dělitelnosti.
18. **Kdy je relace zobrazením?** → Když každý prvek $A$ má **právě jeden** obraz — ani žádný, ani dva.
19. **Kdy k zobrazení existuje inverzní?** → Právě když je **bijektivní**.
20. **Proč se říká „naivní" teorie množin?** → Protože množinu bere intuitivně a neomezuje, co množina je. To vede k paradoxům — nejznámější je **Russellův**: množina všech množin, které neobsahují samy sebe. Obsahuje sama sebe? Ano vede na ne a ne na ano. Axiomatická teorie (ZFC) tomu předchází.

### Užitečné odkazy

- <https://cs.wikipedia.org/wiki/V%C3%BDrokov%C3%A1_logika>
- <https://cs.wikipedia.org/wiki/Naivn%C3%AD_teorie_mno%C5%BEin>
- <https://cs.wikipedia.org/wiki/Bin%C3%A1rn%C3%AD_relace>
- <https://cs.wikipedia.org/wiki/Hasseho_diagram>
