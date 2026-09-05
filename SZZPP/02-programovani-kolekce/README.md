## 2 — Programování: kolekce

- [Zadání okruhu (PDF)](../ZadaniOkruhu/APR-I-II-3okruhy.pdf)

> Opravit chybný kód pracující s kolekcemi a rozšířit ho podle zadání. 60 minut u počítače (Jupyter, tahák Python, bez internetu), pak 20 minut obhajoby — v úvodu představíš řešení, následuje diskuse a ověřování souvisejících znalostí.

**Tohle není zkouška ze znalostí, ale z rutiny.** Zadání zní „najděte syntaktické i sémantické chyby" — což není otevřený problém, ale **rozpoznávací úloha z uzavřené množiny vzorů**. Proto je jádro téhle přípravy [katalog typických chyb](#katalog-typických-chyb) níž, ne přehled metod seznamu. Kód piš, nečti ho: úlohy jsou ve složce [`Kod/`](./Kod/).

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn na jedno místo, pak výklad s příklady. -->

#### Souhrn na jednom místě

Všechno, co PDF vyžaduje, v jedné tabulce — na rychlé opakování před zkouškou. Podrobný výklad s příklady je pod ní.

| Co | K čemu / jak se chová | Zapamatuj si | Kde |
|---|---|---|---|
| `list` | uspořádaná **měnitelná** posloupnost, index od 0 | `append`/`sort`/`remove` mění na místě a vrací `None` | [↓](#seznam-list--uspořádaný-měnitelný-indexovaný-od-nuly) |
| `dict` | dvojice klíč→hodnota, klíč musí být **neměnitelný** | vyhledání $O(1)$; `d[k]` spadne na `KeyError`, `d.get(k, 0)` ne | [↓](#slovník-dict--dvojice-klíčhodnota-klíč-musí-být-neměnitelný) |
| `range` | **líný generátor**, ne seznam | nedá se měnit; `list(range(…))` z něj udělá seznam | [↓](#range-není-seznam) |
| `str` | neměnitelný řetězec | `.strip()`, `.split()`, `.lower()`, `.capitalize()` vrací **nový** řetězec | — |
| `tuple` | neměnitelná n-tice `(1, 2)` | proto může být klíčem slovníku | — |
| indexování | `s[0]` první, `s[-1]` poslední | záporný index počítá od konce | [↓](#slicing-startstopkrok) |
| slicing | `s[start:stop:krok]` → **nový** seznam | `stop` je **výlučný**; `s[1::2]` = liché indexy; `s[:]` = mělká kopie | [↓](#slicing-startstopkrok) |
| `for` / `while` | průchod kolekcí / dokud platí podmínka | `for` když znáš počet, `while` když čekáš na podmínku | — |
| `enumerate` | dvojice `(index, hodnota)` | lepší než `range(len(s))`; `start=1` posune číslování | [↓](#enumerate-a-zip) |
| `zip` | spojí kolekce po dvojicích | **končí u té kratší**; `dict(zip(a, b))` staví slovník | [↓](#enumerate-a-zip) |
| comprehension | `[výraz for x in kolekce if podmínka]` | `if` na konci **filtruje**, `if…else` vepředu **vybírá hodnotu** | [↓](#list-comprehension) |
| kopie | `b = a` **není kopie** | `.copy()` mělká (vnitřek sdílený), `copy.deepcopy()` hluboká | [↓](#mělká-vs-hluboká-kopie) |
| `is` vs. `==` | identita vs. hodnota | `is` = tentýž objekt v paměti; pro `None` vždy `is None` | [↓](#mělká-vs-hluboká-kopie) |
| výjimky | `raise ValueError("…")`, `try/except` | `ValueError` = špatná hodnota, `TypeError` = špatný typ | [↓](#výjimky) |
| `isinstance` | kontrola typu | past: `isinstance(True, int)` je `True` — `bool` dědí z `int` | [↓](#výjimky) |
| f-string | `f"{jmeno}: {cena:.2f}"` | `f"{x=}"` vypíše jméno i hodnotu — nejrychlejší ladění | [↓](#f-stringy) |
| `print` / `input` | výstup / vstup z konzole | `input()` vrací **vždy `str`** — čísla musíš přetypovat `int(…)` | — |
| `math`, `random` | `sqrt`, `floor`, `pi` / `randint`, `choice` | `randint(1,6)` je **včetně obou** mezí, na rozdíl od `range` | [↓](#math-a-random) |
| vlastní funkce | `def f(a, b=1)` | poziční vs. pojmenované parametry; **`return` nesmí chybět** | — |

**Tři věci z téhle tabulky pokrývají většinu chyb ve zkouškových úlohách:** metody měnící na místě vrací `None`, `range` není seznam, a `b = a` není kopie.

#### Seznam (`list`) — uspořádaný, měnitelný, indexovaný od nuly

```python
mesta = ["Ústí", "Praha", "Brno"]
mesta.append("Plzeň")        # ['Ústí', 'Praha', 'Brno', 'Plzeň']  na konec
mesta.insert(1, "Děčín")     # ['Ústí', 'Děčín', 'Praha', 'Brno', 'Plzeň']  na index
mesta.remove("Brno")         # smaže podle HODNOTY (první výskyt), ValueError když není
posledni = mesta.pop()       # 'Plzeň' — vrátí A smaže; pop(0) je první
len(mesta)                   # 4
"Praha" in mesta             # True — ale je to průchod, O(n)
mesta.index("Praha")         # 2
```

**Past, na kterou se ptají:** `append` vrací `None`, ne seznam. `mesta = mesta.append("X")` ti přepíše seznam na `None`. Totéž `sort()`, `reverse()`, `remove()` — **mění na místě a vrací `None`**. Naproti tomu `sorted(mesta)` vrací **nový** seznam a původní nechá být.

```python
a = [3, 1, 2]
b = a.sort()        # b je None!  a je [1, 2, 3]
c = sorted([3,1,2]) # c je [1, 2, 3],  původní seznam beze změny
```

#### Slovník (`dict`) — dvojice klíč→hodnota, klíč musí být neměnitelný

```python
znamky = {"Anna": 1, "Bob": 3}
znamky["Cyril"] = 2          # přidání i změna je totéž
znamky["David"]              # KeyError!  Klíč neexistuje
znamky.get("David")          # None — nespadne
znamky.get("David", 0)       # 0 — výchozí hodnota
"Anna" in znamky             # True — testuje KLÍČ, ne hodnotu; a je to O(1)
znamky.keys()                # dict_keys(['Anna', 'Bob', 'Cyril'])
znamky.values()              # dict_values([1, 3, 2])
znamky.pop("Bob")            # 3 — vrátí a smaže
```

Iterace přes slovník vždycky přes `.items()`, když potřebuješ obojí:

```python
for jmeno, znamka in znamky.items():
    print(f"{jmeno}: {znamka}")
# Anna: 1
# Cyril: 2
```

Samotné `for x in znamky:` iteruje **přes klíče**, ne přes hodnoty — častá chyba.

**Kdy slovník místo seznamu:** vyhledání podle klíče je $O(1)$ (hashovací tabulka), v seznamu $O(n)$ (musíš projít). U 10 položek je to jedno, u 100 000 je to rozdíl mezi milisekundou a minutou. Teorie k tomu je v [SZZTP okruh 1](../../SZZTP/01-abstraktni-kolekce/).

#### `range` **není** seznam

Tohle je v ukázkové úloze hlavní past, tak si to zapamatuj zvlášť:

```python
data = range(1, 10)
print(data)              # range(1, 10)  — NE [1,2,...,9]
data[0] = 99             # TypeError: 'range' object does not support item assignment
list(range(1, 10))       # [1, 2, 3, 4, 5, 6, 7, 8, 9]  ← až tohle je seznam
```

`range(1, 10)` je **líný generátor**: neuloží devět čísel, uloží si jen „od 1 do 10 po 1" a čísla dopočítává za běhu. Proto je neměnitelný a proto se `print` nevypíše hezky. Hranice: **od `start` včetně, do `stop` bez něj**. `range(5)` je `0,1,2,3,4`, tedy pět prvků. `range(1, 10, 2)` je `1,3,5,7,9`.

#### Slicing `[start:stop:krok]`

```python
s = [0, 10, 20, 30, 40, 50]
s[1:4]      # [10, 20, 30]   — stop je VÝLUČNÝ
s[:3]       # [0, 10, 20]
s[3:]       # [30, 40, 50]
s[::2]      # [0, 20, 40]    — každý druhý od začátku (INDEXY 0,2,4)
s[1::2]     # [10, 30, 50]   — každý druhý od indexu 1 (INDEXY 1,3,5)
s[-1]       # 50             — poslední
s[-2:]      # [40, 50]       — poslední dva
s[::-1]     # [50,40,30,20,10,0]  — obrácený, jako nový seznam
```

**`s[1::2]` si zapamatuj**, ukázková úloha chce přesně „prvek s lichým indexem (druhý, čtvrtý, šestý…)". Všimni si toho matoucího názvosloví v zadání: **lichý index = sudé pořadí**. Index 1 je *druhý* prvek. Tady se dělá off-by-one nejčastěji.

Slicing seznamu vrací **nový seznam** — takže `kopie = s[:]` je zároveň nejkratší způsob mělké kopie.

#### `enumerate` a `zip`

Když potřebuješ index i hodnotu, nepiš `for i in range(len(s))`:

```python
for i, hodnota in enumerate(["a", "b", "c"]):
    print(i, hodnota)
# 0 a
# 1 b
# 2 c

for i, h in enumerate(["a", "b"], start=1):   # číslování od 1
    print(i, h)
# 1 a
# 2 b
```

`zip` spojí dvě kolekce po dvojicích a **končí u té kratší**:

```python
jmena = ["Anna", "Bob", "Cyril"]
body  = [10, 20]
list(zip(jmena, body))     # [('Anna', 10), ('Bob', 20)]  — Cyril vypadl!
dict(zip(jmena, body))     # {'Anna': 10, 'Bob': 20}      — hezký způsob stavby slovníku
```

#### List comprehension

Zkratka za „projdi kolekci a vyrob novou". Obojí umět napsat, protože zadání často chce **nemodifikovat, ale vrátit nový seznam**:

```python
cisla = [1, 2, 3, 4, 5]

# klasicky
vysledek = []
for x in cisla:
    vysledek.append(x * 2)
# [2, 4, 6, 8, 10]

# comprehension — totéž
vysledek = [x * 2 for x in cisla]        # [2, 4, 6, 8, 10]

# s podmínkou (filtr — patří NA KONEC)
sude = [x for x in cisla if x % 2 == 0]  # [2, 4]

# s výběrem hodnoty (ternární — patří DOPŘEDU, musí mít else)
upravene = [x + 1 if x % 2 == 0 else x for x in cisla]   # [1, 3, 3, 5, 5]

# s indexem
z_lichych = [x for i, x in enumerate(cisla) if i % 2 == 1]  # [2, 4]
```

**Rozdíl mezi těmi dvěma posledními tvary je oblíbená doptávka.** `if` na konci **vyhazuje prvky** (filtr, bez `else`). `if…else` na začátku **vybírá hodnotu** a vrací stejný počet prvků (musí mít `else`, jinak `SyntaxError`).

Slovníková comprehension funguje stejně: `{k: v*2 for k, v in znamky.items()}`.

#### Mělká vs. hluboká kopie

```python
a = [1, 2, 3]
b = a              # NENÍ kopie — druhé jméno pro tentýž seznam
b.append(4)
print(a)           # [1, 2, 3, 4]  ← změnilo se i a!
a is b             # True

c = a.copy()       # nebo a[:] nebo list(a) — mělká kopie
c.append(5)
print(a)           # [1, 2, 3, 4]  ← a se nezměnilo
a is c             # False
a == c             # False (c má navíc 5); po `c = a.copy()` by bylo True
```

Mělká kopie ale zkopíruje **jen vnější seznam**. U vnořených struktur:

```python
import copy
matice = [[1, 2], [3, 4]]
melka = matice.copy()
melka[0].append(99)
print(matice)           # [[1, 2, 99], [3, 4]]  ← prosáklo dovnitř!

hluboka = copy.deepcopy(matice)
hluboka[0].append(7)
print(matice)           # [[1, 2, 99], [3, 4]]  ← teď už ne
```

**`is` vs. `==`:** `is` ptá se „je to tentýž objekt v paměti", `==` „mají stejnou hodnotu". Pro `None` se používá `is None`.

#### Výjimky

Zadání explicitně chce „kontrola, zda jsou prvky skutečně čísla, pokud nikoliv vyhození výjimky":

```python
def zdvojnasob(data):
    if not isinstance(data, list):
        raise TypeError("očekávám seznam")
    for i, x in enumerate(data):
        if not isinstance(x, (int, float)):
            raise ValueError(f"prvek na indexu {i} není číslo: {x!r}")
    return [x * 2 for x in data]

zdvojnasob([1, 2, "a"])   # ValueError: prvek na indexu 2 není číslo: 'a'
```

Kterou výjimku zvolit: **`ValueError`** = správný typ, špatná hodnota (prázdný seznam, záporná délka). **`TypeError`** = špatný typ úplně (dostal jsem `str` místo `list`). **`IndexError`** / **`KeyError`** vyhazuje Python sám.

Odchycení:

```python
try:
    vysledek = zdvojnasob([1, "a"])
except ValueError as e:
    print(f"Chyba: {e}")      # Chyba: prvek na indexu 1 není číslo: 'a'
```

**Past:** `isinstance(True, int)` je `True` — `bool` v Pythonu dědí z `int`. Když chceš `True` odmítnout, musíš to napsat: `if isinstance(x, bool) or not isinstance(x, (int, float))`.

#### f-stringy

```python
jmeno, cena, podil = "šroubek", 12.3456, 0.07
print(f"{jmeno}: {cena:.2f} Kč")     # šroubek: 12.35 Kč
print(f"{podil:.1%}")                # 7.0%
print(f"{cena:>10.1f}|")             # "      12.3|"  — zarovnání na 10 znaků
print(f"{jmeno=}, {cena=}")          # jmeno='šroubek', cena=12.3456  ← skvělé na ladění
```

Ten poslední tvar (`f"{promenna=}"`) používej při ladění — vypíše jméno i hodnotu, ušetří psaní.

#### `math` a `random`

```python
import math, random
math.sqrt(16)        # 4.0
math.floor(2.7)      # 2      math.ceil(2.1) → 3
math.pi              # 3.141592653589793
random.randint(1, 6) # celé číslo 1–6 VČETNĚ obou (na rozdíl od range!)
random.choice(["a", "b", "c"])
random.seed(42)      # reprodukovatelnost — u zkoušky se hodí, ať máš stejný výstup
```

---

### Katalog typických chyb

<!-- Tohle je jádro přípravy. Zkoušková úloha je rozpoznávací, ne tvůrčí. -->

Když dostaneš cizí kód, projdi ho tímhle seznamem místo hádání. **Prvních pět je přímo z ukázkové úlohy nebo její blízké variace.**

| # | Vzor chyby | Jak vypadá | Proč selže |
|---|---|---|---|
| 1 | **`range` místo seznamu** | `data = range(1,10)`, pak `data[0] = 5` | `range` je neměnitelný generátor → `TypeError`. Oprava: `list(range(1,10))` |
| 2 | **Přiřazení do iterační proměnné** | `for x in data: x += 1` | `x` je jen kopie odkazu; kolekce se nezmění, cyklus proběhne naprázdno |
| 3 | **Test na špatné proměnné** | `for c in text: if text == "("` | Porovnává celý řetězec místo znaku — vždy `False`. Má být `if c == "("` |
| 4 | **Index vs. hodnota** | `if item % 2 == 1` když má jít o *pozici* | Zadání říká „lichý index", kód testuje lichou hodnotu. Řeší `enumerate` |
| 5 | **Sudý/lichý naopak** | komentář říká „sudé", kód testuje `% 2 == 1` | Sémantická chyba — kód běží, dělá něco jiného. Sudé je `% 2 == 0` |
| 6 | **Mazání během iterace** | `for x in s: if x < 0: s.remove(x)` | Posune indexy, přeskočí prvky. Řešení: iteruj přes kopii `s[:]` nebo postav nový seznam |
| 7 | **`b = a` místo kopie** | `kopie = puvodni` a pak `kopie.append(…)` | Není kopie, jen druhé jméno — změní se obojí. Má být `a.copy()` |
| 8 | **Mělká kopie u vnořené struktury** | `m2 = matice.copy()`, pak `m2[0][0] = 9` | Vnitřní seznamy jsou sdílené. Má být `copy.deepcopy` |
| 9 | **Návratová hodnota `None`** | `s = s.append(x)` nebo `s = s.sort()` | Metody měnící na místě vrací `None` → seznam zmizí |
| 10 | **Chybějící `return`** | funkce jen počítá a nic nevrací | Volající dostane `None`; typicky u „místo modifikace vrať nový seznam" |
| 11 | **Off-by-one ve slicingu / `range`** | `s[0:len(s)-1]`, `range(1, len(s))` | `stop` je výlučný — utne poslední prvek nebo přeskočí první |
| 12 | **`KeyError` u slovníku** | `pocty[slovo] += 1` na nový klíč | Klíč ještě neexistuje. `pocty.get(slovo, 0) + 1` nebo `setdefault` |
| 13 | **Mutable default argument** | `def f(x, akum=[])` | Seznam se vytvoří **jednou** při definici a přežije mezi voláními. Má být `akum=None` a uvnitř `if akum is None: akum = []` |
| 14 | **Iterace přes slovník bez `.items()`** | `for k, v in znamky:` | Iteruje přes klíče (řetězce) → `ValueError: too many values to unpack` |
| 15 | **`==` místo `is` u `None`** | `if x == None` | Funguje, ale nesprávný idiom; u vlastních tříd s `__eq__` může selhat |
| 16 | **`isinstance(True, int) == True`** | kontrola typu čísla propustí `bool` | `bool` dědí z `int`; `[True, False]` projde jako „čísla" |
| 17 | **Chybí `self`** | `def metoda():` uvnitř třídy | Spíš okruh 3, ale objevuje se |
| 18 | **Porovnání float na rovnost** | `if 0.1 + 0.2 == 0.3` | `False` — je to `0.30000000000000004`. `math.isclose(a, b)` |

**Syntaktické chyby** (kód nespustíš) najdeš tak, že ho **prostě spustíš** — Python ti řekne řádek. Patří sem chybějící dvojtečka, špatné odsazení, neuzavřená závorka, `SyntaxError` u comprehension bez `else`.

**Sémantické chyby** (kód běží, dělá blbost) najdeš jen tak, že **porovnáš, co kód dělá, s tím, co slibuje docstring nebo komentář**. Proto docstring vždy přečti dřív než kód — je to zadání.

---

### Rozbor ukázkové úlohy z PDF

Zadání:

```python
# kód má ke každé položce modifikovatelné sekvence s celočíselnými prvky
# přičíst 1 je-li položka sudá

data = range(1, 10)

print(data)

for item in data:
    if item % 2 == 1:
        item += 1

print(data)
```

Rozšíření podle PDF: inkrementovat prvek s **lichým indexem**, místo modifikace vracet **nový seznam**, kontrolovat, že prvky jsou **čísla**, jinak výjimka.

#### Co je špatně — čtyři chyby

1. **`data = range(1, 10)` není „modifikovatelná sekvence".** Komentář to explicitně vyžaduje, `range` to nesplňuje. → `list(range(1, 10))`
2. **`print(data)` vypíše `range(1, 10)`**, ne prvky. Důsledek předchozího.
3. **`item += 1` nic nemění.** `item` je lokální jméno; přiřazení do něj přepíše jen tu proměnnou, ne prvek v seznamu. Cyklus proběhne devětkrát a neudělá nic.
4. **`if item % 2 == 1` testuje liché, komentář říká sudé.** Sémantický rozpor. Sudé je `% 2 == 0`.

Chyby 1 a 2 jsou **sémantické, ne syntaktické** — kód se spustí a doběhne bez chybové hlášky. Právě proto je nutné spustit ho a **porovnat výstup se zadáním**, ne jen číst.

#### Opravená verze (doslova podle komentáře)

```python
data = list(range(1, 10))       # [1, 2, ..., 9]
print(data)

for i in range(len(data)):
    if data[i] % 2 == 0:        # sudá HODNOTA, podle komentáře
        data[i] += 1            # zápis přes index — tohle už mění seznam

print(data)                     # [1, 3, 3, 5, 5, 7, 7, 9, 9]
```

Ověření v hlavě: sudé hodnoty jsou 2, 4, 6, 8 → z nich bude 3, 5, 7, 9. Liché zůstanou. Sedí.

#### Rozšíření podle zadání

```python
def inkrementuj_liche_indexy(data: list) -> list:
    """
    Vrací NOVÝ seznam, kde jsou o 1 zvýšeny prvky na lichém indexu
    (tedy druhý, čtvrtý, šestý … prvek v pořadí).
    Vyhazuje ValueError, pokud některý prvek není číslo.
    """
    if not isinstance(data, list):
        raise TypeError(f"očekávám seznam, dostal jsem {type(data).__name__}")

    for i, x in enumerate(data):
        if isinstance(x, bool) or not isinstance(x, (int, float)):
            raise ValueError(f"prvek na indexu {i} není číslo: {x!r}")

    return [x + 1 if i % 2 == 1 else x for i, x in enumerate(data)]
```

Ověření: `inkrementuj_liche_indexy([10, 20, 30, 40])` → indexy 1 a 3 → `[10, 21, 30, 41]`. Sedí.

**Proč `enumerate` a ne `data[1::2]`:** slicing sice vybere správné prvky, ale ztratí jejich pozice a nešlo by z něj složit celý seznam v původním pořadí. `enumerate` dá index i hodnotu naráz.

**Proč kontrola typů ve zvláštním cyklu a ne uvnitř comprehension:** aby funkce buď uspěla celá, nebo neudělala nic. Kdyby se kontrolovalo za pochodu, u chyby uprostřed už máš rozdělanou práci. U funkce vracející nový seznam je to jedno, u modifikace na místě zásadní — **a přesně na tohle se u obhajoby ptají**.

#### Varianta, kdyby chtěli modifikaci na místě

```python
def inkrementuj_na_miste(data: list) -> None:
    """Modifikuje seznam PŘÍMO. Nic nevrací (proto -> None)."""
    for i in range(1, len(data), 2):    # 1, 3, 5, … rovnou lichá
        data[i] += 1
```

Umět obě verze a **umět vysvětlit rozdíl**, protože zadání to explicitně staví proti sobě: modifikace na místě nic nevrací a mění vstup volajícího (může být nechtěné), nová kolekce vstup nechá být, ale zabere paměť navíc.

---

### Postup u zkoušky (60 min přípravy)

<!-- Časový rozpočet. Drž se ho, ať nezůstaneš viset na opravě a nestihneš rozšíření. -->

**0–10 min — pochopit a spustit**
1. Přečíst **docstring a komentáře dřív než kód** — je to zadání, kód je podezřelý.
2. Kód **spustit tak, jak je**. Zapsat si přesnou chybovou hlášku nebo výstup. Tohle je tvůj výchozí stav do „výsledků ladění" a bez něj nemáš co obhajovat.
3. Vypsat si na papír: co má kód dělat / co dělá / kde se to rozchází.

**10–25 min — oprava**

4. Projít [katalog chyb](#katalog-typických-chyb) shora.
5. Opravovat **po jedné chybě a po každé spustit**. Nikdy neopravuj tři věci naráz — nebudeš vědět, která pomohla.
6. Ověřit na příkladu, který spočítáš v hlavě (`[1,2,3,4]`, ne `range(1000)`).

**25–50 min — rozšíření**

7. Rozšíření dělej **jako novou funkci, ne přepisem opravené.** Chceš u obhajoby ukázat obojí a mít se čeho držet, kdyby se rozšíření nepovedlo.
8. Body ze zadání ber **po jednom a v pořadí, jak jsou napsané** — komise podle nich kontroluje.
9. Ke každému bodu zapiš jeden testovací příklad s očekávaným výsledkem.

**50–60 min — sepsat ladění a zkontrolovat**

10. Vyplnit [šablonu výsledků ladění](#šablona-výsledků-ladění) — je to explicitně požadovaný výstup.
11. Poslední spuštění celého notebooku odshora (`Restart & Run All`) — ať v obhajobě nevyskočí chyba ze zapomenuté buňky.

**Když ti dojde čas:** raději opravený kód + poctivý popis „tohle jsem nestihl a takhle bych to udělal" než rozdělané rozšíření, které nejde spustit. Zadání se ptá „co funguje **a co nikoliv a proč**" — nefunkční část s vysvětlením je legitimní odpověď.

---

### Šablona výsledků ladění

<!-- Explicitně požadovaný výstup ze zadání. Předpřipravená struktura, u zkoušky se jen doplní. -->

Vlož do notebooku jako markdown buňku pod řešení:

```
## Výsledky ladění

### Nalezené chyby
| # | Řádek | Typ | Popis | Oprava |
|---|-------|-----|-------|--------|
| 1 | 1 | sémantická | `range` není modifikovatelná sekvence | `list(range(1,10))` |
| 2 | 8 | sémantická | `item += 1` nemění seznam, jen lokální proměnnou | zápis přes `data[i]` |

### Co funguje
- Oprava: pro `[1..9]` vrací `[1,3,3,5,5,7,7,9,9]` — ověřeno ručním výpočtem.
- Rozšíření: `[10,20,30,40]` → `[10,21,30,41]`, indexy 1 a 3.
- Kontrola typů: `[1,"a"]` vyhodí ValueError s indexem chybného prvku.

### Co nefunguje / omezení
- `bool` je podtyp `int`; ošetřeno zvlášť, jinak by `[True]` prošlo jako čísla.
- Nekontroluje se vnořený seznam — `[[1,2]]` vyhodí ValueError, což je zamýšlené.

### Jak jsem to testoval
- Krátké seznamy s ručně dopočítaným výsledkem.
- Hraniční případy: prázdný seznam, jednoprvkový, seznam s nečíslem.
```

**Hraniční případy zmiň vždycky** — prázdná kolekce, jeden prvek, špatný typ. To je nejlevnější způsob, jak u obhajoby vypadat, že víš, co děláš.

---

### Co si nacvičit

Úlohy jsou ve složce [`Kod/`](./Kod/):

- **00 — ukázková úloha** ([notebook](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/02-programovani-kolekce/Kod/00-ukazkova-uloha.ipynb) · [číst na webu](./Kod/00-ukazkova-uloha.md)) — oficiální úloha z PDF s celým rozborem
- **01 — cvičení, zadání** ([notebook](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/02-programovani-kolekce/Kod/01-cviceni-zadani.ipynb) · [číst na webu](./Kod/01-cviceni-zadani.md)) — šest úloh, prázdné buňky na řešení
- **02 — cvičení, řešení** ([notebook](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/02-programovani-kolekce/Kod/02-cviceni-reseni.ipynb) · [číst na webu](./Kod/02-cviceni-reseni.md)) — řešení, výsledky ladění a doptávky

Na webu jsou notebooky vidět i s výstupy (spouští se při buildu). **Trénuj ale v Jupyteru, ne na webu** — čtení kódu vytváří pocit znalosti bez znalosti.

- [ ] Ukázková úloha z PDF celá, včetně rozšíření, na časovku 60 minut
- [ ] Cvičná úloha 1 — mazání během iterace
- [ ] Cvičná úloha 2 — slovník, `KeyError` a `.get()`
- [ ] Cvičná úloha 3 — mělká vs. hluboká kopie
- [ ] Cvičná úloha 4 — index vs. hodnota, `enumerate`
- [ ] Cvičná úloha 5 — mutable default argument
- [ ] Cvičná úloha 6 — návratová hodnota `None` u metod měnících na místě
- [ ] Napsat tutéž transformaci **klasickým cyklem i comprehension** (obojí bez přemýšlení)
- [ ] Zpaměti: `s[1::2]`, `enumerate(s, start=1)`, `dict(zip(a, b))`, `sorted` vs. `.sort()`

---

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

---

### Na co se doptají

- **Proč se `range` nedá modifikovat? Co to vlastně je?** — Líný generátor, drží si jen `start`, `stop`, `krok` a čísla dopočítává. Proto je paměťově $O(1)$ i pro milion prvků, ale je neměnitelný.
- **Co se stane, když ze seznamu mažeš prvky během iterace?** — Iterátor si drží index, mazání posune zbytek doleva → prvky se přeskočí. `[1,1,2]` s mazáním jedniček skončí jako `[1,2]`. Řešení: iterovat přes kopii, nebo postavit nový seznam.
- **Kdy je slovník lepší než seznam a jaká je složitost vyhledání?** — Slovník $O(1)$ (hashovací tabulka), seznam $O(n)$. Slovník když hledáš podle klíče, seznam když potřebuješ pořadí a indexy. Detaily v [SZZTP 1](../../SZZTP/01-abstraktni-kolekce/).
- **Rozdíl mezi `list.copy()` a `copy.deepcopy()`?** — Mělká kopie duplikuje jen vnější seznam, vnitřní objekty zůstanou sdílené. `deepcopy` projde rekurzivně vše. U plochého seznamu čísel je to jedno, u seznamu seznamů zásadní.
- **Proč jste zvolil vrácení nového seznamu místo modifikace?** — Nemodifikuje vstup volajícího (žádný vedlejší efekt), funkce je čistá a snáz testovatelná. Cena je paměť navíc — u velkých dat může být modifikace na místě nutná.
- **Jaký je rozdíl mezi `is` a `==`?** — `is` porovnává identitu (tentýž objekt v paměti), `==` hodnotu. `[1,2] == [1,2]` je `True`, `[1,2] is [1,2]` je `False`.
- **Proč jste použil `ValueError` a ne `TypeError`?** — `TypeError` = špatný typ argumentu jako celku, `ValueError` = správný typ, nevyhovující obsah. U prvku uvnitř seznamu jde spíš o obsah.
- **Co dělá `enumerate` a proč to je lepší než `range(len(s))`?** — Vrací dvojice (index, hodnota), takže nemusíš indexovat ručně. Čitelnější a funguje i na kolekcích bez indexu.
- **Rozdíl mezi `if` na konci a `if…else` na začátku comprehension?** — Na konci filtruje (mění počet prvků), na začátku vybírá hodnotu (počet zachová) a musí mít `else`.
- **Je `[]` a `list()` totéž?** — Ano, `[]` je jen rychlejší literál.
- **Co je hashovatelný objekt a proč jím musí být klíč slovníku?** — Neměnitelný objekt s konstantním hashem (`str`, `int`, `tuple`). Seznam klíčem být nemůže — po změně by se změnil jeho hash a hodnota by se ve slovníku „ztratila".

---

### Užitečné odkazy

- Dokumentace datových typů: <https://docs.python.org/3/tutorial/datastructures.html>
- Teorie kolekcí a složitostí: [SZZTP okruh 1](../../SZZTP/01-abstraktni-kolekce/)
- Algoritmy nad seznamy: [SZZTP okruh 2](../../SZZTP/02-algoritmy-nad-seznamy/)
