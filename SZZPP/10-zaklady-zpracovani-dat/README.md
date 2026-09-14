## 10 — Základy zpracování dat

- [Zadání okruhu (PDF)](../ZadaniOkruhu/ZZD.pdf)
- 📄 **[Tahák k okruhu 10](../Tahaky/10.md)** — **hotový R kód** — dplyr, pivot, ggplot *(na mobil k nahlédnutí, ne k odevzdání)*

> Vstupem je **sada tabulek (CSV/XLSX)** a seznam požadavků. Výstupem je **protokol v Rmd nebo qmd + vyrenderované HTML/PDF** s popisem dat, komentovaným kódem a **interpretací výsledků**. 60 minut u počítače s RStudiem a tidyverse, pak 20 minut obhajoby.

**Odevzdává se protokol, ne skript.** To je zásadní rozdíl proti [okruhu 8](../08-operacni-systemy/): nestačí, že kód funguje — musí být **zrenderovaný do HTML/PDF** a doplněný slovním popisem a interpretací. Zadání to vyjmenovává ve třech bodech.

> **Nejčastější způsob, jak tenhle okruh pokazit:** nechat render na konec a nestihnout ho. **Nerenderovaný protokol je nedodělaný protokol** — kód v `.qmd` bez HTML je podle zadání neúplné odevzdání. [Jak se tomu vyhnout](#postup-u-zkoušky-60-min-přípravy).

Podle [PLAN.md](../../PLAN.md) je u tohohle okruhu riziko v tom, že `dplyr`/`ggplot2` syntaxe vypadává z hlavy nejrychleji ze všeho. **Chce to reálné psaní kódu, ne čtení.** Skripty ke spuštění jsou ve složce [`Kod/`](./Kod/).

Překryv se statistikou v [SZZTP 8](../../SZZTP/08-nahodna-velicina/) a [SZZTP 9](../../SZZTP/09-intervaly-spolehlivosti/) — interpretace boxplotu a rozdělení se hodí na obou místech.

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn, pak výklad s příklady. -->

#### Souhrn na jednom místě

| Co | K čemu | Zapamatuj si | Kde |
|---|---|---|---|
| `numeric`, `character` | čísla, text | `is.numeric()`, `as.numeric()` | [↓](#datové-typy-a-struktury) |
| `logical` | `TRUE`/`FALSE` | dá se sčítat: `sum(x > 5)` spočítá splněné | [↓](#datové-typy-a-struktury) |
| **`factor`** | kategorie s pevnými úrovněmi | **řídí pořadí v grafech**; `levels()` | [↓](#factor--na-tom-záleží-víc-než-se-zdá) |
| vektor | základní struktura | R **vektorizuje** — cykly obvykle nepotřebuješ | [↓](#datové-typy-a-struktury) |
| `data.frame` | tabulka | `str()`, `summary()`, `nrow()`, `head()` | [↓](#datové-typy-a-struktury) |
| `list` | heterogenní seznam | prvky přes `[[ ]]`, ne `[ ]` | [↓](#datové-typy-a-struktury) |
| `read.csv` / `read_csv` | načtení CSV | pozor na `stringsAsFactors` a oddělovač | [↓](#načítání-a-ukládání-dat) |
| `read_excel` | načtení XLSX | z balíčku `readxl` | [↓](#načítání-a-ukládání-dat) |
| `%>%` nebo `\|>` | pipe — řetězení operací | „vezmi tohle **a pak**…" | [↓](#dplyr--manipulace-s-tabulkami) |
| `mutate` | **nový sloupec** | `mutate(avg = (a+b+c)/3)` | [↓](#dplyr--manipulace-s-tabulkami) |
| `filter` | **výběr řádků** | pozor: `==`, ne `=` | [↓](#dplyr--manipulace-s-tabulkami) |
| `select` | **výběr sloupců** | `select(-sloupec)` odebere | [↓](#dplyr--manipulace-s-tabulkami) |
| `arrange` | řazení | `arrange(desc(x))` sestupně | [↓](#dplyr--manipulace-s-tabulkami) |
| `group_by` + `summarise` | seskupení a agregace | **`.groups = "drop"`** na konec | [↓](#seskupování-a-sumarizace) |
| `pivot_wider` | dlouhý → **široký** | `names_from`, `values_from` | [↓](#krátký-a-dlouhý-formát) |
| `pivot_longer` | široký → **dlouhý** | ggplot chce skoro vždy **dlouhý** | [↓](#krátký-a-dlouhý-formát) |
| `str_detect` | obsahuje vzor? | **je v zadání** — hledání „high school" | [↓](#řetězce-a-regulární-výrazy) |
| `ggplot()` + `geom_*` | grafy | vrstvy spojené `+`, ne `%>%` | [↓](#ggplot2--grafy) |
| `geom_boxplot` | boxplot | **je v zadání**; umět interpretovat | [↓](#boxplot-a-jeho-interpretace) |
| `.qmd` / `.Rmd` | reprodukovatelný report | YAML hlavička + chunky | [↓](#protokol-v-qmd) |

**Tři věci, které rozhodují o úspěchu:** `str_detect` s podřetězcem (past v zadání), `pivot_wider` na široký formát, a **zrenderovat včas**.

#### Datové typy a struktury

```r
x <- 5                      # numeric
jmeno <- "Anna"             # character
plati <- TRUE               # logical
kategorie <- factor("A")    # factor

class(x)        # "numeric"
is.numeric(x)   # TRUE
as.numeric("5") # 5  (převod)
```

**Logické hodnoty se dají sčítat** — `TRUE` je 1, `FALSE` je 0:

```r
skore <- c(45, 78, 92, 61, 88)
sum(skore > 70)        # 3    — kolik jich je nad 70
mean(skore > 70)       # 0.6  — jaký podíl (60 %)
```

To je idiom, který se pořád hodí: **`mean()` na logickém vektoru dá rovnou podíl.**

**Vektor** je základní struktura a R na něm pracuje **vektorizovaně** — operace se aplikuje na všechny prvky naráz, cyklus nepotřebuješ:

```r
skore <- c(45, 78, 92)
skore + 10        # 55 88 102   — přičte ke všem
skore / 10        # 4.5 7.8 9.2
skore[skore > 70] # 78 92       — filtrování logickým vektorem
length(skore)     # 3
```

**Indexuje se od 1**, ne od nuly (na rozdíl od Pythonu). `skore[1]` je první prvek, `skore[-1]` **odebere** první (ne poslední!).

**`data.frame`** je tabulka — sloupce mohou mít různý typ, ale všechny mají stejnou délku:

```r
df <- read.csv("StudentsPerformance.csv")
str(df)        # struktura: typy a první hodnoty  <- TOHLE spusť vždycky první
summary(df)    # statistický souhrn každého sloupce
head(df, 3)    # první tři řádky
nrow(df); ncol(df)   # 1000, 8
names(df)      # názvy sloupců
df$gender      # jeden sloupec jako vektor
df[1, ]        # první řádek
df[, "gender"] # sloupec
```

**`str()` a `summary()` spusť hned po načtení** — zadání chce „základní popis zadaných dat" a tohle je přesně ono.

**`list`** může držet cokoli různých typů a délek:

```r
l <- list(cislo = 5, text = "ahoj", vektor = c(1,2,3))
l$cislo       # 5
l[["text"]]   # "ahoj"    <- dvojité závorky!
l["text"]     # podseznam, ne hodnota
```

#### `factor` — na tom záleží víc, než se zdá

Kategorie s **pevně danou množinou úrovní**. Je to doptávka ze zadání, tak si to zapamatuj.

```r
g <- factor(c("male","female","female","male"))
levels(g)     # "female" "male"   <- ABECEDNĚ, ne podle výskytu
table(g)      # female 2, male 2
as.integer(g) # 2 1 1 2           <- vnitřně jsou to čísla!
```

**Proč na tom záleží:** `ggplot2` řadí kategorie na ose **podle úrovní factoru**, ne podle abecedy ani podle výskytu v datech. Když chceš jiné pořadí, musíš ho nastavit:

```r
# výchozí: abecedně — "some high school" před "high school"?  Ne, abecedně: h < s
vzdelani <- factor(df$parental.level.of.education)

# vlastní pořadí (logické, ne abecední)
vzdelani <- factor(df$parental.level.of.education,
                   levels = c("some high school", "high school",
                              "some college", "associate's degree",
                              "bachelor's degree", "master's degree"))
```

**Konkrétně:** bez tohohle by v grafu šlo „associate's degree" před „high school", což nedává smysl — ale abecedně je to správně (a < h).

**Past s `read.csv`:** ve starších verzích R se text automaticky převáděl na factor. **Od R 4.0 už ne** (`stringsAsFactors = FALSE` je výchozí). Pokud narazíš na starý kód, který se chová divně, tohle bývá příčina.

```r
str(df$gender)           # chr — je to text, ne factor
df$gender <- factor(df$gender)   # explicitní převod, když ho potřebuješ
```

#### Načítání a ukládání dat

```r
# CSV — base R
df <- read.csv("data.csv")
df <- read.csv("data.csv", sep = ";", dec = ",")   # český Excel!

# CSV — readr (tidyverse), rychlejší a hlásí typy
library(readr)
df <- read_csv("data.csv")
df <- read_csv2("data.csv")    # evropský formát: ; oddělovač, , desetinná

# XLSX
library(readxl)
df <- read_excel("data.xlsx")
df <- read_excel("data.xlsx", sheet = "List2")

# uložení
write.csv(df, "vystup.csv", row.names = FALSE)   # row.names=FALSE, ať nepřibude sloupec
library(writexl); write_xlsx(df, "vystup.xlsx")
```

**Nejčastější problém při načítání** je český CSV z Excelu: oddělovač `;` a desetinná čárka. Poznáš to tak, že `str()` ukáže **jeden sloupec** místo osmi, nebo čísla jako `character`. Řešení: `read.csv2()` nebo `sep=";", dec=","`.

**Vždycky po načtení zkontroluj `str(df)` a `nrow(df)`** — jestli sedí počet sloupců a typy.

#### `dplyr` — manipulace s tabulkami

Pět základních sloves, která pokryjí většinu zadání:

```r
library(dplyr)

df %>%
  mutate(avg.score = (math.score + reading.score + writing.score) / 3) %>%  # nový sloupec
  filter(gender == "female") %>%                                            # výběr řádků
  select(gender, race.ethnicity, avg.score) %>%                             # výběr sloupců
  arrange(desc(avg.score)) %>%                                              # řazení
  head(5)
```

**Pipe `%>%`** (nebo nativní `|>` v novějším R) čte se jako **„a pak"**: vezmi `df`, **a pak** přidej sloupec, **a pak** vyfiltruj…

| Sloveso | Co dělá | Příklad |
|---|---|---|
| `mutate()` | **přidá/změní sloupec** | `mutate(avg = (a+b)/2)` |
| `filter()` | **vybere řádky** podle podmínky | `filter(skore > 70)` |
| `select()` | **vybere sloupce** | `select(gender, skore)`, `select(-lunch)` |
| `arrange()` | seřadí | `arrange(desc(skore))` |
| `rename()` | přejmenuje | `rename(novy = stary)` |
| `distinct()` | odstraní duplicity | `distinct(gender)` |
| `slice_head(n=5)` | prvních n řádků | |

**Past: `filter` používá `==`, ne `=`.** Jedno rovnítko je přiřazení a R ohlásí chybu.

**Spojování tabulek** (zadání to zmiňuje jako „slučování"):

```r
left_join(a, b, by = "id")     # vše z a + odpovídající z b (jako SQL LEFT JOIN)
inner_join(a, b, by = "id")    # jen shodné
full_join(a, b, by = "id")     # vše z obou
anti_join(a, b, by = "id")     # z a to, co NENÍ v b
```

Je to stejná logika jako [SQL JOINy v okruhu 9](../09-databazove-systemy/#joiny) — `left_join` zachová i řádky bez partnera.

#### Seskupování a sumarizace

```r
souhrn <- df %>%
  group_by(gender, race.ethnicity) %>%
  summarise(
    prumer = mean(avg.score),
    median = median(avg.score),
    n = n(),                    # počet řádků ve skupině
    .groups = "drop"            # <- DŮLEŽITÉ
  )
```

**Ověřený výstup** (na datech po filtrování „high school"):

```
   gender race.ethnicity   prumer  n
1  female        group A 71.07018 19
2  female        group B 75.54444 30
3  female        group C 75.93333 60
...
6    male        group A 63.17778 15
```

**K čemu je `.groups = "drop"`:** bez něj zůstane výsledek seskupený podle první proměnné a další operace se chovají nečekaně (a dplyr vypíše varování). **Piš to vždycky** — ušetří ti to záhadné chyby.

**Agregační funkce:** `mean()`, `median()`, `sd()`, `min()`, `max()`, `sum()`, `n()`, `n_distinct()`.

**Past s `NA`:** jakákoli agregace s chybějící hodnotou vrátí `NA`:

```r
x <- c(1, 2, NA, 4)
mean(x)              # NA      <- pozor!
mean(x, na.rm = TRUE)# 2.333   <- takhle
sum(is.na(df$sloupec))  # kolik je chybějících hodnot
```

**Kontingenční tabulka** (je v zadání):

```r
table(df$gender, df$race.ethnicity)      # četnosti dvou kategorií
prop.table(table(df$gender))             # relativní četnosti (podíly)
xtabs(~ gender + lunch, data = df)       # formulový zápis
```

#### Krátký a dlouhý formát

**Tohle je čtvrtý úkol zadání a je dobré rozumět, proč se to dělá.**

| Formát | Jak vypadá | K čemu |
|---|---|---|
| **dlouhý** (long, tidy) | každý řádek = jedno pozorování | **výpočty, ggplot** |
| **široký** (wide) | kategorie jako sloupce | **čtení člověkem, tabulky do reportu** |

```r
library(tidyr)

# DLOUHÝ -> ŠIROKÝ
siroky <- souhrn %>%
  pivot_wider(names_from = gender, values_from = prumer)

# ŠIROKÝ -> DLOUHÝ
dlouhy <- siroky %>%
  pivot_longer(cols = c(female, male), names_to = "gender", values_to = "prumer")
```

**Ověřený výstup** převodu na široký:

```
  race.ethnicity   female     male
1        group A 71.07018 63.17778
2        group B 75.54444 68.55208
3        group C 75.93333 68.61033
4        group D 76.63194 72.98742
5        group E 79.90123 77.02469
```

**Proč to zadání chce:** takhle se **snadno porovnává** — vidíš vedle sebe ženy a muže v každé skupině a hned je vidět, že ženy mají všude vyšší průměr. V dlouhém formátu bys musel skákat mezi řádky.

**Pozor:** `pivot_wider` potřebuje, aby ve vstupu **nezůstaly další rozlišující sloupce**. Kdybys tam nechal sloupec `n` (počet), vytvořil by se z něj další sloupec navíc nebo vzniknou seznamy. Proto se před pivotem odebírá: `select(-n)`.

#### Řetězce a regulární výrazy

Zadání to vyžaduje explicitně a v ukázkové úloze je to **druhý úkol**.

```r
library(stringr)

str_detect(x, "vzor")         # TRUE/FALSE — obsahuje?
str_replace(x, "a", "b")      # nahradí PRVNÍ výskyt
str_replace_all(x, "a", "b")  # všechny
str_sub(x, 1, 3)              # podřetězec (od 1 do 3)
str_length(x)                 # délka
str_to_lower(x); str_to_upper(x)
str_trim(x)                   # ořeže mezery
str_split(x, ",")             # rozdělí
str_c("a", "b", sep = "-")    # spojí: "a-b"
```

**Regulární výrazy** — základ stačí:

| Vzor | Význam |
|---|---|
| `.` | libovolný znak |
| `^` | začátek řetězce |
| `$` | konec |
| `[abc]` | jeden ze znaků |
| `[0-9]` nebo `\\d` | číslice |
| `+` | jeden a víc |
| `*` | nula a víc |
| `\|` | nebo |

**Pozor na dvojité zpětné lomítko** — v R se píše `"\\d"`, ne `"\d"`.

```r
str_detect(x, "^Praha")       # začíná na Praha
str_detect(x, "school$")      # končí na school
str_detect(x, "\\d{5}")       # obsahuje pět číslic za sebou
str_detect(x, "high|master")  # obsahuje "high" NEBO "master"
```

#### `ggplot2` — grafy

Stavba grafu je **vrstvení spojené `+`** (ne pipe!):

```r
library(ggplot2)

ggplot(df, aes(x = race.ethnicity, y = avg.score, fill = race.ethnicity)) +
  geom_boxplot(show.legend = FALSE) +
  labs(title = "Rozdělení průměrného skóre podle etnické skupiny",
       x = "Etnická skupina", y = "Průměrné skóre") +
  theme_minimal()
```

| Část | Co dělá |
|---|---|
| `ggplot(data, aes(...))` | data a **mapování** proměnných na osy/barvy |
| `geom_*()` | **typ** grafu (vrstva) |
| `labs()` | popisky — **nikdy nevynechávej** |
| `theme_*()` | vzhled (`theme_minimal()`, `theme_bw()`) |
| `facet_wrap(~ promenna)` | rozdělí na podgrafy podle kategorie |

**Nejčastější typy:**

```r
geom_boxplot()                  # rozdělení podle kategorií  <- v zadání
geom_histogram(bins = 30)       # rozdělení jedné číselné proměnné
geom_point()                    # bodový (vztah dvou číselných)
geom_bar()                      # četnosti kategorií (počítá sám)
geom_col()                      # sloupcový z hotových hodnot
geom_line()                     # spojnicový (časové řady)
geom_smooth(method = "lm")      # proložení přímkou
```

**Dvě časté chyby:**

`geom_bar()` vs. `geom_col()` — `bar` si **počty spočítá sám** z dat, `col` očekává **hotové hodnoty** v `y`. Když máš už zagregovanou tabulku, chceš `geom_col()`.

**Vrstvy se spojují `+`, ne `%>%`.** Pipe se používá na přípravu dat, plus na stavbu grafu. Smíchání je nejčastější syntaktická chyba začátečníků:

```r
df %>%                                    # pipe na data
  filter(gender == "female") %>%
  ggplot(aes(x = avg.score)) +            # a TADY se přepne na +
  geom_histogram(bins = 30)
```

#### Boxplot a jeho interpretace

**Zadání ho chce a komise se na interpretaci ptá** — tak si to zapamatuj pořádně.

```
        ┬  ← maximum bez odlehlých (Q3 + 1,5·IQR)
        │
    ┌───┴───┐  ← Q3 (75. percentil)
    │       │
    ├───────┤  ← MEDIÁN (50. percentil)
    │       │
    └───┬───┘  ← Q1 (25. percentil)
        │
        ┴  ← minimum bez odlehlých (Q1 − 1,5·IQR)

        ●  ← odlehlé hodnoty (outliers)
```

| Část | Co znamená |
|---|---|
| **čára uprostřed** | **medián** — polovina hodnot je nad, polovina pod |
| **krabice** | **IQR** (mezikvartilové rozpětí) — **prostředních 50 %** dat |
| **vousy** | dosah do 1,5 násobku IQR od kvartilů |
| **body mimo vousy** | **odlehlé hodnoty** — dál než 1,5·IQR |

**Ověřená čísla** z naší úlohy (skupina A):

```
min = 41,0   Q1 = 62,2   medián = 67,3   Q3 = 75,8   max = 88,3
```

Takže: polovina studentů skupiny A má průměr pod 67,3. Prostředních 50 % leží mezi 62,2 a 75,8, tedy IQR je asi 13,6 bodu.

**Jak boxplot interpretovat nahlas** (přesně tohle řekni u obhajoby):

1. **Poloha** — kde leží medián? *„Skupina E má nejvyšší medián 78,7, skupina A nejnižší 67,3."*
2. **Rozptyl** — jak vysoká je krabice? *„Skupina C má nejširší rozpětí, tedy nejvíc nevyrovnané výsledky."*
3. **Symetrie** — je medián uprostřed krabice? Když je posunutý, je rozdělení **zešikmené**.
4. **Odlehlé hodnoty** — jsou tam body mimo vousy? Co to znamená věcně?

**Klíčová věta:** boxplot **neukazuje průměr, ale medián** — a to je jeho výhoda, protože medián není citlivý na odlehlé hodnoty. Když má rozdělení pár extrémů, průměr se posune, medián ne.

Teorie k percentilům a rozdělení je v [SZZTP okruh 8](../../SZZTP/08-nahodna-velicina/).

#### Protokol v `.qmd`

```
---
title: "Protokol — zpracování dat o výsledcích studentů"
author: "Valdemar Pospíšil"
date: today
format:
  html:
    toc: true
    code-fold: false
    embed-resources: true
lang: cs
---
```

**`embed-resources: true` je důležité** — zabalí obrázky přímo do HTML, takže odevzdáváš **jeden soubor**, ne HTML plus složku s obrázky.

**Chunk s kódem:**

````
```{r}
#| label: nacteni-dat
#| message: false
library(tidyverse)
df <- read.csv("StudentsPerformance.csv")
```
````

| Volba chunku | K čemu |
|---|---|
| `#| message: false` | skryje hlášky při načítání balíčků |
| `#| warning: false` | skryje varování |
| `#| echo: false` | **skryje kód**, ukáže jen výstup |
| `#| include: false` | spustí, ale nic nezobrazí |
| `#| fig-width: 8` | šířka grafu |

**Zadání chce komentovaný kód**, takže `echo: false` používej jen výjimečně — kód má být vidět.

**Render:** v RStudiu tlačítko **Render** (nebo `Ctrl+Shift+K`). Z konzole:

```r
quarto::quarto_render("protokol.qmd")
rmarkdown::render("protokol.Rmd")     # pro .Rmd
```

---

### Postup u zkoušky (60 min přípravy)

**0–5 min — render nejdřív, obsah potom**

1. **Založ `.qmd` s hlavičkou a jedním triviálním chunkem a hned ho zrenderuj.** Když render nefunguje (chybí balíček, LaTeX u PDF), chceš to vědět **na začátku**, ne v 55. minutě.
2. Když PDF zlobí, **přepni na HTML** — zadání připouští obojí a HTML nepotřebuje LaTeX.

**5–15 min — načtení a popis dat**

3. Načti data, spusť `str(df)`, `summary(df)`, `nrow(df)`.
4. **Napiš slovní popis** — kolik řádků, jaké sloupce, jaké typy, jsou chybějící hodnoty. Zadání to chce jako první bod obsahu.

**15–45 min — úkoly po jednom**

5. Každý úkol = **vlastní nadpis + chunk + komentář**. Struktura protokolu tím vznikne sama.
6. **Po každém chunku se podívej na výsledek** — `head()`, `nrow()`, ne slepě dál.
7. U grafů hned připiš **jednu větu interpretace**. Nenechávej to na konec, zapomeneš to.

**45–55 min — interpretace a úklid**

8. Projdi zadání bod po bodu a odškrtej.
9. Doplň závěr — **co z dat plyne**. Tohle je třetí povinný bod obsahu.

**55–60 min — finální render**

10. **Zrenderuj načisto a otevři výsledek.** Zkontroluj, že se vykreslily grafy a nikde není chybová hláška.
11. Odevzdej **oba soubory** — `.qmd` i vyrenderované HTML/PDF.

**Když ti dojde čas:** raději tři úkoly s interpretací a zrenderované, než pět úkolů v nezrenderovaném souboru.

---

### Rozbor ukázkové úlohy

> Soubor `StudentsPerformance.csv` načtěte a vyřešte:
> 1. nový sloupec `avg.score` — průměr z `math.score`, `reading.score`, `writing.score`
> 2. vyfiltrujte záznamy, kde `parental.level.of.education` obsahuje **„high school" kdekoliv v textu**
> 3. průměr `avg.score` pro **každou kombinaci** `gender` a `race.ethnicity`
> 4. převeďte do **širokého formátu** — `gender` jako sloupce
> 5. **boxplot** `avg.score` pro každou kategorii `race.ethnicity`

#### Popis dat

Datová sada má **1000 řádků a 8 sloupců**: pět kategorických (`gender`, `race.ethnicity`, `parental.level.of.education`, `lunch`, `test.preparation.course`) a tři číselné (`math.score`, `reading.score`, `writing.score`, každý 0–100).

```r
str(df)
summary(df)
sum(is.na(df))     # 0 — žádné chybějící hodnoty
```

#### Úkol 1 — nový sloupec

```r
df <- df %>%
  mutate(avg.score = (math.score + reading.score + writing.score) / 3)
```

**Ověření na prvním řádku:** `(84 + 85 + 80) / 3 = 83`. Sedí.

**Alternativa přes `rowMeans`** (elegantnější, když je sloupců víc):

```r
df <- df %>%
  mutate(avg.score = rowMeans(select(., math.score, reading.score, writing.score)))
```

**Pozor:** `mean(c(a, b, c))` uvnitř `mutate` **nefunguje po řádcích** — spočítal by průměr celého sloupce. Na to je buď ruční `(a+b+c)/3`, nebo `rowMeans()`.

#### Úkol 2 — filtr „high school" kdekoliv v textu

**Tady je past a je to nejdůležitější bod celé úlohy.** Sloupec obsahuje šest kategorií:

```
"master's degree"  "associate's degree"  "some high school"
"bachelor's degree"  "high school"  "some college"
```

**Dvě z nich obsahují „high school":** `high school` **a** `some high school`. Zadání říká **„kdekoliv v textu"**, takže se musí zachytit obě:

```r
hs <- df %>% filter(str_detect(parental.level.of.education, "high school"))
```

**Ověřený výsledek:** z 1000 řádků zůstalo **382** — z toho 198 „high school" a 184 „some high school".

**Co by bylo špatně:**

```r
filter(parental.level.of.education == "high school")   # jen 198 řádků — chybí polovina!
```

**Řekni to u obhajoby sám:** *„Použil jsem `str_detect`, protože zadání říká 'kdekoliv v textu' — kategorie `some high school` obsahuje hledaný pojem taky a rovnost by ji vynechala."*

#### Úkol 3 — průměr pro kombinaci dvou kategorií

```r
souhrn <- hs %>%
  group_by(gender, race.ethnicity) %>%
  summarise(prumer.avg.score = mean(avg.score), n = n(), .groups = "drop")
```

**Ověřený výstup** (10 kombinací = 2 pohlaví × 5 skupin):

```
   gender race.ethnicity   prumer  n
1  female        group A 71.07018 19
2  female        group B 75.54444 30
3  female        group C 75.93333 60
4  female        group D 76.63194 48
5  female        group E 79.90123 27
6    male        group A 63.17778 15
7    male        group B 68.55208 32
8    male        group C 68.61033 71
9    male        group D 72.98742 53
10   male        group E 77.02469 27
```

**Sloupec `n` tam přidávám schválně** — ukazuje velikost skupin, a průměr ze 15 hodnot má jinou váhu než ze 71. U interpretace na to upozorni.

#### Úkol 4 — široký formát

```r
siroky <- souhrn %>%
  select(-n) %>%                      # odebrat n, jinak by pivot vyrobil sloupce navíc
  pivot_wider(names_from = gender, values_from = prumer.avg.score)
```

**Ověřený výstup:**

```
  race.ethnicity   female     male
1        group A 71.07018 63.17778
2        group B 75.54444 68.55208
3        group C 75.93333 68.61033
4        group D 76.63194 72.98742
5        group E 79.90123 77.02469
```

**Interpretace, která se hodí nahlas:** *„V širokém formátu je hned vidět, že ženy mají vyšší průměrné skóre ve **všech pěti** skupinách. Největší rozdíl je u skupiny A (asi 8 bodů), nejmenší u skupiny E (necelé 3 body). V dlouhém formátu by tohle porovnání vyžadovalo skákat mezi řádky."*

#### Úkol 5 — boxplot

```r
ggplot(hs, aes(x = race.ethnicity, y = avg.score, fill = race.ethnicity)) +
  geom_boxplot(show.legend = FALSE) +
  labs(title = "Rozdělení průměrného skóre podle etnické skupiny",
       subtitle = "Pouze studenti, jejichž rodič má vzdělání obsahující 'high school'",
       x = "Etnická skupina", y = "Průměrné skóre") +
  theme_minimal()
```

**Ověřené hodnoty, které z grafu čteš:**

| Skupina | min | Q1 | medián | Q3 | max |
|---|---|---|---|---|---|
| A | 41,0 | 62,2 | **67,3** | 75,8 | 88,3 |
| B | 51,0 | 68,8 | **73,0** | 76,7 | 96,3 |
| C | 45,0 | 65,8 | **72,3** | 79,3 | 100,0 |
| D | 51,3 | 69,0 | **75,7** | 80,7 | 93,7 |
| E | 56,3 | 71,8 | **78,7** | 84,4 | 95,7 |

**Interpretace k obhajobě:**

> Mediány rostou od skupiny A (67,3) ke skupině E (78,7), tedy mezi skupinami je systematický rozdíl asi 11 bodů. Skupina A má zároveň nejnižší minimum (41) a nejužší horní část — její výsledky jsou nejslabší i nejméně rozptýlené směrem nahoru. Skupina C má naopak nejširší rozpětí (45 až 100), takže je uvnitř nejvíc nevyrovnaná. **Pozor na velikost skupin** — skupina A má jen 34 studentů, takže je její odhad méně spolehlivý než u skupiny C se 131.

**Proč boxplot a ne histogram** (častá doptávka): boxplot **porovnává rozdělení mezi kategoriemi** vedle sebe, histogram ukazuje tvar rozdělení **jedné** proměnné. Zadání chce porovnat pět skupin, takže boxplot.

---

### Příklady na procvičení

Skripty i data jsou v [`Kod/`](./Kod/). U každého si nastav 45 minut a **napiš protokol celý, včetně renderu**.

#### Příklad 1 — prodeje podle měsíců a poboček

> CSV s prodeji (`pobocka`, `mesic`, `kategorie`, `trzba`, `pocet_kusu`).
>
> 1. přidej sloupec `prumerna_cena` (tržba / počet kusů)
> 2. vyfiltruj jen pobočky, jejichž název obsahuje „Praha"
> 3. spočítej celkovou tržbu pro kombinaci `pobocka` × `kategorie`
> 4. převeď do širokého formátu (kategorie jako sloupce)
> 5. sloupcový graf tržeb podle poboček, histogram tržeb

*Co si vyzkoušíš:* totéž co v ukázkové úloze, jen na jiných datech — a navíc `geom_col()` vs. `geom_bar()`.

*Past:* dělení nulou u `prumerna_cena`, když je `pocet_kusu` nulový. Ošetři `ifelse()`.

#### Příklad 2 — měření teplot

> CSV s měřeními (`stanice`, `datum`, `teplota_rano`, `teplota_poledne`, `teplota_vecer`), **s chybějícími hodnotami**.
>
> 1. převeď do **dlouhého formátu** (jeden řádek = jedno měření)
> 2. spočítej denní průměr pro každou stanici, ošetři `NA`
> 3. najdi dny, kdy teplota přesáhla 30 °C
> 4. boxplot teplot podle stanic a podle denní doby
> 5. spojnicový graf průběhu teplot v čase

*Co si vyzkoušíš:* `pivot_longer` (opačný směr než v ukázkové úloze), `na.rm = TRUE`, práci s datem, `geom_line()`.

*Past:* `mean()` bez `na.rm = TRUE` vrátí `NA`. A `as.Date()` potřebuje správný formát.

---

### Co si nacvičit

Skripty jsou ve složce [`Kod/`](./Kod/) — [přehled a zadání cvičení](./Kod/) je v README té složky:

| Soubor | Co to je |
|---|---|
| [`protokol-ukazkova-uloha.qmd`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/10-zaklady-zpracovani-dat/Kod/protokol-ukazkova-uloha.qmd) | **referenční řešení** — kompletní protokol i s interpretacemi |
| [`vytvor-data.R`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/10-zaklady-zpracovani-dat/Kod/vytvor-data.R) | vygeneruje `StudentsPerformance.csv` i data pro cvičení |
| [`01-prodeje-reseni.R`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/10-zaklady-zpracovani-dat/Kod/priklady/01-prodeje-reseni.R) | cvičný příklad 1 — prodeje podle poboček |
| [`02-teploty-reseni.R`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/10-zaklady-zpracovani-dat/Kod/priklady/02-teploty-reseni.R) | cvičný příklad 2 — teploty s chybějícími hodnotami |

Rychlý start v RStudiu: nastav pracovní adresář na složku `Kod/`, spusť `source("vytvor-data.R")` a otevři `.qmd` protokol.

- [ ] **Ukázková úloha celá** — protokol v `.qmd`, zrenderovaný, na časovku 60 minut
- [ ] Aspoň jeden [příklad na procvičení](#příklady-na-procvičení)
- [ ] **Zpaměti: kostra `.qmd`** — YAML hlavička + první chunk, bez hledání na internetu
- [ ] **Zpaměti: pět sloves dplyr** — `mutate`, `filter`, `select`, `arrange`, `group_by`+`summarise`
- [ ] `str_detect` s podřetězcem — **past z ukázkové úlohy**
- [ ] `pivot_wider` i `pivot_longer`, vědět kdy který
- [ ] `ggplot` od nuly: boxplot, histogram, sloupcový, bodový
- [ ] **Interpretace boxplotu nahlas** — medián, IQR, vousy, odlehlé hodnoty
- [ ] `.groups = "drop"` a `na.rm = TRUE` — psát automaticky
- [ ] Zrenderovat `.qmd` do HTML **bez hledání**, včetně `embed-resources`

---

### Poznámky

<!-- Sem vlastní výpisky, útržky kódu, výstupy. -->

---

### Na co se doptají

- **Co ti boxplot říká o rozdělení dat? Co jsou ty body mimo vousy?** — Čára uprostřed je **medián**, krabice je **IQR** (prostředních 50 % dat), vousy sahají do 1,5 násobku IQR. Body za nimi jsou **odlehlé hodnoty**. Když je medián posunutý v krabici, je rozdělení **zešikmené**.
- **Proč jsi zvolil právě tenhle typ grafu?** — Boxplot **porovnává rozdělení mezi kategoriemi** vedle sebe, což zadání chce. Histogram by ukázal tvar rozdělení jedné proměnné, ale neporovnal by pět skupin.
- **Jaký je rozdíl mezi krátkým a dlouhým formátem a kdy který potřebuješ?** — Dlouhý má **jeden řádek na pozorování** a chce ho `ggplot` i výpočty. Široký má **kategorie jako sloupce** a je čitelnější pro člověka. Převádí se `pivot_wider` / `pivot_longer`.
- **Co je factor a proč na něm záleží při vykreslování?** — Kategorie s pevnými **úrovněmi**. `ggplot` řadí osu podle úrovní, ne podle abecedy ani výskytu — takže když chceš vlastní pořadí (např. stupně vzdělání logicky, ne abecedně), musíš ho nastavit přes `levels`.
- **Proč jsi použil `str_detect` a ne rovnost?** — Zadání říká „obsahuje **kdekoliv v textu**". Kategorie `some high school` hledaný pojem obsahuje taky, ale `== "high school"` by ji vynechala — přišel bych o 184 z 382 řádků.
- **Co dělá `.groups = "drop"`?** — Po `summarise` zruší zbývající seskupení. Bez něj zůstane výsledek seskupený podle první proměnné, dplyr vypíše varování a další operace se chovají nečekaně.
- **Co se stane, když jsou v datech `NA`?** — Jakákoli agregace vrátí `NA`. Řeší se `mean(x, na.rm = TRUE)`. Počet chybějících zjistíš `sum(is.na(x))`.
- **Rozdíl `geom_bar()` a `geom_col()`?** — `geom_bar()` si **spočítá četnosti sám** z dat, `geom_col()` očekává **hotové hodnoty** v `y`. Na zagregovanou tabulku chceš `geom_col()`.
- **Proč se vrstvy ggplotu spojují `+` a ne `%>%`?** — `ggplot2` vznikl dřív než pipe a má vlastní systém skládání vrstev. Pipe se používá na **přípravu dat**, plus na **stavbu grafu**.
- **Jaký je rozdíl mezi mediánem a průměrem?** — Medián je **prostřední hodnota**, průměr součet dělený počtem. Medián **není citlivý na odlehlé hodnoty** — proto ho boxplot ukazuje. U zešikmených dat (příjmy) je medián vypovídající.
- **Co je `%>%` a jak se liší od `|>`?** — Obojí je pipe. `%>%` je z `magrittr` (součást tidyverse) a umí `.` jako zástupný symbol. `|>` je nativní od R 4.1, rychlejší, ale jednodušší. Pro zkoušku jsou zaměnitelné.
- **Proč `embed-resources: true`?** — Zabalí obrázky a CSS přímo do HTML, takže odevzdáváš **jeden soubor** místo HTML a složky s obrázky.
- **Jak bys ověřil, že se ti data načetla správně?** — `str()` (typy a struktura), `nrow()`/`ncol()` (rozměry), `summary()` (rozsahy hodnot), `sum(is.na())` (chybějící). Nejčastější problém je český CSV se `;` a desetinnou čárkou — pozná se podle toho, že vznikne jeden sloupec místo osmi.
- **Indexuje se v R od nuly?** — **Ne, od jedničky.** A `x[-1]` **odebere** první prvek, není to poslední jako v Pythonu.

---

### Užitečné odkazy

Materiály, které jsou podle zadání k dispozici u zkoušky:

- R snadno a rychle I: <https://oeconomica.vse.cz/wp-content/uploads/Danko_Safr_R-snadno-a-rychle_1.pdf>
- R snadno a rychle II: <https://oeconomica.vse.cz/wp-content/uploads/Safr_Danko_R-snadno-a-rychle_2.pdf>
- Taháky (dplyr, ggplot2, stringr, Markdown) jsou vyjmenované v [zadání](../ZadaniOkruhu/ZZD.pdf)

Další:

- Dokumentace tidyverse: <https://www.tidyverse.org/>
- R for Data Science (kniha zdarma): <https://r4ds.hadley.nz/>
- Statistika a rozdělení teoreticky: [SZZTP okruh 8](../../SZZTP/08-nahodna-velicina/)
