## 2 — NoSQL databáze

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-DB.pdf)

### Požadované znalosti a dovednosti

- dokumentově orientované databáze (MongoDB, BJSON v PostgreSQL)
- programové vytváření a plnění databáze
- dotazy nad databází
- agregační pipelines
- vizualizace (Matplotlib)

### Charakteristika zkušební úlohy

Návrh optimálního NoSQL modelu pro Open Data — včetně **zdůvodnění, proč je či není vhodné zvolit SQL databázi**. Vytvoření databáze v MongoDB, programové načtení dat, dotazy (preferovány agregační) a vizualizace. Prostředí: Docker s MongoDB + Python.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a cíl
2. Proč NoSQL a ne relační databáze — tohle je jádro hodnocení
3. Návrh struktury dokumentů, míra denormalizace a čím jsem ji zdůvodnil
4. ETL skript a řešení nekonzistencí
5. Agregační pipeline a její jednotlivé fáze
6. Vizualizace výsledků
7. Zhodnocení výhod a nevýhod zvoleného řešení

### Na co se doptají (diskuse po prezentaci)

- Kdy bys naopak zvolil relační databázi? Buď konkrétní.
- Vysvětli jednotlivé fáze své agregační pipeline.
- Vnořit dokument, nebo referencovat? Podle čeho ses rozhodl?
- Co je CAP teorém a kde v něm MongoDB stojí?
- Jak je to v MongoDB s transakcemi a konzistencí?
- Jak bys řešil totéž pomocí JSONB v PostgreSQL?

### Užitečné odkazy

-
