## 6 — Vývoj mobilní aplikace

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-SW.pdf)

### Požadované znalosti a dovednosti

- Java (základy) nebo C#, Android SDK
- aktivity a činnost na pozadí
- přístup k webovým službám, zpracování JSON a XML
- využití senzorů včetně pozičních služeb
- ukládání dat do databáze (SQLite)
- UML

### Charakteristika zkušební úlohy

Jednoduchá aplikace pro Android se dvěma aktivitami a činností na pozadí. Odevzdává se Git projekt, UML diagramy vlastní logiky, dokumentace pro vývojáře i pro uživatele.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a funkční požadavky
2. Struktura aplikace: aktivity, navigace mezi nimi, UML
3. Práce na pozadí — jak je řešena a proč tak
4. Přístup k webové službě a parsování odpovědi
5. Perzistence v SQLite a offline režim
6. Ukázka běhu
7. Dokumentace

### Na co se doptají (diskuse po prezentaci)

- Popiš životní cyklus aktivity — co se stane při otočení displeje?
- Jak předáváš data mezi aktivitami?
- Proč nesmí síťový požadavek běžet na hlavním vlákně?
- Jak funguje periodická aktualizace na pozadí a co jí brání v moderním Androidu?
- Jak řešíš oprávnění za běhu (poloha, síť)?
- Jak zajistíš, že se offline zobrazí jen časově relevantní data?

### Užitečné odkazy

-
