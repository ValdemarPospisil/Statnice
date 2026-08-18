# Plán přípravy na SZZ

Start: **út 18. 8. 2026** · Cíl: připraven do **po 7. 9. 2026** (21 dní)
Pokud máš termín dřív (14 dní), použij [zkrácenou variantu](#zkrácená-varianta-14-dní).

---

## 1. Co tě vlastně čeká

| Zkouška | Okruhů | Formát | Kde se to láme |
|---|---|---|---|
| **KI/SZZTP** – teoretické základy | 10 z 12 | **15 min příprava, 15 min ústní** | Nemáš čas nic dohledat ani odvodit. Musíš to umět odvyprávět zpaměti. |
| **KI/SZZPP** – povinný základ | 12 z 16 | **60 min u počítače + 20 min obhajoba** | Praktická úloha. Rozhoduje rutina v nástroji, ne teorie. |
| **KI/SZZVP** – volitelné bloky | 8 | **5 h doma (3–10 dní předem) + 7–10 min prezentace + diskuse** | Úlohu zvládneš. Riziko je v „ověřování souvisejících znalostí" po prezentaci. |

### Tvůj výběr (podle README, po vyškrtnutí)

Číslování níže je **oficiální** — u SZZTP 1–12, kde 6 a 7 jsou vyřazené; u SZZPP a SZZVP je to pořadí v sadě, kterou si sestavuješ. Stejné číslování používají složky s poznámkami.

**SZZTP (10 z 12):**

| # | Okruh | Poznámky |
|---|---|---|
| 1 | Abstraktní kolekce (seznamy, slovníky, iterátory, fronta, zásobník) + složitosti | [📁](./SZZTP/01-abstraktni-kolekce/) |
| 2 | Algoritmy nad seznamy, binární vyhledávání, merge sort | [📁](./SZZTP/02-algoritmy-nad-seznamy/) |
| 3 | Spojové struktury (spoj. seznam, binární strom) + složitosti | [📁](./SZZTP/03-spojove-struktury/) |
| 4 | Reálná funkce, polynomy, Horner, půlení intervalu, Newton | [📁](./SZZTP/04-funkce-polynomy-nelinearni-rovnice/) |
| 5 | Derivace a integrály + numerická integrace (obdélník, lichoběžník, Simpson) | [📁](./SZZTP/05-derivace-integraly-numerika/) |
| 8 | Náhodná veličina a její charakteristiky, rozdělení | [📁](./SZZTP/08-nahodna-velicina/) |
| 9 | Intervaly spolehlivosti | [📁](./SZZTP/09-intervaly-spolehlivosti/) |
| 10 | Výrokový a predikátový počet, množiny, binární relace ← *máš rozpracované* | [📁](./SZZTP/10-logika-mnoziny-relace/) |
| 11 | Rekurence, asymptotická notace, Euklidův algoritmus | [📁](./SZZTP/11-rekurence-asymptotika/) |
| 12 | Grafy, stromy, eulerovské/hamiltonovské grafy, DFS/BFS | [📁](./SZZTP/12-grafy-stromy/) |

**SZZPP (12 z 16):** APR ×3 (funkce a cykly / kolekce / OOP) · PCA ×2 (výběr komponent / diagnostika) · ZEL ×2 (analogová / digitální) · OPS (bash) · URDB (PostgreSQL) · ZZD (R) · MPG (návrh multimediální aplikace) · PRIZ (projektové řízení) → [rozcestník](./SZZPP/)

**SZZVP (8):** DB blok ×3 (relační + OLAP / NoSQL / pokročilá statistika a časové řady) · SW blok ×5 (návrhové vzory / desktop / mobil / web / OO návrh) → [rozcestník](./SZZVP/)

---

## 2. Rozbor: kde je skutečná obtížnost

### SZZTP je nejtěžší, ale ne tak, jak to vypadá

Deset okruhů zní hrozivě. Ve skutečnosti **pět z nich je jeden souvislý blok**:

> **Okruhy 1, 2, 3, 11, 12** = kolekce → algoritmy nad nimi → spojové struktury → asymptotika → grafy a stromy.

To je jedna látka viděná z pěti stran. Naučíš-li se pořádně asymptotickou notaci a projdeš datové struktury s jejich složitostmi, **pokryješ 50 % SZZTP jedním tahem**. Tohle je největší páka celé přípravy — proto to jde jako první a dostane nejvíc času.

Zbytek se dělí na tři nesouvislé kusy:
- **Okruh 10** (logika, množiny, relace) — máš rozjeté, formálně náročné, ale konečné.
- **Okruhy 4, 5** (matematická analýza + numerika) — nejhorší poměr objem/čas, spojité, potřebuje počítání rukou.
- **Okruhy 8, 9** (pravděpodobnost, intervaly spolehlivosti) — malé, ale zrádné na interpretaci.

### Kritický fakt o formátu SZZTP

15 minut přípravy znamená, že si **nestihneš nic promyslet, jen si uspořádat, co už umíš**. Proto musí ke každému z 10 okruhů existovat **jedna A4 osnovy**, kterou umíš odvyprávět bez opory. To je konkrétní, měřitelný cíl přípravy — ne „nastudovat látku".

Poznámka z tvých [poznámek z konzultace](./SZZTP/10-logika-mnoziny-relace/poznamky-z-konzultace.md) je přesná a stojí za zopakování u **všech** okruhů:
> „Řekněte, jak přesně zněla vaše otázka“ — a hned říct, čemu se budeš věnovat.

Zvlášť u okruhu 10, kde zkoušející nechá vybrat podtéma. Připrav si dvě, na kterých budeš stavět (podle tvých poznámek: **výrokový počet + množiny/relace**, predikátový počet si nikdo nevybírá).

### Překryvy napříč zkouškami — tohle šetří dny

| Naučíš se jednou | Pokryje |
|---|---|
| Relační návrh, normalizace, ER, JOIN, GROUP BY | **URDB** (SZZPP) + **SZZVP-DB I** (tam navíc jen transakce, procedury, OLAP, star/snowflake) |
| Statistika a regrese | **SZZTP 8+9** + **ZZD** (SZZPP, R) + **SZZVP-DB III** (regrese, ARIMA) — **trojnásobný překryv** |
| Python kolekce, výjimky, OOP | **APR ×3** (SZZPP prakticky) + **SZZTP 1–3** (teoreticky) |
| OO návrh, UML, návrhové vzory | **SZZVP-SW I a V** + argumentace u **MPG** (SZZPP) |
| Logické funkce, úplný systém spojek, NAND/NOR | **SZZTP 10** (výrokový počet) + **ZEL digitální** (SZZPP, Karnaugh, dekodér) |

Když se učíš databáze nebo statistiku, **uč se je rovnou v širší verzi pro SZZVP** — mimoběžné opakování je zbytečná práce.

### Kde je skryté riziko

- **PCA I a II** (výběr komponent, diagnostika) vypadají triviálně. Nejsou — u obhajoby jde o *zdůvodnění* volby a znalost diagnostických nástrojů. Ale příprava na ně je krátká, dělej je jako výplň unavených večerů.
- **ZEL analogová část** je jediný okruh, kde musíš umět **počítat rukou pod časovým tlakem** (Kirchhoff, smyčkové proudy, uzlová napětí, superpozice, Thévenin, Norton — všech šest metod na jeden obvod). To je nejnáročnější jednotlivá úloha v SZZPP. Nenechávej na konec.
- **SZZVP úloha přijde 3–10 dní před zkouškou** a sežere celý den (5 h řešení + příprava prezentace). Musíš mít v plánu volný blok, jinak ti to rozbije poslední týden.
- **ZZD v R**: pokud jsi R nepoužíval pár měsíců, syntaxe `dplyr`/`ggplot2` vypadává z hlavy nejrychleji ze všeho. Chce to reálné psaní kódu, ne čtení.

---

## 3. Metoda: jak se učit, aby to fungovalo

1. **Každý okruh má vlastní složku** s `README.md` — kostry jsou už založené. U SZZTP mají tuhle strukturu:
   ```
   ### Osnova výkladu (15 min)   ← předvyplněná, tohle je celé jádro
   ### Klíčové definice          ← co musím říct doslova
   ### Příklad na papír          ← jeden, který během výkladu spočítám nebo nakreslím
   ### Na co se doptají          ← předvyplněné typickými dotazy
   ```
   Osnova se musí vejít na A4. Když se nevejde, ještě tomu nerozumíš.
   U SZZPP je navíc `Postup u zkoušky (60 min)` a `Co si nacvičit`, u SZZVP `Kostra prezentace (7–10 min)`.
   Doplňkové soubory (`Kod/`, obrázky, `.qmd`, `.sql`) patří do složky daného okruhu.

2. **Aktivní vybavování, ne čtení.** Zavři poznámky a mluv nahlas 10 minut. Kde se zadrhneš, tam je díra. Čtení textu vytváří pocit znalosti bez znalosti.

3. **Simulace u SZZTP.** Poslední týden: náhodně vylosuj okruh, 15 min ticha s papírem, 15 min výkladu nahlas. Nic jiného neodhalí, že „to nějak umíš, ale neumíš to říct".

4. **U SZZPP piš kód, nečti ho.** Otevři editor a vyřeš ukázkovou úlohu ze zadání celou, s časovkou na 60 minut. Ukázkové úlohy v PDF jsou reprezentativní — jsou to vlastně vzorové otázky.

5. **Papír a tužka** u ZEL, ZTP 4/5 a grafů. U zkoušky nebudeš mít Wolfram.

---

## 4. Denní plán (21 dní)

Odhad ~4–5 h denně. Neděle jsou lehčí schválně — plán, který nepočítá s únavou, se rozpadne ve druhém týdnu.

### Týden 1 (18.–24. 8.) — SZZTP: algoritmický blok + logika

Cíl týdne: **6 z 10 osnov SZZTP hotových** (okruhy 11, 1, 2, 3, 12, 10).

| Den | Hlavní blok (3 h) | Doplněk (1–2 h) |
|---|---|---|
| **út 18. 8.** | [ZTP 11](./SZZTP/11-rekurence-asymptotika/): asymptotická notace (O, Θ, Ω, vztahy a manipulace), rekurence — iterační a substituční metoda, Euklidův algoritmus | Projít šablony ve složkách okruhů |
| **st 19. 8.** | [ZTP 1](./SZZTP/01-abstraktni-kolekce/): abstraktní kolekce — seznam, slovník, iterátor, fronta, zásobník; **tabulka složitostí všech operací** | [APR 1](./SZZPP/01-programovani-funkce-a-cykly/): ukázková úloha „funkce a cykly" v Pythonu, na čas |
| **čt 20. 8.** | [ZTP 2](./SZZTP/02-algoritmy-nad-seznamy/): filtrování, vyhledávání, řazení výběrem/vkládáním, binární vyhledávání, merge sort — umět **odvodit** složitosti, ne odrecitovat | [APR 2](./SZZPP/02-programovani-kolekce/): ukázková úloha „kolekce" |
| **pá 21. 8.** | [ZTP 3](./SZZTP/03-spojove-struktury/): jednosměrný spojový seznam a binární strom — vkládání, výmaz, vyhledávání + složitosti; kreslit! | [APR 3](./SZZPP/03-programovani-oop/): ukázková úloha „OOP" (`__str__`, `__contains__`, property, iterátor) |
| **so 22. 8.** | [ZTP 12](./SZZTP/12-grafy-stromy/): grafy (orientovaný/neorientovaný, reprezentace — matice vs. seznam sousedů), stromy, Euler vs. Hamilton, DFS/BFS | — |
| **ne 23. 8.** | [ZTP 10](./SZZTP/10-logika-mnoziny-relace/): dokončit poznámky — výrokový počet (úplný systém spojek!), množiny, systém množin, binární relace, Hasse | Lehký den |
| **po 24. 8.** | **Kontrola:** 6 osnov nahlas, každá 10 min. Doplň díry. | [ZEL digitální](./SZZPP/07-elektronika-digitalni/): Karnaugh + Quine-McCluskey — navazuje na výrokový počet |

### Týden 2 (25.–31. 8.) — SZZTP: matematika a statistika + SZZPP drilly

Cíl týdne: **10 z 10 osnov SZZTP** + polovina SZZPP odzkoušená prakticky.

| Den | Hlavní blok (3 h) | Doplněk (1–2 h) |
|---|---|---|
| **út 25. 8.** | [ZTP 4](./SZZTP/04-funkce-polynomy-nelinearni-rovnice/): reálná funkce (def. obor, obor hodnot, limita, spojitost), polynomy, **Hornerovo schéma**, půlení intervalu, Newtonova metoda | Spočítat rukou: Horner + 2 kroky Newtona |
| **st 26. 8.** | [ZTP 5](./SZZTP/05-derivace-integraly-numerika/): derivace a její geometrický význam, primitivní funkce, určitý integrál; obdélníkové/lichoběžníkové/**Simpsonovo** pravidlo; aplikace (extrém, objem rot. tělesa) | Spočítat rukou všechna tři numerická pravidla na jednom integrálu |
| **čt 27. 8.** | [ZTP 8](./SZZTP/08-nahodna-velicina/): náhodná veličina, distribuční funkce, pravděpodobnostní funkce vs. hustota, střední hodnota, rozptyl, kvantily, klíčová rozdělení | — |
| **pá 28. 8.** | [ZTP 9](./SZZTP/09-intervaly-spolehlivosti/): konstrukce pro stř. hodnotu, rozptyl, rel. četnost; **interpretace spolehlivosti** (tady se nejčastěji chybuje) | [ZZD](./SZZPP/10-zaklady-zpracovani-dat/): R — `dplyr` řetězec na reálném CSV |
| **so 29. 8.** | [**ZEL analogová**](./SZZPP/06-elektronika-analogova/): jeden obvod všemi šesti metodami — Kirchhoff, smyčkové proudy, uzlová napětí, superpozice, Thévenin, Norton | — |
| **ne 30. 8.** | [URDB](./SZZPP/09-databazove-systemy/) + [SZZVP-DB I](./SZZVP/01-relacni-db-a-olap/) společně: normalizace 1–3 NF, ER (vraní nohy), JOIN, GROUP BY → nahoru OLAP, star/snowflake, OLTP vs. OLAP | Lehký den |
| **po 31. 8.** | **Kontrola:** všech 10 osnov SZZTP existuje. Vylosuj 3, odvykládej. | [OPS](./SZZPP/08-operacni-systemy/): napsat bash skript z ukázkové úlohy (`find`, kolony, CSV) |

### Týden 3 (1.–7. 9.) — SZZPP dokončit, SZZVP, opakování

Cíl týdne: nulové bílé místo + zaběhnutá rutina výkladu.

| Den | Hlavní blok | Doplněk |
|---|---|---|
| **út 1. 9.** | [ZZD](./SZZPP/10-zaklady-zpracovani-dat/): celá ukázková úloha v R do `.Rmd` včetně vyrenderování — **na čas** | [SZZVP-DB III](./SZZVP/03-pokrocila-statistika-a-casove-rady/): dekompozice časových řad, ARIMA/SARIMA — jen přehled a interpretace |
| **st 2. 9.** | [Návrhové vzory](./SZZVP/04-navrhove-vzory/): Prototype, Command, Iterator, Factory Method, Observer, Strategy, Adapter, Decorator, Singleton — umět **k čemu jsou a kdy je použít** | [OO návrh](./SZZVP/08-objektove-orientovany-navrh/): diagram tříd, use case, sekvenční — umět nakreslit z hlavy |
| **čt 3. 9.** | [PRIZ](./SZZPP/12-projektove-rizeni/): SMART, SWOT, RACI, projektový trojúhelník, PDCA, řízení rizik — projít celou ukázkovou úlohu písemně | [MPG](./SZZPP/11-multimedia-a-pocitacova-grafika/): barevné modely, komprese, křivky, homogenní souřadnice, filtry |
| **pá 4. 9.** | [PCA I](./SZZPP/04-architektura-vyber-komponent/) + [II](./SZZPP/05-architektura-diagnostika/): sestava do rozpočtu se zdůvodněním + diagnostický postup u černé obrazovky | [SZZVP-DB II](./SZZVP/02-nosql-databaze/): NoSQL, denormalizace, agregační pipeline |
| **so 5. 9.** | **Rezerva na SZZVP úlohu** (5 h) — pokud už přišla, řeší se dnes | — |
| **ne 6. 9.** | Prezentace k SZZVP úloze: 7–10 min, nacvičit nahlas na stopky | Lehký den |
| **po 7. 9.** | **Simulace SZZTP:** 3× vylosovat okruh, 15 min příprava, 15 min výklad | Rychlý průlet všemi 12 osnovami SZZPP |

> **Až přijde zadání SZZVP úlohy** (3–10 dní předem), překlop ji na `so 5. 9.` nebo nejbližší volný blok a zbytek dne posuň. Nepokoušej se ji řešit „vedle" ostatního učení — 5 hodin je 5 hodin.

---

## 5. Zkrácená varianta (14 dní)

Když máš míň času, škrtej v tomto pořadí — ne plošně:

1. **Neškrtej nic ze SZZTP.** Je to jediná zkouška, kde se nedá improvizovat.
2. **PCA I + II** zkrať na 2 h dohromady (přehled komponent + diagnostický postup, zbytek zvládneš u tabule z logiky věci).
3. **MPG a PRIZ** dělej jen jako průchod ukázkovou úlohou písemně (2 h každý) — obojí je hlavně o strukturovaném uvažování, ne o memorování.
4. **SZZVP-SW** zkrať na vzory + UML; desktop/mobil/web umíš z praxe a máš na úlohu 5 hodin s materiály.
5. **Nikdy neškrtej:** ZEL analogovou, ZZD v R, ZTP 4/5. Tyhle tři se nedají „vymyslet na místě".

Konkrétně: vynech dny **pá 4. 9.** a **čt 3. 9.** jako plnohodnotné bloky, zkrať týden 3 na tři dny a týden 1 nech beze změny.

---

## 6. Kontrolní seznam

### SZZTP — každý okruh má A4 osnovu, kterou umím říct bez opory
- [ ] 1 · Abstraktní kolekce + složitosti
- [ ] 2 · Algoritmy nad seznamy, binární vyhledávání, merge sort
- [ ] 3 · Spojový seznam, binární strom
- [ ] 4 · Funkce, polynomy, Horner, půlení, Newton
- [ ] 5 · Derivace, integrál, numerická integrace
- [ ] 8 · Náhodná veličina a charakteristiky
- [ ] 9 · Intervaly spolehlivosti
- [ ] 10 · Logika, množiny, relace
- [ ] 11 · Rekurence, asymptotika, Euklidés
- [ ] 12 · Grafy, stromy, DFS/BFS

### SZZPP — každou ukázkovou úlohu jsem vyřešil na počítači, na čas
- [ ] APR: funkce a cykly · [ ] APR: kolekce · [ ] APR: OOP
- [ ] PCA I: výběr komponent · [ ] PCA II: diagnostika
- [ ] ZEL: analogová (6 metod) · [ ] ZEL: digitální (Karnaugh + QM)
- [ ] OPS: bash skript · [ ] URDB: PostgreSQL od ER po SELECT
- [ ] ZZD: `.Rmd` report · [ ] MPG: návrh aplikace · [ ] PRIZ: SMART/SWOT/RACI

### SZZVP — umím k tématu mluvit i mimo vlastní řešení
- [ ] DB I: relační + OLAP · [ ] DB II: NoSQL · [ ] DB III: statistika a časové řady
- [ ] SW I: návrhové vzory · [ ] SW II: desktop · [ ] SW III: mobil · [ ] SW IV: web · [ ] SW V: OO návrh

---

## 7. Tři věci, na kterých to nejčastěji padá

1. **Umím to, ale neumím to říct.** Řešení: mluvit nahlas od prvního týdne, ne až v posledním.
2. **Poslední týden sežere SZZVP úloha.** Řešení: volný blok v plánu, viz `so 5. 9.`
3. **Rovnoměrné rozdělení času mezi zkoušky.** SZZTP potřebuje zhruba polovinu celkového času, protože je to jediná zkouška bez záchranné sítě v podobě počítače, materiálů nebo času na rozmyšlenou.
