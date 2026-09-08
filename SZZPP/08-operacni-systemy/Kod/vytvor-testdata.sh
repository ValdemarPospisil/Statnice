#!/usr/bin/env bash
#
# vytvor-testdata — vygeneruje testovací adresář pro cvičení
#
# Záměrně obsahuje: mezery v názvech, českou diakritiku, velká písmena
# v příponách, vnořené podadresáře a soubory, které se hledat NEMAJÍ.
# Přesně to, na čem naivní skripty padají.

set -eu

cil="${1:-testdata}"

if [ -e "$cil" ]; then
    printf "Adresář '%s' už existuje. Smazat a vytvořit znovu? [a/N] " "$cil"
    read -r odpoved
    case "$odpoved" in
        [aAyY]) rm -rf -- "$cil" ;;
        *) echo "Ponecháno."; exit 0 ;;
    esac
fi

mkdir -p "$cil/podadresar/hloubka2" "$cil/logy" "$cil/prazdny"

# obrázky různých velikostí (obsah je jen výplň, na velikosti záleží)
vytvor() { head -c "$2" /dev/zero | tr '\0' 'x' > "$1"; }

vytvor "$cil/a.jpg"                            1500
vytvor "$cil/b.png"                             800
vytvor "$cil/c.bmp"                           30000
vytvor "$cil/podadresar/foto s mezerou.jpg"    2200
vytvor "$cil/podadresar/skenované.jpg"         4096
vytvor "$cil/podadresar/hloubka2/hluboko.PNG"   640

# soubory, které se hledat NEMAJÍ
vytvor "$cil/dokument.txt"                      100
vytvor "$cil/nic.pdf"                            50

# logy pro příklad 2 a 4 (různě staré)
for i in 1 2 3; do
    vytvor "$cil/logy/app$i.log" $((i * 5000))
done
touch -d "40 days ago" "$cil/logy/app1.log"
touch -d "10 days ago" "$cil/logy/app2.log"

# webový log pro příklad s analýzou
cat > "$cil/logy/access.log" <<'LOG'
192.168.1.10 - - [08/Sep/2026:10:00:01] "GET /index.html" 200 5120
192.168.1.10 - - [08/Sep/2026:10:00:05] "GET /style.css" 200 2048
10.0.0.5 - - [08/Sep/2026:10:01:00] "GET /neexistuje" 404 512
192.168.1.10 - - [08/Sep/2026:10:01:30] "GET /obrazek.png" 200 40960
172.16.0.1 - - [08/Sep/2026:10:02:00] "GET /index.html" 200 5120
10.0.0.5 - - [08/Sep/2026:10:02:15] "GET /chybi.jpg" 404 512
192.168.1.10 - - [08/Sep/2026:10:03:00] "GET /data.json" 200 1024
172.16.0.1 - - [08/Sep/2026:10:03:30] "GET /style.css" 200 2048
10.0.0.5 - - [08/Sep/2026:10:04:00] "GET /uplne-chybi" 404 512
192.168.1.10 - - [08/Sep/2026:10:05:00] "GET /video.mp4" 200 1048576
LOG

# soubor s nebezpečnými právy pro příklad 4
vytvor "$cil/verejny.txt" 200
chmod 777 "$cil/verejny.txt"

echo "Testovací data vytvořena v '$cil':"
find "$cil" -type f | sort
