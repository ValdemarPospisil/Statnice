## 2 — Komplexní algoritmy nad seznamy

> Komplexní algoritmy nad seznamy (filtrování, vyhledávání, třídění/řazení výběrem nebo vkládáním), efektivnější implementace vyhledávání a třídění (binární vyhledávání, merge sort), časová složitost algoritmů

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. Filtrování — predikát, výsledkem podmnožina; odlišit od vyhledávání (identifikace + lokalizace prvku)
2. Lineární vyhledávání — princip, O(n), kdy je jediná možnost
3. Binární vyhledávání — předpoklad setříděnosti, invariant, půlení intervalu, O(log n)
4. Řazení výběrem (selection sort) — princip, vždy O(n²), počet výměn
5. Řazení vkládáním (insertion sort) — princip, O(n²), ale O(n) na téměř setříděném vstupu
6. Merge sort — rozděl a panuj, operace slévání, rekurentní vztah T(n) = 2T(n/2) + n → O(n log n)
7. Paměťová náročnost a stabilita: merge sort O(n) navíc, insertion sort in-place
8. Porovnání: kdy použít který algoritmus a proč se O(n log n) nedá u porovnávacího řazení překonat
9. Jak se složitost odvozuje — počítání porovnání, ne měření času

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

### Příklad na papír

<!-- Jeden příklad, který během výkladu spočítám nebo nakreslím. -->

### Na co se doptají

- Odvoď složitost merge sortu z rekurentního vztahu (vazba na otázku 11).
- Proč nejde binárně vyhledávat ve spojovém seznamu?
- Co znamená, že je řazení stabilní, a kdy mi to vadí?
- Insertion sort je O(n²) — proč se přesto používá uvnitř rychlých knihovních řadicích algoritmů?

### Užitečné odkazy

-
