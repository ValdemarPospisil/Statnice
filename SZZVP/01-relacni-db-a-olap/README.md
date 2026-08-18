## 1 — Relační databázové systémy a OLAP databáze

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-DB.pdf)

### Požadované znalosti a dovednosti

- konceptuální, logický a fyzický návrh; normalizace 1.–3. NF, ER diagram (vraní nohy)
- SELECT, JOINy, WHERE, ORDER BY, GROUP BY
- transakce, analytické (okenní) funkce
- uložené procedury včetně triggerů, rekurzivní dotazy
- programový přístup k databázím (kurzory, ORM)
- vizualizace (Matplotlib)
- OLAP a jeho druhy (ROLAP, MOLAP, HOLAP), OLTP vs. OLAP
- architektura multidimenzionálních databází (fakta a dimenze), modely star a snowflake

### Charakteristika zkušební úlohy

Návrh a naplnění relační databáze z Open Dat, propojení zdrojů, analytické dotazy, vizualizace a návrh multidimenzionálního modelu datového skladu. Prostředí: Docker s PostgreSQL + Python (NumPy, Pandas) + DBeaver.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a co bylo cílem (30 s)
2. Datové zdroje a jejich problémy — nekonzistentní identifikátory, chybějící data
3. ER diagram návrhu a proč zrovna takhle
4. ETL skript — jak jsem data čistil a vkládal
5. Klíčové dotazy a jejich výstupy
6. Vizualizace a co z ní plyne
7. Návrh datového skladu (star schema: faktová tabulka + dimenze)
8. Co bych udělal jinak / co by šlo dál

### Na co se doptají (diskuse po prezentaci)

- V čem se liší OLTP a OLAP a proč se pro ně navrhuje schéma jinak?
- Proč star a ne snowflake (nebo naopak)?
- Co je ROLAP, MOLAP, HOLAP?
- Vysvětli ACID na své transakci.
- K čemu by se ti tady hodila okenní funkce?
- Jak bys řešil rekurzivní dotaz nad hierarchií?

### Užitečné odkazy

-
