## 3 — Spojové datové struktury

> Spojové datové struktury (jednosměrný spojový seznam, binární strom) a základní operace nad nimi (vkládání, výmaz, vyhledávání) včetně časové složitosti

### Osnova výkladu (15 min)

<!-- Tohle je jádro. Musí se vejít na jednu A4 a musíš to umět bez opory. -->

1. Motivace — souvislá paměť (pole) vs. uzly propojené odkazy; co tím získám a co ztratím
2. Jednosměrný spojový seznam — uzel (data + next), hlava, konec
3. Operace: vložení na začátek O(1), vložení na konec O(n), výmaz, vyhledání O(n)
4. Proč spojový seznam nemá indexaci v O(1)
5. Binární strom — kořen, uzel, list, potomek, hloubka, výška
6. Binární vyhledávací strom — invariant (vlevo menší, vpravo větší)
7. Vkládání, vyhledávání, výmaz: všechny O(h); h = log n u vyváženého, n u degenerovaného stromu
8. Výmaz v BVS — tři případy: list / jeden potomek / dva potomci (náhrada následníkem)
9. Průchody: preorder, inorder (dá setříděnou posloupnost!), postorder
10. Srovnávací tabulka: pole vs. spojový seznam vs. BVS

### Klíčové definice

<!-- Co musím říct doslova a přesně, ne vlastními slovy. -->

### Příklad na papír

<!-- Jeden příklad, který během výkladu spočítám nebo nakreslím. -->

### Na co se doptají

- Nakresli, co se stane, když do prázdného BVS vkládáš už setříděnou posloupnost.
- Jak smažeš uzel se dvěma potomky? Proč zrovna následník v inorder pořadí?
- Jaká je paměťová režie spojového seznamu oproti poli?
- Kde v praxi narazíš na spojový seznam, i když ho přímo nepíšeš?

### Užitečné odkazy

-
