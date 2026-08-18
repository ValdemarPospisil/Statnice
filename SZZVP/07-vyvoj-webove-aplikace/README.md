## 7 — Vývoj webové aplikace

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-SW.pdf)

### Požadované znalosti a dovednosti

- XML a jeho specifikace, XSD validace, XML DOM
- HTML DOM, JavaScript
- PHP: ukládání dat, cookies a session, práce s objekty, SimpleXML, práce s databázemi
- analýza požadavků, návrh SW architektury, verzování
- testování, validace a verifikace, API, nasazení a podpora

### Charakteristika zkušební úlohy

Webová aplikace s databází (nebo XML jako úložištěm) řešící podnikový problém. Povinný je jazyk PHP. Součástí bývá autentizace, role, API a zabezpečení proti běžným hrozbám.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a řešený problém
2. Architektura aplikace a použité technologie
3. Datová vrstva: schéma databáze nebo struktura XML + XSD
4. Klíčové funkce a jak jsou implementované
5. Autentizace, role a oprávnění
6. Zabezpečení — SQL injection, XSS, hashování hesel
7. API pro integraci
8. Ukázka běhu

### Na co se doptají (diskuse po prezentaci)

- Jak konkrétně bráníš SQL injection? Ukaž to v kódu.
- Jak ukládáš hesla a proč zrovna tak?
- Rozdíl mezi cookie a session — kde session doopravdy leží?
- Co je XSS a kde ti hrozilo?
- K čemu je XSD a co ti validace zaručí?
- Jak jsi navrhoval API — proč tyhle endpointy?

### Užitečné odkazy

-
