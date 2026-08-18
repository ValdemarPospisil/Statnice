## 8 — Operační systémy

- [Zadání okruhu (PDF)](../ZadaniOkruhu/OPS.pdf)

### Požadované znalosti a dovednosti

- struktura souborového systému Linuxu, příkazy pro práci se soubory a adresáři (mkdir, cp, mv, rm, ls, find)
- práva v Linuxu a řízení procesů
- kolony a textové nástroje (cat, cut, tr, sort, grep)
- jednoduché skripty (proměnné, cykly, podmínky)

### Charakteristika zkušební úlohy

Napsat BASH skript řešící dílčí úlohu správy systému. K dispozici je Linux včetně manuálových stránek. Odevzdává se funkční skript.

### Postup u zkoušky (60 min přípravy)

1. Přečíst zadání a rozdělit na minimální požadavky a rozšiřující — minimální udělat první.
2. Zkontrolovat počet a platnost parametrů (`$#`, `[ -d "$1" ]`).
3. Jádro postavit na koloně: `find` → `while read` nebo `xargs`.
4. Ošetřit mezery v názvech souborů (`-print0`, uvozovky kolem proměnných).
5. Otestovat na reálném adresáři, ne jen přečíst.

### Co si nacvičit

- [ ] Vyřešit ukázkovou úlohu z PDF (CSV se seznamem obrázků) včetně rozšíření
- [ ] `find` s `-name`, `-type`, `-size`, `-exec`
- [ ] `stat` pro velikost souboru, `sort -t, -k2 -n` pro CSV
- [ ] Cykly `for`/`while`, podmínky `if`, `case`, aritmetika `$(( ))`
- [ ] `grep`, `cut`, `tr`, `sed`, `awk` v koloně
- [ ] Práva: `chmod`, `chown`, číselný i symbolický zápis; `ps`, `kill`, `&`, `jobs`

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

### Na co se doptají

- Proč dáváš proměnné do uvozovek?
- Co se stane, když má soubor v názvu mezeru nebo apostrof?
- Jak zjistíš návratový kód předchozího příkazu a k čemu ti je?
- Vysvětli práva 755 a 644 — co znamenají a proč zrovna ta.

### Užitečné odkazy

-
