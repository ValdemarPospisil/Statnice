#!/usr/bin/env bash
#
# analyza — statistika z webového logu
#
# Formát řádku: IP - - [datum] "GET /cesta" kód velikost
# Použití: ./02-analyza-logu.sh LOGFILE

set -u

if [ "$#" -ne 1 ]; then
    echo "Použití: $(basename "$0") LOGFILE" >&2
    exit 1
fi

log="$1"
[ -f "$log" ] || { echo "Chyba: '$log' není soubor" >&2; exit 2; }
[ -r "$log" ] || { echo "Chyba: '$log' není čitelný" >&2; exit 2; }
[ -s "$log" ] || { echo "Chyba: '$log' je prázdný" >&2; exit 2; }

echo "=== Analýza $log ==="
echo
echo "Celkem požadavků: $(wc -l < "$log")"
echo

echo "TOP 10 IP adres podle počtu požadavků:"
# cut vytáhne 1. pole (IP), sort seskupí, uniq -c spočítá,
# sort -rn setřídí podle počtu sestupně
cut -d' ' -f1 "$log" | sort | uniq -c | sort -rn | head -10 \
    | while read -r pocet ip; do
        printf '  %5s x  %s\n' "$pocet" "$ip"
      done
echo

pocet404=$(grep -c ' 404 ' "$log" || true)
echo "Chyb 404: $pocet404"

if [ "$pocet404" -gt 0 ]; then
    echo "Nejčastěji chybějící cesty:"
    grep ' 404 ' "$log" | cut -d'"' -f2 | sort | uniq -c | sort -rn | head -5 \
        | while read -r pocet cesta; do
            printf '  %5s x  %s\n' "$pocet" "$cesta"
          done
fi
echo

# poslední pole je velikost -> součet přes awk
celkem=$(awk '{soucet += $NF} END {print soucet+0}' "$log")
echo "Přeneseno celkem: $celkem B ($(numfmt --to=iec-i --suffix=B "$celkem"))"

# průměr přes awk, protože bash neumí desetinná čísla
awk '{s += $NF; n++} END {if (n) printf "Průměrná velikost: %.1f B\n", s/n}' "$log"
