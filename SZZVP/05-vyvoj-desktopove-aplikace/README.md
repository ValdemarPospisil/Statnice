## 5 — Vývoj desktopové aplikace

- [Zadání okruhu (PDF)](../ZadaniOkruhu/SZZVP-SW.pdf)

### Požadované znalosti a dovednosti

- komponenty v ekosystému C# (WPF + XAML) nebo Python (PyQt, Tkinter)
- událostmi řízené programování
- perzistence: databáze (ORM nebo SQL) případně XML/JSON
- asynchronicita a vícevláknové aplikace
- dokumentační komentáře a UML diagramy

### Charakteristika zkušební úlohy

Aplikace s GUI v C# nebo Pythonu, událostmi řízená, objektově navržená, pracující s perzistentními daty a využívající asynchronicitu. Součástí je dokumentace z dokumentačních komentářů a UML diagramy.

### Mé řešení úlohy

<!-- Zadání přijde 3–10 dní předem, na řešení je 5 hodin. Sem popis postupu, odkaz na repo, diagramy. -->

### Kostra prezentace (7–10 min)

1. Zadání a funkční požadavky
2. Architektura — vrstvy, UML diagram tříd
3. GUI a jak je řešeno událostmi řízené chování
4. Datová vrstva: schéma a přístup (ORM / SQL / JSON)
5. Asynchronicita — co běží na pozadí a proč (a jak GUI zůstane responzivní)
6. Ukázka běhu aplikace
7. Dokumentace a testování

### Na co se doptají (diskuse po prezentaci)

- Proč musí dlouhý výpočet běžet mimo hlavní vlákno? Co se stane, když ne?
- Jak z pozadí bezpečně aktualizuješ GUI?
- Vysvětli async/await — co se ve skutečnosti děje.
- Co je MVVM a použil jsi ho?
- Data binding — jak funguje?
- Jak ošetříš současný přístup k databázi?

### Užitečné odkazy

-
