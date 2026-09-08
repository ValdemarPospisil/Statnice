-- ============================================================
-- Dotazy ze zadání + demonstrace rozdílu INNER / LEFT JOIN
-- Spuštění:  \i 03-dotazy.sql
-- Výstupy do souboru:  \o vystup.txt  potom  \i 03-dotazy.sql  potom  \o
-- ============================================================

\echo '=== a) Všichni studenti a jména předmětů, které studují ==='
-- INNER JOIN je tu správný: zadání chce studenty A předměty, které studují.
-- Student bez zápisu by měl prázdný předmět, což nedává smysl.
-- Pozor: student se opakuje pro každý předmět — to je u M:N normální.
SELECT s.prijmeni || ' ' || s.jmeno AS student,
       p.nazev                      AS predmet
FROM student s
JOIN zapis   z ON z.id_studenta = s.id_studenta
JOIN predmet p ON p.id_predmetu = z.id_predmetu
ORDER BY s.prijmeni, p.nazev;

\echo ''
\echo '=== b) Studijní programy a počty studentů, vzestupně podle názvu ==='
-- LEFT JOIN je tu KLÍČOVÝ: program bez studentů se musí objevit s nulou.
-- COUNT(s.id_studenta) místo COUNT(*): u prázdného programu vyrobí LEFT JOIN
-- jeden řádek s NULL, takže COUNT(*) by dal 1, ale COUNT(sloupec) správně 0.
SELECT sp.nazev                  AS program,
       sp.stupen,
       COUNT(s.id_studenta)      AS pocet_studentu
FROM studijni_program sp
LEFT JOIN student s ON s.id_programu = sp.id_programu
GROUP BY sp.id_programu, sp.nazev, sp.stupen
ORDER BY sp.nazev ASC;

\echo ''
\echo '=== c) Předměty seskupené podle ročníku (agregace řetězce) ==='
-- STRING_AGG je přesně to, co zadání myslí "agregací řetězce".
-- ORDER BY UVNITŘ agregace zajistí stabilní pořadí ve slepenci —
-- bez něj je pořadí nedefinované.
SELECT rocnik,
       COUNT(*)                              AS pocet_predmetu,
       STRING_AGG(nazev, ', ' ORDER BY nazev) AS predmety
FROM predmet
GROUP BY rocnik
ORDER BY rocnik;

\echo ''
\echo '=== BONUS: počet zapsaných na předmět (nahrazuje smazaný atribut) ==='
-- Tohle je odpověď na vadu 4 v zadání: "počet studentů" se nedrží
-- ve sloupci, spočítá se dotazem a je tím vždy aktuální.
SELECT p.nazev,
       p.rocnik,
       p.semestr,
       COUNT(z.id_studenta) AS pocet_zapsanych
FROM predmet p
LEFT JOIN zapis z ON z.id_predmetu = p.id_predmetu
GROUP BY p.id_predmetu, p.nazev, p.rocnik, p.semestr
ORDER BY pocet_zapsanych DESC, p.nazev;

\echo ''
\echo '=== DEMONSTRACE: INNER JOIN zahodí předmět bez zápisů ==='
SELECT p.nazev, COUNT(z.id_studenta) AS pocet
FROM predmet p
JOIN zapis z ON z.id_predmetu = p.id_predmetu
GROUP BY p.id_predmetu, p.nazev
ORDER BY p.nazev;

\echo ''
\echo '=== DEMONSTRACE: LEFT JOIN ho ukáže s nulou ==='
SELECT p.nazev, COUNT(z.id_studenta) AS pocet
FROM predmet p
LEFT JOIN zapis z ON z.id_predmetu = p.id_predmetu
GROUP BY p.id_predmetu, p.nazev
ORDER BY p.nazev;

\echo ''
\echo '=== PAST: COUNT(*) vs COUNT(sloupec) u LEFT JOIN ==='
-- COUNT(*) počítá ŘÁDKY (LEFT JOIN vyrobil jeden s NULL) -> 1
-- COUNT(sloupec) ignoruje NULL                            -> 0
SELECT p.nazev,
       COUNT(*)             AS pocet_hvezdicka,
       COUNT(z.id_studenta) AS pocet_sloupec
FROM predmet p
LEFT JOIN zapis z ON z.id_predmetu = p.id_predmetu
WHERE p.nazev = 'Nikým nezapsaný předmět'
GROUP BY p.id_predmetu, p.nazev;

\echo ''
\echo '=== WHERE vs HAVING ==='
-- WHERE filtruje ŘÁDKY před seskupením, HAVING SKUPINY po seskupení.
SELECT rocnik, COUNT(*) AS pocet
FROM predmet
WHERE semestr = 'ZS'        -- na sloupec -> WHERE
GROUP BY rocnik
HAVING COUNT(*) >= 1        -- na agregaci -> HAVING
ORDER BY rocnik;
