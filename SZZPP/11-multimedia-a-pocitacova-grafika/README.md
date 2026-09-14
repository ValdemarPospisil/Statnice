## 11 — Multimédia a základy počítačové grafiky

- [Zadání okruhu (PDF)](../ZadaniOkruhu/MPG.pdf)
- 📄 **[Tahák k okruhu 11](../Tahaky/11.md)** — principy formátů, barev, transformací, filtrů *(na mobil k nahlédnutí, ne k odevzdání)*

> **Prezentace návrhu** multimediální aplikace včetně **vysvětlení principů jevů**, které daná funkcionalita využívá. 60 minut přípravy (Windows, MS Office / LibreOffice, Python a C#), pak 20 minut obhajoby.

**Tohle je jediný okruh SZZPP, kde se nic nenaprogramuje.** Odevzdáváš **návrh a jeho obhajobu**, ne kód. Zadání to říká jasně: *„prokázat schopnost aplikovat znalosti… ve formě prezentace návrhu"*.

> **Nejčastější způsob, jak tenhle okruh pokazit:** vyjmenovat funkce („bude tam otáčení, filtry a ukládání do PNG") a neumět říct, **jak to uvnitř funguje**. Zadání chce u každé funkce *„matematický popis, principy využitých fyzikálních jevů"*. Seznam funkcí je bezcenný — **princip je celá odpověď**.

Proti ostatním okruhům tu nemáš úlohu k odladění, ale zato **víš dopředu, na co se bude ptát** — zadání vyjmenovává požadavky bod po bodu. Naučit se jich šest a ke každému princip je celá příprava.

Překryv: transformační matice a křivky souvisí s [SZZTP 5](../../SZZTP/05-derivace-integraly-numerika/), argumentace o návrhu UI s [SZZVP SW blokem](../../SZZVP/04-navrhove-vzory/).

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn, pak výklad s příklady. -->

#### Souhrn na jednom místě

| Téma | Princip v jedné větě | Zapamatuj si | Kde |
|---|---|---|---|
| **rastr vs. vektor** | mřížka pixelů vs. matematický popis | rastr degraduje zvětšením, vektor ne | [↓](#rastrová-a-vektorová-grafika) |
| **RGB** | aditivní míchání světla | monitory; $(255,0,0)$ = červená | [↓](#barevné-modely) |
| **CMYK** | subtraktivní míchání barviv | **tisk**; menší gamut než RGB | [↓](#barevné-modely) |
| **HSV/HSL** | odstín, sytost, jas | **úpravy barev** — odpovídá lidskému vnímání | [↓](#barevné-modely) |
| **barevná hloubka** | bitů na pixel | 24 bit = 16,7 mil. barev (True Color) | [↓](#barevná-hloubka-a-velikost-dat) |
| **vzorkování** | převod spojitého na diskrétní | **Nyquist**: $f_s \ge 2 f_{max}$ | [↓](#vzorkování-a-kvantizace) |
| **kvantizace** | zaokrouhlení hodnot na úrovně | ztráta informace → kvantizační šum | [↓](#vzorkování-a-kvantizace) |
| **bezztrátová komprese** | odstraní **redundanci** | PNG, GIF, FLAC, ZIP — jde obnovit přesně | [↓](#komprese) |
| **ztrátová komprese** | zahodí, co oko/ucho nevnímá | JPEG, MP3, H.264 — **nejde vrátit** | [↓](#komprese) |
| **JPEG** | DCT → kvantizace → Huffman | ztrátový, **bez průhlednosti**, artefakty | [↓](#jpeg--jak-to-funguje) |
| **PNG** | predikce + DEFLATE | bezztrátový, **alfa kanál** | [↓](#formáty-obrázků) |
| **homogenní souřadnice** | 2D bod jako $(x,y,1)$ | umožní **posun jako násobení maticí** | [↓](#homogenní-souřadnice-a-transformace) |
| **konvoluce** | vážený průměr okolí pixelu | jádro (kernel) určuje efekt | [↓](#konvoluce--filtry-a-efekty) |
| **Sobel** | gradient jasu | **detekce hran** | [↓](#konvoluce--filtry-a-efekty) |
| **Bézierova křivka** | interpolace mezi řídicími body | prochází **prvním a posledním** bodem | [↓](#křivky) |
| **alias** | falešné vzory z podvzorkování | řeší **antialiasing** | [↓](#alias-a-antialiasing) |

**Tři věci, na kterých se to láme:** proč homogenní souřadnice (kvůli posunu), co dělá JPEG (DCT a zahození vysokých frekvencí), a rozdíl aditivního a subtraktivního míchání.

#### Rastrová a vektorová grafika

| | Rastrová (bitmapa) | Vektorová |
|---|---|---|
| **Reprezentace** | mřížka pixelů, každý má barvu | matematický popis tvarů |
| **Zvětšení** | **kostičkuje**, ztrácí kvalitu | libovolné, bez ztráty |
| **Velikost dat** | roste s rozlišením | roste se složitostí tvarů |
| **Vhodné na** | **fotografie**, skeny | loga, ikony, technické výkresy, písmo |
| **Formáty** | JPEG, PNG, GIF, BMP, TIFF | SVG, EPS, AI, PDF |

**Zadaná úloha je editor bitmap**, takže pracuješ s rastrem — ale kreslicí nástroje (čáry, křivky) se vnitřně počítají vektorově a teprve pak se **rasterizují** do pixelů.

#### Barevné modely

**RGB — aditivní** (skládání světla). Začínáš od černé (nic nesvítí) a přidáváš:

```
(255,   0,   0) = červená
(  0, 255,   0) = zelená
(255, 255,   0) = žlutá     <- červená + zelená
(255, 255, 255) = bílá      <- všechny naplno
```

Používají ho **monitory, projektory, fotoaparáty** — cokoli, co samo vyzařuje světlo.

**CMYK — subtraktivní** (odečítání od bílého papíru). Začínáš od bílé a barvivo pohlcuje:

```
Cyan + Magenta + Yellow = teoreticky černá, prakticky špinavě hnědá
-> proto se přidává K (blacK) jako samostatná barva
```

Používá ho **tisk**. **Gamut CMYK je menší než RGB** — sytě zelená nebo modrá z monitoru se nedá vytisknout, a proto se výtisky zdají tlumenější. To je dobrá doptávka.

**HSV / HSL** — odpovídá tomu, jak o barvě přemýšlí člověk:

| Složka | Význam | Rozsah |
|---|---|---|
| **H** (Hue) | odstín — kde na barevném kruhu | 0–360° |
| **S** (Saturation) | sytost — od šedé k plné barvě | 0–100 % |
| **V** (Value) / **L** (Lightness) | jas | 0–100 % |

**Ověřené převody:**

```
RGB(255,   0,   0) -> HSV(  0°, 100%, 100%)   červená
RGB(  0, 255,   0) -> HSV(120°, 100%, 100%)   zelená
RGB(255, 128,   0) -> HSV( 30°, 100%, 100%)   oranžová
RGB(128, 128, 128) -> HSV(  0°,   0%,  50%)   šedá — nulová sytost
```

**Proč je HSV v editoru nutný:** zadání chce „nastavení kontrastu, jasu a **sytosti barev**". V RGB se sytost nedá změnit přímo — musel bys přepočítat všechny tři složky najednou. V HSV je to **jedno číslo**: `S = S * 1.2`, a převedeš zpátky.

**Jas a luminance** — prostý průměr složek je špatně:

```
RGB(255,0,0)  průměr = 85   luminance = 76
RGB(0,255,0)  průměr = 85   luminance = 150   <- vnímáme jako dvakrát světlejší!
RGB(0,0,255)  průměr = 85   luminance = 29
```

Lidské oko je nejcitlivější na zelenou, proto se používají váhy:

$$Y = 0{,}299 R + 0{,}587 G + 0{,}114 B$$

**Konkrétně:** převod do stupňů šedi prostým průměrem udělá ze zelené i modré stejně šedou, přestože zelená je vnímaná jako výrazně světlejší. Proto se v editoru na „převod na černobílou" používá luminance.

#### Barevná hloubka a velikost dat

| Hloubka | Počet barev | Použití |
|---|---|---|
| 1 bit | 2 | černobílá (fax) |
| 8 bit | 256 | GIF, indexovaná paleta |
| **24 bit** | **16 777 216** | **True Color** — standard |
| 32 bit | 24 bit + alfa | s průhledností |

**Proč se vůbec komprimuje** — spočítej si to:

```
1920 × 1080 × 24 bit / 8 = 6 220 800 B = 5,93 MB   ... jeden snímek
× 25 snímků/s × 60 s = 8,69 GB                      ... jedna minuta videa
```

Minuta nekomprimovaného Full HD videa je skoro 9 GB. **To je celá motivace pro kompresi** a je to nejlepší způsob, jak její nutnost vysvětlit u obhajoby.

#### Vzorkování a kvantizace

Převod spojitého (analogového) signálu na diskrétní má dva kroky:

**Vzorkování** (sampling) — měříme hodnotu v pravidelných okamžicích. Kolikrát za sekundu říká **vzorkovací frekvence** $f_s$.

**Nyquistův–Shannonův teorém:** aby šel signál věrně zrekonstruovat, musí platit

$$f_s \ge 2 f_{max}$$

**Konkrétně u zvuku:** lidské ucho slyší do 20 kHz, takže potřebuješ aspoň 40 kHz. CD používá **44,1 kHz** — s rezervou na filtry.

**Co se stane při porušení:** vzniká **alias** — vyšší frekvence se „přehne" a projeví jako falešná nižší. U zvuku to zní jako cizí tón, u obrazu jako moaré vzory.

**Kvantizace** — každý vzorek zaokrouhlíme na jednu z konečně mnoha úrovní. Počet úrovní dává **bitová hloubka**: 16 bit = 65 536 úrovní. Zaokrouhlovací chyba se projeví jako **kvantizační šum**.

**Ověřený výpočet velikosti CD audia:**

```
44 100 Hz × 16 bit × 2 kanály = 1 411 200 bit/s = 172 kB/s
1 minuta = 10,1 MB
MP3 320 kbps = 2,3 MB   -> kompresní poměr 4,4 : 1
```

#### Komprese

| | Bezztrátová | Ztrátová |
|---|---|---|
| **Princip** | odstraní **redundanci** | zahodí, co člověk nevnímá |
| **Obnovení** | **bit po bitu přesné** | nikdy ne původní data |
| **Poměr** | 2–4 : 1 | 10–100 : 1 |
| **Formáty** | PNG, GIF, FLAC, ZIP | JPEG, MP3, H.264, AAC |
| **Kdy** | text, ikony, archivace, mezikroky editace | fotky, hudba, video |

**Bezztrátové techniky:**

- **RLE** (Run-Length Encoding) — `AAAAABBB` → `5A3B`. Skvělé na ikony s plochami jedné barvy, nepoužitelné na fotky.
- **Huffmanovo kódování** — časté symboly dostanou kratší kód. Vazba na entropii.
- **LZW / DEFLATE** — slovníkové metody, hledají opakující se sekvence.

**Ztrátové techniky** stojí na **percepčním modelu** — na tom, co lidské smysly nezachytí:

- oko je **méně citlivé na barvu než na jas** → chroma subsampling (4:2:0)
- oko **špatně vidí jemné detaily** → JPEG zahodí vysoké frekvence
- ucho **neslyší tišší tón hned po hlasitém** → MP3 ho nezakóduje (maskování)

**Typické velikosti** pro Full HD fotku (originál 5,93 MB):

```
PNG (bezztrátový)  ~2 025 kB   (3:1)
JPEG kvalita 90      ~405 kB   (15:1)
JPEG kvalita 50      ~152 kB   (40:1)
```

#### JPEG — jak to funguje

**Tohle umět vysvětlit v pěti krocích**, je to nejčastější doptávka celého okruhu:

1. **Převod do YCbCr** — oddělí jas (Y) od barvy (Cb, Cr). Oko je citlivější na jas.
2. **Chroma subsampling** (4:2:0) — barevné složky se vzorkují na poloviční rozlišení. **Zahodí 50 % barevných dat a skoro to není vidět.**
3. **Rozdělení na bloky 8×8** pixelů.
4. **DCT** (diskrétní kosinová transformace) — převede blok z prostoru pixelů do prostoru **frekvencí**. Vlevo nahoře nízké frekvence (hrubý tvar), vpravo dole vysoké (jemné detaily).
5. **Kvantizace** — dělení kvantizační tabulkou. **Tady vzniká ztráta**: vysoké frekvence se zaokrouhlí na nulu. Míra dělení = nastavení kvality.
6. **Huffmanovo kódování** zbylých koeficientů (mnoho nul za sebou → RLE).

**Klíčová věta k obhajobě:** *„JPEG nezahazuje pixely, ale frekvence — konkrétně ty vysoké, které oko špatně rozliší. Proto vznikají artefakty právě na ostrých hranách, kde jsou vysoké frekvence potřeba."*

**Proto je JPEG špatný na:** text, ikony, screenshoty, kresby s ostrými hranami. Kolem písmen vznikne „duchový" šum.

#### Formáty obrázků

| Formát | Komprese | Průhlednost | Kdy použít |
|---|---|---|---|
| **JPEG** | ztrátová | **ne** | **fotografie**, kde nevadí drobná ztráta |
| **PNG** | bezztrátová | **ano** (alfa kanál) | **ikony, loga, screenshoty**, obrázky s textem |
| **GIF** | bezztrátová | ano (1 bit) | animace, max. **256 barev** |
| **WebP** | obojí | ano | moderní web — menší než JPEG i PNG |
| **TIFF** | volitelná | ano | archivace, tisk, skenování |
| **BMP** | žádná | ne | jen jako mezikrok, zbytečně velký |
| **SVG** | vektorový | ano | loga, ikony — libovolné zvětšení |

**Jak zdůvodnit volbu v návrhu editoru** (zadání to explicitně chce):

> Podporoval bych **JPEG** pro fotografie (nejrozšířenější, dobrý poměr velikost/kvalita), **PNG** pro obrázky vyžadující průhlednost nebo ostré hrany, a **BMP nebo TIFF** jako bezztrátový mezikrok při editaci. **Interně bych pracoval s bezztrátovou reprezentací** a komprimoval až při exportu — jinak by se s každým uložením kvalita zhoršovala (generační ztráta).

**Ta poslední věta je nejcennější** — ukazuje, že rozumíš důsledkům.

#### Homogenní souřadnice a transformace

**Proč se používají** (klasická doptávka): v běžných 2D souřadnicích jdou rotace a škálování zapsat jako násobení maticí 2×2, ale **posun ne** — je to sčítání. Homogenní souřadnice přidají třetí složku:

$$(x, y) \longrightarrow (x, y, 1)$$

a tím se **posun stane taky násobením**. Všechny transformace pak mají stejný tvar a dají se **skládat součinem matic**.

**Posun** o $(t_x, t_y)$ — jediná transformace, která v běžných 2D souřadnicích maticí nejde:

$$T = \begin{pmatrix} 1 & 0 & t_x \\ 0 & 1 & t_y \\ 0 & 0 & 1 \end{pmatrix}$$

**Škálování** koeficienty $(s_x, s_y)$:

$$S = \begin{pmatrix} s_x & 0 & 0 \\ 0 & s_y & 0 \\ 0 & 0 & 1 \end{pmatrix}$$

**Rotace** o úhel $\alpha$ kolem počátku:

$$R = \begin{pmatrix} \cos\alpha & -\sin\alpha & 0 \\ \sin\alpha & \cos\alpha & 0 \\ 0 & 0 & 1 \end{pmatrix}$$

**Zkosení** (deformace) koeficienty $sh_x$, $sh_y$:

$$H = \begin{pmatrix} 1 & sh_x & 0 \\ sh_y & 1 & 0 \\ 0 & 0 & 1 \end{pmatrix}$$

**Ověřený příklad** — bod $(2,3)$, posun o $(5,1)$, pak rotace o 90°:

```
po posunu:           (7, 4)
po rotaci o 90°:    (-4, 7)

složená matice M = R · T:
  [ 0  -1  -1 ]
  [ 1   0   5 ]
  [ 0   0   1 ]

M · (2,3,1) = (-4, 7, 1)   ✓ stejný výsledek jedním násobením
```

**Zásadní past: na pořadí záleží.** Násobení matic **není komutativní**:

```
R · T · p = (-4, 7)      rotace PO posunu
T · R · p = ( 2, 3)      posun PO rotaci   <- úplně jiný výsledek!
```

**Čte se to zprava doleva** — matice nejblíž k bodu se aplikuje první.

**Rotace kolem libovolného bodu** (ne kolem počátku) je složenina tří transformací:

$$M = T(c) \cdot R(\alpha) \cdot T(-c)$$

Slovy: **přesuň střed do počátku, otoč, vrať zpátky.** Ověřeno: bod $(4,2)$ otočený o 90° kolem $(2,2)$ skončí v $(2,4)$. ✓

**Výhoda skládání:** místo abys na každý pixel aplikoval tři transformace, spočítáš **jednu složenou matici** a tou projedeš obrázek jednou. U milionu pixelů je to zásadní rozdíl ve výkonu — a to je přesně ta „optimalizace z hlediska výkonu", kterou zadání zmiňuje.

#### Konvoluce — filtry a efekty

**Princip:** každý pixel nahradíš **váženým průměrem jeho okolí**. Váhy jsou v matici zvané **jádro** (kernel, konvoluční maska).

$$g(x,y) = \sum_{i} \sum_{j} f(x+i,\, y+j) \cdot k(i,j)$$

**Rozostření (box blur)** — všechny váhy stejné:

$$k = \frac{1}{9}\begin{pmatrix} 1 & 1 & 1 \\ 1 & 1 & 1 \\ 1 & 1 & 1 \end{pmatrix}$$

**Součet vah musí být 1**, jinak se změní celkový jas obrázku. Proto to dělení devíti.

**Gaussovské rozostření** dává váhy podle Gaussovy křivky (střed víc, okraje méně) — vypadá přirozeněji než box blur.

**Zaostření (sharpen)** — zvýrazní rozdíl proti okolí:

$$k = \begin{pmatrix} 0 & -1 & 0 \\ -1 & 5 & -1 \\ 0 & -1 & 0 \end{pmatrix}$$

Součet je 1, ale záporné váhy okolí zesílí kontrast na hranách.

**Detekce hran — Sobelův operátor.** Dvě jádra, každé detekuje jiný směr:

$$G_x = \begin{pmatrix} -1 & 0 & 1 \\ -2 & 0 & 2 \\ -1 & 0 & 1 \end{pmatrix} \qquad G_y = \begin{pmatrix} -1 & -2 & -1 \\ 0 & 0 & 0 \\ 1 & 2 & 1 \end{pmatrix}$$

**Ověřený příklad** na obrázku se svislou hranou (vlevo hodnota 10, vpravo 200):

```
Gx (svislé hrany):        Gy (vodorovné hrany):
  [   0  760  760 ]         [ 0  0  0 ]
  [   0  760  760 ]         [ 0  0  0 ]
  [   0  760  760 ]         [ 0  0  0 ]
```

`Gx` hranu **našel** (hodnoty 760), `Gy` nenašel nic — protože vodorovná hrana tam žádná není. Velikost gradientu se pak spočítá:

$$\lvert G \rvert = \sqrt{G_x^2 + G_y^2}$$

**Proč to funguje:** jádro počítá **rozdíl mezi levou a pravou stranou** okolí. V ploché oblasti je rozdíl nulový, na hraně velký. Je to numerická derivace jasu — **hrana je místo, kde se jas prudce mění**.

**Co s okraji obrázku** (dobrá doptávka): jádro 3×3 nemá u krajního pixelu celé okolí. Řešení: zmenšit výstup, zrcadlit okraje, opakovat krajní pixel, nebo doplnit nulami.

#### Křivky

**Bézierova kubická křivka** — čtyři řídicí body:

$$B(t) = (1-t)^3 P_0 + 3(1-t)^2 t P_1 + 3(1-t) t^2 P_2 + t^3 P_3, \qquad t \in [0,1]$$

**Ověřený příklad** pro $P_0=(0,0)$, $P_1=(1,3)$, $P_2=(3,3)$, $P_3=(4,0)$:

```
t = 0     ->  (0,      0)      = P0
t = 0,25  ->  (0,906,  1,688)
t = 0,5   ->  (2,      2,25)
t = 0,75  ->  (3,094,  1,688)
t = 1     ->  (4,      0)      = P3
```

**Klíčová vlastnost:** křivka prochází **prvním a posledním** bodem, ale **prostředními ne** — ty ji jen „přitahují". To je vidět z výpočtu: $B(0) = P_0$ a $B(1) = P_3$, protože ostatní členy vypadnou.

**Proč Bézier a ne polynom skrz všechny body:** polynom vysokého stupně mezi body **osciluje** (Rungeho jev). Bézier je stabilní a lokálně ovladatelný.

**Navazování křivek** (splajn): aby přechod nebyl vidět, musí být **spojitý ve směru tečny** — koncový bod první křivky, jeho předchůdce a následující řídicí bod druhé křivky musí ležet **na jedné přímce**. To je spojitost $C^1$.

Numerické metody a interpolace souvisí s [SZZTP okruh 5](../../SZZTP/05-derivace-integraly-numerika/).

#### Alias a antialiasing

**Alias** vzniká, když se spojitý signál vzorkuje **příliš hrubě** — vysoké frekvence se „přehnou" a projeví jako falešné nízké.

**Projevy v grafice:**

- **zubaté hrany** („schody") na šikmých čarách
- **moaré** vzory na jemných texturách (pruhovaná košile ve videu)
- blikání tenkých detailů při pohybu

**Antialiasing** — řešení je průměrovat:

| Metoda | Princip |
|---|---|
| **Supersampling (SSAA)** | vykreslit ve vyšším rozlišení a zmenšit průměrováním |
| **MSAA** | vzorkovat víckrát jen na hranách objektů |
| **FXAA** | rozmazat nalezené hrany dodatečně (rychlé, méně přesné) |

**Vysvětlení principu:** pixel na hraně není celý černý ani bílý — **hrana jím prochází**. Antialiasing mu dá odstín podle toho, jakou částí ho objekt pokrývá. Zubatost zmizí, protože oko si ten přechod vyhladí samo.

---

### Postup u zkoušky (60 min přípravy)

<!-- Připravuješ PREZENTACI, ne kód. Struktura je daná zadáním. -->

**0–5 min — rozbor zadání**

1. **Vypiš si požadavky ze zadání jako osnovu prezentace.** U editoru bitmap je jich šest skupin — a to je rovnou šest slidů.
2. Zadání ti říká, co se bude hodnotit: *matematický popis, principy jevů, standardy a formáty, návrh dalších funkcí, algoritmy*.

**5–40 min — obsah po sekcích**

3. Ke každému požadavku **jeden slide** a na něm: co to dělá → **jak to funguje** → proč zrovna tak.
4. **Vzorce piš**, i když je prezentace stručná. Transformační matice, konvoluční jádro, Bézier — to jsou tři místa, kde se ukazuje, že tomu rozumíš.
5. U formátů **vždy zdůvodni volbu**. Ne „podporujeme PNG", ale „PNG kvůli bezztrátovosti a alfa kanálu".

**40–50 min — návrh dalších funkcí**

6. Zadání to **explicitně požaduje** („návrh dalších funkcionalit"). Nabídni 3–5 věcí: vrstvy, historie kroků (undo), dávkové zpracování, skriptovatelnost, neinvazivní úpravy.
7. Ke každé řekni, **proč by byla užitečná** a jak by se implementovala.

**50–60 min — UI a kontrola**

8. **Nezapomeň na UI** — je to samostatný bod zadání. Rozvržení, klávesové zkratky, nedestruktivní editace, zpětná vazba.
9. Projdi osnovu a zkontroluj, že **u každého bodu umíš říct princip**, ne jen název.

**Formát výstupu:** zadání jmenuje PowerPoint/LibreOffice, ale klidně i dokument. **Podstatná je obhajoba**, ne grafika slidů. Radši méně slidů a víc rozumět.

---

### Rozbor ukázkové úlohy

> Navrhněte **nástroj na editaci bitmapových obrázků**. Navrhněte požadovanou funkcionalitu a **vysvětlete její principy**.

Zadání dává šest skupin požadavků. Ke každé patří **princip**, ne jen seznam funkcí.

#### 1. Otevírání a ukládání — které formáty a proč

| Formát | Proč ho podporovat |
|---|---|
| **JPEG** | nejrozšířenější formát fotografií; uživatel bude otevírat hlavně tohle |
| **PNG** | bezztrátový + **alfa kanál** — nutný pro ikony, loga, obrázky s průhledností |
| **BMP / TIFF** | bezztrátový mezikrok; TIFF navíc pro tisk a archivaci |
| **WebP** | moderní, menší než JPEG i PNG při srovnatelné kvalitě |
| **vlastní formát** | uchová **vrstvy a historii úprav**, které běžné formáty neumí |

**Klíčový návrhový argument:** *„Interně budu pracovat s bezztrátovou reprezentací a komprimovat až při exportu. Kdybych po každé úpravě ukládal do JPEG, kvalita by se **kumulativně zhoršovala** (generační ztráta) — po deseti uloženích by byl obrázek viditelně poškozený."*

#### 2. Konverze barevných modelů — které implementovat

- **RGB** — základní, odpovídá zobrazení na monitoru
- **HSV/HSL** — **nutný** pro úpravy sytosti a odstínu; v RGB by to znamenalo přepočítávat tři složky naráz
- **CMYK** — pro výstup do tisku; upozornit uživatele, že **gamut je menší** a syté barvy se změní
- **stupně šedi** — přes **luminanci** $Y = 0{,}299R + 0{,}587G + 0{,}114B$, ne prostý průměr

**Konkrétní zdůvodnění HSV:** *„Zvýšení sytosti o 20 % je v HSV jediná operace `S = S × 1,2`. V RGB neexistuje jednoduchý ekvivalent — musel bych najít maximum a minimum složek a roztáhnout jejich rozdíl."*

#### 3. Kontrast, jas a sytost — vzorce

| Úprava | Vzorec | Poznámka |
|---|---|---|
| **Jas** | $p' = p + b$ | prostý posun; nutné **oříznutí** do 0–255 |
| **Kontrast** | $p' = (p - 128) \cdot c + 128$ | roztažení kolem středu |
| **Sytost** | v HSV: $S' = S \cdot s$ | proto ten převod |
| **Gamma** | $p' = 255 \cdot (p/255)^{1/\gamma}$ | nelineární, odpovídá vnímání |

**Past, kterou zmínit:** po každé operaci se musí hodnoty **oříznout** do rozsahu 0–255 (`clamp`). Bez toho přeteče typ a světlá místa se „přetočí" do tmavých — vznikne rušivý artefakt.

#### 4. Kreslení čar a křivek

- **Čára:** Bresenhamův algoritmus — rasterizace úsečky **jen celočíselnou aritmetikou** (žádné dělení ani float), proto je rychlý
- **Křivky:** Bézierovy kubiky, vyhodnocené v krocích $t$ a spojené úsečkami
- **Antialiasing:** bez něj budou čáry zubaté; pixely na hraně dostanou částečnou intenzitu

**Vyplňování oblastí (flood fill):**

> Algoritmus záplavového vyplňování: od zvoleného pixelu se rekurzivně (nebo frontou) rozšiřuje do sousedů, dokud mají původní barvu. **Rekurzivní verze může přetéct zásobník** u velkých ploch, takže bych použil variantu s explicitní frontou. Rozlišuje se **4-okolí a 8-okolí** — u 4-okolí neprotéká barva diagonálními škvírami.

**Tolerance** je praktické rozšíření: vyplňuj i pixely, které se od výchozí barvy liší méně než zadaná mez. U fotek nutné, protože „jednolitá" plocha nikdy nemá přesně stejné hodnoty.

#### 5. Transformace pomocí homogenních souřadnic

Tohle je nejmatematičtější část a zadání ji jmenuje explicitně — [vzorce a ověřené příklady jsou výš](#homogenní-souřadnice-a-transformace).

**Co dodat navíc k samotným maticím:**

**Interpolace při transformaci.** Po otočení nepadnou zdrojové pixely přesně na cílovou mřížku. Musíš dopočítat mezihodnoty:

| Metoda | Kvalita | Rychlost |
|---|---|---|
| **Nejbližší soused** | nejhorší (zubaté) | nejrychlejší |
| **Bilineární** | dobrá | střední |
| **Bikubická** | nejlepší | nejpomalejší |

**Inverzní mapování.** Neprocházíš zdrojové pixely a nepočítáš, kam padnou (vznikly by díry), ale **procházíš cílové** a počítáš, odkud se berou — tedy aplikuješ $M^{-1}$. Tím je zaručeno, že se vyplní každý cílový pixel.

**To je odpověď na „popis algoritmů klíčových funkcionalit"**, kterou zadání chce.

#### 6. Filtry a efekty

Všechny stojí na **konvoluci** — [princip a ověřené příklady výš](#konvoluce--filtry-a-efekty).

| Filtr | Jádro / princip |
|---|---|
| Rozostření | průměrovací nebo Gaussovo jádro |
| Zaostření | záporné váhy okolí, kladný střed |
| Detekce hran | **Sobel** — dvě jádra, gradient |
| Reliéf (emboss) | asymetrické jádro |
| **Medián** | **není konvoluce** — bere prostřední hodnotu okolí |

**Mediánový filtr zmínit zvlášť:** není lineární, takže se nedá zapsat jádrem. Používá se na **odstranění zrnitého šumu** (salt and pepper), protože na rozdíl od průměrování nerozmaže hrany.

**Optimalizace, která udělá dojem:** Gaussovo rozostření je **separabilní** — místo jádra $n \times n$ se dá aplikovat dvakrát jednorozměrné jádro (vodorovně a svisle). Složitost klesne z $O(n^2)$ na $O(2n)$ na pixel. U jádra 9×9 je to 81 vs. 18 operací, tedy **4,5× rychleji**.

#### 7. Zvětšování zobrazení a nastavení

- **Zoom** není transformace obrázku, ale **zobrazení** — původní data se nemění
- Pro zvětšení nad 100 % se hodí **nejbližší soused** (uživatel chce vidět jednotlivé pixely), pro zmenšení **bikubická** interpolace
- **Nastavení a preference:** JSON nebo INI soubor v adresáři uživatele; ukládat naposledy otevřené soubory, rozvržení panelů, výchozí formát exportu

#### 8. Uživatelské rozhraní

Zadání ho jmenuje jako samostatný bod, takže mu věnuj vlastní slide:

- **Nedestruktivní editace** — úpravy jako vrstvy, ne přepis pixelů. Uživatel se může vrátit.
- **Historie kroků** (undo/redo) — zásobník operací; u velkých obrázků ukládat **jen rozdíly**, ne celé kopie
- **Okamžitá zpětná vazba** — náhled filtru před potvrzením
- **Klávesové zkratky** pro časté operace
- **Nemodální nástroje** — uživatel nemusí potvrzovat dialog, aby viděl efekt

#### 9. Návrh dalších funkcí

Zadání to **výslovně požaduje**. Nabídni:

| Funkce | Proč |
|---|---|
| **Vrstvy** | nedestruktivní kompozice, standard v oboru |
| **Dávkové zpracování** | stejná úprava na sto fotek naráz |
| **Skriptovatelnost** | automatizace opakovaných úloh (Python API) |
| **Výběrové nástroje** | laso, kouzelná hůlka — úprava jen části obrázku |
| **Podpora barevných profilů (ICC)** | věrné barvy mezi monitorem a tiskem |
| **GPU akcelerace** | filtry jsou dokonale paralelizovatelné — každý pixel nezávisle |

**GPU akcelerace je nejlepší z nich pro obhajobu:** *„Konvoluce je ideální úloha pro GPU, protože výpočet každého pixelu je nezávislý na ostatních. Na CPU jde o sekvenční průchod milionem pixelů, na GPU běží tisíce najednou. U filtru na 4K obrázku je rozdíl řádový."*

---

### Příklady na procvičení

Zadání může přijít s jinou aplikací než editor obrázků. **Struktura odpovědi zůstává stejná** — funkce → princip → zdůvodnění → co navíc.

#### Příklad 1 — přehrávač a editor zvuku

> Navrhněte nástroj pro editaci zvukových stop. Umožní načtení, střih, mixáž více stop, aplikaci efektů a export.

*Co musíš vysvětlit:* **vzorkovací frekvence a Nyquist** (proč 44,1 kHz), bitová hloubka a kvantizační šum, rozdíl WAV/FLAC/MP3, princip **MP3** (psychoakustický model, maskování), efekty (ekvalizér = filtrování frekvenčních pásem, dozvuk = konvoluce s impulzní odezvou), **FFT** pro zobrazení spektra.

*Dobrý bod navíc:* normalizace hlasitosti podle **LUFS**, ne podle špičky — odpovídá vnímané hlasitosti.

#### Příklad 2 — aplikace pro střih videa

> Navrhněte nástroj pro střih videa s podporou přechodů, titulků a exportu do běžných formátů.

*Co musíš vysvětlit:* **klíčové snímky** (I, P, B) a proč střih na nekličovém snímku vyžaduje překódování, kontejner vs. kodek (MP4 je kontejner, H.264 kodek), snímková frekvence a prokládání, **chroma subsampling**, proč se náhled generuje v nižším rozlišení (proxy).

*Dobrý bod navíc:* **rendering na pozadí** a cache náhledů — jinak je aplikace nepoužitelná.

#### Příklad 3 — prohlížeč a organizér fotografií

> Navrhněte aplikaci pro prohlížení, třídění a základní úpravy fotografií z fotoaparátu.

*Co musíš vysvětlit:* **RAW vs. JPEG** (RAW je nezpracovaný výstup ze snímače, umožňuje pozdější korekce bez ztráty), **EXIF metadata**, generování náhledů a jejich cache, histogram jako nástroj expozice, **nedestruktivní úpravy** (uloží se jen seznam operací).

*Dobrý bod navíc:* rozpoznávání obličejů nebo geolokace z EXIF — ukazuje, že myslíš na uživatele.

---

### Co si nacvičit

- [ ] **Ukázková úloha z PDF** — projít všech šest skupin požadavků a ke každé umět říct princip
- [ ] Aspoň jeden [příklad na procvičení](#příklady-na-procvičení) — ideálně zvuk nebo video, ať nejsi překvapený
- [ ] **Zpaměti: tři transformační matice** (posun, rotace, škálování) a proč homogenní souřadnice
- [ ] **Zpaměti: Sobelova jádra** a co dělá které
- [ ] **Zpaměti: pět kroků JPEG** (YCbCr → subsampling → bloky 8×8 → DCT → kvantizace → Huffman)
- [ ] **Zpaměti: Nyquist** $f_s \ge 2f_{max}$ a proč má CD 44,1 kHz
- [ ] Vzorec Bézierovy kubiky a fakt, že prochází krajními body
- [ ] Rozdíl RGB / CMYK / HSV a **kdy který** — včetně gamutu
- [ ] Zdůvodnit volbu JPEG vs. PNG na konkrétním obsahu
- [ ] Spočítat velikost nekomprimovaného obrázku a videa — ukazuje nutnost komprese

---

### Poznámky

<!-- Sem vlastní výpisky, náčrtky, útržky vzorců. -->

---

### Na co se doptají

- **Proč se pro fotky používá JPEG a pro ikony PNG?** — JPEG je ztrátový, pracuje s **frekvencemi** a zahazuje vysoké — u fotek s plynulými přechody to oko nepozná. Ikony a text mají **ostré hrany**, což jsou právě vysoké frekvence, takže kolem nich vznikají artefakty. PNG je navíc bezztrátový a má **alfa kanál**, který JPEG neumí.
- **Vysvětli, jak funguje detekce hran přes konvoluční jádro.** — Jádro počítá **rozdíl jasu** mezi protilehlými stranami okolí pixelu. V ploché oblasti je rozdíl nulový, na hraně velký. Sobel má dvě jádra ($G_x$, $G_y$) pro svislé a vodorovné hrany, výsledek se spojí jako $\sqrt{G_x^2 + G_y^2}$. Je to numerická derivace jasu.
- **Proč se v grafice používají homogenní souřadnice, když stačí 2D?** — Protože **posun se v 2D nedá zapsat maticí** — je to sčítání, ne násobení. Přidáním třetí složky se posun stane násobením, všechny transformace mají stejný tvar a **dají se skládat součinem matic**. Místo tří operací na každý pixel pak stačí jedna složená matice.
- **Co je alias a jak se proti němu bojuje?** — Falešné vzory vzniklé **příliš hrubým vzorkováním** — zubaté hrany, moaré. Porušení Nyquistovy podmínky $f_s \ge 2f_{max}$. Řeší se antialiasingem: vykreslit ve vyšším rozlišení a zprůměrovat (SSAA), nebo vzorkovat víckrát jen na hranách (MSAA).
- **Proč má CD vzorkovací frekvenci 44,1 kHz?** — Ucho slyší do 20 kHz, Nyquist tedy vyžaduje aspoň 40 kHz. Zbytek je rezerva pro antialiasingový filtr, který nemá nekonečně strmou charakteristiku.
- **Jaký je rozdíl mezi aditivním a subtraktivním mícháním?** — **Aditivní (RGB)** skládá světlo, začíná černou, všechny složky naplno dají bílou — monitory. **Subtraktivní (CMYK)** odečítá od bílého papíru, barvivo pohlcuje světlo — tisk.
- **Proč se při převodu na černobílou nepoužije prostý průměr?** — Oko vnímá zelenou výrazně světleji než modrou. Prostý průměr by udělal ze zelené i modré stejně šedou. Proto luminance $Y = 0{,}299R + 0{,}587G + 0{,}114B$.
- **Co je gamut a proč se výtisk liší od monitoru?** — Rozsah zobrazitelných barev. **CMYK má menší gamut než RGB**, takže sytě zelené a modré odstíny z monitoru nejdou vytisknout a nahradí se nejbližší dostupnou barvou.
- **Jak funguje flood fill a jaké má úskalí?** — Od výchozího pixelu se šíří do sousedů se stejnou barvou. **Rekurzivní verze může přetéct zásobník**, proto se používá fronta. Rozlišuje se 4-okolí a 8-okolí — 8-okolí protéká diagonálními škvírami.
- **Proč je u konvolučního jádra důležitý součet vah?** — Když je součet 1, zachová se celkový jas. Když je větší, obrázek se prosvětlí, když menší, ztmavne. Proto se rozostřovací jádro dělí devíti.
- **Co se stane s pixely na okraji při konvoluci?** — Nemají celé okolí. Možnosti: zmenšit výstup, zrcadlit okraje, opakovat krajní pixel, doplnit nulami (to ale ztmaví okraj).
- **Prochází Bézierova křivka všemi řídicími body?** — **Ne, jen prvním a posledním.** Prostřední ji jen „přitahují". Plyne to ze vzorce: pro $t=0$ zbyde jen $P_0$, pro $t=1$ jen $P_3$.
- **Jak bys optimalizoval aplikaci filtru na velký obrázek?** — Separabilní jádra (Gauss jde rozložit na dvě 1D konvoluce, $O(n^2) \to O(2n)$), **GPU akcelerace** (každý pixel nezávisle), zpracování po dlaždicích kvůli cache, náhled v nižším rozlišení.
- **Co je generační ztráta?** — Opakované uložení do ztrátového formátu kvalitu **kumulativně** zhoršuje, protože se pokaždé znovu kvantizuje. Proto se při editaci pracuje bezztrátově a komprimuje až při finálním exportu.
- **Rozdíl mezi kontejnerem a kodekem?** — **Kodek** (H.264, AAC) určuje, jak jsou data zakódovaná. **Kontejner** (MP4, MKV, AVI) je obal, který drží video, zvuk, titulky a metadata pohromadě. Jeden kontejner může obsahovat různé kodeky.

---

### Užitečné odkazy

- Numerické metody a interpolace: [SZZTP okruh 5](../../SZZTP/05-derivace-integraly-numerika/)
- Návrh a architektura aplikací: [SZZVP návrhové vzory](../../SZZVP/04-navrhove-vzory/)
