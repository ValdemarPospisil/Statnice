## 12 — Grafy, stromy, eulerovské a hamiltonovské grafy, prohledávání

> Grafy (definice orientovaného a neorientovaného grafu, jejich vlastnosti a reprezentace, význačné typy grafů), stromy (vymezení a základní charakteristiky, binární stromy a jejich reprezentace), eulerovské a hamiltonovské grafy (eulerovský tah, hamiltonovská kružnice a cesta), prohledávání do hloubky a do šířky

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. Definice neorientovaného a orientovaného grafu
2. Základní pojmy: stupeň vrcholu, sled, tah, cesta, kružnice, souvislost, komponenta
3. Reprezentace: matice sousednosti vs. seznam sousedů — paměť a složitost operací, kdy co
4. Význačné typy: úplný, bipartitní, regulární, souvislý, acyklický, strom, les
5. Stromy — charakterizace (souvislý a acyklický, n − 1 hran, mezi dvěma vrcholy právě jedna cesta)
6. Kořenový a binární strom, reprezentace odkazy vs. polem
7. Eulerovský tah a kružnice — podmínka přes stupně vrcholů, sedm mostů královeckých
8. Hamiltonovská cesta a kružnice — proč u ní neexistuje jednoduchá podmínka (NP-úplnost)
9. DFS — zásobník/rekurze, jak se chová, typické použití
10. BFS — fronta, hledání nejkratší cesty v nevážený grafu
11. Složitost obou průchodů: O(V + E) pro seznam sousedů

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

### Příklad na papír

<!-- Jeden příklad, který během výkladu spočítám nebo nakreslím. -->

### Na co se doptají

- Kdy má graf eulerovský tah a kdy eulerovskou kružnici? Odůvodni přes stupně.
- V čem je zásadní rozdíl mezi Eulerem a Hamiltonem z hlediska výpočetní složitosti?
- Proč BFS najde nejkratší cestu a DFS ne?
- Kolik paměti zabere matice sousednosti u řídkého grafu s milionem vrcholů?

### Užitečné odkazy

-
