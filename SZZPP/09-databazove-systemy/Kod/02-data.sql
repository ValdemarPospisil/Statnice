-- ============================================================
-- Ukázková data (~3 řádky na tabulku podle zadání)
-- Spuštění:  \i 02-data.sql
-- ============================================================
--
-- Data jsou zvolená ZÁMĚRNĚ tak, aby dotazy měly co ukázat:
--   * "Matematická informatika" má jen jednoho studenta
--   * "Fyzikální informatika" nemá ŽÁDNÉHO studenta  -> ukáže LEFT JOIN
--   * "Nikým nezapsaný předmět" nemá žádný zápis      -> ukáže LEFT JOIN
--   * Jiří Novák má tři předměty, Petr Černý jeden

TRUNCATE zapis, student, predmet, studijni_program RESTART IDENTITY CASCADE;

INSERT INTO studijni_program (nazev, stupen, doba_roky) VALUES
    ('Aplikovaná informatika',  'Bc',  3),
    ('Informační systémy',      'Mgr', 2),
    ('Matematická informatika', 'Bc',  3),
    ('Fyzikální informatika',   'Bc',  3);   -- schválně bez studentů

INSERT INTO student (jmeno, prijmeni, datum_narozeni, id_programu) VALUES
    ('Jiří',  'Novák',      '2006-05-20', 1),
    ('Anna',  'Dvořáková',  '2005-11-03', 1),
    ('Petr',  'Černý',      '2004-02-14', 2),
    ('Eva',   'Malá',       '2006-08-30', 3);

INSERT INTO predmet (nazev, rocnik, semestr) VALUES
    ('Relační databáze bez SQL', 2, 'LS'),
    ('Operační systémy',         2, 'ZS'),
    ('Algoritmizace',            1, 'ZS'),
    ('Základy elektroniky',      1, 'LS'),
    ('Nikým nezapsaný předmět',  3, 'ZS');   -- schválně bez zápisů

INSERT INTO zapis (id_studenta, id_predmetu) VALUES
    (1, 1), (1, 2), (1, 3),      -- Novák: tři předměty
    (2, 1), (2, 3),              -- Dvořáková: dva
    (3, 2),                      -- Černý: jeden
    (4, 3), (4, 4);              -- Malá: dva

\echo 'Data vložena.'
