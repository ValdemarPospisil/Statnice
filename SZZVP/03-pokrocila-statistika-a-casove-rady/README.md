## 3 — Pokročilé statistické metody a zpracování časových řad

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-DB.pdf)

### Požadované znalosti a dovednosti

- jednoduchá a mnohonásobná lineární regrese, nelineární regresní modely
- analýza rozptylu, logistická regrese
- předpoklady regresních modelů a co dělat, když nejsou splněny
- dekompozice časových řad — sezónnost a trend
- Box-Jenkinsova metodologie: ARMA, ARIMA, SARIMA
- dynamické lineární modely závislosti mezi časovými řadami

### Charakteristika zkušební úlohy

Datový soubor a úkol. Výstupem je report (R nebo Python) s analýzami, vizualizacemi a **především interpretacemi** — proč zrovna tyto metody a jaké jsou závěry. Očekává se porovnání více modelů a kontrola předpokladů.

### Postup řešení úlohy

Tenhle okruh je jiný než zbylých sedm: **neodevzdáváš aplikaci, ale report**. Hodnotí se interpretace, ne kód. Zadání to říká doslova: *„především interpretace, aby bylo zřejmé, jaké metody a proč byly použity"*.

**1. Rozhodni jedinou otázku, na které stojí všechno ostatní: je to časová řada, nebo nezávislá pozorování?**

- Máš sloupec s datem/časem a měření jdou za sebou v pravidelném kroku → **časová řada** → dekompozice, ARIMA/SARIMA, modely závislosti mezi řadami.
- Řádky jsou navzájem nezávislé případy (pacienti, domácnosti, obce) → **klasická regrese**.

Ověř to prakticky: vykresli závisle proměnnou proti času a udělej **ACF** (autokorelační funkci) reziduí obyčejné regrese. Když ACF ukazuje výrazné špičky, pozorování nezávislá nejsou a klasická regrese je špatně.

**2. Urči závisle proměnnou a její typ.** Spojitá → lineární regrese. Binární (ano/ne) → **logistická**. Počet událostí → Poissonova. Tenhle krok rozhoduje o celé rodině modelů, a je to první otázka u obhajoby.

**3. Explorativní analýza a vizualizace — s komentářem.** Zadání chce komentář *co je zřejmé a co se dá očekávat*, ne jen obrázky:

- průběh závisle proměnné (u řad v čase, u nezávislých histogram)
- bodové grafy proti každému regresoru
- **korelační matice regresorů** — hledáš multikolinearitu
- u časových řad **ACF a PACF**

**4. Postav víc modelů, ne jeden.** Zadání to vyžaduje výslovně („student by měl navrhnout více modelů, které bude hodnotit a dále porovnávat"). Minimum:

- jednoduchý model (1–2 regresory)
- plný model (všechny regresory)
- model po **krokové regresi** (`step()` podle AIC)
- u řad navíc: model trendu a sezónnosti × SARIMA × model se závislostí na jiných řadách

**5. Ke každému modelu spočítej kritérium kvality.** AIC/BIC (menší je lepší), **adjusted** R², významnost koeficientů, střední chyba reziduí. Dej je do jedné srovnávací tabulky — to je nejsilnější obrázek celého reportu.

**6. Zkontroluj předpoklady. Tohle je nejčastěji opomíjená část a zadání ji zmiňuje třikrát.** U vybraného modelu čtyři diagnostické grafy:

| Předpoklad | Jak ověřit | Když neplatí |
|---|---|---|
| linearita | rezidua vs. predikce (nesmí být vzorec) | polynomický člen, transformace |
| nezávislost reziduí | ACF reziduí, Durbin-Watson | přidat členy ARMA |
| konstantní rozptyl | rezidua vs. predikce (nesmí se rozevírat) | logaritmovat závisle proměnnou |
| normalita reziduí | Q-Q graf, Shapiro-Wilk | logaritmovat, robustní regrese |

**7. Vyber optimální model a zapiš ho rovnicí.** Doslova z PDF: *„Student musí umět model zapsat formou rovnice, popsat způsob, jakým jednotlivé faktory ovlivňují závisle proměnnou."* Napiš si tu rovnici do reportu **s dosazenými odhadnutými čísly**, ne symbolicky.

**8. Interpretuj — slovně, v jednotkách úlohy.** Ne „koeficient je 0,43", ale „když srážky vzrostou o 1 mm, hladina stoupne v průměru o 0,43 cm, za jinak stejných podmínek".

### Checklist odevzdání

Společné:

- [ ] report v R (Quarto/R Markdown) nebo Pythonu (Jupyter), vykreslený do **HTML/PDF** — ne jen zdroják
- [ ] zdrojový kód v Git repozitáři
- [ ] report jde reprodukovat: data v repu (nebo skript na stažení), fixovaný `set.seed()`

Specifické pro tento okruh (přímo z PDF):

- [ ] rozhodnutí **časová řada × nezávislá pozorování** a jeho zdůvodnění
- [ ] identifikace závisle proměnné a volba rodiny modelů podle jejího typu
- [ ] vizualizace **s komentářem**, co je z nich vidět
- [ ] **více modelů** a jejich porovnání v tabulce
- [ ] indikátor kvality u každého modelu (AIC/BIC, R², významnost, chyba reziduí)
- [ ] **kontrola předpokladů** u vybraného modelu + nápravné kroky, když neplatí
- [ ] **model zapsaný rovnicí** s odhadnutými koeficienty
- [ ] interpretace koeficientů slovy a v jednotkách úlohy
- [ ] závěr vzhledem k zadanému úkolu

### Pasti a časté chyby

- **Vynechaná kontrola předpokladů.** Nejtěžší ztráta bodů. I když všechno vyjde, ty čtyři grafy tam musí být.
- **Obyčejné R² u vícenásobné regrese.** R² roste s každým přidaným regresorem, i s náhodným. Porovnávej **adjusted R²** nebo AIC.
- **Zaměňování korelace a kauzality** v interpretaci. Říkej „je spojeno s", ne „způsobuje".
- **Interpretace koeficientu bez podmínky „za jinak stejných podmínek"** — u vícenásobné regrese je to podstatné.
- **Logistická regrese: koeficient není pravděpodobnost.** Je to log-odds. `exp(koeficient)` je **poměr šancí** (odds ratio), a to je to, co se interpretuje.
- **ARIMA na nestacionární řadě bez diferencování.** `d` v ARIMA existuje právě proto. Ověř ADF testem.
- **Přediferencování** — když už je řada stacionární, další diference přidá umělou negativní autokorelaci.
- **Sezónnost ignorovaná u měsíčních/čtvrtletních dat.** Použij SARIMA, ne ARIMA.
- **Kroková regrese jako jediný argument.** `step()` je nástroj, ne odpověď. Musíš umět říct, proč vybrané proměnné dávají věcný smysl.
- **Predikce hodnocená na trénovacích datech.** U časové řady odděl posledních N pozorování jako test.

### Technické minimum

R (report v Quartu):

```r
install.packages(c("forecast", "tseries", "car", "lmtest", "ggplot2"))
```

```r
model <- lm(hladina ~ srazky + teplota + prutok, data = df)
summary(model)          # koeficienty, R², adjusted R², významnost
AIC(model); BIC(model)
par(mfrow = c(2,2)); plot(model)     # čtyři diagnostické grafy naráz
step(model)                          # kroková regrese podle AIC

# časové řady
r <- ts(df$hladina, frequency = 12)
plot(decompose(r))                   # trend + sezónnost + zbytek
acf(r); pacf(r)
adf.test(r)                          # stacionarita: p < 0,05 = stacionární
m <- forecast::auto.arima(r)
checkresiduals(m)                    # test nezávislosti reziduí
forecast::forecast(m, h = 12) |> plot()
```

Python:

```bash
pip install pandas statsmodels scikit-learn matplotlib seaborn
```

```python
import statsmodels.api as sm
import statsmodels.formula.api as smf

model = smf.ols("hladina ~ srazky + teplota + prutok", data=df).fit()
print(model.summary())

from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.stattools import adfuller

seasonal_decompose(rada, model="additive", period=12).plot()
adfuller(rada)                        # [1] je p-hodnota
sar = SARIMAX(rada, order=(1,1,1), seasonal_order=(1,1,1,12)).fit()
```

### Řešení ukázkové úlohy

**Zadání z PDF:** *„Cílem je najít optimální model pro výšku hladiny v řece (na čem a jakým způsobem výška hladiny závisí). K dispozici jsou data o různých ukazatelích, která mohou mít na výšku hladiny vliv."*

#### Krok 1 — o jaká data jde

Výška hladiny měřená v čase je **skoro jistě časová řada** (denní/hodinová měření). Ověř a **napiš to do reportu i s důkazem**:

```r
plot(df$datum, df$hladina, type = "l")
m0 <- lm(hladina ~ srazky + teplota, data = df)
acf(residuals(m0))          # výrazné špičky = rezidua závislá = NENÍ to nezávislé pozorování
durbinWatsonTest(m0)        # DW blízko 2 = nezávislá; blízko 0 = kladná autokorelace
```

Když ACF ukáže pomalu klesající špičky, řekni nahlas: *„klasická regrese by tu porušila předpoklad nezávislosti reziduí, proto jdu cestou modelů časových řad — nebo regrese s ARMA chybovou složkou."* Tohle je nejlepší věta celého reportu.

#### Krok 2 — explorativní analýza

```r
# průběh závisle proměnné
plot(df$datum, df$hladina, type = "l", ylab = "Hladina [cm]")

# závislosti na regresorech
pairs(df[, c("hladina","srazky","teplota","prutok","vlhkost")])
cor(df[, -1])                # multikolinearita: |r| > 0,8 mezi regresory je problém

# struktura řady
r <- ts(df$hladina, frequency = 365)
plot(decompose(r))           # je tam trend? sezónnost?
acf(r, lag.max = 60); pacf(r, lag.max = 60)
```

Komentář, který k tomu patří (zadání ho vyžaduje): *„Hladina vykazuje roční sezónnost s maximem na jaře. Průtok koreluje s hladinou velmi silně (r = 0,91), což je fyzikálně očekávané — pozor, jde spíš o jiné vyjádření téže veličiny než o vysvětlující faktor. Srážky korelují slaběji (r = 0,34) a s prodlevou, což naznačuje potřebu zpožděného regresoru."*

#### Krok 3 — kandidátní modely

```r
# A) jen trend a sezónnost
mA <- tslm(r ~ trend + season)

# B) klasická regrese na ostatních řadách
mB <- lm(hladina ~ srazky + teplota + prutok + vlhkost, data = df)

# C) kroková regrese
mC <- step(mB, direction = "both")

# D) se zpožděným regresorem (srážky se projeví až za den či dva)
df$srazky_lag1 <- dplyr::lag(df$srazky, 1)
df$srazky_lag2 <- dplyr::lag(df$srazky, 2)
mD <- lm(hladina ~ srazky + srazky_lag1 + srazky_lag2 + teplota, data = df)

# E) SARIMA na samotné řadě
mE <- auto.arima(r, seasonal = TRUE)

# F) regrese s externími regresory a ARMA chybou — obvykle vítěz
mF <- auto.arima(r, xreg = as.matrix(df[, c("srazky","teplota")]))
```

Model **F** je ten, ke kterému má úloha směřovat: vysvětlující proměnné *a zároveň* ošetřená autokorelace reziduí. Umět říct, proč je lepší než B, je jádro obhajoby.

#### Krok 4 — srovnávací tabulka

Tohle dej do reportu jako tabulku, ne do textu:

| Model | Popis | AIC | adj. R² | RMSE | Rezidua nezávislá? |
|---|---|---|---|---|---|
| A | trend + sezónnost | 4812 | 0,41 | 18,3 | ne |
| B | plná regrese | 4203 | 0,78 | 11,2 | **ne** |
| C | kroková regrese | 4198 | 0,78 | 11,2 | ne |
| D | + zpožděné srážky | 4102 | 0,82 | 9,8 | ne |
| E | SARIMA(1,1,1)(1,0,0)[365] | 3944 | — | 8,1 | ano |
| **F** | **regrese + ARMA chyba** | **3871** | — | **7,4** | **ano** |

Věta k tabulce: *„Modely B–D mají vysoké R², ale porušují předpoklad nezávislosti reziduí — jejich směrodatné chyby jsou podhodnocené a testy významnosti nespolehlivé. Model F dosahuje nejnižšího AIC a jako jediný kombinuje vysvětlující proměnné se splněnými předpoklady."*

#### Krok 5 — kontrola předpokladů vybraného modelu

```r
checkresiduals(mF)        # graf reziduí + ACF + histogram + Ljung-Box test
shapiro.test(residuals(mF))
```

Co hledáš a co dělat, když to nevyjde:

- **Ljung-Box p > 0,05** → rezidua jsou bílý šum, dobře. Když p < 0,05, zvyš řád ARMA.
- **Q-Q graf** — body na přímce. Když se ohýbají, zkus `log(hladina)`.
- **Rezidua vs. predikce** — když se vějíř rozevírá (heteroskedasticita), taky logaritmuj.

Napiš do reportu, **co jsi udělal, když předpoklad neplatil** — i to je hodnocené.

#### Krok 6 — zápis rovnicí a interpretace

Toto je ta část, kterou se u obhajoby ptají skoro jistě. Model se zapíše s **dosazenými čísly**:

$$\text{hladina}_t = 42{,}1 + 0{,}43 \cdot \text{srazky}_t + 0{,}28 \cdot \text{srazky}_{t-1} - 1{,}12 \cdot \text{teplota}_t + \eta_t$$

$$\eta_t = 0{,}76\,\eta_{t-1} + \varepsilon_t, \qquad \varepsilon_t \sim N(0;\ 7{,}4^2)$$

Interpretace po jednotlivých členech (takhle to řekni nahlas):

- **0,43 u srážek**: každý 1 mm srážek téhož dne zvedne hladinu v průměru o 0,43 cm, za jinak stejných podmínek.
- **0,28 u zpožděných srážek**: dešťová voda se projeví ještě druhý den — dohromady tedy zhruba 0,71 cm na milimetr srážek.
- **−1,12 u teploty**: o stupeň tepleji znamená v průměru o 1,12 cm nižší hladinu — výpar. Znaménko dává fyzikální smysl, což je argument pro model.
- **η s koeficientem 0,76**: chybová složka je autokorelovaná. Odchylka od modelu z minulého dne se ze tří čtvrtin přenese na dnešek — proto samotná regrese nestačila.
- **42,1**: absolutní člen, teoretická hladina při nulových srážkách i teplotě. Extrapolace mimo rozsah dat, interpretačně bezcenná — řekni to, ať tě tím nechytnou.

#### Krok 7 — závěr

Tři až čtyři věty odpovídající **na zadanou otázku**, ne na statistiku: *„Výška hladiny závisí především na srážkách, a to se zpožděním do dvou dnů, a negativně na teplotě. Model vysvětluje chování hladiny se střední chybou 7,4 cm, což je při rozpětí hladin 30–210 cm použitelné pro krátkodobou předpověď na 1–3 dny. Pro delší horizont přesnost rychle klesá, protože model nemá informaci o budoucích srážkách."*

#### Kdyby to byla nezávislá pozorování

Kdyby ACF žádnou autokorelaci neukázalo, jde se klasickou cestou — připrav si ji taky, zadání ji zmiňuje:

```r
m1 <- lm(y ~ x1 + x2, data = df)
m2 <- lm(y ~ x1 + x2 + x3 + x4, data = df)
m3 <- lm(y ~ x1 * x2, data = df)             # s interakcí
m4 <- lm(y ~ poly(x1, 2) + x2, data = df)    # polynomická
m5 <- step(m2, direction = "both")

anova(m1, m2)                                 # je plný model významně lepší?
car::vif(m2)                                  # VIF > 5–10 = multikolinearita
par(mfrow = c(2,2)); plot(m5)
```

Kdyby byla závisle proměnná binární (překročila hladina povodňový stupeň?):

```r
mlog <- glm(povoden ~ srazky + teplota, data = df, family = binomial)
exp(coef(mlog))     # poměry šancí — TOHLE se interpretuje, ne samotné koeficienty
```

Interpretace: *„`exp(0,43) = 1,54` — každý další milimetr srážek zvyšuje šanci na překročení povodňového stupně o 54 %."* Pozor: **šance, ne pravděpodobnost.**

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a cíl analýzy
2. Charakter dat: časová řada, nebo nezávislá pozorování? Tím se rozhoduje o celé metodice
3. Explorativní vizualizace a co z nich je vidět
4. Navržené modely a proč zrovna ty
5. Kritéria kvality: AIC/BIC, R², významnost koeficientů, střední chyba reziduí
6. Kontrola předpokladů (nezávislost a normalita reziduí, stabilita rozptylu) a nápravné kroky
7. Výběr optimálního modelu, jeho zápis rovnicí a interpretace koeficientů
8. Závěr vzhledem k zadanému úkolu

### Na co se doptají (diskuse po prezentaci)

- Zapiš svůj model rovnicí a vysvětli, co znamená každý koeficient.
- Jaké předpoklady má lineární regrese a jak jsi je ověřil?
- Co uděláš, když jsou rezidua závislá? A co při nestabilním rozptylu?
- Co znamená I v ARIMA a jak jsi určil jeho řád?
- Kdy logistická regrese místo lineární?
- Jak jsi porovnával modely a proč zrovna tímto kritériem?

### Užitečné odkazy

- Hyndman & Athanasopoulos, *Forecasting: Principles and Practice* (zdarma, nejlepší zdroj na ARIMA/SARIMA): <https://otexts.com/fpp3/>
- Dokumentace balíčku `forecast`: <https://pkg.robjhyndman.com/forecast/>
- statsmodels — časové řady: <https://www.statsmodels.org/stable/tsa.html>
- statsmodels — regrese a diagnostika: <https://www.statsmodels.org/stable/regression.html>
- Quarto (reporty v R i Pythonu): <https://quarto.org/>
