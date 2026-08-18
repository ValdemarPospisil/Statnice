## 7 — Základy elektroniky: digitální část

- [Zadání okruhu (PDF)](../ZadaniOkruhu/ZEL-2okruhy.pdf)

### Požadované znalosti a dovednosti

- funkce logických hradel (AND, OR, NOT, NAND, NOR, XOR, XNOR)
- sestavení pravdivostní tabulky
- Karnaughova mapa a minimalizace pomocí ní
- algoritmus Quine-McCluskey včetně skupinové minimalizace
- kreslení schématu logické funkce
- sedmisegmentový displej (např. 5161AS, společná katoda)
- dekodér a multiplexor

### Charakteristika zkušební úlohy

Návrh logického kombinačního obvodu: pravdivostní tabulka → minimalizace (Karnaugh i Quine-McCluskey) → rovnice → schéma.

### Postup u zkoušky (60 min přípravy)

1. Sestavit pravdivostní tabulku ze slovního zadání — tady se dělá nejvíc chyb.
2. Karnaughova mapa: správné Grayovo pořadí, slučovat co největší skupiny (i přes okraje).
3. Quine-McCluskey: implikanty → primární implikanty → pokrývací tabulka.
4. Zapsat minimalizovanou rovnici a nakreslit schéma.
5. Případně převést do NAND/NOR (vazba na SZZTP 10 — úplný systém spojek).

### Co si nacvičit

- [ ] Vyřešit ukázkovou úlohu z PDF (adresový dekodér 3 → 8)
- [ ] Karnaugh pro 3 i 4 proměnné, včetně neurčených stavů (don't care)
- [ ] Quine-McCluskey ručně na jednom příkladu
- [ ] Zapojení sedmisegmentovky se společnou katodou vs. anodou
- [ ] Realizace funkce multiplexorem

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

### Na co se doptají

- Proč je v Karnaughově mapě Grayovo pořadí a ne binární?
- Co jsou don't care stavy a jak ti pomůžou?
- Převeď svou funkci na samá NAND hradla.
- Jak realizuješ libovolnou funkci 3 proměnných jedním multiplexorem 8:1?

### Užitečné odkazy

-
