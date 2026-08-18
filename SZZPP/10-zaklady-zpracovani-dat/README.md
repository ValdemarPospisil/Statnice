## 10 — Základy zpracování dat

- [Zadání okruhu (PDF)](../ZadaniOkruhu/ZZD.pdf)

### Požadované znalosti a dovednosti

- datové typy (numeric, logical, character, factor) a struktury (vektory, matice, data.frame, list)
- operace nad řetězci včetně regulárních výrazů
- načítání a ukládání dat (CSV, XLSX)
- cykly, podmínky, vlastní funkce
- manipulace s tabulkami (výběr, řazení, filtrování, slučování, seskupování, sumarizace, krátký ↔ dlouhý formát, kontingenční tabulky)
- grafy včetně histogramů a boxplotů a jejich interpretace
- reprodukovatelné reporty (Rmd, qmd)

### Charakteristika zkušební úlohy

Vstupem jsou tabulky (CSV/XLSX) a seznam požadavků. Výstupem je **protokol v Rmd nebo qmd + vyrenderované HTML/PDF** obsahující popis dat, komentovaný kód a interpretaci výsledků.

### Postup u zkoušky (60 min přípravy)

1. Nejdřív ověřit, že render vůbec funguje — prázdný dokument zrenderovat hned na začátku.
2. Načíst data, podívat se na `str()` a `summary()`, popsat je slovy.
3. Řešit úkoly postupně, každý jako vlastní chunk s komentářem.
4. Grafy popsat — interpretace se hodnotí zvlášť.
5. Nechat si 10 minut na finální render; nerenderovaný protokol je nedodělaný protokol.

### Co si nacvičit

- [ ] Vyřešit ukázkovou úlohu z PDF (StudentsPerformance.csv) celou, na čas
- [ ] `dplyr`: `mutate`, `filter`, `select`, `arrange`, `group_by` + `summarise`
- [ ] `tidyr`: `pivot_wider` / `pivot_longer` (krátký ↔ dlouhý formát)
- [ ] `stringr` + regulární výrazy (`str_detect` — v zadání je hledání „high school“)
- [ ] `ggplot2`: boxplot, histogram, bodový graf, faceting
- [ ] Založit a zrenderovat `.qmd` od nuly bez hledání na internetu

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

### Na co se doptají

- Co ti boxplot říká o rozdělení dat? Co jsou ty body mimo vousy?
- Proč jsi zvolil právě tenhle typ grafu?
- Jaký je rozdíl mezi krátkým a dlouhým formátem a kdy který potřebuješ?
- Co je factor a proč na něm záleží při vykreslování?

### Užitečné odkazy

-
