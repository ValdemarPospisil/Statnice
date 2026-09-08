-- ============================================================
-- Příklad 2 — objednávky v e-shopu (řešení)
-- ============================================================
-- Vady zadaného návrhu:
--   1. "seznam produktů s množstvím" v objednávce -> 1. NF, vazební tabulka
--   2. "celková cena" u objednávky                -> odvoditelná, SMAZÁNA
--   3. kategorie = "Elektronika/Notebooky"        -> 1. NF, hierarchie
--
-- KLÍČOVÁ VĚC: cena se ukládá i do položky objednávky. Cena produktu
-- se v čase mění, ale na faktuře musí zůstat ta, za kterou se prodalo.

DROP TABLE IF EXISTS objednavka_polozka;
DROP TABLE IF EXISTS objednavka;
DROP TABLE IF EXISTS produkt;
DROP TABLE IF EXISTS kategorie;
DROP TABLE IF EXISTS zakaznik;

CREATE TABLE kategorie (
    id_kategorie  SERIAL      PRIMARY KEY,
    nazev         VARCHAR(80) NOT NULL,
    id_nadrazene  INTEGER     REFERENCES kategorie(id_kategorie),  -- hierarchie!
    UNIQUE (nazev, id_nadrazene)
);

CREATE TABLE zakaznik (
    id_zakaznika SERIAL       PRIMARY KEY,
    jmeno        VARCHAR(50)  NOT NULL,
    prijmeni     VARCHAR(50)  NOT NULL,
    email        VARCHAR(120) NOT NULL UNIQUE,
    mesto        VARCHAR(80)  NOT NULL
);

CREATE TABLE produkt (
    id_produktu  SERIAL        PRIMARY KEY,
    nazev        VARCHAR(150)  NOT NULL,
    cena         NUMERIC(10,2) NOT NULL CHECK (cena > 0),   -- NUMERIC, ne REAL!
    id_kategorie INTEGER       NOT NULL REFERENCES kategorie(id_kategorie)
);

CREATE TABLE objednavka (
    id_objednavky SERIAL  PRIMARY KEY,
    id_zakaznika  INTEGER NOT NULL REFERENCES zakaznik(id_zakaznika) ON DELETE RESTRICT,
    datum         DATE    NOT NULL DEFAULT CURRENT_DATE
    -- žádná "celkova_cena" — spočítá se SUM z položek
);

CREATE TABLE objednavka_polozka (
    id_objednavky INTEGER       NOT NULL REFERENCES objednavka(id_objednavky) ON DELETE CASCADE,
    id_produktu   INTEGER       NOT NULL REFERENCES produkt(id_produktu)      ON DELETE RESTRICT,
    mnozstvi      SMALLINT      NOT NULL CHECK (mnozstvi > 0),
    cena_za_kus   NUMERIC(10,2) NOT NULL CHECK (cena_za_kus > 0),
    -- ^ historická cena! Kdyby se sem nedávala, změna ceny produktu
    --   by přepsala i staré faktury.
    PRIMARY KEY (id_objednavky, id_produktu)
);

INSERT INTO kategorie (nazev, id_nadrazene) VALUES
    ('Elektronika', NULL);
INSERT INTO kategorie (nazev, id_nadrazene) VALUES
    ('Notebooky', 1), ('Telefony', 1);
INSERT INTO kategorie (nazev, id_nadrazene) VALUES
    ('Knihy', NULL);

INSERT INTO zakaznik (jmeno, prijmeni, email, mesto) VALUES
    ('Jan','Novák','novak@example.com','Ústí nad Labem'),
    ('Petra','Svobodová','svobodova@example.com','Praha'),
    ('Tomáš','Marek','marek@example.com','Brno');   -- bez objednávky

INSERT INTO produkt (nazev, cena, id_kategorie) VALUES
    ('Notebook Lenovo ThinkPad', 24990.00, 2),
    ('Notebook Dell XPS',        32500.00, 2),
    ('Telefon Samsung Galaxy',   11990.00, 3),
    ('Kniha SQL pro praxi',        450.00, 4);

INSERT INTO objednavka (id_zakaznika, datum) VALUES
    (1,'2026-08-01'), (1,'2026-08-20'), (2,'2026-08-15');

INSERT INTO objednavka_polozka (id_objednavky, id_produktu, mnozstvi, cena_za_kus) VALUES
    (1, 1, 1, 24990.00),
    (1, 4, 2,   450.00),
    (2, 3, 1, 11990.00),
    (3, 2, 1, 32500.00),
    (3, 4, 1,   450.00);

\echo '=== 1) Objednávky s SPOČÍTANOU celkovou cenou ==='
SELECT o.id_objednavky,
       z.prijmeni || ' ' || z.jmeno            AS zakaznik,
       o.datum,
       COUNT(op.id_produktu)                    AS pocet_polozek,
       SUM(op.mnozstvi * op.cena_za_kus)        AS celkem_kc
FROM objednavka o
JOIN zakaznik           z  ON z.id_zakaznika  = o.id_zakaznika
JOIN objednavka_polozka op ON op.id_objednavky = o.id_objednavky
GROUP BY o.id_objednavky, z.prijmeni, z.jmeno, o.datum
ORDER BY celkem_kc DESC;

\echo ''
\echo '=== 2) TOP 3 nejprodávanější produkty (podle množství) ==='
SELECT p.nazev,
       SUM(op.mnozstvi)                   AS prodano_kusu,
       SUM(op.mnozstvi * op.cena_za_kus)  AS obrat_kc
FROM produkt p
JOIN objednavka_polozka op ON op.id_produktu = p.id_produktu
GROUP BY p.id_produktu, p.nazev
ORDER BY prodano_kusu DESC, obrat_kc DESC
LIMIT 3;

\echo ''
\echo '=== 3) Obrat podle kategorií (včetně nadřazené) ==='
SELECT COALESCE(nad.nazev, k.nazev)               AS hlavni_kategorie,
       k.nazev                                     AS podkategorie,
       COALESCE(SUM(op.mnozstvi * op.cena_za_kus), 0) AS obrat_kc
FROM kategorie k
LEFT JOIN kategorie          nad ON nad.id_kategorie = k.id_nadrazene
LEFT JOIN produkt            p   ON p.id_kategorie   = k.id_kategorie
LEFT JOIN objednavka_polozka op  ON op.id_produktu   = p.id_produktu
GROUP BY k.id_kategorie, k.nazev, nad.nazev
ORDER BY obrat_kc DESC;

\echo ''
\echo '=== 4) Zákazníci BEZ objednávky (antijoin) ==='
SELECT z.prijmeni || ' ' || z.jmeno AS zakaznik, z.mesto, z.email
FROM zakaznik z
LEFT JOIN objednavka o ON o.id_zakaznika = z.id_zakaznika
WHERE o.id_objednavky IS NULL
ORDER BY z.prijmeni;
