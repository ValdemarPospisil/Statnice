## 9 — Intervaly spolehlivosti

> Intervaly spolehlivosti, jejich význam, interpretace a konstrukce (definice, typy, interpretace spolehlivosti, resp. hladiny významnosti, výpočet [pro střední hodnotu, rozptyl, relativní četnost], vliv rozsahu výběru, využití v praxi)

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. **Populace vs. výběr** — parametr populace ($\mu$, $\sigma^2$, $\pi$) neznám, mám jen výběr $n$ hodnot
2. **Bodový odhad** ($\bar{x}$) a proč nestačí — je to jedno číslo bez informace o tom, jak moc se může mýlit
3. **Interval spolehlivosti** — místo jednoho čísla dám **rozmezí plus spolehlivost**, se kterou ho konstruuji
4. **Spolehlivost $1-\alpha$ a hladina významnosti $\alpha$** — $\alpha$ je riziko, že interval parametr mine
5. **SPRÁVNÁ interpretace:** kdybych výběr opakoval, $95\ \%$ takto sestrojených intervalů by parametr pokrylo — **ne** „parametr v něm leží s pravděpodobností $95\ \%$"
6. **Obecný tvar:** bodový odhad $\pm$ kvantil $\cdot$ střední chyba
7. **IS pro střední hodnotu při známém $\sigma$** — kvantil $u_{1-\alpha/2}$ z $N(0,1)$
8. **IS pro střední hodnotu při neznámém $\sigma$** — **Studentovo $t$** s $n-1$ stupni volnosti; pro velká $n$ splyne s $u$
9. **IS pro relativní četnost** (podíl) — $\hat{p} \pm u_{1-\alpha/2}\sqrt{\hat{p}(1-\hat{p})/n}$, odtud „chyba $\pm 5\ \%$" v předvolebních průzkumech
10. **IS pro rozptyl** — rozdělení $\chi^2$, **nesymetrický** interval
11. **Jednostranné vs. oboustranné** — kdy mě zajímá jen jedna mez
12. **Vliv rozsahu výběru:** šířka klesá s $\frac{1}{\sqrt{n}}$ — poloviční interval stojí **čtyřnásobný** výběr
13. **Vliv $\alpha$** a souvislost s testováním hypotéz; využití v praxi

**Nit, na kterou to navlékni:** interval spolehlivosti je **poctivé přiznání nejistoty**. Změřím-li výběr, dostanu $\bar{x}$ — ale to je jen jedno číslo z náhodného pokusu a příště by vyšlo jinak. Interval spolehlivosti k odhadu **připojí, jak moc se může mýlit**. Všechny čtyři varianty ve zkušebním okruhu jsou přitom **jeden a týž vzorec**: *bodový odhad $\pm$ kvantil $\cdot$ střední chyba*. Liší se jen tím, **z jakého rozdělení ten kvantil beru** — a to se řídí tím, co o populaci vím: znám-li $\sigma$, beru normální rozdělení; neznám-li ho, platím za jeho odhad širším Studentovým $t$; jde-li o rozptyl, mění se i tvar na nesymetrický $\chi^2$. **A šířka intervalu má vždycky $\sqrt{n}$ ve jmenovateli** — proto se přesnost kupuje draho.

---

### Co si napsat na papír (první 3 minuty přípravy)

<!-- Tohle si zapamatuj doslova a při přípravě to hoď na papír. Zbytek se z toho odvodí. -->

Tahák, který si vyrobíš zpaměti hned na začátku přípravy. Napsání zabere zhruba tři minuty, zbylých dvanáct pak máš na rozmyšlení příkladu.

```
POPULACE (parametr neznám)   ---výběr n hodnot--->   ODHAD

  mu    <- x s pruhem (výběrový průměr)
  sigma^2 <- s^2 (výběrový rozptyl, dělí se n-1 !)
  pi (podíl) <- p se stříškou = X/n

INTERVAL SPOLEHLIVOSTI = odhad  ±  kvantil * střední chyba
                                   ------------------------
                                        toto je "chyba odhadu"

spolehlivost 1-alfa  |  hladina významnosti alfa  |  typicky alfa = 0,05

1) STŘEDNÍ HODNOTA, sigma ZNÁM
   x ± u(1-alfa/2) * sigma/odmocnina(n)
   u(0,975) = 1,96      u(0,95) = 1,645     u(0,995) = 2,576

2) STŘEDNÍ HODNOTA, sigma NEZNÁM   <- v praxi skoro vždy
   x ± t(n-1)(1-alfa/2) * s/odmocnina(n)
   t je ŠIRŠÍ než u, pro n nad 30 už je skoro stejné

3) RELATIVNÍ ČETNOST (podíl)
   p ± u(1-alfa/2) * odmocnina( p*(1-p)/n )
   podmínka: n*p > 5  a  n*(1-p) > 5

4) ROZPTYL  (nesymetrický!)
   ( (n-1)*s^2 / chi2(n-1)(1-alfa/2) ;  (n-1)*s^2 / chi2(n-1)(alfa/2) )
   POZOR: velký kvantil je DOLE ve jmenovateli levé meze

INTERPRETACE: opakoval-li bych výběr mnohokrát, 95 % takto sestrojených
              intervalů by pokrylo skutečný parametr
NE: "parametr tam leží s pravděpodobností 95 %"  <- parametr je konstanta

ŠÍŘKA klesá s 1/odmocnina(n)   ->  2x užší interval = 4x větší výběr
ŠÍŘKA roste s alfa klesajícím  ->  vyšší jistota = širší interval
```

#### Jak si z toho odvodit zbytek

- **Čtyři vzorce si nepamatuj jako čtyři.** Všechny jsou *odhad $\pm$ kvantil $\cdot$ střední chyba* (jen rozptyl má jiný tvar, protože jeho rozdělení není symetrické). Když si zapamatuješ tohle schéma, doplníš zbytek podle toho, **co v úloze znáš**.
- **Kdy $u$ a kdy $t$ se rozhodne jedinou otázkou:** *„dostal jsem $\sigma$ populace, nebo jsem si směrodatnou odchylku spočítal z dat?"* Spočítal-li jsem ji z dat, je i ona odhad — a za tu nejistotu navíc se platí širším Studentovým $t$.
- **Proč je ve jmenovateli $\sqrt{n}$**, si odvodíš z okruhu 8: pro průměr $n$ nezávislých veličin platí $D(\bar{X}) = \frac{\sigma^2}{n}$, a směrodatná odchylka je odmocnina, tedy $\frac{\sigma}{\sqrt{n}}$. **Odtud plyne celé pravidlo o rozsahu výběru** — nemusíš si ho pamatovat zvlášť.
- **Kvantil si pamatuj jen jeden:** $1{,}96$ pro $95\ \%$. Ostatní odvodíš logikou — chci-li větší jistotu, musím jít dál do chvostů, takže kvantil **roste**: $1{,}645$ pro $90\ \%$, $2{,}576$ pro $99\ \%$.
- **Proč $1-\frac{\alpha}{2}$ a ne $1-\alpha$:** riziko $\alpha$ se u oboustranného intervalu **rozdělí na dva konce**, do každého $\frac{\alpha}{2}$. Pro $\alpha = 0{,}05$ tedy $2{,}5\ \%$ vlevo a $2{,}5\ \%$ vpravo, a kvantil hledám na úrovni $0{,}975$.

#### Jak si to zapamatovat, aniž bys to biflil

> **Odhad říká „kolik", interval spolehlivosti říká „a jak moc si tím jsem jistý".**

Celá otázka je jedna tabulka — *„co o populaci vím?"*:

| Znám… | Odhaduji | Beru kvantil z | Vzorec |
|---|---|---|---|
| $\sigma$ populace | $\mu$ | $N(0,1)$ — $u$ | $\bar{x} \pm u \frac{\sigma}{\sqrt{n}}$ |
| jen data | $\mu$ | Studentovo $t_{n-1}$ | $\bar{x} \pm t \frac{s}{\sqrt{n}}$ |
| počet úspěchů | $\pi$ | $N(0,1)$ — $u$ | $\hat{p} \pm u \sqrt{\frac{\hat{p}(1-\hat{p})}{n}}$ |
| jen data | $\sigma^2$ | $\chi^2_{n-1}$ | $\frac{(n-1)s^2}{\chi^2_{1-\alpha/2}}$ až $\frac{(n-1)s^2}{\chi^2_{\alpha/2}}$ |

**První tři řádky jsou symetrické** („$\pm$"), poslední ne — a to je jediná výjimka, kterou si musíš zvlášť zapamatovat.

##### Kde to navazuje na ostatní okruhy

| Co tady | Kde to už bylo | Jak to spolu souvisí |
|---|---|---|
| kvantil $u_{1-\alpha/2}$ | kvantily, [okruh 8](../08-nahodna-velicina/) | interval spolehlivosti **je** postavený na kvantilech |
| standardizace $U = \frac{X-\mu}{\sigma}$ | normální rozdělení, [okruh 8](../08-nahodna-velicina/) | odtud se vzorec pro $\mu$ odvodí |
| $D(\bar{X}) = \frac{\sigma^2}{n}$ | vlastnosti rozptylu, [okruh 8](../08-nahodna-velicina/) | důvod, proč je ve jmenovateli $\sqrt{n}$ |
| relativní četnost | binomické rozdělení, [okruh 8](../08-nahodna-velicina/) | podíl je binomická veličina vydělená $n$ |
| $\sqrt{n}$ v jmenovateli | odmocnina jako funkce, [okruh 4](../04-funkce-polynomy-nelinearni-rovnice/) | roste pomalu — proto je přesnost drahá |

---

### Populace, výběr a bodový odhad

#### Proč vůbec něco odhaduji

**Populace** (základní soubor) je celek, který mě zajímá — *všichni* čeští muži, *všechny* vyrobené žárovky, *všichni* voliči. Její skutečné charakteristiky se značí řeckými písmeny a **neznám je**:

| Parametr populace | Značka | Odhad z výběru | Značka |
|---|---|---|---|
| střední hodnota | $\mu$ | výběrový průměr | $\bar{x}$ |
| rozptyl | $\sigma^2$ | výběrový rozptyl | $s^2$ |
| směrodatná odchylka | $\sigma$ | výběrová sm. odchylka | $s$ |
| podíl (relativní četnost) | $\pi$ | výběrový podíl | $\hat{p}$ |

**Výběr** (vzorek) je náhodně vybraná podmnožina populace o rozsahu $n$. Z něj počítám **bodový odhad** — jedno číslo, které parametr nahrazuje.

**Konkrétně:** změřím $25$ mužů, průměr vyjde $\bar{x} = 178$ cm. To je bodový odhad průměrné výšky **všech** českých mužů.

#### Proč bodový odhad nestačí

Protože je to výsledek **náhodného pokusu** — kdybych vybral jiných $25$ mužů, vyšlo by $176$ nebo $181$. Bodový odhad tuhle nejistotu neříká vůbec.

Porovnej dvě sdělení:

```
"Průměrná výška je 178 cm."
        ...jak moc se můžeš mýlit? nevím

"Průměrná výška je 178 cm, interval spolehlivosti 174 až 182 cm."
        ...aha, přesnější než ±4 cm to z těch dat nedostanu
```

Druhé sdělení je **poctivé**. A přesně to interval spolehlivosti dodává.

> **Past:** bodový odhad skoro jistě **není** přesná hodnota parametru. Pravděpodobnost, že $\bar{x}$ trefí $\mu$ přesně, je u spojité veličiny **nulová** — viz [okruh 8](../08-nahodna-velicina/). Proto se odhaduje intervalem, ne bodem.

---

### Definice a interpretace

#### Co to je

**Interval spolehlivosti** pro parametr $\theta$ se spolehlivostí $1-\alpha$ je dvojice mezí $(L, U)$, spočtených z výběru tak, že

$$P(L < \theta < U) = 1 - \alpha$$

**Klíč k pochopení té rovnice:** náhodné jsou **meze $L$ a $U$**, ne parametr $\theta$. Ten je pevná (byť neznámá) konstanta. Interval „skáče" kolem parametru, ne naopak.

#### Spolehlivost a hladina významnosti

| Pojem | Značka | Typicky | Význam |
|---|---|---|---|
| spolehlivost | $1-\alpha$ | $0{,}95$ | podíl intervalů, které parametr pokryjí |
| hladina významnosti | $\alpha$ | $0{,}05$ | riziko, že interval parametr **mine** |

Jsou to dvě strany téže mince: $\alpha = 0{,}05$ znamená spolehlivost $95\ \%$. Pro $99\ \%$ spolehlivost je $\alpha = 0{,}01$.

**Kam se $\alpha$ v grafu rozdělí:**

```
              hustota N(0,1)
                    ╱▔▔╲
                  ╱      ╲
                ╱          ╲
              ╱   95 %      ╲
   ▁▁▁▁▁▁▁▁╱                 ╲▁▁▁▁▁▁▁▁
     2,5 %  │                 │  2,5 %
         -1,96                1,96
        = -u(0,975)         = u(0,975)

   alfa = 0,05 se ROZDĚLÍ na dva konce po alfa/2 = 0,025
```

Proto se v každém vzorci píše kvantil na úrovni $1 - \frac{\alpha}{2}$, tedy $0{,}975$ — ne $0{,}95$.

#### Interpretace — na tohle se zeptají skoro jistě

> **Správně:** „Kdybych výběr mnohokrát opakoval a pokaždé takto sestrojil interval, přibližně $95\ \%$ z nich by skutečný parametr obsahovalo."

> **Špatně:** „Skutečný parametr leží v tomto intervalu s pravděpodobností $95\ \%$."

**Proč je druhá věta chybná:** skutečný parametr je **konstanta**. Buď v mém konkrétním intervalu je, nebo není — pravděpodobnost je tedy $1$, nebo $0$, jen nevím která. Náhodnost je v tom, **jaký interval mi z výběru vyšel**, ne v parametru.

Nakresli k tomu tenhle obrázek, je to nejlepší způsob, jak to vysvětlit:

```
     skutečné mu (neznámé, ale PEVNÉ)
                 │
   výběr 1   ├───┼───┤        ✔ pokryl
   výběr 2  ├───┼──┤          ✔ pokryl
   výběr 3      ├─┼───┤       ✔ pokryl
   výběr 4 ├──┤ │              ✘ MINUL
   výběr 5    ├──┼──┤          ✔ pokryl
   ...          │
                │
   ze 100 takových intervalů jich mine zhruba 5
```

**Řekni k tomu:** svislá čára stojí na místě, pohybují se **intervaly**. Kdybych parametr znal, viděl bych, které mine — ale právě proto, že ho neznám, můžu mluvit jen o tom, jak často metoda funguje.

---

### Obecná konstrukce

Všechny intervaly pro střední hodnotu a podíl mají týž tvar:

$$\text{odhad} \pm \underbrace{k_{1-\alpha/2} \cdot \text{SE}}_{\text{chyba odhadu}}$$

kde $\text{SE}$ (*standard error*, střední chyba odhadu) je směrodatná odchylka toho odhadu.

| Část | Co dělá | Na čem závisí |
|---|---|---|
| odhad | střed intervalu | na datech |
| kvantil $k$ | jak jistý chci být | na $\alpha$ (a na rozdělení) |
| $\text{SE}$ | jak přesný je odhad | na $\sigma$ a hlavně na $n$ |

**Konkrétní dosazení:** mám $n = 25$, $\sigma = 10$, $\bar{x} = 70$, chci $95\ \%$.

$$\text{SE} = \frac{\sigma}{\sqrt{n}} = \frac{10}{\sqrt{25}} = \frac{10}{5} = 2$$

$$\text{chyba odhadu} = 1{,}96 \cdot 2 = 3{,}92$$

$$\text{IS} = 70 \pm 3{,}92 = (66{,}08;\ 73{,}92)$$

**Tři čísla, tři kroky.** Tenhle výpočet umíš do třiceti sekund a projde jím celá otázka.

---

### 1) Interval spolehlivosti pro střední hodnotu při známém $\sigma$

$$\bar{x} \pm u_{1-\alpha/2} \cdot \frac{\sigma}{\sqrt{n}}$$

#### Odkud se vzorec bere

Z **centrální limitní věty** ([okruh 8](../08-nahodna-velicina/)): výběrový průměr $\bar{X}$ má přibližně normální rozdělení se střední hodnotou $\mu$ a rozptylem $\frac{\sigma^2}{n}$. Po standardizaci

$$U = \frac{\bar{X} - \mu}{\sigma/\sqrt{n}} \sim N(0,1)$$

a odtud už jen vyjádřím $\mu$ z nerovnosti $-u_{1-\alpha/2} < U < u_{1-\alpha/2}$.

#### Kvantily, které stojí za zapamatování

| Spolehlivost | $\alpha$ | $u_{1-\alpha/2}$ |
|---|---|---|
| $90\ \%$ | $0{,}10$ | $1{,}645$ |
| $95\ \%$ | $0{,}05$ | $\mathbf{1{,}96}$ |
| $99\ \%$ | $0{,}01$ | $2{,}576$ |

**Zapamatuj si jen $1{,}96$**, zbytek odvodíš: větší jistota $\Rightarrow$ musím jít dál do chvostů $\Rightarrow$ větší kvantil $\Rightarrow$ **širší interval**.

**Konkrétní dosazení** na téže úloze ($\bar{x} = 70$, $\sigma = 10$, $n = 25$, tedy $\text{SE} = 2$):

| Spolehlivost | Výpočet | Interval | Šířka |
|---|---|---|---|
| $90\ \%$ | $70 \pm 1{,}645 \cdot 2$ | $(66{,}71;\ 73{,}29)$ | $6{,}58$ |
| $95\ \%$ | $70 \pm 1{,}96 \cdot 2$ | $(66{,}08;\ 73{,}92)$ | $7{,}84$ |
| $99\ \%$ | $70 \pm 2{,}576 \cdot 2$ | $(64{,}85;\ 75{,}15)$ | $10{,}30$ |

**Vidíš ten obchod:** za jistotu se platí šířkou. Chci-li mít pravdu v $99$ případech ze $100$ místo $95$, musím připustit o třetinu širší rozmezí. **Stoprocentní jistota by znamenala interval od $-\infty$ do $+\infty$** — a to je informace nulové hodnoty.

---

### 2) Interval spolehlivosti pro střední hodnotu při neznámém $\sigma$

$$\bar{x} \pm t_{n-1}\left(1-\tfrac{\alpha}{2}\right) \cdot \frac{s}{\sqrt{n}}$$

**Tohle je varianta, která se používá v praxi**, protože skutečnou $\sigma$ populace člověk skoro nikdy nezná. Nahradí ji výběrovou směrodatnou odchylkou $s$ — jenže **to je taky jen odhad**, a za tu nejistotu navíc se platí širším kvantilem.

#### Není to vlastně jedno, když v obou případech potřebuji nějaké $\sigma$?

Napadne to skoro každého a je to dobrá otázka. **Míru rozptýlení potřebuješ tak jako tak** — bez ní nevíš, jak přesný odhad je. Rozdíl **není v tom, že bys ji jednou měl a podruhé ne**, ale **odkud ji máš**:

| | $\sigma$ (varianta 1) | $s$ (varianta 2) |
|---|---|---|
| **odkud** | zvenčí — norma, dlouhodobé měření, zadání | **spočítal jsem si ji z týchž dat** |
| **jak přesná** | přesná, je to fakt o populaci | sama je **odhad**, taky se mýlí |
| **při jiném výběru** | stejná | **jiná** |
| **kvantil** | $u$ z $N(0,1)$ | širší $t_{n-1}$ |

**Konkrétně:** kdybych svých $25$ odezev serveru změřil znovu, `σ = 10` by zůstalo `10` (je to vlastnost serveru), ale `s` by vyšlo třeba `9,4` nebo `11,2`. **Do vzorce tedy dosazuji číslo, které samo poskakuje** — a Studentovo $t$ tuhle nejistotu navíc započítá tím, že je širší.

**Takže máš pravdu v tom, že prakticky je to skoro jedno** — a pro $n > 30$ dokonce doslova, protože $t$ a $u$ už jsou skoro totožné. **Rozdíl je citelný jen u malých výběrů**, kde je $s$ spočítané z pár hodnot opravdu nespolehlivé. Právě proto se u velkých vzorků běžně používá $u$ i tam, kde by formálně patřilo $t$.

#### Výběrový rozptyl a proč $n-1$

$$s^2 = \frac{1}{n-1}\sum_{i=1}^{n}(x_i - \bar{x})^2$$

Dělí se $n-1$, ne $n$. **Důvod:** odchylky měřím od $\bar{x}$, tedy od čísla spočítaného z týchž dat — a od svého vlastního průměru jsou data vždycky blíž než od skutečného $\mu$. Rozptyl by tak vycházel systematicky **menší**. Dělení menším číslem to vyrovná.

**Ukázka na dvou hodnotách $4$ a $6$:** $\bar{x} = 5$, součet čtverců $= 1 + 1 = 2$. Dělením $n = 2$ vyjde $1$, dělením $n-1 = 1$ vyjde $2$. Druhé číslo je nestranné.

#### Studentovo $t$-rozdělení

Vypadá jako normální rozdělení, ale má **těžší chvosty** — je nižší uprostřed a širší po stranách:

```
        ╱▔╲     ← normální N(0,1)
      ╱─ ─ ╲    ← t s malým počtem stupňů volnosti
    ╱        ╲
  ╱ ˙          ˙ ╲     t má tlustší konce
▁˙▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁˙▁    -> kvantil je dál od nuly
```

Má jediný parametr — **stupně volnosti** $\nu = n-1$. Čím větší výběr, tím spolehlivější odhad $s$, tím blíž je $t$ normálnímu rozdělení:

| $n$ | $\nu = n-1$ | $t_\nu(0{,}975)$ | $u_{0{,}975}$ | Rozdíl |
|---|---|---|---|---|
| $5$ | $4$ | $2{,}776$ | $1{,}96$ | obrovský |
| $10$ | $9$ | $2{,}262$ | $1{,}96$ | výrazný |
| $20$ | $19$ | $2{,}093$ | $1{,}96$ | znatelný |
| $30$ | $29$ | $2{,}045$ | $1{,}96$ | malý |
| $100$ | $99$ | $1{,}984$ | $1{,}96$ | zanedbatelný |

**Odtud plyne pravidlo,** které se často říká jako hotová věc: *pro $n > 30$ se dá $t$ nahradit $u$*. Teď vidíš proč — rozdíl už je pod jedno procento.

> **Past:** stupňů volnosti je $n-1$, ne $n$. Pro výběr $10$ hodnot se v tabulce dívám na řádek $9$.

**Konkrétní dosazení:** měřím spotřebu auta při $10$ jízdách (l/100 km):

```
6,2   5,8   6,5   6,0   6,3   5,9   6,4   6,1   6,0   5,8
```

$$\bar{x} = 6{,}1 \qquad s \doteq 0{,}245 \qquad n = 10$$

$$\text{SE} = \frac{0{,}245}{\sqrt{10}} \doteq \frac{0{,}245}{3{,}162} \doteq 0{,}0775$$

$$\text{IS} = 6{,}1 \pm 2{,}262 \cdot 0{,}0775 = 6{,}1 \pm 0{,}175 = (5{,}93;\ 6{,}28)$$

Kdybych chybně použil $u = 1{,}96$, vyšlo by $\pm 0{,}152$ — interval **užší o $13\ \%$**, tedy hlásil bych větší přesnost, než na jakou mám data. Přesně kvůli tomu $t$-rozdělení existuje.

---

### 3) Interval spolehlivosti pro relativní četnost

$$\hat{p} \pm u_{1-\alpha/2} \cdot \sqrt{\frac{\hat{p}(1-\hat{p})}{n}}$$

kde $\hat{p} = \frac{X}{n}$ je podíl úspěchů ve výběru.

#### Odkud se bere ta odmocnina

Počet úspěchů $X$ má **binomické rozdělení** ([okruh 8](../08-nahodna-velicina/)) s $D(X) = np(1-p)$. Podíl je $\hat{p} = \frac{X}{n}$, a protože $D(aX) = a^2 D(X)$:

$$D(\hat{p}) = \frac{1}{n^2}\cdot np(1-p) = \frac{p(1-p)}{n}$$

Odmocnina z toho je střední chyba. **Nemusíš si ji pamatovat — odvodíš ji ze vzorce pro binomický rozptyl.**

#### Podmínka použitelnosti

$$n\hat{p} > 5 \quad \text{a} \quad n(1-\hat{p}) > 5$$

Aproximuji totiž binomické rozdělení normálním, a to jde jen tehdy, když **v obou kategoriích je dost pozorování**. Pro $n = 100$ a $\hat{p} = 0{,}01$ mám jediný úspěch — tam vzorec neplatí.

**Konkrétní dosazení — předvolební průzkum:** zeptám se $400$ lidí, $240$ řekne „ano".

$$\hat{p} = \frac{240}{400} = 0{,}6$$

$$\text{SE} = \sqrt{\frac{0{,}6 \cdot 0{,}4}{400}} = \sqrt{\frac{0{,}24}{400}} = \sqrt{0{,}0006} \doteq 0{,}0245$$

$$\text{IS} = 0{,}6 \pm 1{,}96 \cdot 0{,}0245 = 0{,}6 \pm 0{,}048 = (55{,}2\ \%;\ 64{,}8\ \%)$$

**Tohle je ta „chyba $\pm 5$ procentních bodů", kterou hlásí každý průzkum v televizi.** Teď víš, odkud se bere — z $n \approx 1000$ respondentů a spolehlivosti $95\ \%$.

> **Praktický důsledek:** když jedna strana má v průzkumu $21\ \%$ a druhá $19\ \%$ při chybě $\pm 3$ body, **jejich intervaly se překrývají** a z průzkumu se nedá říct, která vede. Tohle je nejčastější chyba ve výkladu volebních výsledků.

---

### 4) Interval spolehlivosti pro rozptyl

$$\left(\frac{(n-1)s^2}{\chi^2_{n-1}(1-\tfrac{\alpha}{2})};\ \ \frac{(n-1)s^2}{\chi^2_{n-1}(\tfrac{\alpha}{2})}\right)$$

**Tenhle jediný nemá tvar „$\pm$"** — a to je jeho hlavní zvláštnost, na kterou se ptají.

#### Proč je nesymetrický

Rozptyl je **nezáporný**, takže jeho rozdělení nemůže být symetrické — vlevo naráží na nulu, vpravo má volný prostor. Rozdělení $\chi^2$ proto vypadá takhle:

```
   ▁╱▔╲
  ╱     ╲▁
 │         ▔▔╲▁▁▁▁▁▁
 └──────────────────────▶
 0                          zešikmené doprava
```

**Interval proto sedí kolem $s^2$ nesouměrně** — nahoru sahá dál než dolů.

> **Past, na kterou se určitě zeptají:** ve **jmenovateli levé (dolní) meze** je **velký** kvantil $\chi^2(1-\frac{\alpha}{2})$ a ve jmenovateli pravé ten **malý**. Je to obráceně, než čekáš — protože dělení větším číslem dá menší výsledek.

**Konkrétní dosazení** na téže spotřebě auta ($n = 10$, $s = 0{,}25$, tedy $s^2 = 0{,}0625$, $\nu = 9$):

Z tabulek: $\chi^2_9(0{,}025) = 2{,}700$ a $\chi^2_9(0{,}975) = 19{,}023$.

$$\text{dolní mez} = \frac{9 \cdot 0{,}0625}{19{,}023} = \frac{0{,}5625}{19{,}023} \doteq 0{,}0296$$

$$\text{horní mez} = \frac{9 \cdot 0{,}0625}{2{,}700} = \frac{0{,}5625}{2{,}700} \doteq 0{,}2083$$

$$\text{IS pro } \sigma^2 = (0{,}0296;\ 0{,}2083)$$

Pro směrodatnou odchylku stačí **odmocnit obě meze**: $(0{,}172;\ 0{,}456)$.

**Všimni si, jak je ten interval široký** — horní mez je sedmkrát větší než dolní. **Rozptyl se odhaduje mnohem hůř než střední hodnota** a na jeho slušný odhad je potřeba výrazně větší výběr.

> Podle zkušeností z minulých let se **na rozptyl obvykle neptají** a stačí vědět, že se počítá přes $\chi^2$ a že je nesymetrický. Nauč se pořádně první tři.

---

### Jednostranné vs. oboustranné intervaly

Dosud jsem počítal **oboustranné** intervaly — riziko $\alpha$ rozdělené na dva konce. Někdy mě ale zajímá **jen jedna mez**:

| Typ | Tvar | Kvantil | Kdy |
|---|---|---|---|
| oboustranný | $(L;\ U)$ | $1-\frac{\alpha}{2}$ | „v jakém rozmezí to je" |
| levostranný | $(L;\ \infty)$ | $1-\alpha$ | „aspoň kolik to je" |
| pravostranný | $(-\infty;\ U)$ | $1-\alpha$ | „nejvýš kolik to je" |

**Reálné použití:** u životnosti žárovky mě zajímá jen dolní mez („vydrží aspoň $900$ hodin"), u obsahu škodliviny jen horní („nejvýš $2$ mg/l").

**Konkrétní dosazení:** táž data ($\bar{x} = 70$, $\text{SE} = 2$), ale ptám se „aspoň kolik". Celé riziko $5\ \%$ dám na jeden konec, takže kvantil je $u_{0{,}95} = 1{,}645$:

$$L = 70 - 1{,}645 \cdot 2 = 66{,}71$$

Tvrdím tedy: **$\mu$ je aspoň $66{,}71$**, se spolehlivostí $95\ \%$.

Porovnej s oboustranným, kde dolní mez vyšla $66{,}08$. **Jednostranný interval dává těsnější mez**, protože neplýtvá rizikem na druhý konec, který mě nezajímá.

---

### Vliv rozsahu výběru

Tohle je nejčastější doplňující otázka celé otázky. Klíč je jediný vzorec:

$$\text{šířka} = 2 \cdot u_{1-\alpha/2} \cdot \frac{\sigma}{\sqrt{n}}$$

**Šířka klesá s $\frac{1}{\sqrt{n}}$** — ne s $\frac{1}{n}$. To je celý vtip.

**Konkrétní dosazení** ($\sigma = 10$, $95\ \%$):

| $n$ | $\sqrt{n}$ | Chyba odhadu | Šířka |
|---|---|---|---|
| $25$ | $5$ | $3{,}92$ | $7{,}84$ |
| $100$ | $10$ | $1{,}96$ | $3{,}92$ |
| $400$ | $20$ | $0{,}98$ | $1{,}96$ |

**Čtyřnásobný výběr $\Rightarrow$ poloviční interval.** Chci-li interval desetkrát užší, musím měřit **stokrát** víc.

> **Odpověď na otázku „chci interval dvakrát užší, kolikrát větší výběr?":** **čtyřikrát**. Protože $\sqrt{4} = 2$.

#### Kolik měření potřebuji předem

Vzorec se dá otočit a spočítat rozsah výběru **dopředu** — to je jeho hlavní praktické využití. Chci-li chybu odhadu nejvýš $d$:

$$n \ge \left(\frac{u_{1-\alpha/2} \cdot \sigma}{d}\right)^2$$

**Konkrétní dosazení:** $\sigma = 10$, chci $95\ \%$ a chybu nejvýš $\pm 2$:

$$n \ge \left(\frac{1{,}96 \cdot 10}{2}\right)^2 = 9{,}8^2 = 96{,}04 \quad \Rightarrow \quad n = 97$$

Zpřísním-li požadavek na $\pm 1$, potřebuji $\left(\frac{19{,}6}{1}\right)^2 = 384{,}2$, tedy $385$ měření. **Dvakrát přesnější odhad stojí čtyřikrát víc práce.**

> **Zaokrouhluje se vždycky nahoru** — z nerovnosti $n \ge 96{,}04$ plyne $97$, ne $96$.

#### Co všechno šířku ovlivňuje

| Když roste… | Šířka | Proč |
|---|---|---|
| rozsah výběru $n$ | **klesá** ($\propto \frac{1}{\sqrt{n}}$) | víc dat, přesnější odhad |
| rozptyl $\sigma$ | **roste** (lineárně) | data jsou rozházenější |
| spolehlivost $1-\alpha$ | **roste** | větší jistota se platí šířkou |

**Rozptyl populace ovlivnit nemůžu, spolehlivost si volím podle úlohy — takže jediná páka, kterou opravdu mám, je rozsah výběru.**

---

### Souvislost s testováním hypotéz

Interval spolehlivosti a oboustranný test hypotézy jsou **dvě formulace téhož**:

> Hodnota $\mu_0$ **leží** v intervalu spolehlivosti se spolehlivostí $1-\alpha$ $\iff$ hypotéza $H_0\!: \mu = \mu_0$ se **nezamítá** na hladině $\alpha$.

**Konkrétní dosazení:** vyšel mi interval $(66{,}08;\ 73{,}92)$.

- Tvrdí-li někdo $\mu = 70$ — číslo je uvnitř, **nezamítám**, data mu neodporují.
- Tvrdí-li $\mu = 80$ — číslo je venku, **zamítám** na hladině $5\ \%$.

**Interval je přitom informativnější**, protože rovnou ukáže *všechny* hodnoty, které data nevyvracejí — kdežto test odpoví jen ano/ne na jednu jedinou.

---

### Využití v praxi

| Obor | K čemu | Co se odhaduje |
|---|---|---|
| průzkumy veřejného mínění | volební preference $\pm$ chyba | podíl |
| medicína | účinnost léku oproti placebu | rozdíl středních hodnot |
| kontrola kvality | průměrná hmotnost balení | střední hodnota |
| A/B testování webu | konverzní poměr varianty | podíl |
| měření ve fyzice | výsledek $\pm$ nejistota | střední hodnota |
| strojové učení | přesnost modelu na testovací sadě | podíl |

**Ke každému z nich se hodí jedna věta:** ve všech případech se **neuvádí jen výsledek, ale i to, jak přesně byl změřen** — a to je přesně to, co interval spolehlivosti dělá.

---

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

- **Populace (základní soubor)** — množina všech objektů, na které se zkoumání vztahuje.
- **Výběr (výběrový soubor)** — náhodně zvolená podmnožina populace o rozsahu $n$, z níž se odhadují parametry populace.
- **Bodový odhad** — jediná hodnota spočtená z výběru, kterou nahrazuji neznámý parametr populace.
- **Interval spolehlivosti** — interval $(L, U)$ určený z výběru tak, že s pravděpodobností $1-\alpha$ pokrývá skutečnou hodnotu odhadovaného parametru.
- **Spolehlivost** — hodnota $1-\alpha$, tedy podíl takto sestrojených intervalů, které skutečný parametr obsahují.
- **Hladina významnosti** — hodnota $\alpha$, tedy pravděpodobnost, že interval skutečný parametr nepokryje.
- **Střední chyba odhadu** — směrodatná odchylka bodového odhadu, u průměru $\frac{\sigma}{\sqrt{n}}$.
- **Výběrový rozptyl** — $s^2 = \frac{1}{n-1}\sum (x_i - \bar{x})^2$; dělí se $n-1$, aby byl odhad nestranný.
- **Stupně volnosti** — parametr Studentova a $\chi^2$ rozdělení; u jednoho výběru je roven $n-1$.

---

### Příklad na papír

Dva příklady. **První je hlavní** — projde celou otázkou a ukáže rozdíl mezi $u$ a $t$. **Druhý** je na interpretaci: šest výběrů vedle sebe, aby bylo vidět, co ta spolehlivost vlastně znamená.

---

#### Příklad 1 — doba odezvy serveru

##### Zadání

Měřím **dobu odezvy serveru** v milisekundách. Naměřil jsem $n = 25$ hodnot s průměrem $\bar{x} = 70$ ms.

##### Krok 0: co je co a odkud to mám

Tohle si u zkoušky vypiš dřív, než začneš počítat — je z toho vidět, že rozumíš, co dosazuješ:

| Značka | Co to je | Hodnota | **Odkud ji mám** |
|---|---|---|---|
| $n$ | rozsah výběru, počet měření | $25$ | **ze zadání** — kolikrát jsem měřil |
| $\bar{x}$ | výběrový průměr, bodový odhad $\mu$ | $70$ ms | **spočítal jsem ho z dat** (součet děleno $n$) |
| $\sigma$ | směrodatná odchylka **populace** | $10$ ms | **ze zadání** — z dlouhodobého provozu |
| $\alpha$ | hladina významnosti, riziko | $0{,}05$ | **volím si ji** podle požadované spolehlivosti |
| $1-\alpha$ | spolehlivost | $0{,}95$ | to, co chci tvrdit — $95\ \%$ |
| $u_{1-\alpha/2}$ | kvantil normovaného normálního rozdělení | $1{,}96$ | **z tabulek** (nebo zpaměti) |
| $\mu$ | skutečná průměrná odezva | **neznámá** | to, co odhaduji — proto tu celou úlohu dělám |

**Všimni si, odkud se ta čísla berou:** $n$ a $\bar{x}$ **z dat**, $\sigma$ **ze zadání**, $\alpha$ **si volím sám** a $u$ z něj **vyčtu v tabulce**. Nic z toho není počítání — samotný výpočet je až ten násobek níž.

##### Krok 1: varianta A — $\sigma$ znám

$$\bar{x} \pm u_{1-\alpha/2} \cdot \frac{\sigma}{\sqrt{n}}$$

**Nejdřív kvantil.** Riziko $\alpha = 0{,}05$ se rozdělí na dva konce po $\frac{\alpha}{2} = 0{,}025$, takže v tabulce hledám úroveň

$$1 - \frac{\alpha}{2} = 1 - 0{,}025 = 0{,}975 \quad \Rightarrow \quad u_{0{,}975} = 1{,}96$$

**Pak střední chyba** — o kolik se typicky liší výběrový průměr od skutečného:

$$\text{SE} = \frac{\sigma}{\sqrt{n}} = \frac{10}{\sqrt{25}} = \frac{10}{5} = 2\ \text{ms}$$

**Chyba odhadu** je součin obojího:

$$u \cdot \text{SE} = 1{,}96 \cdot 2 = 3{,}92\ \text{ms}$$

**A interval** je odhad plus minus ta chyba:

$$\text{IS} = 70 \pm 3{,}92 = (66{,}08;\ 73{,}92)\ \text{ms}$$

**Řekni k tomu:** „S $95\ \%$ spolehlivostí je průměrná doba odezvy mezi $66$ a $74$ milisekundami."

##### Krok 2: varianta B — $\sigma$ neznám

$$\bar{x} \pm t_{n-1}\left(1-\tfrac{\alpha}{2}\right) \cdot \frac{s}{\sqrt{n}}$$

Teď $\sigma$ populace **nemám**. Mám jen svých $25$ naměřených hodnot, takže si směrodatnou odchylku musím spočítat z nich:

$$s = \sqrt{\frac{1}{n-1}\sum_{i=1}^{n}(x_i - \bar{x})^2} = 10\ \text{ms}$$

**Schválně vyšlo stejné číslo jako $\sigma$ v Kroku 1** — aby bylo vidět, že jediné, co se mezi variantami mění, je **kvantil**.

**Co je jinak proti Kroku 1:**

| Značka | Varianta A | Varianta B | Rozdíl |
|---|---|---|---|
| míra rozptýlení | $\sigma = 10$ (**dána**) | $s = 10$ (**spočítána z dat**) | v B je to sám odhad |
| rozdělení kvantilu | $N(0,1)$ | Studentovo $t_{24}$ | B má těžší chvosty |
| kvantil | $1{,}96$ | $2{,}064$ | B je větší |
| $\nu$ (stupně volnosti) | — | $n - 1 = 24$ | jen v B |

**Kvantil** teď čtu z tabulky $t$-rozdělení, na řádku $\nu = n - 1 = 25 - 1 = 24$:

$$t_{24}(0{,}975) = 2{,}064$$

$$\text{IS} = 70 \pm 2{,}064 \cdot 2 = 70 \pm 4{,}13 = (65{,}87;\ 74{,}13)\ \text{ms}$$

> **Proč se vůbec liší, když jsem dosadil totéž číslo $10$?** Protože **nevím, jak přesné to $10$ je**. V A jde o vlastnost populace, kterou znám jistě. V B je to odhad z pětadvaceti hodnot — kdybych měřil znovu, vyšlo by $9{,}4$ nebo $11{,}2$. Studentovo $t$ tuhle nejistotu navíc započítává tím, že je širší. **Proto se ten interval nafoukne, i když dosazuji stejné číslo.**

**Porovnání vedle sebe:**

| Varianta | Kvantil | Chyba odhadu | Interval | Šířka |
|---|---|---|---|---|
| A: $\sigma$ znám | $1{,}96$ | $3{,}92$ | $(66{,}08;\ 73{,}92)$ | $7{,}84$ |
| B: $\sigma$ neznám | $2{,}064$ | $4{,}13$ | $(65{,}87;\ 74{,}13)$ | $8{,}26$ |

**Interval B je širší o $5\ \%$** — a to je přesně cena za to, že jsem směrodatnou odchylku musel odhadnout z dat. Pro $n = 5$ by ten rozdíl byl $42\ \%$; pro $n = 100$ už jen $1\ \%$.

##### Krok 3: vliv rozsahu výběru

Zůstanu u varianty A a měním jen $n$:

| $n$ | $\text{SE} = \frac{10}{\sqrt{n}}$ | Interval | Šířka |
|---|---|---|---|
| $25$ | $2$ | $(66{,}08;\ 73{,}92)$ | $7{,}84$ |
| $100$ | $1$ | $(68{,}04;\ 71{,}96)$ | $3{,}92$ |
| $400$ | $0{,}5$ | $(69{,}02;\ 70{,}98)$ | $1{,}96$ |

**Čtyřnásobný výběr, poloviční šířka.** Nakresli k tomu, jak se intervaly zužují kolem téhož středu:

```
  n = 25    ├─────────┼─────────┤
  n = 100        ├────┼────┤
  n = 400          ├──┼──┤
                      │
                     70
```

##### Krok 4: kolik měření potřebuji

Chci chybu odhadu nejvýš $\pm 1$ ms:

$$n \ge \left(\frac{1{,}96 \cdot 10}{1}\right)^2 = 19{,}6^2 = 384{,}16 \quad \Rightarrow \quad \mathbf{n = 385}$$

##### Krok 5: co z toho plyne pro rozhodování

Tvrdí-li dodavatel, že server odpovídá v průměru do $65$ ms, mé měření mu **odporuje** — $65$ leží pod dolní mezí $66{,}08$. Tvrdí-li $68$ ms, data mu neodporují.

---

#### Příklad 2 — výška mužů a šest výběrů vedle sebe

**Tenhle příklad si nakresli**, když se zeptají na interpretaci. Je na něm vidět to, co se slovy vysvětluje těžko: **parametr stojí, hýbou se intervaly.**

##### Zadání

| Pojem | Konkrétně |
|---|---|
| **populace** | všichni dospělí muži v ČR |
| **výběr** | $25$ náhodně vybraných mužů |
| **parametr** | $\mu$ = průměrná výška všech mužů v ČR |
| **skutečná hodnota** | $\mu = 178{,}5$ cm |

> **Pozor na tu poslední řádku:** ve skutečné úloze $\mu$ **neznám** — kdybych ho znal, nic neodhaduji. Tady si ho *dosadím*, abych mohl ukázat, které intervaly ho pokryly. **Je to didaktická berlička, ne součást postupu.**

##### Krok 1: střední chyba

Ze statistik vím, že směrodatná odchylka výšky mužů je $\sigma = 8$ cm. Při $n = 25$:

$$\text{SE} = \frac{\sigma}{\sqrt{n}} = \frac{8}{\sqrt{25}} = \frac{8}{5} = 1{,}6\ \text{cm}$$

$$\text{chyba odhadu} = 1{,}96 \cdot 1{,}6 = 3{,}136 \doteq 3{,}1\ \text{cm}$$

**Každý interval bude tedy široký zhruba $6{,}3$ cm** — a to bez ohledu na to, jaký průměr mi ve kterém výběru vyjde. Šířka závisí jen na $\sigma$, $n$ a $\alpha$, **ne na datech**.

##### Krok 2: šest nezávislých výběrů

Vyberu šest různých pětadvacetic mužů. Každá dá jiný průměr, a tedy jiný interval:

| Výběr | $\bar{x}$ | Interval $\bar{x} \pm 3{,}1$ | Pokryl $178{,}5$? |
|---|---|---|---|
| 1 | $178{,}2$ | $(175{,}1;\ 181{,}3)$ | ✔ |
| 2 | $179{,}4$ | $(176{,}3;\ 182{,}5)$ | ✔ |
| 3 | $177{,}1$ | $(174{,}0;\ 180{,}2)$ | ✔ |
| 4 | $178{,}9$ | $(175{,}8;\ 182{,}0)$ | ✔ |
| 5 | $175{,}0$ | $(171{,}9;\ \mathbf{178{,}1})$ | ✘ **minul** |
| 6 | $180{,}0$ | $(176{,}9;\ 183{,}1)$ | ✔ |

##### Krok 3: obrázek, kvůli kterému to celé je

```
                    mu = 178,5 cm
                         │
   výběr 1     ├─────────┼──┤          175,1 - 181,3   ✔
   výběr 2        ├──────┼─────┤       176,3 - 182,5   ✔
   výběr 3   ├────────┼──┤             174,0 - 180,2   ✔
   výběr 4      ├───────┼────┤         175,8 - 182,0   ✔
   výběr 5 ├────────┤   │               171,9 - 178,1   ✘ MINUL
   výběr 6       ├──────┼──────┤       176,9 - 183,1   ✔
                         │
              svislá čára STOJÍ
              závorky se HÝBOU
```

**Tři věty, které k tomu obrázku musíš říct:**

1. **Svislá čára se nehýbe.** $178{,}5$ je vlastnost populace — nemění se podle toho, koho vyberu.
2. **Pátý výběr nebyl udělaný špatně.** Byl stejně poctivě náhodný jako ostatní, jen do něj náhodou padlo víc menších mužů. Tomu se **nedá zabránit** — to je právě těch $5\ \%$.
3. **U reálné úlohy vidím jediný řádek** a nevím, jestli je z těch pěti pokrývajících, nebo ten šestý. Proto se spolehlivost týká **metody**, ne mého konkrétního intervalu.

> **Past ve formulaci:** neříkej „trefil jsem se do intervalu". Podmětem musí být **interval**: *„interval pokryl parametr"*. Ta první formulace totiž mlčky předpokládá, že interval stojí a parametr se hýbe — a to je přesně ta chybná představa, kterou zkoušející hledá.

##### Krok 4: proč zrovna šest a ne sto

Při $95\ \%$ spolehlivosti mine **jeden z dvaceti**. Ze šesti výběrů by tedy „správně" neměl minout ani jeden — čekaná hodnota je $6 \cdot 0{,}05 = 0{,}3$ výběru.

**Řekni to takhle:** „Nakreslil jsem šest pro názornost, abych se na ně vešel. Kdybych jich udělal sto, minulo by zhruba pět."

##### Krok 5: co změní jiná spolehlivost

Táž data, jen jiné $\alpha$ — mění se **jen kvantil**, `SE` zůstává $1{,}6$:

| Spolehlivost | $\alpha$ | Kvantil | Chyba | Šířka | Mine ze $100$ |
|---|---|---|---|---|---|
| $90\ \%$ | $0{,}10$ | $1{,}645$ | $2{,}6$ | $5{,}3$ cm | $10$ |
| $95\ \%$ | $0{,}05$ | $1{,}96$ | $3{,}1$ | $6{,}3$ cm | $5$ |
| $99\ \%$ | $0{,}01$ | $2{,}576$ | $4{,}1$ | $8{,}2$ cm | $1$ |

```
  90 %      ├────────┤          nejužší, ale mine 10x ze 100
  95 %     ├──────────┤
  99 %   ├──────────────┤       nejširší, ale mine jen 1x
                │
             178,5
```

**Nic zadarmo:** vyšší jistota se platí šířkou. Doveď to do extrému — **$100\ \%$ spolehlivosti se dá mít vždycky**, stačí říct „výška je mezi $0$ a $300$ cm". Nikdy se nespleteš a nikomu to nepomůže. **Užitečnost odhadu je právě v tom, že si připustíš nějaké riziko.**

##### Krok 6: past na rozsah výběru

Kdyby v zadání bylo $n = 1000$ místo $25$, vyšlo by

$$\text{SE} = \frac{8}{\sqrt{1000}} \doteq \frac{8}{31{,}6} \doteq 0{,}25 \quad \Rightarrow \quad 1{,}96 \cdot 0{,}25 \doteq 0{,}5\ \text{cm}$$

tedy interval široký **jeden centimetr**, ne šest.

| $n$ | $\sqrt{n}$ | $\text{SE}$ | Chyba $\pm$ | Šířka |
|---|---|---|---|---|
| $25$ | $5$ | $1{,}6$ | $3{,}1$ | $6{,}3$ cm |
| $100$ | $10$ | $0{,}8$ | $1{,}6$ | $3{,}1$ cm |
| $1000$ | $31{,}6$ | $0{,}25$ | $0{,}5$ | $1{,}0$ cm |

**Kontrola zdravým rozumem, která se vyplatí:** kdyby ti u tisícovky lidí vyšel interval široký sedm centimetrů, **něco jsi spočítal špatně**. Tisíc měření dává u výšky přesnost na půl centimetru — a přesně proto se průzkumy dělají na $n \approx 1000$: u podílů to vyjde na $\pm 3$ procentní body, což je akorát užitečné.

---

> **Věta, kterou celou otázku uzavři:** „Interval spolehlivosti je bodový odhad doplněný o poctivé přiznání, jak moc se může mýlit. Všechny jeho varianty jsou tentýž vzorec — *odhad plus minus kvantil krát střední chyba* — a liší se jen tím, z jakého rozdělení kvantil beru: znám-li $\sigma$, je to normální rozdělení, neznám-li ho, platím za jeho odhad širším Studentovým $t$, a u rozptylu se mění i tvar na nesymetrický $\chi^2$. Rozhodující je ale $\sqrt{n}$ ve jmenovateli — **přesnost roste jen s odmocninou z rozsahu výběru**, takže dvakrát přesnější odhad stojí čtyřikrát víc měření. A interpretovat se to musí opatrně: náhodné jsou meze intervalu, ne parametr."

---

### Na co se doptají

- Co je to interval spolehlivosti a k čemu je, když už mám bodový odhad?
- **Vysvětli, proč je interpretace „parametr tam leží s pravděpodobností $95\ \%$" nesprávná.**
- Co je náhodné — parametr, nebo meze intervalu?
- Jaký je vztah mezi spolehlivostí a hladinou významnosti?
- Proč se v kvantilu píše $1-\frac{\alpha}{2}$ a ne $1-\alpha$?
- **Chci interval dvakrát užší — kolikrát větší výběr potřebuji?**
- Proč se u neznámého rozptylu používá $t$ místo $u$ a co se stane pro velké $n$?
- Kolik je stupňů volnosti u výběru o $10$ hodnotách?
- Proč se výběrový rozptyl dělí $n-1$ a ne $n$?
- Odkud se ve vzorci bere $\sqrt{n}$ ve jmenovateli?
- Proč je interval pro rozptyl nesymetrický?
- Jak se odvodí střední chyba u odhadu podílu?
- Kdy se interval pro relativní četnost nesmí použít?
- Co se stane s intervalem, když zvýším spolehlivost z $95\ \%$ na $99\ \%$?
- Kdy použiješ jednostranný interval a jaký kvantil v něm bude?
- **Není to jedno, jestli $\sigma$ znám, když stejně potřebuji $s$?** V čem je rozdíl?
- Jak IS souvisí s testováním hypotéz a zamítnutím nulové hypotézy?
- Průzkum hlásí $21\ \%$ a $19\ \%$ při chybě $\pm 3$ body — dá se říct, kdo vede?
- Jak dopředu spočítám, kolik měření potřebuji?

### Užitečné odkazy

- <https://seeing-theory.brown.edu/frequentist-inference/index.html> (interaktivní simulace — vidíš, jak intervaly „skáčou" kolem parametru)
- <https://rpsychologist.com/d3/ci/> (vizualizace pokrytí intervalů, nejlepší pomůcka k interpretaci)
- <https://www.geogebra.org/probability> (kalkulátor kvantilů $u$, $t$ i $\chi^2$)
- <https://en.wikipedia.org/wiki/Confidence_interval>
- `/home/valdemar/Dokumenty/SZZ/01 - SZZTP - 15m ústní/09/` — zpracování od kamaráda; má obrázky k populaci vs. výběru a kód v R
