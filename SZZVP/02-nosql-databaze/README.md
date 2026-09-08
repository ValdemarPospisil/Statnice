## 2 — NoSQL databáze

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-DB.pdf)

### Požadované znalosti a dovednosti

- dokumentově orientované databáze (MongoDB, BJSON v PostgreSQL)
- programové vytváření a plnění databáze
- dotazy nad databází
- agregační pipelines
- vizualizace (Matplotlib)

### Charakteristika zkušební úlohy

Návrh optimálního NoSQL modelu pro Open Data — včetně **zdůvodnění, proč je či není vhodné zvolit SQL databázi**. Vytvoření databáze v MongoDB, programové načtení dat, dotazy (preferovány agregační) a vizualizace. Prostředí: Docker s MongoDB + Python.

### Postup řešení úlohy

**1. Nejdřív rozhodni o modelu, pak teprve pracuj.** U tohohle okruhu se nehodnotí to, že jsi něco nasypal do Mongo, ale **proč jsi data uspořádal takhle**. Zadání to říká přímo: součástí výstupu je *zdůvodnění, proč je či není vhodné zvolit SQL databázi*.

Rozhodovací pravidlo, které si zapamatuj — **vnořit, nebo referencovat?**

| Vnoř (embed) | Referencuj |
|---|---|
| data se čtou vždy společně | podřízená data se čtou samostatně |
| poměr 1:málo (jedna země × pár měření) | 1:mnoho neomezené (statisíce záznamů) |
| podřízená část se nemění nezávisle | mění se často a samostatně |
| chceš atomický zápis celku | dokument by přerostl **16 MB** (tvrdý limit Mongo) |

**2. Prohlédni si data** stejně jako u relační úlohy: klíč pro spojení, chybějící hodnoty, typy. Past s identifikátory zemí (Německo × DEU × DE) je tu úplně stejná — MongoDB tě před ní nechrání ani tak, jak by cizí klíč v Postgresu.

**3. Navrhni tvar dokumentu a napiš si ho na papír** dřív, než ho vygeneruješ. Typicky vyjde jeden ze dvou tvarů:

- **dokument = země**, uvnitř pole měření → dobré, když se ptáš „ukaž mi vše o Ukrajině"
- **dokument = jedno měření** s vnořeným podobjektem země → dobré pro agregace napříč zeměmi

Pro ukázkovou úlohu je lepší druhý (agregace jsou to hlavní, co se chce).

**4. Denormalizuj vědomě.** Zkopírovat HDP země do každého měření je v Mongo správně, ne chyba — ale musíš umět říct **cenu**: když se HDP opraví, musíš přepsat N dokumentů (`update_many`). Tuhle větu si připrav, padne u obhajoby.

**5. Naplň databázi skriptem**, ne ručně. `insert_many` po dávkách, ne dokument po dokumentu.

**6. Ověř, co se načetlo** — totéž jako u SQL:

```python
print(col.count_documents({}))
print(col.count_documents({"zeme.hdp_na_hlavu": None}))   # kolik chybí HDP
```

**7. Dotazy stav na agregační pipeline**, ne na `find()`. Zadání říká *preferovány jsou agregační operace* — je to hlavní hodnocená dovednost.

**8. Vizualizace z databáze** (výstup pipeline → `pd.DataFrame` → Matplotlib), ne z původního CSV.

**9. Sepiš výhody a nevýhody** zvoleného řešení. Je to samostatný odevzdávaný výstup, ne řečnická vata.

### Checklist odevzdání

Společné:

- [ ] funkční řešení, spustitelné podle README
- [ ] zdrojový kód v **Git repozitáři**, ne ZIP
- [ ] rozumná historie commitů
- [ ] uživatelská příručka (jak spustit, co to dělá)
- [ ] komentáře v kódu

Specifické pro tento okruh (přímo z PDF):

- [ ] **zdůvodnění volby NoSQL** — proč je/není vhodná SQL databáze (samostatná kapitola, ne odstavec)
- [ ] **hodnocení výhod a nevýhod** zvoleného NoSQL řešení
- [ ] návrh struktury dokumentů + popsaná míra denormalizace
- [ ] skript pro načtení dat včetně řešení nekonzistencí
- [ ] **agregační pipeline** (ne jen `find`)
- [ ] přehledné výstupy — agregace dat
- [ ] vizualizace

Body navíc:

- [ ] index na poli, přes které filtruješ, + `explain()` ukazující jeho použití
- [ ] schéma validace (`$jsonSchema`) — ukazuje, že víš, že Mongo *umí* i validovat
- [ ] srovnání s JSONB v PostgreSQL (zadání ho jmenuje)

### Pasti a časté chyby

- **„NoSQL jsem zvolil, protože je to moderní."** Tohle tě potopí. Zdůvodnění musí být věcné: nepravidelná struktura dat, čtení celku najednou, vývoj schématu bez migrací, horizontální škálování.
- **Napodobování relační databáze v Mongo.** Tři kolekce spojované přes `$lookup` na každý dotaz = špatně použitý nástroj. Buď denormalizuj, nebo přiznej, že sem patřil relační model.
- **Zapomenutá agregační pipeline.** Řešení postavené jen na `find()` neukazuje požadovanou dovednost.
- **`$lookup` jako první volba.** Existuje, ale je to nouzovka — když ho používáš všude, návrh dokumentu je špatně.
- **Chybějící index.** Bez indexu dělá Mongo `COLLSCAN`. Zkoušející se rád zeptá „jak zrychlíš tenhle dotaz".
- **Duplicitní import** — Mongo tě nezastaví, `_id` si vygeneruje. Buď si `_id` urči sám, nebo před importem `drop()`.
- **Pořadí fází v pipeline.** `$match` patří **před** `$group`, ne za něj — jinak agreguješ celou kolekci a pak teprve zahazuješ. Toto je klasická otázka.

### Technické minimum

```bash
# MongoDB v Dockeru
docker run --name mongo -p 27017:27017 -d mongo:7

# shell
docker exec -it mongo mongosh szz
```

```bash
pip install pymongo pandas matplotlib
```

```python
from pymongo import MongoClient
cli = MongoClient("mongodb://localhost:27017/")
db  = cli["szz"]
col = db["cizinci"]
```

Klient s GUI: MongoDB Compass, případně v DBeaveru taky jde.

### Řešení ukázkové úlohy

**Zadání z PDF:** stejná data jako u relační úlohy (cizinci 2019 + HDP na hlavu), ale navrhnout **dokumentový** model, zdůvodnit volbu, načíst skriptem, denormalizovat, dotazovat agregacemi a vizualizovat.

#### Zdůvodnění volby (píš to jako první, je to hodnocené)

Poctivá odpověď u téhle úlohy zní: **data jsou pravidelná a tabulková, takže relační databáze by byla stejně dobrá nebo lepší.** Přiznej to a pak vyjmenuj, co konkrétně mluví pro dokumentový model tady:

- **čtení celku najednou** — analytický dotaz potřebuje měření i kontext země zároveň, denormalizovaný dokument to dá jedním čtením bez `JOIN`
- **schéma se vyvíjí** — přidání dalšího zdroje (nezaměstnanost, populace) neznamená `ALTER TABLE` ani migraci
- **nepravidelnost zdrojů** — když jeden zdroj má věkové kategorie a druhý ne, dokument to unese bez `NULL` sloupců
- **agregační pipeline** je expresivní a běží na serveru

A co mluví proti (řekni to sám, dřív než se zeptají): žádné cizí klíče, integritu musíš hlídat v aplikaci; při opravě HDP přepisuješ N dokumentů; ad-hoc dotazy napříč kolekcemi jsou v SQL pohodlnější.

#### Návrh dokumentu

Jeden dokument = jedno měření, kontext země **vnořený a denormalizovaný**:

```json
{
  "_id": "UKR-2019-Z-25-29",
  "rok": 2019,
  "pohlavi": "Z",
  "vek": { "od": 25, "do": 29, "skupina": "25-29" },
  "pocet": 4821,
  "zeme": {
    "iso3": "UKR",
    "nazev_cz": "Ukrajina",
    "hdp_na_hlavu": 3659.99,
    "pasmo_hdp": "do 5 tis."
  }
}
```

Tři rozhodnutí, která umíš obhájit:

- **`_id` složené z přirozeného klíče** místo `ObjectId` — opakovaný import nevytvoří duplicity, protože `_id` musí být unikátní. Zadarmo dostáváš idempotentní ETL.
- **`zeme` vnořená, ne referencovaná** — čte se s každým měřením, mění se zřídka, je malá. Klasické „embed".
- **`pasmo_hdp` předpočítané** při ETL — agregace pak nemusí počítat `$switch` za běhu. Cena: při změně pásem se přepočítává. To je vědomý kompromis, ne opomenutí.

#### Načtení dat

```python
import pandas as pd
from pymongo import MongoClient

cli = MongoClient("mongodb://localhost:27017/")
col = cli["szz"]["cizinci"]
col.drop()                                    # idempotence při opakovaném běhu

cizinci = pd.read_csv("cizinci2019.csv", sep=";", dtype=str)
hdp     = pd.read_csv("hdp2019.csv")

# stejná past jako u SQL: sjednotit identifikátor zemí
MAPA = {"Německo": "DEU", "Slovensko": "SVK", "Ukrajina": "UKR"}
cizinci["iso3"] = cizinci["stat"].str.strip().map(MAPA)
print("Nepřeloženo:", cizinci[cizinci["iso3"].isna()]["stat"].unique())

hdp_mapa = hdp.set_index("iso3")["hdp_na_hlavu"].to_dict()

def pasmo(v):
    if v is None:      return "neznámo"
    if v <  5000:      return "do 5 tis."
    if v < 20000:      return "5–20 tis."
    if v < 50000:      return "20–50 tis."
    return "nad 50 tis."

davka = []
for r in cizinci.dropna(subset=["iso3"]).itertuples():
    h = hdp_mapa.get(r.iso3)
    davka.append({
        "_id":     f"{r.iso3}-2019-{r.pohlavi}-{r.vek_od}-{r.vek_do}",
        "rok":     2019,
        "pohlavi": r.pohlavi,
        "vek":     {"od": int(r.vek_od), "do": int(r.vek_do)},
        "pocet":   int(str(r.pocet).replace(" ", "")),
        "zeme":    {"iso3": r.iso3, "nazev_cz": r.stat.strip(),
                    "hdp_na_hlavu": h, "pasmo_hdp": pasmo(h)},
    })

col.insert_many(davka, ordered=False)     # ordered=False: jedna chyba nezastaví zbytek
col.create_index("zeme.iso3")
col.create_index([("zeme.pasmo_hdp", 1), ("pocet", -1)])
print("Vloženo:", col.count_documents({}))
```

#### Agregační pipeline

Tohle je jádro celé úlohy. Cizinci podle pásma HDP země původu:

```python
pipeline = [
    {"$match": {"rok": 2019, "zeme.hdp_na_hlavu": {"$ne": None}}},   # 1. filtruj HNED
    {"$group": {                                                     # 2. agreguj
        "_id":        "$zeme.pasmo_hdp",
        "cizincu":    {"$sum": "$pocet"},
        "zemi":       {"$addToSet": "$zeme.iso3"},
        "prumer_hdp": {"$avg": "$zeme.hdp_na_hlavu"},
    }},
    {"$project": {                                                   # 3. uprav tvar
        "_id": 0,
        "pasmo":      "$_id",
        "cizincu":    1,
        "pocet_zemi": {"$size": "$zemi"},
        "prumer_hdp": {"$round": ["$prumer_hdp", 0]},
    }},
    {"$sort": {"cizincu": -1}},
]
vysledek = list(col.aggregate(pipeline))
```

**Pořadí fází je to podstatné:** `$match` úplně první, aby se agregovalo jen to, co projde filtrem — a aby se mohl použít index. Kdybys ho dal až za `$group`, Mongo projde celou kolekci. Přesně na tohle se u obhajoby ptají.

Mapování fází na SQL (dobrá odpověď na „vysvětli svou pipeline"):

| Fáze | SQL ekvivalent |
|---|---|
| `$match` | `WHERE` (před agregací) / `HAVING` (po ní) |
| `$group` | `GROUP BY` + agregační funkce |
| `$project` | `SELECT` (projekce) |
| `$sort` | `ORDER BY` |
| `$limit` | `LIMIT` |
| `$unwind` | rozbalení pole na řádky (v SQL nemá přímý protějšek) |
| `$lookup` | `LEFT JOIN` |

Druhý dotaz — top 10 občanství, sekce věkové struktury:

```python
top = list(col.aggregate([
    {"$group": {"_id": "$zeme.nazev_cz", "celkem": {"$sum": "$pocet"}}},
    {"$sort":  {"celkem": -1}},
    {"$limit": 10},
]))
```

Ověření, že se používá index:

```python
col.find({"zeme.iso3": "UKR"}).explain()["queryPlanner"]["winningPlan"]
# hledáš IXSCAN, ne COLLSCAN
```

#### Vizualizace

```python
import matplotlib.pyplot as plt
df = pd.DataFrame(vysledek)                  # data z pipeline, ne z CSV

fig, ax = plt.subplots(figsize=(8, 5))
ax.bar(df["pasmo"], df["cizincu"])
ax.set_ylabel("Počet cizinců")
ax.set_title("Cizinci v ČR podle pásma HDP země původu (2019)")
fig.tight_layout(); fig.savefig("cizinci_hdp.png", dpi=150)
```

#### Kdyby se ptali na JSONB v PostgreSQL

Zadání ho jmenuje, takže si připrav jednu ukázku — ukazuje, že rozumíš tomu, že „dokumentový" a „MongoDB" nejsou synonyma:

```sql
CREATE TABLE dokumenty (id SERIAL PRIMARY KEY, data JSONB);
CREATE INDEX idx_data ON dokumenty USING GIN (data);

SELECT data->'zeme'->>'nazev_cz' AS zeme, SUM((data->>'pocet')::int)
FROM dokumenty
WHERE data->'zeme'->>'pasmo_hdp' = 'do 5 tis.'
GROUP BY 1;
```

Rozdíl v jedné větě: **PostgreSQL s JSONB dá dokumentovou flexibilitu i transakce a `JOIN`y**, zatímco MongoDB nabízí lepší horizontální škálování a pohodlnější agregační jazyk.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a cíl
2. Proč NoSQL a ne relační databáze — tohle je jádro hodnocení
3. Návrh struktury dokumentů, míra denormalizace a čím jsem ji zdůvodnil
4. ETL skript a řešení nekonzistencí
5. Agregační pipeline a její jednotlivé fáze
6. Vizualizace výsledků
7. Zhodnocení výhod a nevýhod zvoleného řešení

### Na co se doptají (diskuse po prezentaci)

- Kdy bys naopak zvolil relační databázi? Buď konkrétní.
- Vysvětli jednotlivé fáze své agregační pipeline.
- Vnořit dokument, nebo referencovat? Podle čeho ses rozhodl?
- Co je CAP teorém a kde v něm MongoDB stojí?
- Jak je to v MongoDB s transakcemi a konzistencí?
- Jak bys řešil totéž pomocí JSONB v PostgreSQL?

### Užitečné odkazy

- Dokumentace MongoDB: <https://www.mongodb.com/docs/manual/>
- Agregační pipeline: <https://www.mongodb.com/docs/manual/core/aggregation-pipeline/>
- Návrhové vzory schémat (embed vs. reference): <https://www.mongodb.com/docs/manual/data-modeling/>
- PyMongo: <https://pymongo.readthedocs.io/en/stable/>
- JSONB v PostgreSQL: <https://www.postgresql.org/docs/current/datatype-json.html>
