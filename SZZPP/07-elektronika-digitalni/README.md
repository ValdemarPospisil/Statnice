## 7 — Základy elektroniky: digitální část

- [Zadání okruhu (PDF)](../ZadaniOkruhu/ZEL-2okruhy.pdf)
- 📄 **[Tahák k okruhu 7](../Tahaky/07.md)** — jak začít u dekodéru, MUXu, sedmisegmentovky *(na mobil k nahlédnutí, ne k odevzdání)*

> Návrh logického kombinačního obvodu: **pravdivostní tabulka → minimalizace (Karnaugh i Quine-McCluskey) → rovnice → schéma**. 60 minut přípravy, pak 20 minut obhajoby. K dispozici tabulkový procesor a datasheet k sedmisegmentovce.

**Na papíře, ale mechanicky.** Proti [analogové části](../06-elektronika-analogova/) se tu nepočítá, jen se postupuje podle algoritmu. Když umíš Grayovo pořadí v Karnaughově mapě a tabulku pro Quine-McCluskey, je to spolehlivá práce bez rizika, že se přepočítáš.

> **Zásadní věc o ukázkové úloze:** dekodér 3→8 **nemá co minimalizovat** — každý výstup je jediný minterm, tedy izolovaná jednička v mapě, která se nemá s čím sloučit. Zadání přesto minimalizaci žádá, takže odpověď je *„provedl jsem ji a nic neubrala, protože…"*. Kdo to nepozná, hledá půl hodiny neexistující skupiny. [Podrobně níž](#rozbor-ukázkové-úlohy).

Překryv s [SZZTP okruh 10](../../SZZTP/10-logika-mnoziny-relace/) (výrokový počet, úplný systém spojek) — NAND/NOR převody a De Morgan jsou tam teoreticky.

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn, pak výklad s příklady. -->

#### Souhrn na jednom místě

| Co | Význam / vzorec | Zapamatuj si | Kde |
|---|---|---|---|
| **AND** ($\cdot$) | 1 jen když **všechny** vstupy 1 | jako násobení | [↓](#logická-hradla) |
| **OR** ($+$) | 1 když **aspoň jeden** vstup 1 | jako sčítání (ale $1+1=1$) | [↓](#logická-hradla) |
| **NOT** ($'$, negace) | obrací hodnotu | značí se čárkou nebo pruhem | [↓](#logická-hradla) |
| **NAND** | negovaný AND | **úplný systém** — postavíš z něj vše | [↓](#nand-nor-a-de-morgan) |
| **NOR** | negovaný OR | taky úplný systém | [↓](#nand-nor-a-de-morgan) |
| **XOR** ($\oplus$) | 1 když je vstupů 1 **nepárný počet** | „různost", sčítání bez přenosu | [↓](#logická-hradla) |
| **XNOR** | negovaný XOR | „shoda", komparátor | [↓](#logická-hradla) |
| **minterm** | součin, kde je každá proměnná právě raz | odpovídá **jednomu řádku** tabulky s výstupem 1 | [↓](#od-tabulky-k-rovnici) |
| **SoP** (DNF) | součet součinů: $AB + A'C$ | z jedniček tabulky | [↓](#od-tabulky-k-rovnici) |
| **PoS** (KNF) | součin součtů: $(A+B)(A'+C)$ | z nul tabulky | [↓](#od-tabulky-k-rovnici) |
| **Karnaughova mapa** | grafická minimalizace | **Grayovo pořadí**, slučuj mocniny dvou | [↓](#karnaughova-mapa) |
| **don't care** (X) | výstup nezáleží | **použij ho jako 1, když ti pomůže** | [↓](#dont-care-stavy) |
| **Quine-McCluskey** | tabulková minimalizace | algoritmus, funguje na libovolný počet proměnných | [↓](#quine-mccluskey) |
| **De Morgan** | $(AB)' = A' + B'$, $(A+B)' = A'B'$ | „negace rozdělí a obrátí operátor" | [↓](#nand-nor-a-de-morgan) |
| **dekodér** | $n$ vstupů → $2^n$ výstupů, aktivní právě jeden | každý výstup = jeden minterm | [↓](#dekodér) |
| **multiplexor** | $2^n$ vstupů → 1 výstup, adresa vybírá | **realizuje libovolnou funkci** $n$ proměnných | [↓](#multiplexor) |
| **7segment** | 7 LED (a–g) + tečka | **společná katoda** = aktivní 1, anoda = aktivní 0 | [↓](#sedmisegmentový-displej) |

**Tři věci, které rozhodují:** Grayovo pořadí v mapě, slučování jen v mocninách dvou (1, 2, 4, 8) i přes okraje, a to, že don't care smíš brát jako jedničku.

#### Logická hradla

| $A$ | $B$ | AND | OR | XOR | NAND | NOR | XNOR |
|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | **1** | **1** | **1** |
| 0 | 1 | 0 | 1 | 1 | **1** | 0 | 0 |
| 1 | 0 | 0 | 1 | 1 | **1** | 0 | 0 |
| 1 | 1 | **1** | 1 | 0 | 0 | 0 | **1** |

**Jak si to zapamatovat bez biflování:** AND je násobení ($0 \cdot 1 = 0$). OR je sčítání s tím, že $1 + 1 = 1$ (saturuje). XOR je „jsou různé". XNOR je „jsou stejné". NAND a NOR jsou prostě negace prvních dvou.

**Konkrétně:** $A = 1$, $B = 0$ → AND dá 0, OR dá 1, XOR dá 1 (různé), NAND dá 1 (negace nuly).

**XOR má užitečné vlastnosti**, na které se ptají:

$$A \oplus 0 = A, \qquad A \oplus 1 = A', \qquad A \oplus A = 0$$

Poslední dvě znamenají, že XOR funguje jako **řízená negace** a že se dá použít na jednoduché šifrování (dvakrát XOR týmž klíčem = původní hodnota).

#### Od tabulky k rovnici

**Součet součinů (SoP)** — vezmi **řádky, kde je výstup 1**, a pro každý napiš součin všech proměnných (negovaná tam, kde je 0):

| $A$ | $B$ | $C$ | $f$ | minterm |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | — |
| 0 | 0 | 1 | 1 | $A'B'C$ |
| 0 | 1 | 0 | 0 | — |
| 0 | 1 | 1 | 1 | $A'BC$ |
| 1 | 0 | 0 | 0 | — |
| 1 | 0 | 1 | 0 | — |
| 1 | 1 | 0 | 1 | $ABC'$ |
| 1 | 1 | 1 | 1 | $ABC$ |

$$f = A'B'C + A'BC + ABC' + ABC$$

Zapisuje se taky jako $f = \sum m(1, 3, 6, 7)$ — čísla jsou dekadické indexy řádků.

**Součin součtů (PoS)** — z **nul**, ale s obrácenou logikou: pro každý řádek s nulou napiš součet, kde je proměnná negovaná tam, kde je **1**. Pro řádek $A{=}0, B{=}0, C{=}0$ dostaneš $(A + B + C)$.

**Kterou formu volit:** SoP je běžnější a snáz se čte. PoS se vyplatí, když je v tabulce **málo nul** — pak je kratší.

#### Karnaughova mapa

**Grayovo pořadí** je celý trik: sousední políčka se liší **v jediném bitu**, takže se dají slučovat.

Mapa pro tři proměnné (proměnná $A$ určuje řádek, $BC$ sloupec):

```
        BC
A    00   01   11   10       <- POZOR: 11 před 10, ne binárně!
  0 | m0 | m1 | m3 | m2 |
  1 | m4 | m5 | m7 | m6 |
```

Mapa pro čtyři proměnné:

```
         CD
AB    00   01   11   10
   00| m0 | m1 | m3 | m2 |
   01| m4 | m5 | m7 | m6 |
   11| m12| m13| m15| m14|
   10| m8 | m9 | m11| m10|
```

**Proč Grayovo pořadí a ne binární** (klasická doptávka): kdyby byly sloupce v pořadí 00, 01, 10, 11, pak by sousedy byly `01` a `10`, které se liší ve **dvou** bitech — nešlo by je sloučit. Grayovo pořadí zajistí, že **každá dvě sousední políčka se liší právě v jednom bitu**, a tím se ta proměnná při sloučení vypustí.

**Pravidla slučování:**

1. Slučuj skupiny o velikosti **mocniny dvou**: 1, 2, 4, 8, 16. Nikdy 3 nebo 6.
2. Skupiny **musí být obdélníkové** (v mapě), ne do L.
3. **Přes okraje se to počítá jako soused** — mapa je na povrchu anuloidu. Levý a pravý sloupec jsou sousedi, horní a dolní řádek taky. **Všechny čtyři rohy tvoří jednu skupinu.**
4. Skupiny se **mohou překrývat** — to je v pořádku a často to pomůže.
5. Dělej **co největší** skupiny; každé zdvojnásobení velikosti vypustí jednu proměnnou.

**Kolik proměnných zbyde:** skupina o velikosti $2^k$ v mapě s $n$ proměnnými má součin s $n - k$ literály. Skupina 4 políček ve 4proměnné mapě → $4 - 2 = 2$ literály.

**Konkrétně** — majoritní funkce „aspoň dva ze tří vstupů jsou 1", tedy $f = \sum m(3, 5, 6, 7)$:

```
        BC
A    00   01   11   10
  0 |  0 |  0 |  1 |  0 |
  1 |  0 |  1 |  1 |  1 |
```

Tři dvojice: $m_3 + m_7$ (sloupec 11) → $BC$. $m_5 + m_7$ → $AC$. $m_6 + m_7$ → $AB$.

$$f = AB + BC + AC$$

Ze čtyř tříliterálových mintermů jsou tři dvouliterálové součiny — z 12 literálů na 6.

#### Don't care stavy

**X** (nebo **–**) znamená „na téhle kombinaci nezáleží, nikdy nenastane". Typicky u BCD, kde kódy 10–15 nemají význam.

**Pravidlo: ber don't care jako 1, když ti to zvětší skupinu. Jinak jako 0.** Nemusíš být konzistentní — u každé skupiny se rozhoduješ zvlášť.

**Konkrétně** — segment `a` sedmisegmentovky pro BCD (svítí u číslic 0, 2, 3, 5, 6, 7, 8, 9; kódy 10–15 jsou don't care):

Bez don't care by minimalizace dala dlouhý výraz. S nimi:

$$a = A + C + BD + B'D'$$

Kde $A$ je nejvyšší bit (váha 8), $D$ nejnižší (váha 1). **Čtyři členy místo osmi mintermů** — to je efekt don't care stavů.

#### Quine-McCluskey

Tabulkový algoritmus. **Výhoda proti Karnaughovi:** funguje pro libovolný počet proměnných a je mechanický (nedá se přehlédnout skupina).

**Postup:**

1. **Zapiš mintermy binárně** a seskup podle **počtu jedniček**.
2. **Slučuj sousední skupiny** — dva termy, které se liší v jediném bitu, sluč a ten bit označ `–`. Oba původní termy si označ jako použité.
3. **Opakuj**, dokud se dá slučovat.
4. **Neoznačené termy jsou primární implikanty.**
5. **Pokrývací tabulka:** řádky = primární implikanty, sloupce = mintermy. Najdi **esenciální** (ten, který jako jediný pokrývá nějaký minterm) a doplň zbytek.

**Konkrétně** na funkci $f = \sum m(0, 1, 2, 5, 6, 7)$ (tři proměnné $A, B, C$):

**Krok 1** — seskupení podle počtu jedniček:

| Skupina | Minterm | ABC |
|---|---|---|
| 0 jedniček | $m_0$ | 000 |
| 1 jednička | $m_1$ | 001 |
| | $m_2$ | 010 |
| 2 jedničky | $m_5$ | 101 |
| | $m_6$ | 110 |
| 3 jedničky | $m_7$ | 111 |

**Krok 2** — slučování (liší se v jednom bitu):

| Sloučeno | Výsledek | Zápis |
|---|---|---|
| $m_0, m_1$ | 00– | $A'B'$ |
| $m_0, m_2$ | 0–0 | $A'C'$ |
| $m_1, m_5$ | –01 | $B'C$ |
| $m_2, m_6$ | –10 | $BC'$ |
| $m_5, m_7$ | 1–1 | $AC$ |
| $m_6, m_7$ | 11– | $AB$ |

Dál se slučovat nedá (žádné dva se neliší v jednom bitu při stejné pozici `–`), takže **všech šest je primárních implikantů**.

**Krok 3** — pokrývací tabulka:

| Implikant | $m_0$ | $m_1$ | $m_2$ | $m_5$ | $m_6$ | $m_7$ |
|---|---|---|---|---|---|---|
| $A'B'$ | × | × | | | | |
| $A'C'$ | × | | × | | | |
| $B'C$ | | × | | × | | |
| $BC'$ | | | × | | × | |
| $AC$ | | | | × | | × |
| $AB$ | | | | | × | × |

Žádný minterm nemá jen jeden pokrývající implikant → **žádný esenciální**. Musíš vybrat minimální pokrytí, například:

$$f = A'B' + BC' + AC \qquad \text{nebo} \qquad f = A'C' + B'C + AB$$

**Obě jsou minimální** (tři členy, šest literálů). To je normální — minimální forma nemusí být jediná. **Řekni to u obhajoby**, ukazuje to, že rozumíš tomu, co se počítá.

**Skupinová minimalizace** (zadání ji zmiňuje) = minimalizace **několika výstupů společně**, aby se sdílely společné členy. U dekodéru nemá smysl (výstupy nemají nic společného), u sedmisegmentovky ano — segmenty sdílí podvýrazy.

#### NAND, NOR a De Morgan

**De Morganovy zákony:**

$$(A \cdot B)' = A' + B' \qquad (A + B)' = A' \cdot B'$$

Slovně: **negace se rozdělí na členy a operátor se obrátí.**

**Konkrétně:** $A = 1$, $B = 0$. Vlevo: $(1 \cdot 0)' = 0' = 1$. Vpravo: $1' + 0' = 0 + 1 = 1$. Sedí.

**NAND je úplný systém spojek** — postavíš z něj cokoli:

| Funkce | Z NAND |
|---|---|
| NOT $A$ | $A \uparrow A$ (oba vstupy stejné) |
| $A \cdot B$ | $(A \uparrow B) \uparrow (A \uparrow B)$ — NAND a pak negace |
| $A + B$ | $(A \uparrow A) \uparrow (B \uparrow B)$ — negace vstupů, pak NAND |

**Převod SoP na samá NAND** je mechanický: schéma AND-OR nahradíš NAND-NAND. Funguje to díky De Morganovi — dvojitá negace se vyruší:

$$AB + CD = \bigl((AB)' \cdot (CD)'\bigr)'$$

Takže **první úroveň AND hradel → NAND, druhá úroveň OR → taky NAND**. Nic dalšího se nemění. Tohle je oblíbená doptávka a je to jednodušší, než to zní.

Teorie úplných systémů spojek je v [SZZTP okruh 10](../../SZZTP/10-logika-mnoziny-relace/).

#### Dekodér

**$n$ vstupů → $2^n$ výstupů, aktivní je právě jeden** podle binární hodnoty na vstupu.

Bloková značka ze zadání má vstupy označené **váhami 1, 2, 4** (ne jmény A, B, C) a výstupy 0–7:

```
        +--------+
   ---->| 1    0 |---->
   ---->| 2    1 |---->
   ---->| 4    2 |---->
        |  DEC 3 |---->
        |      4 |---->
        |      5 |---->
        |      6 |---->
        |      7 |---->
        +--------+
```

**Každý výstup je právě jeden minterm** — to je celá jeho definice:

$$Y_0 = C'B'A', \quad Y_1 = C'B'A, \quad Y_2 = C'BA', \quad \dots, \quad Y_7 = CBA$$

(kde $A$ má váhu 1, $B$ váhu 2, $C$ váhu 4)

**Praktické použití:** adresování — vybere jeden z osmi paměťových čipů podle tří adresních bitů. Odtud „adresový dekodér".

**Aktivní úroveň:** bývá i dekodér s **aktivní nulou** (vybraný výstup je 0, ostatní 1) — pak jsou výstupy negované mintermy. Ověř si v zadání, co se chce.

#### Multiplexor

**$2^n$ datových vstupů → 1 výstup**, adresa $n$ bitů vybírá, který vstup se propustí.

Pro MUX 8:1:

$$Y = \sum_{i=0}^{7} D_i \cdot m_i$$

kde $m_i$ je minterm adresy. Tedy $Y = D_0 A'B'C' + D_1 A'B'C + \dots + D_7 ABC$.

**Jak realizovat libovolnou funkci** (nejlepší doptávka v celém okruhu): funkci $n$ proměnných realizuješ **jedním MUX $2^n{:}1$** tak, že proměnné dáš na adresní vstupy a **na datové vstupy přivedeš přímo hodnoty z pravdivostní tabulky** (0 nebo 1).

**Konkrétně** pro $f = \sum m(1, 3, 6, 7)$ a MUX 8:1: adresa = $ABC$, a datové vstupy nastavíš na $D_0{=}0$, $D_1{=}1$, $D_2{=}0$, $D_3{=}1$, $D_4{=}0$, $D_5{=}0$, $D_6{=}1$, $D_7{=}1$. **Žádná minimalizace není potřeba** — tabulka je přímo zapojení.

**Poloviční trik** (dojem na komisi): funkci $n$ proměnných zvládneš i s MUX $2^{n-1}{:}1$ — na adresu dáš $n-1$ proměnných a na datové vstupy přivedeš poslední proměnnou, její negaci, 0 nebo 1 podle toho, co v té dvojici řádků tabulky vychází.

#### Sedmisegmentový displej

Sedm LED označených **a** až **g** (plus tečka **dp**):

```
     aaa
    f   b
    f   b
     ggg
    e   c
    e   c
     ddd   dp
```

**Společná katoda** (typ 5161AS ze zadání): všechny katody LED jsou spojené na zem, segment se rozsvítí **jedničkou** na anodě. Aktivní úroveň = **1**.

**Společná anoda:** naopak — anody na $+U$, segment svítí **nulou**. Aktivní úroveň = **0**.

**Praktická věc, na kterou se ptají:** ke každému segmentu patří **předřadný rezistor** (typicky 220–330 Ω), jinak LED spálíš. Rezistor patří do série s každým segmentem zvlášť, ne jeden společný — jinak by jasnost závisela na počtu svítících segmentů.

**Které segmenty svítí u které číslice** (dekodér BCD → 7 segmentů):

| Číslice | a | b | c | d | e | f | g |
|---|---|---|---|---|---|---|---|
| 0 | 1 | 1 | 1 | 1 | 1 | 1 | 0 |
| 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
| 2 | 1 | 1 | 0 | 1 | 1 | 0 | 1 |
| 3 | 1 | 1 | 1 | 1 | 0 | 0 | 1 |
| 4 | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
| 5 | 1 | 0 | 1 | 1 | 0 | 1 | 1 |
| 6 | 1 | 0 | 1 | 1 | 1 | 1 | 1 |
| 7 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
| 8 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 9 | 1 | 1 | 1 | 1 | 0 | 1 | 1 |

Kódy 10–15 jsou **don't care** — toho se využívá při minimalizaci každého segmentu zvlášť.

---

### Postup u zkoušky (60 min přípravy)

**0–10 min — pravdivostní tabulka**

1. **Ze slovního zadání sestav tabulku.** Tady se dělá nejvíc chyb — přečti zadání dvakrát.
2. **Označ si váhy vstupů** a jejich pořadí (co je MSB). Pak už to neměň.
3. Vyznač **don't care** stavy, pokud nějaké jsou.
4. Zapiš funkci jako $\sum m(\dots)$ — kompaktní a snadno se kontroluje.

**10–25 min — Karnaughova mapa**

5. Nakresli mřížku a **napiš záhlaví v Grayově pořadí** (00, 01, 11, 10). Zkontroluj to, než začneš plnit.
6. Vyplň jedničky a don't care.
7. Slučuj **od největších skupin**, přes okraje, s překryvy.
8. Zapiš minimalizovanou rovnici.

**25–40 min — Quine-McCluskey**

9. Seskup mintermy podle počtu jedniček, slučuj, najdi primární implikanty.
10. Pokrývací tabulka, esenciální implikanty, minimální pokrytí.
11. **Porovnej s Karnaughem** — musí vyjít stejný počet členů a literálů (výrazy se mohou lišit).

**40–55 min — schéma a multiplexor**

12. Nakresli schéma z minimalizované rovnice (AND–OR).
13. Případně převeď na NAND–NAND.
14. Realizuj MUX — datové vstupy přímo z tabulky.

**55–60 min — kontrola**

15. **Ověř rovnici na dvou–třech řádcích tabulky.** Dosaď a spočítej.
16. Zkontroluj, že Karnaugh a Quine-McCluskey daly ekvivalentní výsledek.

**Kontrola v Pythonu** není v seznamu materiálů (je tam tabulkový procesor), ale v Excelu si tabulku ověřit můžeš — vzorec `=IF(AND(...),1,0)` a porovnat sloupce.

---

### Rozbor ukázkové úlohy

> Navrhněte **adresový dekodér se třemi vstupy a osmi výstupy**. Každé kombinaci vstupních hodnot bude odpovídat právě jeden aktivní výstup.
>
> 1. Pravdivostní tabulka · 2. Minimalizace Karnaughovou mapou · 3. Minimalizace Quine-McCluskey · 4. Schéma dekodéru · 5. Návrh pomocí multiplexorů

Vstupy jsou ve schématu označené **váhami 1, 2, 4**. Označím je $A$ (váha 1), $B$ (váha 2), $C$ (váha 4), takže hodnota na vstupu je $4C + 2B + A$.

#### 1. Pravdivostní tabulka

| $C$ (4) | $B$ (2) | $A$ (1) | Hodnota | $Y_0$ | $Y_1$ | $Y_2$ | $Y_3$ | $Y_4$ | $Y_5$ | $Y_6$ | $Y_7$ |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | **1** | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 | **1** | 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 1 | 0 | 2 | 0 | 0 | **1** | 0 | 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 3 | 0 | 0 | 0 | **1** | 0 | 0 | 0 | 0 |
| 1 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | **1** | 0 | 0 | 0 |
| 1 | 0 | 1 | 5 | 0 | 0 | 0 | 0 | 0 | **1** | 0 | 0 |
| 1 | 1 | 0 | 6 | 0 | 0 | 0 | 0 | 0 | 0 | **1** | 0 |
| 1 | 1 | 1 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | **1** |

**Na diagonále jsou jedničky** — to je vizuální podpis dekodéru. Každý řádek má právě jednu.

#### 2. Minimalizace Karnaughovou mapou — a proč nic neubere

**Tohle je pointa celé úlohy.** Vezmi mapu pro výstup $Y_3$ (aktivní jen při hodnotě 3, tedy $C{=}0, B{=}1, A{=}1$):

```
        BA
C    00   01   11   10
  0 |  0 |  0 |  1 |  0 |
  1 |  0 |  0 |  0 |  0 |
```

**Jediná jednička, izolovaná.** Nemá žádného souseda s jedničkou, takže největší možná skupina má velikost 1 a vypustí nulu proměnných:

$$Y_3 = C'BA$$

**Totéž platí pro všech osm výstupů.** Každý má v mapě přesně jednu jedničku:

$$Y_0 = C'B'A' \quad Y_1 = C'B'A \quad Y_2 = C'BA' \quad Y_3 = C'BA$$
$$Y_4 = CB'A' \quad Y_5 = CB'A \quad Y_6 = CBA' \quad Y_7 = CBA$$

**Jak to říct u obhajoby:**

> „Minimalizaci jsem provedl pro každý výstup zvlášť. Každý výstup dekodéru je definičně **jediný minterm**, takže v Karnaughově mapě je to izolovaná jednička bez sousedů — nemá se s čím sloučit a minimalizace nemůže nic ubrat. Výsledný výraz je totožný s mintermem z tabulky. To není chyba postupu, ale vlastnost dekodéru."

Kdo tohle řekne, má bod. Kdo hledá skupiny, ztratí půl hodiny.

#### 3. Quine-McCluskey — stejný výsledek, jinou cestou

Pro $Y_3$ je vstupem jediný minterm $m_3 = 011$:

| Krok | Obsah |
|---|---|
| Seskupení podle počtu 1 | skupina „2 jedničky": $011$ |
| Slučování | **není s čím** — jediný term v celé tabulce |
| Primární implikanty | $011 = C'BA$ |
| Pokrývací tabulka | jeden řádek, jeden sloupec → implikant je **esenciální** |

$$Y_3 = C'BA$$

**Argument je stejný jako u Karnaughovy mapy** — algoritmus proběhne, ale slučovací fáze nemá co dělat. U obhajoby stačí ukázat na jednom výstupu a říct, že u ostatních sedmi je to analogické.

**Skupinová minimalizace** (zadání ji jmenuje u požadovaných znalostí): u dekodéru **nemá co sdílet**, protože žádné dva výstupy nemají společný implikant — každý je jiný minterm. Můžeš ale sdílet **negace vstupů**: $A'$, $B'$, $C'$ se použijí opakovaně, takže stačí **tři invertory** pro celý obvod. To je jediná úspora, která tu existuje, a je dobré ji zmínit.

#### 4. Schéma dekodéru

Osm tříbranných AND hradel, každé s jinou kombinací negovaných a nenegovaných vstupů:

Nejdřív invertory, pak osm tříbranných AND hradel. Každý vstup je k dispozici v obou polaritách:

```
  A ---+---------------------> A
       +---[>o]-------------->  A'      (invertor)

  B ---+---------------------> B
       +---[>o]-------------->  B'

  C ---+---------------------> C
       +---[>o]-------------->  C'
```

Z těch šesti signálů se pak sestaví osm součinů — každý AND dostane jednu kombinaci polarit:

| Výstup | AND vstupy | Aktivní při |
|---|---|---|
| $Y_0$ | $C'$, $B'$, $A'$ | 000 = 0 |
| $Y_1$ | $C'$, $B'$, $A$ | 001 = 1 |
| $Y_2$ | $C'$, $B$, $A'$ | 010 = 2 |
| $Y_3$ | $C'$, $B$, $A$ | 011 = 3 |
| $Y_4$ | $C$, $B'$, $A'$ | 100 = 4 |
| $Y_5$ | $C$, $B'$, $A$ | 101 = 5 |
| $Y_6$ | $C$, $B$, $A'$ | 110 = 6 |
| $Y_7$ | $C$, $B$, $A$ | 111 = 7 |

Jeden výstup podrobně:

```
   C' ----+
          |
   B  ----+---[ AND ]----> Y3      (aktivní při C=0, B=1, A=1)
          |
   A  ----+
```

**Vzor je jednoduchý:** sloupec polarit v tabulce je binární zápis indexu výstupu, kde 0 znamená negovaný vstup. $Y_5$ = 101 → $C$ nenegované, $B$ negované, $A$ nenegované.

**Spotřeba hradel:** 3 invertory + 8 tříbranných AND. To je celý dekodér.

**Varianta s aktivní nulou:** místo AND použij NAND — výstupy budou negované, tedy vybraný výstup 0 a ostatní 1. Používá se to častěji, protože se tím dá přímo budit `CS` (chip select) vstup, který je typicky aktivní v nule.

#### 5. Návrh pomocí multiplexorů

Zadání chce „obvod pomocí multiplexorů". Dekodér a multiplexor jsou **duální funkce** (dekodér má jeden vstup a mnoho výstupů, MUX mnoho vstupů a jeden výstup), takže se realizuje po výstupech:

**Každý výstup zvlášť jedním MUX 8:1:** adresa = $CBA$, datové vstupy přímo z tabulky. Pro $Y_3$ tedy $D_3 = 1$ a všechny ostatní $D_i = 0$.

```
  Y3:  MUX 8:1, adresa CBA
       D0=0  D1=0  D2=0  D3=1  D4=0  D5=0  D6=0  D7=0
```

To je funkční, ale **osm multiplexorů na dekodér je plýtvání** — a přesně to u obhajoby řekni:

> „Realizace multiplexorem je formálně možná, ale u dekodéru neefektivní — potřeboval bych osm MUX 8:1, tedy podstatně víc hradel než osm AND. Multiplexor se hodí na realizaci **jedné složité funkce**, kde ušetří minimalizaci, ne na dekodér, jehož výstupy jsou triviální mintermy. Naopak **demultiplexor** je s dekodérem funkčně totožný — dekodér s povolovacím vstupem *je* demultiplexor."

Ta poslední věta je nejcennější věc, kterou v tomhle bodě můžeš říct.

---

### Příklady na procvičení

Oba mají **ověřené výsledky**. Spočítej rukou, pak zkontroluj.

#### Příklad 1 — majoritní funkce (rozcvička, ~15 min)

Navrhni obvod se třemi vstupy $A, B, C$, který dá na výstupu 1, když jsou **aspoň dva vstupy v jedničce** (hlasování 2 ze 3).

**Udělej:** tabulku, Karnaughovu mapu, minimalizaci, Quine-McCluskey, schéma, a realizaci MUX 8:1.

<details markdown="1">
<summary><strong>Řešení příkladu 1</strong> — až po vlastním výpočtu</summary>

**Pravdivostní tabulka:**

| $A$ | $B$ | $C$ | počet 1 | $f$ |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 |
| 0 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 2 | **1** |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 2 | **1** |
| 1 | 1 | 0 | 2 | **1** |
| 1 | 1 | 1 | 3 | **1** |

$$f = \sum m(3, 5, 6, 7)$$

**Karnaughova mapa:**

```
        BC
A    00   01   11   10
  0 |  0 |  0 |  1 |  0 |
  1 |  0 |  1 |  1 |  1 |
```

Tři dvojice (každá vypustí jednu proměnnou):

- $m_3, m_7$ → sloupec 11, mění se $A$ → $BC$
- $m_5, m_7$ → mění se $B$ → $AC$
- $m_6, m_7$ → mění se $C$ → $AB$

$$f = AB + BC + AC$$

**Quine-McCluskey:**

| Skupina | Minterm | ABC |
|---|---|---|
| 2 jedničky | $m_3$ | 011 |
| | $m_5$ | 101 |
| | $m_6$ | 110 |
| 3 jedničky | $m_7$ | 111 |

Slučování: $m_3{+}m_7 = {-}11 = BC$, $m_5{+}m_7 = 1{-}1 = AC$, $m_6{+}m_7 = 11{-} = AB$. Dál to nejde.

Pokrývací tabulka:

| Implikant | $m_3$ | $m_5$ | $m_6$ | $m_7$ |
|---|---|---|---|---|
| $BC$ | × | | | × |
| $AC$ | | × | | × |
| $AB$ | | | × | × |

$m_3$ pokrývá jen $BC$ → **esenciální**. Stejně $m_5$ → $AC$ a $m_6$ → $AB$. **Všechny tři jsou esenciální**, takže:

$$f = AB + BC + AC$$

Shoda s Karnaughem ✓

**Schéma:** tři dvoubranná AND hradla ($AB$, $BC$, $AC$) a jedno tříbranné OR. **Žádný invertor** — funkce neobsahuje negace, což je pěkná vlastnost majoritní funkce.

**MUX 8:1:** adresa $ABC$, datové vstupy $D_0{=}0$, $D_1{=}0$, $D_2{=}0$, $D_3{=}1$, $D_4{=}0$, $D_5{=}1$, $D_6{=}1$, $D_7{=}1$ — přímo sloupec $f$ z tabulky.

**Kontrola** dosazením $A{=}1, B{=}0, C{=}1$: $AB + BC + AC = 0 + 0 + 1 = 1$. V tabulce řádek 5 → 1 ✓

</details>

#### Příklad 2 — segment `a` sedmisegmentovky (plná úloha, ~35 min)

Navrhni obvod, který budí **segment `a`** sedmisegmentového displeje se **společnou katodou** podle BCD vstupu $A$ (váha 8), $B$ (4), $C$ (2), $D$ (1).

Segment `a` (horní vodorovná čárka) svítí u číslic **0, 2, 3, 5, 6, 7, 8, 9**. Kódy 10–15 jsou **don't care**.

**Udělej:** tabulku, Karnaughovu mapu s využitím don't care, minimalizaci, Quine-McCluskey a schéma. Porovnej, o kolik don't care pomohly.

<details markdown="1">
<summary><strong>Řešení příkladu 2</strong> — až po vlastním výpočtu</summary>

**Pravdivostní tabulka:**

| Číslice | $A$ | $B$ | $C$ | $D$ | segment `a` |
|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | **1** |
| 1 | 0 | 0 | 0 | 1 | 0 |
| 2 | 0 | 0 | 1 | 0 | **1** |
| 3 | 0 | 0 | 1 | 1 | **1** |
| 4 | 0 | 1 | 0 | 0 | 0 |
| 5 | 0 | 1 | 0 | 1 | **1** |
| 6 | 0 | 1 | 1 | 0 | **1** |
| 7 | 0 | 1 | 1 | 1 | **1** |
| 8 | 1 | 0 | 0 | 0 | **1** |
| 9 | 1 | 0 | 0 | 1 | **1** |
| 10–15 | 1 | – | – | – | **X** |

$$a = \sum m(0, 2, 3, 5, 6, 7, 8, 9) + \sum d(10, 11, 12, 13, 14, 15)$$

**Karnaughova mapa** (X = don't care):

```
         CD
AB    00   01   11   10
   00|  1 |  0 |  1 |  1 |
   01|  0 |  1 |  1 |  1 |
   11|  X |  X |  X |  X |
   10|  1 |  1 |  X |  X |
```

Skupiny (don't care beru jako 1, kde pomůže):

1. **Celý spodní půl mapy** (řádky 11 a 10, tedy $A{=}1$): 8 políček → $A$
2. **Sloupce 11 a 10** (tedy $C{=}1$): 8 políček → $C$
3. **$BD$**: políčka $m_5, m_7, m_{13}, m_{15}$ → 4 políčka → $BD$
4. **$B'D'$**: políčka $m_0, m_2, m_8, m_{10}$ → 4 políčka → $B'D'$

$$a = A + C + BD + B'D'$$

**Kontrola pokrytí:** $m_0$ (v $B'D'$) ✓, $m_2$ (v $C$ i $B'D'$) ✓, $m_3$ ($C$) ✓, $m_5$ ($BD$) ✓, $m_6$ ($C$) ✓, $m_7$ ($C$, $BD$) ✓, $m_8$ ($A$) ✓, $m_9$ ($A$) ✓. A nula $m_1$ ani $m_4$ v žádné skupině není ✓

**Quine-McCluskey** dá tytéž čtyři primární implikanty:

| Implikant | Binárně | Pokrývá |
|---|---|---|
| $C$ | `--1-` | 2, 3, 6, 7, 10, 11, 14, 15 |
| $B'D'$ | `-0-0` | 0, 2, 8, 10 |
| $BD$ | `-1-1` | 5, 7, 13, 15 |
| $A$ | `1---` | 8–15 |

Esenciální: $m_0$ pokrývá jen $B'D'$, $m_3$ a $m_6$ jen $C$, $m_5$ jen $BD$, $m_9$ jen $A$ → **všechny čtyři jsou esenciální**.

$$a = A + C + BD + B'D'$$

**O kolik don't care pomohly:** bez nich (kódy 10–15 jako nuly) by nešly udělat skupiny přes spodní řádky. Skupina $A$ by zmizela úplně a ostatní by se zmenšily na dvojice — dostal bys šest a víc členů se třemi literály. **Se don't care jsou to čtyři členy s nejvýš dvěma literály.** To je ten důvod, proč se u BCD vždycky používají.

**Schéma:** dvě dvoubranná AND ($BD$, $B'D'$), jedno čtyřbranné OR, dva invertory ($B'$, $D'$). Vstupy $A$ a $C$ jdou do OR přímo.

**Společná katoda:** segment svítí **jedničkou**, takže výstup obvodu jde přes předřadný rezistor (~220 Ω) na anodu segmentu. Kdyby to byla společná anoda, musel bys celý výstup **znegovat**, protože segment tam svítí nulou.

</details>


---

### Katalog typů úloh

**Všechny výsledky níž jsou ověřené a verifikované na všech kombinacích vstupů.** Postup je vždy stejný — tabulka → K-mapa → minimalizace → schéma — mění se jen zadání. Projdi si je a u každého si zkus výsledek odvodit sám dřív, než se podíváš.

#### Přehled

| # | Typ úlohy | Vstupy → výstupy | Zvláštnost |
|---|---|---|---|
| 1 | [Dekodér](#1-dekodér-n--2n) | $n$ → $2^n$ | **minimalizace nic neubere** |
| 2 | [Multiplexor](#2-multiplexor-2n--1) | $2^n$ + $n$ adresních → 1 | realizuje libovolnou funkci |
| 3 | [Sedmisegmentovka](#3-sedmisegmentový-displej) | 4 (BCD) → 7 | **don't care** 10–15 |
| 4 | [Binární → Gray](#4-převodník-binární--gray) | 4 → 4 | čisté XOR, K-mapa netřeba |
| 5 | [Gray → binární](#5-převodník-gray--binární) | 4 → 4 | **kumulativní** XOR |
| 6 | [Komparátor](#6-komparátor) | 4 (2+2) → 3 | tři výstupy: >, =, < |
| 7 | [Sčítačka](#7-sčítačka) | 2–3 → 2 | základ ALU |
| 8 | [Prioritní kodér](#8-prioritní-kodér) | 4 → 2 + validita | **priorita** vstupů |
| 9 | [Detektor vlastnosti](#9-detektory-vlastností) | 4 → 1 | dělitelnost, prvočíslo |
| 10 | [Parita](#10-generátor-parity) | 4 → 1 | **nejde zminimalizovat** |
| 11 | [Majorita](#11-majoritní-funkce) | 3–4 → 1 | hlasování |
| 12 | [Validátor BCD](#12-validátor-bcd) | 4 → 1 | detekce neplatného kódu |

---

#### 1. Dekodér ($n$ → $2^n$)

**Zadání:** každé kombinaci vstupů odpovídá právě jeden aktivní výstup.

Podrobně v [rozboru ukázkové úlohy](#rozbor-ukázkové-úlohy). Shrnutí:

$$Y_0 = C'B'A' \quad Y_1 = C'B'A \quad \dots \quad Y_7 = CBA$$

**Zvláštnost:** každý výstup je **jediný minterm**, takže v K-mapě je to izolovaná jednička. **Minimalizace nemůže nic ubrat** — a to je celý vtip té úlohy.

**Schéma:** 3 invertory + 8 tříbranných AND.

---

#### 2. Multiplexor ($2^n$ → 1)

**Zadání:** adresa vybírá, který datový vstup se propustí na výstup.

$$Y = \sum_{i=0}^{2^n-1} D_i \cdot m_i \qquad \text{kde } m_i \text{ je minterm adresy}$$

Pro MUX 4:1 s adresou $S_1 S_0$:

$$Y = D_0 S_1'S_0' + D_1 S_1'S_0 + D_2 S_1 S_0' + D_3 S_1 S_0$$

**Realizace libovolné funkce** (nejlepší doptávka okruhu): proměnné na adresní vstupy, **hodnoty z pravdivostní tabulky přímo na datové vstupy**. Žádná minimalizace není potřeba.

```
f = Σm(1,3,6,7) pomocí MUX 8:1, adresa ABC:
   D0=0  D1=1  D2=0  D3=1  D4=0  D5=0  D6=1  D7=1
        ↑ tohle je doslova sloupec f z tabulky
```

**Poloviční trik:** funkci $n$ proměnných zvládneš i s MUX $2^{n-1}$:1 — na adresu dáš $n-1$ proměnných a na datové vstupy přivedeš `0`, `1`, poslední proměnnou nebo její negaci (Shannonův rozvoj).

---

#### 3. Sedmisegmentový displej

**Zadání:** BCD vstup (0–9) → sedm segmentů. Kódy 10–15 jsou **don't care**.

Tabulka (společná katoda, segment svítí v `1`):

| Číslice | $A$ | $B$ | $C$ | $D$ | a | b | c | d | e | f | g |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
| 2 | 0 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 1 |
| 3 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 |
| 4 | 0 | 1 | 0 | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
| 5 | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 1 | 1 |
| 6 | 0 | 1 | 1 | 0 | 1 | 0 | 1 | 1 | 1 | 1 | 1 |
| 7 | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
| 8 | 1 | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 9 | 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 |

**Ověřené minimalizace všech sedmi segmentů** (s využitím don't care):

| Segment | Mintermy | Minimalizovaný výraz |
|---|---|---|
| **a** | 0,2,3,5,6,7,8,9 | $A + C + BD + B'D'$ |
| **b** | 0,1,2,3,4,7,8,9 | $B' + CD + C'D'$ |
| **c** | 0,1,3,4,5,6,7,8,9 | $B + D + C'$ |
| **d** | 0,2,3,5,6,8,9 | $A + B'C + CD' + B'D' + BC'D$ |
| **e** | 0,2,6,8 | $CD' + B'D'$ |
| **f** | 0,4,5,6,8,9 | $A + BC' + BD' + C'D'$ |
| **g** | 2,3,4,5,6,8,9 | $A + B'C + BC' + CD'$ |

**Všimni si:** segment `c` má jen **tři členy s jedním literálem** — je to nejjednodušší, protože svítí u devíti z deseti číslic (nesvítí jen u dvojky). Segment `d` je naopak nejsložitější.

**Skupinová minimalizace** (zadání ji zmiňuje): několik segmentů sdílí podvýrazy — např. $B'D'$ je v `a` i `e`, $CD'$ v `e` i `g`. Sdílením hradel ušetříš.

---

#### 4. Převodník binární → Gray

**Zadání:** převeď 4bitové binární číslo na Grayův kód (sousední hodnoty se liší v jediném bitu).

**Ověřená tabulka:**

```
B3B2B1B0 -> G3G2G1G0      B3B2B1B0 -> G3G2G1G0
  0000   ->   0000          1000   ->   1100
  0001   ->   0001          1001   ->   1101
  0010   ->   0011          1010   ->   1111
  0011   ->   0010          1011   ->   1110
  0100   ->   0110          1100   ->   1010
  0101   ->   0111          1101   ->   1011
  0110   ->   0101          1110   ->   1001
  0111   ->   0100          1111   ->   1000
```

**Minimalizace přes K-mapu** (ověřeno):

$$G_3 = A \qquad G_2 = A'B + AB' \qquad G_1 = B'C + BC' \qquad G_0 = C'D + CD'$$

**Klíčové pozorování:** $A'B + AB'$ **je definice XOR**. Takže:

$$G_3 = B_3 \qquad G_2 = B_3 \oplus B_2 \qquad G_1 = B_2 \oplus B_1 \qquad G_0 = B_1 \oplus B_0$$

**Obecné pravidlo:** nejvyšší bit se opíše, každý další je XOR sousedních binárních bitů.

**Schéma:** tři XOR hradla, žádné AND/OR. **K-mapu vlastně nepotřebuješ** — když vzorec znáš, napíšeš schéma rovnou.

```
  B3 ─────────────────────────► G3
      ├──────┐
  B2 ─┼──────┤ XOR ├──────────► G2
      │      └──────┘
      ├──────┐
  B1 ─┼──────┤ XOR ├──────────► G1
      │      └──────┘
      ├──────┐
  B0 ────────┤ XOR ├──────────► G0
             └──────┘
```

**K čemu Gray kód je** (doptávka): u inkrementálních snímačů polohy. Při přechodu mezi sousedními hodnotami se mění **jediný bit**, takže nemůže vzniknout přechodový stav s nesmyslnou hodnotou. U binárního kódu přechod 0111 → 1000 mění všechny čtyři bity naráz.

---

#### 5. Převodník Gray → binární

**Zadání:** opačný směr.

$$B_3 = G_3 \qquad B_2 = B_3 \oplus G_2 \qquad B_1 = B_2 \oplus G_1 \qquad B_0 = B_1 \oplus G_0$$

Rozepsáno jen přes vstupy:

$$B_3 = A \qquad B_2 = A \oplus B \qquad B_1 = A \oplus B \oplus C \qquad B_0 = A \oplus B \oplus C \oplus D$$

**Zvláštnost:** je to **kumulativní** XOR — každý další bit XORuje všechny předchozí. Proto se K-mapa nevyplatí: $B_0$ má **osm mintermů bez jediného souseda**, takže minimalizace nic neubere a výraz by měl osm čtyřliterálových členů.

**Schéma:** řetěz tří XOR hradel zapojených **za sebou** (výstup jednoho jde do dalšího), na rozdíl od binární→Gray, kde jsou paralelně.

---

#### 6. Komparátor

**Zadání:** porovnej dvě dvoubitová čísla $A_1A_0$ a $B_1B_0$, výstupy „větší", „rovno", „menší".

Značení pro K-mapu: $A = A_1$, $B = A_0$, $C = B_1$, $D = B_0$.

**Ověřené minimalizace:**

| Výstup | Mintermy | Výraz |
|---|---|---|
| $A > B$ | 4,8,9,12,13,14 | $AC' + ABD' + BC'D'$ |
| $A = B$ | 0,5,10,15 | $ABCD + A'BC'D + AB'CD' + A'B'C'D'$ |
| $A < B$ | 1,2,3,6,7,11 | $A'C + B'CD + A'B'D$ |

**Elegantnější zápis rovnosti přes XNOR:**

$$(A = B) = (A_1 \odot B_1) \cdot (A_0 \odot B_0)$$

Slovy: čísla se rovnají, když se **rovnají oba páry bitů**. XNOR je „shoda", takže dvě XNOR hradla a jeden AND. To je podstatně méně hradel než ta čtyřčlenná SoP forma — **zmiň to u obhajoby**.

**Kontrola:** tři výstupy se musí navzájem vylučovat a pokrýt všechny stavy: $6 + 4 + 6 = 16$ ✓

---

#### 7. Sčítačka

**Poloviční sčítačka** (half adder) — dva vstupy, bez přenosu zvenčí:

| $A$ | $B$ | $S$ | $C$ |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | **1** |

$$S = A'B + AB' = A \oplus B \qquad C = AB$$

**Jedno XOR a jedno AND.** Součet je XOR, přenos je AND — to si zapamatuj, je to základ všeho.

**Úplná sčítačka** (full adder) — přidá přenos ze spodního řádu $C_{in}$:

$$S = A \oplus B \oplus C_{in}$$
$$C_{out} = AB + AC_{in} + BC_{in}$$

**Ověřeno:** $S$ má mintermy 1,2,4,7 (lichý počet jedniček), $C_{out}$ mintermy 3,5,6,7 (aspoň dvě jedničky).

**Všimni si:** $C_{out}$ je **majoritní funkce** — přenos vznikne, když jsou aspoň dva ze tří vstupů v jedničce. To je hezká souvislost s [úlohou 11](#11-majoritní-funkce).

**Schéma úplné sčítačky:** dvě poloviční sčítačky + jedno OR.

---

#### 8. Prioritní kodér

**Zadání:** čtyři vstupy $D_3 \dots D_0$, výstupem je **binární index nejvyššího aktivního vstupu**. Když jsou aktivní dva, vyhrává ten s vyšší prioritou.

Značení: $A = D_3$, $B = D_2$, $C = D_1$, $D = D_0$.

**Ověřené minimalizace:**

$$Y_1 = A + B \qquad Y_0 = A + B'C \qquad V = A + B + C + D$$

**Jak to číst:** $Y_1$ je 1, když je aktivní $D_3$ **nebo** $D_2$ (oba mají index ≥ 2). $Y_0$ je 1 při $D_3$, nebo při $D_1$ **za podmínky, že $D_2$ není aktivní** (jinak by vyhrál on).

**Výstup $V$ (valid)** je nutný, protože bez něj nerozlišíš „aktivní je $D_0$" (výstup 00) od „není aktivní nic" (taky 00).

**Rozdíl proti obyčejnému kodéru:** obyčejný kodér předpokládá, že je aktivní **právě jeden** vstup, a při dvou dá nesmysl. Prioritní řeší i současnou aktivaci — proto se používá v přerušovacím řadiči procesoru.

---

#### 9. Detektory vlastností

**Zadání typu:** výstup je 1, když vstupní číslo má nějakou vlastnost.

**Dělitelnost třemi** (4 bity, hodnoty 1–15), mintermy 3, 6, 9, 12, 15:

$$f = ABCD + A'B'CD + A'BCD' + AB'C'D + ABC'D'$$

**Zvláštnost:** **nedá se zminimalizovat** — každý minterm je izolovaný, protože násobky tří v binárním zápisu nesousedí. Výsledek je stejně dlouhý jako součet mintermů.

> **Tohle je stejná situace jako u dekodéru** a je dobré ji poznat rychle: když jsou mintermy „rozházené", minimalizace nepomůže. Řekni to nahlas a nehledej skupiny, které neexistují.

**Prvočíslo** (2, 3, 5, 7, 11, 13):

$$f = A'CD + B'CD + BC'D + A'B'C$$

Tady minimalizace **funguje** — ze šesti čtyřliterálových mintermů se staly čtyři tříliterálové členy.

---

#### 10. Generátor parity

**Zadání:** výstup je 1, když je počet jedniček na vstupu **lichý** (sudá parita — doplní se do sudého počtu).

Mintermy: 1, 2, 4, 7, 8, 11, 13, 14.

$$P = A \oplus B \oplus C \oplus D$$

**Zvláštnost — nejdůležitější poznatek:** v K-mapě je to **šachovnice**. Žádné dvě jedničky spolu nesousedí, takže **minimalizace je nemožná**. SoP forma má osm čtyřliterálových mintermů, což je nejhorší možný případ.

**Ale s XOR** je to jediný řetězec tří hradel. To je celá pointa: **XOR se v Karnaughově mapě neprojeví jako slučitelná skupina**, proto se šachovnicový vzor musí poznat na první pohled.

```
       CD
 AB   00 01 11 10
 00 |  0  1  0  1 |
 01 |  1  0  1  0 |     <- šachovnice = XOR
 11 |  0  1  0  1 |
 10 |  1  0  1  0 |
```

**Použití:** kontrola přenosu dat. Odesílatel přidá paritní bit, příjemce parity přepočítá — když nesedí, došlo k chybě v lichém počtu bitů.

---

#### 11. Majoritní funkce

**Zadání:** výstup je 1, když je aspoň polovina (nebo daný počet) vstupů v jedničce.

**Dva ze tří** (mintermy 3, 5, 6, 7):

$$f = AB + AC + BC$$

**Tři ze čtyř** (mintermy 7, 11, 13, 14, 15):

$$f = ABC + ABD + ACD + BCD$$

**Vzor je zřejmý:** všechny kombinace $k$ vstupů z $n$. Pro „2 ze 3" jsou to všechny dvojice, pro „3 ze 4" všechny trojice. **K-mapu vlastně nepotřebuješ** — napíšeš to z kombinatoriky.

**Pěkná vlastnost:** výraz **neobsahuje žádnou negaci**, takže schéma nepotřebuje invertory. Jen AND hradla a jedno OR.

**Použití:** hlasovací obvody v systémech s trojitou redundancí (letecká technika) — když dva ze tří počítačů řeknou totéž, výsledek se bere jako správný.

---

#### 12. Validátor BCD

**Zadání:** detekuj neplatný BCD kód (hodnoty 10–15).

$$f = AB + AC$$

**Odvození bez K-mapy:** neplatné jsou hodnoty ≥ 10, tedy `1010` až `1111`. Všechny mají $A = 1$ (jsou ≥ 8) a zároveň $B = 1$ nebo $C = 1$ (aby byly ≥ 10). Odtud $A(B + C) = AB + AC$.

**Doplněk** — platný BCD je negace: $f' = A' + B'C'$ (De Morgan).

**Použití:** v BCD sčítačce se tímhle detekuje, kdy je potřeba korekce (+6).

---

### Jak s katalogem pracovat

1. **Vyber si typ, vezmi papír a vyřeš ho sám** — tabulka, K-mapa, minimalizace, schéma.
2. **Teprve pak porovnej** s výsledkem výš.
3. Když se rozejdeš, zkontroluj na [32x8](http://www.32x8.com/) — ukáže i postup Quine-McCluskey.

**Tři situace, které musíš poznat rychle**, protože ti ušetří půl hodiny hledání neexistujících skupin:

| Poznávací znak v K-mapě | Co to je | Co s tím |
|---|---|---|
| **izolované jedničky** bez sousedů | dekodér, dělitelnost | minimalizace **nic neubere** — řekni to a jdi dál |
| **šachovnice** | parita, XOR funkce | přepiš na **XOR**, ne na SoP |
| **všechny kombinace $k$ z $n$** | majorita | napiš z kombinatoriky, K-mapa netřeba |

---

### Co si nacvičit

- [ ] Ukázková úloha z PDF (dekodér 3→8) — **hlavně umět vysvětlit, proč minimalizace nic neubere**
- [ ] [Příklad 1](#příklad-1--majoritní-funkce-rozcvička-15-min) — majoritní funkce, všechny body
- [ ] [Příklad 2](#příklad-2--segment-a-sedmisegmentovky-plná-úloha-35-min) — sedmisegmentovka s don't care
- [ ] **Zpaměti: Grayovo pořadí** 00, 01, 11, 10 — a proč není binární
- [ ] **Zpaměti: pravidla slučování** (mocniny dvou, obdélníky, přes okraje, rohy)
- [ ] **Zpaměti: pravdivostní tabulka všech hradel** včetně XOR a XNOR
- [ ] Quine-McCluskey ručně na funkci se 4 proměnnými
- [ ] Převod SoP na samá NAND (De Morgan)
- [ ] Realizace funkce multiplexorem — datové vstupy přímo z tabulky
- [ ] Rozdíl společná katoda / anoda a k čemu je předřadný rezistor
- [ ] Nakreslit schéma z rovnice a zpátky rovnici ze schématu

---

### Poznámky

<!-- Sem vlastní výpisky, mapy, schémata. -->

---

### Na co se doptají

- **Proč je v Karnaughově mapě Grayovo pořadí a ne binární?** — Aby se **sousední políčka lišila v jediném bitu**. Při binárním pořadí by sousedily `01` a `10`, které se liší ve dvou bitech, a nešly by sloučit. Grayovo pořadí zajistí, že sloučení dvou sousedů vždy vypustí právě jednu proměnnou.
- **Co jsou don't care stavy a jak ti pomůžou?** — Kombinace, které nikdy nenastanou (u BCD kódy 10–15). Můžeš je brát **jako 1, když ti to zvětší skupinu**, a jako 0 jinak — a nemusíš být konzistentní. U segmentu `a` to zkrátí výraz ze šesti členů na čtyři.
- **Převeď svou funkci na samá NAND hradla.** — Mechanicky: schéma AND–OR se převede na NAND–NAND. Funguje to díky De Morganovi, $AB + CD = ((AB)' \cdot (CD)')'$ — dvojité negace se vyruší. Vstupy ani topologie se nemění.
- **Jak realizuješ libovolnou funkci 3 proměnných jedním multiplexorem 8:1?** — Proměnné na **adresní vstupy**, a na **datové vstupy přivedu přímo sloupec výstupu z pravdivostní tabulky** (0 nebo 1). Minimalizace vůbec není potřeba — tabulka *je* zapojení.
- **Proč u dekodéru minimalizace nic neubere?** — Každý výstup je **definičně jediný minterm**, tedy v mapě izolovaná jednička bez sousedů. Nemá se s čím sloučit. Jediná úspora je sdílení tří invertorů pro negované vstupy.
- **Jaký je rozdíl mezi dekodérem a demultiplexorem?** — Funkčně **žádný** — dekodér s povolovacím (enable) vstupem *je* demultiplexor. Rozdíl je v použití: dekodér vybírá, demultiplexor rozvádí datový signál na jeden z výstupů.
- **Kolik literálů má skupina o velikosti 4 ve mapě se 4 proměnnými?** — $n - k$, kde $2^k$ je velikost skupiny. Tedy $4 - 2 = 2$ literály. Každé zdvojnásobení skupiny ubere jednu proměnnou.
- **Můžou být skupiny v Karnaughově mapě velikosti 3?** — **Ne**, jen mocniny dvou (1, 2, 4, 8, 16). Skupina o třech políčkách by neodpovídala žádnému součinu.
- **Je minimální forma jediná?** — **Ne.** U funkce $\sum m(0,1,2,5,6,7)$ jsou dvě různá minimální řešení se stejným počtem členů i literálů. Když ti vyjde jiný výraz než v řešení, ověř počet členů — může být rovnocenný.
- **Co je úplný systém spojek a proč je NAND úplný?** — Systém, kterým lze vyjádřit každou logickou funkci. NAND je úplný, protože z něj postavíš NOT ($A \uparrow A$), AND a OR. Teorie v [SZZTP okruh 10](../../SZZTP/10-logika-mnoziny-relace/).
- **Rozdíl mezi společnou katodou a anodou u displeje?** — U společné katody jsou katody na zemi a segment svítí **jedničkou**. U společné anody naopak — svítí **nulou**, takže budicí obvod musí být negovaný.
- **Proč má každý segment vlastní předřadný rezistor?** — Aby jasnost nezávisela na počtu svítících segmentů. Jeden společný rezistor by při osmičce (7 segmentů) dal každé LED méně proudu než při jedničce (2 segmenty).
- **Kdy použít PoS místo SoP?** — Když je v tabulce **méně nul než jedniček** — pak je součin součtů kratší.
- **Co dělá XOR a k čemu je?** — 1 při **nepárném počtu jedniček**. Používá se na paritu, poloviční sčítačku (součet bez přenosu) a jako řízená negace ($A \oplus 1 = A'$).

---

### Užitečné odkazy

#### Kde si to procvičit

| Zdroj | K čemu | Jazyk |
|---|---|---|
| **[32x8 Karnaugh Map Solver](http://www.32x8.com/)** | **Nejužitečnější na kontrolu.** Zadáš mintermy (i don't care) pro 2–8 proměnných a vypíše minimalizovaný výraz — **navíc ukáže postup Quine-McCluskey**. Spočítej si úlohu rukou a ověř si ji tady. | EN |
| [Charlie Coleman K-map Solver](https://www.charlie-coleman.com/experiments/kmap/) | vizuální Karnaughova mapa — klikáš do políček a vidíš, jak se tvoří skupiny | EN |
| **[CircuitVerse](https://circuitverse.org/simulator)** | postav schéma z hradel a odsimuluj. Má hotové dekodéry, multiplexory i sedmisegmentovku. | EN |
| [simulator.io](https://simulator.io/) | jednodušší simulátor logických obvodů, rychlý start | EN |
| [Logic.ly (demo)](https://logic.ly/demo/) | přehledné kreslení hradel, dobré na ověření schématu | EN |
| [Karnaughova mapa (Wikipedie)](https://cs.wikipedia.org/wiki/Karnaughova_mapa) | připomenutí pravidel slučování česky | CZ |

**Jak na procvičení:** vezmi libovolnou funkci (třeba „výstup je 1, když jsou aspoň dva ze čtyř vstupů v 1"), sestav pravdivostní tabulku, zminimalizuj **rukou** Karnaughovou mapou — a teprve pak zkontroluj na 32x8. Nástroj ti navíc ukáže Quine-McCluskey postup, takže si ověříš obě metody naráz.

**Pozor:** 32x8 očekává mintermy jako čísla oddělená čárkou a proměnné značí od `A` (nejvyšší bit). Ověř si, že máš stejné pořadí bitů jako ve svém zadání.

#### Související okruhy

- Analogová část elektroniky: [okruh 6](../06-elektronika-analogova/)
- Výrokový počet a úplné systémy spojek: [SZZTP okruh 10](../../SZZTP/10-logika-mnoziny-relace/)
