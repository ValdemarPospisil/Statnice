# Kontext repozitáře

## Účel

Příprava na státní závěrečné zkoušky na katedře informatiky (UJEP). Cílem **není kód ani produkční projekt**, ale to, aby si Valdemar látku zapamatoval a uměl ji **říct nahlas u zkoušky**. Tomu podřizuj vše ostatní.

Plán přípravy a rozbor obtížnosti okruhů je v [PLAN.md](./PLAN.md).

## Struktura

Tři zkoušky, každá má vlastní složku s `README.md` (rozcestník + pravidla zkoušky) a `ZadaniOkruhu/` s oficiálními PDF:

| Složka | Zkouška | Formát |
|---|---|---|
| `SZZTP/` | Teoretické základy | 15 min příprava, 15 min ústní, **bez počítače** |
| `SZZPP/` | Povinný základ | 60 min praktická úloha u počítače + 20 min obhajoba |
| `SZZVP/` | Volitelné bloky | 5 h úloha doma + 7–10 min prezentace + diskuse |

Každá otázka má **vlastní složku** `NN-popisny-nazev/` s `README.md`. Číslování je oficiální — u `SZZTP/` chybí 6 a 7, protože jsou to vyřazené okruhy; nedoplňuj je. Doplňkové soubory (kód, obrázky, `.qmd`, `.sql`) patří do složky dané otázky, ne do nových míst.

## Šablona poznámek

Nadpisy v `README.md` otázky drž tak, jak jsou. Struktura se liší podle zkoušky:

- **SZZTP** — `Osnova výkladu (15 min)` · `Klíčové definice` · `Příklad na papír` · `Na co se doptají` · `Užitečné odkazy`
- **SZZPP** — navíc `Postup u zkoušky (60 min přípravy)` · `Co si nacvičit` (checkboxy) · `Poznámky`
- **SZZVP** — `Mé řešení úlohy` · `Kostra prezentace (7–10 min)` · `Na co se doptají`

`Osnova výkladu` je jádro celé přípravy: musí se vejít na jednu A4 a musí jít odvyprávět bez opory. Když ji rozšiřuješ, hlídej, aby nenabobtnala — radši zkrať.

## Jak psát

- **Česky**, srozumitelně, tónem vhodným k ústní obhajobě — ne suché definice bez souvislostí.
- Spíš **odrážky než odstavce**. Dlouhé eseje piš jen na výslovné vyžádání.
- U algoritmů a datových struktur vždy uveď **časovou (a kde dává smysl paměťovou) složitost** a krátkou intuici — proč to funguje, jaký platí invariant.
- Matematiku sázej do `$…$` a `$$…$$`.
- Odkazy jako autonomní: `<https://…>`. Nevymýšlej URL — radši žádný odkaz než neexistující.
- Kód v ohraničených blocích s uvedeným jazykem. Python u okruhů APR, BASH u OPS, SQL u databází, R u ZZD, C# u SZZVP-SW.
- **Zvýrazňuj pasti a časté chyby** — u ústní zkoušky rozhodují právě ty (např. správná interpretace intervalu spolehlivosti, `O` vs. `Ω`).
- Kde se okruhy překrývají, propoj je odkazem na složku druhého okruhu. Překryvy jsou vypsané v [PLAN.md](./PLAN.md).

## Web s vykreslenou matematikou

Repozitář se při každém pushi do `main` nasazuje na <https://valdemarpospisil.github.io/Statnice/> (Jekyll + GitHub Pages, workflow `.github/workflows/pages.yml`). Rozcestník `index.md` se generuje při buildu skriptem `generate_index.py` — **needituj ho ručně**, je v `.gitignore`.

Pozor na jednu věc: kramdown při buildu převede zdrojové `$…$` a `$$…$$` na `\(…\)` a `\[…\]`. MathJax v `_includes/head-custom.html` proto **musí** mít v delimiterech obě varianty. Kdyby se přestaly vzorce vykreslovat, hledej chybu tady.

Aby se okruh objevil v rozcestníku, musí být složka pojmenovaná `NN-nazev` a mít `README.md` s prvním nadpisem ve tvaru `## N — Název`.

## Konzistence

Nový text nepiš v jiném stylu, než jsou už vypracované otázky. Jako vzor ber ty nejlépe vyplněné — ověř aktuální stav ve složkách. Nezakládej nové `.md` soubory ani nepřepisuj věci napříč repozitářem, pokud o to Valdemar výslovně nepožádá.

## Zdroj pravdy

Oficiální PDF v `ZadaniOkruhu/` jsou závazné znění okruhů. Než začneš psát obsah k nějaké otázce, přečti si příslušné PDF (`pdftotext -layout`) — ukázkové úlohy v nich jsou reprezentativní a u SZZPP i SZZVP prakticky určují, co se bude zkoušet.

Repozitář kamaráda, který už státnice složil, je v `/home/valdemar/Dokumenty/SZZ`. Má **prakticky stejný výběr okruhů**, takže je to použitelný zdroj inspirace i kontroly — ale je to cizí repozitář, **nikdy do něj nezapisuj**.
