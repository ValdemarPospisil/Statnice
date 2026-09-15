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

**Dostupnost lékáren v Ústeckém kraji.** Tři veřejné zdroje spojené do dvou databází — dokumentové (MongoDB) a grafové (Neo4j). Repozitář: `~/Dokumenty/SZZVP-NoSQL`.

#### Zadání a co z něj plynulo

| Požadavek ze zadání | Jak splněn | Výsledek |
|---|---|---|
| tabulka počtů lékáren v okresech a ORP | `dotazy_mongo.pocty_okresy()`, `pocty_orp()` | 7 okresů, 16 ORP |
| **Neo4j:** minimální kostra dostupnosti | `dotazy_neo4j.kostra_souhrn()` | 351 hran, 986,53 km |
| **Mongo:** vzdálenost obcí od nejbližší lékárny, 10 nejvzdálenějších | `dotazy_mongo.nejvzdalenejsi_obce()` | max 14,98 km (Brandov) |
| vlastní zpracování | 4 analýzy | pustina, řetězce, hustota, změny území |

#### Čísla, která musíš umět zpaměti

Tohle je první, co u obhajoby padne — čísla musí jít z hlavy, ne z papíru.

```
167 lékáren · 354 obcí · 7 okresů · 16 ORP · Ústecký kraj (CZ042)

Vzdálenost obcí bez lékárny k nejbližší lékárně (303 obcí se známou polohou):
   min 0,4 km │ medián 4,82 km │ průměr 4,99 km │ max 14,98 km
   140 obcí dál než 5 km, 12 obcí dál než 10 km
   66 788 obyvatel žije dál než 5 km

Nejvzdálenější: Brandov 14,98 km, Domoušice 14,05 km, Pnětluky 12,29 km
   → v první desítce je 6 obcí okresu Louny (13 lékáren na 70 obcí)

Minimální kostra: 352 uzlů → 351 hran (strom má vždy n−1), 986,53 km, průměr 2,81 km
   Nejdelší hrany: Český Jiřetín–Klíny 7,7 km, Kalek–Boleboř 7,69 km
   → všechny tři nejdelší leží v Krušných horách

Graf BLIZKO: 1 266 hran (6 nejbližších sousedů), úplný graf by měl 61 776
Velikost dat: kolekce 201 kB a 134 kB — objem NENÍ důvod pro NoSQL
```

**Proč 303 a ne 305 obcí bez lékárny:** Líšťany a Nezabylice nemají záznam v Geonames, takže nemají souřadnice a z geodotazů vypadly. Umět to říct dřív, než se zeptají.

#### Datové zdroje a jejich spojení

| Zdroj | Co dodává | Role |
|---|---|---|
| Registr NRPZS (CSV) | 167 lékáren | předmět analýzy |
| ČSÚ (XLSX, 13 listů) | hierarchie obcí 2013–2024 | **autoritativní** seznam obcí |
| Geonames `CZ.txt` | 43 264 objektů ČR | geometrie a populace |
| `admin2Codes.txt` | kódy okresů | **most** mezi Geonames a ČSÚ |

Tok dat (nauč se ho nakreslit na tabuli):

```
parse_uzemi.py    ┐
parse_geonames.py ├→ build.py ┬→ load_mongo.py → MongoDB
parse_lekarny.py  ┘           └→ load_neo4j.py → Neo4j
        ↑
   normalize.py  (používají všechny)
```

#### Ústřední problém úlohy: tři nekompatibilní kódové systémy

Tohle je jádro obhajoby — zadání explicitně chce „řešení nekonzistencí identifikátorů".

| Zdroj | Kraj | Okres |
|---|---|---|
| ČSÚ + registr | `CZ042` (NUTS 3) | `CZ0426` (LAU 1) |
| Geonames | `89` (**FIPS**) | `0426` |
| `admin2Codes` | — | `CZ.89.0426`, **bez NUTS** |

Dvě věci, které to dělají netriviálním:

1. **Geonames používá FIPS**, historický americký standard, ne NUTS. Kdybys spojoval `89` s `CZ089`, dostaneš tiše nula výsledků. Řešení: převodní tabulka `FIPS_TO_NUTS3` v `normalize.py`.
2. **`admin2Codes.txt` nemá NUTS kód vůbec** — zná jen `CZ.89.0426` a text „Okres Teplice". Spojení Geonames → ČSÚ tedy jde **výhradně přes normalizovaný textový název okresu**. Proto je normalizace nutná, ne kosmetická. Výsledek: 98 záznamů pokryje všech 77 okresů.

Přehled všech řešených nekonzistencí:

| Nekonzistence | Rozsah | Řešení |
|---|---|---|
| FIPS vs. NUTS u kraje | všechna sídla | tabulka `FIPS_TO_NUTS3` |
| `admin2Codes` bez NUTS | 98 řádků | spojení přes název → 77/77 okresů |
| Diakritika mezi zdroji | — | `norm()` přes NFKD |
| Praha dělená na 22 částí | 22 | sjednoceno na `CZ0100` |
| `Město Brno` vs. `Brno-město` | 1 | alias |
| Lékárny bez souřadnic | 3 | dogeokódování na střed obce + `geo_zdroj` |
| Duplicitní názvy obcí | 6 v ÚK | rozhodnutí podle okresu a populace |
| Slepený `DruhZarizeni` | 3 | parsováno na seznam |
| **Sídlo firmy ≠ poloha lékárny** | **91 ze 167** | sloupce `*Sidlo` se nikdy nepoužijí jako poloha |
| Obce bez Geonames | 2 | `loc: null`, mimo geodotazy |

**Dvě pasti, které musíš umět vyprávět jako historku:**

- **Kódy okresů jsou hexadecimální** — `CZ0209, CZ020A, CZ020B, CZ020C`. Nikdy neparsovat jako `int`. Proto je ve validátoru vzor `^CZ[0-9A-C]{4}$`.
- **Kdyby se geokódovalo podle sloupců `*Sidlo`**, skončilo by 41 lékáren v Brně a 25 v Praze — to je sídlo Dr. Max a BENU, ne poloha lékárny. Postihlo by to 91 ze 167 lékáren.

#### Struktura dokumentu (MongoDB)

Obec — hierarchie **vnořená**, geometrie jako GeoJSON:

```javascript
{
  _id: "554804",                    // kód obce ČSÚ = přirozený klíč
  nazev: "Ústí nad Labem",
  nazev_norm: "usti nad labem",     // předpočítáno pro spojování zdrojů
  status: "S", status_popis: "statutární město",

  pou:   { kod: "42142", nazev: "Ústí nad Labem" },
  orp:   { kod: "4214",  nazev: "Ústí nad Labem" },
  okres: { kod: "CZ0427", nazev: "Ústí nad Labem" },
  kraj:  { kod: "CZ042", nazev: "Ústecký kraj" },
  nuts2: { kod: "CZ04",  nazev: "Severozápad" },
  rok_listu: "1.1.2024",            // ke kterému řezu se hierarchie vztahuje

  loc: { type: "Point", coordinates: [14.03227, 50.6607] },   // [lng, lat]!
  populace: 90378,
  lekaren: 19, ma_lekarnu: true     // předpočítáno
}
```

Lékárna — ORP **denormalizované** z obce, příznak kvality polohy:

```javascript
{
  _id: "248001",                    // MistoPoskytovaniId
  nazev: "ČESKÁ LÉKÁRNA HOLDING, a.s., Dr. Max Lékárna",
  druhy_zarizeni: ["Lékárna"],      // SEZNAM — u 3 lékáren je jich víc
  adresa: { obec: "Postoloprty", obec_norm: "postoloprty", ... },
  uzemi: {
    okres_kod: "CZ0424", okres_nazev: "Louny",
    orp_kod: "4207", orp_nazev: "Louny"      // DENORMALIZOVÁNO z obce
  },
  loc: { type: "Point", coordinates: [13.699670, 50.360664] },
  geo_zdroj: "registr",             // "registr" = přesná, "obec" = dogeokódováno
  obec_kod: "565229",               // reference do kolekce obce
  retezec: "Dr. Max",
  poskytovatel: { ico: "28511298", sidlo_obec: "Brno", ... }  // SÍDLO, ne poloha
}
```

#### Pět rozhodnutí o modelu — a cena každého

Tohle je nejcennější část obhajoby. Ke každému rozhodnutí umět **důvod i cenu**.

**1. Dvě kolekce, ne lékárny vnořené do obcí.**
Nabízelo by se vnořit — čte se to spolu, poměr 1:málo (max 19 lékáren v Ústí). **Přesto špatně**, a to z technického důvodu: `$geoNear` musí být **první stupeň pipeline** a pracuje **nad kolekcí**, ne nad vnořeným polem. Hlavní úloha by s vnořením nešla udělat vůbec. Navíc se lékárny čtou i samostatně (řetězce, hustota).

**2. Hierarchie ORP/okres/kraj vnořená do obce.**
Tady vnoření platí: poměr 1:málo, čte se vždy s obcí, mění se jednou za roky. Žádná agregace za okresy nepotřebuje `$lookup`, stačí `$group`.

**3. ORP denormalizované i do lékárny.**
Registr ORP vůbec neuvádí. Zkopírováním z obce se tabulka za ORP udělá jedním `$group`. **Cena:** při přeřazení obce do jiného ORP nutno přepsat všechny lékárny v ní (`update_many`). A není to hypotéza — mezi 2013 a 2024 se to stalo **19krát**.

**4. Předpočítané `lekaren` a `ma_lekarnu`.**
Filtr „obce bez lékárny" je vstup hlavní úlohy, použije se opakovaně, umožní index. **Cena:** platí jen k okamžiku načtení; při průběžných změnách nutno přepočítávat. Tady jde o statický import.

**5. `loc` jako GeoJSON, ne dvě čísla.**
Jen nad GeoJSON funguje `2dsphere`. **Past:** pořadí je `[longitude, latitude]` (RFC 7946), obráceně než se souřadnice běžně čtou. Záměna nezpůsobí chybu — jen tiše přesune všechny body mimo ČR. Mapa v notebooku slouží i jako kontrola tohoto pořadí.

#### Hlavní agregační pipeline — vysvětlení stupeň po stupni

Tohle musíš umět projít řádek po řádku. Úloha: *pro každou obec bez lékárny najdi nejbližší lékárnu.*

```python
[
  {"$match": {"ma_lekarnu": False, "loc": {"$ne": None}}},   # 1
  {"$lookup": {                                              # 2
      "from": "lekarny",
      "as": "nejblizsi",
      "let": {"stred": "$loc"},                              # 3
      "pipeline": [
          {"$geoNear": {"near": "$$stred",                   # 4
                        "distanceField": "vzdalenost_m",
                        "spherical": True}},
          {"$limit": 1},                                     # 5
      ],
  }},
  {"$unwind": "$nejblizsi"},                                 # 6
  {"$project": {"km": {"$round": [                           # 7
      {"$divide": ["$nejblizsi.vzdalenost_m", 1000]}, 2]}}},
  {"$sort": {"km": -1}},                                     # 8
]
```

1. **`$match` první** — vybere 303 obcí. Musí být první, aby se použil index a aby se nepočítalo nad zbytečnými dokumenty.
2. **`$lookup` s vnořenou pipeline** — pro každou obec spustí samostatnou agregaci nad kolekcí `lekarny`.
3. **`let`** zpřístupní hodnotu z nadřazeného dokumentu uvnitř vnořené pipeline jako `$$stred` (dvojité dolary = proměnná, ne pole).
4. **`$geoNear`** spočítá vzdálenosti od středu té obce, seřazené vzestupně. `spherical: True` = počítat po povrchu koule, ne v rovině.
5. **`$limit: 1`** — jen nejbližší. V Mongo 8 nelze limit dát dovnitř `$geoNear`.
6. **`$unwind`** rozbalí jednoprvkové pole na podobjekt.
7. **`$project`** přepočte metry na kilometry.
8. **`$sort`** sestupně — nejvzdálenější první.

**Klíčová pointa, kterou musíš umět:** vnořená pipeline uvnitř `$lookup` je **jediný způsob**, jak dostat `$geoNear` na první místo pro každý dokument zvlášť. `$geoNear` totiž musí být prvním stupněm své pipeline — v hlavní pipeline by mohl být jen jednou, pro jeden bod.

#### Cypher a minimální kostra (Neo4j)

Graf: 545 uzlů, 2 515 orientovaných hran.

```
(:Okres)   -[:V_KRAJI]->    (:Kraj)         7
(:ORP)     -[:V_OKRESE]->   (:Okres)       16
(:Obec)    -[:V_OKRESE]->   (:Okres)      354
(:Obec)    -[:V_ORP]->      (:ORP)        354
(:Lekarna) -[:V_OBCI]->     (:Obec)       167
(:Obec)    -[:BLIZKO {km}]- (:Obec)      1266    ← graf dostupnosti
(:Obec)    -[:V_KOSTRE {km}]-(:Obec)      351    ← výsledek kostry
```

**Proč existuje `(:Obec)-[:V_OKRESE]->(:Okres)`, když vede cesta přes ORP:** hranice ORP a okresů se **nekryjí**. Okres Litoměřice se dělí na ORP Litoměřice, Lovosice a Roudnice; naopak ORP může zasahovat do dvou okresů. Okres tedy **nelze odvodit průchodem** — je to samostatný fakt ze zdroje. Klasická doplňující otázka.

Výpočet kostry:

```cypher
CALL gds.spanningTree.stream($projekce, {
    sourceNode: start, relationshipWeightProperty: 'km'})
YIELD nodeId, parentId, weight
WITH gds.util.asNode(nodeId) AS a, gds.util.asNode(parentId) AS b, weight
WHERE a <> b        // kořenový řádek má nodeId == parentId, vyloučit!
```

Tři věci k vysvětlení:

- **GDS pracuje nad projekcí v paměti**, ne nad uloženým grafem. Proto `gds.graph.project(...)` před výpočtem.
- **`undirectedRelationshipTypes: ['*']`** je nutné — kostra dává smysl jen nad neorientovaným grafem.
- **`WHERE a <> b`** — první vrácený řádek je kořen, kde `nodeId == parentId`. Bez vyloučení bys měl 352 hran místo 351 a špatný součet.

**Graf `BLIZKO` je aproximace.** Úplný graf 352 obcí by měl $\binom{352}{2} = 61\,776$ hran. Omezení na **6 nejbližších sousedů** dá 1 266 hran. Hrany jsou **symetrizované** — pár se zachová, když má aspoň jeden uzel druhý mezi svými nejbližšími; bez toho se graf snadno rozpadne. Spojitost se po načtení ověřuje (352 z 352 dosažitelných).

#### Proč NoSQL — a kde bych volil SQL

Zadání to vyžaduje jako samostatný výstup. **Poctivá odpověď má dvě části** a právě ta poctivost je silná stránka.

**Pro NoSQL v této úloze:**

1. **Geoprostorové dotazy jsou hlavní operací.** MongoDB má `2dsphere` a `$geoNear` jako stupeň pipeline. V PostgreSQL by to šlo, ale **jen s PostGIS** — čisté SQL geoprostorový index nemá. Srovnání tedy není „SQL vs. NoSQL", ale **„MongoDB vs. PostgreSQL + PostGIS"**.
2. **Grafová úloha nemá v relačním modelu dobré řešení.** Minimální kostra je průchod grafem, ne agregace. V SQL by to znamenalo rekurzivní CTE a ruční implementaci Primova algoritmu; v Neo4j je to `gds.spanningTree`.
3. **Zdroje mají nepravidelné atributy.** Registr má 33 sloupců, z nichž `SpravniObvod` je prázdný u všech a `PoskytovatelFax` téměř všude. Relačně by vznikly tabulky s většinou `NULL`.
4. **Vnořená hierarchie se čte vždy celá.** Obec → POÚ → ORP → okres → kraj → NUTS 2. Relačně pět tabulek a čtyři `JOIN` na každý dotaz.

**Pro SQL by mluvilo:**

- **Data jsou malá a pevně strukturovaná** — 201 kB a 134 kB. NoSQL se vyplácí u objemů vyžadujících horizontální dělení. Tady o žádné nejde.
- **Referenční integrita je ručně** — že `lekarny.obec_kod` odkazuje na existující obec, garantuje jen skript. Cizí klíč by to vynutil databází.
- **Denormalizace se udržuje kódem** — ORP v lékárně vyžaduje `update_many`. Relačně by to byl `JOIN`, vždy aktuální.
- **Analytika nad více úrovněmi** — kdyby přišly časové řady a dotazy „meziroční změna po ORP", je to učebnicová úloha pro SQL s okenními funkcemi.

**Závěr, který řekni nahlas:** *„Pro tuto úlohu je volba NoSQL odůvodněná dvěma důvody — geoprostorové operace v pipeline a grafový algoritmus. Ostatní důvody jsou příjemné, ale samy by volbu neopravňovaly: při 500 dokumentech by PostgreSQL s JSONB a PostGIS posloužil stejně dobře a přidal integritu. Neupřímné by bylo tvrdit, že úloha vyžaduje NoSQL kvůli objemu dat. Nevyžaduje."*

#### Výhody a nevýhody řešení

**Výhody:**

- **Každá úloha běží v modelu, který jí odpovídá.** Loader je společný (`build.py`), druhá databáze stála ~30 % práce navíc.
- **Křížová validace.** Deset nejvzdálenějších obcí spočítané nezávisle Mongem (`$geoNear`) a Neo4j (`point.distance()`) vyšlo **shodně na dvě desetinná místa**. Kdyby byla chyba v pořadí `lat`/`lng`, výsledky by se rozešly. To je nejsilnější argument o správnosti.
- **Kvalita dat zůstává v datech.** `geo_zdroj` říká, které 3 lékárny mají přibližnou polohu; `geonames.kandidatu`, u kterých obcí se rozhodovalo.
- **Ověřitelnost.** `kontrola.py` vypíše kontrolní součty, notebook obsahuje důkaz použití indexu (`GEO_NEAR_2DSPHERE`) i funkční validace schématu.

**Nevýhody (říct je sám, dřív než se zeptají):**

- **Dvě databáze = dvě kopie dat**, nic je nedrží v konzistenci.
- **Referenční integrita není vynucená.**
- **Graf `BLIZKO` je aproximace** — 6 sousedů by při jiném kraji mohlo vést k nespojitému grafu.
- **Vzdálenosti jsou vzdušnou čarou.** Brandov má 14,98 km vzdušnou čarou, po silnici přes Krušné hory podstatně víc. Řešením by bylo routovací API — mimo rozsah úlohy.
- **Dvě obce bez souřadnic** (Líšťany, Nezabylice) vypadly z geodotazů.

#### Vlastní zpracování — 4 analýzy

**1. Lékárenská pustina** (obyvatelé × km): vážení přeskládá pořadí. Brandov je nejdál (14,98 km), ale má **249 obyvatel**. Nejcitelnější je **Peruc** (2 109 × 9,09 km) a **Chlumec** (4 170 × 4,06 km). *Pointa: kdyby kraj řešil, kde otevřít lékárnu, samotná vzdálenost by ho poslala ke 249 lidem.*

**2. Koncentrace sítí:** nezávislé lékárny drží **62–67 %** ve všech okresech kromě **Mostu, kde je trh rozdělený na třetiny** (39/33/28 %). *Proti běžné představě, že sítě trh ovládly.*

**3. Hustota na obyvatele** — ukázka pasti poměrových ukazatelů: vítěz **Hřensko** má 40,5 lékáren na 10 tis. obyvatel, ale je to turistické středisko u Pravčické brány. Věcně smysluplné jsou až **Lovosice** (6,86) proti **Mostu** (1,9) — 3,6× rozdíl.

**4. Změny územní struktury 2013→2024:** 19 obcí změnilo ORP nebo okres, 6 obcí vzniklo zrušením vojenských újezdů (kódy `5001xx`), obec **Brdy** zanikla. *Proto každý dokument nese `rok_listu` — územní příslušnost není v čase stabilní.*

#### Klíčový výsledek napříč oběma modely

**Krušné hory vyšly jako překážka nezávisle ve dvou analýzách.** Nejvzdálenější obce od lékáren (Brandov, Kalek, Hora Svaté Kateřiny) i tři nejdelší hrany kostry leží ve stejné oblasti. To není náhoda a je to nejlepší pointa na závěr prezentace.

#### Spuštění (kdyby chtěli vidět běh)

```bash
cd ~/Dokumenty/SZZVP-NoSQL
docker compose up -d                                   # MongoDB, Neo4j, mongo-express
PYTHONPATH=src .venv/bin/python src/load_mongo.py      # naplní MongoDB
PYTHONPATH=src .venv/bin/python src/load_neo4j.py      # naplní Neo4j
PYTHONPATH=src .venv/bin/python src/dotazy_mongo.py    # dotazy
PYTHONPATH=src .venv/bin/python src/dotazy_neo4j.py    # kostra
PYTHONPATH=src .venv/bin/python src/prezentace.py      # vygeneruje out/prezentace.pptx
```

| Rozhraní | Adresa |
|---|---|
| Neo4j Browser | <http://localhost:7474> |
| mongo-express | <http://localhost:8081> |

Loadery jsou **idempotentní** — kolekce i graf se před zápisem vyprázdní.

### Kostra prezentace (7–10 min)

Prezentace je vygenerovaná v `out/prezentace.pptx` (13 slidů), pod každým slidem jsou poznámky. **Časový rozpočet: ~40 s na slide.** To je málo — nacvič si to se stopkami a u slidů 2–4 se nezdržuj.

| # | Slide | Co říct (jádro) | ~s |
|---|---|---|---|
| 1 | Dostupnost lékáren | Úloha: kde v Ústeckém kraji je nejhůř dostupná lékárna. 3 zdroje, 2 databáze. | 30 |
| 2 | Tři nekompatibilní kódové systémy | **FIPS vs. NUTS** — Geonames má `89`, ČSÚ `CZ042`. `admin2Codes` nemá NUTS vůbec → spojení přes normalizovaný název. | 60 |
| 3 | Řešené nekonzistence | Tabulka. Zdůraznit: **sídlo firmy ≠ poloha lékárny** (91 ze 167), hexadecimální kódy okresů. | 45 |
| 4 | Schéma: proč dvě databáze | Každá úloha patří jinému modelu. Geodotazy dokumentově, kostra grafově. Loader společný. | 45 |
| 5 | Počty v okresech a ORP | Povinná tabulka. Denormalizace ORP → jeden `$group` bez `$lookup`. | 30 |
| 6 | Vzdálenost k nejbližší lékárně | **Hlavní úloha.** Projít pipeline: `$match` → `$lookup` s `let` → `$geoNear` → `$limit 1`. Medián 4,82 km, max 14,98 km. | 90 |
| 7 | Kde lékárny jsou a kde chybí | Mapa. 140 obcí dál než 5 km, 66 788 obyvatel. | 45 |
| 8 | Minimální kostra | 352 uzlů → **351 hran (n−1)**, 986,53 km. GDS nad projekcí v paměti. | 60 |
| 9 | Kostra v Neo4j Browseru | Obrázek. Po filtru >5 km se rozpadne na řetízky — **Krušné hory a okraje kraje**. | 45 |
| 10 | Vlastní zpracování | Pustina: Brandov je nejdál, ale má 249 obyvatel. Peruc je citelnější. | 60 |
| 11 | Jak vím, že je to správně | **Křížová validace** — Mongo a Neo4j nezávisle, shoda na 2 desetinná místa. | 45 |
| 12 | Proč NoSQL a kde SQL | Obě části. Geodotazy + graf pro NoSQL; malá data, integrita pro SQL. **Objem není důvod.** | 60 |
| 13 | Výsledky | Krušné hory vyšly jako překážka nezávisle ve dvou analýzách. | 30 |

**Věta, kterou začít:** *„Řešil jsem dostupnost lékáren v Ústeckém kraji — 167 lékáren, 354 obcí, tři veřejné zdroje, které spolu nemluví stejným jazykem."*

**Věta, kterou skončit:** *„Krušné hory vyšly jako překážka dvakrát nezávisle — v geodotazech i v grafu. To mi říká, že výsledek není artefakt metody."*

### Na co se doptají (diskuse po prezentaci)

Diskuse je ~10 minut a rozhoduje o známce víc než prezentace. Otázky jsou seřazené podle pravděpodobnosti.

#### A. Jisté otázky k tvému řešení

**„Proč dvě databáze, když by stačila jedna?"**
Protože zadání obsahovalo dvě úlohy různé povahy. Vzdálenost k nejbližší lékárně je agregace nad geoprostorovým indexem — dokumentový model. Minimální kostra je průchod grafem, kde je vztah prvotřídní objekt — grafový model. Loader je společný (`build.py`), takže druhá databáze stála zhruba 30 % práce navíc. Vedlejší zisk: stejná úloha spočítaná dvakrát nezávisle slouží jako křížová kontrola.

**„Vysvětlete svou agregační pipeline stupeň po stupni."**
Viz rozbor výše — `$match` (výběr 303 obcí, první kvůli indexu) → `$lookup` s vnořenou pipeline → `let` předá `$$stred` → `$geoNear` (vzdálenosti od té obce) → `$limit 1` → `$unwind` → `$project` (metry na km) → `$sort`. **Pointa:** vnořená pipeline je jediný způsob, jak dostat `$geoNear` na první místo pro každý dokument zvlášť.

**„Co je `2dsphere` index a proč ho potřebujete?"**
Geoprostorový index nad GeoJSON geometrií, počítá na kulové ploše (ne v rovině). `$geoNear` a `$near` ho **vyžadují** — bez něj Mongo dotaz odmítne s chybou, nespadne do pomalého skenu. Vnitřně je to *S2 geometry*: povrch koule se rozdělí na buňky a body dostanou klíč podle buňky, takže hledání nejbližších nemusí projít celou kolekci. Důkaz použití je v notebooku — `explain()` ukazuje stupeň `GEO_NEAR_2DSPHERE`.

**„Proč `[lng, lat]` a ne `[lat, lng]`?"**
GeoJSON (RFC 7946) definuje pořadí jako `[longitude, latitude]` — obráceně, než se souřadnice běžně čtou a než je má registr ve sloupcích `Lat`, `Lng`. **Záměna nezpůsobí chybu**, jen tiše přesune všechny body mimo ČR (z 50° s. š., 14° v. d. by bylo 14° s. š., 50° v. d. — Arabské moře). Proto je mapa v notebooku zároveň kontrolou pořadí.

**„Jak jste vyřešil, že zdroje používají různé identifikátory?"**
Tři systémy: ČSÚ NUTS (`CZ042`), Geonames FIPS (`89`), `admin2Codes` (`CZ.89.0426` bez NUTS). Převodní tabulka `FIPS_TO_NUTS3` řeší kraj; u okresu **není jiná cesta než textový název**, protože `admin2Codes` NUTS kód neobsahuje. Proto normalizace přes NFKD (odstranění diakritiky) plus aliasy pro Prahu a Brno. Výsledek: 98 záznamů pokryje 77 okresů.

**„Kolik dat to vlastně je a potřebujete kvůli tomu NoSQL?"**
201 kB a 134 kB, dohromady pod půl megabajtu. **Ne, objem není důvod** — to říkám v prezentaci sám. Důvodem jsou geoprostorové operace a grafový algoritmus, ne velikost.

**„Jak víte, že jsou výsledky správné?"**
Tři způsoby. (1) Křížová validace — Mongo `$geoNear` a Neo4j `point.distance()` daly shodné výsledky na dvě desetinná místa. (2) `kontrola.py` vypíše, co se ze zdrojů načetlo, s kontrolními součty. (3) Validační schéma `$jsonSchema` odmítne vadný zápis — v loaderu je test, který se o vadný zápis schválně pokusí.

**„Co ta obec, která nemá souřadnice?"**
Líšťany a Nezabylice nemají záznam v Geonames. Zůstaly v databázi s `loc: null`, aby počty za okresy byly úplné, ale z geodotazů vypadly. Proto 303 obcí místo 305. Je to v dokumentu vidět, ne zamlčené.

#### B. Teorie NoSQL — skoro jisté

**„Vnořit, nebo referencovat?"**

| Vnoř (embed) | Referencuj |
|---|---|
| čte se vždy společně | podřízená data se čtou samostatně |
| poměr 1:málo | 1:mnoho neomezené |
| nemění se nezávisle | mění se často a samostatně |
| chceš atomický zápis celku | dokument by přerostl **16 MB** |

U mě: hierarchie **vnořená** (čte se vždy s obcí, mění se jednou za roky), lékárny **v samostatné kolekci** — a to z technického důvodu, `$geoNear` pracuje nad kolekcí, ne nad polem.

**„Co je CAP teorém a kde v něm MongoDB stojí?"**
Distribuovaný systém může současně garantovat nejvýš dvě ze tří vlastností: **C**onsistency (všechny uzly vidí totéž), **A**vailability (každý dotaz dostane odpověď), **P**artition tolerance (funguje při rozpadu sítě). Protože se síť rozpadnout může vždy, je P povinné — reálná volba je mezi C a A. **MongoDB je CP**: při rozpadu replica setu menšinová část přestane přijímat zápisy, aby nevznikla rozdvojená data. Naproti tomu Cassandra je AP. *Pozn.: v mém řešení běží jeden uzel, takže CAP se prakticky neuplatní — umět to říct, když se doptají.*

**„Jak je to v MongoDB s transakcemi?"**
Od verze 4.0 podporuje **víceoperační ACID transakce**, od 4.2 i napříč shardy. Zápis jednoho dokumentu je atomický vždy — i s vnořenými poli. To je vedlejší argument pro vnoření: aktualizace obce i její hierarchie je jeden atomický zápis. V mém řešení transakce nepoužívám, protože jde o jednorázový import; kdyby se lékárny měnily za běhu společně s předpočítaným `lekaren` v obci, transakci bych potřeboval.

**„Co je BASE proti ACID?"**
ACID (relační) = Atomicity, Consistency, Isolation, Durability — přísná záruka. BASE (mnoho NoSQL) = **B**asically **A**vailable, **S**oft state, **E**ventually consistent — systém upřednostní dostupnost a připustí, že se repliky dočasně liší. MongoDB je blíž ACID, než se běžně říká.

**„Jak bys řešil totéž pomocí JSONB v PostgreSQL?"**

```sql
CREATE TABLE obce (id TEXT PRIMARY KEY, data JSONB);
CREATE INDEX idx_data ON obce USING GIN (data);

SELECT data->'okres'->>'nazev' AS okres, COUNT(*)
FROM obce WHERE (data->>'ma_lekarnu')::boolean = false
GROUP BY 1;
```

Rozdíl v jedné větě: **PostgreSQL s JSONB dá dokumentovou flexibilitu i transakce, cizí klíče a `JOIN`y**; MongoDB nabízí lepší horizontální škálování a čitelnější agregační jazyk. **Pro geodotazy bych ale stejně potřeboval PostGIS** — JSONB sám geoprostorový index nemá.

**„Proč je `$match` na začátku pipeline?"**
Aby se agregovalo jen to, co projde filtrem, a hlavně aby se **mohl použít index**. Po `$group` už dokumenty nejsou původní a index neexistuje. Stejná logika jako `WHERE` vs. `HAVING` v SQL.

**„Mapování fází pipeline na SQL?"**

| Fáze | SQL |
|---|---|
| `$match` | `WHERE` (před agregací) / `HAVING` (po ní) |
| `$group` | `GROUP BY` + agregační funkce |
| `$project` | `SELECT` (projekce) |
| `$sort` / `$limit` | `ORDER BY` / `LIMIT` |
| `$lookup` | `LEFT JOIN` |
| `$unwind` | rozbalení pole na řádky (v SQL nemá přímý protějšek) |

**„Co je sharding a replikace?"**
**Replikace** = tytéž údaje na víc uzlech kvůli dostupnosti a odolnosti (replica set, jeden primární pro zápis, sekundární pro čtení). **Sharding** = data rozdělená podle shard klíče na různé uzly kvůli objemu. Moje úloha nepotřebuje ani jedno — půl megabajtu se vejde na jeden uzel.

#### C. Grafové databáze a kostra

**„Co je minimální kostra a jaký algoritmus ji počítá?"**
Podgraf, který spojuje všechny uzly, je souvislý, **neobsahuje cyklus** a má nejmenší možný součet vah. Strom nad $n$ uzly má vždy přesně $n-1$ hran — proto 352 uzlů → **351 hran**. Klasické algoritmy: **Kruskal** (hrany vzestupně podle váhy, přidej, pokud nevytvoří cyklus — potřebuje union-find) a **Prim** (roste z jednoho uzlu, vždy přidá nejlevnější hranu ven ze stromu). GDS `spanningTree` používá Primův přístup, proto vyžaduje `sourceNode`.

**„Proč jen 6 nejbližších sousedů?"**
Úplný graf 352 obcí by měl $\binom{352}{2} = 61\,776$ hran. Omezení na 6 sousedů dá 1 266 hran. Je to **aproximace** — kostra by se změnila jen tehdy, kdyby optimální hrana vedla k nějakému sedmému a vzdálenějšímu sousedovi, což je u geografických dat nepravděpodobné. Hrany jsou **symetrizované** (pár se zachová, když má aspoň jeden uzel druhý mezi nejbližšími) a **spojitost se po načtení ověřuje** — 352 z 352 dosažitelných.

**„K čemu je ta kostra prakticky dobrá?"**
Je to nejlevnější způsob, jak propojit všechny obce sítí — model rozvozové trasy nebo pohotovostní služby. Hlavně ale: **nejdelší hrany ukazují kritická spojení**, jejichž ztráta síť rozdělí. Všechny tři nejdelší leží v Krušných horách.

**„Kdy grafová databáze a kdy relační?"**
Grafová, když je **vztah sám o sobě nositelem informace** a dotazy procházejí do neznámé hloubky (sociální sítě, doporučování, detekce podvodů, trasování). V SQL by to byla rekurzivní CTE, která se s hloubkou rychle zhoršuje. Relační, když jsou dotazy tabulkové a vztahy mělké.

#### D. Otázky, kde je snadné šlápnout vedle

**„Není denormalizace chyba?"**
Ne — v dokumentovém modelu je to **vzor, ne prohřešek**. Ale musím umět říct cenu: při přeřazení obce do jiného ORP musím přepsat všechny lékárny v ní (`update_many`). A stalo se to 19krát mezi 2013 a 2024. Kdyby se to dělo denně, zvolil bych referenci a `$lookup`.

**„Proč nemáte cizí klíče?"**
MongoDB je nemá. Integritu garantuje loader — že `lekarny.obec_kod` odkazuje na existující obec, hlídá `build.py`, ne databáze. **To je nevýhoda, kterou přiznávám sám.** Částečnou náhradou je `$jsonSchema` validátor, který hlídá strukturu a typy, ale ne referenční integritu.

**„Není 14,98 km pro Brandov málo?"**
Je to **vzdušná čára**. Po silnici přes Krušné hory je to podstatně víc. Řešením by bylo routovací API (OSRM, Valhalla), ale to je mimo rozsah pětihodinové úlohy. Zmiňuji to jako nevýhodu v README.

**„Co ta tři místa s nepřesnou polohou?"**
Tři lékárny neměly v registru souřadnice, dogeokódoval jsem je na střed obce a označil `geo_zdroj: "obec"`. Příznak se **nese až do výsledků dotazů**, takže není nikde skryté, že jde o přibližnou hodnotu.

**„Proč je kód okresu string a ne číslo?"**
Kódy jsou **hexadecimální** — `CZ0209, CZ020A, CZ020B, CZ020C`. Parsování jako `int` by selhalo nebo tiše zkomolilo Prahu-východ a Prahu-západ. Proto validační vzor `^CZ[0-9A-C]{4}$`.

#### E. Kdyby došlo na obecné SW inženýrství

- **„Jak byste to nasadil do produkce?"** — kontejnerizace už je (`docker-compose.yml`), chybělo by: autentizace databází (teď bez hesla, jen lokálně), plánované spouštění loaderu, monitoring, zálohy.
- **„Kde jsou testy?"** — jednotkové testy nemám, mám `kontrola.py` s kontrolními součty a křížovou validaci mezi databázemi. Kdybych je psal, začal bych u `normalize.norm_okres()` — čistá funkce s jasnými vstupy a výstupy, a v docstringu už má doctest příklady.
- **„Co bylo nejtěžší?"** — zjistit, že Geonames používá FIPS místo NUTS. Spojení tiše vracelo nula výsledků, žádná chyba. Právě proto `kontrola.py` vypisuje, co se nespárovalo.

### Užitečné odkazy

- Dokumentace MongoDB: <https://www.mongodb.com/docs/manual/>
- Agregační pipeline: <https://www.mongodb.com/docs/manual/core/aggregation-pipeline/>
- Návrhové vzory schémat (embed vs. reference): <https://www.mongodb.com/docs/manual/data-modeling/>
- PyMongo: <https://pymongo.readthedocs.io/en/stable/>
- JSONB v PostgreSQL: <https://www.postgresql.org/docs/current/datatype-json.html>
