-- ============================================================
-- Ověření, že integritní omezení opravdu fungují
-- Spuštění:  \i 04-omezeni-test.sql
-- KAŽDÝ příkaz níž MÁ selhat — to je smyslem testu.
-- ============================================================
--
-- V psql pokračuje skript i po chybě, takže uvidíš všechny hlášky.
-- Ověřeno: všech šest omezení zabírá.

\echo '=== 1) Duplicitní zápis -> složený PRIMARY KEY'
INSERT INTO zapis (id_studenta, id_predmetu) VALUES (1, 1);
-- ERROR: duplicate key value violates unique constraint "zapis_pkey"
-- TOHLE je odpověď na "jak zabráníš dvojímu zápisu" — zdarma, z PK.

\echo '=== 2) Zápis neexistujícího studenta -> FOREIGN KEY'
INSERT INTO zapis (id_studenta, id_predmetu) VALUES (999, 1);
-- ERROR: insert or update on table "zapis" violates foreign key constraint

\echo '=== 3) Ročník 9 -> CHECK'
INSERT INTO predmet (nazev, rocnik, semestr) VALUES ('Test', 9, 'ZS');
-- ERROR: new row for relation "predmet" violates check constraint

\echo '=== 4) Neplatný semestr -> CHECK'
INSERT INTO predmet (nazev, rocnik, semestr) VALUES ('Test2', 1, 'XX');
-- ERROR: new row for relation "predmet" violates check constraint

\echo '=== 5) Duplicitní název předmětu -> UNIQUE'
INSERT INTO predmet (nazev, rocnik, semestr) VALUES ('Algoritmizace', 1, 'ZS');
-- ERROR: duplicate key value violates unique constraint "predmet_nazev_key"

\echo '=== 6) Chybějící povinná hodnota -> NOT NULL'
INSERT INTO student (jmeno, prijmeni, datum_narozeni, id_programu)
VALUES ('Bez', 'Programu', '2000-01-01', NULL);
-- ERROR: null value in column "id_programu" violates not-null constraint

\echo '=== 7) Smazání programu, který má studenty -> ON DELETE RESTRICT'
DELETE FROM studijni_program WHERE id_programu = 1;
-- ERROR: update or delete on table "studijni_program" violates
--        foreign key constraint on table "student"

\echo '=== 8) A teď co PROJDE: smazání studenta -> ON DELETE CASCADE'
-- Zápisy se smažou s ním, protože zápis bez studenta nemá smysl.
SELECT COUNT(*) AS zapisy_pred FROM zapis WHERE id_studenta = 4;
DELETE FROM student WHERE id_studenta = 4;
SELECT COUNT(*) AS zapisy_po FROM zapis WHERE id_studenta = 4;
\echo '(zapisy_po musí být 0 — CASCADE je smazal)'

\echo ''
\echo 'Pro obnovení dat spusť znovu:  \i 02-data.sql'
