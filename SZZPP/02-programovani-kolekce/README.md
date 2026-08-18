## 2 — Programování: kolekce

- [Zadání okruhu (PDF)](../ZadaniOkruhu/APR-I-II-3okruhy.pdf)

### Požadované znalosti a dovednosti

- základní kolekce (seznamy, slovník), jejich metody a literály
- literály základních tříd a jejich operace
- cykly, podmíněné příkazy, vlastní funkce
- vyvolávání výjimek
- vstup a výstup na konzoli

### Charakteristika zkušební úlohy

Opravit chybný kód pracující s kolekcemi a rozšířit ho — typicky modifikace vs. vytvoření nového seznamu, kontrola typů prvků, práce s indexy.

### Postup u zkoušky (60 min přípravy)

1. Ověřit, jestli je struktura vůbec modifikovatelná (`range` není seznam!).
2. Rozlišit modifikaci na místě od vrácení nové kolekce.
3. Pozor na modifikaci kolekce během iterace přes ni.
4. Ošetřit typy prvků a vyhodit výjimku, když neodpovídají.
5. Sepsat výsledky ladění.

### Co si nacvičit

- [ ] Ukázková úloha z PDF: inkrementace prvků, celá včetně rozšíření
- [ ] List comprehension i klasický cyklus — obojí umět napsat
- [ ] `enumerate`, `zip`, slicing, `range` vs. `list`
- [ ] Slovník: iterace přes `.items()`, `.get()` s výchozí hodnotou
- [ ] Mělká vs. hluboká kopie

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

### Na co se doptají

- Proč se `range` nedá modifikovat? Co to vlastně je?
- Co se stane, když ze seznamu mažeš prvky během iterace?
- Kdy je slovník lepší než seznam a jaká je složitost vyhledání?
- Rozdíl mezi `list.copy()` a `copy.deepcopy()`?

### Užitečné odkazy

-
