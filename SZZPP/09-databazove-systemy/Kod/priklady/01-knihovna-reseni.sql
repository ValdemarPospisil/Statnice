-- ============================================================
-- Příklad 1 — knihovna (řešení)
-- ============================================================
-- Zadaný návrh měl tyto vady:
--   1. autor = "Karel Čapek, 1890–1938"   -> 1. NF + vlastní entita autor
--   2. jméno = "Jan Novák"                -> 1. NF: jmeno + prijmeni
--   3. adresa = "Ústí nad Labem, 40001"   -> 1. NF: mesto + psc
--   4. "počet výpůjček" u knihy           -> odvoditelný, SMAZÁN
--   5. výpůjčka je M:N S ATRIBUTY (datum) -> plnohodnotná entita

DROP TABLE IF EXISTS vypujcka;
DROP TABLE IF EXISTS kniha;
DROP TABLE IF EXISTS autor;
DROP TABLE IF EXISTS ctenar;

CREATE TABLE autor (
    id_autora  SERIAL      PRIMARY KEY,
    jmeno      VARCHAR(50) NOT NULL,
    prijmeni   VARCHAR(50) NOT NULL,
    rok_naroz  SMALLINT,                    -- může být neznámý -> bez NOT NULL
    rok_umrti  SMALLINT,
    CHECK (rok_umrti IS NULL OR rok_naroz IS NULL OR rok_umrti >= rok_naroz)
);

CREATE TABLE kniha (
    id_knihy  SERIAL       PRIMARY KEY,
    nazev     VARCHAR(200) NOT NULL,
    isbn      CHAR(13)     UNIQUE,          -- ISBN-13; UNIQUE, ale smí být NULL
    rok_vydani SMALLINT,
    id_autora INTEGER      NOT NULL REFERENCES autor(id_autora) ON DELETE RESTRICT
    -- žádný "pocet_vypujcek" — spočítá se z tabulky vypujcka
);

CREATE TABLE ctenar (
    id_ctenare   SERIAL      PRIMARY KEY,
    jmeno        VARCHAR(50) NOT NULL,
    prijmeni     VARCHAR(50) NOT NULL,
    mesto        VARCHAR(80) NOT NULL,      -- vada 3: rozděleno
    psc          CHAR(5)     NOT NULL CHECK (psc ~ '^[0-9]{5}$'),
    clenstvi_od  DATE        NOT NULL DEFAULT CURRENT_DATE
);

-- Výpůjčka NENÍ jen technická spojka — má vlastní atributy,
-- takže je to plnohodnotná entita s vlastním PK.
CREATE TABLE vypujcka (
    id_vypujcky    SERIAL  PRIMARY KEY,
    id_ctenare     INTEGER NOT NULL REFERENCES ctenar(id_ctenare) ON DELETE RESTRICT,
    id_knihy       INTEGER NOT NULL REFERENCES kniha(id_knihy)    ON DELETE RESTRICT,
    datum_pujceni  DATE    NOT NULL DEFAULT CURRENT_DATE,
    datum_vraceni  DATE,                    -- NULL = ještě nevrácena
    CHECK (datum_vraceni IS NULL OR datum_vraceni >= datum_pujceni)
);

-- Táž kniha se může půjčit vícekrát (postupně), takže složený PK
-- (ctenar, kniha) by byl CHYBA. Ale jedna kniha nesmí být půjčená
-- dvěma lidem NARÁZ -> částečný unikátní index:
CREATE UNIQUE INDEX idx_kniha_pujcena
    ON vypujcka(id_knihy) WHERE datum_vraceni IS NULL;

INSERT INTO autor (jmeno, prijmeni, rok_naroz, rok_umrti) VALUES
    ('Karel','Čapek',1890,1938),
    ('Bohumil','Hrabal',1914,1997),
    ('Milan','Kundera',1929,2023);

INSERT INTO kniha (nazev, isbn, rok_vydani, id_autora) VALUES
    ('Válka s mloky','9788072038541',1936,1),
    ('R.U.R.','9788072038558',1920,1),
    ('Postřižiny','9788072038565',1976,2),
    ('Nesnesitelná lehkost bytí',NULL,1984,3);

INSERT INTO ctenar (jmeno, prijmeni, mesto, psc, clenstvi_od) VALUES
    ('Jan','Novák','Ústí nad Labem','40001','2024-01-15'),
    ('Petra','Svobodová','Praha','11000','2023-06-01'),
    ('Tomáš','Marek','Teplice','41501','2025-03-10');

INSERT INTO vypujcka (id_ctenare, id_knihy, datum_pujceni, datum_vraceni) VALUES
    (1,1,'2026-08-01',NULL),        -- Novák má Mloky půjčené
    (1,3,'2026-07-01','2026-07-20'),-- a Postřižiny už vrátil
    (2,2,'2026-08-15',NULL);        -- Svobodová má R.U.R.
    -- Marek nemá nic -> ukáže třetí dotaz

\echo '=== 1) Které knihy má který čtenář PŮJČENÉ (nevrácené) ==='
SELECT c.prijmeni || ' ' || c.jmeno AS ctenar,
       k.nazev                       AS kniha,
       v.datum_pujceni
FROM ctenar c
JOIN vypujcka v ON v.id_ctenare = c.id_ctenare
JOIN kniha    k ON k.id_knihy   = v.id_knihy
WHERE v.datum_vraceni IS NULL      -- IS NULL, nikdy "= NULL"!
ORDER BY c.prijmeni;

\echo ''
\echo '=== 2) Počet výpůjček podle autora ==='
-- LEFT JOIN, aby se objevil i autor, kterého si nikdo nepůjčil.
SELECT a.prijmeni || ' ' || a.jmeno AS autor,
       COUNT(v.id_vypujcky)          AS pocet_vypujcek
FROM autor a
LEFT JOIN kniha    k ON k.id_autora = a.id_autora
LEFT JOIN vypujcka v ON v.id_knihy  = k.id_knihy
GROUP BY a.id_autora, a.prijmeni, a.jmeno
ORDER BY pocet_vypujcek DESC, a.prijmeni;

\echo ''
\echo '=== 3) Čtenáři, kteří nemají nic půjčené ==='
-- Idiom "LEFT JOIN ... WHERE ... IS NULL" = antijoin (co NENÍ v druhé tabulce)
SELECT c.prijmeni || ' ' || c.jmeno AS ctenar, c.mesto
FROM ctenar c
LEFT JOIN vypujcka v
       ON v.id_ctenare = c.id_ctenare AND v.datum_vraceni IS NULL
WHERE v.id_vypujcky IS NULL
ORDER BY c.prijmeni;

\echo ''
\echo '=== BONUS: nejaktivnější čtenáři (i vrácené) ==='
SELECT c.prijmeni, COUNT(v.id_vypujcky) AS celkem_vypujcek
FROM ctenar c
LEFT JOIN vypujcka v ON v.id_ctenare = c.id_ctenare
GROUP BY c.id_ctenare, c.prijmeni
HAVING COUNT(v.id_vypujcky) > 0
ORDER BY celkem_vypujcek DESC;
