-- ============================================================
-- Okruh 9 — schéma pro ukázkovou úlohu (studenti a předměty)
-- PostgreSQL. Spuštění:  \i 01-schema.sql
-- ============================================================
--
-- Zadaný konceptuální návrh měl PĚT vad, které tady jsou opravené:
--   1. "jméno" = "Jiří Novák"                 -> 1. NF: jmeno + prijmeni
--   2. "studijní program" = "Aplik. inf., Bc" -> 1. NF: nazev + stupen
--   3. "doba trvání programu" u studenta      -> 3. NF: vlastní tabulka
--   4. "počet studentů" u předmětu            -> odvoditelný, SMAZÁN
--   5. "ročník a semestr" = "2. LS"           -> 1. NF: rocnik + semestr
--
-- Pořadí CREATE TABLE je dané cizími klíči: nadřazené tabulky první.

DROP TABLE IF EXISTS zapis;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS predmet;
DROP TABLE IF EXISTS studijni_program;

-- --- 1) studijní program -------------------------------------
-- Vznikl kvůli vadě 3: doba_roky závisí na programu, ne na studentovi.
-- Tranzitivní závislost  student -> program -> doba_roky  porušovala 3. NF.
CREATE TABLE studijni_program (
    id_programu SERIAL       PRIMARY KEY,
    nazev       VARCHAR(100) NOT NULL,
    stupen      VARCHAR(3)   NOT NULL CHECK (stupen IN ('Bc','Mgr','PhD')),
    doba_roky   SMALLINT     NOT NULL CHECK (doba_roky BETWEEN 1 AND 6),
    -- "Aplikovaná informatika" existuje jako Bc i Mgr -> jednoznačná
    -- je až KOMBINACE názvu a stupně, ne název samotný.
    UNIQUE (nazev, stupen)
);

-- --- 2) student ----------------------------------------------
CREATE TABLE student (
    id_studenta    SERIAL      PRIMARY KEY,
    jmeno          VARCHAR(50) NOT NULL,     -- vada 1: rozděleno
    prijmeni       VARCHAR(50) NOT NULL,
    datum_narozeni DATE        NOT NULL,
    id_programu    INTEGER     NOT NULL      -- vada 3: FK místo duplicity
                   REFERENCES studijni_program(id_programu)
                   ON DELETE RESTRICT        -- program se nesmaže, dokud má studenty
);

-- --- 3) předmět ----------------------------------------------
CREATE TABLE predmet (
    id_predmetu SERIAL       PRIMARY KEY,
    nazev       VARCHAR(100) NOT NULL UNIQUE,
    rocnik      SMALLINT     NOT NULL CHECK (rocnik BETWEEN 1 AND 6),
    semestr     VARCHAR(2)   NOT NULL CHECK (semestr IN ('ZS','LS'))
    -- POZOR: žádný sloupec "pocet_studentu"!
    -- Vada 4 — je odvoditelný přes COUNT z tabulky zapis.
    -- Kdyby tu byl, musel by se ručně aktualizovat při každém zápisu
    -- a při jednom opomenutí by přestal odpovídat skutečnosti.
);

-- --- 4) zápis (rozklad M:N) ----------------------------------
-- Vztah "student studuje předmět" je M:N a relační model ho neumí
-- vyjádřit přímo -> vazební tabulka.
CREATE TABLE zapis (
    id_studenta INTEGER NOT NULL
                REFERENCES student(id_studenta)  ON DELETE CASCADE,
    id_predmetu INTEGER NOT NULL
                REFERENCES predmet(id_predmetu)  ON DELETE CASCADE,
    -- SLOŽENÝ primární klíč dělá dvě věci naráz:
    --   a) identifikuje řádek
    --   b) BRÁNÍ dvojímu zápisu téhož studenta na týž předmět
    PRIMARY KEY (id_studenta, id_predmetu)
);

-- Volitelně: index na cizí klíč zrychlí dotazy "kdo studuje předmět X".
-- (PostgreSQL vytvoří index pro PK automaticky, ale ten je na pořadí
--  (id_studenta, id_predmetu) — pro hledání podle předmětu se hodí druhý.)
CREATE INDEX idx_zapis_predmet ON zapis(id_predmetu);

\echo 'Schéma vytvořeno. Kontrola: \dt a \d zapis'
