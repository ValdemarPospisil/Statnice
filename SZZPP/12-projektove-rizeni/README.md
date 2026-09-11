## 12 — Projektové řízení

- [Zadání okruhu (PDF)](../ZadaniOkruhu/PRIZ.pdf)

> **Analýza a návrh řízení simulovaného IT projektu** pomocí technik projektového managementu. 60 minut u počítače (MS Office / LibreOffice), pak 20 minut obhajoby. Odevzdává se **textový dokument nebo prezentace v PDF**.

**Jediný okruh bez kódu a bez matematiky** — zato s nejkonkrétnějším zadáním ze všech. Zadání vyjmenovává **čtyři povinné úkoly a čtyři rozšiřující**, takže víš přesně, co se bude hodnotit.

> **Nejčastější způsob, jak tenhle okruh pokazit:** psát obecné fráze místo konkrétních čísel. „Cílem je zvýšit prodeje" není SMART cíl. „Do 30. 6. 2027 dosáhnout obratu 2 mil. Kč měsíčně přes e-shop" je. **Každé tvrzení v odevzdaném dokumentu musí být konkrétní, měřitelné a vztažené k zadanému projektu.**

Zadaný rozpočet (5 mil. Kč) a termín (1 rok) jsou **skutečná omezení** — když ti finanční rozvaha nesedí do rozpočtu, je to chyba, kterou komise uvidí. [Ověřený rozpočet níž](#rozšíření-1--finanční-rozvaha) vychází přesně.

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn, pak výklad s příklady. -->

#### Souhrn na jednom místě

| Technika | K čemu | Zapamatuj si | Kde |
|---|---|---|---|
| **Projektový trojúhelník** | rozsah / čas / náklady | **změníš jeden, změní se další** | [↓](#projektový-trojúhelník) |
| **Fáze projektu** | zahájení → plánování → realizace → ukončení | monitorování běží **průběžně** | [↓](#fáze-projektu) |
| **SMART** | formulace cílů | **S**pecific **M**easurable **A**chievable **R**elevant **T**ime-bound | [↓](#smart--jak-formulovat-cíl) |
| **SWOT** | analýza situace | S/W = **interní**, O/T = **externí** | [↓](#swot-analýza) |
| **PEST(LE)** | vnější prostředí | politické, ekonomické, sociální, technologické | [↓](#pest-a-porterových-pět-sil) |
| **Porterových 5 sil** | konkurenční prostředí | dodavatelé, odběratelé, konkurence, noví, substituty | [↓](#pest-a-porterových-pět-sil) |
| **RACI** | odpovědnosti | **A je vždy právě jedno** | [↓](#raci-matice) |
| **PDCA** | cyklické zlepšování | Plan → Do → Check → Act | [↓](#pdca-cyklus) |
| **Řízení rizik** | 4 strategie | přijetí, přenesení, vyhýbání, snížení | [↓](#řízení-rizik) |
| **WBS** | rozpad práce | strom úkolů, listy = pracovní balíky | [↓](#wbs--rozpad-práce) |
| **Ganttův diagram** | harmonogram | úkoly v čase + závislosti | [↓](#rozšíření-2--harmonogram) |
| **Kritická cesta** | nejdelší řetěz závislostí | zpoždění na ní **zpozdí celý projekt** | [↓](#rozšíření-2--harmonogram) |
| **SCRUM** | agilní rámec | sprinty, PO/SM/tým, 5 ceremonií | [↓](#agilní-metodiky) |
| **Kanban** | vizuální tok práce | **WIP limity**, žádné sprinty | [↓](#agilní-metodiky) |
| **PRINCE2** | procesní metodika | 7 principů, procesů, témat | [↓](#agilní-metodiky) |
| **Management změn** | přechod lidí na nové | ADKAR, Kotterových 8 kroků | [↓](#rozšíření-4--management-změn) |

**Tři věci, které rozhodují:** v RACI je vždy jen jedno A, v SWOT nesplést interní a externí, a u SMART uvést **konkrétní čísla a data**.

#### Projektový trojúhelník

Tři veličiny, které **nejdou měnit nezávisle**:

```
              ROZSAH
             (co uděláme)
                 /\
                /  \
               /    \
              /KVALITA\
             /________\
          ČAS          NÁKLADY
      (do kdy)         (za kolik)
```

**Klíčové pravidlo:** změníš-li jeden vrchol, musí se přizpůsobit aspoň jeden další. Kvalita je uprostřed — obvykle je to to, co se tiše obětuje, když se tlačí na ostatní tři.

**Konkrétně na zadané úloze:** zákazník chce e-shop do roka za 5 milionů. Když si v šestém měsíci vymyslí věrnostní program navíc (**rozsah ↑**), musíš buď posunout termín (**čas ↑**), přidat lidi (**náklady ↑**), nebo něco jiného vyhodit. **Třetí možnost — že se to „nějak stihne" — znamená, že klesne kvalita.**

Tohle je nejlepší odpověď na doptávku „jak bys řídil změnu rozsahu".

#### Fáze projektu

| Fáze | Co se v ní děje | Výstup |
|---|---|---|
| **Zahájení** (initiation) | proč projekt vůbec děláme, kdo je zadavatel | projektová charta, business case |
| **Plánování** | rozsah, harmonogram, rozpočet, rizika, tým | projektový plán, WBS, Gantt |
| **Realizace** (execution) | vlastní práce | produkt, dílčí dodávky |
| **Monitorování a řízení** | **běží průběžně** po celou dobu | reporty, řízení změn |
| **Ukončení** (closure) | předání, vyúčtování, **poučení** | akceptační protokol, lessons learned |

**Monitorování není samostatná etapa v čase** — probíhá souběžně s realizací. To je častá chyba v diagramech.

**Lessons learned se nesmí vynechat** — je to jediná fáze, ze které má organizace dlouhodobý užitek. U obhajoby to zmiň.

#### SMART — jak formulovat cíl

| Písmeno | Význam | Otázka |
|---|---|---|
| **S**pecific | konkrétní | Co přesně? |
| **M**easurable | měřitelný | Jak poznám, že je hotovo? |
| **A**chievable | dosažitelný | Je to reálné se zdroji, které mám? |
| **R**elevant | relevantní | Přispívá to k hlavnímu cíli? |
| **T**ime-bound | termínovaný | Do kdy? |

**Rozdíl vidět vedle sebe:**

```
ŠPATNĚ:  "Vytvoříme moderní e-shop."
         Co je moderní? Kdy? Jak poznám úspěch?

SPRÁVNĚ: "Do 31. 8. 2027 spustíme e-shop s katalogem min. 200 produktů,
          platbou kartou a dobírkou, který zvládne 500 objednávek denně,
          v rozpočtu 3,5 mil. Kč."
         S: e-shop s katalogem a platbami
         M: 200 produktů, 500 objednávek/den, 3,5 mil. Kč
         A: odpovídá týmu 4 FTE na 9 měsíců
         R: přímo naplňuje cíl přechodu z kamenných prodejen
         T: 31. 8. 2027
```

**Nejčastější chyba:** cíl vypadá SMART, ale chybí **měřitelnost**. „Zlepšíme uživatelskou zkušenost" není měřitelné — „snížíme podíl opuštěných košíků z 70 % na 50 %" ano.

#### SWOT analýza

**Klasická past a nejčastější doptávka:** které kvadranty jsou interní a které externí.

| | **Pomáhá** | **Škodí** |
|---|---|---|
| **Interní** (my sami) | **S** — Strengths (silné stránky) | **W** — Weaknesses (slabé stránky) |
| **Externí** (okolí) | **O** — Opportunities (příležitosti) | **T** — Threats (hrozby) |

**Zapamatuj si:** S a W jsou věci, které **můžeš ovlivnit** (tvůj tým, tvoje technologie, tvoje finance). O a T jsou věci, které **ovlivnit nemůžeš**, jen na ně reagovat (legislativa, konkurence, trh).

**Typická chyba:** dát „silná konkurence" do slabých stránek. Konkurence je **externí**, patří do hrozeb. Do slabých stránek patří „nemáme zkušenosti s e-commerce".

**Co se ze SWOT dělá dál** (tohle udělá dojem): kombinace kvadrantů dávají strategie.

| Strategie | Kombinace | Význam |
|---|---|---|
| **SO** (ofenzivní) | silné + příležitosti | využij, v čem jsi dobrý, na to, co se nabízí |
| **ST** (defenzivní) | silné + hrozby | použij silné stránky k obraně |
| **WO** | slabé + příležitosti | odstraň slabinu, abys mohl využít příležitost |
| **WT** (přežití) | slabé + hrozby | minimalizuj obojí, nejrizikovější kvadrant |

#### PEST a Porterových pět sil

Zadání je v ukázkové úloze explicitně jmenuje (byť ne názvem), takže je dobré vědět, kam patří.

**PEST(LE)** — makroprostředí, tedy vnější faktory, které jdou do **O a T** ve SWOT:

| | Faktor | Příklad u e-shopu |
|---|---|---|
| **P** | politicko-právní | GDPR, zákon o ochraně spotřebitele, EET |
| **E** | ekonomické | inflace, kupní síla, kurz koruny |
| **S** | sociálně-kulturní | růst nákupů online, důraz na udržitelnost |
| **T** | technologické | mobilní platby, AI doporučování, rychlost internetu |
| (L) | legislativní | někdy zvlášť od P |
| (E) | ekologické | obalová legislativa, uhlíková stopa dopravy |

**Porterových pět sil** — konkurenční prostředí v odvětví:

1. **Stávající konkurence** — jiné e-shopy s dárkovým zbožím
2. **Noví konkurenti** — jak snadno někdo vstoupí? (u e-shopu velmi snadno = vysoká hrozba)
3. **Vyjednávací síla dodavatelů** — kolik výrobců žvýkaček existuje?
4. **Vyjednávací síla odběratelů** — zákazník snadno přejde jinam = vysoká síla
5. **Substituty** — jiné dárkové předměty pro programátory

**Poznámka k zadání:** ukázková úloha Porterovy síly označuje jako „faktory z interního okolí". **To není přesné** — Porter analyzuje odvětví, tedy vnější prostředí. Ale drž se formulace zadání a v odevzdaném dokumentu je zmiň tam, kam je zadání řadí. Kdyby se komise ptala, můžeš na tenhle rozdíl slušně upozornit.

#### RACI matice

Rozdělení odpovědností. Pro každý úkol a každou roli se přiřadí písmeno:

| Písmeno | Anglicky | Význam |
|---|---|---|
| **R** | Responsible | **kdo to dělá** (může být víc lidí) |
| **A** | Accountable | **kdo za to zodpovídá** — schvaluje výsledek |
| **C** | Consulted | s kým se **předem** konzultuje (obousměrná komunikace) |
| **I** | Informed | kdo je **informován** o výsledku (jednosměrně) |

**Nejdůležitější pravidlo a nejčastější doptávka:** **na každý úkol je právě jedno A.** Když jsou dvě, není jasné, kdo rozhoduje při sporu, a odpovědnost se rozplyne. Když není žádné, nemá kdo úkol schválit.

**R může být víc** (na úkolu pracuje tři lidi), **A jen jedno**. A a R může být tatáž osoba.

**Kontrola matice, kterou udělej vždycky:**

- každý řádek má **právě jedno A** a **aspoň jedno R**
- žádný sloupec není samé C a I (ten člověk nic nedělá — proč je v týmu?)
- žádný sloupec není přeplněný R (ten člověk je úzké hrdlo)

#### PDCA cyklus

Demingův cyklus průběžného zlepšování:

```
    ┌─────────────────────────────┐
    │                             ▼
  ACT ◄─── CHECK ◄─── DO ◄─── PLAN
  (uprav)  (vyhodnoť) (proveď) (naplánuj)
```

| Krok | Co se dělá | U e-shopu |
|---|---|---|
| **Plan** | naplánuj změnu, definuj metriky | „zrychlíme načtení stránky pod 2 s" |
| **Do** | proveď **v malém měřítku** | optimalizace na testovacím prostředí |
| **Check** | změř výsledek proti plánu | načtení kleslo z 3,5 s na 1,8 s ✓ |
| **Act** | zaveď plošně, nebo zkus jinak | nasadit do produkce a standardizovat |

**Pointa je v tom cyklu** — po Act následuje další Plan. Neustálé zlepšování v malých krocích, ne jedna velká změna.

**Vazba na agilní metodiky:** sprint retrospektiva ve SCRUMu je v podstatě Check + Act.

#### Řízení rizik

**Postup:** identifikovat → ohodnotit → zvolit strategii → **průběžně sledovat**.

**Ohodnocení** přes dvě osy, jejichž součin dává prioritu:

$$\text{Míra rizika} = \text{pravděpodobnost} \times \text{dopad}$$

Obojí se obvykle boduje 1–5, takže míra vychází 1–25.

**Čtyři strategie** (zadání je jmenuje explicitně):

| Strategie | Kdy | Příklad u e-shopu |
|---|---|---|
| **Vyhnutí se** (avoid) | vysoká pravděpodobnost i dopad | nepoužít nevyzkoušenou technologii |
| **Snížení** (mitigate) | dá se ovlivnit | automatizované testy proti chybám v platbách |
| **Přenesení** (transfer) | jde delegovat | pojištění, outsourcing platební brány, SLA s dodavatelem |
| **Přijetí** (accept) | nízký dopad nebo nelze ovlivnit | drobné zpoždění dodávky fotografií produktů |

**Pátá, nepsaná možnost:** ignorovat riziko. To není strategie, to je chyba — **přijetí znamená vědomé rozhodnutí a zapsání do registru**, ne že na to zapomeneš.

#### WBS — rozpad práce

**Work Breakdown Structure** — hierarchický rozpad projektu na menší kusy:

```
1. E-shop
   1.1 Analýza a návrh
       1.1.1 Sběr požadavků
       1.1.2 Návrh UX (wireframy)
       1.1.3 Návrh architektury
   1.2 Vývoj
       1.2.1 Katalog produktů
       1.2.2 Košík a objednávka
       1.2.3 Platební brána
       1.2.4 Administrace
   1.3 Testování
   1.4 Migrace dat
   1.5 Spuštění a školení
```

**Pravidlo 8/80:** pracovní balík (list stromu) by měl zabrat mezi 8 a 80 hodinami. Kratší je zbytečně drobné, delší se nedá spolehlivě odhadnout.

**Pravidlo 100 %:** WBS musí obsahovat **veškerou** práci projektu — co v ní není, se neudělá a nezaplatí.

**K čemu to je:** z WBS se odvozuje harmonogram (co po čem), rozpočet (kolik co stojí) i RACI (kdo co dělá). **Je to základ, ze kterého vychází všechno ostatní.**

#### Agilní metodiky

| | **SCRUM** | **Kanban** | **PRINCE2** |
|---|---|---|---|
| **Typ** | agilní rámec | vizuální metoda toku | procesní metodika |
| **Iterace** | sprinty (1–4 týdny) | **žádné**, plynulý tok | etapy |
| **Role** | Product Owner, Scrum Master, tým | žádné předepsané | projektový výbor, PM |
| **Klíčový prvek** | sprint backlog | **WIP limity** | business case |
| **Kdy** | měnící se požadavky, stabilní tým | údržba, podpora, nepravidelný příchod práce | velké, formální, regulované projekty |

**SCRUM — pět ceremonií:**

| Ceremonie | Kdy | Účel |
|---|---|---|
| Sprint planning | začátek sprintu | co se udělá |
| Daily standup | denně, 15 min | co jsem dělal / budu dělat / co mě blokuje |
| Sprint review | konec sprintu | ukázka výsledku zadavateli |
| Retrospektiva | konec sprintu | **jak zlepšit spolupráci** (= PDCA) |
| Backlog refinement | průběžně | upřesnění a odhad položek |

**Kanban a WIP limity** — nejdůležitější myšlenka: omezením počtu souběžně rozpracovaných úkolů se **zkrátí průběžná doba**. Když dělá pět lidí na pěti věcech naráz, nic není hotové; když se soustředí na dvě, dokončí je rychleji.

**Kdy vodopád a kdy agilně** (častá doptávka):

| Vodopád | Agilně |
|---|---|
| požadavky jsou **jasné a neměnné** | požadavky se budou **měnit** |
| regulované prostředí, nutná dokumentace | rychlá zpětná vazba je důležitější |
| fixní rozsah i cena ve smlouvě | prostor pro průběžné upřesňování |
| stavebnictví, certifikace | **vývoj software** — typicky agilně |

**Poctivá odpověď u e-shopu:** hybridní přístup. Rámec projektu (rozpočet, milníky, dodávky) řídit formálně, **vlastní vývoj agilně ve dvoutýdenních sprintech**. Přesně to je PRINCE2 Agile, které zadání zmiňuje.

---

### Postup u zkoušky (60 min přípravy)

<!-- Pořadí podle zadání. Povinné úkoly první, rozšíření až zbude čas. -->

**0–5 min — osnova dokumentu**

1. **Založ dokument a napiš do něj nadpisy podle zadání.** Čtyři povinné úkoly + rozšíření. Tím máš strukturu a nic nezapomeneš.
2. Přečti zadání **dvakrát** a podtrhni čísla: rozpočet, termín, co se má nahradit.

**5–20 min — úkol 1: SMART cíle**

3. Rozděl hlavní cíl na **4–6 dílčích** — analýza, návrh, vývoj, migrace, spuštění, školení.
4. Každý napiš **s konkrétními čísly a datem**. Bez čísel to není SMART.

**20–32 min — úkol 2: SWOT**

5. Čtyři kvadranty, **3–5 položek v každém**. Hlídej interní vs. externí.
6. Doplň **strategie SO/ST/WO/WT** — to je nad rámec základního zadání a je vidět.

**32–44 min — úkol 3: tým a RACI**

7. Navrhni **6–8 rolí** (zadání jmenuje PM, programátory, architekta, UI/UX, QA).
8. Matice: řádky = úkoly z WBS, sloupce = role. **Zkontroluj, že každý řádek má právě jedno A.**

**44–55 min — úkol 4: rizika**

9. **5–8 rizik** s pravděpodobností, dopadem a strategií.
10. Ke každému **konkrétní opatření**, ne jen „budeme sledovat".

**55–60 min — rozšíření a export**

11. Co stihneš: finanční rozvaha, harmonogram, agilní prvky, šablony.
12. **Export do PDF** — zadání ho explicitně vyžaduje. Nenech to na poslední minutu.

**Když ti dojde čas:** čtyři povinné úkoly pořádně jsou lepší než osm odbytých. Rozšíření zmiň aspoň v bodech s poznámkou „takto bych postupoval".

---

### Rozbor ukázkové úlohy

> **Cíl:** *„Z důvodu nízkých prodejů žvýkaček s vtipným tetováním pro programátory v kamenných obchodech a vysokých provozních nákladech chceme přejít na internetové řešení prodeje formou e-shopu do jednoho roku. Na implementaci máme 5 milionů Kč."*

**Co z cíle vytěžit hned:** rozpočet **5 000 000 Kč**, termín **12 měsíců**, důvod **vysoké provozní náklady** (takže úspěch se měří i úsporou, ne jen tržbami), a produkt je **specifický segment** (dárkové zboží pro programátory).

#### Úkol 1 — rozdělení na SMART cíle

| # | Dílčí cíl (SMART) | Termín |
|---|---|---|
| 1 | Do konce 2. měsíce dokončit analýzu požadavků a vybrat technologický stack; výstupem je schválený dokument s min. 30 funkčními požadavky | měsíc 2 |
| 2 | Do konce 4. měsíce dodat návrh UX (wireframy všech 12 klíčových obrazovek) a architektury, schválený zadavatelem | měsíc 4 |
| 3 | Do konce 7. měsíce dodat MVP s katalogem 200 produktů, košíkem a platbou kartou, které projde interním testováním | měsíc 7 |
| 4 | Do konce 9. měsíce dokončit migraci 100 % produktových dat a projít externím bezpečnostním auditem bez kritických nálezů | měsíc 9 |
| 5 | Do konce 10. měsíce proškolit 100 % zaměstnanců (15 osob) na nové procesy, ověřeno testem s úspěšností min. 80 % | měsíc 10 |
| 6 | Do konce 12. měsíce spustit ostrý provoz a dosáhnout min. 300 objednávek měsíčně při dostupnosti systému 99,5 % | měsíc 12 |

**Proč to funguje:** každý cíl má **číslo** (30 požadavků, 200 produktů, 99,5 %) a **datum**. To je rozdíl mezi SMART a přáním.

#### Úkol 2 — SWOT analýza

| | **Pomáhá** | **Škodí** |
|---|---|---|
| **Interní** | **Silné stránky (S)**<br>• zavedená značka a existující zákazníci<br>• vlastní sklad a logistika<br>• specifický produkt s jasnou cílovou skupinou<br>• dostatečný rozpočet (5 mil.) | **Slabé stránky (W)**<br>• nulová zkušenost s e-commerce<br>• zaměstnanci zvyklí na kamenný prodej<br>• neexistující databáze produktů v digitální podobě<br>• žádná online marketingová historie |
| **Externí** | **Příležitosti (O)**<br>• dlouhodobý růst online nákupů<br>• cílová skupina (programátoři) nakupuje online nadprůměrně<br>• možnost expanze mimo region i do zahraničí<br>• nižší provozní náklady než prodejny | **Hrozby (T)**<br>• snadný vstup nové konkurence do e-commerce<br>• velké platformy (Amazon, Alza) jako substituty<br>• GDPR a legislativa e-shopů<br>• závislost na dopravcích a platebních branách<br>• výkyvy kupní síly |

**Odvozené strategie:**

- **SO:** využít existující zákazníky jako první uživatele e-shopu a zdroj recenzí
- **ST:** postavit se na specifičnosti produktu — velké platformy nemají dárkové zboží pro programátory
- **WO:** najmout externího konzultanta na e-commerce, aby slabina nebránila využití rostoucího trhu
- **WT:** nejprve pilotní provoz s omezenou skupinou, teprve pak plné spuštění

#### Úkol 3 — tým a RACI matice

**Navržený tým** (7 osob, celkem 3,8 FTE):

| Role | Úvazek | Odpovídá za |
|---|---|---|
| Projektový manažer (PM) | 0,4 | plán, rozpočet, komunikace se zadavatelem |
| Architekt / tech. lead (AR) | 0,4 | technická koncepce, code review |
| Backend vývojář (BE) | 1,0 | serverová logika, integrace |
| Frontend vývojář (FE) | 1,0 | uživatelské rozhraní |
| UI/UX návrhář (UX) | 0,3 | wireframy, design systém |
| QA / tester (QA) | 0,5 | testovací scénáře, kvalita |
| DevOps (DO) | 0,2 | nasazení, monitoring, infrastruktura |

**RACI matice:**

| Úkol | PM | AR | BE | FE | UX | QA | DO |
|---|---|---|---|---|---|---|---|
| Sběr a schválení požadavků | **A** | C | I | I | R | I | I |
| Návrh architektury | I | **A/R** | C | C | I | C | C |
| Návrh UX a wireframy | I | C | I | C | **A/R** | I | I |
| Vývoj katalogu produktů | I | C | **A/R** | R | C | I | I |
| Vývoj košíku a objednávek | I | C | **A/R** | R | C | C | I |
| Integrace platební brány | I | C | **A/R** | I | I | C | C |
| Testování a QA | I | C | C | C | I | **A/R** | I |
| Nasazení a infrastruktura | I | C | C | I | I | I | **A/R** |
| Migrace dat | **A** | C | R | I | I | C | R |
| Školení zaměstnanců | **A/R** | I | I | I | C | I | I |
| Komunikace se zadavatelem | **A/R** | C | I | I | I | I | I |

**Kontrola, kterou u obhajoby zmiň:**

- každý řádek má **právě jedno A** ✓
- nikdo není jen C a I ✓
- backend má nejvíc R — je to úzké hrdlo, **při zpoždění bych posílil právě tuhle roli**

#### Úkol 4 — rizika a strategie

| # | Riziko | P (1–5) | D (1–5) | Míra | Strategie | Konkrétní opatření |
|---|---|---|---|---|---|---|
| 1 | Výpadek platební brány | 2 | 5 | **10** | **Přenesení** | SLA s poskytovatelem, záložní brána |
| 2 | Únik osobních údajů | 2 | 5 | **10** | **Snížení** | externí bezpečnostní audit, šifrování, pravidelné aktualizace |
| 3 | Odchod klíčového vývojáře | 3 | 4 | **12** | **Snížení** | dokumentace, párové programování, code review |
| 4 | Zpoždění migrace dat | 4 | 3 | **12** | **Snížení** | začít migraci v 7. měsíci, ne na konci; průběžné testovací importy |
| 5 | Odpor zaměstnanců ke změně | 4 | 3 | **12** | **Snížení** | zapojit je do návrhu, školení, ambasadoři změny |
| 6 | Překročení rozpočtu | 3 | 4 | **12** | **Snížení** | rezerva 12 %, měsíční kontrola čerpání |
| 7 | Nízká návštěvnost po spuštění | 3 | 4 | **12** | **Snížení** | marketing zahájit už 2 měsíce před spuštěním |
| 8 | Zpoždění dodávky produktových fotografií | 3 | 2 | **6** | **Přijetí** | dočasně zástupné obrázky, doplnit průběžně |
| 9 | Nevyzkoušená technologie nefunguje | 2 | 5 | 10 | **Vyhnutí se** | použít zavedený framework, žádné experimenty na produkci |

**Proč jsou u čísel:** priorita se dá seřadit a komise vidí, že jsi o dopadu přemýšlel. Riziko s mírou 12 se řeší dřív než to s mírou 6.

#### Rozšíření 1 — finanční rozvaha

**Osobní náklady** (9 měsíců aktivní práce z 12měsíčního projektu):

| Role | Úvazek | Kč/měsíc | Celkem |
|---|---|---|---|
| Projektový manažer | 0,4 | 95 000 | 342 000 |
| Architekt / tech. lead | 0,4 | 120 000 | 432 000 |
| Backend vývojář | 1,0 | 100 000 | 900 000 |
| Frontend vývojář | 1,0 | 95 000 | 855 000 |
| UI/UX návrhář | 0,3 | 85 000 | 229 500 |
| QA / tester | 0,5 | 75 000 | 337 500 |
| DevOps | 0,2 | 110 000 | 198 000 |
| **Celkem** | **3,8 FTE** | | **3 294 000** |

**Ostatní náklady:**

| Položka | Kč |
|---|---|
| Licence a nástroje (Jira, Figma, IDE) | 100 000 |
| Hosting a infrastruktura (12 měsíců) | 150 000 |
| Integrace platební brány | 120 000 |
| Externí bezpečnostní audit | 180 000 |
| Marketing a spuštění | 300 000 |
| Školení zaměstnanců | 100 000 |
| Migrace dat a fotografií produktů | 150 000 |
| **Celkem** | **1 100 000** |

**Souhrn:**

| | Kč | Podíl |
|---|---|---|
| Osobní náklady | 3 294 000 | 65,9 % |
| Ostatní náklady | 1 100 000 | 22,0 % |
| **Přímé náklady** | **4 394 000** | 87,9 % |
| **Rezerva na rizika** | **606 000** | **12,1 %** |
| **Rozpočet celkem** | **5 000 000** | 100 % |

**Tři věci, které na téhle tabulce obhájíš:**

1. **Součet sedí přesně na zadaných 5 milionů** — komise si to spočítá.
2. **Rezerva 12,1 %** je v doporučeném rozmezí 10–20 %. Bez rezervy je rozpočet nerealistický.
3. **Osobní náklady jsou 66 %** přímých nákladů, což u IT projektu odpovídá (typicky 60–70 %).

**Návratnost investice:** provoz kamenných prodejen stojí odhadem 3,6 mil. Kč ročně, provoz e-shopu 1,2 mil. Kč. Roční úspora **2,4 mil. Kč** → investice se vrátí za **2,1 roku**. To je argument pro zadavatele, proč projekt vůbec dělat.

#### Rozšíření 2 — harmonogram

```
Fáze                          Měsíc:  1  2  3  4  5  6  7  8  9 10 11 12
──────────────────────────────────────────────────────────────────────────
Zahájení a analýza                    ██ ██
Návrh (UX + architektura)                ██ ██ ██
Vývoj MVP                                   ██ ██ ██ ██ ██
Testování a bezpečnostní audit                       ██ ██ ██ ██
Migrace dat                                             ██ ██ ██
Pilotní provoz                                                ██ ██
Školení a komunikace                                          ██ ██ ██
Ostrý provoz a stabilizace                                          ██ ██
```

**Kritická cesta:** analýza → návrh → vývoj MVP → testování → pilot → ostrý provoz. **Zpoždění kterékoli z těchto fází posune spuštění.** Migrace dat a školení běží paralelně, takže mají rezervu.

**Milníky** (kontrolní body pro zadavatele):

| Milník | Měsíc | Kritérium |
|---|---|---|
| M1 — schválené požadavky | 2 | podpis zadavatele |
| M2 — schválený návrh | 4 | wireframy a architektura |
| M3 — funkční MVP | 7 | projde interním testem |
| M4 — bezpečnostní audit | 9 | bez kritických nálezů |
| M5 — pilotní provoz | 10 | 50 reálných objednávek |
| M6 — ostrý provoz | 12 | spuštění a dostupnost 99,5 % |

#### Rozšíření 3 — agilní prvky

| Prvek | Jak konkrétně |
|---|---|
| **Dvoutýdenní sprinty** | vývoj rozdělen na 14denní iterace s dodávkou na konci |
| **Product backlog** | seřazený seznam funkcí, priority mění zadavatel |
| **Denní standupy** | 15 minut, tři otázky |
| **Sprint review se zadavatelem** | každé dva týdny ukázka — **včasná zpětná vazba** místo překvapení na konci |
| **Retrospektiva** | co zlepšit v procesu (= PDCA v praxi) |
| **Definition of Done** | kód + testy + code review + dokumentace + nasazeno na test |
| **WIP limit** | max. 3 úkoly ve sloupci „rozpracováno" |
| **MVP a inkrementy** | nejdřív katalog a košík, teprve pak věrnostní program |

**Hybridní přístup pro obhajobu:** *„Rámec projektu (milníky, rozpočet, reporting zadavateli) bych řídil formálně podle PRINCE2, protože zadavatel potřebuje jistotu ohledně rozpočtu a termínu. Vlastní vývoj bych vedl agilně ve sprintech, protože požadavky na e-shop se během vývoje upřesní. To je přesně princip PRINCE2 Agile."*

#### Rozšíření 4 — management změn

Zadání chce „hladký přechod z pohledu interních procesů". Tohle je o **lidech**, ne o technologii — a je to nejčastěji podceňovaná část.

**Model ADKAR** — pět fází, kterými musí projít každý zaměstnanec:

| Fáze | Co znamená | Konkrétní nástroj |
|---|---|---|
| **A**wareness | ví, že změna přijde a proč | úvodní setkání s vysvětlením ekonomických důvodů |
| **D**esire | chce se zapojit | ukázat, co z toho mají (méně rutiny, nové dovednosti) |
| **K**nowledge | ví, jak to dělat | školení, manuály, videonávody |
| **A**bility | umí to použít | cvičné prostředí, pilotní provoz, podpora |
| **R**einforcement | udrží si nový způsob | zpětná vazba, ocenění, měření výsledků |

**Nejčastější chyba:** organizace skočí rovnou na Knowledge (uspořádá školení) a přeskočí Awareness a Desire. Lidé pak sedí na školení, ale nechápou proč — a po něm se vrátí ke starému způsobu.

**Konkrétní opatření pro e-shop:**

1. **Komunikační plán** — měsíční informační schůzky od začátku projektu, ne až před spuštěním
2. **Ambasadoři změny** — 2–3 zaměstnanci zapojení do návrhu, kteří pak pomáhají ostatním
3. **Školení ve dvou vlnách** — nejdřív ambasadoři, pak zbytek (s jejich pomocí)
4. **Pilotní provoz** — měsíc souběžného provozu prodejny i e-shopu, aby se procesy usadily
5. **Sběr zpětné vazby** — anonymní dotazník po 2 týdnech provozu + otevřený kanál pro připomínky
6. **Postupné vypínání** — kamenné prodejny zavírat postupně, ne naráz

**Věta, která to shrne:** *„Technicky je projekt hotový, když funguje e-shop. Z pohledu organizace je hotový, až když zaměstnanci pracují po novém a nevracejí se ke starým postupům. To je rozdíl mezi nasazením a skutečnou změnou."*

---

### Příklady na procvičení

Zadání může přijít s jiným projektem. **Struktura odpovědi zůstává stejná** — SMART, SWOT, tým a RACI, rizika, rozšíření.

#### Příklad 1 — migrace firemních systémů do cloudu

> Firma s 200 zaměstnanci provozuje vlastní servery. Kvůli vysokým nákladům na údržbu a stárnoucímu hardwaru chce přejít do cloudu do 18 měsíců. Rozpočet 8 milionů Kč.

*Na co myslet:* rizika jsou jiná — **výpadek za provozu**, vendor lock-in, náklady na přenos dat, bezpečnost. Tým potřebuje **cloud architekta** a **specialistu na bezpečnost**. Migrace po etapách (nejdřív nekritické systémy). Ve SWOT hraje roli závislost na jednom poskytovateli.

#### Příklad 2 — vývoj mobilní aplikace pro objednávání jídla

> Restaurace chce vlastní aplikaci místo drahých provizí agregátorům. Termín 8 měsíců, rozpočet 3 miliony.

*Na co myslet:* **dvě platformy** (iOS/Android) — nativně, nebo cross-platform? To je klíčové rozhodnutí s dopadem na rozpočet. Rizika: schvalovací proces v App Store, získání uživatelů (nejtěžší část). Ve SWOT je hrozbou právě síla agregátorů.

#### Příklad 3 — zavedení systému pro správu dokumentů

> Úřad s 500 zaměstnanci přechází z papírové agendy na elektronický systém spisové služby. Termín 2 roky, rozpočet 12 milionů.

*Na co myslet:* **legislativa je zásadní** (zákon o archivnictví, GDPR, eIDAS). Management změn je tady nejtěžší část — velká organizace, dlouhé zvyky. Rizika: neúplná migrace historických dokumentů, odpor zaměstnanců. Vhodná je **vodopádová metodika s formálními etapami**, protože požadavky plynou z legislativy a nemění se.

---

### Co si nacvičit

- [ ] **Ukázková úloha z PDF celá písemně** — všechny čtyři povinné úkoly, na časovku 60 minut
- [ ] Aspoň jeden [příklad na procvičení](#příklady-na-procvičení)
- [ ] **Zpaměti: SMART** — a umět na místě přepsat vágní cíl na konkrétní
- [ ] **Zpaměti: SWOT kvadranty** a co je interní vs. externí
- [ ] **Zpaměti: RACI** a pravidlo jednoho A
- [ ] **Zpaměti: čtyři strategie rizik** (přijetí, přenesení, vyhýbání, snížení)
- [ ] Projektový trojúhelník a co se stane při změně rozsahu
- [ ] PDCA cyklus a jeho vazba na retrospektivu
- [ ] Rozdíl SCRUM / Kanban / PRINCE2 a **kdy který**
- [ ] Sestavit finanční rozvahu tak, aby **součet seděl na zadaný rozpočet** a měla rezervu
- [ ] Vysvětlit ADKAR a proč se nestačí školit

---

### Poznámky

<!-- Sem vlastní výpisky, šablony, útržky. -->

---

### Na co se doptají

- **Přepiš tenhle vágní cíl podle SMART.** — Doplním **konkrétní číslo** (kolik, jak měřím) a **termín**. „Vytvoříme moderní e-shop" → „Do 31. 8. 2027 spustíme e-shop s katalogem 200 produktů a platbou kartou, který zvládne 500 objednávek denně, v rozpočtu 3,5 mil. Kč."
- **Proč může být v RACI jen jedno A?** — Protože **A je ten, kdo rozhoduje a schvaluje**. Kdyby byla dvě, není jasné, kdo má poslední slovo při neshodě, a odpovědnost se rozplyne. R může být víc, A jen jedno.
- **Kdy zvolíš vodopád a kdy agilní přístup?** — Vodopád, když jsou požadavky **jasné a neměnné** a prostředí regulované (legislativa, certifikace). Agilně, když se požadavky budou **upřesňovat** a je potřeba rychlá zpětná vazba. U e-shopu bych volil **hybrid** — formální rámec, agilní vývoj.
- **Jak konkrétně bys řídil změnu rozsahu uprostřed projektu?** — Přes **projektový trojúhelník**: zákazník musí vědět, že nová funkce znamená buď posun termínu, nebo víc peněz, nebo vyhození jiné funkce. Formálně: žádost o změnu → dopadová analýza (čas, peníze, rizika) → rozhodnutí projektového výboru → aktualizace plánu. **Nikdy ne tiché přijetí** — to je cesta k překročení rozpočtu.
- **Jaký je rozdíl mezi SWOT a PEST?** — SWOT má **čtyři kvadranty** a mísí interní i externí pohled. PEST analyzuje **jen vnější makroprostředí** (politické, ekonomické, sociální, technologické) a jeho výstupy se použijí jako vstup do O a T ve SWOT.
- **Do kterého kvadrantu SWOT patří silná konkurence?** — Do **hrozeb (T)**, protože je to **externí** faktor, který neovlivníš. Častá chyba je dávat ji do slabých stránek.
- **Co je rezerva v rozpočtu a kolik má být?** — Částka na nepředvídané události, **10–20 %** rozpočtu. Bez ní je plán nerealistický — každý projekt narazí na něco neočekávaného. V mém návrhu je 606 000 Kč, tedy 12,1 %.
- **Jak ohodnotíš riziko?** — **Pravděpodobnost × dopad**, obojí na škále 1–5. Součin dá prioritu 1–25 a podle ní se rizika řadí. Riziko s mírou 12 se řeší dřív než to s mírou 6.
- **Co znamená přijetí rizika a kdy ho použiješ?** — **Vědomé rozhodnutí** nedělat proti riziku nic, protože opatření by stálo víc než škoda. Musí být **zapsané v registru rizik** — jinak to není přijetí, ale opomenutí.
- **K čemu je WBS?** — Rozpad projektu na pracovní balíky. Z něj se odvozuje harmonogram, rozpočet i RACI. Platí **pravidlo 100 %** (co v WBS není, se neudělá) a **8/80** (balík 8–80 hodin).
- **Co je kritická cesta?** — Nejdelší řetěz vzájemně závislých úkolů. **Zpoždění kterékoli úlohy na ní zpozdí celý projekt**, protože nemá časovou rezervu. Úkoly mimo ni rezervu mají.
- **Jaké jsou role ve SCRUMu?** — **Product Owner** (priority a business hodnota), **Scrum Master** (odstraňuje překážky, hlídá proces), **vývojový tým** (samoorganizovaný, dodává). PM v klasickém smyslu ve SCRUMu není.
- **Co jsou WIP limity a proč fungují?** — Omezení počtu souběžně rozpracovaných úkolů. Když se dělá na všem naráz, nic není hotové — **omezením paralelní práce se zkrátí průběžná doba** dokončení jednotlivých položek.
- **Proč nestačí lidi na novou aplikaci vyškolit?** — Školení řeší jen fázi **Knowledge** z modelu ADKAR. Bez **Awareness** (proč se to děje) a **Desire** (proč bych chtěl) se lidé po školení vrátí ke starým postupům. A bez **Reinforcement** změna nevydrží.
- **Co je lessons learned a proč se na to zapomíná?** — Zápis poučení z projektu při jeho ukončení. Zapomíná se, protože po dokončení už všichni pracují na dalším projektu — ale je to jediná fáze, ze které má organizace **dlouhodobý** užitek.

---

### Užitečné odkazy

- Návrh a architektura softwarových projektů: [SZZVP návrhové vzory](../../SZZVP/04-navrhove-vzory/)
- Argumentace o návrhu aplikace: [okruh 11](../11-multimedia-a-pocitacova-grafika/)
