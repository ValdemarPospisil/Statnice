## 5 — Architektura počítačů: diagnostika a řešení problémů

- [Zadání okruhu (PDF)](../ZadaniOkruhu/PCA-II.pdf)

> Dostaneš **simulovanou závadu**: identifikovat ji, nasadit diagnostické nástroje, vyřešit, zaznamenat postup a případně navrhnout upgrade. 60 minut přípravy, pak 20 minut obhajoby.

**Pozor na jednu věc, kterou zadání říká a snadno se přehlédne:** mezi dostupnými materiály je **„počítač s vadným hardwarem"** a nástroje MemTest86+, CPU-Z, GPU-Z. Takže to nebude jen povídání u tabule — pravděpodobně budeš mít **fyzický stroj**, na kterém máš závadu najít. Plus **internet** (ceníky a benchmarky), stejně jako u [okruhu 4](../04-architektura-vyber-komponent/).

**Z toho plyne, co se učit:** ne seznam závad k memorování, ale **systematický postup**, který dojde k příčině i u závady, kterou jsi nikdy neviděl. Komise nesleduje, jestli uhádneš správnou komponentu — sleduje, jestli **nehádáš**.

> **Nejčastější způsob, jak tenhle okruh pokazit:** začít vyměňovat součástky podle dojmu. Správná odpověď na „počítač nejde zapnout" není „bude to zdroj", ale **„nejdřív ověřím, jestli jde napájení, a pak postupuji takhle…"**.

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn na jedno místo, pak výklad. -->

#### Souhrn na jednom místě

| Oblast | Co umět | Klíčový nástroj |
|---|---|---|
| **Systematický postup** | od nejjednoduššího a nejpravděpodobnějšího; **měnit jednu věc naráz** | papír a tužka (záznam!) |
| **Napájení** | ověřit zdroj zkratováním pinů (paperclip test), změřit napětí | tester zdroje, multimetr |
| **POST a signalizace** | pípání, diagnostické LED, POST kódy na displeji desky | manuál desky |
| **Minimální sestava** | deska + CPU + 1× RAM + zdroj, nic víc | — |
| **RAM** | testovat po jednom modulu, ve správném slotu | **MemTest86+** |
| **Disk** | SMART atributy, přemapované sektory | **CrystalDiskInfo**, `smartctl` |
| **Teploty** | throttling, zaschlá pasta, zanesené chladiče | HWiNFO64, Core Temp |
| **Grafika** | zkusit integrovanou, přehodit slot, jiný kabel | **GPU-Z**, FurMark |
| **Identifikace HW** | co v tom stroji vlastně je | **CPU-Z**, HWiNFO64 |
| **Logy systému** | modré obrazovky, chyby disku | Prohlížeč událostí, `journalctl` |
| **Upgrade** | co vyměnit, aby to nejvíc pomohlo, a jestli to sedí | ceníky, [okruh 4](../04-architektura-vyber-komponent/) |

**Tři pravidla, která rozhodují o úspěchu:** postupuj od nejjednoduššího, měň **jednu věc naráz**, a **zapisuj si každý krok** (zadání to explicitně vyžaduje).

#### Systematický postup — obecné jádro

Tohle je nejdůležitější věc v celém okruhu. Ať dostaneš jakoukoli závadu, postup je vždycky stejný:

```
1. ZJISTIT PŘÍZNAKY   Co přesně se děje? Kdy to začalo? Co se změnilo?
                      -> "nejde zapnout" je jiná závada než "zapne a hned zhasne"

2. ROZDĚLIT NA POLOVINY  Jde vůbec napájení? -> ANO/NE rozdělí prostor příčin

3. VYLOUČIT NEJJEDNODUŠŠÍ  kabel, zásuvka, vypínač zdroje, monitor na jiném vstupu
                           -> tady končí většina "závad" v praxi

4. MINIMÁLNÍ SESTAVA   odpojit vše nepodstatné; když naskočí, přidávat PO JEDNOM

5. NASADIT NÁSTROJ     MemTest86+ na RAM, SMART na disk, teploty na throttling

6. ZÁMĚNA ZA ZNÁMÉ DOBRÉ  jediný spolehlivý test u zdroje a desky

7. ZAZNAMENAT          co jsem zkusil, co to udělalo, co z toho plyne
```

**Krok 2 je to, co odlišuje diagnostiku od hádání.** Každý test má rozdělit množinu možných příčin na polovinu — jako binární vyhledávání. Když se otáčejí ventilátory, zdroj aspoň částečně funguje a můžeš se soustředit jinam.

**Krok 6 je nutný u zdroje a desky**, protože se nedají otestovat softwarově. „Vyměnil jsem zdroj a začalo to fungovat" je platný důkaz; „zdroj vypadá staře" není.

#### Příznak → pravděpodobná příčina

Tabulka, kterou si zapamatuj. **Pořadí ve sloupci „příčiny" je pořadí, ve kterém ověřovat.**

| Příznak | Pravděpodobné příčiny (od nejčastější) | Čím ověřit |
|---|---|---|
| **Vůbec nic se nestane** (žádné LED, ventilátory) | kabel/zásuvka, vypínač zdroje, **zdroj**, vypínač na skříni, deska | paperclip test zdroje, zkusit jiný kabel |
| **Ventilátory se rozjedou, ale černá obrazovka** | **RAM** (špatně dosednutá), grafika, monitor/kabel, CPU, deska | pípání/LED, přesadit RAM, integrovaná grafika |
| **Zapne a po pár sekundách zhasne** | přehřátí (chladič nedosedá), zkrat, **zdroj** nedodá proud | zkontrolovat chladič, minimální sestava |
| **Cyklicky se restartuje** | zdroj, přehřátí, vadná RAM, BIOS | teploty, MemTest86+ |
| **Modré obrazovky (BSOD) náhodně** | **RAM**, ovladače, přehřátí, disk | MemTest86+, Prohlížeč událostí |
| **Mrzne při zátěži** | **přehřátí**, zdroj, nestabilní přetaktování | HWiNFO64 při zátěži |
| **Systém startuje minuty, občas zamrzne** | **umírající disk** | SMART (CrystalDiskInfo) |
| **Nevidí disk** | kabel SATA/napájení, špatný M.2 slot, BIOS, vadný disk | BIOS, přehodit kabel/slot |
| **Artefakty na obrazovce, pády her** | **grafika** (přehřátí nebo vada), VRAM, ovladače | GPU-Z teploty, FurMark, jiná karta |
| **Nefunguje po upgradu** | **kompatibilita** (socket, DDR4/5), starý BIOS, málo wattů | manuál desky, sekce CPU support |
| **Pípá při startu** | podle kódu — obvykle RAM nebo grafika | **manuál konkrétní desky** |
| **Hlučný počítač** | zanesené chladiče, vadné ložisko ventilátoru, fan curve | vizuální kontrola, BIOS |

**Ta tabulka není k memorování zpaměti.** Důležitý je vzor: **nejčastější příčina je skoro vždycky ta nejjednodušší** (kabel, nedosednutá RAM, prach). Drahé komponenty (deska, CPU) selhávají nejméně často — a přesto na ně lidi tipují první.

#### Napájení a POST

**První otázka u každé závady se startem:** dostane se do počítače elektřina?

**Paperclip test** (zkouška zdroje bez počítače): odpoj zdroj od desky, na 24pinovém konektoru spoj **zelený vodič (PS_ON, pin 16)** se **kterýmkoli černým (zem)**. Zapni vypínač na zdroji. Když se rozběhne ventilátor, zdroj aspoň startuje. **Neznamená to, že je v pořádku** — může nedodávat stabilní napětí pod zátěží. Ale když se nerozběhne, je zdroj vadný.

Napětí na větvích má být (±5 %):

| Větev | Barva vodiče | Tolerance |
|---|---|---|
| +12 V | žlutá | 11,4–12,6 V |
| +5 V | červená | 4,75–5,25 V |
| +3,3 V | oranžová | 3,14–3,47 V |

**POST** (Power-On Self-Test) je samotest při startu. Když selže, deska to hlásí:

- **Pípáním** — kódy se **liší podle výrobce BIOSu**, takže bez manuálu desky je nečti. Obecně: opakované krátké pípání bývá RAM, jedno dlouhé + dvě krátká grafika.
- **Diagnostickými LED** — moderní desky mají čtyři (CPU / DRAM / VGA / BOOT). Svítící DRAM znamená problém s pamětí. **Tohle je nejrychlejší diagnostika, jaká existuje** — kdyby to komise měla na desce, začni tady.
- **POST kódem** na dvouznakovém displeji (lepší desky). Kód se hledá v manuálu.

**Reset BIOSu** (ukázková úloha to zmiňuje) — vrátí nastavení do výchozího stavu, pomůže po neúspěšném přetaktování nebo špatné konfiguraci:

1. Vypnout a **odpojit od sítě**
2. Vyndat **baterii CMOS** (CR2032) na 30 sekund, nebo
3. Přemostit **jumper CLR_CMOS** na desce
4. Vrátit, zapnout — nastavení je výchozí (včetně data a boot order)

#### Diagnostické nástroje

Zadání jmenuje tři, ale je dobré znát víc:

| Nástroj | Na co | Co v něm hledat |
|---|---|---|
| **MemTest86+** | RAM | **Bootuje z USB**, testuje mimo systém. Jakákoli chyba = vadný modul. Nechat běžet aspoň jeden celý průchod. |
| **CPU-Z** | identifikace | Jaký přesně CPU, socket, kolik a jaké RAM moduly, v jakém režimu (single/dual channel), takty |
| **GPU-Z** | grafika | Model, VRAM, teploty, takty, **sensor log** při zátěži |
| **CrystalDiskInfo** | disk | **SMART atributy**, stav (Good/Caution/Bad), naběhané hodiny |
| **HWiNFO64** | vše dohromady | Teploty, napětí, otáčky ventilátorů — **nejlepší na sledování při zátěži** |
| **Prohlížeč událostí** (Windows) | logy | Kritické chyby, `Kernel-Power` (nečekané vypnutí), `disk` (chyby čtení) |
| **FurMark / Prime95** | zátěžový test | Odhalí nestabilitu, která se v klidu neprojeví. **Pozor, zahřeje to** |
| `smartctl`, `dmesg`, `journalctl` | Linux | Totéž z příkazové řádky |

**SMART atributy, které znamenají „vyměnit disk"** — tohle je oblíbená doptávka:

| Atribut | Co znamená |
|---|---|
| **Reallocated Sectors Count** (05) | Přemapované vadné sektory. **Cokoli nad 0 je varování**, rostoucí hodnota = disk umírá |
| **Current Pending Sector** (C5) | Sektory čekající na přemapování — **horší než 05**, data v nich jsou v ohrožení |
| **Uncorrectable Sector Count** (C6) | Nešly přečíst ani opravit → **ztráta dat** |
| Power-On Hours (09) | Naběhané hodiny — kontext, ne závada |
| **Percentage Used** (SSD) | Opotřebení flash. Nad 90 % plánuj výměnu |

**Klíčová věta k SMART:** disk s rostoucím počtem přemapovaných sektorů **je nutné vyměnit, i když ještě funguje**. SMART je varovný systém, ne indikátor poruchy — až selže úplně, je pozdě.

#### Teploty a throttling

**Throttling** = procesor nebo grafika sníží takty, aby se nepřehřály. Projev: počítač „je pomalý při zátěži, ale v klidu v pohodě".

Orientační mezní teploty:

| Komponenta | Běžně v klidu | Pod zátěží | Kritické |
|---|---|---|---|
| CPU | 30–45 °C | 60–80 °C | **nad 95 °C** (throttling) |
| GPU | 30–45 °C | 65–83 °C | **nad 90 °C** |
| SSD NVMe | 30–50 °C | do 70 °C | nad 75 °C |
| HDD | 25–40 °C | do 50 °C | nad 55 °C |

**Nejčastější příčiny přehřívání, v tomhle pořadí:**

1. **Zanesené chladiče prachem** — nejčastější a nejsnadnější k opravě
2. **Zaschlá teplovodivá pasta** — po 3–5 letech, projeví se skokově vysokou teplotou CPU
3. **Chladič nedosedá** — po neopatrné montáži; teplota vyletí na 100 °C do několika sekund
4. **Nefunkční ventilátor** — vizuální kontrola
5. **Špatné proudění ve skříni** — všechny ventilátory nasávají nebo vyfukují

#### Upgrade jako součást řešení

Zadání to výslovně vyžaduje: *„v případě potřeby navrhnout upgrade komponent"*. Nejde jen o opravu — komise chce vidět, že umíš určit **priority**.

**Co nejvíc pomůže, v tomhle pořadí** (u staršího počítače):

1. **HDD → SSD** — jednoznačně největší skok ve vnímané rychlosti. Start systému z minuty na deset sekund.
2. **Víc RAM** — když se systém swapuje na disk (8 → 16 GB)
3. **Grafika** — když jde o hry
4. **CPU** — nejdražší a nejméně efektivní, protože obvykle znamená **novou desku i RAM**

**Kdy upgrade nemá smysl a je lepší koupit nový stroj:**

- Socket je mrtvá platforma (LGA1151, AM3+) → nový CPU znamená deska + RAM + CPU = polovina nového počítače
- Zdroj by nezvládl novou grafiku → další položka
- Deska má DDR3 → paměti se dnes už nevyplatí kupovat
- **Součet dílčích upgradů překročí 60 % ceny nové sestavy**

Pravidlo pro obhajobu: **„vyměnit jednu komponentu se vyplatí, vyměnit tři už ne"**.

Podrobně ke kompatibilitě a dimenzování v [okruhu 4](../04-architektura-vyber-komponent/).

---

### Postup u zkoušky (60 min přípravy)

<!-- Časový rozpočet. Předpokládá, že máš k dispozici fyzický stroj. -->

**0–10 min — zjistit příznaky a zapsat výchozí stav**

1. **Přesně popsat, co se děje.** „Nejde zapnout" není diagnóza. Rozliš: nic se nestane / rozjedou se ventilátory / naskočí a zhasne / naskočí a nic na obrazovce.
2. **Založit si záznam na papír** — zadání explicitně chce *„proveďte záznam provedených kroků"*. Tabulka: co jsem zkusil → co to udělalo → co z toho plyne.
3. **Zjistit, co se změnilo.** Nová komponenta? Aktualizace? Přenášelo se to? Tohle bývá odpověď.

**10–35 min — zúžit na komponentu**

4. **Nejjednodušší věci první:** kabel, zásuvka, vypínač zdroje, monitor na správném vstupu, RAM dosednutá.
5. **Podívat se na diagnostické LED / poslechnout pípání.** Když deska hlásí DRAM, máš to za dvě minuty.
6. **Minimální sestava:** deska + CPU + jeden modul RAM + zdroj. Odpojit disky, grafiku (když je iGPU), přídavné karty, USB. Naskočí? Přidávej **po jednom**.
7. **Nasadit nástroj** podle podezření: MemTest86+ (RAM), CrystalDiskInfo (disk), HWiNFO64 (teploty).

**35–50 min — potvrdit a vyřešit**

8. **Potvrdit záměnou za známé dobré**, když jde o zdroj nebo desku. Bez toho je to jen hypotéza — a řekni to nahlas.
9. **Navrhnout řešení:** opravit (přesadit, vyčistit, přepastovat), nebo vyměnit.
10. **Zkontrolovat, že závada nemá druhotnou příčinu.** Vadná RAM může být důsledek přepětí ze zdroje — když vyměníš jen paměť, závada se vrátí.

**50–60 min — upgrade a sepsání**

11. **Navrhnout upgrade** podle priorit (SSD → RAM → GPU → CPU) a ověřit kompatibilitu se stávající deskou.
12. **Dopsat záznam** a připravit si tři věty: *co byla závada, jak jsem k tomu došel, co jsem s tím udělal*.

**Když závadu nenajdeš:** to není selhání, pokud umíš říct, **co jsi vyloučil a co by byl další krok**. Poctivé „vyloučil jsem RAM a disk, zbývá zdroj a deska, další krok je záměna zdroje" je lepší odpověď než nesprávný tip s jistotou v hlase.

---

### Ukázková úloha z PDF

> Uživatel si stěžuje, že se **počítač nespouští**. Po zapnutí se zobrazí **pouze černá obrazovka**.

#### Rozbor zadání

Formulace je záměrně nejednoznačná a **první věc je ji ujasnit**. „Nespouští se" a „černá obrazovka" jsou dvě různé závady:

| Co uživatel vidí | Co to znamená |
|---|---|
| Nic — žádné LED, ticho | **Vůbec nejde napájení** |
| Ventilátory se rozjedou, obrazovka černá | Napájení jde, **selhává POST** — zúžilo se to na RAM / GPU / CPU / desku |
| Naskočí a za pár sekund zhasne | Přehřátí nebo **zkrat / nedostatečný zdroj** |
| Obraz je, ale systém nenaběhne | Závada **disku nebo systému**, ne hardwaru desky |

**„Zobrazí se pouze černá obrazovka" napovídá, že něco naskočí** — takže druhý řádek. To je dobrá zpráva: zdroj aspoň částečně funguje.

**První otázka u zkoušky tedy zní:** „Rozjedou se ventilátory a svítí LED na desce?" Kdyby se komise vyptávala, co bys dělal, začni tímhle — ukazuje to, že neplýtváš časem na nesprávné poloviny.

#### Diagnostický postup

```
KROK 1  Napájení a viditelné projevy
        - svítí LED na desce?  otáčejí se ventilátory?
        - ANO -> zdroj aspoň startuje, jdi na KROK 3
        - NE  -> KROK 2

KROK 2  Zdroj
        - jiný napájecí kabel, jiná zásuvka, vypínač na zdroji
        - paperclip test (zelený + černý vodič na 24pinu)
        - rozběhne se ventilátor zdroje?  NE -> VADNÝ ZDROJ
        - ANO -> zdroj startuje, ale nemusí dodávat proud pod zátěží
                 -> záměna za známé dobrý zdroj

KROK 3  Signalizace desky   <- NEJRYCHLEJŠÍ CESTA
        - diagnostické LED (CPU / DRAM / VGA / BOOT)
        - pípání (kód podle manuálu DESKY, ne obecně)
        - POST kód na displeji
        -> svítí DRAM? jdi rovnou na KROK 5

KROK 4  Monitor a obraz  (vylučovací, trvá minutu)
        - správný vstup na monitoru (HDMI 1 vs. 2)?
        - kabel do GRAFIKY, ne do desky (když je dedikovaná karta)!
        - jiný kabel, jiný monitor

KROK 5  RAM   <- nejčastější příčina černé obrazovky
        - vyndat, vyfoukat slot, vrátit AŽ NA CVAKNUTÍ
        - zkusit JEDEN modul, v prvním doporučeném slotu (obvykle A2)
        - postupně každý modul zvlášť -> odhalí vadný
        - naskočí? -> MemTest86+ na potvrzení

KROK 6  Grafika
        - je iGPU? vyndat kartu, kabel do desky -> naskočí?
        - jiný PCIe slot, zkontrolovat napájecí konektory karty
        - dosednutí karty

KROK 7  Reset BIOSu
        - odpojit od sítě, vyndat CR2032 na 30 s (nebo jumper CLR_CMOS)
        - pomůže po neúspěšném přetaktování nebo špatné konfiguraci

KROK 8  Minimální sestava
        - deska + CPU + chladič + 1x RAM + zdroj, MIMO skříň na kartonu
          (vyloučí zkrat o skříň)
        - naskočí -> přidávat po jednom
        - nenaskočí -> CPU nebo DESKA -> záměna
```

**Proč v tomhle pořadí:** kroky jsou seřazené podle **(pravděpodobnost) ÷ (námaha)**. RAM je nejčastější příčina a přesadit ji trvá dvě minuty. Deska je nejvzácnější příčina a její výměna je nejdražší — proto je poslední.

#### Řešení a záznam

Zadání chce *„proveďte záznam provedených kroků, identifikace problému a jeho řešení"*. Šablona:

```
ZÁZNAM DIAGNOSTIKY

Příznak:     Po zapnutí se rozběhnou ventilátory, obrazovka zůstane černá,
             žádné pípání. Uživatel den předtím čistil počítač od prachu.

Krok  Co jsem zkusil                      Výsledek              Co z toho plyne
1     LED a ventilátory                   ventilátory jdou,     zdroj startuje;
                                          svítí DRAM LED        podezření na RAM
2     Monitor: vstup a kabel              bez změny             monitor vyloučen
3     Přesazení oba moduly RAM            naskočil POST         modul nedosedl
4     MemTest86+, 1 průchod               0 chyb                RAM je v pořádku

Diagnóza:    Nedosednutý modul RAM po čištění počítače.
Řešení:      Přesazení modulu do slotu A2 až na zacvaknutí. Ověřeno POST
             a jedním průchodem MemTest86+ bez chyb.
Prevence:    Po manipulaci vždy zkontrolovat dosednutí RAM, GPU a napájecích
             konektorů. Uživatele poučit, ať při čištění nevytahuje komponenty.
```

**Ten poslední řádek je bonus, který si nikdo nepamatuje udělat** — a přitom „prevence" ukazuje, že myslíš na uživatele, ne jen na součástku.

#### Návrh upgradu

Zadání ho žádá jako třetí bod, i když závada byla banální. Postup:

1. **Zjistit, co v tom stroji je** — CPU-Z (procesor, socket, RAM a její režim), CrystalDiskInfo (typ a stav disku).
2. **Najít úzké hrdlo:** je systém na HDD? Má 8 GB RAM? Běží paměti v single channel?
3. **Navrhnout podle priorit:**

```
Rozpočet 5 000 Kč na starší kancelářský počítač:
  1 TB NVMe SSD        1 800   <- největší efekt, systém z HDD na SSD
  +8 GB RAM (2. modul) 1 000   <- zapne dvoukanálový režim
  ------------------------------
                       2 800   zbytek jako rezerva nebo lepší chladič

Nedoporučuji: nový CPU. Socket je LGA1151 = mrtvá platforma,
znamenalo by to novou desku i paměti, tedy ~12 000 Kč.
```

**Ten poslední odstavec („nedoporučuji, protože…") je nejcennější část odpovědi.** Ukazuje, že rozumíš kompatibilitě a nesypeš ze sebe jen seznam dílů.

---

### Příklady na procvičení

U každého projdi postup nahlas: **příznak → co ověřím první → čím to potvrdím → řešení → prevence**. Nastav si 20 minut.

#### 1. Náhodné modré obrazovky (BSOD)

Počítač běží, ale několikrát denně spadne s modrou obrazovkou. Různé chybové kódy.

*Kudy na to:* různé kódy ukazují na **hardware, ne na ovladač** (ten by padal konzistentně). Nejčastěji **RAM** → MemTest86+ přes noc. Pak teploty (HWiNFO64 při zátěži) a zdroj. V Prohlížeči událostí hledej `Kernel-Power` a `WHEA-Logger`.

*Past:* přeinstalovat systém. Když je vadná RAM, závada se vrátí.

#### 2. Počítač je „pomalý", uživatel chce nový

Tři roky starý stroj, uživatel si stěžuje, že „všechno trvá věčnost". Rozpočet 6 000 Kč.

*Kudy na to:* nejdřív **zjistit, jestli je to závada nebo konfigurace**. CrystalDiskInfo (je systém na HDD? umírá disk?), Správce úloh (co žere výkon?), HWiNFO64 (throttluje?). Nejčastější příčiny: systém na HDD, málo RAM, zanesený chladič, nebo prostě zaplněný startup.

*Past:* rovnou navrhnout upgrade. **Nejdřív diagnostika** — možná stačí vyčistit chladič a odinstalovat pár programů, a to je nula korun.

#### 3. Po upgradu grafiky se počítač nespustí

Uživatel vyměnil kartu za výkonnější. Předtím to fungovalo.

*Kudy na to:* „co se změnilo" je odpověď — nová karta. Ověřuj v tomto pořadí: **napájecí konektory karty** (6+2 pin, zapojené oba?), **wattáž zdroje** (dost?), **dosednutí** v PCIe slotu, délka vs. skříň, aktualizace BIOSu. Vrať starou kartu → funguje? Tím máš potvrzeno.

*Past:* podezřívat kartu z vady. Statisticky je pravděpodobnější nedostatečný zdroj nebo nezapojený konektor.

#### 4. Hry se sekají, i když jsou parametry dostatečné

FPS klesá po pár minutách hraní, pak se drží nízko.

*Kudy na to:* „po pár minutách" je učebnicový **throttling**. GPU-Z / HWiNFO64 sensor log při hraní — sleduj teploty a takty. Nad 90 °C na GPU nebo 95 °C na CPU je jasno. Příčiny: prach, zaschlá pasta, nefunkční ventilátor, špatné proudění.

*Past:* upgradovat grafiku. Když throttluje, nová karta bude throttlovat taky.

#### 5. Disk se občas „ztratí"

Systém někdy nenajde druhý disk, po restartu je zpátky.

*Kudy na to:* **kabely první** — přehodit SATA kabel i napájecí, zkusit jiný port na desce. Pak SMART (CrystalDiskInfo — přemapované sektory?). Pak zdroj (nedodává stabilně?). U M.2 zkontroluj, že je slot správný — některé sdílí linky se SATA porty.

*Past:* formátovat disk. Když jde o mechanickou závadu nebo kabel, nepomůže to a přijdeš o data.

#### 6. Počítač se vypne při zátěži

V klidu běží, ale při hraní nebo renderu se po chvíli sám vypne (ne restart — vypne).

*Kudy na to:* **vypnutí bez modré obrazovky ukazuje na napájení nebo tepelnou ochranu.** Zkus: teploty pod zátěží (HWiNFO64), spočítat, jestli zdroj stačí (viz [okruh 4](../04-architektura-vyber-komponent/)), záměna zdroje. Prohlížeč událostí ukáže `Kernel-Power 41` (nečekané vypnutí), což to potvrdí, ale příčinu neřekne.

*Past:* podezřívat systém nebo ovladače. Tvrdé vypnutí je téměř vždy hardware.

---

### Šablona odpovědi u obhajoby

```
1. UJASNIT PŘÍZNAK   "Nejdřív bych se zeptal, jestli se rozjedou ventilátory -
                      to rozdělí příčiny na napájení versus POST."

2. POSTUP            od nejjednoduššího a nejpravděpodobnějšího;
                     u každého kroku říct, CO tím vylučuji

3. NÁSTROJ           čím to potvrdím (MemTest86+ / SMART / teploty)
                     a co konkrétně v tom výstupu hledám

4. ZÁZNAM            tabulka: krok -> výsledek -> co z toho plyne

5. DIAGNÓZA A ŘEŠENÍ  co byla závada, jak jsem to opravil, jak jsem to ověřil

6. PREVENCE          aby se to nestalo znovu

7. UPGRADE           priority (SSD -> RAM -> GPU -> CPU) + kompatibilita
                     a hlavně: co NEdoporučuji a proč
```

**Body 4 a 6 lidi zapomínají a zadání je explicitně chce.** Bod 7 s „nedoporučuji, protože socket je mrtvá platforma" je nejlepší způsob, jak ukázat, že rozumíš souvislostem.

---

### Co si nacvičit

- [ ] Ukázková úloha z PDF (černá obrazovka) — **celý rozhodovací postup nahlas**, včetně záznamu
- [ ] Aspoň tři z [příkladů na procvičení](#příklady-na-procvičení) — hlavně throttling a upgrade
- [ ] **Zpaměti: obecný postup** (příznaky → rozdělit na poloviny → nejjednodušší → minimální sestava → nástroj → záměna → záznam)
- [ ] **Zpaměti: co znamená svítící DRAM/VGA LED** a proč je to nejrychlejší diagnostika
- [ ] Paperclip test — umět popsat (zelený + černý na 24pinu)
- [ ] SMART atributy 05, C5, C6 a co znamenají
- [ ] Reset BIOSu dvěma způsoby (baterie / jumper)
- [ ] Mezní teploty CPU a GPU a co je throttling
- [ ] Priority upgradu a **kdy upgrade nemá smysl**
- [ ] Vyplnit záznam diagnostiky pro jednu z úloh — nanečisto, aby ses nezdržoval u zkoušky

---

### Poznámky

<!-- Sem vlastní výpisky, postupy, zkušenosti. -->

---

### Na co se doptají

- **Jak odlišíš vadnou grafiku od vadné základní desky?** — Zkusím **integrovanou grafiku** (vyndat kartu, kabel do desky). Naskočí-li obraz, je problém v kartě. Nenaskočí-li, jde o desku nebo CPU. Druhá možnost je dát kartu do jiného počítače, nebo jinou kartu do tohoto — **záměna za známé dobré**.
- **Co ti řekne SMART a kdy disk vyměnit, i když ještě funguje?** — SMART je vnitřní diagnostika disku. Klíčové atributy: **Reallocated Sectors (05)**, **Current Pending Sector (C5)**, **Uncorrectable (C6)**. Rostoucí počet přemapovaných sektorů znamená **vyměnit hned** — je to varování, ne porucha. Až selže úplně, je pozdě na záchranu dat.
- **Počítač náhodně mrzne — jak postupuješ?** — Nejdřív **teploty pod zátěží** (HWiNFO64), pak **MemTest86+** na RAM, pak logy (`Kernel-Power`, `WHEA-Logger`), pak zdroj. „Náhodně" a „při zátěži" jsou dvě různé závady — u zátěže mířím na teploty a zdroj, u náhodného na RAM.
- **Kdy má smysl upgradovat a kdy koupit novou sestavu?** — Když stačí **vyměnit jednu komponentu**, vyplatí se. Když by to znamenalo CPU + desku + RAM (mrtvý socket), nebo když součet překročí ~60 % ceny nové sestavy, je lepší nový stroj.
- **Proč postupuješ v tomhle pořadí?** — Podle **pravděpodobnosti dělené námahou**. RAM je nejčastější příčina a přesadit ji trvá dvě minuty; deska selhává nejméně často a je nejdražší. Každý krok má vyloučit co největší část možných příčin.
- **Jak zjistíš, jestli je vadný zdroj?** — Paperclip test řekne, jestli **vůbec startuje**. Že dodává **stabilní napětí pod zátěží**, se softwarově nezjistí — jedině multimetrem, testerem, nebo **záměnou za známé dobrý**. Tohle přiznat je správná odpověď.
- **Co je throttling a jak ho poznáš?** — Snížení taktů kvůli teplotě. Projev: „v klidu dobré, pod zátěží pomalé". Poznáš ho sledováním **teploty a taktu současně** (HWiNFO64) — takt klesá, když teplota narazí na limit.
- **Co uděláš jako první, když počítač vůbec nejde zapnout?** — Zkontroluju **napájecí kabel, zásuvku a vypínač na zdroji**. Zní to trivilně, ale je to statisticky nejčastější příčina a trvá to deset sekund.
- **Uživatel tvrdí, že „nic nedělal". Věříš mu?** — Ne, ale neřeknu to. Zeptám se konkrétně: *nebylo to přenášené? nečistil jste to? neinstalovalo se něco?* Odpověď na „co se změnilo" je nejrychlejší cesta k diagnóze.
- **K čemu je minimální sestava?** — Vyloučí všechno, co není nutné ke startu (disky, karty, USB, přední panel). Když naskočí, přidáváním **po jednom** najdeš viníka. Sestavení **mimo skříň** navíc vyloučí zkrat o kostru.
- **Proč nesmíš měnit dvě věci naráz?** — Protože pak nevíš, která pomohla — a když se závada vrátí, začínáš od nuly. Je to stejné pravidlo jako u ladění kódu v [okruhu 1](../01-programovani-funkce-a-cykly/).
- **Vyměnil jsi RAM a funguje to. Hotovo?** — Ne nutně. Zjistil bych, **proč se poškodila** — přepětí ze vadného zdroje poškodí i novou paměť. Pokud je zdroj podezřelý, zkontroloval bych napětí.

---

### Užitečné odkazy

- MemTest86+: <https://www.memtest.org>
- CPU-Z a další od CPUID: <https://www.cpuid.com>
- GPU-Z: <https://www.techpowerup.com/gpuz/>
- CrystalDiskInfo: <https://crystalmark.info/en/software/crystaldiskinfo/>
- HWiNFO64: <https://www.hwinfo.com>
- Výběr komponent a kompatibilita: [okruh 4](../04-architektura-vyber-komponent/)
