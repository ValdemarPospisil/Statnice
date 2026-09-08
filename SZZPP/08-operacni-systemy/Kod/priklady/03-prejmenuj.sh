#!/usr/bin/env bash
#
# prejmenuj — normalizuje názvy souborů: malá písmena, podtržítka, bez diakritiky
#
# Použití: ./03-prejmenuj.sh ADRESÁŘ

set -u

if [ "$#" -ne 1 ]; then
    echo "Použití: $(basename "$0") ADRESÁŘ" >&2
    exit 1
fi

adresar="$1"
[ -d "$adresar" ] || { echo "Chyba: '$adresar' není adresář" >&2; exit 2; }

# --- naplánovat přejmenování (nic se zatím nemění) ----------------------
zdroje=()
cile=()
kolize=0

while IFS= read -r -d '' cesta; do
    slozka=$(dirname -- "$cesta")
    jmeno=$(basename -- "$cesta")

    # diakritika -> ASCII, malá písmena, mezery -> podtržítka
    nove=$(printf '%s' "$jmeno" \
        | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null \
        | tr '[:upper:]' '[:lower:]' \
        | tr ' ' '_' \
        | tr -s '_')

    [ "$jmeno" = "$nove" ] && continue          # není co měnit

    if [ -e "$slozka/$nove" ]; then
        echo "KOLIZE: '$nove' už existuje, přeskakuji '$jmeno'" >&2
        kolize=$((kolize + 1))
        continue
    fi

    zdroje+=( "$cesta" )
    cile+=( "$slozka/$nove" )
    printf '  %s\n     -> %s\n' "$jmeno" "$nove"
done < <(find "$adresar" -type f -print0)

pocet="${#zdroje[@]}"

if [ "$pocet" -eq 0 ]; then
    echo "Nic k přejmenování (kolizí: $kolize)."
    exit 0
fi

echo
echo "K přejmenování: $pocet souborů, kolizí přeskočeno: $kolize"
printf "Provést? [a/N] "
read -r odpoved

case "$odpoved" in
    [aAyY])
        i=0
        while [ "$i" -lt "$pocet" ]; do
            mv -n -- "${zdroje[i]}" "${cile[i]}" && echo "OK: ${cile[i]}"
            i=$((i + 1))
        done
        ;;
    *)
        echo "Zrušeno."
        ;;
esac
