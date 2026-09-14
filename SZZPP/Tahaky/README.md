## Taháky k okruhům SZZPP

Zpět na [rozcestník SZZPP](../).

Krátká shrnutí ke každému z dvanácti okruhů. Doplňují podrobné poznámky ve složkách okruhů — ty jsou na **učení**, tyhle na **rychlé zopakování a nahlédnutí**.

### K čemu to je a k čemu ne

| | |
|---|---|
| ✅ **Rychlé zopakování** před zkouškou | pár minut čtení místo 700řádkového README |
| ✅ **Nahlédnutí do mobilu**, když si nejsi jistý | zvlášť u bash a R syntaxe, která vypadává z hlavy |
| ✅ **Hotový kód k úpravě** | u okruhů 8 a 10 je snazší upravit funkční řešení než psát od nuly |
| ❌ **Není to k odevzdání** | u zkoušky máš jen povolené materiály (tahák Pythonu, SQL, manuálové stránky) |
| ❌ **Nenahrazuje procvičení** | kód přečtený není kód napsaný — úlohy si projdi ve složkách `Kod/` |

### Obsah

| Okruh | Tahák | Typ obsahu |
|---|---|---|
| 1 — Funkce a cykly | [01.md](./01.md) | soupis chyb + opravený kód uzávorkování |
| 2 — Kolekce | [02.md](./02.md) | soupis chyb + hotová funkce |
| 3 — OOP | [03.md](./03.md) | soupis chyb + kompletní třída `Semaphore` |
| 4 — Výběr komponent | [04.md](./04.md) | tabulka účel → komponenty, BIOS, instalace OS |
| 5 — Diagnostika | [05.md](./05.md) | postup + tabulka symptom → příčina |
| 6 — Analogová elektronika | [06.md](./06.md) | všech šest metod řešení obvodů |
| 7 — Digitální elektronika | [07.md](./07.md) | jak začít u dekodéru, MUXu, sedmisegmentovky |
| 8 — Operační systémy | [08.md](./08.md) | **hotový funkční bash skript** |
| 9 — Databáze | [09.md](./09.md) | SQL vzory + normální formy |
| 10 — Zpracování dat | [10.md](./10.md) | **hotový R kód** — dplyr, pivot, ggplot |
| 11 — Multimédia | [11.md](./11.md) | principy formátů, barev, transformací, filtrů |
| 12 — Projektové řízení | [12.md](./12.md) | SMART, SWOT, RACI, rizika |

### Co je u zkoušky skutečně k dispozici

Podle oficiálních zadání v [`ZadaniOkruhu/`](../ZadaniOkruhu/):

| Okruh | Povolené materiály |
|---|---|
| 1, 2, 3 | **tahák Python**, Jupyter notebook |
| 4, 5 | **internet** — ceníky komponent, benchmarkové servery |
| 6 | Python a R na řešení soustav rovnic |
| 7 | datasheet k sedmisegmentovce, tabulkový procesor |
| 8 | **manuálové stránky** (`man`) |
| 9 | **tahák SQL** pro PostgreSQL |
| 10 | odkazy na příručky a taháky přímo v zadání, RStudio |
| 11, 12 | MS Office / LibreOffice |

**Okruhy 4 a 5 jsou jediné s internetem** — tam se tahák nejmíň hodí, protože si můžeš vyhledat cokoli. Naopak u **8 a 10** máš jen `man` respektive příručky, takže hotový kód v hlavě (nebo aspoň jeho struktura) je největší výhoda.

### Ověřeno

Kódy v tahácích jsou spuštěné a funkční:

- Python (okruhy 1, 2, 3) — všechny bloky běží bez chyby
- Bash (okruh 8) — otestován včetně mezer v názvech a velkých písmen v příponách
- SQL (okruh 9) a R (okruh 10) — odpovídají odladěným skriptům ve složkách `Kod/`
