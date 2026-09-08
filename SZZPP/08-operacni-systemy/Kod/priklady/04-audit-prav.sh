#!/usr/bin/env bash
#
# audit — najde soubory s nebezpečnými právy a nabídne opravu
#
# Nebezpečné = zápis pro ostatní (o+w), typicky 777 nebo 666.
# Použití: ./04-audit-prav.sh ADRESÁŘ

set -u

if [ "$#" -ne 1 ]; then
    echo "Použití: $(basename "$0") ADRESÁŘ" >&2
    exit 1
fi

adresar="$1"
[ -d "$adresar" ] || { echo "Chyba: '$adresar' není adresář" >&2; exit 2; }

soubory=()
adresare=()

echo "=== Soubory se zápisem pro ostatní (o+w) ==="

while IFS= read -r -d '' cesta; do
    prava=$(stat -c%a -- "$cesta")
    if [ -d "$cesta" ]; then
        typ="adresář"
        adresare+=( "$cesta" )
    else
        typ="soubor "
        soubory+=( "$cesta" )
    fi
    printf '  %-8s %4s  %s\n' "$typ" "$prava" "$cesta"
done < <(find "$adresar" -perm -o+w -print0)

pocetS="${#soubory[@]}"
pocetA="${#adresare[@]}"

if [ "$((pocetS + pocetA))" -eq 0 ]; then
    echo "  (nic nenalezeno — práva jsou v pořádku)"
    exit 0
fi

echo
echo "Nalezeno: $pocetS souborů, $pocetA adresářů"
echo "Návrh: soubory -> 644, adresáře -> 755"
echo "(adresáře MUSÍ mít x, jinak se do nich nedostaneš)"
printf "Opravit? [a/N] "
read -r odpoved

case "$odpoved" in
    [aAyY])
        for f in "${soubory[@]:-}"; do
            [ -n "$f" ] && chmod 644 -- "$f" && echo "644: $f"
        done
        for d in "${adresare[@]:-}"; do
            [ -n "$d" ] && chmod 755 -- "$d" && echo "755: $d"
        done
        ;;
    *)
        echo "Zrušeno."
        ;;
esac
