## 4 — Architektura počítačů: výběr komponent

- [Zadání okruhu (PDF)](../ZadaniOkruhu/PCA-I.pdf)

> Dostaneš **rozpočet a požadavky na funkčnost**. Vybereš komponenty, **zdůvodníš volbu**, popíšeš sestavení, instalaci OS a ovladačů a nastavení BIOSu. 60 minut přípravy, pak 20 minut obhajoby.

**Tohle je jediný okruh SZZPP, kde máš k dispozici internet.** Zadání ho uvádí černé na bílém: *„aktuální ceníky počítačových komponent, přístup k vybraným benchmarkovým serverům"*. Bez něj by to nešlo — ceny se mění týdně a nikdo po tobě nechce, abys je uměl zpaměti.

**Z toho plyne úplně jiná strategie než u okruhů 1–3.** Neučíš se konkrétní modely, ty si za hodinu vygooglíš. Učíš se **postup, kompatibilitní pravidla a argumentaci** — protože právě to internet nenahradí a právě na to se komise ptá.

> **Nejčastější způsob, jak tenhle okruh pokazit:** přinést hezkou tabulku sestavy a neumět odpovědět „a proč zrovna tohle?". Sestava bez zdůvodnění je bezcenná; **zdůvodnění bez perfektní sestavy projde**.

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn na jedno místo, pak výklad. -->

#### Souhrn na jednom místě

| Komponenta | Co určuje výkon | Na co se váže (kompatibilita) | Typický podíl rozpočtu |
|---|---|---|---|
| **CPU** (procesor) | jádra, takt, cache, generace | **socket** + chipset desky, TDP ↔ chladič | 20–30 % |
| **Základní deska** | nic přímo, ale limituje vše ostatní | socket CPU, typ RAM, formát skříně, sloty | 10–15 % |
| **RAM** (paměť) | kapacita, rychlost, latence | **DDR4 vs. DDR5** (nezáměnné!), max. takt desky | 10–15 % |
| **GPU** (grafika) | čip, VRAM, sběrnice | délka ↔ skříň, konektory zdroje, PCIe slot | 0–40 % |
| **Úložiště** | typ (NVMe/SATA/HDD), kapacita | M.2 slot ↔ deska, SATA porty | 10–15 % |
| **Zdroj** (PSU) | wattáž, účinnost (80+), konektory | součet spotřeby + rezerva, konektory GPU | 8–12 % |
| **Skříň** | průtok vzduchu | formát desky, délka GPU, výška chladiče | 5–10 % |
| **Chlazení** | odvod TDP | socket, výška ↔ skříň | 0–8 % |

**Tři věci, které rozhodují o úspěchu:** socket CPU musí sedět s deskou, typ RAM (DDR4/DDR5) musí sedět s deskou, a zdroj musí mít rezervu i konektory pro grafiku.

#### Procesor (CPU)

**Co dělá:** vykonává instrukce. Pro kancelář a web rozhoduje hlavně **takt jednoho jádra** (jednovláknový výkon), pro střih videa, kompilaci a virtualizaci **počet jader**.

Klíčové parametry, které umět přečíst z názvu:

```
Intel Core i5-13400F
           │ │  │ └── F = BEZ integrované grafiky (nutná dedikovaná GPU!)
           │ │  └──── model v rámci řady
           │ └─────── 13 = generace
           └───────── i5 = třída (i3 < i5 < i7 < i9)

AMD Ryzen 5 7600X
            │ │  └── X = vyšší takty
            │ └───── 7000 = generace (socket AM5, jen DDR5)
            └─────── 5 = třída (3 < 5 < 7 < 9)
```

**Přípona `F` u Intelu je klasická past:** ušetří pár stovek, ale **nemá integrovanou grafiku**. Do kancelářské sestavy bez dedikované GPU ji nedávej — počítač se nerozjede. Naopak když stejně kupuješ grafickou kartu, je to čistá úspora.

**Konkrétně:** i3-12100 (s grafikou) vs. i3-12100F (bez ní) — rozdíl je asi 300 Kč. Pokud v sestavě není GPU, těch 300 Kč **musíš** utratit.

**AMD:** procesory bez přípony `G` obvykle integrovanou grafiku nemají (u Ryzenů 7000 už mají slabou iGPU, u starších 5000 ne). Řady `G` (např. 5600G) mají grafiku výrazně silnější a hodí se přesně do kancelářských sestav bez GPU.

**TDP** (Thermal Design Power, ve wattech) říká, kolik tepla musí uchladit chladič. 65 W zvládne přibalený chladič, 105 W a víc chce lepší.

#### Základní deska

**Sama o sobě nezrychlí nic** — ale určuje, co do ní půjde zapojit. Proto se vybírá **až po procesoru**.

| Co hlídat | Proč |
|---|---|
| **Socket** | LGA1700 (Intel 12.–14. gen), AM4 (Ryzen 1000–5000), AM5 (Ryzen 7000+). **Musí přesně sedět.** |
| **Chipset** | Intel: H610 (základ) < B660/B760 (rozumný střed) < Z690/Z790 (přetaktování). AMD: A620 < B650 < X670. |
| **Typ RAM** | Deska je **buď DDR4, nebo DDR5** — nikdy obojí. Nezáměnné, jiný konektor. |
| **Formát** | ATX (velká) > Micro-ATX (mATX, běžná) > Mini-ITX (malá, dražší). Musí sedět do skříně. |
| **Sloty M.2** | Kolik NVMe disků půjde zapojit. |

**Nejčastější chyba v celém okruhu:** deska se socketem, který nesedí k procesoru. Ověř to **vždycky** — je to první věc, na kterou se komise ptá.

**Druhá nejčastější:** deska DDR4 a paměti DDR5 (nebo naopak). Fyzicky do sebe nejdou.

#### Operační paměť (RAM)

**Kapacita** je nejdůležitější:

| Kolik | Pro co |
|---|---|
| 8 GB | absolutní minimum, dnes už těsné i na kancelář |
| **16 GB** | **rozumný standard** pro kancelář i hry |
| 32 GB | střih videa, virtualizace, práce s velkými daty |

**Vždy dva moduly, ne jeden.** Dvoukanálový režim (dual channel) zvýší propustnost skoro dvojnásobně. Takže **2×8 GB, ne 1×16 GB** — za stejné peníze. U integrované grafiky je to zvlášť důležité, protože si bere paměť ze systémové RAM.

**Rychlost** (MHz) a **latence** (CL) rozhodují méně. U DDR4 je rozumné 3200 MHz CL16, u DDR5 5600 MHz a výš. **Rychlejší paměť než deska podporuje je vyhozené peníze** — poběží pomaleji.

#### Grafická karta (GPU)

**První otázka vždycky zní: potřebuje ji ta sestava vůbec?**

- **Kancelář, web, video, Office** → **ne**. Integrovaná grafika v CPU to zvládne bez problémů, včetně 4K videa a dvou monitorů. Ušetřených 5 000 Kč dej do CPU a SSD.
- **Hry, 3D, střih videa, CAD, trénování modelů** → **ano**, a je to obvykle největší položka rozpočtu.

**Tohle je nejlepší místo, kde u obhajoby ukázat, že přemýšlíš.** Ukázkové řešení v PDF dává do kancelářské sestavy GTX 1650 — což je při požadavku „Word, Excel, web, multimédia" **zbytečné**. Když na to upozorníš a nabídneš, že za ty peníze radši dáš rychlejší SSD a víc RAM, uděláš dojem. (Ale řekni to slušně — je to *ukázka*, ne dogma.)

Co u karty hlídat: **VRAM** (8 GB je dnes rozumné minimum na hry), **délka** (vejde se do skříně?), **napájecí konektory** (má je zdroj?).

#### Úložiště

| Typ | Rychlost (čtení) | Cena/GB | Kdy |
|---|---|---|---|
| **NVMe SSD** (M.2) | 3 000–7 000 MB/s | střední | **systémový disk — vždy** |
| SATA SSD | ~550 MB/s | střední | když deska nemá M.2 slot |
| HDD (plotnový) | ~150 MB/s | nejnižší | archiv, velké soubory, zálohy |

**Systém patří vždy na SSD.** Rozdíl mezi HDD a SSD je nejvíc znatelná změna, jakou v počítači uděláš — start systému z minuty na deset sekund. NVMe je proti SATA SSD v běžném provozu rozdíl malý, ale cena podobná, takže volíš NVMe.

**Typická kombinace do rozpočtu:** 500 GB NVMe (systém + programy) + 1–2 TB HDD (data), nebo prostě 1 TB NVMe, když data nejsou objemná.

#### Napájecí zdroj (PSU)

**Nejčastěji podceňovaná komponenta.** Špatný zdroj může při poruše zničit zbytek sestavy.

Jak dimenzovat:

```
1. Sečti TDP procesoru a spotřebu grafiky
   např. CPU 65 W + GPU 170 W = 235 W
2. Přičti ~100 W na zbytek (deska, disky, ventilátory)
   235 + 100 = 335 W
3. Přidej rezervu ~30 % (účinnost je nejvyšší kolem 50-70 % zátěže,
   a je kam růst při upgradu)
   335 x 1,3 = 435 W  ->  volím 500 W
```

**Certifikace 80+** (Bronze, Gold, Platinum) udává **účinnost** — kolik z odebrané energie se dostane do počítače a kolik se vyzáří jako teplo. 80+ Bronze má ~85 %, Gold ~90 %. Vyšší certifikace = nižší účet za elektřinu a méně tepla, ale dražší. **Do běžné sestavy Bronze stačí**, u výkonných strojů se Gold vyplatí.

**Nešetři na značce.** Neznačkový zdroj s nálepkou „700 W" často nedodá ani 400 W a při přetížení může vzít s sebou desku.

#### Instalace OS a ovladačů

Zadání to explicitně vyžaduje, takže tohle umět odvyprávět:

1. **Připravit instalační médium** — USB flash (min. 8 GB), nástroj Media Creation Tool (Windows) nebo Rufus/Ventoy (obecně), u Linuxu `dd` nebo balenaEtcher.
2. **V BIOSu nastavit boot z USB** — buď natrvalo v pořadí bootování, nebo jednorázově přes boot menu (obvykle F8/F11/F12 při startu).
3. **Rozdělit disk** — u nového disku stačí nechat instalátor, ať to udělá sám (vytvoří EFI, systémový a recovery oddíl).
4. **Nainstalovat systém**, restartovat, **vyndat USB**.
5. **Ovladače v tomhle pořadí:**
   - **chipset desky** (jako první — bez něj nefunguje správně nic dalšího)
   - grafika (od NVIDIA/AMD/Intel, ne ty z Windows Update)
   - síť, zvuk, případně čtečky
6. **Aktualizovat systém** a zkontrolovat ve Správci zařízení, že nikde není vykřičník.

**Windows 11 vyžaduje TPM 2.0 a Secure Boot** — obojí se zapíná v BIOSu (TPM může být skryté pod `fTPM` u AMD nebo `PTT` u Intelu). Tohle je oblíbená doptávka.

#### Nastavení BIOSu

| Co | Proč |
|---|---|
| **XMP** (Intel) / **EXPO** (AMD) | Paměti běží po zapnutí na základním taktu (např. 2133 MHz), i když jsi koupil 3200 MHz. **Jedno kliknutí = výkon zdarma.** Tohle je nejčastější doptávka. |
| **Boot order** | Aby počítač startoval z toho, z čeho chceš. |
| **Secure Boot + TPM** | Nutné pro Windows 11. |
| **SATA mode = AHCI** | Ne IDE — moderní režim pro SSD. |
| **Fan curve** | Nastavení otáček ventilátorů podle teploty (hluk vs. chlazení). |
| **Aktualizace BIOSu** | U nové desky se starším BIOSem nemusí nový procesor nastartovat. |

**Optimalizace výkonu** kromě XMP: zapnout **Resizable BAR** (u novějších GPU pár procent navíc), v systému nastavit **plán napájení na Vysoký výkon**, zkontrolovat, že se NVMe disk hlásí v PCIe režimu.

---

### Postup u zkoušky (60 min přípravy)

<!-- Tohle je jádro. Máš internet — využij ho na ceny, ne na učení. -->

**0–5 min — přečíst zadání a určit profil**

Nejdřív si odpověz na jedinou otázku, která rozhoduje o všem ostatním: **na co ten počítač bude?**

| Profil | Kam jdou peníze | Co se šetří |
|---|---|---|
| **Kancelář / web / multimédia** | CPU s integrovanou grafikou, SSD, 16 GB RAM | **žádná dedikovaná GPU** |
| **Hry** | GPU (klidně 40–50 % rozpočtu), pak CPU | levnější deska, jeden disk |
| **Střih videa / 3D** | CPU s víc jádry, 32 GB RAM, rychlé NVMe | grafika střední třídy stačí |
| **Programování / virtualizace** | RAM (32 GB), víc jader, dva monitory | grafika integrovaná |

Napiš si profil na papír jednou větou. **Tahle věta je pak odpověď na většinu doptávek.**

**5–15 min — hrubý rozpočet po položkách**

Rozděl rozpočet **procenty** ještě dřív, než něco vybereš. Zabrání to tomu, že utratíš 60 % za procesor a nezbude na disk.

```
Kancelář 15 000 Kč:
  CPU (s iGPU)     4 000   27 %
  Deska            2 000   13 %
  RAM 16 GB        1 800   12 %
  NVMe 500 GB      1 500   10 %
  HDD 1 TB         1 200    8 %
  Zdroj 450W       1 300    9 %
  Skříň            1 200    8 %
  ------------------------------
  celkem          13 000   87 %   -> 2 000 rezerva
```

**Nech si 10–15 % rezervu.** Ceny se liší podle obchodu a komise ocení, že s tím počítáš.

**15–40 min — konkrétní modely (tady používej internet)**

Pořadí výběru **má svou logiku** — jdi odshora, protože každý krok omezuje ten další:

1. **CPU** — z rozpočtu a profilu. Zkontroluj, jestli má **integrovanou grafiku**, když nekupuješ GPU.
2. **Deska** — podle **socketu** procesoru. Zvol chipset podle toho, co potřebuješ (přetaktování? kolik M.2?).
3. **RAM** — typ **podle desky** (DDR4/DDR5), vždy dva moduly.
4. **GPU** — jen když ji profil vyžaduje.
5. **Úložiště** — NVMe na systém, případně HDD na data.
6. **Zdroj** — spočítej podle vzorce výš, zaokrouhli nahoru.
7. **Skříň a chlazení** — formát desky, délka GPU, výška chladiče.

**Kde hledat:**

| Co | Kde | Na co dát pozor |
|---|---|---|
| Ceny a dostupnost | Alza, CZC, Czech Computer, Heureka | Ber **cenu s DPH** a ověř skladem |
| Kompatibilita celé sestavy | <https://pcpartpicker.com> | Automaticky hlásí konflikty (socket, RAM, wattáž) |
| Parametry CPU | <https://ark.intel.com>, <https://www.amd.com/en/products/specifications> | Oficiální — socket, TDP, **integrovaná grafika ano/ne** |
| Srovnání výkonu CPU | <https://www.cpubenchmark.net> | Jednovláknový vs. vícevláknový skór |
| Srovnání výkonu GPU | <https://www.videocardbenchmark.net> | Poměr výkon/cena |
| Podpora CPU u konkrétní desky | web výrobce desky, sekce „CPU support" | **Někdy je nutná aktualizace BIOSu!** |

**Kdybys neměl internet** (nebo selže): sestav to z logiky věci a **řekni to nahlas** — „konkrétní modely bych ověřil v ceníku, ale struktura sestavy by byla tahle a proč". Komise zajímá úvaha, ne katalogové číslo.

**40–50 min — kontrola kompatibility**

Projdi tenhle seznam **položku po položce**. Tady se ztrácejí body nejčastěji:

- [ ] **Socket CPU = socket desky** (LGA1700 / AM4 / AM5)
- [ ] **Typ RAM = typ desky** (DDR4 ≠ DDR5, fyzicky nezáměnné)
- [ ] Podporuje deska ten **takt RAM**, který jsi zvolil?
- [ ] Má deska **dost slotů M.2** pro tvé disky?
- [ ] **Bez dedikované GPU**: má CPU **integrovanou grafiku**? (pozor na `F` u Intelu)
- [ ] Má **zdroj dost wattů** a **správné konektory** pro grafiku (6+2 pin)?
- [ ] Vejde se **grafika do skříně** (délka) a **chladič** (výška)?
- [ ] Sedí **formát desky do skříně** (ATX / mATX / ITX)?
- [ ] Podporuje deska ten procesor **s aktuálním BIOSem**? (u nových CPU na starších deskách)

**50–60 min — sepsat zdůvodnění**

**Tohle je nejdůležitějších deset minut celé přípravy.** Ke každé komponentě jednu větu:

```
CPU  i3-12100 (4 jádra, iGPU)  — na Office a web bohatě stačí, integrovaná
                                 grafika ušetří 3 000 Kč za zbytečnou kartu
Deska B660M DDR4 mATX          — socket LGA1700 sedí k CPU, DDR4 je levnější
                                 než DDR5 a u téhle třídy výkonu se rozdíl neprojeví
RAM  2x8 GB DDR4-3200          — dva moduly kvůli dvoukanálovému režimu,
                                 16 GB je dnešní standard, iGPU si bere z RAM
```

Kdo umí odříkat tabulku takhle, ten okruh dá — i kdyby konkrétní modely nebyly nejlevnější možné.

---

### Ukázková úloha z PDF

> Navrhněte počítač pro **běžnou kancelářskou práci s internetem a multimédii**. Rozpočet **15 000 Kč**. Dostatečný výkon pro Office, web a přehrávání multimédií. Vysvětlete důvod volby.

#### Rozbor zadání

Klíčová slova jsou **„kancelářská práce, internet, multimédia"**. Ani slovo o hrách, střihu videa nebo 3D. Z toho plyne:

- **Dedikovaná grafika není potřeba** — integrovaná zvládne 4K video, dva monitory i weby s videem.
- **Nejsou potřeba desítky jader** — Office a prohlížeč využijí spíš rychlost jednoho jádra.
- **SSD je nutnost** — na vnímanou rychlost má větší vliv než procesor.
- **16 GB RAM** — prohlížeč s dvaceti panely a Excel to snadno spotřebují.

#### Poznámka k ukázkovému řešení v PDF

Ukázka v zadání obsahuje **GeForce GTX 1650** a procesor **i3-12100F** (přípona `F` = bez integrované grafiky). To je vnitřně konzistentní — když je v sestavě karta, `F` verze dává smysl a ušetří.

Ale při požadavcích *„Word, Excel, web, multimédia"* je ta karta **zbytečná**: stojí kolem 3 500 Kč, což je skoro čtvrtina rozpočtu. Za ty peníze se dá pořídit i3-12100 **s** integrovanou grafikou, větší SSD a lepší zdroj.

**U obhajoby to zmiň — ale opatrně a jako alternativu, ne jako opravu:**

> „Ukázkové řešení počítá s GTX 1650. Při zadaných požadavcích bych ji vynechal a použil procesor s integrovanou grafikou — ušetřených asi 3 000 Kč bych dal do většího SSD a kvalitnějšího zdroje. Kartu bych ponechal jen tehdy, kdyby se počítalo s příležitostným hraním nebo akcelerací střihu videa."

Tímhle ukážeš, že rozumíš **vazbě mezi požadavky a rozpočtem**, což je přesně to, co okruh zkouší. A necháváš otevřená vrátka, kdyby komise trvala na svém.

#### Vlastní návrh (struktura, ne konkrétní ceny)

| Komponenta | Volba | Odhad | Zdůvodnění |
|---|---|---|---|
| CPU | Intel i3-12100 **nebo** Ryzen 5 5600G | ~3 500 | 4–6 jader bohatě stačí; **s integrovanou grafikou** |
| Deska | B660M / A520M, mATX, DDR4 | ~2 000 | socket sedí, mATX je levnější a stačí |
| RAM | 2× 8 GB DDR4-3200 CL16 | ~1 800 | 16 GB standard, **dvoukanál** kvůli iGPU |
| SSD | 1 TB NVMe M.2 | ~1 800 | systém i data na jednom rychlém disku |
| Zdroj | 450–500 W, 80+ Bronze | ~1 200 | bez GPU stačí; značka, ne wattáž na papíře |
| Skříň | mATX s dobrým průtokem | ~1 200 | musí sednout formát desky |
| **Celkem** | | **~11 500** | rezerva ~3 500 na OS nebo lepší disk |

**Ceny jsou orientační** — u zkoušky je ověříš v ceníku. Důležitá je **struktura a poměry**, ne přesné částky.

**Kam dát rezervu, když zbude:** větší SSD → víc RAM → lepší zdroj. V tomhle pořadí, a umět to zdůvodnit.

---

### Příklady na procvičení

Vyřeš je stejně jako u zkoušky: **profil → rozpočet v procentech → konkrétní modely → kontrola kompatibility → zdůvodnění**. U každého si nastav 45 minut.

#### 1. Herní počítač za 30 000 Kč

Plynulé hraní současných her ve **Full HD při 60+ FPS**.

*Na co myslet:* GPU je největší položka (~40 %). Nepřepálit CPU — k GPU střední třídy stačí i5/Ryzen 5. Zdroj musí mít správné konektory a rezervu. 16 GB RAM stačí, 32 je zbytečné.

*Past:* koupit drahý procesor a slabou grafiku. U her je to skoro vždycky obráceně.

#### 2. Pracovní stanice pro střih videa za 45 000 Kč

Práce s 4K materiálem v DaVinci Resolve nebo Premiere.

*Na co myslet:* **32 GB RAM je minimum**, hodí se 64. Víc jader než u her. Rychlé NVMe na scratch disk + kapacitní úložiště na projekty. GPU se u střihu využije na akceleraci — ale nemusí to být to nejdražší.

*Past:* zapomenout na kapacitu úložiště. 4K materiál žere stovky GB.

#### 3. Kancelářský počítač za 8 000 Kč

Nejlevnější sestava, která ještě dává smysl pro Office a web.

*Na co myslet:* tady se ukáže, jestli umíš šetřit **na správných místech**. Integrovaná grafika povinně, 8 GB RAM (ale s možností dokoupit), levná deska, menší SSD. Zvaž **repasovaný počítač** — u tak nízkého rozpočtu je to legitimní odpověď a komisi tím překvapíš.

*Past:* koupit HDD místo SSD, abys ušetřil. Systém na HDD je dnes nepoužitelný.

#### 4. Tichý počítač do obývacího pokoje (HTPC) za 20 000 Kč

Přehrávání 4K videa, streamování, občasné hraní nenáročných her. **Priorita: co nejnižší hlučnost.**

*Na co myslet:* CPU s nízkým TDP, kvalitní chladič s velkým pomalým ventilátorem (nebo pasivní), SSD místo HDD (netočí se, neduní), zdroj s režimem zero-RPM, malá skříň s dobrým prouděním.

*Past:* zaměřit se jen na výkon a ignorovat zadání — priorita je **ticho**, ne FPS.

#### 5. Počítač pro programování a virtualizaci za 35 000 Kč

Docker, několik virtuálních strojů, dva monitory, IDE.

*Na co myslet:* **RAM je král** (32 GB, ideálně s možností na 64), víc jader pro paralelní build, rychlý NVMe. Grafika integrovaná stačí — ale ověř, že zvládne **dva monitory** (dnes ano). Zvaž ECC paměti, pokud jde o server.

*Past:* utratit za grafiku. K programování ji nepotřebuješ, dokud netrénuješ neuronové sítě.

#### 6. Upgrade pěti let starého počítače za 10 000 Kč

Máš i5-7400, 8 GB DDR4, HDD 1 TB, deska B250. Co koupit, aby to nejvíc pomohlo?

*Na co myslet:* tohle je **nejzajímavější typ úlohy**, protože se ptá na priority. Odpověď: **NVMe/SATA SSD** (největší skok ve vnímané rychlosti), pak **+8 GB RAM**. Nový procesor nedává smysl — socket LGA1151 je slepá ulička, znamenal by novou desku i RAM.

*Past:* navrhnout nové CPU bez ověření, že sedí do stávající desky.

---

### Šablona odpovědi u obhajoby

Když si nebudeš vědět rady, drž se téhle struktury — projde vždycky:

```
1. PROFIL       "Zadání říká kancelář a multimédia, takže cílím na
                 jednovláknový výkon a rychlé úložiště, ne na grafiku."

2. SESTAVA      (tabulka po položkách s cenami a součtem)

3. ZDŮVODNĚNÍ   ke každé položce jedna věta - proč zrovna tohle

4. KOMPATIBILITA "Socket LGA1700 sedí, deska je DDR4 stejně jako paměti,
                  zdroj má rezervu 40 %, grafika není potřeba."

5. CO BYCH ZMĚNIL "Kdyby byl rozpočet o 3 000 vyšší, dal bych je do
                   většího SSD. Kdyby byl o 3 000 nižší, ubral bych RAM na 8 GB
                   s tím, že se dá dokoupit."

6. INSTALACE     USB médium -> boot z USB -> instalace -> ovladače
                 (chipset první!) -> aktualizace -> XMP v BIOSu
```

**Bod 5 je to, co odliší dobrou odpověď od průměrné.** Ukazuje, že rozumíš kompromisům, ne že jsi opsal jednu sestavu.

---

### Co si nacvičit

- [ ] Ukázková úloha z PDF (kancelář za 15 000 Kč) — celá, včetně zdůvodnění a poznámky ke GTX 1650
- [ ] Aspoň dva z [příkladů na procvičení](#příklady-na-procvičení) — ideálně herní a upgrade
- [ ] **Zpaměti: sokety a jaké CPU do nich patří** (LGA1700, AM4, AM5)
- [ ] **Zpaměti: dimenzování zdroje** — CPU + GPU + 100 W, ×1,3
- [ ] Vysvětlit XMP/EXPO a proč se zapíná
- [ ] Odvyprávět postup instalace OS včetně **pořadí ovladačů**
- [ ] Umět říct, **kdy dedikovaná grafika není potřeba** a co za ty peníze koupit místo ní
- [ ] Projít si <https://pcpartpicker.com> nanečisto, ať víš, jak vypadá

---

### Poznámky

<!-- Sem vlastní výpisky, ceny, odkazy na konkrétní sestavy. -->

---

### Na co se doptají

- **Proč jsi zvolil právě tenhle procesor a ne o generaci starší za méně peněz?** — Novější generace má lepší poměr výkon/spotřeba a **delší podporu socketu** (možnost upgradu). U starší bych ušetřil, ale deska by byla slepá ulička. Když je rozpočet napjatý, je starší generace legitimní volba — pak to řekni takhle.
- **Bude ta grafika stačit? A potřebuje ji ta sestava vůbec?** — Druhá půlka otázky je ta důležitá. Pro Office a web **ne** — integrovaná zvládne i 4K video a dva monitory. Ušetřené peníze jdou do SSD a RAM.
- **Jak jsi dimenzoval zdroj?** — Součet TDP procesoru a spotřeby grafiky, plus ~100 W na zbytek, plus 30 % rezerva. Rezerva je kvůli účinnosti (nejvyšší kolem 50–70 % zátěže) a kvůli budoucímu upgradu.
- **Co je XMP/EXPO a proč ho v BIOSu zapnout?** — Profil s parametry paměti od výrobce. **Bez něj běží paměti na základním taktu** (2133 MHz místo 3200), takže platíš za rychlost, kterou nevyužíváš. Jedno kliknutí.
- **Jaký je rozdíl mezi DDR4 a DDR5 a poznám to?** — Jiná napěťová architektura, DDR5 má vyšší propustnost. **Fyzicky nezáměnné** — jiná pozice zářezu. Deska podporuje jen jeden typ.
- **Proč dva moduly RAM a ne jeden?** — Dvoukanálový režim zhruba zdvojnásobí propustnost. U integrované grafiky je to zvlášť znát, protože si bere paměť ze systémové RAM.
- **Co znamená `F` v i3-12100F?** — Bez integrované grafiky. Ušetří pár set korun, ale **vyžaduje dedikovanou kartu**.
- **V jakém pořadí instaluješ ovladače a proč?** — **Chipset první** (bez něj nefungují správně sběrnice a čipy na desce), pak grafika, síť, zvuk. Nakonec Windows Update.
- **Co potřebuje Windows 11, co Windows 10 ne?** — **TPM 2.0 a Secure Boot**, obojí se zapíná v BIOSu (`fTPM` u AMD, `PTT` u Intelu). A UEFI místo Legacy bootu.
- **Kde je v té sestavě úzké hrdlo?** — Poctivá odpověď je lepší než tvrdit, že žádné není. U kancelářské sestavy s iGPU je to grafika, ale pro daný účel to nevadí — a přesně tak to řekni.
- **Co bys změnil, kdyby byl rozpočet o 5 000 vyšší / nižší?** — Vyšší: větší SSD, pak RAM, pak lepší zdroj. Nižší: méně RAM (s možností dokoupit) nebo menší SSD, **nikdy ne HDD místo SSD**.
- **Proč zrovna tenhle chipset?** — Podle toho, co potřebuješ: přetaktování (Z u Intelu, X u AMD), počet M.2 slotů, USB portů. Do kancelářské sestavy stačí nejnižší řada.

---

### Užitečné odkazy

- Sestavení s kontrolou kompatibility: <https://pcpartpicker.com>
- Parametry procesorů Intel: <https://ark.intel.com>
- Parametry procesorů AMD: <https://www.amd.com/en/products/specifications>
- Benchmarky procesorů: <https://www.cpubenchmark.net>
- Benchmarky grafických karet: <https://www.videocardbenchmark.net>
- Diagnostika a řešení problémů: [okruh 5](../05-architektura-diagnostika/)
