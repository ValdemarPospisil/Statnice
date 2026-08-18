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

-
