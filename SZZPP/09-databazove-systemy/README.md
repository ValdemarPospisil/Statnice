## 9 — Databázové systémy

- [Zadání okruhu (PDF)](../ZadaniOkruhu/URDB.pdf)
- 📄 **[Tahák k okruhu 9](../Tahaky/09.md)** — CREATE/INSERT/SELECT vzory + normální formy *(na mobil k nahlédnutí, ne k odevzdání)*

> Ze slovního popisu a konceptuálního návrhu vytvořit databázi v **PostgreSQL**: ER diagram po normalizaci **na papíře**, `CREATE TABLE` + `INSERT`, a **odladěné dotazy `SELECT` včetně výstupů**. 60 minut u počítače (psql, textový editor, **tahák SQL**), pak 20 minut obhajoby.

**Tři výstupy, tři různá média** — a lidi zapomínají na první: diagram se kreslí **rukou na papír**, takže si to nacvič. Zbytek je práce v `psql`.

> **Nejčastější způsob, jak tenhle okruh pokazit:** opsat konceptuální návrh ze zadání do tabulek beze změny. Zadání **explicitně říká**, že návrh je *„nutno upravit (normalizovat, odstranit přebytečné atributy apod.)"* — je tam **schválně rozbitý**. Najít ty vady je půlka úlohy. [Které to jsou](#co-je-na-zadaném-návrhu-špatně).

Velký překryv se [SZZVP okruh 1](../../SZZVP/01-relacni-db-a-olap/) — tam je totéž plus transakce, procedury a OLAP. **Uč se to rovnou v širší verzi.**

Hotové SQL skripty jsou ve složce [`Kod/`](./Kod/).

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn, pak výklad s příklady. -->

#### Souhrn na jednom místě

| Co | K čemu | Zapamatuj si | Kde |
|---|---|---|---|
| **entita** | věc, o které vedeme data | v návrhu → tabulka | [↓](#konceptuální-návrh) |
| **atribut** | vlastnost entity | → sloupec | [↓](#konceptuální-návrh) |
| **1:N** | jeden k mnoha | FK jde na stranu **N** | [↓](#relační-vztahy-a-jejich-rozklad) |
| **M:N** | mnoho k mnoha | **vždy vazební tabulka** se složeným PK | [↓](#relační-vztahy-a-jejich-rozklad) |
| **1:1** | jeden k jednomu | FK + `UNIQUE`, nebo sloučit do jedné tabulky | [↓](#relační-vztahy-a-jejich-rozklad) |
| **1. NF** | atomické hodnoty | žádné seznamy v jednom sloupci | [↓](#normalizace) |
| **2. NF** | 1. NF + plná závislost na **celém** PK | týká se **jen složených klíčů** | [↓](#normalizace) |
| **3. NF** | 2. NF + žádná tranzitivní závislost | neklíčový atribut nesmí určovat jiný | [↓](#normalizace) |
| **ER vraní nohy** | notace vztahů | „nožka" = strana **N** | [↓](#er-diagram-vraními-nohami) |
| `CREATE TABLE` | fyzický návrh | pořadí: **nadřazené tabulky první** (kvůli FK) | [↓](#create-table-a-domény) |
| `SERIAL` | automatické ID | v PostgreSQL; moderně `GENERATED AS IDENTITY` | [↓](#create-table-a-domény) |
| `PRIMARY KEY` | jednoznačná identifikace | implikuje `NOT NULL` + `UNIQUE` | [↓](#integritní-omezení) |
| `FOREIGN KEY` | referenční integrita | `REFERENCES tabulka(sloupec)` | [↓](#integritní-omezení) |
| `CHECK` | doménové omezení | `CHECK (rocnik BETWEEN 1 AND 6)` | [↓](#integritní-omezení) |
| `INSERT INTO` | vkládání | víc řádků naráz `VALUES (…),(…)` | [↓](#insert) |
| `INNER JOIN` | průnik | řádky **bez partnera zmizí** | [↓](#joiny) |
| `LEFT JOIN` | vše zleva | nespárované doplní `NULL` | [↓](#joiny) |
| `WHERE` | selekce (filtr řádků) | před seskupením | [↓](#select-where-order-by) |
| `GROUP BY` | seskupení | v `SELECT` jen **klíče seskupení a agregace** | [↓](#group-by-a-agregace) |
| `HAVING` | filtr **po** seskupení | na agregované hodnoty | [↓](#group-by-a-agregace) |
| `STRING_AGG` | agregace řetězců | **je v zadání!** `STRING_AGG(nazev, ', ')` | [↓](#group-by-a-agregace) |
| `ORDER BY` | řazení | `ASC` (výchozí) / `DESC` | [↓](#select-where-order-by) |

**Tři věci, které rozhodují o úspěchu:** poznat, co je na zadaném návrhu rozbité, rozložit M:N vazební tabulkou, a umět vysvětlit rozdíl INNER/LEFT JOIN na vlastních datech.

#### Konceptuální návrh

**Entita** = věc, o které vedeme data (student, předmět). **Atribut** = její vlastnost (jméno, datum narození). **Relační vztah** = vazba mezi entitami („student studuje předmět").

Zadání říká, že konceptuální návrh umíš **pasivně** — tedy ho dostaneš hotový a máš ho *upravit*. Takže se neuč kreslit konceptuální model, ale **rozpoznávat v něm vady**.

#### Relační vztahy a jejich rozklad

| Vztah | Jak se realizuje | Příklad |
|---|---|---|
| **1:N** | cizí klíč **na straně N** | program má N studentů → `student.id_programu` |
| **M:N** | **vazební tabulka** se složeným PK | student studuje N předmětů, předmět má M studentů → tabulka `zapis` |
| **1:1** | FK s `UNIQUE`, nebo sloučit | student má jednu kartu → `karta.id_studenta UNIQUE` |

**Rozklad M:N je nejdůležitější dovednost okruhu.** Vztah „student studuje předmět" je M:N, protože jeden student má víc předmětů **a zároveň** jeden předmět má víc studentů. V relační databázi to nejde vyjádřit přímo — musí vzniknout třetí tabulka:

```sql
CREATE TABLE zapis (
    id_studenta INTEGER NOT NULL REFERENCES student(id_studenta),
    id_predmetu INTEGER NOT NULL REFERENCES predmet(id_predmetu),
    PRIMARY KEY (id_studenta, id_predmetu)   -- SLOŽENÝ primární klíč
);
```

**Ten složený PK dělá dvě věci naráz:** identifikuje řádek a **znemožňuje dvojí zápis** téhož studenta na týž předmět. To je odpověď na doptávku „jak zabráníš duplicitnímu zápisu" — a je zdarma, nemusíš přidávat nic dalšího.

Vazební tabulka může mít **vlastní atributy** — datum zápisu, známku, počet pokusů. Pak už to není jen technická spojka, ale plnohodnotná entita.

#### Normalizace

**1. normální forma:** všechny hodnoty jsou **atomické** — v jednom sloupci není seznam.

```
ŠPATNĚ:  predmety = "Databáze, Algoritmy, Elektronika"    <- porušuje 1. NF
SPRÁVNĚ: samostatná tabulka se třemi řádky
```

**2. normální forma:** 1. NF **a** každý neklíčový atribut závisí na **celém** primárním klíči, ne jen na jeho části. **Týká se to jen tabulek se složeným PK** — kde je PK jednoduchý, je 2. NF splněná automaticky.

```
ŠPATNĚ:  zapis(id_studenta, id_predmetu, nazev_predmetu)
         nazev_predmetu závisí jen na id_predmetu, ne na celém klíči
SPRÁVNĚ: nazev_predmetu patří do tabulky predmet
```

**3. normální forma:** 2. NF **a** žádný neklíčový atribut nezávisí na jiném neklíčovém (žádná **tranzitivní** závislost).

```
ŠPATNĚ:  student(id, jmeno, program, doba_trvani_programu)
         doba_trvani závisí na programu, ne na studentovi
         -> id → program → doba_trvani   je tranzitivní závislost
SPRÁVNĚ: tabulka studijni_program(id, nazev, doba_roky)
```

**Jak to poznat rychle** (a jak to říct u obhajoby): zeptej se *„když změním tuhle hodnotu, musím ji změnit na víc místech?"* Když ano, je to porušení normalizace a hrozí **nekonsistence**.

**Konkrétně:** kdyby délka bakalářského studia byla u každého studenta zvlášť a změnila se ze 3 na 4 roky, musel bys ji přepsat u všech studentů — a kdyby ti jeden unikl, máš v databázi rozpor. Po normalizaci se změní **na jednom místě**.

#### ER diagram vraními nohami

Kreslí se **na papír**, takže tohle si opravdu nacvič od ruky.

```
  studijni_program                student                    predmet
 +----------------+          +--------------+          +---------------+
 | id_programu PK |         <| id_studenta  |>--------<| id_predmetu   |
 | nazev          |----------| jmeno        |   zapis  | nazev         |
 | stupen         |    1:N   | prijmeni     |    M:N   | rocnik        |
 | doba_roky      |          | datum_naroz. |          | semestr       |
 +----------------+          | id_programu FK|         +---------------+
                             +--------------+
```

**Notace vraních nohou:**

| Značka | Význam |
|---|---|
| `—<` (nožka) | **mnoho** (N) |
| `—` (čárka) | **jeden** (1) |
| `—o` (kroužek) | volitelné (nula nebo…) |
| `—\|` (svislítko) | povinné (aspoň jeden) |

Kombinace se čtou zprava doleva: `—o<` je „nula nebo mnoho", `—\|<` je „jeden nebo mnoho".

**Praktická rada ke kreslení:** M:N vazbu **vždy rozkresli na dvě 1:N** přes vazební tabulku. Komise chce vidět **logický návrh po rozvinutí**, ne konceptuální M:N šipku. Zadání to říká výslovně: *„ER diagram logického návrhu po normalizaci a rozvinutí relačních vztahů"*.

#### `CREATE TABLE` a domény

```sql
CREATE TABLE studijni_program (
    id_programu  SERIAL       PRIMARY KEY,
    nazev        VARCHAR(100) NOT NULL,
    stupen       VARCHAR(3)   NOT NULL CHECK (stupen IN ('Bc','Mgr','PhD')),
    doba_roky    SMALLINT     NOT NULL CHECK (doba_roky BETWEEN 1 AND 6),
    UNIQUE (nazev, stupen)
);
```

**Základní domény v PostgreSQL:**

| Typ | Kdy |
|---|---|
`INTEGER`, `SMALLINT`, `BIGINT` | celá čísla |
`SERIAL` | automaticky rostoucí ID (moderně `INTEGER GENERATED ALWAYS AS IDENTITY`) |
`NUMERIC(10,2)` | **peníze a přesná desetinná čísla** |
`REAL`, `DOUBLE PRECISION` | přibližná desetinná (ne na peníze!) |
`VARCHAR(n)` | text s limitem |
`TEXT` | text bez limitu — v PostgreSQL stejně rychlý jako VARCHAR |
`CHAR(n)` | fixní délka, doplňuje mezerami (spíš nepoužívat) |
`DATE` | jen datum |
`TIMESTAMP` | datum a čas |
`BOOLEAN` | `TRUE`/`FALSE` |

**Na peníze nikdy `REAL`** — plovoucí čárka nedokáže přesně vyjádřit desetinná čísla a při sčítání se kumuluje chyba. `NUMERIC` je přesný.

**Pořadí vytváření tabulek je dané cizími klíči:** nadřazené první. `studijni_program` → `student` → `predmet` → `zapis`. Kdybys zkusil `student` dřív než `studijni_program`, `REFERENCES` selže.

**Při mazání obráceně** — `DROP TABLE zapis` první, nebo `DROP TABLE ... CASCADE`.

#### Integritní omezení

| Omezení | Co vynutí | Ověřený projev při porušení |
|---|---|---|
| `PRIMARY KEY` | jednoznačnost + `NOT NULL` | `duplicate key value violates unique constraint` |
| `FOREIGN KEY` | odkaz musí existovat | `violates foreign key constraint` |
| `NOT NULL` | hodnota musí být zadaná | `null value in column violates not-null` |
| `UNIQUE` | žádné duplicity | `duplicate key value violates unique constraint` |
| `CHECK` | podmínka na hodnotu | `new row violates check constraint` |

**Vyzkoušel jsem to** — na schématu níž tyhle operace selžou (a to je správně):

| Operace | Selže na |
|---|---|
| dvakrát zapsat téhož studenta na týž předmět | složený `PRIMARY KEY` |
| zapsat neexistujícího studenta | `FOREIGN KEY` |
| ročník 9 | `CHECK (rocnik BETWEEN 1 AND 6)` |
| semestr `'XX'` | `CHECK (semestr IN ('ZS','LS'))` |
| dva předměty téhož názvu | `UNIQUE` |
| smazat studenta, který má zápisy | `FOREIGN KEY` (chrání před osiřelými řádky) |

**Chování cizího klíče při mazání** se dá nastavit — a je to dobrá doptávka:

```sql
id_studenta INTEGER REFERENCES student(id_studenta) ON DELETE CASCADE
--                                                    ^ smaže i zápisy
--   ON DELETE RESTRICT  = zakáže mazání (výchozí chování)
--   ON DELETE SET NULL  = vynuluje odkaz
```

U vazební tabulky `zapis` je `CASCADE` rozumné (zápisy bez studenta nemají smysl), u faktur naopak chceš `RESTRICT`.

#### `INSERT`

```sql
INSERT INTO studijni_program (nazev, stupen, doba_roky) VALUES
 ('Aplikovaná informatika','Bc',3),
 ('Informační systémy','Mgr',2),
 ('Matematická informatika','Bc',3);
```

**Vždycky vypisuj sloupce.** `INSERT INTO t VALUES (...)` bez seznamu závisí na jejich pořadí v tabulce a rozbije se, jak někdo přidá sloupec.

**Se `SERIAL` id nevyplňuj** — nechej ho vygenerovat. Když ho potřebuješ zpátky:

```sql
INSERT INTO student (jmeno, prijmeni) VALUES ('Jiří','Novák')
RETURNING id_studenta;      -- PostgreSQL specialita, hodí se
```

#### `SELECT`, `WHERE`, `ORDER BY`

```sql
SELECT prijmeni, jmeno, datum_narozeni     -- projekce (výběr sloupců)
FROM student
WHERE datum_narozeni >= '2006-01-01'       -- selekce (výběr řádků)
ORDER BY prijmeni ASC, jmeno ASC;          -- řazení
```

**Užitečné ve `WHERE`:**

```sql
WHERE prijmeni LIKE 'Nov%'          -- % = cokoli, _ = jeden znak
WHERE prijmeni ILIKE 'nov%'         -- PostgreSQL: bez ohledu na velikost
WHERE rocnik IN (1, 2)              -- výčet
WHERE rocnik BETWEEN 1 AND 3        -- interval, VČETNĚ obou
WHERE id_programu IS NULL           -- na NULL VŽDY "IS", nikdy "="
WHERE NOT (semestr = 'ZS')
```

**`NULL` se nikdy neporovnává pomocí `=`.** `WHERE x = NULL` nevrátí nic, protože NULL znamená „neznámo" a výsledek srovnání je taky neznámo. Musí být `IS NULL` / `IS NOT NULL`. **Klasická past a častá doptávka.**

#### JOINy

**Tohle je nejdůležitější část dotazovací poloviny okruhu.** Ukážu rozdíl na ověřených datech.

```sql
-- INNER JOIN: jen řádky, které mají partnera na obou stranách
SELECT p.nazev, COUNT(z.id_studenta) AS pocet
FROM predmet p
JOIN zapis z ON z.id_predmetu = p.id_predmetu
GROUP BY p.id_predmetu, p.nazev;
```

Výsledek (přidal jsem předmět, na který se nikdo nezapsal):

```
Algoritmizace              3
Operační systémy           2
Relační databáze bez SQL   2
Základy elektroniky        1
```

**Nezapsaný předmět v seznamu vůbec není** — nemá partnera v `zapis`, takže ho INNER JOIN zahodil.

```sql
-- LEFT JOIN: všechny řádky z levé tabulky, nespárované doplní NULL
SELECT p.nazev, COUNT(z.id_studenta) AS pocet
FROM predmet p
LEFT JOIN zapis z ON z.id_predmetu = p.id_predmetu
GROUP BY p.id_predmetu, p.nazev;
```

```
Algoritmizace              3
Nikým nezapsaný předmět    0     <- objevil se, s nulou
Operační systémy           2
Relační databáze bez SQL   2
Základy elektroniky        1
```

**Pravidlo:** když se ptáš „kolik má každý X", skoro vždy chceš **LEFT JOIN** — jinak ti zmizí ta X, která mají nula.

**A teď past, na kterou se ptají:**

```sql
SELECT p.nazev,
       COUNT(*)             AS pocet_hvezdicka,   -- 1  ← ŠPATNĚ
       COUNT(z.id_studenta) AS pocet_sloupec      -- 0  ← správně
FROM predmet p LEFT JOIN zapis z ON z.id_predmetu = p.id_predmetu
WHERE p.id_predmetu = 5 GROUP BY p.id_predmetu, p.nazev;
```

**`COUNT(*)` počítá řádky**, a LEFT JOIN vyrobil jeden řádek s NULL hodnotami — takže vrátí `1`. **`COUNT(sloupec)` NULL ignoruje** a vrátí správnou `0`. Ověřeno.

**Ostatní typy spojení:**

| Typ | Co vrátí |
|---|---|
`INNER JOIN` | jen spárované (průnik) |
`LEFT JOIN` | vše z levé + spárované z pravé |
`RIGHT JOIN` | vše z pravé + spárované z levé (= LEFT s obrácenými tabulkami) |
`FULL OUTER JOIN` | vše z obou stran |
`CROSS JOIN` | kartézský součin (každý s každým) |

**`RIGHT JOIN` se v praxi skoro nepoužívá** — je to `LEFT JOIN` s prohozenými tabulkami, což se čte lépe. Když se komise zeptá, proč jsi ho nepoužil, tohle je odpověď.

**Spojení tří tabulek** (M:N vazba se prochází přes vazební tabulku):

```sql
SELECT s.prijmeni || ' ' || s.jmeno AS student, p.nazev AS predmet
FROM student s
JOIN zapis z   ON z.id_studenta = s.id_studenta
JOIN predmet p ON p.id_predmetu = z.id_predmetu
ORDER BY s.prijmeni, p.nazev;
```

Ověřený výstup:

```
Dvořáková Anna  | Algoritmizace
Dvořáková Anna  | Relační databáze bez SQL
Malá Eva        | Algoritmizace
Malá Eva        | Základy elektroniky
Novák Jiří      | Algoritmizace
Novák Jiří      | Operační systémy
Novák Jiří      | Relační databáze bez SQL
Černý Petr      | Operační systémy
```

**Student se opakuje** pro každý předmět — to je normální a správné, `JOIN` přes M:N násobí řádky.

#### `GROUP BY` a agregace

```sql
SELECT sp.nazev, sp.stupen, COUNT(s.id_studenta) AS pocet_studentu
FROM studijni_program sp
LEFT JOIN student s ON s.id_programu = sp.id_programu
GROUP BY sp.id_programu, sp.nazev, sp.stupen
ORDER BY sp.nazev ASC;
```

**Agregační funkce:** `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, a v PostgreSQL navíc **`STRING_AGG`**.

**Zásadní pravidlo:** v `SELECT` smí být **jen sloupce z `GROUP BY` a agregační funkce**. Nic jiného. PostgreSQL to vynucuje chybou:

```
ERROR: column "s.jmeno" must appear in the GROUP BY clause
       or be used in an aggregate function
```

**Proč:** kdyby ve skupině bylo pět různých jmen, které z nich má databáze vypsat? Nemá jak rozhodnout. (MySQL to historicky tiše dovolovalo a vracelo náhodné — PostgreSQL je striktní a je to správně.)

**`STRING_AGG` je přímo v zadání** („agregace řetězce se jménem předmětu"):

```sql
SELECT rocnik,
       COUNT(*) AS pocet,
       STRING_AGG(nazev, ', ' ORDER BY nazev) AS predmety
FROM predmet
GROUP BY rocnik
ORDER BY rocnik;
```

Ověřený výstup:

```
1 | 2 | Algoritmizace, Základy elektroniky
2 | 2 | Operační systémy, Relační databáze bez SQL
3 | 1 | Nikým nezapsaný předmět
```

**To `ORDER BY` uvnitř `STRING_AGG` je detail, kterým uděláš dojem** — bez něj je pořadí ve slepenci nedefinované.

**`WHERE` vs. `HAVING`:**

```sql
SELECT rocnik, COUNT(*) AS pocet
FROM predmet
WHERE semestr = 'LS'        -- filtruje ŘÁDKY, PŘED seskupením
GROUP BY rocnik
HAVING COUNT(*) > 1;        -- filtruje SKUPINY, PO seskupení
```

**Pravidlo:** na sloupce `WHERE`, na agregace `HAVING`. `WHERE COUNT(*) > 1` je chyba — v době vyhodnocení `WHERE` agregace ještě neexistuje.

---

### Postup u zkoušky (60 min přípravy)

**0–10 min — analýza návrhu a papír**

1. **Najdi, co je na zadaném návrhu rozbité.** Zadání říká, že ho máš upravit — tak hledej: seznamy v jednom poli (1. NF), tranzitivní závislosti (3. NF), **odvoditelné atributy** (počet studentů!).
2. **Načrtni cílové tabulky** a vazby mezi nimi.
3. **Nakresli ER diagram na papír** — čistě, s vraními nohami, **M:N rozvinuté** na dvě 1:N.

**10–30 min — schéma v psql**

4. Napiš `CREATE TABLE` do **souboru** v editoru, ne přímo do psql — snáz se opravuje.
5. **Pořadí podle cizích klíčů**: nadřazené tabulky první.
6. Spusť: `\i schema.sql`. Zkontroluj `\dt` a `\d tabulka`.

**30–42 min — data**

7. `INSERT` ~3 řádky na tabulku, **se vypsanými sloupci**.
8. Data zvol tak, aby **dotazy měly co ukázat** — někdo bez zápisu, program bez studentů. Tím pak předvedeš rozdíl INNER/LEFT JOIN.

**42–55 min — dotazy**

9. Piš je po jednom a **hned spouštěj**. Zadání chce „odladěné dotazy **včetně výstupů**".
10. **Výstupy si ulož** — `\o vystup.txt` nebo zkopíruj do souboru. Jsou součástí odevzdání.

**55–60 min — kontrola**

11. Projdi zadání bod po bodu, odškrtni.
12. Zkontroluj, že diagram odpovídá tomu, co jsi opravdu vytvořil.

#### Minimum v psql, které musíš znát

```
psql -U uzivatel -d databaze     # připojení
\?                  nápověda k příkazům psql
\h CREATE TABLE     nápověda k SQL syntaxi  ← tohle nahrazuje tahák
\l                  seznam databází
\c databaze         přepnout databázi
\dt                 seznam tabulek
\d tabulka          struktura tabulky (sloupce, klíče, omezení)
\i soubor.sql       spustit SQL ze souboru   ← používej!
\o vystup.txt       přesměrovat výstup do souboru (\o samotné vypne)
\x                  přepnout na svislé zobrazení (dlouhé řádky)
\q                  konec
```

**`\h CREATE TABLE` je tvůj tahák** — vypíše celou syntaxi včetně omezení. Když si nejsi jistý, nehádej.

---

### Rozbor ukázkové úlohy

> Konceptuální návrh databáze studentů a předmětů. **Tento návrh je nutno upravit** (normalizovat, odstranit přebytečné atributy apod.).
>
> **student:** jméno (Jiří Novák) · datum narození · studijní program (Aplikovaná informatika, Bc) · **doba trvání studijního programu v rocích (3)**
> **předmět:** jméno · **počet studentů (120)** · ročník a semestr (2. LS)
> **vztah:** student studuje předmět

#### Co je na zadaném návrhu špatně

**Tohle je jádro úlohy.** Pět vad, každá jiného typu:

| # | Vada | Která forma / princip | Oprava |
|---|---|---|---|
| 1 | **„jméno" = „Jiří Novák"** — dvě informace v jednom poli | **1. NF** (atomicita) | rozdělit na `jmeno` a `prijmeni` |
| 2 | **„studijní program" = „Aplikovaná informatika, Bc"** — název a stupeň v jednom | **1. NF** | rozdělit na `nazev` a `stupen` |
| 3 | **„doba trvání programu"** u studenta | **3. NF** (tranzitivní závislost) | vlastní tabulka `studijni_program` |
| 4 | **„počet studentů" u předmětu** | **odvoditelný atribut** | **smazat** — spočítá se `COUNT` |
| 5 | **„ročník a semestr" = „2. LS"** | **1. NF** | rozdělit na `rocnik` a `semestr` |

**Vada 3 podrobně** (nejlepší materiál na obhajobu): `student.doba_trvani` závisí na `student.program`, který závisí na `student.id`. To je **tranzitivní závislost** `id → program → doba_trvani`, tedy porušení 3. NF. Praktický důsledek: kdyby se délka bakaláře změnila ze 3 na 4 roky, musel bys to přepsat u **všech** studentů, a při jednom opomenutí máš v databázi rozpor.

**Vada 4 podrobně** (druhá nejlepší): „počet studentů: 120" je **odvoditelná hodnota** — plyne z tabulky zápisů. Držet ji zvlášť znamená, že se při každém zápisu musí ručně aktualizovat, jinak přestane platit. To je **redundance**, ne normalizační porušení v úzkém smyslu. Správně se spočítá dotazem:

```sql
SELECT p.nazev, COUNT(z.id_studenta) AS pocet_zapsanych
FROM predmet p LEFT JOIN zapis z ON z.id_predmetu = p.id_predmetu
GROUP BY p.id_predmetu, p.nazev;
```

Ověřený výstup na testovacích datech:

```
Algoritmizace              3
Operační systémy           2
Relační databáze bez SQL   2
Základy elektroniky        1
```

**Vztah „student studuje předmět" je M:N** → vazební tabulka `zapis` se složeným PK.

#### Cílové schéma — čtyři tabulky

```
studijni_program 1 ──< N student N >──── zapis ────< N predmet
                                    (M:N rozvinuto)
```

Celé SQL je v [`Kod/`](./Kod/), tady jen podstatné:

```sql
CREATE TABLE studijni_program (
    id_programu SERIAL       PRIMARY KEY,
    nazev       VARCHAR(100) NOT NULL,
    stupen      VARCHAR(3)   NOT NULL CHECK (stupen IN ('Bc','Mgr','PhD')),
    doba_roky   SMALLINT     NOT NULL CHECK (doba_roky BETWEEN 1 AND 6),
    UNIQUE (nazev, stupen)          -- program je dán názvem A stupněm
);

CREATE TABLE student (
    id_studenta    SERIAL       PRIMARY KEY,
    jmeno          VARCHAR(50)  NOT NULL,
    prijmeni       VARCHAR(50)  NOT NULL,     -- vada 1 opravena
    datum_narozeni DATE         NOT NULL,
    id_programu    INTEGER      NOT NULL      -- vada 3: FK místo duplicity
                   REFERENCES studijni_program(id_programu)
);

CREATE TABLE predmet (
    id_predmetu SERIAL       PRIMARY KEY,
    nazev       VARCHAR(100) NOT NULL UNIQUE,
    rocnik      SMALLINT     NOT NULL CHECK (rocnik BETWEEN 1 AND 6),
    semestr     VARCHAR(2)   NOT NULL CHECK (semestr IN ('ZS','LS'))
    -- vada 4: žádný "pocet_studentu"! Spočítá se dotazem.
);

CREATE TABLE zapis (
    id_studenta INTEGER NOT NULL REFERENCES student(id_studenta)  ON DELETE CASCADE,
    id_predmetu INTEGER NOT NULL REFERENCES predmet(id_predmetu)  ON DELETE CASCADE,
    PRIMARY KEY (id_studenta, id_predmetu)   -- brání dvojímu zápisu
);
```

**Proč `UNIQUE (nazev, stupen)` a ne jen `nazev`:** „Aplikovaná informatika" existuje jako Bc i Mgr — jsou to dva různé programy se stejným názvem. Kombinace je jednoznačná, samotný název ne.

#### Dotazy ze zadání — ověřené výstupy

**a) Všichni studenti a jména předmětů, které studují**

```sql
SELECT s.prijmeni || ' ' || s.jmeno AS student, p.nazev AS predmet
FROM student s
JOIN zapis z   ON z.id_studenta = s.id_studenta
JOIN predmet p ON p.id_predmetu = z.id_predmetu
ORDER BY s.prijmeni, p.nazev;
```

```
Dvořáková Anna  | Algoritmizace
Dvořáková Anna  | Relační databáze bez SQL
Malá Eva        | Algoritmizace
Malá Eva        | Základy elektroniky
Novák Jiří      | Algoritmizace
Novák Jiří      | Operační systémy
Novák Jiří      | Relační databáze bez SQL
Černý Petr      | Operační systémy
```

**Na co se zeptají:** *„Proč INNER JOIN a ne LEFT?"* — Zadání chce studenty **a předměty, které studují**. Student bez zápisu by měl prázdný předmět, což tu nedává smysl. Kdyby zadání znělo „všichni studenti a případně jejich předměty", použil bych LEFT JOIN.

**b) Studijní programy a počty studentů, vzestupně podle názvu**

```sql
SELECT sp.nazev AS program, sp.stupen, COUNT(s.id_studenta) AS pocet_studentu
FROM studijni_program sp
LEFT JOIN student s ON s.id_programu = sp.id_programu
GROUP BY sp.id_programu, sp.nazev, sp.stupen
ORDER BY sp.nazev ASC;
```

```
Aplikovaná informatika   | Bc  | 2
Fyzikální informatika    | Bc  | 0     <- program bez studentů, díky LEFT JOIN
Informační systémy       | Mgr | 1
Matematická informatika  | Bc  | 1
```

**Tady je LEFT JOIN klíčový** a je to nejlepší místo na obhajobu: program, na kterém **nikdo nestuduje**, se má objevit s nulou. INNER JOIN by ho zahodil. A `COUNT(s.id_studenta)` místo `COUNT(*)` — jinak by u prázdného programu vyšla 1 místo 0.

**c) Předměty seskupené podle ročníku, agregace názvů**

```sql
SELECT rocnik,
       COUNT(*) AS pocet_predmetu,
       STRING_AGG(nazev, ', ' ORDER BY nazev) AS predmety
FROM predmet
GROUP BY rocnik
ORDER BY rocnik;
```

```
1 | 2 | Algoritmizace, Základy elektroniky
2 | 2 | Operační systémy, Relační databáze bez SQL
3 | 1 | Nikým nezapsaný předmět
```

Zadání říká „agregace řetězce se jménem předmětu" — to je přesně `STRING_AGG`.

---

### Příklady na procvičení

SQL skripty jsou v [`Kod/`](./Kod/). U každého si nastav 40 minut a **napiš to sám, než se koukneš**.

#### Příklad 1 — knihovna

> Konceptuální návrh: **kniha** (název, autor „Karel Čapek, 1890–1938", ISBN, počet výpůjček), **čtenář** (jméno „Jan Novák", adresa „Ústí nad Labem, 40001", členství od). Vztah: čtenář si půjčuje knihy.
>
> Normalizujte, nakreslete ER diagram, vytvořte tabulky s daty a dotazy: 1. které knihy má který čtenář půjčené · 2. počet výpůjček podle autora · 3. čtenáři, kteří nemají nic půjčené

*Co je rozbité:* autor s daty života v jednom poli (1. NF + vlastní entita), adresa v jednom poli, „počet výpůjček" je odvoditelný, výpůjčka je M:N **s atributem** (datum půjčení, vrácení).

*Klíčové:* vazební tabulka `vypujcka` má vlastní atributy, takže je to plnohodnotná entita. Třetí dotaz vyžaduje `LEFT JOIN ... WHERE ... IS NULL`.

#### Příklad 2 — objednávky v e-shopu

> **zákazník** (jméno, e-mail, město), **produkt** (název, cena, kategorie „Elektronika/Notebooky"), **objednávka** (datum, zákazník, seznam produktů s množstvím, celková cena).
>
> Dotazy: 1. objednávky s celkovou cenou (spočítanou!) · 2. top 3 nejprodávanější produkty · 3. obrat podle kategorií · 4. zákazníci bez objednávky

*Co je rozbité:* „seznam produktů" v objednávce (1. NF), „celková cena" je odvoditelná (SUM), kategorie s podkategorií v jednom poli.

*Klíčové:* vazební tabulka `objednavka_polozka` s **množstvím a cenou v době objednání** (cena produktu se může změnit, historickou cenu musíš uchovat). To je věc, kterou u obhajoby oceníte.

---

### Co si nacvičit

SQL skripty jsou ve složce [`Kod/`](./Kod/) — v PostgreSQL syntaxi, tedy přesně to, co budeš mít u zkoušky:

| Soubor | Co to je |
|---|---|
| [`01-schema.sql`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/09-databazove-systemy/Kod/01-schema.sql) | `CREATE TABLE`, **s komentářem ke každé opravené vadě** |
| [`02-data.sql`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/09-databazove-systemy/Kod/02-data.sql) | `INSERT` s daty zvolenými tak, aby dotazy měly co ukázat |
| [`03-dotazy.sql`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/09-databazove-systemy/Kod/03-dotazy.sql) | tři dotazy ze zadání + demonstrace INNER/LEFT JOIN a pastí |
| [`04-omezeni-test.sql`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/09-databazove-systemy/Kod/04-omezeni-test.sql) | osm operací, které **mají selhat** — důkaz, že omezení zabírají |
| [`priklady/`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/09-databazove-systemy/Kod/priklady) | dvě cvičné úlohy s řešením (knihovna, e-shop) |

Spuštění: `\i 01-schema.sql`, pak `02-data.sql`, `03-dotazy.sql`. Výstupy do souboru přes `\o vystup.txt`.

- [ ] **Ukázková úloha z PDF celá** — diagram na papír, schéma, data, tři dotazy s výstupy
- [ ] **Zpaměti: pět vad zadaného návrhu** a která forma se u které porušuje
- [ ] Aspoň jeden [příklad na procvičení](#příklady-na-procvičení)
- [ ] **Kreslení ER diagramu vraními nohami od ruky** — je to jediný výstup na papíře
- [ ] **Rozdíl INNER vs. LEFT JOIN předvést na vlastních datech** (proto ta data s nezapsaným předmětem)
- [ ] `COUNT(*)` vs. `COUNT(sloupec)` u LEFT JOIN — vědět, proč to dá jiný výsledek
- [ ] `STRING_AGG` — je přímo v zadání, umět zpaměti včetně `ORDER BY` uvnitř
- [ ] `WHERE` vs. `HAVING` a proč `WHERE COUNT(*)` nefunguje
- [ ] Normalizace 1. → 2. → 3. NF s vlastním příkladem porušení
- [ ] `\h CREATE TABLE`, `\d tabulka`, `\i soubor.sql` v psql

---

### Poznámky

<!-- Sem vlastní výpisky, SQL, schémata. -->

---

### Na co se doptají

- **Ve které normální formě je tvůj původní návrh a co ji porušuje?** — Zadaný návrh není ani v **1. NF**: „Jiří Novák" a „Aplikovaná informatika, Bc" nejsou atomické hodnoty. Po rozdělení by porušoval **3. NF** kvůli tranzitivní závislosti `student → program → doba_trvani`. A navíc obsahuje **odvoditelný atribut** „počet studentů".
- **Proč jsi tady dal LEFT JOIN a ne INNER?** — Protože se ptám „kolik studentů má **každý** program" — program bez studentů se musí objevit s nulou. INNER JOIN by ho vynechal. Ověřil jsem to na datech.
- **Co se stane, když dáš do SELECTu sloupec, který není v GROUP BY?** — PostgreSQL vyhodí chybu `column must appear in the GROUP BY clause or be used in an aggregate function`. Logicky proto, že ve skupině může být víc různých hodnot a databáze nemá jak vybrat.
- **Jak vynutíš, aby se student nezapsal na stejný předmět dvakrát?** — **Složeným primárním klíčem** `PRIMARY KEY (id_studenta, id_predmetu)` na vazební tabulce. Je to zdarma, žádné další omezení není potřeba.
- **Proč jsi odstranil „počet studentů"?** — Je **odvoditelný** z tabulky zápisů přes `COUNT`. Držet ho zvlášť by znamenalo aktualizovat ho při každém zápisu a riskovat, že přestane odpovídat skutečnosti.
- **Jaký je rozdíl mezi `COUNT(*)` a `COUNT(sloupec)`?** — `COUNT(*)` počítá **řádky**, `COUNT(sloupec)` počítá **nenulové hodnoty**. U LEFT JOIN bez partnera vyrobí spojení jeden řádek s NULL, takže `COUNT(*)` dá 1, ale `COUNT(sloupec)` správně 0.
- **Kdy `WHERE` a kdy `HAVING`?** — `WHERE` filtruje **řádky před seskupením**, `HAVING` **skupiny po seskupení**. Na agregace jde jen `HAVING` — v době vyhodnocení `WHERE` agregace ještě neexistuje.
- **Proč `IS NULL` a ne `= NULL`?** — NULL znamená „neznámá hodnota", takže výsledek jakéhokoli srovnání s ní je taky neznámý (ne `TRUE`). `WHERE x = NULL` proto nevrátí nikdy nic.
- **Co je referenční integrita a jak ji vynutíš?** — Že cizí klíč odkazuje na **existující** řádek. Vynutí ji `FOREIGN KEY ... REFERENCES`. Databáze pak nedovolí vložit odkaz na neexistující záznam ani smazat záznam, na který se odkazuje (podle `ON DELETE`).
- **Kdy použít `ON DELETE CASCADE` a kdy `RESTRICT`?** — `CASCADE` tam, kde závislé záznamy bez rodiče nemají smysl (zápisy studenta). `RESTRICT` tam, kde by mazání zničilo historii (faktury zákazníka).
- **Proč je M:N vazba realizovaná třetí tabulkou?** — Relační model neumí vyjádřit M:N přímo — musel by být „seznam" v jednom sloupci, což porušuje 1. NF. Vazební tabulka to rozloží na dvě 1:N.
- **Jaký typ použiješ na peníze a proč ne `REAL`?** — `NUMERIC(10,2)`. `REAL` je plovoucí čárka, která nedokáže přesně vyjádřit desetinná čísla — chyby se při sčítání kumulují a účetnictví přestane souhlasit.
- **V jakém pořadí vytváříš tabulky a proč?** — **Nadřazené první**, protože `REFERENCES` vyžaduje, aby cílová tabulka existovala. Při mazání obráceně, nebo `CASCADE`.
- **Kolik řádků vrátí spojení přes M:N?** — Až součin — student se třemi předměty se objeví třikrát. Je to správně, ale při agregacích si to musíš uvědomit (jinak dostaneš nafouknuté součty).
- **Co je složený primární klíč a kdy vzniká?** — PK ze dvou a víc sloupců. Typicky u **vazební tabulky** M:N vztahu, kde je řádek identifikovaný kombinací obou cizích klíčů.

---

### Užitečné odkazy

- Dokumentace PostgreSQL: <https://www.postgresql.org/docs/current/>
- Nápověda přímo v psql: `\h CREATE TABLE`, `\?`
- Rozšířená verze pro SZZVP (transakce, procedury, OLAP): [SZZVP okruh 1](../../SZZVP/01-relacni-db-a-olap/)
