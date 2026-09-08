## 1 — Relační databázové systémy a OLAP databáze

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-DB.pdf)

### Požadované znalosti a dovednosti

- konceptuální, logický a fyzický návrh; normalizace 1.–3. NF, ER diagram (vraní nohy)
- SELECT, JOINy, WHERE, ORDER BY, GROUP BY
- transakce, analytické (okenní) funkce
- uložené procedury včetně triggerů, rekurzivní dotazy
- programový přístup k databázím (kurzory, ORM)
- vizualizace (Matplotlib)
- OLAP a jeho druhy (ROLAP, MOLAP, HOLAP), OLTP vs. OLAP
- architektura multidimenzionálních databází (fakta a dimenze), modely star a snowflake

### Charakteristika zkušební úlohy

Návrh a naplnění relační databáze z Open Dat, propojení zdrojů, analytické dotazy, vizualizace a návrh multidimenzionálního modelu datového skladu. Prostředí: Docker s PostgreSQL + Python (NumPy, Pandas) + DBeaver.

### Postup řešení úlohy

Pořadí kroků má význam — každý další stojí na předchozím. Nepřeskakuj návrh a nezačínej `CREATE TABLE`.

**1. Nejdřív se podívej do dat, teprve pak navrhuj.** Stáhni oba zdroje a otevři je (`head -5 soubor.csv`, v Pythonu `pd.read_csv(...).head()`). Zjišťuješ tři věci:

- **Jaký je klíč, přes který se zdroje spojí?** Tohle je nejčastější místo, kde úloha spadne. ČSÚ dává české názvy zemí („Německo"), Světová banka kódy ISO-3 („DEU"), Eurostat občas ISO-2 („DE"). Přes tohle `JOIN` nespojíš nic.
- **Kde jsou chybějící hodnoty?** (`df.isna().sum()`)
- **Jaké jsou datové typy?** Pozor na čísla uložená jako text s mezerou jako oddělovačem tisíců („1 234“) a na desetinnou čárku místo tečky.

**2. Navrhni ER diagram — na papír nebo do PlantUML.** Až potom piš SQL. Pravidla:

- každá **entita** = tabulka (země, měření, kategorie)
- vztah **1:N** = cizí klíč na straně N
- vztah **M:N** = **vazební tabulka** se složeným primárním klíčem
- **3. NF**: žádný neklíčový atribut nezávisí na jiném neklíčovém. Když máš v tabulce `cizinci` sloupec `nazev_zeme`, je to porušení — název patří do tabulky `zeme`.

**3. Vytvoř schéma (`schema.sql`).** Ne ručně v DBeaveru — do souboru, aby šlo znovu spustit. Na začátek `DROP TABLE IF EXISTS ... CASCADE;`, ať můžeš iterovat.

**4. ETL přes staging tabulku.** Nesnaž se vkládat rovnou do cílových tabulek:

```
CSV → staging tabulka (všechno TEXT, žádná omezení) → SQL čištění → cílové tabulky
```

Proč: když ti import spadne na půlce kvůli jednomu řádku, staging tabulka ti umožní podívat se, co se nenačetlo. Vkládání rovnou znamená, že hledáš chybu v Pythonu naslepo.

**5. Ověř integritu po importu**, než začneš dotazovat:

```sql
SELECT COUNT(*) FROM cizinci;                    -- načetlo se všechno?
SELECT COUNT(*) FROM cizinci c
  LEFT JOIN zeme z ON c.iso3 = z.iso3
  WHERE z.iso3 IS NULL;                          -- kolik řádků se nespáruje?
```

Když druhý dotaz vrátí nenulové číslo, máš problém s identifikátory — vrať se ke kroku 1. **Tohle je ta kontrola, kterou lidi vynechají a pak prezentují graf ze třetiny dat.**

**6. Dotazy piš od nejjednoduššího.** Nejdřív `SELECT * LIMIT 10`, pak `JOIN`, pak `GROUP BY`, pak okenní funkce. Každý mezikrok si ověř očima.

**7. Vizualizace** — Matplotlib, ale data taháš **z databáze** (`pd.read_sql`), ne z původního CSV. Zkoušející se na to ptá.

**8. Návrh datového skladu jako samostatný diagram.** Není to úprava OLTP schématu, je to nový model:

- **faktová tabulka** = to, co měříš (počet cizinců) + cizí klíče do dimenzí
- **dimenze** = podle čeho to řežeš (země, rok, věk, pohlaví)
- **star** = dimenze ploché (denormalizované), **snowflake** = dimenze dál rozložené do 3. NF

Stačí diagram a `CREATE TABLE` skript, nemusíš ho plnit daty — ale řekni to nahlas u obhajoby.

### Checklist odevzdání

Společné (chce to každé zadání SZZVP):

- [ ] funkční řešení, spustitelné podle README
- [ ] zdrojový kód v **Git repozitáři** (GitHub/GitLab), ne ZIP
- [ ] rozumná historie commitů — ne jeden commit „final"
- [ ] uživatelská příručka (stačí `README.md`): jak to spustit, co to dělá
- [ ] komentáře v kódu

Specifické pro tento okruh (přímo z PDF):

- [ ] **ER diagram** logického modelu
- [ ] **DM diagram** — multidimenzionální model datového skladu (star/snowflake)
- [ ] skripty: `schema.sql`, ETL skript, `queries.sql`
- [ ] přehledné výstupy — **agregace dat** (`GROUP BY`)
- [ ] vizualizace
- [ ] zdůvodnění návrhu: proč tyhle tabulky, proč tenhle klíč

Když zbyde čas, tohle přidává body a zadání to jmenuje:

- [ ] transakce kolem importu
- [ ] okenní (analytická) funkce aspoň v jednom dotazu
- [ ] uložená procedura nebo trigger
- [ ] rekurzivní dotaz (`WITH RECURSIVE`), pokud v datech je hierarchie

### Pasti a časté chyby

- **Nespárované identifikátory.** Popsáno výš — kontroluj `LEFT JOIN ... WHERE ... IS NULL`.
- **`INNER JOIN` tiše zahodí data.** Když spojuješ cizince s HDP a pro pár zemí HDP chybí, `INNER JOIN` je vymaže z výsledku a ty si toho nevšimneš. Použij `LEFT JOIN` a chybějící hodnoty vyřeš vědomě.
- **`COUNT(*)` vs. `COUNT(sloupec)`.** První počítá řádky, druhý nenulové hodnoty. U `GROUP BY` s `LEFT JOIN` to dělá rozdíl.
- **Chybějící cizí klíče.** Databáze bez `REFERENCES` je jen sada CSV. Zkoušející se na integritní omezení ptá.
- **Desetinná čárka a mezery v číslech** z českých zdrojů — `NUMERIC` sloupec je nepřijme.
- **Míchání OLTP a OLAP schématu.** Datový sklad je *jiný* model, ne přejmenované tabulky.
- **Vizualizace z CSV místo z databáze** — celá práce s DB pak vypadá jako ozdoba.

### Technické minimum

```bash
# PostgreSQL v Dockeru
docker run --name pg -e POSTGRES_PASSWORD=heslo -e POSTGRES_DB=szz \
  -p 5432:5432 -d postgres:16

# připojení klientem uvnitř kontejneru
docker exec -it pg psql -U postgres -d szz

# spuštění skriptu ze souboru
docker exec -i pg psql -U postgres -d szz < schema.sql
```

```bash
pip install pandas sqlalchemy psycopg2-binary matplotlib
```

```python
from sqlalchemy import create_engine
import pandas as pd

eng = create_engine("postgresql+psycopg2://postgres:heslo@localhost:5432/szz")

# načtení DataFrame do tabulky (ideální pro staging)
df.to_sql("staging_cizinci", eng, if_exists="replace", index=False)

# čtení zpět pro vizualizaci
vysledek = pd.read_sql("SELECT * FROM v_cizinci_hdp", eng)
```

DBeaver: `Database → New Connection → PostgreSQL`, host `localhost`, port `5432`.

### Řešení ukázkové úlohy

**Zadání z PDF:** propojit *Cizinci podle státního občanství, věku a pohlaví (2019)* s *HDP na hlavu pro jednotlivé státy*, navrhnout DB, naplnit ji skriptem, spojit, agregovat, vizualizovat a navrhnout datový sklad.

#### Návrh schématu — proč tři tabulky a ne jedna

Kdyby bylo všechno v jedné tabulce, název země a HDP by se opakovaly u každého řádku (každý věk × pohlaví). To je porušení 3. NF a znamená to aktualizační anomálie — při opravě HDP musíš přepsat stovky řádků.

```sql
DROP TABLE IF EXISTS cizinci, hdp, zeme CASCADE;

-- číselník zemí: jediné místo, kde žije název a kód
CREATE TABLE zeme (
    iso3        CHAR(3)     PRIMARY KEY,
    nazev_cz    TEXT        NOT NULL UNIQUE
);

-- fakta o cizincích: 1:N na zeme
CREATE TABLE cizinci (
    id          SERIAL      PRIMARY KEY,
    iso3        CHAR(3)     NOT NULL REFERENCES zeme(iso3),
    rok         SMALLINT    NOT NULL,
    pohlavi     CHAR(1)     NOT NULL CHECK (pohlavi IN ('M','Z')),
    vek_od      SMALLINT    NOT NULL,
    vek_do      SMALLINT    NOT NULL,
    pocet       INTEGER     NOT NULL CHECK (pocet >= 0),
    UNIQUE (iso3, rok, pohlavi, vek_od, vek_do)
);

-- HDP: 1:N na zeme, jeden řádek na zemi a rok
CREATE TABLE hdp (
    iso3            CHAR(3)  NOT NULL REFERENCES zeme(iso3),
    rok             SMALLINT NOT NULL,
    hdp_na_hlavu    NUMERIC(12,2),
    PRIMARY KEY (iso3, rok)
);

CREATE INDEX idx_cizinci_iso3 ON cizinci(iso3);
```

Všimni si tří věcí, na které se zkoušející ptá: **`UNIQUE` na přirozeném klíči** (brání duplicitnímu importu), **`CHECK`** (doménová integrita) a **index na sloupci, přes který se `JOIN`uje**.

#### Past číslo jedna: různé identifikátory zemí

ČSÚ říká „Německo", Světová banka „DEU". Řešení je překladová tabulka, kterou naplníš při ETL:

```python
MAPA = {"Německo": "DEU", "Slovensko": "SVK", "Ukrajina": "UKR", ...}

df["iso3"] = df["stat"].str.strip().map(MAPA)
nespojene = df[df["iso3"].isna()]["stat"].unique()
print("Nepodařilo se přeložit:", nespojene)   # tohle si VYPIŠ
```

Ten `print` je důležitý — bez něj nevíš, že jsi ztratil polovinu zemí. U obhajoby řekni, kolik jich bylo a jak jsi to řešil.

#### ETL přes staging

```python
import pandas as pd
from sqlalchemy import create_engine, text

eng = create_engine("postgresql+psycopg2://postgres:heslo@localhost:5432/szz")

# 1) syrová data do staging (všechno text, nic se nevaliduje)
raw = pd.read_csv("cizinci2019.csv", sep=";", encoding="utf-8", dtype=str)
raw.to_sql("staging_cizinci", eng, if_exists="replace", index=False)

# 2) čištění v pandas
raw["pocet"] = (raw["pocet"].str.replace(" ", "", regex=False)
                            .str.replace(",", ".", regex=False)
                            .astype("Int64"))
raw["iso3"] = raw["stat"].str.strip().map(MAPA)
cist = raw.dropna(subset=["iso3", "pocet"])

# 3) číselník zemí NEJDŘÍV (kvůli cizímu klíči)
zeme = cist[["iso3", "stat"]].drop_duplicates().rename(columns={"stat": "nazev_cz"})
zeme.to_sql("zeme", eng, if_exists="append", index=False)

# 4) fakta až potom, celé v transakci
with eng.begin() as con:                      # begin() = commit/rollback automaticky
    cist[["iso3","rok","pohlavi","vek_od","vek_do","pocet"]] \
        .to_sql("cizinci", con, if_exists="append", index=False)
```

Pořadí `zeme` → `cizinci` není libovolné: cizí klíč vyžaduje, aby rodičovský řádek existoval dřív. `with eng.begin()` je ta **transakce**, na kterou se ptají — když import spadne, neuloží se nic a databáze zůstane konzistentní.

#### Kontrola, kterou nesmíš vynechat

```sql
-- kolik faktů nemá zemi? Musí vyjít 0
SELECT COUNT(*) FROM cizinci c
LEFT JOIN zeme z ON c.iso3 = z.iso3 WHERE z.iso3 IS NULL;

-- pro kolik zemí chybí HDP? Tohle si zapamatuj pro obhajobu
SELECT COUNT(DISTINCT c.iso3) FROM cizinci c
LEFT JOIN hdp h ON c.iso3 = h.iso3 AND h.rok = 2019
WHERE h.iso3 IS NULL;
```

#### Klíčové dotazy

Seskupení podle státního občanství:

```sql
SELECT z.nazev_cz, SUM(c.pocet) AS celkem
FROM cizinci c
JOIN zeme z ON z.iso3 = c.iso3
WHERE c.rok = 2019
GROUP BY z.nazev_cz
ORDER BY celkem DESC
LIMIT 15;
```

Cizinci podle pásma HDP země původu — tohle je ten dotaz, o který v úloze jde:

```sql
SELECT
    CASE
        WHEN h.hdp_na_hlavu <  5000 THEN 'do 5 tis.'
        WHEN h.hdp_na_hlavu < 20000 THEN '5–20 tis.'
        WHEN h.hdp_na_hlavu < 50000 THEN '20–50 tis.'
        ELSE                              'nad 50 tis.'
    END                       AS pasmo_hdp,
    SUM(c.pocet)              AS pocet_cizincu,
    COUNT(DISTINCT c.iso3)    AS pocet_zemi
FROM cizinci c
LEFT JOIN hdp h ON h.iso3 = c.iso3 AND h.rok = c.rok
WHERE c.rok = 2019
GROUP BY 1
ORDER BY MIN(h.hdp_na_hlavu);
```

`LEFT JOIN` schválně — země bez HDP spadnou do `NULL` skupiny a ty je uvidíš, místo aby zmizely.

Okenní funkce (zadání je jmenuje, stojí dva řádky navíc):

```sql
SELECT z.nazev_cz,
       SUM(c.pocet) AS celkem,
       RANK()       OVER (ORDER BY SUM(c.pocet) DESC)               AS poradi,
       ROUND(100.0 * SUM(c.pocet) / SUM(SUM(c.pocet)) OVER (), 2)   AS podil_pct
FROM cizinci c JOIN zeme z ON z.iso3 = c.iso3
GROUP BY z.nazev_cz;
```

To vnořené `SUM(SUM(...)) OVER ()` je součet přes celý výsledek — okenní funkce se vyhodnocuje **až po** `GROUP BY`, proto to takhle jde. Umět tohle vysvětlit je přesně ten typ otázky, co u obhajoby padne.

#### Vizualizace

```python
import matplotlib.pyplot as plt

df = pd.read_sql("""
    SELECT z.nazev_cz, SUM(c.pocet) AS celkem
    FROM cizinci c JOIN zeme z ON z.iso3 = c.iso3
    GROUP BY z.nazev_cz ORDER BY celkem DESC LIMIT 10
""", eng)                                    # z DATABÁZE, ne z CSV

fig, ax = plt.subplots(figsize=(9, 5))
ax.barh(df["nazev_cz"], df["celkem"])
ax.invert_yaxis()
ax.set_xlabel("Počet cizinců")
ax.set_title("10 nejčastějších státních občanství, 2019")
fig.tight_layout()
fig.savefig("cizinci_top10.png", dpi=150)
```

#### Návrh datového skladu (star schema)

Fakt = **počet cizinců**, dimenze = **země, čas, věk, pohlaví**:

```sql
CREATE TABLE dim_zeme (
    zeme_key      SERIAL PRIMARY KEY,      -- zástupný (surrogate) klíč
    iso3          CHAR(3),
    nazev_cz      TEXT,
    kontinent     TEXT,                    -- denormalizováno = star
    pasmo_hdp     TEXT
);
CREATE TABLE dim_cas   (cas_key SERIAL PRIMARY KEY, rok SMALLINT, ctvrtleti SMALLINT);
CREATE TABLE dim_vek   (vek_key SERIAL PRIMARY KEY, vek_od SMALLINT, vek_do SMALLINT, skupina TEXT);
CREATE TABLE dim_pohl  (pohl_key SERIAL PRIMARY KEY, pohlavi CHAR(1), popis TEXT);

CREATE TABLE fact_cizinci (
    zeme_key  INT REFERENCES dim_zeme,
    cas_key   INT REFERENCES dim_cas,
    vek_key   INT REFERENCES dim_vek,
    pohl_key  INT REFERENCES dim_pohl,
    pocet     INTEGER NOT NULL,            -- míra (measure)
    PRIMARY KEY (zeme_key, cas_key, vek_key, pohl_key)
);
```

Argumentace pro obhajobu ve třech větách:

- **Proč star a ne snowflake:** dimenze jsou malé a čtou se pořád dokola. Denormalizace ušetří `JOIN`y, a redundance nevadí — sklad se nezapisuje transakčně, plní se dávkově, takže aktualizační anomálie nehrozí.
- **Proč zástupné klíče** místo `iso3`: přežijí změnu zdrojového číselníku a umožní pomalu se měnící dimenze (SCD) — historii, kdy země patřila do jiného pásma HDP.
- **Kdyby dimenze byly obří** (miliony řádků, hluboká hierarchie), snowflake se vyplatí kvůli místu. Tady ne.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a co bylo cílem (30 s)
2. Datové zdroje a jejich problémy — nekonzistentní identifikátory, chybějící data
3. ER diagram návrhu a proč zrovna takhle
4. ETL skript — jak jsem data čistil a vkládal
5. Klíčové dotazy a jejich výstupy
6. Vizualizace a co z ní plyne
7. Návrh datového skladu (star schema: faktová tabulka + dimenze)
8. Co bych udělal jinak / co by šlo dál

### Na co se doptají (diskuse po prezentaci)

- V čem se liší OLTP a OLAP a proč se pro ně navrhuje schéma jinak?
- Proč star a ne snowflake (nebo naopak)?
- Co je ROLAP, MOLAP, HOLAP?
- Vysvětli ACID na své transakci.
- K čemu by se ti tady hodila okenní funkce?
- Jak bys řešil rekurzivní dotaz nad hierarchií?

### Užitečné odkazy

- Dokumentace PostgreSQL: <https://www.postgresql.org/docs/current/>
- Okenní funkce (tutoriál v dokumentaci): <https://www.postgresql.org/docs/current/tutorial-window.html>
- Matplotlib: <https://matplotlib.org/stable/index.html>
- Otevřená data ČSÚ: <https://csu.gov.cz/otevrena-data>
- World Bank Open Data (HDP na hlavu): <https://data.worldbank.org/>
