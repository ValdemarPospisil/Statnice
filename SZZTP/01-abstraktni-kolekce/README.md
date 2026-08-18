## 1 — Základní a specializované abstraktní kolekce

> Základní abstraktní kolekce (jejich klasická implementace [seznamy, slovníky], iterátory nad nimi, typické elementární operace a jejich časová složitost) a specializované abstraktní kolekce (fronta, zásobník)

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. Abstraktní datový typ vs. datová struktura — rozhraní odděleno od implementace, proč to je užitečné
2. Přehled základních kolekcí: seznam, množina, slovník (a čím se liší v tom, co garantují)
3. Seznam — typické operace (přístup, vložení, výmaz, hledání) a jejich složitost
4. Implementace seznamu: statické pole vs. dynamické pole (realokace, amortizovaná složitost) vs. spojový seznam
5. Slovník — klíč → hodnota; hashovací tabulka, kolize a jejich řešení, průměrně O(1) vs. nejhůře O(n)
6. Iterátor — proč existuje, protokol průchodu, oddělení iterace od struktury
7. Zásobník (LIFO) — push / pop / top, typické použití (rekurze, vyhodnocování výrazů)
8. Fronta (FIFO) — enqueue / dequeue, typické použití (BFS, buffery)
9. Souhrnná tabulka časových složitostí — tady graduje celý výklad

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

### Příklad na papír

<!-- Jeden příklad, který během výkladu spočítám nebo nakreslím. -->

### Na co se doptají

- Proč má vložení do dynamického pole amortizovaně O(1), když realokace stojí O(n)?
- Kdy je hashovací tabulka horší než strom? Co se stane při špatné hashovací funkci?
- Jak implementuješ frontu pomocí dvou zásobníků? A jakou to má složitost?
- Čím se liší množina od seznamu z pohledu ADT, ne z pohledu implementace?

### Užitečné odkazy

-
