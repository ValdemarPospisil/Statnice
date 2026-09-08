#!/usr/bin/env bash
#
# uklid — najde staré logy, ukáže je a po potvrzení smaže
#
# Použití: ./01-uklid-logu.sh ADRESÁŘ DNŮ
# Příklad: ./01-uklid-logu.sh /var/log 30

set -u

if [ "$#" -ne 2 ]; then
    echo "Použití: $(basename "$0") ADRESÁŘ DNŮ" >&2
    exit 1
fi

adresar="$1"
dnu="$2"

[ -d "$adresar" ] || { echo "Chyba: '$adresar' není adresář" >&2; exit 2; }

# dnu musí být kladné celé číslo
case "$dnu" in
    ''|*[!0-9]*) echo "Chyba: '$dnu' není celé číslo" >&2; exit 2 ;;
esac

# --- najít a vypsat kandidáty -------------------------------------------
nalezene=()
celkem=0

while IFS= read -r -d '' soubor; do
    velikost=$(stat -c%s -- "$soubor")
    nalezene+=( "$soubor" )
    celkem=$((celkem + velikost))
    printf '  %10s B  %s\n' "$velikost" "$soubor"
done < <(find "$adresar" -type f -name "*.log" -mtime "+$dnu" -print0)

pocet="${#nalezene[@]}"

if [ "$pocet" -eq 0 ]; then
    echo "Žádné logy starší než $dnu dní nenalezeny."
    exit 0
fi

echo
echo "Nalezeno $pocet souborů, celkem $celkem B ($(numfmt --to=iec-i --suffix=B "$celkem"))"

# --- potvrzení PŘED mazáním ---------------------------------------------
printf "Smazat? [a/N] "
read -r odpoved
case "$odpoved" in
    [aAyY])
        for soubor in "${nalezene[@]}"; do
            rm -- "$soubor" && echo "smazáno: $soubor"
        done
        echo "Uvolněno $celkem B."
        ;;
    *)
        echo "Zrušeno, nic se nesmazalo."
        ;;
esac
