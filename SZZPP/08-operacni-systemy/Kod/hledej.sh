#!/usr/bin/env bash
#
# hledej — vytvoří CSV se seznamem obrázků v adresáři včetně podadresářů
#
# Použití: ./hledej.sh ADRESÁŘ VÝSTUP.csv PŘÍPONA [PŘÍPONA...]
# Příklad: ./hledej.sh /adresar_s_obrazky /vystup.csv bmp png jpg

set -u                      # pád při použití nenastavené proměnné

# --- 1) kontrola parametrů -------------------------------------------------
if [ "$#" -lt 3 ]; then
    echo "Použití: $(basename "$0") ADRESÁŘ VÝSTUP.csv PŘÍPONA [PŘÍPONA...]" >&2
    exit 1
fi

adresar="$1"
vystup="$2"
shift 2                     # zbytek $@ jsou přípony

if [ ! -d "$adresar" ]; then
    echo "Chyba: '$adresar' není adresář" >&2
    exit 2
fi
if [ ! -r "$adresar" ]; then
    echo "Chyba: adresář '$adresar' není čitelný" >&2
    exit 2
fi

# --- 2) sestavení podmínky pro find ---------------------------------------
# Z přípon: -iname "*.bmp" -o -iname "*.png" -o ...
podminky=()
for pripona in "$@"; do
    podminky+=( -o -iname "*.${pripona}" )
done
podminky=( "${podminky[@]:1}" )     # zahodit první -o

# --- 3) hlavní kolona -----------------------------------------------------
pocet=0
celkem=0
docasny=$(mktemp)
trap 'rm -f "$docasny"' EXIT        # uklidit i při přerušení

while IFS= read -r -d '' soubor; do
    velikost=$(stat -c%s -- "$soubor")
    pocet=$((pocet + 1))
    celkem=$((celkem + velikost))
    printf '%s,%s\n' "\"$soubor\"" "$velikost" >> "$docasny"
done < <(find "$adresar" -type f \( "${podminky[@]}" \) -print0)

# --- 4) výstup: hlavička + setříděno podle velikosti ----------------------
{
    echo "cesta,velikost_b"
    sort -t, -k2 -n -r "$docasny"
} > "$vystup"

# --- 5) statistika na konzoli ---------------------------------------------
echo "Nalezeno obrázků: $pocet"
if [ "$pocet" -gt 0 ]; then
    echo "Celková velikost: $celkem B ($(numfmt --to=iec-i --suffix=B "$celkem"))"
    echo "Průměrná velikost: $((celkem / pocet)) B"
fi
echo "Výstup zapsán do: $vystup"
