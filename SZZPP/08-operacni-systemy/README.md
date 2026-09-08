## 8 — Operační systémy

- [Zadání okruhu (PDF)](../ZadaniOkruhu/OPS.pdf)

> Napsat **BASH skript** řešící dílčí úlohu správy Linuxu. 60 minut u počítače s **manuálovými stránkami** a vstupními daty, pak 20 minut obhajoby. Odevzdává se **funkční skript**.

**Máš k dispozici `man` a reálná data** — takže se neučíš přepínače nazpaměť, ale **postup a pasti**. Zadání je vždy rozdělené na *minimální požadavky* a *rozšiřující*; udělej nejdřív minimální, ať máš co odevzdat.

> **Nejčastější způsob, jak tenhle okruh pokazit:** napsat skript, který funguje na `soubor.jpg` a rozsype se na `foto s mezerou.jpg`. Mezery a diakritika v názvech jsou **první věc, kterou komise vyzkouší** — a v testovacích datech budou. [Jak se tomu vyhnout](#past-číslo-jedna-mezery-v-názvech).

Hotové skripty ke spuštění jsou ve složce [`Kod/`](./Kod/).

---

### Požadované znalosti a dovednosti

<!-- Podle PDF. Nejdřív souhrn, pak výklad s příklady. -->

#### Souhrn na jednom místě

| Co | K čemu | Zapamatuj si | Kde |
|---|---|---|---|
| `ls`, `cd`, `pwd` | pohyb a výpis | `ls -la` (i skryté, podrobně), `ls -lh` (čitelné velikosti) | [↓](#soubory-a-adresáře) |
| `mkdir`, `rm`, `cp`, `mv` | správa souborů | `mkdir -p` (i rodiče), `rm -r` (rekurzivně), `cp -r` | [↓](#soubory-a-adresáře) |
| `find` | hledání | `-type f`, **`-iname`** (bez ohledu na velikost), **`-print0`** | [↓](#find--nejdůležitější-nástroj-okruhu) |
| `stat` | info o souboru | `stat -c%s` = velikost v bajtech | [↓](#velikost-a-metadata) |
| `du`, `df` | místo na disku | `du -sh` (součet adresáře), `df -h` (volné místo) | [↓](#velikost-a-metadata) |
| `cat`, `head`, `tail` | výpis obsahu | `tail -f` (sleduje přírůstky) | [↓](#textové-nástroje-a-kolony) |
| `grep` | filtrování řádků | `-i` nerozlišuje velikost, `-v` obrátí, `-r` rekurzivně, `-c` počet | [↓](#textové-nástroje-a-kolony) |
| `cut` | výběr sloupců | `-d,` oddělovač, `-f2` druhý sloupec | [↓](#textové-nástroje-a-kolony) |
| `sort` | řazení | **`-n`** číselně, `-r` obráceně, `-t,` `-k2` podle 2. sloupce | [↓](#textové-nástroje-a-kolony) |
| `tr` | záměna znaků | `tr ' ' '_'`, `tr -d` maže | [↓](#textové-nástroje-a-kolony) |
| `wc` | počítání | `-l` řádky, `-c` bajty, `-w` slova | [↓](#textové-nástroje-a-kolony) |
| `awk`, `sed` | pokročilé zpracování | `awk -F, '{s+=$2} END{print s}'` — součet sloupce | [↓](#awk-a-sed-když-kolona-nestačí) |
| **kolona** (pipe) `\|` | výstup jednoho na vstup druhého | čte se zleva doprava jako výrobní linka | [↓](#textové-nástroje-a-kolony) |
| proměnné | `x=5`, `"$x"` | **žádné mezery** kolem `=`, **vždy do uvozovek** | [↓](#proměnné-a-parametry) |
| `$1`, `$@`, `$#` | parametry skriptu | `$#` počet, `"$@"` všechny (v uvozovkách!) | [↓](#proměnné-a-parametry) |
| `if`, `test`, `[ ]` | podmínky | `-d` adresář, `-f` soubor, `-r` čitelný, `-z` prázdný řetězec | [↓](#podmínky) |
| `for`, `while` | cykly | `while IFS= read -r` na čtení řádků | [↓](#cykly) |
| `$(( ))` | aritmetika | `pocet=$((pocet + 1))` — bash umí jen celá čísla | [↓](#aritmetika) |
| `$?` | návratový kód | **0 = úspěch**, cokoli jiného chyba | [↓](#návratové-kódy) |
| `chmod`, `chown` | práva | `755` = rwxr-xr-x, `644` = rw-r--r-- | [↓](#práva) |
| `ps`, `kill`, `&` | procesy | `ps aux`, `kill -9` až jako poslední možnost | [↓](#procesy) |

**Tři věci, které rozhodují o úspěchu:** `find -print0` s `while read -d ''` (mezery), uvozovky kolem každé proměnné, a kontrola parametrů na začátku.

#### Soubory a adresáře

```bash
ls -la              # vše včetně skrytých, podrobný výpis
ls -lh              # velikosti čitelně (4.0K, 1.2M)
ls -lt              # setříděno podle času, nejnovější první

mkdir -p a/b/c      # vytvoří i chybějící rodiče (bez -p spadne)
rm -r adresar       # rekurzivně
rm -f soubor        # bez dotazů, neexistující nehlásí
cp -r zdroj/ cil/   # rekurzivní kopie
mv stary novy       # přesun i přejmenování (totéž)
```

**Struktura systému** — na to se ptají:

| Adresář | Co v něm je |
|---|---|
| `/` | korenový adresář, vše ostatní je pod ním |
| `/home` | domovské adresáře uživatelů |
| `/etc` | **konfigurační soubory** systému |
| `/var` | proměnná data — logy (`/var/log`), fronty |
| `/tmp` | temporary, maže se při restartu |
| `/usr/bin`, `/bin` | spustitelné programy |
| `/dev` | zařízení jako soubory (`/dev/null`, `/dev/sda`) |
| `/proc` | virtuální FS s informacemi o procesech |
| `/mnt`, `/media` | přípojné body pro další disky |

**Absolutní vs. relativní cesta:** absolutní začíná `/` (`/home/valdemar/soubor`), relativní od aktuálního adresáře (`../soubor`, `./skript.sh`). Ve skriptech preferuj absolutní nebo si na začátku ověř, kde jsi.

#### `find` — nejdůležitější nástroj okruhu

```bash
find /cesta -type f                     # jen soubory (d = adresáře)
find . -name "*.jpg"                    # podle jména, ROZLIŠUJE velikost písmen
find . -iname "*.jpg"                   # NEROZLIŠUJE — najde i .JPG a .Jpg
find . -type f -size +1M                # větší než 1 MB (-1M = menší)
find . -type f -mtime -7                # změněné za posledních 7 dní
find . -maxdepth 1 -type f              # jen v tomhle adresáři, ne v podadresářích
find . -type f -empty                   # prázdné soubory
find . -type f -print0                  # oddělovač je NULOVÝ BAJT, ne nový řádek
```

**Kombinace podmínek** — pozor na závorky, musí se escapovat:

```bash
find . -type f \( -iname "*.jpg" -o -iname "*.png" \)      # jpg NEBO png
find . -type f -iname "*.log" ! -path "*/cache/*"          # ! je negace
```

**Konkrétně:** v adresáři s 8 soubory (3 jpg, 1 png, 1 bmp, 1 PNG, 2 ostatní) vrátí `find . -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.bmp" \)` **šest** souborů — včetně `.PNG` velkými písmeny, právě protože je tam `-iname`.

**`-exec` vs. kolona:**

```bash
find . -name "*.tmp" -exec rm {} \;      # spustí rm pro KAŽDÝ soubor zvlášť (pomalé)
find . -name "*.tmp" -exec rm {} +       # spustí rm s VÍC soubory naráz (rychlé)
find . -name "*.tmp" -delete             # ještě lepší, když find umí danou akci
```

#### Past číslo jedna: mezery v názvech

**Tohle je nejdůležitější odstavec celého okruhu.** Ukážu to na reálném příkladu.

Naivní skript:

```bash
for f in $(find testdata -name "*.jpg"); do
    echo "$f,$(stat -c%s $f)"
done
```

Na souboru `podadresar/foto s mezerou.jpg` udělá tohle:

```
stat: nelze získat informace o 'testdata/podadresar/foto' ...
testdata/podadresar/foto,
stat: nelze získat informace o 's' ...
s,
stat: nelze získat informace o 'mezerou.jpg' ...
mezerou.jpg,
```

**Jeden soubor se rozpadl na tři neexistující.** Důvod: `$(find ...)` vrátí jeden dlouhý řetězec a bash ho rozdělí podle mezer (word splitting).

**Správně** — nulový bajt jako oddělovač, protože ten se v názvu souboru vyskytovat nemůže:

```bash
while IFS= read -r -d '' soubor; do
    velikost=$(stat -c%s -- "$soubor")
    printf '%s,%s\n' "$soubor" "$velikost"
done < <(find testdata -type f -iname "*.jpg" -print0)
```

Rozbor těch přepínačů:

| Část | Co dělá |
|---|---|
| `-print0` | find oddělí výstupy **nulovým bajtem** místo novým řádkem |
| `IFS=` | vypne dělení podle mezer pro tenhle příkaz |
| `read -r` | **nezpracovává zpětná lomítka** jako escape sekvence |
| `read -d ''` | čte až k nulovému bajtu |
| `"$soubor"` | uvozovky zabrání dělení při použití |
| `--` | ukončí přepínače — kdyby soubor začínal `-`, nebral by se jako přepínač |
| `< <(...)` | **process substitution** — cyklus běží v hlavním shellu, takže si počítadla pamatuje |

**Ta poslední položka je zrádná.** Kdybys napsal `find ... | while read ...`, cyklus poběží v podshellu a **proměnné z něj se ztratí**:

```bash
# ŠPATNĚ — pocet zůstane 0
pocet=0
find . -type f -print0 | while IFS= read -r -d '' f; do
    pocet=$((pocet + 1))
done
echo "$pocet"        # 0 !

# SPRÁVNĚ
pocet=0
while IFS= read -r -d '' f; do
    pocet=$((pocet + 1))
done < <(find . -type f -print0)
echo "$pocet"        # správný počet
```

#### Velikost a metadata

```bash
stat -c%s soubor         # velikost v bajtech (jen číslo)
stat -c%y soubor         # čas poslední změny
stat soubor              # vše podrobně

du -sh adresar           # součet velikosti adresáře, čitelně
du -sh * | sort -h       # velikosti položek setříděné (-h = human readable číselně)
df -h                    # volné místo na discích

wc -c < soubor           # velikost přes wc (méně obvyklé)
numfmt --to=iec-i --suffix=B 39236    # 39KiB — převod na čitelný formát
```

**`stat -c%s` vs. `du`:** `stat` dá **logickou velikost** (kolik dat), `du` dá **obsazené místo na disku** (zaokrouhlené na bloky). U malých souborů se to liší — soubor s 100 B zabere na disku 4 kB.

#### Textové nástroje a kolony

**Kolona** (pipe, `|`) posílá výstup jednoho příkazu na vstup dalšího. Čte se zleva doprava jako výrobní linka:

```bash
cat /etc/passwd | cut -d: -f1 | sort | head -5
#   ^vypiš        ^první pole  ^seřaď  ^prvních 5
```

**`grep`** — filtruje řádky:

```bash
grep "vzor" soubor           # řádky obsahující vzor
grep -i "vzor" soubor        # bez ohledu na velikost písmen
grep -v "vzor" soubor        # řádky NEobsahující (obrácený výběr)
grep -c "vzor" soubor        # jen počet nalezených řádků
grep -r "vzor" /cesta        # rekurzivně v adresáři
grep -n "vzor" soubor        # s čísly řádků
grep -E "a|b" soubor         # rozšířené regulární výrazy
```

**`cut`** — vybírá sloupce:

```bash
cut -d, -f2 data.csv         # druhý sloupec, oddělovač čárka
cut -d: -f1,3 /etc/passwd    # první a třetí
cut -c1-10 soubor            # znaky 1 až 10
```

**`sort`** — nejčastější past je řazení čísel:

```bash
sort soubor                  # abecedně (POZOR: "10" < "9" !)
sort -n soubor               # číselně — takhle správně
sort -r soubor               # obráceně
sort -u soubor               # a odstranit duplicity
sort -t, -k2 -n data.csv     # podle 2. sloupce CSV, číselně
sort -h                      # čitelné velikosti (1K, 2M) správně
```

**Konkrétně** ta past: `printf "9\n10\n" | sort` dá `10, 9` (abecedně, protože „1" < „9"), zatímco `sort -n` dá správně `9, 10`.

**`tr`** — záměna nebo mazání znaků:

```bash
tr ' ' '_'                   # mezery na podtržítka
tr 'a-z' 'A-Z'               # na velká písmena
tr -d '\r'                   # smazat CR (windowsové konce řádků)
tr -s ' '                    # sloučit opakované mezery do jedné
```

**`wc`, `head`, `tail`, `uniq`:**

```bash
wc -l soubor                 # počet řádků
head -20 soubor              # prvních 20 řádků
tail -20 soubor              # posledních 20
tail -f /var/log/syslog      # sleduje nové řádky (Ctrl+C ukončí)
sort soubor | uniq -c         # počet výskytů (uniq POTŘEBUJE setříděný vstup!)
sort soubor | uniq -d         # jen duplicity
```

**`uniq` funguje jen na setříděném vstupu** — porovnává vždy jen se sousedním řádkem. Proto ta kombinace `sort | uniq -c`.

#### `awk` a `sed`, když kolona nestačí

**`awk`** je nejužitečnější na počítání se sloupci:

```bash
awk -F, '{soucet += $2} END {print soucet}' data.csv   # součet 2. sloupce
awk -F, '$2 > 1000' data.csv                           # řádky, kde je 2. sloupec > 1000
awk -F, '{print $1}' data.csv                          # jako cut, ale flexibilnější
awk 'NR > 1' data.csv                                  # přeskočit hlavičku
awk -F, '{print NF}' data.csv                          # počet polí na řádku
```

**`sed`** na náhrady v textu:

```bash
sed 's/staré/nové/' soubor       # první výskyt na každém řádku
sed 's/staré/nové/g' soubor      # všechny výskyty
sed -i 's/a/b/g' soubor          # zapíše PŘÍMO do souboru (pozor!)
sed -n '5,10p' soubor            # vypíše jen řádky 5–10
sed '1d' soubor                  # smaže první řádek (hlavičku)
```

**U zkoušky si vystač s `awk` na součty a `sed` na náhrady** — na víc není čas a `man` je po ruce.

#### Proměnné a parametry

```bash
jmeno="Valdemar"          # ŽÁDNÉ mezery kolem = !
pocet=0
echo "$jmeno"             # vždy do uvozovek
echo "${jmeno}_suffix"    # složené závorky, když navazuje text

vysledek=$(prikaz)        # výstup příkazu do proměnné
soubory=$(ls | wc -l)
```

**Parametry skriptu:**

| Zápis | Význam |
|---|---|
| `$0` | jméno skriptu |
| `$1`, `$2`, … | první, druhý parametr |
| `$#` | **počet** parametrů |
| `"$@"` | **všechny parametry, každý zvlášť** (správné) |
| `"$*"` | všechny jako jeden řetězec |
| `shift` | zahodí `$1` a posune ostatní (`shift 2` zahodí dva) |

**`"$@"` vs. `"$*"`** je klasická doptávka: `"$@"` zachová dělení na jednotlivé argumenty (i s mezerami), `"$*"` je slepí do jednoho. **Skoro vždy chceš `"$@"`.**

**`shift` se hodí u variabilního počtu argumentů** — přesně jako v ukázkové úloze, kde jsou první dva parametry adresář a výstup a zbytek jsou přípony:

```bash
adresar="$1"
vystup="$2"
shift 2              # teď "$@" obsahuje jen přípony
for pripona in "$@"; do
    echo "$pripona"
done
```

#### Podmínky

```bash
if [ -d "$adresar" ]; then
    echo "je adresář"
elif [ -f "$adresar" ]; then
    echo "je soubor"
else
    echo "neexistuje"
fi
```

**Testy, které potřebuješ:**

| Test | Platí, když |
|---|---|
| `-d cesta` | je **adresář** |
| `-f cesta` | je **běžný soubor** |
| `-e cesta` | **existuje** (cokoli) |
| `-r`, `-w`, `-x` | je čitelný / zapisovatelný / spustitelný |
| `-s cesta` | existuje a je **neprázdný** |
| `-z "$s"` | řetězec je **prázdný** |
| `-n "$s"` | řetězec je **neprázdný** |
| `"$a" = "$b"` | řetězce se rovnají |
| `"$a" != "$b"` | nerovnají |
| `$a -eq $b` | čísla se rovnají (`-ne`, `-lt`, `-le`, `-gt`, `-ge`) |

**Pozor na rozdíl:** `=` pro řetězce, `-eq` pro čísla. `[ "10" = "10.0" ]` je nepravda, `[ 10 -eq 10 ]` je pravda.

**Mezery uvnitř `[ ]` jsou povinné** — `[` je totiž příkaz, ne syntaxe. `[-d "$x"]` je chyba.

```bash
[ "$#" -lt 3 ] && { echo "málo parametrů" >&2; exit 1; }    # zkratka
```

**`case`** na víc variant:

```bash
case "$1" in
    *.jpg|*.jpeg) echo "JPEG" ;;
    *.png)        echo "PNG" ;;
    *)            echo "něco jiného" ;;
esac
```

#### Cykly

```bash
# přes hodnoty
for x in a b c; do echo "$x"; done

# přes soubory (glob) — TENTO tvar mezery zvládá
for f in *.jpg; do echo "$f"; done

# číselný
for i in {1..5}; do echo "$i"; done
for ((i=0; i<5; i++)); do echo "$i"; done

# while s podmínkou
i=0
while [ "$i" -lt 5 ]; do
    echo "$i"
    i=$((i + 1))
done

# čtení souboru po řádcích
while IFS= read -r radek; do
    echo "řádek: $radek"
done < soubor.txt
```

**`for f in *.jpg` mezery zvládá** (glob expanduje na jednotlivá jména), ale **nefunguje rekurzivně** a když nic nenajde, projde jednou s literálem `*.jpg`. Proto se u rekurzivního hledání používá `find -print0`.

#### Aritmetika

```bash
pocet=$((pocet + 1))
soucet=$((a * b + c))
prumer=$((celkem / pocet))       # CELOČÍSELNÉ dělení, zbytek se zahodí!
zbytek=$((celkem % pocet))
```

**Bash umí jen celá čísla.** `$((10 / 3))` dá `3`, ne `3.33`. Na desetinná čísla potřebuješ `bc` nebo `awk`:

```bash
echo "scale=2; 10 / 3" | bc      # 3.33
awk "BEGIN {printf \"%.2f\", 10/3}"    # 3.33
```

#### Návratové kódy

**Každý příkaz vrací kód: `0` znamená úspěch, cokoli jiného chybu.**

```bash
grep "vzor" soubor
if [ "$?" -eq 0 ]; then echo "nalezeno"; fi

# nebo přímo
if grep -q "vzor" soubor; then echo "nalezeno"; fi     # -q = tiše

prikaz1 && prikaz2      # prikaz2 jen když prikaz1 uspěl
prikaz1 || prikaz2      # prikaz2 jen když prikaz1 selhal
prikaz1 ; prikaz2       # oba bez ohledu na výsledek

exit 0                  # ukončit skript úspěchem
exit 1                  # ukončit chybou
```

**Užitečné nastavení na začátek skriptu:**

```bash
set -e          # skončit při první chybě
set -u          # pád při použití nenastavené proměnné (chytá překlepy!)
set -o pipefail # kolona selže, když selže kterýkoli člen, ne jen poslední
set -euo pipefail   # všechno naráz
```

**`set -u` doporučuju vždycky** — odhalí překlep v názvu proměnné, který by jinak tiše expandoval na prázdno.

**Chybové výpisy patří na `stderr`:**

```bash
echo "Chyba: soubor neexistuje" >&2      # >&2 přesměruje na standardní chybový výstup
```

Tím se nemíchají s užitečným výstupem, když někdo skript použije v koloně.

#### Práva

```bash
ls -l soubor
# -rw-r--r-- 1 valdemar valdemar 1234 Sep  8 10:00 soubor
#  ^^^ ^^^ ^^^
#  vlastník skupina ostatní
```

| Zápis | Číselně | Význam |
|---|---|---|
| `r` | 4 | čtení |
| `w` | 2 | zápis |
| `x` | 1 | spuštění (u adresáře: vstup do něj) |

**Sečti pro každou trojici:**

| Práva | Číslo | Kdo co může | Typicky |
|---|---|---|---|
| `rwxr-xr-x` | **755** | vlastník vše, ostatní čtení+spuštění | **skripty, adresáře** |
| `rw-r--r--` | **644** | vlastník čte+píše, ostatní jen čtou | **běžné soubory** |
| `rwx------` | 700 | jen vlastník | privátní |
| `rw-------` | 600 | jen vlastník, bez spuštění | SSH klíče, hesla |
| `rwxrwxrwx` | 777 | **kdokoli cokoli** | nikdy nepoužívat |

```bash
chmod 755 skript.sh          # číselně
chmod +x skript.sh           # symbolicky — přidat spustitelnost
chmod u+w,go-w soubor        # u=vlastník, g=skupina, o=ostatní, a=všichni
chown uzivatel:skupina soubor
```

**Proč 755 u skriptu a 644 u dat:** skript musí být **spustitelný** (`x`), datový soubor nemá důvod. `777` je bezpečnostní chyba — kdokoli může přepsat obsah.

**U adresáře znamená `x` právo do něj vstoupit** (a `r` právo vypsat obsah). Adresář s `r--` můžeš vypsat, ale nedostaneš se do souborů v něm.

#### Procesy

```bash
ps aux                  # všechny procesy, podrobně
ps aux | grep firefox   # najít konkrétní
top, htop               # interaktivně, průběžně
pgrep -l firefox        # jen PID a jméno

kill 1234               # slušně ukončit (signál TERM, proces může uklidit)
kill -9 1234            # NÁSILNĚ (KILL, nedá se ignorovat) — až když TERM nezabere
pkill firefox           # podle jména

prikaz &                # spustit na pozadí
jobs                    # seznam úloh na pozadí
fg %1                   # vrátit do popředí
nohup prikaz &          # běží dál i po odhlášení
```

**Rozdíl `kill` a `kill -9`** (častá doptávka): `kill` pošle `SIGTERM`, který proces může **odchytit a uklidit po sobě** (zavřít soubory, uložit stav). `kill -9` pošle `SIGKILL`, který jádro provede okamžitě — proces nemá šanci reagovat, což může nechat rozbitá data. **Vždycky zkus nejdřív `kill`.**

---

### Postup u zkoušky (60 min přípravy)

**0–5 min — rozbor zadání**

1. **Rozděl na minimální a rozšiřující požadavky.** Minimální udělej první — je to to, co musí fungovat.
2. **Vypiš si formát volání** (`hledej ADRESÁŘ VÝSTUP.csv bmp png jpg`) a z něj poznáš, co jsou parametry.
3. Podívej se na **testovací data** — jsou tam mezery v názvech? diakritika? velká písmena v příponách? (Skoro jistě ano, je to schválně.)

**5–15 min — kostra skriptu**

4. Shebang, `set -u`, kontrola parametrů. **Tohle napiš vždycky první**, i než začneš řešit logiku.
5. Vytvoř soubor, dej mu `chmod +x`, zkus spustit prázdný — ať víš, že se vůbec pouští.

**15–40 min — jádro**

6. Nejdřív **napiš samotnou kolonu na příkazové řádce** a odlaď ji. Až pak ji vlož do skriptu.
7. Testuj **průběžně po každé části** na reálných datech. Ne až na konci.
8. Používej `man`, když si nejsi jistý přepínačem — je k dispozici a nikdo to nepočítá za chybu.

**40–52 min — rozšiřující požadavky**

9. Po jednom, v pořadí ze zadání. Po každém otestuj.

**52–60 min — kontrola a úklid**

10. **Vyzkoušej hraniční případy:** prázdný adresář, neexistující adresář, žádné parametry, soubor s mezerou v názvu.
11. Přidej komentáře a nápovědu (`Použití: …`). Vypadá to profesionálně a stojí to dvě minuty.
12. Zkontroluj, že skript **nezanechává temporary soubory** (`trap 'rm -f "$tmp"' EXIT`).

**Když ti dojde čas:** funkční minimální varianta + poznámka „rozšíření 3 jsem nestihl, udělal bych to takhle" je lepší než rozdělané všechno.

---

### Rozbor ukázkové úlohy

> Napište skript pro BASH, který vytvoří **CSV soubor se seznamem všech obrázků** v daném adresáři, **včetně podadresářů**. Vstupem je adresář a **seznam přípon** považovaných za obrázky.
>
> `hledej /adresar_s_obrazky /vystupni_soubor.csv bmp png jpg`
>
> **Rozšíření:** 1. setřídění podle velikosti · 2. konzolová statistika (počet, celková velikost) · 3. kontrola parametrů

#### Co ze zadání plyne

| Z čeho | Co to znamená pro skript |
|---|---|
| „včetně podadresářů" | **`find`**, ne `ls` ani glob |
| „seznam přípon" jako parametry | **variabilní počet argumentů** → `shift 2` a pak `"$@"` |
| CSV výstup | oddělovač čárka, hodnoty s mezerami **do uvozovek** |
| „setřídění dle velikosti" | `sort -t, -k2 -n` |
| „počet a celková velikost" | počítadla v cyklu → **nesmí být v podshellu!** |
| „kontrola parametrů" | `$#`, `-d`, `-r` na začátku |

**Nejzrádnější je ta kombinace:** potřebuješ počítat (počítadla) *a* zvládnout mezery v názvech (`-print0`). To vylučuje `find | while` (podshell zabije počítadla) i `for f in $(find)` (rozbije mezery). Jediné správné řešení je **`while read -d '' < <(find -print0)`**.

#### Řešení

Celý skript je v [`Kod/hledej.sh`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/08-operacni-systemy/Kod/hledej.sh) — tady jen komentovaná kostra:

```bash
#!/usr/bin/env bash
set -u                      # pád při nenastavené proměnné

# --- kontrola parametrů (rozšíření 3) ---
if [ "$#" -lt 3 ]; then
    echo "Použití: $(basename "$0") ADRESÁŘ VÝSTUP.csv PŘÍPONA [PŘÍPONA...]" >&2
    exit 1
fi

adresar="$1"
vystup="$2"
shift 2                     # zbytek "$@" jsou přípony

[ -d "$adresar" ] || { echo "Chyba: '$adresar' není adresář" >&2; exit 2; }
[ -r "$adresar" ] || { echo "Chyba: '$adresar' není čitelný" >&2; exit 2; }

# --- sestavit podmínku pro find z libovolného počtu přípon ---
podminky=()
for pripona in "$@"; do
    podminky+=( -o -iname "*.${pripona}" )
done
podminky=( "${podminky[@]:1}" )     # zahodit úvodní -o

# --- hlavní cyklus ---
pocet=0
celkem=0
docasny=$(mktemp)
trap 'rm -f "$docasny"' EXIT        # uklidit i při Ctrl+C

while IFS= read -r -d '' soubor; do
    velikost=$(stat -c%s -- "$soubor")
    pocet=$((pocet + 1))
    celkem=$((celkem + velikost))
    printf '"%s",%s\n' "$soubor" "$velikost" >> "$docasny"
done < <(find "$adresar" -type f \( "${podminky[@]}" \) -print0)

# --- výstup: hlavička + setříděno podle velikosti (rozšíření 1) ---
{
    echo "cesta,velikost_b"
    sort -t, -k2 -n -r "$docasny"
} > "$vystup"

# --- statistika (rozšíření 2) ---
echo "Nalezeno obrázků: $pocet"
if [ "$pocet" -gt 0 ]; then
    echo "Celková velikost: $celkem B ($(numfmt --to=iec-i --suffix=B "$celkem"))"
    echo "Průměrná velikost: $((celkem / pocet)) B"
fi
echo "Výstup zapsán do: $vystup"
```

#### Ověřený výstup

Na testovacích datech (8 souborů, z toho 6 obrázků včetně jednoho s mezerou v názvu, jednoho s diakritikou a jednoho s příponou `.PNG`):

```
$ ./hledej.sh testdata vystup.csv bmp png jpg
Nalezeno obrázků: 6
Celková velikost: 39236 B (39KiB)
Průměrná velikost: 6539 B
Výstup zapsán do: vystup.csv

$ cat vystup.csv
cesta,velikost_b
"testdata/c.bmp",30000
"testdata/podadresar/skenované.jpg",4096
"testdata/podadresar/foto s mezerou.jpg",2200
"testdata/a.jpg",1500
"testdata/b.png",800
"testdata/podadresar/hloubka2/hluboko.PNG",640
```

**Všimni si, co to zvládlo:** mezeru v názvu, českou diakritiku, příponu velkými písmeny (`-iname`), rekurzi do dvou úrovní podadresářů, a správné číselné řazení sestupně.

#### Na co se u tohohle skriptu ptají

| Otázka | Odpověď |
|---|---|
| Proč `-print0` a `read -d ''`? | Nulový bajt je jediný znak, který **nemůže být v názvu souboru** — na rozdíl od mezery i nového řádku |
| Proč `< <(find)` a ne `find \| while`? | Kolona spustí cyklus v **podshellu** a počítadla `pocet`/`celkem` by se po skončení ztratila |
| Proč `mktemp` a ne rovnou do výstupu? | Aby šlo **setřídit až nakonec** a připsat hlavičku nad setříděná data |
| Proč `trap … EXIT`? | Smaže temporary soubor **i při Ctrl+C** nebo chybě, ne jen při úspěšném konci |
| Proč `--` u `stat`? | Kdyby název souboru začínal pomlčkou, `stat` by ho bral jako přepínač |
| Proč `-iname` a ne `-name`? | Aby našel i `.PNG`, `.Jpg` — uživatel nepíše přípony konzistentně |
| Proč hodnoty v CSV v uvozovkách? | Cesta může obsahovat **čárku**, která by rozbila strukturu CSV |
| Co když je adresář prázdný? | Cyklus neproběhne, `pocet` zůstane 0, CSV bude mít jen hlavičku — a statistika se **nepokusí dělit nulou** (proto ten `if`) |

---

### Příklady na procvičení

Skripty i zadání jsou v [`Kod/`](./Kod/). U každého si nastav 30 minut.

#### Příklad 1 — úklid starých logů

Skript `uklid.sh ADRESÁŘ DNŮ` najde v adresáři soubory `*.log` **starší než zadaný počet dní**, vypíše je s velikostí, spočítá kolik místa zaberou, a **po potvrzení** je smaže.

*Co si vyzkoušíš:* `find -mtime`, potvrzovací dotaz (`read -p`), bezpečné mazání, souhrn.

*Past:* smazat bez potvrzení, nebo použít `rm $soubory` bez uvozovek.

#### Příklad 2 — statistika přístupů z logu

Skript `analyza.sh LOGFILE` z webového logu (formát: `IP - - [datum] "GET /cesta" kód velikost`) vypíše **top 10 IP adres** podle počtu požadavků, **počet chyb 404**, a **celkový objem přenesených dat**.

*Co si vyzkoušíš:* klasickou kolonu `cut | sort | uniq -c | sort -rn | head`, `grep -c`, `awk` na součet.

*Past:* zapomenout, že `uniq -c` potřebuje **setříděný** vstup.

#### Příklad 3 — hromadné přejmenování

Skript `prejmenuj.sh ADRESÁŘ` převede jména všech souborů na **malá písmena**, **mezery na podtržítka** a odstraní **diakritiku**. Před přejmenováním vypíše, co se bude dít, a zeptá se.

*Co si vyzkoušíš:* `tr`, `iconv` na diakritiku, `mv`, kontrolu kolizí názvů.

*Past:* přejmenovat na existující jméno a přepsat cizí soubor — vždycky testuj `[ -e "$nove" ]`.

#### Příklad 4 — kontrola práv

Skript `audit.sh ADRESÁŘ` najde soubory s **nebezpečnými právy** (777, zápis pro ostatní), vypíše je s aktuálními právy a **nabídne opravu** na 644 (soubory) a 755 (adresáře).

*Co si vyzkoušíš:* `find -perm`, `stat -c%a`, `chmod`, rozlišení souboru a adresáře.

*Past:* nastavit 644 i adresářům — pak se do nich nedostaneš, protože chybí `x`.

---

### Co si nacvičit

Skripty jsou ve složce [`Kod/`](./Kod/):

Skripty jsou spustitelné, [zadání cvičení a přehled](./Kod/) je v README té složky:

| Skript | Co dělá |
|---|---|
| [`hledej.sh`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/08-operacni-systemy/Kod/hledej.sh) | **referenční řešení ukázkové úlohy z PDF** |
| [`vytvor-testdata.sh`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/08-operacni-systemy/Kod/vytvor-testdata.sh) | vygeneruje testovací adresář (mezery, diakritika, velká písmena v příponách) |
| [`01-uklid-logu.sh`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/08-operacni-systemy/Kod/priklady/01-uklid-logu.sh) | úklid starých logů s potvrzením |
| [`02-analyza-logu.sh`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/08-operacni-systemy/Kod/priklady/02-analyza-logu.sh) | statistika z webového logu |
| [`03-prejmenuj.sh`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/08-operacni-systemy/Kod/priklady/03-prejmenuj.sh) | normalizace názvů souborů |
| [`04-audit-prav.sh`](https://github.com/ValdemarPospisil/Statnice/blob/main/SZZPP/08-operacni-systemy/Kod/priklady/04-audit-prav.sh) | kontrola a oprava práv |

Rychlý start:

```bash
cd Kod
./vytvor-testdata.sh testdata
./hledej.sh testdata out.csv bmp png jpg
```

- [ ] Ukázková úloha z PDF **celá, na časovku 60 minut**, včetně všech tří rozšíření
- [ ] Aspoň dva [příklady na procvičení](#příklady-na-procvičení)
- [ ] **Zpaměti: kostra skriptu** — shebang, `set -u`, kontrola `$#`, nápověda na `>&2`
- [ ] **Zpaměti: `while IFS= read -r -d '' f; do … done < <(find … -print0)`** — tohle je nejcennější řádek celého okruhu
- [ ] Vyzkoušet, jak se naivní skript **rozsype na souboru s mezerou** (ať víš, proč to děláš)
- [ ] `find` s `-iname`, `-type`, `-size`, `-mtime`, `-perm`
- [ ] Kolona `cut | sort | uniq -c | sort -rn | head` — klasika na statistiky
- [ ] `awk -F, '{s+=$2} END{print s}'` na součet sloupce
- [ ] Práva 755 / 644 / 600 a proč zrovna ta
- [ ] `kill` vs. `kill -9` a proč v tomhle pořadí

---

### Poznámky

<!-- Sem vlastní výpisky, příkazy, útržky kódu. -->

---

### Na co se doptají

- **Proč dáváš proměnné do uvozovek?** — Bez nich bash provede **word splitting** a rozdělí hodnotu podle mezer, plus expanduje glob znaky (`*`, `?`). `$soubor` s hodnotou `foto s mezerou.jpg` se rozpadne na tři argumenty. Uvozovky to zablokují.
- **Co se stane, když má soubor v názvu mezeru nebo apostrof?** — Naivní `for f in $(find ...)` ho rozseká na části a `stat` pak hlásí, že soubory neexistují. Řešení je `find -print0` a `while IFS= read -r -d ''` — nulový bajt v názvu být nemůže.
- **Jak zjistíš návratový kód předchozího příkazu a k čemu ti je?** — `$?`, kde **0 je úspěch**. Používá se na řízení toku (`&&`, `||`), na `if grep -q`, a ve skriptu na `exit` s vlastním kódem, aby volající poznal, co se stalo.
- **Vysvětli práva 755 a 644.** — Trojice vlastník/skupina/ostatní, sečtené z `r=4, w=2, x=1`. **755** = vlastník `rwx`, ostatní `r-x` → skripty a adresáře (potřebují `x`). **644** = vlastník `rw-`, ostatní `r--` → datové soubory, ty spouštět nepotřebuješ.
- **Proč `find` a ne `ls`?** — `ls` nejde rekurzivně do podadresářů s filtrováním a jeho výstup se nemá parsovat (obsahuje formátování). `find` je na to určený a má `-print0`.
- **Jaký je rozdíl mezi `"$@"` a `"$*"`?** — `"$@"` zachová **oddělené argumenty** včetně těch s mezerami, `"$*"` je slepí do jednoho řetězce. Skoro vždy chceš `"$@"`.
- **Proč `find | while` nefunguje s počítadly?** — Kolona spustí pravou stranu v **podshellu**, což je samostatný proces. Změny proměnných v něm zmizí, jak podshell skončí. Řešení: `while … done < <(find …)`.
- **K čemu je `set -u` a `set -e`?** — `-u` způsobí pád při použití **nenastavené** proměnné (chytá překlepy v názvech). `-e` ukončí skript při první chybě. `set -euo pipefail` je bezpečné výchozí nastavení.
- **Proč `sort -n` a ne `sort`?** — Bez `-n` se řadí **abecedně**, takže „10" je před „9" (protože „1" < „9"). U velikostí souborů to dá nesmyslné výsledky.
- **Proč `uniq` potřebuje setříděný vstup?** — Porovnává vždy jen **se sousedním řádkem**, ne globálně. Neseřazené duplicity vzdálené od sebe nepozná. Proto `sort | uniq -c`.
- **Rozdíl `kill` a `kill -9`?** — `kill` posílá `SIGTERM`, který proces může **odchytit a uklidit po sobě**. `kill -9` je `SIGKILL`, provede ho jádro okamžitě a proces nemá šanci reagovat — může to nechat rozbitá data. Nejdřív vždycky `kill`.
- **Co je `trap` a proč ho používáš?** — Zachytí signál nebo ukončení skriptu a spustí úklid. `trap 'rm -f "$tmp"' EXIT` smaže temporary soubor **i při Ctrl+C nebo chybě**, ne jen při normálním konci.
- **Kde v souborovém systému hledáš konfiguraci a kde logy?** — Konfigurace v `/etc`, logy v `/var/log`. Domovské adresáře `/home`, temporary `/tmp`, programy `/usr/bin`.
- **Jak zjistíš velikost souboru ve skriptu?** — `stat -c%s soubor` (logická velikost v bajtech). `du` dá **obsazené místo na disku**, což je u malých souborů víc (zaokrouhluje na bloky).
- **Umí bash desetinná čísla?** — **Ne**, `$(( ))` je celočíselné. `$((10/3))` je `3`. Na desetinná čísla `bc` (`echo "scale=2; 10/3" | bc`) nebo `awk`.

---

### Užitečné odkazy

- Manuálové stránky máš u zkoušky: `man find`, `man bash`, `man test`
- Nápověda ke vestavěným příkazům: `help test`, `help while`
- Kontrola skriptů (nemáš u zkoušky, ale na doma): <https://www.shellcheck.net>
- Průvodce bashem: <https://tldp.org/LDP/abs/html/>
