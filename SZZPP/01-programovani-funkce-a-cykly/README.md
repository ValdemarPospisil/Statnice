## 1 — Programování: funkce a cykly

- [Zadání okruhu (PDF)](../ZadaniOkruhu/APR-I-II-3okruhy.pdf)

> Najít syntaktické i sémantické chyby v poskytnutém kódu, opravit je a rozšířit funkčnost podle zadání. 60 minut u počítače (Jupyter, tahák Python, bez internetu), pak 20 minut obhajoby — v úvodu představíš řešení, následuje diskuse a ověřování souvisejících znalostí.

**Tohle není zkouška ze znalostí, ale z rutiny.** Zadání zní „najděte syntaktické i sémantické chyby" — což není otevřený problém, ale **rozpoznávací úloha z uzavřené množiny vzorů**. Proto je jádro téhle přípravy [katalog typických chyb](#katalog-typických-chyb) níž, ne přehled syntaxe. Kód piš, nečti ho: úlohy jsou ve složce [`Kod/`](./Kod/).

Okruh se z velké části překrývá s [okruhem 2 (kolekce)](../02-programovani-kolekce/) — společné jsou literály, cykly, výjimky, f-stringy. **Tady je navíc těžiště na funkcích** (parametry, `return`, návratové hodnoty) a na `while` cyklech, kolekce naopak skoro nepotřebuješ.

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn na jedno místo, pak výklad s příklady. -->

#### Souhrn na jednom místě

Všechno, co PDF vyžaduje, v jedné tabulce — na rychlé opakování před zkouškou. Podrobný výklad s příklady je pod ní.

| Co | K čemu / jak se chová | Zapamatuj si | Kde |
|---|---|---|---|
| `int`, `float` | celé číslo / desetinné | `/` vrací vždy `float`, `//` celočíselné dolů, `%` zbytek | [↓](#literály-a-operace-základních-typů) |
| `bool` | `True` / `False` | je to **podtyp `int`**: `True + True` je `2` | [↓](#literály-a-operace-základních-typů) |
| `str` | **neměnitelný** řetězec | `.strip()`, `.lower()`, `.split()` vrací **nový** řetězec, původní nemění | [↓](#řetězce-a-jejich-metody) |
| přetypování | `int("5")`, `float("1.5")`, `str(5)` | `int("abc")` vyhodí `ValueError` — ošetři `try/except` | [↓](#vstup-a-výstup-na-konzoli) |
| proměnné | `a = 5`, `a, b = b, a` | prohození jedním řádkem bez pomocné proměnné | — |
| `if/elif/else` | větvení | `elif` se vyhodnotí **jen když předchozí neplatí** — pořadí rozhoduje | [↓](#podmínky-a-větvení) |
| porovnání | `<`, `<=`, `==`, `!=` | řetězitelné: `0 <= x <= 10` funguje a je to idiom | [↓](#podmínky-a-větvení) |
| `and`, `or`, `not` | logické spojky | **zkrácené vyhodnocení** — `if s and s[0]` nespadne na prázdném řetězci | [↓](#podmínky-a-větvení) |
| `for` | průchod něčím konečným | když nepotřebuješ hodnotu, `for _ in range(n)` | [↓](#cykly-for-a-while) |
| `while` | dokud platí podmínka | **řídicí proměnná se musí uvnitř měnit**, jinak nekonečná smyčka | [↓](#cykly-for-a-while) |
| `break` / `continue` | ukončit cyklus / přeskočit iteraci | `break` opustí **jen nejvnitřnější** cyklus | [↓](#break-continue-a-else-u-cyklu) |
| `for…else` | `else` proběhne, **když nebyl `break`** | typicky „nenašel jsem" — málokdo to zná, ale je to elegantní | [↓](#break-continue-a-else-u-cyklu) |
| `def` | vlastní funkce | **bez `return` vrací `None`**; `return` cyklus i funkci hned ukončí | [↓](#vlastní-funkce) |
| parametry | poziční vs. pojmenované | pojmenované s výchozí hodnotou musí být **až za** pozičními | [↓](#vlastní-funkce) |
| výchozí hodnoty | `def f(a, b=1)` | **nikdy měnitelný default** (`[]`, `{}`) — použij `None` | [↓](#vlastní-funkce) |
| `raise` | vyvolání výjimky | `ValueError` = špatná hodnota, `TypeError` = špatný typ | [↓](#výjimky) |
| `try/except` | odchycení | chytej **konkrétní** výjimku, ne holý `except:` | [↓](#výjimky) |
| f-string | `f"{jmeno}: {cena:.2f}"` | `f"{x=}"` vypíše jméno i hodnotu — nejrychlejší ladění | [↓](#f-stringy-a-formátování) |
| `print` | výstup | `print(a, b)` dá mezeru; `end=""` potlačí odřádkování | [↓](#vstup-a-výstup-na-konzoli) |
| `input` | vstup | vrací **vždy `str`** — čísla musíš přetypovat | [↓](#vstup-a-výstup-na-konzoli) |
| `math` | `sqrt`, `floor`, `ceil`, `pi` | `math.floor(-2.5)` je `-3` (dolů), ne `-2` | [↓](#math-a-random) |
| `random` | `randint`, `random`, `choice` | `randint(1,6)` je **včetně obou** mezí, na rozdíl od `range` | [↓](#math-a-random) |

**Tři věci z téhle tabulky pokrývají většinu chyb ve zkouškových úlohách:** funkce bez `return` vrací `None`, `while` s neměnící se podmínkou se zacyklí, a `input()` vrací řetězec, ne číslo.

#### Literály a operace základních typů

```python
celé = 42                # int
desetinné = 3.14         # float
pravda = True            # bool
text = "ahoj"            # str

7 / 2        # 3.5   — pravé dělení, VŽDY float
7 // 2       # 3     — celočíselné, zaokrouhluje DOLŮ
-7 // 2      # -4    ← pozor, dolů znamená k mínus nekonečnu, ne k nule
7 % 2        # 1     — zbytek po dělení
2 ** 10      # 1024  — mocnina
```

`%` je nejužitečnější operátor u těchhle úloh — testuje dělitelnost:

```python
8 % 2 == 0      # True  — sudé
7 % 2 == 0      # False — liché
15 % 3 == 0     # True  — dělitelné třemi
```

**Past s `bool`:** `bool` v Pythonu **dědí z `int`**, takže se chová jako číslo:

```python
True + True      # 2
True == 1        # True
isinstance(True, int)   # True  ← proto kontrola typu čísla propustí bool
sum([True, False, True])  # 2   — dá se toho využít na počítání splněných podmínek
```

**Past s `float`:** desetinná čísla se nedají porovnávat na rovnost:

```python
0.1 + 0.2 == 0.3           # False!
0.1 + 0.2                  # 0.30000000000000004
math.isclose(0.1 + 0.2, 0.3)   # True  ← takhle správně
```

#### Řetězce a jejich metody

Řetězec je **neměnitelný** — všechny metody vrací nový:

```python
s = "  Ahoj Světe  "
s.strip()            # 'Ahoj Světe'   — ořízne mezery z obou stran
s.lower()            # '  ahoj světe  '
s.upper()            # '  AHOJ SVĚTE  '
s.capitalize()       # '  ahoj světe  '  ← pozor, první znak je mezera!
s.strip().capitalize()  # 'Ahoj světe'   — až takhle
print(s)             # '  Ahoj Světe  ' — původní se NEZMĚNIL
```

```python
"a,b,c".split(",")       # ['a', 'b', 'c']
"a b c".split()          # ['a', 'b', 'c']  — bez argumentu dělí podle mezer
"-".join(["a", "b"])     # 'a-b'
"ahoj".replace("a", "A") # 'Ahoj'
len("ahoj")              # 4
"ahoj"[0]                # 'a'    — indexování funguje
"ahoj"[-1]               # 'j'
"ahoj"[1:3]              # 'ho'   — slicing taky
"oj" in "ahoj"           # True
"ahoj"[0] = "A"          # TypeError! Řetězec je neměnitelný
```

Průchod znaky je prostě `for`:

```python
for znak in "abc":
    print(znak, end=" ")
# a b c
```

**Testovací metody** (vrací `bool`, hodí se do podmínek):

```python
"123".isdigit()      # True   — samé číslice
"abc".isalpha()      # True   — samá písmena
"".isdigit()         # False  ← prázdný řetězec je vždy False
"ahoj".startswith("a")   # True
```

#### Podmínky a větvení

```python
teplota = 25

if teplota > 30:
    print("horko")
elif teplota > 20:
    print("příjemně")     # ← vypíše tohle
else:
    print("zima")
```

**Na pořadí `elif` záleží** — vyhodnotí se první, která platí, zbytek se přeskočí. Tohle je klasická sémantická chyba:

```python
# ŠPATNĚ — nikdy nevypíše "horko"
if teplota > 20:
    print("příjemně")     # 25 i 35 spadne sem
elif teplota > 30:
    print("horko")        # nedosažitelné!

# SPRÁVNĚ — od nejužší podmínky k nejširší
if teplota > 30:
    print("horko")
elif teplota > 20:
    print("příjemně")
```

**Řetězení porovnání** funguje a je to idiomatický Python:

```python
x = 5
0 <= x <= 10          # True — a čte se to jako v matematice
0 <= x and x <= 10    # totéž, ale delší
```

**Zkrácené vyhodnocení** (`and` / `or`): Python přestane vyhodnocovat, jakmile zná výsledek. Využívá se na ochranu před pádem:

```python
s = ""
if s and s[0] == "(":     # s je "" → False → s[0] se VŮBEC nevyhodnotí
    print("začíná závorkou")
# bez toho `s and` by to spadlo na IndexError
```

**Pravdivostní hodnota:** prázdné věci jsou nepravdivé, což zkracuje podmínky:

```python
bool("")     # False        bool("a")   # True
bool(0)      # False        bool(5)     # True
bool([])     # False        bool([1])   # True
bool(None)   # False

if not text:              # čitelnější než  if len(text) == 0
    raise ValueError("prázdný vstup")
```

#### Cykly `for` a `while`

**`for`** — když víš, přes co jdeš:

```python
for i in range(5):        # 0, 1, 2, 3, 4
    print(i, end=" ")
# 0 1 2 3 4

for i in range(1, 6):     # 1..5 — stop je VÝLUČNÝ
    print(i, end=" ")
# 1 2 3 4 5

for i in range(10, 0, -2):   # 10, 8, 6, 4, 2 — krok může být záporný
    print(i, end=" ")
# 10 8 6 4 2

for _ in range(3):        # podtržítko = hodnotu nepotřebuju
    print("ahoj")
```

**`while`** — když nevíš, kolikrát to poběží:

```python
zustatek = 100
roky = 0
while zustatek < 200:
    zustatek *= 1.05      # 5 % ročně
    roky += 1             # ← BEZ tohohle řádku by to bylo nekonečné
print(f"zdvojnásobí se za {roky} let")   # zdvojnásobí se za 15 let
```

**Nejčastější chyba u `while`:** řídicí proměnná se uvnitř nemění → nekonečná smyčka.

```python
# ŠPATNĚ — i se nikdy nezvýší, běží donekonečna
i = 0
while i < 5:
    print(i)

# SPRÁVNĚ
i = 0
while i < 5:
    print(i)
    i += 1
```

**Kdy co:** `for` když znáš počet opakování nebo procházíš kolekci, `while` když čekáš na splnění podmínky (vstup od uživatele, konvergence výpočtu).

#### `break`, `continue` a `else` u cyklu

```python
# break — okamžitě opustí cyklus
for i in range(10):
    if i == 3:
        break
    print(i, end=" ")
# 0 1 2

# continue — přeskočí zbytek iterace, pokračuje další
for i in range(5):
    if i % 2 == 0:
        continue
    print(i, end=" ")
# 1 3
```

**`for…else`** je pythonovská specialita, kterou málokdo zná — `else` se provede, **jen když cyklus doběhl bez `break`**:

```python
hledane = 7
for x in [1, 3, 5]:
    if x == hledane:
        print("nalezeno")
        break
else:
    print("nenalezeno")   # ← vypíše tohle, break nenastal
```

Čti to jako „**for…else = nenašel jsem**". Alternativa bez něj je pomocná proměnná `nalezeno = False`, což je delší.

**Past:** `break` opustí **jen nejvnitřnější** cyklus. U vnořených cyklů z toho ven dostaneš buď příznakem, nebo `return` z funkce (nejčistší).

#### Vlastní funkce

```python
def obsah_obdelniku(a: float, b: float) -> float:
    """Vrací obsah obdélníku o stranách a, b."""
    return a * b

print(obsah_obdelniku(3, 4))     # 12
```

**Poziční vs. pojmenované parametry:**

```python
def pozdrav(jmeno, osloveni="Dobrý den", vykricnik=False):
    znak = "!" if vykricnik else "."
    return f"{osloveni}, {jmeno}{znak}"

pozdrav("Anno")                              # 'Dobrý den, Anno.'
pozdrav("Anno", "Ahoj")                      # 'Ahoj, Anno.'          — poziční
pozdrav("Anno", vykricnik=True)              # 'Dobrý den, Anno!'     — pojmenovaný
pozdrav(jmeno="Anno", osloveni="Čau")        # 'Čau, Anno.'
```

**Pravidlo:** parametry s výchozí hodnotou musí být **až za** těmi bez ní. `def f(a=1, b)` je `SyntaxError`.

**Funkce bez `return` vrací `None`** — nejčastější chyba v těchhle úlohách:

```python
def secti(a, b):
    vysledek = a + b       # spočítá, ale nevrátí!

x = secti(2, 3)
print(x)                   # None
print(x + 1)               # TypeError: unsupported operand type(s)
```

**`return` ukončí funkci okamžitě**, včetně cyklu — dá se toho využít:

```python
def obsahuje_zaporne(cisla):
    for x in cisla:
        if x < 0:
            return True      # hned ven, zbytek se neprochází
    return False             # doběhlo bez nálezu

print(obsahuje_zaporne([1, -2, 3]))   # True
print(obsahuje_zaporne([1, 2, 3]))    # False
```

Funkce může vrátit **víc hodnot** (technicky n-tici):

```python
def min_max(cisla):
    return min(cisla), max(cisla)

nejmensi, nejvetsi = min_max([3, 1, 4])
print(nejmensi, nejvetsi)      # 1 4
```

**Anotace typů a docstring** píš vždycky — u obhajoby to vypadá dobře a zadání je má ve vzorovém kódu:

```python
def spocitej(text: str, znak: str = "a") -> int:
    """
    Vrací počet výskytů znaku v textu.

    Vyhazuje ValueError, je-li text prázdný.
    """
```

#### Výjimky

```python
def odmocnina(x):
    if not isinstance(x, (int, float)) or isinstance(x, bool):
        raise TypeError(f"očekávám číslo, dostal jsem {type(x).__name__}")
    if x < 0:
        raise ValueError(f"nelze odmocnit záporné číslo: {x}")
    return math.sqrt(x)

odmocnina(-4)      # ValueError: nelze odmocnit záporné číslo: -4
odmocnina("a")     # TypeError: očekávám číslo, dostal jsem str
```

**Kterou výjimku zvolit:** `ValueError` = správný typ, špatná hodnota (záporné, prázdné, mimo rozsah). `TypeError` = špatný typ úplně. `ZeroDivisionError`, `IndexError`, `KeyError` vyhazuje Python sám.

**Odchycení:**

```python
try:
    cislo = int(input("Zadej číslo: "))
except ValueError:
    print("To nebylo číslo!")
```

Chytej **konkrétní** výjimku. Holý `except:` spolkne i překlep ve jméně proměnné a hledá se to pak strašně:

```python
# ŠPATNĚ
try:
    vysledek = vypocet()
except:              # spolkne úplně všechno včetně tvých chyb
    print("něco se pokazilo")

# SPRÁVNĚ
try:
    vysledek = vypocet()
except (ValueError, TypeError) as e:
    print(f"chyba vstupu: {e}")
```

**Kdy výjimka a kdy návratová hodnota?** (častá doptávka) — výjimku, když je to **chybový stav**, který volající nečeká a nemá pokračovat. Návratovou hodnotu (`None`, `False`), když je to **legitimní výsledek**. Např. „hledaný prvek nenalezen" je běžný stav → vrať `None`. „Odmocnina ze záporného čísla" je chyba → výjimka.

#### f-stringy a formátování

```python
jmeno, cena, podil = "šroubek", 12.3456, 0.07

f"{jmeno}: {cena} Kč"        # 'šroubek: 12.3456 Kč'
f"{cena:.2f}"                # '12.35'    — dvě desetinná místa
f"{cena:.0f}"                # '12'       — zaokrouhlí
f"{podil:.1%}"               # '7.0%'     — procenta
f"{cena:>10.2f}|"            # '     12.35|'  — zarovnat vpravo na 10 znaků
f"{jmeno:<10}|"              # 'šroubek   |'  — vlevo
f"{jmeno:^11}|"              # '  šroubek  |' — na střed
f"{1234567:,}"               # '1,234,567'    — oddělovač tisíců
f"{255:b}"                   # '11111111'     — binárně
f"{jmeno=}, {cena=}"         # "jmeno='šroubek', cena=12.3456"  ← ladění
```

Ten poslední tvar používej při ladění — vypíše jméno i hodnotu, ušetří psaní a u obhajoby ukazuje, že umíš ladit.

Uvnitř f-stringu smí být i výraz: `f"{a + b}"`, `f"{len(text)}"`, `f"{'ano' if x else 'ne'}"`.

#### Vstup a výstup na konzoli

```python
print("a", "b")              # a b        — mezera mezi argumenty
print("a", "b", sep="-")     # a-b
print("a", end="")           # bez odřádkování
print()                      # prázdný řádek
```

**`input()` vrací vždy řetězec** — tohle je nejčastější chyba:

```python
vek = input("Věk: ")         # uživatel napíše 25
print(vek + 1)               # TypeError: can only concatenate str
print(int(vek) + 1)          # 26  ← musíš přetypovat
```

Bezpečné načtení čísla v cyklu:

```python
while True:
    try:
        cislo = int(input("Zadej celé číslo: "))
        break
    except ValueError:
        print("To nebylo celé číslo, zkus to znovu.")
```

**U zkoušky v Jupyteru `input()` raději nepoužívej** — blokuje buňku a při `Restart & Run All` se to zasekne. Napiš funkci s parametrem a zavolej ji s konkrétní hodnotou; `input()` maximálně zmiň jako obálku.

#### `math` a `random`

```python
import math

math.sqrt(16)        # 4.0        — vždy float
math.floor(2.7)      # 2          — dolů
math.floor(-2.5)     # -3         ← pozor, dolů = k mínus nekonečnu
math.ceil(2.1)       # 3          — nahoru
math.pi              # 3.141592653589793
math.inf             # nekonečno — hodí se jako počáteční minimum
abs(-5)              # 5          — vestavěná, není v math
round(2.675, 2)      # 2.67       ← ne 2.68! float nepřesnost
```

`round()` navíc zaokrouhluje **na sudou** při přesné polovině: `round(0.5)` je `0`, `round(1.5)` je `2`. U zkoušky to nejspíš nepotřebuješ, ale je to dobrá doptávka.

```python
import random

random.seed(42)              # reprodukovatelnost — u zkoušky se hodí
random.randint(1, 6)         # celé číslo 1–6 VČETNĚ obou
random.random()              # float z [0, 1)
random.choice(["a", "b"])    # náhodný prvek
random.uniform(1.5, 3.5)     # float z rozsahu
```

**Rozdíl oproti `range`:** `randint(1, 6)` zahrnuje obě meze, `range(1, 6)` je 1–5. Snadná záměna.

---

### Katalog typických chyb

<!-- Tohle je jádro přípravy. Zkoušková úloha je rozpoznávací, ne tvůrčí. -->

Když dostaneš cizí kód, projdi ho tímhle seznamem místo hádání. **Prvních pět je přímo z ukázkové úlohy nebo její blízké variace.**

| # | Vzor chyby | Jak vypadá | Proč selže |
|---|---|---|---|
| 1 | **Test na špatné proměnné** | `for c in text: if text == "("` | Porovnává celý řetězec místo znaku — vždy `False`, cyklus nic neudělá |
| 2 | **Chybí `self` / špatná signatura** | `def __init__(color):` | Spíš okruh 3, ale objevuje se |
| 3 | **Chybějící `return`** | funkce spočítá a nic nevrátí | Volající dostane `None`, pak `TypeError` při dalším použití |
| 4 | **Slabá podmínka na konci** | `return pocet == 0` u závorek | Nezachytí `")("` — počet sedí, **pořadí ne** |
| 5 | **Neošetřený prázdný vstup** | `text[0]` bez kontroly `if not text` | `IndexError`; zadání navíc explicitně chce kontrolu vstupní podmínky |
| 6 | **Nekonečný `while`** | řídicí proměnná se uvnitř nemění | Zacyklí se; v Jupyteru musíš zabít kernel |
| 7 | **Špatné pořadí `elif`** | širší podmínka před užší | Užší větev je **nedosažitelná** — kód běží, počítá špatně |
| 8 | **Off-by-one v `range`** | `range(1, len(s))`, `range(len(s)-1)` | `stop` je výlučný — přeskočí první nebo utne poslední |
| 9 | **`input()` bez přetypování** | `vek = input(); vek + 1` | `input` vrací `str` → `TypeError` |
| 10 | **Mutable default argument** | `def f(x, akum=[])` | Seznam se vytvoří **jednou při definici** a přežije mezi voláními |
| 11 | **Porovnání `float` na rovnost** | `if 0.1 + 0.2 == 0.3` | `False` — je to `0.30000000000000004`. `math.isclose()` |
| 12 | **`isinstance(True, int)`** | kontrola typu čísla propustí `bool` | `bool` dědí z `int`; ošetři zvlášť |
| 13 | **Dělení nulou** | `soucet / pocet` bez kontroly | `ZeroDivisionError` u prázdného vstupu |
| 14 | **`=` místo `==`** | `if x = 5:` | `SyntaxError` — v Pythonu naštěstí nespustitelné |
| 15 | **Zaměněné `/` a `//`** | `pocet = celkem / 2` když se čeká celé | Vrátí `float` (`2.5`), pak selže indexování |
| 16 | **Holý `except:`** | `except:` bez typu | Spolkne i tvoje překlepy, ladění je pak peklo |
| 17 | **Špatné odsazení** | `return` uvnitř cyklu místo za ním | Funkce skončí po první iteraci — běží, výsledek špatný |
| 18 | **Proměnná mimo rozsah** | `for i in …:` a použití `i` po cyklu | Funguje, ale drží poslední hodnotu — často nechtěné |
| 19 | **`break` z vnořeného cyklu** | čeká se opuštění obou | `break` opustí **jen nejvnitřnější** |
| 20 | **Řetězec se snaží měnit** | `text[0] = "A"` | `TypeError` — `str` je neměnitelný |

**Syntaktické chyby** (kód nespustíš) najdeš tak, že ho **prostě spustíš** — Python ti řekne řádek. Patří sem chybějící dvojtečka, špatné odsazení, neuzavřená závorka, `=` místo `==`.

**Sémantické chyby** (kód běží, dělá blbost) najdeš jen tak, že **porovnáš, co kód dělá, s tím, co slibuje docstring nebo komentář**. Proto docstring vždy přečti dřív než kód — je to zadání.

---

### Rozbor ukázkové úlohy z PDF

Zadání:

```python
def test_of_parantheses(text: str) -> bool:
    """
       Testuje, zda jsou kulaté závorky správně uzávorkované.
      Příklad chybného uzávorkování: ")(())("
    """
    para_count = 0
    for c in text:
        if text == "(":
            para_count += 1
        elif text == ")":
            para_count -= 1
    return para_count == 0
```

Rozšíření podle PDF: dodatečný **poziční parametr typu n-tice** s dvojicí znaků (otevírací, uzavírací), **testování vstupní podmínky** (neprázdný řetězec), a funkce vracející **maximální úroveň zanoření** (při špatném uzávorkování `ValueError`).

#### Co je špatně — tři chyby

1. **`if text == "("` porovnává celý řetězec, ne znak.** Má být `if c == "("`. Cyklus proto neudělá **vůbec nic** a funkce vrací `True` pro jakýkoli vstup.
2. **`return para_count == 0` je slabá podmínka.** I po opravě chyby 1 vrátí pro `")("` hodnotu `True` — jednou dolů, jednou nahoru, součet je 0. Přitom **PDF samo uvádí `")(("` jako příklad chybného uzávorkování**. Musí se hlídat, že počítadlo **nikdy neklesne pod nulu**.
3. **Neošetřený prázdný vstup.** `""` vrátí `True`, což je sporné — a zadání navíc v rozšíření explicitně chce kontrolu vstupní podmínky.

Ani jedna chyba není syntaktická — kód se spustí a doběhne bez chybové hlášky. Chyba 1 je navíc zákeřná v tom, že **funkce vrací pořád `True`**, takže na „hezkých" testech jako `"(())"` vypadá správně.

**Tohle je nejdůležitější postřeh z celé úlohy:** naivní oprava (jen `c` místo `text`) projde na `"(())"` i `"()()"` a **pořád je špatně**. Vždycky testuj na vstupu, kde se správné a špatné řešení rozcházejí — tady je to `")("`.

#### Opravená verze

```python
def test_of_parantheses(text: str) -> bool:
    """Testuje, zda jsou kulaté závorky správně uzávorkované."""
    para_count = 0
    for c in text:
        if c == "(":                 # oprava 1: znak, ne celý řetězec
            para_count += 1
        elif c == ")":
            para_count -= 1
            if para_count < 0:       # oprava 2: zavírá dřív, než se otevřelo
                return False
    return para_count == 0
```

Ověření v hlavě:

| vstup | průběh počítadla | výsledek |
|---|---|---|
| `"(())"` | 1, 2, 1, 0 | `True` |
| `"()()"` | 1, 0, 1, 0 | `True` |
| `")("` | −1 → **hned `False`** | `False` |
| `"((("` | 1, 2, 3 → nekončí nulou | `False` |

#### Rozšíření podle zadání

```python
def test_of_parentheses(text: str, zavorky: tuple = ("(", ")")) -> bool:
    """
    Testuje, zda jsou závorky v textu správně uzávorkované.

    text     — neprázdný řetězec k otestování
    zavorky  — dvojice (otevírací, uzavírací) znak

    Vyhazuje ValueError, je-li text prázdný nebo dvojice neplatná.
    """
    if not isinstance(text, str):
        raise TypeError(f"očekávám řetězec, dostal jsem {type(text).__name__}")
    if not text:
        raise ValueError("vstupní řetězec musí být neprázdný")
    if len(zavorky) != 2 or zavorky[0] == zavorky[1]:
        raise ValueError(f"očekávám dvojici různých znaků, dostal jsem {zavorky!r}")

    otevirac, zavirac = zavorky        # rozbalení n-tice
    pocet = 0
    for znak in text:
        if znak == otevirac:
            pocet += 1
        elif znak == zavirac:
            pocet -= 1
            if pocet < 0:
                return False
    return pocet == 0


def max_zanoreni(text: str, zavorky: tuple = ("(", ")")) -> int:
    """
    Vrací maximální úroveň zanoření závorek.

    Vyhazuje ValueError, nejsou-li závorky správně uzávorkované.
    """
    if not test_of_parentheses(text, zavorky):
        raise ValueError(f"závorky v {text!r} nejsou správně uzávorkované")

    otevirac, zavirac = zavorky
    pocet = maximum = 0
    for znak in text:
        if znak == otevirac:
            pocet += 1
            maximum = max(maximum, pocet)    # zaznamenat vrchol
        elif znak == zavirac:
            pocet -= 1
    return maximum
```

Ověření: `max_zanoreni("((()))")` — počítadlo jde 1, 2, 3, pak dolů → `3`. `max_zanoreni("()()")` — jde 1, 0, 1, 0 → `1`. Sedí.

**Proč `max_zanoreni` volá `test_of_parentheses` a nekontroluje si to samo:** zadání říká, že při špatném uzávorkování má vyhodit `ValueError`, a kontrola už je hotová. Neduplikovat logiku je věc, kterou u obhajoby oceníte — a když se zeptají, řekni přesně tohle.

**Proč `zavorky` jako n-tice a ne dva parametry:** zadání to explicitně chce („dodatečný poziční parametr typu n-tice"). Rozbalení `otevirac, zavirac = zavorky` je pak jednořádkové.

---

### Postup u zkoušky (60 min přípravy)

<!-- Časový rozpočet. Drž se ho, ať nezůstaneš viset na opravě a nestihneš rozšíření. -->

**0–10 min — pochopit a spustit**
1. Přečíst **docstring a komentáře dřív než kód** — je to zadání, kód je podezřelý.
2. Kód **spustit tak, jak je**. Zapsat si přesnou chybovou hlášku nebo výstup. Bez toho nemáš co obhajovat.
3. Vypsat si na papír: co má kód dělat / co dělá / kde se to rozchází.

**10–25 min — oprava**

4. Projít [katalog chyb](#katalog-typických-chyb) shora.
5. Opravovat **po jedné chybě a po každé spustit**. Nikdy tři naráz — nebudeš vědět, která pomohla.
6. **Otestovat na vstupu, kde se správné a špatné řešení rozcházejí** — ne na tom, který v zadání „vypadá dobře". U závorek je to `")("`, ne `"(())"`.

**25–50 min — rozšíření**

7. Rozšíření dělej **jako novou funkci, ne přepisem opravené.** Chceš u obhajoby ukázat obojí.
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
| 1 | 8 | sémantická | `if text == "("` porovnává řetězec místo znaku | `if c == "("` |
| 2 | 13 | sémantická | `pocet == 0` neodhalí ")(" — sedí počet, ne pořadí | test `pocet < 0` uvnitř |

### Co funguje
- Oprava: "(())" a "()()" vrací True, ")(" a "(((" vrací False — ověřeno ručně.
- Rozšíření: vlastní dvojice závorek ("[", "]") funguje shodně.
- max_zanoreni("((()))") vrací 3, "()()" vrací 1.
- Prázdný vstup vyhodí ValueError podle zadání.

### Co nefunguje / omezení
- Nepodporuje víc typů závorek najednou — na to by byl potřeba zásobník.
- Znaky mimo zadanou dvojici se ignorují, což je zamýšlené ("a(b)c" je True).

### Jak jsem testoval
- Krátké řetězce s ručně ověřeným výsledkem.
- Hraniční: prázdný vstup, jediná závorka, správný počet ve špatném pořadí.
```

**Hraniční případy zmiň vždycky** — prázdný vstup, jeden znak, špatný typ. To je nejlevnější způsob, jak u obhajoby vypadat, že víš, co děláš.

---

### Co si nacvičit

Úlohy jsou ve složce [`Kod/`](./Kod/):

- **00 — ukázková úloha** ([notebook](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/01-programovani-funkce-a-cykly/Kod/00-ukazkova-uloha.ipynb) · [číst na webu](./Kod/00-ukazkova-uloha.md)) — oficiální úloha z PDF s celým rozborem
- **01 — cvičení, zadání** ([notebook](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/01-programovani-funkce-a-cykly/Kod/01-cviceni-zadani.ipynb) · [číst na webu](./Kod/01-cviceni-zadani.md)) — šest úloh, prázdné buňky na řešení
- **02 — cvičení, řešení** ([notebook](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/01-programovani-funkce-a-cykly/Kod/02-cviceni-reseni.ipynb) · [číst na webu](./Kod/02-cviceni-reseni.md)) — řešení, výsledky ladění a doptávky

Na webu jsou notebooky vidět i s výstupy (spouští se při buildu). **Trénuj ale v Jupyteru, ne na webu** — čtení kódu vytváří pocit znalosti bez znalosti.

- [ ] Ukázková úloha z PDF celá, včetně rozšíření, na časovku 60 minut
- [ ] Cvičná úloha 1 — chybějící `return`
- [ ] Cvičná úloha 2 — nekonečný `while`
- [ ] Cvičná úloha 3 — pořadí `elif`
- [ ] Cvičná úloha 4 — off-by-one v `range`
- [ ] Cvičná úloha 5 — mutable default argument
- [ ] Cvičná úloha 6 — dělení nulou a `float` porovnání
- [ ] Vyhození a odchycení vlastní výjimky s rozumnou zprávou
- [ ] Poziční vs. pojmenované parametry, výchozí hodnoty — napsat bez přemýšlení
- [ ] Typové anotace a docstring — psát automaticky ke každé funkci

---

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

---

### Na co se doptají

- **Proč je právě tohle sémantická chyba a ne syntaktická?** — Syntaktická znamená, že se kód **vůbec nespustí** (Python ohlásí `SyntaxError`). Sémantická se spustí a doběhne, ale dělá něco jiného, než slibuje docstring. Tahle úloha obsahuje jen sémantické — proto se musí testovat, ne jen číst.
- **Co se stane při prázdném vstupu? Ošetřil jsi to?** — Původní kód vrátí `True` (cyklus neproběhne, počítadlo zůstane 0). Zadání explicitně chce kontrolu vstupní podmínky, takže vyhazuju `ValueError`.
- **Kdy použít výjimku a kdy vrátit `None` nebo `False`?** — Výjimku, když je to **chybový stav**, se kterým volající nepočítá. Návratovou hodnotu, když je to **legitimní výsledek** — „nenalezeno" je běžný stav, „záporná délka" je chyba.
- **Jaký je rozdíl mezi `is` a `==`?** — `is` porovnává **identitu** (tentýž objekt v paměti), `==` **hodnotu**. Pro `None` se vždy používá `is None`.
- **Proč `while` a ne `for`?** — `for` když znáš počet iterací nebo procházíš kolekci, `while` když čekáš na splnění podmínky. `while` s neměnící se řídicí proměnnou je nekonečný.
- **Co dělá `for…else`?** — `else` se provede, **jen když cyklus doběhl bez `break`**. Idiom pro „nenašel jsem".
- **Co vrací funkce bez `return`?** — `None`. Proto `x = funkce()` a pak `x + 1` spadne na `TypeError`.
- **Proč se výchozí hodnota parametru nesmí být seznam?** — Vytvoří se **jednou při definici funkce**, ne při každém volání, a přežívá mezi voláními. Správně je `None` a uvnitř `if akum is None: akum = []`.
- **Můžou být pojmenované parametry před pozičními?** — V definici ne (`SyntaxError`). Při volání ano: `f(b=2, a=1)` funguje.
- **Proč `0.1 + 0.2 != 0.3`?** — Binární plovoucí řádová čárka neumí přesně vyjádřit desetinné zlomky. Porovnávej `math.isclose()`.
- **Jaká je složitost vaší funkce?** — $O(n)$, projde řetězec jednou. Paměť $O(1)$ — drží jen počítadlo. (Kdyby se řešilo víc typů závorek, potřebuješ zásobník → paměť $O(n)$.)
- **Jak byste rozšířil řešení na víc typů závorek?** — Zásobník: při otevírací znak vlož, při zavírací zkontroluj, že na vrcholu je odpovídající otevírací, a odeber. Souvisí s [SZZTP okruh 1](../../SZZTP/01-abstraktni-kolekce/).

---

### Užitečné odkazy

- Řízení toku programu: <https://docs.python.org/3/tutorial/controlflow.html>
- Výjimky: <https://docs.python.org/3/tutorial/errors.html>
- Kolekce prakticky: [okruh 2](../02-programovani-kolekce/)
- Zásobník a fronta teoreticky: [SZZTP okruh 1](../../SZZTP/01-abstraktni-kolekce/)
