## 3 — Programování: základy OOP

- [Zadání okruhu (PDF)](../ZadaniOkruhu/APR-I-II-3okruhy.pdf)

> Opravit chybnou definici třídy a rozšířit ji podle zadání. 60 minut u počítače (Jupyter, tahák Python, bez internetu), pak 20 minut obhajoby — v úvodu představíš řešení, následuje diskuse a ověřování souvisejících znalostí.

**Tohle není zkouška ze znalostí, ale z rutiny.** Zadání zní „najděte syntaktické i sémantické chyby" — což není otevřený problém, ale **rozpoznávací úloha z uzavřené množiny vzorů**. Proto je jádro téhle přípravy [katalog typických chyb](#katalog-typických-chyb) níž, ne přehled teorie OOP. Kód piš, nečti ho: úlohy jsou ve složce [`Kod/`](./Kod/).

**Ze tří programovacích okruhů je tenhle nejvíc „na vzorce".** Speciální metody (`__str__`, `__eq__`, `__iter__`) se nedají odvodit — buď je umíš napsat zpaměti, nebo ne. Zato je jich málo a jsou pořád stejné. Základy (literály, cykly, výjimky) sdílí s [okruhem 1](../01-programovani-funkce-a-cykly/) a [okruhem 2](../02-programovani-kolekce/).

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn na jedno místo, pak výklad s příklady. -->

#### Souhrn na jednom místě

Všechno, co PDF vyžaduje, v jedné tabulce — na rychlé opakování před zkouškou. Podrobný výklad s příklady je pod ní.

| Co | K čemu / jak se chová | Zapamatuj si | Kde |
|---|---|---|---|
| `class` | předpis pro objekty | název **velkým** písmenem (`Semaphore`, ne `semaphore`) | [↓](#třída-a-instance) |
| instance | konkrétní objekt `s = Semaphore("red")` | tříd je jedna, instancí libovolně mnoho | [↓](#třída-a-instance) |
| `self` | odkaz na **konkrétní instanci** | **první parametr každé metody**; při volání se předá sám | [↓](#self--nejčastější-zdroj-chyb) |
| `__init__` | konstruktor, volá se při vytvoření | **nic nevrací** (`return` jen holý); validace patří sem | [↓](#konstruktor-__init__) |
| atribut instance | `self.color = color` | **každá instance má vlastní** | [↓](#atribut-třídy-vs-atribut-instance) |
| atribut třídy | `colors = [...]` přímo v těle třídy | **sdílený všemi**; uvnitř metody přes `self.colors` nebo `Semaphore.colors` | [↓](#atribut-třídy-vs-atribut-instance) |
| `__str__` | „hezký" text pro člověka | volá ho `print()` a `str()` | [↓](#__str__-a-__repr__) |
| `__repr__` | jednoznačný text pro programátora | volá ho konzole a výpis v seznamu; **fallback pro `__str__`** | [↓](#__str__-a-__repr__) |
| `__eq__` | co znamená `==` | bez něj se porovnává **identita**; vrať `NotImplemented` u cizího typu | [↓](#__eq__-a-__hash__) |
| `__hash__` | umožní vložit do `set` / klíč `dict` | **definice `__eq__` ho vypne** — musíš dodat ručně | [↓](#__eq__-a-__hash__) |
| `__contains__` | co znamená `in` | `x in objekt` | [↓](#__contains__-a-__len__) |
| `__len__` | co znamená `len()` | musí vracet **nezáporné celé číslo** | [↓](#__contains__-a-__len__) |
| `@property` | metoda, která se čte **jako atribut** | volá se **bez závorek**: `s.stop`, ne `s.stop()` | [↓](#property) |
| setter | `@nazev.setter` | validace při zápisu; bez něj je vlastnost **jen ke čtení** | [↓](#property) |
| `__iter__` | vrací **iterátor** | u vlastního iterátoru `return self` | [↓](#iterátor) |
| `__next__` | vrací další prvek | na konci **musí** vyhodit `StopIteration` | [↓](#iterátor) |
| generátor | funkce s `yield` | zkratka za celý iterátor — kratší a bez `StopIteration` | [↓](#iterátor) |
| `raise` | vyvolání výjimky | `ValueError` = špatná hodnota, `TypeError` = špatný typ | [↓](#výjimky-v-konstruktoru) |

**Tři věci z téhle tabulky pokrývají většinu chyb ve zkouškových úlohách:** chybějící `self`, přístup k atributu třídy bez `self.`, a `__eq__` bez `__hash__`.

#### Třída a instance

**Třída** je předpis, **instance** je konkrétní objekt podle něj:

```python
class Pes:
    def __init__(self, jmeno):
        self.jmeno = jmeno

rex = Pes("Rex")        # instance
alik = Pes("Alík")      # jiná instance
print(rex.jmeno, alik.jmeno)    # Rex Alík
print(type(rex))                # <class '__main__.Pes'>
print(isinstance(rex, Pes))     # True
```

Jedna třída, libovolně mnoho instancí — každá má **vlastní** atributy.

#### `self` — nejčastější zdroj chyb

`self` je odkaz na **tu konkrétní instanci**, na které metodu voláš. Je to **první parametr každé metody** a Python ho předá sám:

```python
class Pes:
    def __init__(self, jmeno):
        self.jmeno = jmeno

    def stekej(self):           # self MUSÍ být
        return f"{self.jmeno}: haf!"

rex = Pes("Rex")
print(rex.stekej())             # 'Rex: haf!'
print(Pes.stekej(rex))          # totéž — tohle se doopravdy děje na pozadí
```

Poslední řádek je klíč k pochopení: `rex.stekej()` je jen zkratka za `Pes.stekej(rex)`. **Proto tam `self` musí být** — jinak nemá instance kam přijít.

Když ho vynecháš:

```python
class Spatne:
    def metoda():               # chybí self
        return "ahoj"

Spatne().metoda()
# TypeError: Spatne.metoda() takes 0 positional arguments but 1 was given
```

Hlášku „takes 0 positional arguments but 1 was given" čti jako **„chybí ti `self`"** — je to nejčastější chybová hláška v tomhle okruhu.

**Zákeřnější varianta:** `self` tam je, ale jmenuje se jinak. Python nekontroluje jméno, jen pozici:

```python
class Semafor:
    def __init__(color):        # 'color' je ve skutečnosti self!
        color.color = "?"       # projde, ale je to nesmysl

s = Semafor()                   # funguje — ale bez parametru
print(s.color)                  # '?'
```

Kód **běží** a je úplně špatně. Proto se `self` píše vždycky `self` — je to konvence, ne pravidlo jazyka.

#### Konstruktor `__init__`

Volá se automaticky při vytvoření instance. Patří do něj **nastavení atributů a validace**:

```python
class Obdelnik:
    def __init__(self, a, b):
        if a <= 0 or b <= 0:
            raise ValueError(f"strany musí být kladné, dostal jsem {a}, {b}")
        self.a = a
        self.b = b

o = Obdelnik(3, 4)
print(o.a * o.b)         # 12
Obdelnik(-1, 4)          # ValueError: strany musí být kladné, dostal jsem -1, 4
```

**`__init__` nic nevrací.** `return self` nebo `return hodnota` je chyba (`TypeError`). Holý `return` na předčasné ukončení je v pořádku.

Výchozí hodnoty parametrů fungují jako u běžné funkce:

```python
class Bod:
    def __init__(self, x=0, y=0):
        self.x, self.y = x, y

print(Bod().x, Bod(3, 4).y)     # 0 4
```

#### Atribut třídy vs. atribut instance

**Zásadní rozdíl, na který se ptají skoro vždy:**

```python
class Pes:
    druh = "pes domácí"          # atribut TŘÍDY — sdílený všemi

    def __init__(self, jmeno):
        self.jmeno = jmeno       # atribut INSTANCE — každý má vlastní

rex = Pes("Rex")
alik = Pes("Alík")

print(rex.jmeno, alik.jmeno)     # Rex Alík        — různé
print(rex.druh, alik.druh)       # pes domácí pes domácí  — stejné

Pes.druh = "vlčák"               # změna pro VŠECHNY
print(rex.druh, alik.druh)       # vlčák vlčák
```

**Uvnitř metody se k atributu třídy musí přes `self.` nebo přes jméno třídy:**

```python
class Semafor:
    barvy = ["red", "yellow", "green"]

    def spatne(self):
        return barvy             # NameError: name 'barvy' is not defined

    def spravne(self):
        return self.barvy        # OK — najde ho přes instanci

    def taky_spravne(self):
        return Semafor.barvy     # OK — explicitně přes třídu
```

**Holý `barvy` uvnitř metody je `NameError`** — na rozdíl od jiných jazyků Python tělo třídy jako jmenný prostor metod nepoužívá. Tohle je v ukázkové úloze.

**Past s měnitelným atributem třídy** (obdoba mutable default argumentu):

```python
class Kosik:
    polozky = []                 # ŠPATNĚ — sdílený seznam!
    def pridej(self, x):
        self.polozky.append(x)

a, b = Kosik(), Kosik()
a.pridej("chleba")
print(b.polozky)                 # ['chleba']  ← prosáklo do druhé instance!

class Kosik2:
    def __init__(self):
        self.polozky = []        # SPRÁVNĚ — každá instance má vlastní
```

#### `__str__` a `__repr__`

Obě vrací **řetězec**, ale pro jiné publikum:

```python
class Bod:
    def __init__(self, x, y):
        self.x, self.y = x, y

    def __str__(self):
        return f"({self.x}, {self.y})"           # pro člověka

    def __repr__(self):
        return f"Bod({self.x}, {self.y})"        # pro programátora

b = Bod(1, 2)
print(b)          # (1, 2)          ← print volá __str__
print(str(b))     # (1, 2)
print(repr(b))    # Bod(1, 2)
print([b, b])     # [Bod(1, 2), Bod(1, 2)]   ← v seznamu se volá __repr__!
```

**Ten poslední řádek je oblíbená doptávka.** Když objekt vypíšeš uvnitř kolekce, Python použije `__repr__`, ne `__str__`. Proto je dobrý zvyk psát `__repr__` vždycky.

**Pravidlo:** `__repr__` má ideálně vypadat jako **kód, kterým objekt vytvoříš** (`Bod(1, 2)`). `__str__` má být čitelný (`(1, 2)`).

**Když definuješ jen `__repr__`, použije se i pro `str()`** — je to fallback. Opačně to neplatí. Proto když píšeš jen jednu, piš `__repr__`.

Bez obou dostaneš `<__main__.Bod object at 0x7f...>`, což je k ničemu.

#### `__eq__` a `__hash__`

Bez `__eq__` porovnává `==` **identitu** (jestli je to tentýž objekt v paměti):

```python
class Bod:
    def __init__(self, x, y):
        self.x, self.y = x, y

print(Bod(1, 2) == Bod(1, 2))    # False!  Dva různé objekty
```

S `__eq__`:

```python
class Bod:
    def __init__(self, x, y):
        self.x, self.y = x, y

    def __eq__(self, other):
        if not isinstance(other, Bod):
            return NotImplemented          # necháme rozhodnout druhou stranu
        return self.x == other.x and self.y == other.y

print(Bod(1, 2) == Bod(1, 2))    # True
print(Bod(1, 2) == "něco")       # False — Python si poradí přes NotImplemented
```

**A teď ta past, na kterou se ptají:**

```python
b = Bod(1, 2)
{b}                # TypeError: unhashable type: 'Bod'
```

**Definice `__eq__` automaticky vypne `__hash__`.** Objekt pak nejde vložit do množiny ani použít jako klíč slovníku. Důvod je logický: dva objekty, které jsou si rovné, musí mít **stejný hash** — a Python neví, jak ho z tvého `__eq__` odvodit, tak ho radši zruší.

Oprava — dodat `__hash__` ze stejných atributů:

```python
class Bod:
    def __init__(self, x, y):
        self.x, self.y = x, y

    def __eq__(self, other):
        if not isinstance(other, Bod):
            return NotImplemented
        return (self.x, self.y) == (other.x, other.y)

    def __hash__(self):
        return hash((self.x, self.y))      # ze stejných atributů jako __eq__

print(len({Bod(1, 2), Bod(1, 2)}))         # 1 — množina je považuje za totéž
```

**Pravidlo:** hash musí být počítaný **ze stejných atributů** jako rovnost, a ty se **nesmí měnit** (jinak se objekt v množině „ztratí").

#### `__contains__` a `__len__`

```python
class Trida:
    def __init__(self, zaci):
        self.zaci = zaci

    def __contains__(self, jmeno):
        return jmeno in self.zaci        # co znamená `in`

    def __len__(self):
        return len(self.zaci)            # co znamená len()

t = Trida(["Anna", "Bob"])
print("Anna" in t)      # True
print("Cyril" in t)     # False
print(len(t))           # 2
if t:                   # bez __bool__ se použije __len__ != 0
    print("třída není prázdná")
```

`__len__` musí vracet **nezáporné celé číslo**, jinak `ValueError`.

#### `@property`

Metoda, která se čte **jako atribut** — bez závorek:

```python
class Obdelnik:
    def __init__(self, a, b):
        self.a, self.b = a, b

    @property
    def obsah(self):
        return self.a * self.b

o = Obdelnik(3, 4)
print(o.obsah)        # 12   ← BEZ závorek!
print(o.obsah())      # TypeError: 'int' object is not callable
```

**Kdy property:** když je to logicky *vlastnost* objektu (obsah, stáří, plná adresa), ne *akce*. Počítá se za běhu, takže je vždy aktuální.

**Setter s validací** — property je jinak jen ke čtení:

```python
class Teplomer:
    def __init__(self, celsia):
        self.celsia = celsia          # projde přes setter!

    @property
    def celsia(self):
        return self._celsia           # podtržítko = "interní"

    @celsia.setter
    def celsia(self, hodnota):
        if hodnota < -273.15:
            raise ValueError(f"pod absolutní nulou: {hodnota}")
        self._celsia = hodnota

    @property
    def fahrenheity(self):
        return self._celsia * 9 / 5 + 32     # jen ke čtení

t = Teplomer(20)
print(t.celsia, t.fahrenheity)    # 20 68.0
t.celsia = 25                     # projde setterem
print(t.fahrenheity)              # 77.0
t.celsia = -300                   # ValueError: pod absolutní nulou: -300
t.fahrenheity = 100               # AttributeError — nemá setter
```

**Všimni si:** i přiřazení v `__init__` projde setterem, takže validace platí i při vytvoření. To je hlavní důvod, proč se property používá.

**Konvence `_celsia`:** jedno podtržítko znamená „interní, nesahej na to". Python to nevynucuje, je to dohoda. Bez něj by se `celsia` volalo dokola a skončilo `RecursionError`.

#### Iterátor

Aby šel objekt použít v `for`, potřebuje `__iter__`. Plná verze s `__next__`:

```python
class Odpocet:
    """Odpočítává od zadaného čísla k nule."""
    def __init__(self, od):
        self.od = od

    def __iter__(self):
        self.aktualni = self.od      # inicializace při začátku iterace
        return self                  # jsem sám sobě iterátorem

    def __next__(self):
        if self.aktualni < 0:
            raise StopIteration      # POVINNÉ — jinak nekonečný cyklus
        hodnota = self.aktualni
        self.aktualni -= 1
        return hodnota

for x in Odpocet(3):
    print(x, end=" ")
# 3 2 1 0
```

**`StopIteration` je povinná** — je to signál „konec", který `for` odchytí. Bez ní se cyklus zacyklí.

**Generátor je zkratka za totéž** — funkce s `yield`, kratší a bez `StopIteration`:

```python
class Odpocet2:
    def __init__(self, od):
        self.od = od

    def __iter__(self):
        aktualni = self.od
        while aktualni >= 0:
            yield aktualni           # yield místo return
            aktualni -= 1

print(list(Odpocet2(3)))    # [3, 2, 1, 0]
```

**Rozdíl, který se hodí u obhajoby:** verze s `return self` má **jeden sdílený stav**, takže dvě souběžné iterace se perou:

```python
o = Odpocet(2)
it1, it2 = iter(o), iter(o)
print(next(it1), next(it2))    # 2 1  ← sdílejí stav, to je špatně

g = Odpocet2(2)
g1, g2 = iter(g), iter(g)
print(next(g1), next(g2))      # 2 2  ← každý má vlastní, správně
```

Generátor je proto **lepší volba**, pokud zadání nechce explicitně `__next__`.

#### Výjimky v konstruktoru

Zadání typicky chce „v konstruktoru zkontrolujte, zda je předaný řetězec platný":

```python
class Semafor:
    BARVY = ["red", "yellow", "green"]

    def __init__(self, barva):
        if not isinstance(barva, str):
            raise TypeError(f"barva musí být řetězec, dostal jsem {type(barva).__name__}")
        if barva not in self.BARVY:
            raise ValueError(f"neplatná barva {barva!r}, povolené: {self.BARVY}")
        self.barva = barva

Semafor("red")        # OK
Semafor("modrá")      # ValueError: neplatná barva 'modrá', povolené: ['red', 'yellow', 'green']
```

**Do chybové hlášky vždy dej, co přišlo a co se čekalo** — u obhajoby to vypadá dobře a při ladění to ušetří čas.

---

### Katalog typických chyb

<!-- Tohle je jádro přípravy. Zkoušková úloha je rozpoznávací, ne tvůrčí. -->

Když dostaneš cizí třídu, projdi ji tímhle seznamem místo hádání. **Prvních pět je přímo z ukázkové úlohy.**

| # | Vzor chyby | Jak vypadá | Proč selže |
|---|---|---|---|
| 1 | **Chybějící `self`** | `def __init__(color):` | `TypeError: takes 0/1 positional arguments but 1/2 were given` |
| 2 | **Špatné odsazení metod** | metody vnořené uvnitř `__init__` | Definují se **lokálně** při každém volání; navenek třída metodu nemá |
| 3 | **Atribut třídy bez `self.`** | `return colors[...]` uvnitř metody | `NameError` — tělo třídy není jmenný prostor metod |
| 4 | **Index mimo rozsah** | `colors[colors.index(x) + 1]` | Na posledním prvku `IndexError`; chybí modulo `% len(colors)` |
| 5 | **Chybí validace v konstruktoru** | `self.color = color` bez kontroly | Vznikne nesmyslná instance, chyba se projeví později |
| 6 | **`__eq__` bez `__hash__`** | definován jen `__eq__` | `TypeError: unhashable type` při vložení do `set` / klíče `dict` |
| 7 | **`__str__` volaný v kolekci** | čeká se `__str__`, přijde `__repr__` | V seznamu se volá `__repr__`; bez něj `<object at 0x...>` |
| 8 | **`property` volaná se závorkami** | `s.stop()` místo `s.stop` | `TypeError: 'bool' object is not callable` |
| 9 | **Rekurze v property** | `return self.celsia` uvnitř getteru `celsia` | `RecursionError` — chybí podtržítko u interního atributu |
| 10 | **Chybí `StopIteration`** | `__next__` bez ukončovací podmínky | Nekonečný cyklus v `for` |
| 11 | **`__iter__` nevrací iterátor** | `__iter__` vrací seznam / nic | `TypeError: iter() returned non-iterator` |
| 12 | **Sdílený stav iterátoru** | `__iter__` vrací `self` bez resetu | Druhá iterace pokračuje od konce první |
| 13 | **Měnitelný atribut třídy** | `polozky = []` v těle třídy | Sdílený **všemi** instancemi — jako mutable default argument |
| 14 | **`__init__` něco vrací** | `return self` | `TypeError: __init__() should return None` |
| 15 | **`__eq__` nekontroluje typ** | `return self.x == other.x` | `AttributeError` při porovnání s cizím typem; vrať `NotImplemented` |
| 16 | **Mutable default argument** | `def __init__(self, x=[])` | Sdílený mezi voláními (viz [okruh 1](../01-programovani-funkce-a-cykly/)) |
| 17 | **Přepsání atributu metodou** | atribut i metoda stejného jména | Pozdější definice tiše vyhraje |
| 18 | **Chybí `return` v metodě** | metoda spočítá a nevrátí | Volající dostane `None` |

**Syntaktické chyby** (kód nespustíš) najdeš tak, že ho **prostě spustíš** — Python ti řekne řádek. Patří sem chybějící dvojtečka, neuzavřená závorka.

**Sémantické chyby** (kód běží, dělá blbost) najdeš jen tak, že **třídu vyzkoušíš** — vytvoříš instanci, zavoláš každou metodu, vypíšeš objekt. U tříd to platí dvojnásob: **špatné odsazení metod projde jako platný kód**.

---

### Rozbor ukázkové úlohy z PDF

Zadání:

```python
class Semaphore:
    colors = ["red", "yellow", "green"]
    def __init__(color:str):
        self.color = color

        def __str__():
            return self.color

        def nextColor():
            """
             vrací semafor s následující barvou v sekvenci přepínání světel
             """
             return Semaphore(colors[colors.index(self.color)+1])
```

Rozšíření podle PDF: **validace** řetězce v konstruktoru, **property `stop`** (zda je nutno zastavit), metoda porovnávající **rovnost** dvou semaforů, a přepínání barev implementované jako **iterátor**.

#### Co je špatně — pět chyb

1. **`def __init__(color: str)` — chybí `self`.** Parametr `color` je ve skutečnosti `self`. `Semaphore("red")` spadne na `TypeError: takes 1 positional argument but 2 were given`.
2. **`__str__` a `nextColor` jsou odsazené uvnitř `__init__`.** Nejsou to metody třídy, ale **lokální funkce**, které se při každém vytvoření instance nadefinují a zahodí. `s.nextColor()` je `AttributeError`.
3. **`def __str__()` a `def nextColor()` — chybí `self`** (i kdyby byly odsazené správně).
4. **`colors[...]` bez `self.`** — uvnitř metody je to `NameError`. Musí být `self.colors` nebo `Semaphore.colors`.
5. **`colors.index(self.color) + 1` přeteče.** Pro `"green"` (index 2) je `colors[3]` → `IndexError`. Semafor se má cyklit zpátky na `"red"` — chybí `% len(colors)`.

**Pozor, tahle třída se definuje bez chyby.** Vnořené funkce jsou syntakticky legální, takže Python nic neohlásí, dokud nezkusíš vytvořit instanci. Sémantických chyb je tu **pět**, syntaktická **žádná** — a to je celá pointa.

**Poznámka k pořadí barev:** `["red", "yellow", "green"]` odpovídá českému semaforu (červená → oranžová → zelená). Po zelené má ale přijít **oranžová a pak červená**, ne rovnou červená. Řešení níž jede prostý kruh podle seznamu ze zadání; kdyby se komise ptala, je to místo, kde nabídnout přesnější model.

#### Opravená verze

```python
class Semaphore:
    colors = ["red", "yellow", "green"]

    def __init__(self, color: str):          # oprava 1: self
        self.color = color

    def __str__(self):                       # oprava 2 + 3: odsazení a self
        return self.color

    def nextColor(self):
        """Vrací semafor s následující barvou v sekvenci přepínání světel."""
        i = self.colors.index(self.color)    # oprava 4: self.colors
        return Semaphore(self.colors[(i + 1) % len(self.colors)])   # oprava 5: modulo
```

Ověření: `Semaphore("green").nextColor()` — index 2, `(2+1) % 3 = 0` → `"red"`. Cyklí se správně.

#### Rozšíření podle zadání

```python
class Semaphore:
    """Semafor se třemi barvami a cyklickým přepínáním."""

    colors = ["red", "yellow", "green"]

    def __init__(self, color: str = "red"):
        if not isinstance(color, str):
            raise TypeError(f"barva musí být řetězec, dostal jsem {type(color).__name__}")
        if color not in self.colors:
            raise ValueError(f"neplatná barva {color!r}, povolené: {self.colors}")
        self.color = color

    # --- textová reprezentace ---
    def __str__(self):
        return self.color

    def __repr__(self):
        return f"Semaphore({self.color!r})"

    # --- property: musím zastavit? ---
    @property
    def stop(self) -> bool:
        """True, pokud je při této barvě nutno zastavit."""
        return self.color in ("red", "yellow")

    # --- rovnost ---
    def __eq__(self, other):
        if not isinstance(other, Semaphore):
            return NotImplemented
        return self.color == other.color

    def __hash__(self):
        return hash(self.color)          # nutné, jinak __eq__ vypne hashování

    # --- přepínání ---
    def nextColor(self):
        """Vrací NOVÝ semafor s následující barvou."""
        i = self.colors.index(self.color)
        return Semaphore(self.colors[(i + 1) % len(self.colors)])

    # --- iterátor: nekonečné cyklení barvami ---
    def __iter__(self):
        aktualni = self
        while True:
            yield aktualni
            aktualni = aktualni.nextColor()
```

Ověření v hlavě:

| výraz | výsledek | proč |
|---|---|---|
| `str(Semaphore("red"))` | `'red'` | `__str__` |
| `Semaphore("red") == Semaphore("red")` | `True` | `__eq__` porovná barvu |
| `Semaphore("red").stop` | `True` | červená → stát |
| `Semaphore("green").stop` | `False` | zelená → jet |
| `Semaphore("green").nextColor()` | `Semaphore('red')` | `(2+1) % 3 = 0` |
| `len({Semaphore("red"), Semaphore("red")})` | `1` | `__hash__` je dodán |

**Proč je iterátor nekonečný:** semafor se přepíná pořád dokola, konec nedává smysl. Použije se s `itertools.islice` nebo `break`:

```python
import itertools
for s in itertools.islice(Semaphore("red"), 5):
    print(s, end=" ")
# red yellow green red yellow
```

**Proč generátor a ne `__next__`:** generátor drží stav sám, takže dvě souběžné iterace se neperou. Kdyby zadání chtělo explicitně `__next__`, je varianta v [notebooku s řešením](./Kod/02-cviceni-reseni.md).

**Proč `nextColor` vrací nový objekt a nemění `self`:** docstring ze zadání říká „**vrací semafor** s následující barvou". Neměnný objekt se snáz testuje a nemá vedlejší efekty. U obhajoby zmiň, že varianta měnící `self.color` je taky legitimní — ale pak nesmí nic vracet.

---

### Postup u zkoušky (60 min přípravy)

<!-- Časový rozpočet. Drž se ho, ať nezůstaneš viset na opravě a nestihneš rozšíření. -->

**0–10 min — pochopit a spustit**
1. Přečíst **docstring a komentáře dřív než kód** — je to zadání, kód je podezřelý.
2. **Zkusit vytvořit instanci a zavolat každou metodu.** U tříd nestačí kód spustit — definice projde, i když je uvnitř nesmysl.
3. Zkontrolovat **odsazení** — jsou všechny metody na úrovni třídy, nebo někde vnořené?
4. Zkontrolovat `self` u **každé** metody.

**10–25 min — oprava**

5. Projít [katalog chyb](#katalog-typických-chyb) shora.
6. Opravovat **po jedné chybě a po každé vyzkoušet**. Nikdy tři naráz.
7. Otestovat **hraniční hodnotu** — u cyklení barev vždy tu poslední (`"green"`), tam se pozná chybějící modulo.

**25–50 min — rozšíření**

8. Body ze zadání ber **po jednom a v pořadí, jak jsou napsané** — komise podle nich kontroluje.
9. **Pořadí, které se osvědčí:** validace v konstruktoru → `__str__`/`__repr__` → property → `__eq__` + `__hash__` → iterátor. Od nejjednoduššího po nejsložitější, ať máš co ukázat, i když dojde čas.
10. Ke každému bodu zapiš jeden testovací příklad s očekávaným výsledkem.

**50–60 min — sepsat ladění a zkontrolovat**

11. Vyplnit [šablonu výsledků ladění](#šablona-výsledků-ladění) — je to explicitně požadovaný výstup.
12. Poslední spuštění celého notebooku odshora (`Restart & Run All`).

**Když ti dojde čas:** raději opravená třída + poctivý popis „iterátor jsem nestihl, udělal bych ho takhle" než rozdělaný kód, který nejde spustit.

---

### Šablona výsledků ladění

<!-- Explicitně požadovaný výstup ze zadání. Předpřipravená struktura, u zkoušky se jen doplní. -->

Vlož do notebooku jako markdown buňku pod řešení:

```
## Výsledky ladění

### Nalezené chyby
| # | Řádek | Typ | Popis | Oprava |
|---|-------|-----|-------|--------|
| 1 | 3 | sémantická | __init__ nemá self, parametr color je ve skutečnosti self | přidat self |
| 2 | 6, 9 | sémantická | metody odsazené uvnitř __init__, nejsou to metody třídy | odsadit o úroveň zpět |
| 3 | 12 | sémantická | colors bez self. -> NameError uvnitř metody | self.colors |
| 4 | 12 | sémantická | index+1 přeteče na poslední barvě -> IndexError | % len(self.colors) |

### Co funguje
- Oprava: Semaphore("green").nextColor() vrací Semaphore('red') — cyklení sedí.
- Validace: neplatná barva i nesprávný typ vyhodí výjimku s vysvětlující hláškou.
- property stop: red/yellow -> True, green -> False. Volá se BEZ závorek.
- __eq__ + __hash__: dva semafory stejné barvy jsou si rovné a v množině splynou.
- Iterátor: itertools.islice(Semaphore("red"), 5) dá red yellow green red yellow.

### Co nefunguje / omezení
- Iterátor je nekonečný — bez islice nebo break se cyklus nezastaví. Je to záměr.
- Pořadí barev je prostý kruh podle zadání; reálný semafor jede green -> yellow -> red.
- nextColor vrací NOVÝ objekt, nemění self — plyne z docstringu "vrací semafor".

### Jak jsem testoval
- Vytvořil instanci, zavolal každou metodu, vypsal objekt samostatně i v seznamu.
- Hraniční: poslední barva (green) kvůli přetečení indexu, neplatná barva, špatný typ.
- Ověřil, že objekt jde vložit do množiny (kontrola __hash__).
```

**Hraniční případy zmiň vždycky** — poslední prvek cyklu, neplatný vstup, porovnání s cizím typem.

---

### Co si nacvičit

Úlohy jsou ve složce [`Kod/`](./Kod/):

- **00 — ukázková úloha** ([notebook](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/03-programovani-oop/Kod/00-ukazkova-uloha.ipynb) · [číst na webu](./Kod/00-ukazkova-uloha.md)) — oficiální úloha z PDF s celým rozborem
- **01 — cvičení, zadání** ([notebook](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/03-programovani-oop/Kod/01-cviceni-zadani.ipynb) · [číst na webu](./Kod/01-cviceni-zadani.md)) — šest úloh, prázdné buňky na řešení
- **02 — cvičení, řešení** ([notebook](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/03-programovani-oop/Kod/02-cviceni-reseni.ipynb) · [číst na webu](./Kod/02-cviceni-reseni.md)) — řešení, výsledky ladění a doptávky

Na webu jsou notebooky vidět i s výstupy (spouští se při buildu). **Trénuj ale v Jupyteru, ne na webu** — čtení kódu vytváří pocit znalosti bez znalosti.

- [ ] Ukázková úloha z PDF celá, včetně rozšíření, na časovku 60 minut
- [ ] Cvičná úloha 1 — chybějící `self` a odsazení metod
- [ ] Cvičná úloha 2 — atribut třídy vs. instance
- [ ] Cvičná úloha 3 — `__str__` vs. `__repr__`
- [ ] Cvičná úloha 4 — `__eq__` bez `__hash__`
- [ ] Cvičná úloha 5 — property a rekurze v getteru
- [ ] Cvičná úloha 6 — iterátor bez `StopIteration`
- [ ] **Zpaměti napsat kostru třídy** se všemi speciálními metodami — tohle se nedá odvodit, musíš to umět
- [ ] Iterátor **oběma způsoby** — `__next__` i generátorem

---

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

---

### Na co se doptají

- **Jaký je rozdíl mezi atributem třídy a atributem instance? Ukaž na svém kódu.** — `colors` je atribut třídy, sdílený všemi instancemi (seznam barev je pro semafory společný). `self.color` je atribut instance, každý semafor má vlastní. Uvnitř metody se k atributu třídy musí přes `self.` nebo jméno třídy.
- **Proč `__str__` a `__repr__` zvlášť?** — `__str__` je pro člověka (`red`), `__repr__` pro programátora a mělo by vypadat jako kód, kterým objekt vytvoříš (`Semaphore('red')`). **V seznamu se volá `__repr__`**, ne `__str__`.
- **Když předefinuji `__eq__`, co se stane při vložení do množiny?** — `TypeError: unhashable type`. Definice `__eq__` **vypne** `__hash__`, protože Python neví, jak hash z tvé rovnosti odvodit. Musíš dodat `__hash__` počítaný ze stejných atributů.
- **Jak by vypadalo řešení generátorem místo plného iterátoru?** — `__iter__` s `yield` místo `return self` + `__next__`. Kratší, nepotřebuje `StopIteration` a hlavně **drží stav sám**, takže dvě souběžné iterace se neperou.
- **Proč `nextColor` vrací nový objekt a nemění `self`?** — Docstring říká „vrací semafor". Neměnný objekt nemá vedlejší efekty a snáz se testuje. Varianta měnící `self.color` je taky legitimní, ale pak nesmí nic vracet.
- **Co dělá `% len(colors)` a proč tam je?** — Zbytek po dělení zajistí cyklení: po posledním indexu se vrátí na 0. Bez něj `IndexError` na poslední barvě.
- **Proč property a ne obyčejná metoda?** — Protože `stop` je logicky *vlastnost* semaforu, ne akce. Čte se bez závorek a počítá se za běhu, takže je vždy aktuální.
- **K čemu je podtržítko v `self._celsia`?** — Konvence „interní, nesahej na to". Bez něj by se getter volal dokola a skončil `RecursionError`.
- **Co vrací `NotImplemented` v `__eq__`?** — Signál „neumím se porovnat s tímhle typem, zkus to ty". Python pak zkusí opačné porovnání a nakonec vrátí `False`. Lepší než vyhodit výjimku.
- **Kdy se volá `__init__` a kdy `__new__`?** — `__new__` objekt vytvoří, `__init__` ho inicializuje. Běžně píšeš jen `__init__`; `__new__` potřebuješ u neměnných typů.
- **Co se stane, když `__next__` nevyhodí `StopIteration`?** — `for` cyklus nikdy neskončí.
- **Jaká je složitost `nextColor`?** — `list.index` je $O(n)$, takže $O(n)$ v počtu barev — tady 3, tedy prakticky konstanta. Slovníkem barva→index by to bylo $O(1)$.

---

### Užitečné odkazy

- Třídy v dokumentaci: <https://docs.python.org/3/tutorial/classes.html>
- Speciální metody (datový model): <https://docs.python.org/3/reference/datamodel.html>
- Funkce a cykly prakticky: [okruh 1](../01-programovani-funkce-a-cykly/)
- Kolekce prakticky: [okruh 2](../02-programovani-kolekce/)
- Iterátory teoreticky: [SZZTP okruh 1](../../SZZTP/01-abstraktni-kolekce/)
