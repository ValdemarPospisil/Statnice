## 6 — Základy elektroniky: analogová část

- [Zadání okruhu (PDF)](../ZadaniOkruhu/ZEL-2okruhy.pdf)

> Zadaný obvod se zdroji napětí a rezistory. Spočítat **proudy ve všech větvích** postupně několika metodami. 60 minut přípravy, pak 20 minut obhajoby. K řešení soustav lze použít Python nebo R.

**Tohle je jediný okruh SZZPP, kde se počítá rukou pod časovým tlakem.** Podle [PLAN.md](../../PLAN.md) je to nejnáročnější jednotlivá úloha celé zkoušky — ne proto, že by byla teoreticky těžká, ale protože šest metod na jeden obvod je hodně psaní.

> **Dobrá zpráva o rozsahu:** podle spolužáka, který zkoušku už složil, **nebude obvod tak složitý jako ukázka v PDF** — konkrétně **horní větev s `R6` a `U6` tam nebude**. To je zásadní zjednodušení, viz [rozbor níž](#rozbor-ukázkové-úlohy). Zbyde obvod se **dvěma smyčkami**, který se rukou zvládne.
>
> Ber to jako pravděpodobný, ne jistý rozsah — postup níž funguje na obojí, jen u plné verze je o jednu rovnici víc.

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn, pak výklad s dosazenými čísly. -->

#### Souhrn na jednom místě

| Metoda | Co sestavuje | Kolik neznámých | Kdy je nejvýhodnější |
|---|---|---|---|
| **Kirchhoff (1. + 2. zákon)** | rovnice pro uzly a smyčky | počet větví | vždycky funguje, nejvíc psaní |
| **Smyčkové proudy** | rovnice pro nezávislé smyčky | počet smyček | **málo smyček, hodně uzlů** |
| **Uzlová napětí** | rovnice pro uzly | počet uzlů − 1 | **málo uzlů, hodně větví** |
| **Superpozice** | dílčí úlohy, každá s jedním zdrojem | — | málo zdrojů, ověření výsledku |
| **Thévenin** | náhrada zdrojem napětí $U_{th}$ a $R_{th}$ | 1 | proud **jedním** rezistorem |
| **Norton** | náhrada zdrojem proudu $I_{sc}$ a $R_n$ | 1 | proud **jedním** rezistorem |

**Nejdůležitější rozhodnutí na začátku:** porovnej **počet nezávislých smyček** a **počet uzlů minus jeden**. Menší číslo vyhrává.

**U zkouškového obvodu vyhrávají uzlová napětí — a to výrazně.** Pozor na to, co je vlastně uzel: místo, kde se stýkají **aspoň tři** vodiče. V obvodu bez `R6`/`U6` jsou uzly jen **dva** (bod nad `R3` a zem), takže po volbě referenčního zbývá **jediná neznámá**. Smyčkové proudy by daly dvě. Body A a C uzly **nejsou** — stýkají se v nich jen dva prvky.

#### Základní pojmy

| Pojem | Definice | Jednotka |
|---|---|---|
| **Napětí** $U$ | rozdíl potenciálů mezi dvěma body | volt (V) |
| **Proud** $I$ | tok náboje větví | ampér (A) |
| **Rezistor** $R$ | prvek s odporem, na kterém vzniká úbytek napětí | ohm (Ω) |
| **Uzel** | místo, kde se stýkají **aspoň tři** vodiče | — |
| **Větev** | úsek mezi dvěma uzly (teče jí **jeden** proud) | — |
| **Smyčka** | uzavřená cesta obvodem | — |

**Ohmův zákon** je základ všeho: $U = R \cdot I$, tedy $I = U/R$ a $R = U/I$.

**Konkrétně:** na rezistoru 50 Ω teče proud 0,2 A → úbytek napětí je $50 \cdot 0{,}2 = 10$ V.

**Sériové a paralelní spojení** — bez tohohle se neobejdeš u Thévenina:

$$R_{s} = R_1 + R_2, \qquad R_{p} = \frac{R_1 R_2}{R_1 + R_2}$$

**Konkrétně:** 30 Ω a 60 Ω sériově dá 90 Ω. Paralelně $\frac{30 \cdot 60}{90} = 20$ Ω. Paralelní kombinace je **vždy menší než menší z obou** — to je rychlá kontrola.

Zkratka pro paralelní: $R_1 \parallel R_2$.

#### 1. Kirchhoffův zákon (proudový, KCL)

**Součet proudů vtékajících do uzlu je rovný součtu vytékajících.** Ekvivalentně: se znaménky je součet nulový.

$$\sum I = 0$$

Fyzikálně: náboj se v uzlu nehromadí — co přiteče, to odteče.

**Konkrétně:** do uzlu tečou 0,165 A a 0,093 A, vytéká jeden proud. Ten musí být $0{,}165 + 0{,}093 = 0{,}258$ A.

**Kolik dá nezávislých rovnic:** pro obvod s $u$ uzly je to $u - 1$. Poslední rovnice je vždy lineární kombinací předchozích, takže je zbytečná. **Tohle je oblíbená doptávka.**

#### 2. Kirchhoffův zákon (napěťový, KVL)

**Součet napětí po uzavřené smyčce je nulový.**

$$\sum U = 0$$

Prakticky: součet zdrojů ve smyčce = součet úbytků na rezistorech.

**Konkrétně:** ve smyčce je zdroj 22 V, rezistory 20 Ω a 35 Ω a teče 0,4 A. Pak $22 = 20 \cdot 0{,}4 + 35 \cdot 0{,}4 = 8 + 14 = 22$. Sedí.

**Kolik dá nezávislých rovnic:** pro obvod s $v$ větvemi a $u$ uzly je to $v - u + 1$ (počet nezávislých smyček). Dohromady s KCL: $(u-1) + (v-u+1) = v$ rovnic pro $v$ neznámých proudů. **Přesně tolik, kolik potřebuješ.**

**Znaménková konvence — tady se dělá nejvíc chyb:**

1. Zvol **orientaci proudů** v každé větvi (šipky) — libovolně, ale **pak už je neměň**.
2. Zvol **směr obíhání smyčky** (třeba po směru hodin).
3. Úbytek na rezistoru: **plus**, když proud teče ve směru obíhání, **minus** když proti.
4. Zdroj: **plus**, když se obíhá od minusu k plusu (proti napětí ho ženeš), jinak minus.

**Vyjde-li proud záporný, není to chyba** — znamená to jen, že teče proti tvé zvolené šipce. Velikost je správná. Tohle řekni nahlas, když se komise zeptá.

#### Metoda smyčkových proudů

**Idea:** místo proudů ve větvích zavedeš **fiktivní proudy obíhající po smyčkách**. Proud ve větvi je pak součtem (nebo rozdílem) smyčkových proudů, které jí procházejí.

**Výhoda:** neznámých je jen počet smyček, a KCL je splněný automaticky (smyčkový proud vteče a vyteče).

**Jak sestavit rovnici pro smyčku:**

$$(\text{součet R ve smyčce}) \cdot I_{\text{vlastní}} \pm (\text{společné R}) \cdot I_{\text{sousední}} = \sum U$$

Znaménko u společného rezistoru: **plus**, když oba smyčkové proudy tečou společnou větví **stejným směrem**, minus když proti sobě.

**Konkrétně** (zkouškový obvod, dvě smyčky, společný `R3` = 50 Ω, proudy tečou přes `R3` stejným směrem — dolů):

$$(R_1 + R_2 + R_3) I_a + R_3 I_b = U_1$$
$$R_3 I_a + (R_3 + R_4 + R_5) I_b = U_5$$

Dosazeno: $(20+35+50) I_a + 50 I_b = 22$ a $50 I_a + (50+60+70) I_b = 25$, tedy

$$105 I_a + 50 I_b = 22, \qquad 50 I_a + 180 I_b = 25$$

Vyřešeno: $I_a = 0{,}1652$ A, $I_b = 0{,}0930$ A. Proud přes `R3` je $I_a + I_b = 0{,}2582$ A.

#### Metoda uzlových napětí

**Idea:** neznámé jsou **potenciály uzlů** vůči zvolenému referenčnímu uzlu (zemi). Proudy se pak dopočítají z Ohmova zákona.

**Postup:**

1. Zvol **referenční uzel** (zem) — nejlépe ten, kde se stýká nejvíc větví, obvykle dolní vodič.
2. Pro každý zbývající uzel napiš KCL, kde každý proud vyjádříš jako $\frac{U_{\text{odkud}} - U_{\text{kam}}}{R}$.
3. Vyřeš soustavu.

**Konkrétně** pro uzel, ze kterého vedou tři větve — na zem přes `R3` = 50 Ω, k uzlu A přes `R2` = 35 Ω, k uzlu C přes `R4` = 60 Ω:

$$\frac{U_B - U_A}{35} + \frac{U_B}{50} + \frac{U_B - U_C}{60} = 0$$

Po vynásobení a seskupení dostaneš tvar, kde u $U_B$ stojí **součet převrácených hodnot všech rezistorů u toho uzlu** a u sousedů jejich převrácené hodnoty se znaménkem minus.

**Zkratka pro sestavení matice** (šetří čas a chyby):

- **na diagonále:** součet vodivostí $1/R$ všech rezistorů připojených k danému uzlu
- **mimo diagonálu:** $-1/R$ rezistoru mezi dvěma uzly
- **pravá strana:** proudy vtékající ze zdrojů, tedy $U_{\text{zdroje}}/R$

#### Nejdřív najdi skutečné uzly — jinak si přidáš práci

**Uzel je místo, kde se stýkají aspoň tři vodiče.** Tohle si ověř dřív, než začneš psát rovnice, protože to určuje, kolik jich bude.

Ve zkouškovém obvodu (bez `R6`/`U6`):

| Bod | Co se tam stýká | Uzel? |
|---|---|---|
| A | `R1` a `R2` | **ne** — jen dva prvky |
| B (nad `R3`) | `R2`, `R3`, `R4` | **ano** |
| C | `R4` a `R5` | **ne** — jen dva prvky |
| zem (dolní vodič) | `R1`/`U1`, `R3`, `R5`/`U5` | **ano** |

**Jsou tedy jen dva uzly: B a zem.** Zem zvolíš referenční, takže zbývá **jediná neznámá $U_B$** — jedna rovnice, žádný determinant.

Protože A a C nejsou uzly, jsou `R1` s `R2` prostě **v sérii v jedné větvi** (a stejně tak `R4` s `R5`):

$$R_{\text{levá}} = R_1 + R_2 = 20 + 35 = 55\ \Omega, \qquad R_{\text{pravá}} = R_4 + R_5 = 60 + 70 = 130\ \Omega$$

#### Sestavení a řešení

KCL v uzlu B — tři větve, každý proud jako $(U_B - \text{soused})/R$:

$$\frac{U_B - U_1}{55} + \frac{U_B}{50} + \frac{U_B - U_5}{130} = 0$$

Přeskládáno na tvar „vodivosti krát neznámá = proudy ze zdrojů":

$$U_B \left(\frac{1}{55} + \frac{1}{50} + \frac{1}{130}\right) = \frac{U_1}{55} + \frac{U_5}{130}$$

$$U_B \cdot (0{,}018182 + 0{,}020000 + 0{,}007692) = 0{,}400000 + 0{,}192308$$

$$U_B \cdot 0{,}045874 = 0{,}592308 \;\Longrightarrow\; U_B = 12{,}912\ \text{V}$$

Proudy z Ohmova zákona, vždy jako **(odkud − kam) / R**:

$$I_1 = I_2 = \frac{U_1 - U_B}{R_1 + R_2} = \frac{22 - 12{,}912}{55} = 0{,}1652\ \text{A}$$
$$I_3 = \frac{U_B}{R_3} = \frac{12{,}912}{50} = 0{,}2582\ \text{A}$$
$$I_4 = I_5 = \frac{U_5 - U_B}{R_4 + R_5} = \frac{25 - 12{,}912}{130} = 0{,}0930\ \text{A}$$

**Kontrola KCL:** $0{,}1652 + 0{,}0930 = 0{,}2582$ ✓

Rovnou je vidět, **proč** $I_1 = I_2$ a $I_4 = I_5$ — jsou to tytéž větve, ne dvě různé.

**Pozor na dvě věci, kde se chybuje:**

- $U_B$ **není** napětí na `R3` ani na žádném jiném rezistoru — je to **potenciál bodu B vůči zemi**. Napětí na rezistoru je vždy **rozdíl** potenciálů jeho konců. (Tady náhodou platí, že napětí na `R3` je taky 12,912 V, protože jeho druhý konec je na zemi, kde je potenciál nula.)
- Proud větví se zdrojem **není** $U_1/(R_1+R_2)$, ale $(U_1 - U_B)/(R_1+R_2)$. Zdroj tlačí 22 V, bod B je na 12,912 V, takže na větvi zbývá 9,088 V úbytku.

**Kdybys A a C zavedl jako uzly** (což se snadno stane, když se na ně podíváš jako na „místa, kde je něco připojené"), dostaneš soustavu 3×3. Vyjde správně — přebytečné rovnice si průchozí body dopočítají — ale je to **trojnásobek práce**. U zkoušky to poznáš tak, že $U_A$ a $U_C$ nikde nepotřebuješ.

#### Metoda superpozice

**Idea:** v lineárním obvodu je výsledný proud **součtem proudů od jednotlivých zdrojů**.

**Postup:** nechej působit jeden zdroj, ostatní „vypni":

| Zdroj | Jak vypnout | Proč |
|---|---|---|
| **napěťový** | nahradit **zkratem** | jeho napětí je 0 V, a to je právě zkrat |
| **proudový** | nahradit **rozpojením** | jeho proud je 0 A, a to je rozpojený obvod |

**Tohle je oblíbená doptávka a logika je jednoduchá:** vypnutý napěťový zdroj má nulové napětí mezi svými vývody = drát. Vypnutý proudový zdroj vede nulový proud = přerušení.

**Konkrétně** (zkouškový obvod, dva zdroje):

| Proud | Jen od $U_1$ | Jen od $U_5$ | Součet |
|---|---|---|---|
| $I_1$ | 0,2415 A | −0,0762 A | **0,1652 A** |
| $I_3$ | 0,1744 A | 0,0838 A | **0,2582 A** |
| $I_5$ | −0,0671 A | 0,1601 A | **0,0930 A** |

Sedí s ostatními metodami. **Všimni si záporných dílčích proudů** — jeden zdroj sám by v té větvi tlačil proud opačně, ale výsledný součet je kladný.

**Pozor:** superpozice funguje **jen pro proudy a napětí**, ne pro výkon. Výkon je kvadratický ($P = RI^2$), takže se sečíst nedá.

#### Théveninova poučka

**Idea:** jakoukoli lineární část obvodu lze z pohledu jednoho rezistoru nahradit **zdrojem napětí $U_{th}$ v sérii s odporem $R_{th}$**.

**Postup pro proud rezistorem $R_x$:**

1. **Odpoj $R_x$.**
2. **$U_{th}$** = napětí naprázdno mezi uvolněnými body (žádný proud tam neteče!).
3. **$R_{th}$** = odpor mezi těmi body, když **všechny zdroje nahradíš zkratem** (napěťové) nebo rozpojením (proudové).
4. **$I_x = \dfrac{U_{th}}{R_{th} + R_x}$**

**Konkrétně** — proud přes `R2` = 35 Ω ve zkouškovém obvodu:

Po odpojení `R2` se obvod rozpadne na dvě nezávislé části:

- **Levá:** `R1` + `U1` naprázdno → neteče proud → $U_A = U_1 = 22$ V
- **Pravá:** `U5` tlačí proud přes `R5` + `R4` + `R3` sériově: $I = \frac{25}{70+60+50} = \frac{25}{180} = 0{,}1389$ A, tedy $U_B = 0{,}1389 \cdot 50 = 6{,}944$ V

$$U_{th} = 22 - 6{,}944 = 15{,}056 \text{ V}$$

$R_{th}$ se zkratovanými zdroji: z bodu A vede `R1` na zem, z bodu B vede `R3` na zem a paralelně `R4`+`R5` na zem:

$$R_{th} = R_1 + \bigl(R_3 \parallel (R_4 + R_5)\bigr) = 20 + \frac{50 \cdot 130}{180} = 20 + 36{,}11 = 56{,}11\ \Omega$$

$$I_2 = \frac{15{,}056}{56{,}11 + 35} = \frac{15{,}056}{91{,}11} = 0{,}1652 \text{ A}$$

**Sedí s předchozími metodami** — to je ta kontrola, kterou u zkoušky uděláš.

#### Nortonova poučka

**Idea:** totéž, ale náhrada je **zdroj proudu $I_{sc}$ paralelně s odporem $R_n$**.

**Postup pro proud rezistorem $R_x$:**

1. **Odpoj $R_x$.**
2. **$I_{sc}$** = proud **zkratem** mezi uvolněnými body.
3. **$R_n = R_{th}$** — počítá se úplně stejně.
4. **$I_x = I_{sc} \cdot \dfrac{R_n}{R_n + R_x}$** (dělič proudu)

**Konkrétně** — proud přes `R3` = 50 Ω:

Po odpojení `R3` a **zkratování** bodu B na zem tečou dva nezávislé proudy:

$$I_{sc} = \frac{U_1}{R_1 + R_2} + \frac{U_5}{R_4 + R_5} = \frac{22}{55} + \frac{25}{130} = 0{,}4 + 0{,}1923 = 0{,}5923 \text{ A}$$

$R_n$ se zkratovanými zdroji — mezi B a zemí jsou paralelně dvě cesty:

$$R_n = (R_1 + R_2) \parallel (R_4 + R_5) = \frac{55 \cdot 130}{185} = 38{,}65\ \Omega$$

$$I_3 = 0{,}5923 \cdot \frac{38{,}65}{38{,}65 + 50} = 0{,}5923 \cdot 0{,}4361 = 0{,}2582 \text{ A}$$

**Sedí.** Všimni si, že $R_n$ tady vyšlo jinak než $R_{th}$ v předchozím příkladu — protože se počítá **z jiných dvou bodů** (B–zem vs. A–B).

**Převod Thévenin ↔ Norton** (častá doptávka):

$$U_{th} = I_{sc} \cdot R_n, \qquad I_{sc} = \frac{U_{th}}{R_{th}}, \qquad R_{th} = R_n$$

**Kontrola:** $0{,}5923 \cdot 38{,}65 = 22{,}89$ V — to je Théveninovo napětí pro body B–zem.

---

### Postup u zkoušky (60 min přípravy)

<!-- Časový rozpočet. Papír a tužka, případně Python na soustavy. -->

**0–5 min — příprava obvodu (nepřeskakovat!)**

1. **Překreslit obvod velký a čitelně.** Máš na to místo, využij ho.
2. **Očíslovat uzly** (A, B, C, zem) a **označit větve**.
3. **Zakreslit orientace proudů** šipkami — libovolně, ale **pak už je neměnit**.
4. **Spočítat:** kolik uzlů, kolik větví, kolik nezávislých smyček ($v - u + 1$).

Tyhle čtyři kroky ti zaberou pět minut a **ušetří půl hodiny hledání znaménkových chyb**.

**5–20 min — Kirchhoff**

5. KCL pro $u-1$ uzlů, KVL pro $v-u+1$ smyček.
6. Soustavu vyřeš — **rukou u dvou rovnic, Pythonem u tří a víc**.

**20–30 min — smyčkové proudy**

7. Zvol nezávislé smyčky, sestav matici podle vzorce (součet R na diagonále, společné R mimo).
8. Proudy ve větvích dopočítej jako součty smyčkových.

**30–40 min — uzlová napětí**

9. Zvol zem, sestav matici vodivostí, vyřeš, dopočítej proudy z Ohmova zákona.

**40–48 min — superpozice**

10. Dvakrát (nebo kolik je zdrojů) tentýž obvod s jedním zdrojem, ostatní zkratované. Sečti.

**48–58 min — Thévenin a Norton**

11. Podle zadání pro konkrétní rezistory. Odpojit, $U_{th}$ / $I_{sc}$, $R_{th}$, dopočítat.

**58–60 min — kontrola**

12. **Porovnej výsledky ze všech metod** — musí být stejné. Pokud ne, máš znaménkovou chybu.
13. **Energetická bilance:** $\sum U_{\text{zdroje}} I = \sum R I^2$. Když sedí, je řešení skoro jistě správné.

**Kdyby čas nestačil:** vyřeš to jednou metodou poctivě a u ostatních **popiš postup** („smyčkovými proudy bych sestavil tuhle matici…"). Lepší než šest rozdělaných výpočtů.

#### Kontrola v Pythonu

Zadání povoluje software na soustavy. Tohle si nacvič, ať to nemusíš vymýšlet u zkoušky:

```python
import numpy as np

# metoda uzlových napětí: matice vodivostí
R1, R2, R3, R4, R5 = 20, 35, 50, 60, 70
U1, U5 = 22, 25

A = np.array([
    [1/R1 + 1/R2,      -1/R2,             0        ],
    [-1/R2,       1/R2 + 1/R3 + 1/R4,   -1/R4      ],
    [0,                -1/R4,       1/R4 + 1/R5    ],
])
b = np.array([U1/R1, 0.0, U5/R5])

UA, UB, UC = np.linalg.solve(A, b)
print(f"{UA=:.4f} {UB=:.4f} {UC=:.4f}")

I1 = (U1 - UA)/R1;  I2 = (UA - UB)/R2;  I3 = UB/R3
I4 = (UC - UB)/R4;  I5 = (U5 - UC)/R5
print(f"{I1=:.4f} {I2=:.4f} {I3=:.4f} {I4=:.4f} {I5=:.4f}")

# kontroly
print("KCL v B:", round(I2 + I4 - I3, 12))
print("bilance:", U1*I1 + U5*I5, "=", I1**2*R1 + I2**2*R2 + I3**2*R3 + I4**2*R4 + I5**2*R5)
```

Smyčkové proudy jsou ještě kratší:

```python
M = np.array([[R1+R2+R3, R3], [R3, R3+R4+R5]])
Ia, Ib = np.linalg.solve(M, np.array([U1, U5]))
print(f"{Ia=:.4f} {Ib=:.4f}  I3 = {Ia+Ib:.4f}")
```

---

### Rozbor ukázkové úlohy

Zadání dává obvod s **šesti rezistory a třemi zdroji**, ale podle spolužáka bude **horní větev (`R6` a `U6`) chybět**. Rozeberu proto **zjednodušenou verzi**, protože ta je pravděpodobná — a pak řeknu, co se změní v plné.

#### Topologie a co znamená to zjednodušení

Původní obvod (podle schématu v PDF):

```
    +---[R6]---(U6)---+          <- TATO VĚTEV NEBUDE
    |                 |
    A---[R2]---B---[R4]---C
    |          |          |
  [R1]       [R3]       [R5]
    |          |          |
  (U1)         |         (U5)
    |          |          |
    +----------+----------+       <- zem (dolní vodič)
```

**Bez horní větve** dostaneš:

```
    A---[R2]---B---[R4]---C
    |          |          |
  [R1]       [R3]       [R5]
    |          |          |
  (U1)         |         (U5)
    |          |          |
    +----------+----------+       zem
```

**Proč je to zásadně jednodušší:** uzly A a C přestanou být skutečnými uzly — vedou z nich jen **dvě** větve, takže jsou jen průchozí body. Z toho plyne:

$$I_1 = I_2 \qquad \text{a} \qquad I_5 = I_4$$

Zůstane **jediný skutečný uzel (B)** a **dvě nezávislé smyčky**. Neznámé jsou fakticky jen dvě, ne tři — a to se rukou zvládne bez potíží.

Hodnoty: $R_1 = 20$, $R_2 = 35$, $R_3 = 50$, $R_4 = 60$, $R_5 = 70$ Ω, $U_1 = 22$ V, $U_5 = 25$ V.

#### Řešení uzlovým napětím (nejrychlejší cesta — jedna rovnice)

Uzly jsou jen **dva**: bod B nad `R3` a zem. Zem je referenční, takže neznámá je jediná — $U_B$. Protože A a C uzly nejsou, `R1`+`R2` = 55 Ω a `R4`+`R5` = 130 Ω jsou sériové kombinace v jedné větvi.

KCL v B:

$$\frac{U_B - 22}{55} + \frac{U_B}{50} + \frac{U_B - 25}{130} = 0$$

$$U_B \cdot (0{,}018182 + 0{,}020000 + 0{,}007692) = 0{,}400000 + 0{,}192308$$

$$U_B = \frac{0{,}592308}{0{,}045874} = 12{,}912\ \text{V}$$

Odtud proudy:

$$I_1 = I_2 = \frac{22 - 12{,}912}{55} = 0{,}1652\ \text{A} \qquad I_3 = \frac{12{,}912}{50} = 0{,}2582\ \text{A} \qquad I_4 = I_5 = \frac{25 - 12{,}912}{130} = 0{,}0930\ \text{A}$$

#### Kontrola smyčkovými proudy

Dvě smyčky: **levá** (`U1` → `R1` → `R2` → `R3` → zem) a **pravá** (`U5` → `R5` → `R4` → `R3` → zem). Společná větev je `R3` a **oba smyčkové proudy jí tečou dolů**, tedy stejným směrem → znaménko **plus**.

$$105\, I_a + 50\, I_b = 22$$
$$50\, I_a + 180\, I_b = 25$$

Řešení (determinant $105 \cdot 180 - 50^2 = 18900 - 2500 = 16400$):

$$I_a = \frac{22 \cdot 180 - 50 \cdot 25}{16400} = \frac{2710}{16400} = 0{,}1652\ \text{A} = I_1$$

$$I_b = \frac{105 \cdot 25 - 50 \cdot 22}{16400} = \frac{1525}{16400} = 0{,}0930\ \text{A} = I_5$$

$$I_3 = I_a + I_b = 0{,}2582\ \text{A}$$

Sedí — **dvě rovnice místo jedné**, proto je u tohohle obvodu rychlejší uzlové napětí.

#### Výsledky — všechny proudy

| Proud | Větev | Hodnota |
|---|---|---|
| $I_1$ | přes `R1` a `U1` | **0,1652 A** |
| $I_2$ | přes `R2` (A → B) | **0,1652 A** |
| $I_3$ | přes `R3` (B → zem) | **0,2582 A** |
| $I_4$ | přes `R4` (C → B) | **0,0930 A** |
| $I_5$ | přes `R5` a `U5` | **0,0930 A** |

Uzlová napětí: $U_A = 18{,}695$ V, $U_B = 12{,}912$ V, $U_C = 18{,}491$ V.

**Kontroly, které udělej vždycky:**

- **KCL v uzlu B:** $I_2 + I_4 = 0{,}1652 + 0{,}0930 = 0{,}2582 = I_3$ ✓
- **Energetická bilance:** zdroje dodají $22 \cdot 0{,}1652 + 25 \cdot 0{,}0930 = 3{,}635 + 2{,}325 = 5{,}960$ W. Rezistory spotřebují $\sum R I^2 = 5{,}960$ W ✓

#### Thévenin pro `R2`

Odpojením `R2` se obvod rozpadne na dvě samostatné části (viz [výklad výš](#théveninova-poučka)):

$$U_{th} = 22 - 6{,}944 = 15{,}056\ \text{V}, \qquad R_{th} = 20 + 36{,}11 = 56{,}11\ \Omega$$

$$I_2 = \frac{15{,}056}{56{,}11 + 35} = 0{,}1652\ \text{A} \quad \checkmark$$

#### Norton pro `R3`

$$I_{sc} = \frac{22}{55} + \frac{25}{130} = 0{,}5923\ \text{A}, \qquad R_n = 55 \parallel 130 = 38{,}65\ \Omega$$

$$I_3 = 0{,}5923 \cdot \frac{38{,}65}{88{,}65} = 0{,}2582\ \text{A} \quad \checkmark$$

#### Co se změní, kdyby `R6` a `U6` v zadání byly

Nic principiálně — jen **jedna rovnice navíc**:

- A a C se stanou **skutečnými uzly** (tři větve), takže $I_1 \ne I_2$ a $I_5 \ne I_4$
- **tři nezávislé smyčky** místo dvou, nebo **tři uzlová napětí** místo dvou plus průchozí body
- soustava 3×3 → **tam už použij Python**, ruční řešení Cramerovým pravidlem je zdlouhavé a chybové

Postup i vzorce zůstávají identické. Kdyby na to došlo, sestav matici uzlových napětí (nejméně psaní) a nech ji vyřešit `numpy.linalg.solve`.

---

### Příklady na procvičení

Oba mají **ověřené výsledky** — spočítej si je rukou a zkontroluj. Nedívej se na řešení dřív.

#### Příklad 1 — dva zdroje, jeden uzel (rozcvička, ~15 min)

Tři paralelní větve mezi uzlem B a zemí:

```
    B je společný uzel, dolní vodič je zem

    [R1=10Ω]        [R3=30Ω]       [R2=20Ω]
    (U1=12V)           |           (U2=6V)
       |               |               |
       +-------- B ----+---------------+
       |               |               |
       +---------------+---------------+   zem
```

Tedy: zdroj $U_1 = 12$ V s $R_1 = 10$ Ω, zdroj $U_2 = 6$ V s $R_2 = 20$ Ω, a mezi B a zemí čistý rezistor $R_3 = 30$ Ω.

**Spočítej:** $U_B$ a proudy $I_1$, $I_2$, $I_3$. Pak zkontroluj Théveninem pro `R3` a superpozicí.

<details markdown="1">
<summary><strong>Řešení příkladu 1</strong> — až po vlastním výpočtu</summary>

**Uzlová napětí** (jediná rovnice):

$$\frac{U_B - 12}{10} + \frac{U_B - 6}{20} + \frac{U_B}{30} = 0$$

Vynásobíme 60: $6(U_B - 12) + 3(U_B - 6) + 2U_B = 0$, tedy $11 U_B = 72 + 18 = 90$.

$$U_B = \frac{90}{11} = 8{,}1818\ \text{V}$$

Proudy:

$$I_1 = \frac{12 - 8{,}1818}{10} = \frac{21}{55} = \mathbf{0{,}3818\ A}$$
$$I_2 = \frac{6 - 8{,}1818}{20} = -\frac{6}{55} = \mathbf{-0{,}1091\ A}$$
$$I_3 = \frac{8{,}1818}{30} = \frac{3}{11} = \mathbf{0{,}2727\ A}$$

**Záporný $I_2$ je fyzikálně zajímavý:** zdroj $U_2$ (6 V) je slabší než napětí v uzlu (8,18 V), takže proud teče **do** něj — nabíjí se. Není to chyba ve výpočtu.

**Kontroly:**
- KCL: $0{,}3818 + (-0{,}1091) = 0{,}2727$ ✓
- Bilance: $12 \cdot 0{,}3818 + 6 \cdot (-0{,}1091) = 4{,}582 - 0{,}655 = 3{,}927$ W. Rezistory: $0{,}3818^2 \cdot 10 + 0{,}1091^2 \cdot 20 + 0{,}2727^2 \cdot 30 = 1{,}458 + 0{,}238 + 2{,}231 = 3{,}927$ W ✓

**Thévenin pro `R3`** (odpojíme `R3`, zbudou dva zdroje s odpory):

$$U_{th} = \frac{U_1/R_1 + U_2/R_2}{1/R_1 + 1/R_2} = \frac{1{,}2 + 0{,}3}{0{,}1 + 0{,}05} = \frac{1{,}5}{0{,}15} = 10\ \text{V}$$

$$R_{th} = R_1 \parallel R_2 = \frac{10 \cdot 20}{30} = 6{,}667\ \Omega$$

$$I_3 = \frac{10}{6{,}667 + 30} = \frac{10}{36{,}667} = \mathbf{0{,}2727\ A} \quad \checkmark$$

**Superpozice pro $I_3$:**
- jen $U_1$ (zdroj $U_2$ zkratován): $I_3 = 0{,}2182$ A
- jen $U_2$ (zdroj $U_1$ zkratován): $I_3 = 0{,}0545$ A
- součet: $0{,}2182 + 0{,}0545 = \mathbf{0{,}2727}$ A ✓

</details>

#### Příklad 2 — jako zkoušková úloha, jiné hodnoty (~35 min)

**Stejná topologie** jako zjednodušený zkouškový obvod:

```
    A---[R2]---B---[R4]---C
    |          |          |
  [R1]       [R3]       [R5]
    |          |          |
  (U1)         |         (U5)
    |          |          |
    +----------+----------+       zem
```

$R_1 = 10$ Ω, $R_2 = 25$ Ω, $R_3 = 40$ Ω, $R_4 = 50$ Ω, $R_5 = 20$ Ω, $U_1 = 18$ V, $U_5 = 12$ V.

**Spočítej:** všech pět proudů **všemi šesti metodami** jako u zkoušky — Kirchhoff, smyčkové proudy, uzlová napětí, superpozice, Thévenin pro `R2`, Norton pro `R3`. Ověř energetickou bilancí.

Když je málo času, udělej aspoň smyčkové proudy a zkontroluj Théveninem.

<details markdown="1">
<summary><strong>Řešení příkladu 2</strong> — až po vlastním výpočtu</summary>

**Nejdřív si ověř uzly:** stýkají se aspoň tři vodiče jen v bodě nad `R3` (uzel B) a v dolním vodiči (zem). Body A a C uzly nejsou — jsou v nich jen dva prvky, takže `R1` s `R2` a `R4` s `R5` jsou **sériové kombinace v jedné větvi**:

$$R_{\text{levá}} = 10 + 25 = 35\ \Omega, \qquad R_{\text{pravá}} = 50 + 20 = 70\ \Omega$$

Platí tedy $I_1 = I_2$ a $I_4 = I_5$, a neznámé jsou fakticky **tři proudy**: $I_1$, $I_3$, $I_5$ — nebo, u uzlových napětí, **jediné napětí $U_B$**.

#### a) Kirchhoffovy zákony

**KCL v uzlu B** (co přiteče, to odteče):

$$I_1 + I_5 = I_3$$

**KVL levá smyčka** (zdroj $U_1$ → `R1` → `R2` → `R3` → zem):

$$U_1 = R_1 I_1 + R_2 I_1 + R_3 I_3 \;\Rightarrow\; 18 = 35 I_1 + 40 I_3$$

**KVL pravá smyčka** (zdroj $U_5$ → `R5` → `R4` → `R3` → zem):

$$U_5 = R_5 I_5 + R_4 I_5 + R_3 I_3 \;\Rightarrow\; 12 = 70 I_5 + 40 I_3$$

Substitucí $I_3 = I_1 + I_5$ do obou rovnic:

$$18 = 35 I_1 + 40(I_1 + I_5) = 75 I_1 + 40 I_5$$
$$12 = 70 I_5 + 40(I_1 + I_5) = 40 I_1 + 110 I_5$$

To je táž soustava jako u smyčkových proudů — což není náhoda, viz níž.

#### b) Smyčkové proudy

$I_a$ obíhá levou smyčku, $I_b$ pravou, společná větev je `R3` a **oba jí tečou dolů** → znaménko plus:

$$(R_1 + R_2 + R_3) I_a + R_3 I_b = U_1 \;\Rightarrow\; 75 I_a + 40 I_b = 18$$
$$R_3 I_a + (R_3 + R_4 + R_5) I_b = U_5 \;\Rightarrow\; 40 I_a + 110 I_b = 12$$

Determinant: $75 \cdot 110 - 40^2 = 8250 - 1600 = 6650$

$$I_a = \frac{18 \cdot 110 - 40 \cdot 12}{6650} = \frac{1980 - 480}{6650} = \frac{1500}{6650} = \frac{30}{133} = 0{,}2256\ \text{A}$$

$$I_b = \frac{75 \cdot 12 - 40 \cdot 18}{6650} = \frac{900 - 720}{6650} = \frac{180}{6650} = \frac{18}{665} = 0{,}0271\ \text{A}$$

$$I_3 = I_a + I_b = \frac{24}{95} = 0{,}2526\ \text{A}$$

**Proč to vyšlo stejně jako u Kirchhoffa:** smyčkové proudy jsou jen mechanický způsob, jak tu soustavu sestavit — KCL je splněný automaticky tím, že smyčkový proud vteče i vyteče.

#### c) Uzlová napětí — nejrychlejší cesta

Uzly jsou **dva** (B a zem), zem je referenční → **jediná neznámá $U_B$**. KCL v B se sériovými kombinacemi 35 Ω a 70 Ω:

$$\frac{U_B - 18}{35} + \frac{U_B}{40} + \frac{U_B - 12}{70} = 0$$

Přeskládáno:

$$U_B \left(\frac{1}{35} + \frac{1}{40} + \frac{1}{70}\right) = \frac{18}{35} + \frac{12}{70}$$

$$U_B \cdot (0{,}028571 + 0{,}025000 + 0{,}014286) = 0{,}514286 + 0{,}171429$$

$$U_B \cdot 0{,}067857 = 0{,}685714 \;\Longrightarrow\; U_B = \frac{192}{19} = 10{,}105\ \text{V}$$

Proudy (vždy „odkud − kam" děleno R):

$$I_1 = I_2 = \frac{18 - 10{,}105}{35} = 0{,}2256\ \text{A} \qquad I_3 = \frac{10{,}105}{40} = 0{,}2526\ \text{A} \qquad I_4 = I_5 = \frac{12 - 10{,}105}{70} = 0{,}0271\ \text{A}$$

**Jedna rovnice o jedné neznámé** — proti dvěma u smyčkových proudů a třem u Kirchhoffa. Proto u tohohle typu obvodu (dva uzly, dvě smyčky) volíš uzlová napětí.

#### d) Superpozice

**Jen $U_1$** (zdroj $U_5$ nahrazen zkratem — `R5` pak vede z C na zem):

Z pohledu zdroje je to `R1` + `R2` v sérii s paralelní kombinací:

$$R_3 \parallel (R_4 + R_5) = \frac{40 \cdot 70}{110} = 25{,}455\ \Omega$$
$$R_{\text{celk}} = 10 + 25 + 25{,}455 = 60{,}455\ \Omega \;\Rightarrow\; I_1' = \frac{18}{60{,}455} = 0{,}2977\ \text{A}$$

Proud se v uzlu B rozdělí děličem:

$$I_3' = I_1' \cdot \frac{R_4 + R_5}{R_3 + R_4 + R_5} = 0{,}2977 \cdot \frac{70}{110} = 0{,}1895\ \text{A}$$
$$I_5' = -I_1' \cdot \frac{R_3}{R_3 + R_4 + R_5} = -0{,}2977 \cdot \frac{40}{110} = -0{,}1083\ \text{A}$$

$I_5'$ je **záporný**, protože samotný zdroj $U_1$ by tou větví tlačil proud opačně.

**Jen $U_5$** (zdroj $U_1$ zkratován):

$$R_3 \parallel (R_1 + R_2) = \frac{40 \cdot 35}{75} = 18{,}667\ \Omega$$
$$R_{\text{celk}} = 20 + 50 + 18{,}667 = 88{,}667\ \Omega \;\Rightarrow\; I_5'' = \frac{12}{88{,}667} = 0{,}1353\ \text{A}$$
$$I_3'' = 0{,}1353 \cdot \frac{35}{75} = 0{,}0632\ \text{A} \qquad I_1'' = -0{,}1353 \cdot \frac{40}{75} = -0{,}0722\ \text{A}$$

**Součet:**

| Proud | Jen $U_1$ | Jen $U_5$ | Součet |
|---|---|---|---|
| $I_1$ | +0,2977 A | −0,0722 A | **0,2256 A** |
| $I_3$ | +0,1895 A | +0,0632 A | **0,2526 A** |
| $I_5$ | −0,1083 A | +0,1353 A | **0,0271 A** |

Sedí s předchozími metodami.

#### e) Thévenin pro `R2`

Odpojím `R2` → obvod se rozpadne na dvě samostatné části.

**Levá:** `R1` + `U1` naprázdno, neteče proud → $U_A = 18$ V.

**Pravá:** $U_5$ tlačí proud přes `R5` + `R4` + `R3` sériově:

$$I = \frac{12}{20 + 50 + 40} = \frac{12}{110} = 0{,}1091\ \text{A} \;\Rightarrow\; U_B = 0{,}1091 \cdot 40 = 4{,}364\ \text{V}$$

$$U_{th} = 18 - 4{,}364 = 13{,}636\ \text{V}$$

$R_{th}$ se zkratovanými zdroji (z A vede `R1` na zem, z B `R3` na zem a paralelně `R4`+`R5`):

$$R_{th} = R_1 + \bigl(R_3 \parallel (R_4 + R_5)\bigr) = 10 + 25{,}455 = 35{,}455\ \Omega$$

$$I_2 = \frac{U_{th}}{R_{th} + R_2} = \frac{13{,}636}{35{,}455 + 25} = \frac{13{,}636}{60{,}455} = \mathbf{0{,}2256\ A} \quad \checkmark$$

#### f) Norton pro `R3`

Odpojím `R3` a **zkratuju** bod B na zem → tečou dva nezávislé proudy:

$$I_{sc} = \frac{U_1}{R_1 + R_2} + \frac{U_5}{R_4 + R_5} = \frac{18}{35} + \frac{12}{70} = 0{,}5143 + 0{,}1714 = 0{,}6857\ \text{A}$$

$R_n$ mezi B a zemí se zkratovanými zdroji (dvě paralelní cesty):

$$R_n = (R_1 + R_2) \parallel (R_4 + R_5) = \frac{35 \cdot 70}{105} = 23{,}333\ \Omega$$

$$I_3 = I_{sc} \cdot \frac{R_n}{R_n + R_3} = 0{,}6857 \cdot \frac{23{,}333}{63{,}333} = 0{,}6857 \cdot 0{,}3684 = \mathbf{0{,}2526\ A} \quad \checkmark$$

#### Souhrn výsledků

| Proud | Větev | Hodnota |
|---|---|---|
| $I_1 = I_2$ | `R1`,`U1` a `R2` | **0,2256 A** |
| $I_3$ | `R3` | **0,2526 A** |
| $I_4 = I_5$ | `R4` a `R5`,`U5` | **0,0271 A** |

Uzlová napětí: $U_A = 15{,}744$ V, $U_B = 10{,}105$ V, $U_C = 11{,}459$ V.

**Kontroly:**

- **KCL v B:** $0{,}2256 + 0{,}0271 = 0{,}2526$ ✓
- **Energetická bilance:** zdroje dodají $18 \cdot 0{,}2256 + 12 \cdot 0{,}0271 = 4{,}060 + 0{,}325 = 4{,}385$ W.
  Rezistory spotřebují $0{,}509 + 1{,}272 + 2{,}553 + 0{,}037 + 0{,}015 = 4{,}385$ W ✓
- **Všech šest metod dalo tytéž proudy** — to je nejlepší možná kontrola.

</details>

---

### Co si nacvičit

- [ ] Zjednodušený zkouškový obvod (bez `R6`, `U6`) **všemi metodami rukou, na čas**
- [ ] [Příklad 1](#příklad-1--dva-zdroje-jeden-uzel-rozcvička-15-min) — rozcvička na jeden uzel
- [ ] [Příklad 2](#příklad-2--jako-zkoušková-úloha-jiné-hodnoty-35-min) — plná úloha, dvě metody + kontrola
- [ ] **Zpaměti: kolik nezávislých rovnic** dá KCL ($u-1$) a KVL ($v-u+1$)
- [ ] **Zpaměti: jak vypnout zdroj** u superpozice (napěťový → zkrat, proudový → rozpojení)
- [ ] **Zpaměti: vzorec pro paralelní kombinaci** a že výsledek je menší než menší z obou
- [ ] Sestavení matice uzlových napětí přes vodivosti (bez rozepisování rovnic)
- [ ] Převod Thévenin ↔ Norton
- [ ] Energetická bilance jako kontrola — **nacvič si to, je to nejrychlejší způsob, jak odhalit chybu**
- [ ] Kontrolní skript v Pythonu napsat zpaměti (numpy, `linalg.solve`)

---

### Poznámky

<!-- Sem vlastní výpisky, náčrtky, mezivýsledky. -->

---

### Na co se doptají

- **Kolik nezávislých rovnic dostaneš z 1. a kolik z 2. Kirchhoffova zákona?** — KCL dá $u - 1$ (poslední uzlová rovnice je kombinací ostatních), KVL dá $v - u + 1$ (počet nezávislých smyček). Dohromady $v$ rovnic pro $v$ neznámých proudů.
- **Proč se u superpozice napěťový zdroj nahrazuje zkratem a proudový rozpojením?** — Vypnutý napěťový zdroj má mezi vývody 0 V, což je definice zkratu. Vypnutý proudový vede 0 A, což je rozpojený obvod.
- **Jak spočítáš vnitřní odpor náhradního zdroje?** — Odpojím dotyčný rezistor, **všechny zdroje nahradím zkratem** (napěťové) a spočítám odpor mezi uvolněnými body sériově-paralelním zjednodušováním.
- **Zkontroluj si výsledek — sedí energetická bilance?** — Součet výkonů dodaných zdroji ($\sum U I$) musí být rovný součtu spotřebovaných na rezistorech ($\sum R I^2$). U mého řešení 5,960 W na obou stranách.
- **Proč ti vyšel proud záporný?** — Protože teče proti mé zvolené orientaci šipky. Velikost je správná, jen směr je opačný. Fyzikálně to u zdroje znamená, že se **nabíjí** místo vybíjení.
- **Kterou metodu bys zvolil, kdybys měl vybrat jednu?** — Porovnám počet nezávislých smyček a počet uzlů minus jeden; menší číslo vyhrává. U tohohle obvodu jsou **dva uzly** (bod nad `R3` a zem), takže po volbě referenčního zbývá **jediná neznámá** — proti dvěma smyčkovým proudům. Volím tedy **uzlová napětí**: jedna rovnice, žádný determinant.
- **Dá se superpozicí spočítat i výkon?** — **Ne.** Výkon je kvadratický v proudu ($P = RI^2$), takže dílčí výkony se sečíst nedají. Superpozice platí jen pro proudy a napětí.
- **Jaký je vztah mezi Théveninem a Nortonem?** — Jsou to duální náhrady téhož: $U_{th} = I_{sc} R_n$ a $R_{th} = R_n$. Z jedné se druhá dopočítá.
- **Co je uzel a co větev?** — Uzel je místo, kde se stýkají **aspoň tři** vodiče. Větev je úsek mezi dvěma uzly, kterým teče **jeden** proud. Bod, kde se stýkají jen dva prvky, není uzel — proto v našem obvodu nejsou A a C skutečné uzly.
- **Proč jsi zvolil právě tenhle uzel jako referenční?** — Volí se ten s nejvíc připojenými větvemi (obvykle dolní vodič), protože tím se soustava nejvíc zjednoduší. Volba je ale libovolná — výsledné proudy vyjdou stejně.
- **Kdy je paralelní kombinace větší než jeden z rezistorů?** — Nikdy. Je vždy menší než menší z obou. Rychlá kontrola výpočtu.
- **Jak bys řešil obvod s proudovým zdrojem?** — U uzlových napětí je to snadné: proudový zdroj přispěje přímo do pravé strany rovnice. U smyčkových proudů se hůř zpracovává, tam je lepší ho převést Nortonem na napěťový.

---

### Užitečné odkazy

- Digitální část elektroniky: [okruh 7](../07-elektronika-digitalni/)
- Soustavy lineárních rovnic teoreticky: [SZZTP okruh 4](../../SZZTP/04-funkce-polynomy-nelinearni-rovnice/)
