## 9 — Databázové systémy

- [Zadání okruhu (PDF)](../ZadaniOkruhu/URDB.pdf)

### Požadované znalosti a dovednosti

- konceptuální návrh: entity, atributy, relační vztahy (pasivně)
- logický návrh: relace 1:1, 1:N, M:N a jejich rozklad, normalizace (1.–3. NF), ER diagram (vraní nohy)
- fyzický návrh: CREATE TABLE, domény, omezení (PK, FK, NOT NULL, UNIQUE)
- manipulace s daty: INSERT INTO
- dotazy: SELECT, INNER/LEFT/RIGHT JOIN, WHERE, projekce
- řazení (ORDER BY) a seskupování (GROUP BY)

### Charakteristika zkušební úlohy

Ze slovního popisu a konceptuálního návrhu vytvořit databázi v PostgreSQL: ER diagram po normalizaci (na papíře), CREATE TABLE + INSERT, odladěné dotazy SELECT včetně výstupů.

### Postup u zkoušky (60 min přípravy)

1. Z popisu vytáhnout entity a atributy, najít porušení normálních forem.
2. Rozdělit M:N vazbu vazební tabulkou.
3. Nakreslit ER diagram vraními nohami — kreslí se na papír, nacvič si to.
4. CREATE TABLE ve správném pořadí (nadřazené tabulky první kvůli FK).
5. Naplnit ~3 řádky na tabulku.
6. Napsat dotazy, spustit je a ukázat výstupy.

### Co si nacvičit

- [ ] Vyřešit ukázkovou úlohu z PDF (studenti a předměty) celou v PostgreSQL
- [ ] Normalizace 1. → 2. → 3. NF na konkrétním příkladu, umět zdůvodnit každý krok
- [ ] Rozklad M:N, kdy vzniká složený primární klíč
- [ ] JOINy: INNER vs. LEFT — umět říct, čím se výsledek liší
- [ ] GROUP BY + agregace, včetně `STRING_AGG` (agregace řetězců je v zadání!)
- [ ] Kreslení ER diagramu vraními nohami od ruky

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

### Na co se doptají

- Ve které normální formě je tvůj původní návrh a co ji porušuje?
- Proč jsi tady dal LEFT JOIN a ne INNER?
- Co se stane, když dáš do SELECTu sloupec, který není v GROUP BY?
- Jak vynutíš, aby se student nezapsal na stejný předmět dvakrát?

### Užitečné odkazy

-
